Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3AEEsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 23:48:35 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:44165 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab3AEEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 23:48:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130102104421.GC22160@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
	<1356456367-14660-1-git-send-email-handai.szj@taobao.com>
	<20130102104421.GC22160@dhcp22.suse.cz>
Date: Sat, 5 Jan 2013 12:48:00 +0800
Message-ID: <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
From: Sha Zhengju <handai.szj@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com,
        fengguang.wu@intel.com, glommer@parallels.com, dchinner@redhat.com,
        Sha Zhengju <handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 6:44 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Wed 26-12-12 01:26:07, Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> This patch adds memcg routines to count dirty pages, which allows memory controller
>> to maintain an accurate view of the amount of its dirty memory and can provide some
>> info for users while cgroup's direct reclaim is working.
>
> I guess you meant targeted resp. (hard/soft) limit reclaim here,
> right? It is true that this is direct reclaim but it is not clear to me

Yes, I meant memcg hard/soft reclaim here which is triggered directly
by allocation and is distinct from background kswapd reclaim (global).

> why the usefulnes should be limitted to the reclaim for users. I would
> understand this if the users was in fact in-kernel users.
>

One of the reasons I'm trying to accounting the dirty pages is to get a
more board overall view of memory usages because memcg hard/soft
reclaim may have effect on response time of user application.
Yeah, the beneficiary can be application administrator or kernel users.  :P

> [...]
>> To prevent AB/BA deadlock mentioned by Greg Thelen in previous version
>> (https://lkml.org/lkml/2012/7/30/227), we adjust the lock order:
>> ->private_lock --> mapping->tree_lock --> memcg->move_lock.
>> So we need to make mapping->tree_lock ahead of TestSetPageDirty in __set_page_dirty()
>> and __set_page_dirty_nobuffers(). But in order to avoiding useless spinlock contention,
>> a prepare PageDirty() checking is added.
>
> But there is another AA deadlock here I believe.
> page_remove_rmap
>   mem_cgroup_begin_update_page_stat             <<< 1
>   set_page_dirty
>     __set_page_dirty_buffers
>       __set_page_dirty
>         mem_cgroup_begin_update_page_stat       <<< 2
>           move_lock_mem_cgroup
>             spin_lock_irqsave(&memcg->move_lock, *flags);
>
> mem_cgroup_begin_update_page_stat is not recursive wrt. locking AFAICS
> because we might race with the moving charges:
>         CPU0                                            CPU1
> page_remove_rmap
>                                                 mem_cgroup_can_attach
>   mem_cgroup_begin_update_page_stat (1)
>     rcu_read_lock
>                                                   mem_cgroup_start_move
>                                                     atomic_inc(&memcg_moving)
>                                                     atomic_inc(&memcg->moving_account)
>                                                     synchronize_rcu
>     __mem_cgroup_begin_update_page_stat
>       mem_cgroup_stolen <<< TRUE
>       move_lock_mem_cgroup
>   [...]
>         mem_cgroup_begin_update_page_stat (2)
>           __mem_cgroup_begin_update_page_stat
>             mem_cgroup_stolen     <<< still TRUE
>             move_lock_mem_cgroup  <<< DEADLOCK
>   [...]
>   mem_cgroup_end_update_page_stat
>     rcu_unlock
>                                                   # wake up from synchronize_rcu
>                                                 [...]
>                                                 mem_cgroup_move_task
>                                                   mem_cgroup_move_charge
>                                                     walk_page_range
>                                                       mem_cgroup_move_account
>                                                         move_lock_mem_cgroup
>
>
> Maybe I have missed some other locking which would prevent this from
> happening but the locking relations are really complicated in this area
> so if mem_cgroup_{begin,end}_update_page_stat might be called
> recursively then we need a fat comment which justifies that.
>

Ohhh...good catching!  I didn't notice there is a recursive call of
mem_cgroup_{begin,end}_update_page_stat in page_remove_rmap().
The mem_cgroup_{begin,end}_update_page_stat() design has depressed
me a lot recently as the lock granularity is a little bigger than I thought.
Not only the resource but also some code logic is in the range of locking
which may be deadlock prone. The problem still exists if we are trying to
add stat account of other memcg page later, may I make bold to suggest
that we dig into the lock again...

But with regard to the current lock implementation, I doubt if we can we can
account MEM_CGROUP_STAT_FILE_{MAPPED, DIRTY} in one breath and just
try to get move_lock once in the beginning. IMHO we can make
mem_cgroup_{begin,end}_update_page_stat() to recursive aware and what I'm
thinking now is changing memcg->move_lock to rw-spinlock from the
original spinlock:
mem_cgroup_{begin,end}_update_page_stat() try to get the read lock which make it
reenterable and memcg moving task side try to get the write spinlock.
Then the race may be following:

        CPU0                                            CPU1
page_remove_rmap
                                                mem_cgroup_can_attach
  mem_cgroup_begin_update_page_stat (1)
    rcu_read_lock
                                                  mem_cgroup_start_move
                                                    atomic_inc(&memcg_moving)

atomic_inc(&memcg->moving_account)
                                                    synchronize_rcu
    __mem_cgroup_begin_update_page_stat
      mem_cgroup_stolen   <<< TRUE
      move_lock_mem_cgroup   <<<< read-spinlock success
  [...]
     mem_cgroup_begin_update_page_stat (2)
          __mem_cgroup_begin_update_page_stat
            mem_cgroup_stolen     <<< still TRUE
            move_lock_mem_cgroup  <<<< read-spinlock success

  [...]
  mem_cgroup_end_update_page_stat     <<< locked = true, unlock
    rcu_unlock
                                                  # wake up from synchronize_rcu
                                                [...]
                                                mem_cgroup_move_task
                                                  mem_cgroup_move_charge
                                                    walk_page_range
                                                      mem_cgroup_move_account

move_lock_mem_cgroup    <<< write-spinlock


AFAICS, the deadlock seems to be avoided by both the rcu and rwlock.
Is there anything I lost?


Thanks,
Sha
