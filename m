Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0DAD5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:57:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:57087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0DAD5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:57:25 -0400
Message-ID: <4BB41988.1030400@kernel.org>
Date: Thu, 01 Apr 2010 12:56:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to	destroy_workqueue()
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain> <20100331112559.GA17747@redhat.com> <4BB408AF.4080908@redhat.com>
In-Reply-To: <4BB408AF.4080908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 03:56:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On 04/01/2010 11:45 AM, Cong Wang wrote:
>> OK, but nobody should take cpu_maps_update_begin() under wq->lockdep_map,
>> in particular work->func() must not.
>>
>> I must have missed something, but it seems to me this patch tries to
>> supress the valid warning.
>>
>> Could you please clarify?
> 
> Sure, below is the whole warning. Please teach me how this is valid.

I still have some trouble interpreting lockdep warnings.  Please
correct me if I get something wrong.

> modprobe/5264 is trying to acquire lock:
>  ((bond_dev->name)){+.+...}, at: [<ffffffff8108524a>] cleanup_workqueue_thread+0x2b/0x10b
>
> but task is already holding lock:
>  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810631d1>] cpu_maps_update_begin+0x1e/0x27

This (cpu hotplug -> wq) is the expected sequence.  Plug cpu
hotplugging and then flush cpu workqueues.

> which lock already depends on the new lock.

But lockdep says the other way around has already happened.

> the existing dependency chain (in reverse order) is:
>
> -> #3 (cpu_add_remove_lock){+.+.+.}:
>        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
>        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
>        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
>        [<ffffffff815523f8>] mutex_lock_nested+0x64/0x4e9
>        [<ffffffff810631d1>] cpu_maps_update_begin+0x1e/0x27
>        [<ffffffff810853cd>] destroy_workqueue+0x41/0x107
>        [<ffffffffa0839d32>] bond_uninit+0x524/0x58a [bonding]
>        [<ffffffff8146967b>] rollback_registered_many+0x205/0x2e3
>        [<ffffffff81469783>] unregister_netdevice_many+0x2a/0x75
>        [<ffffffff8147ada3>] __rtnl_kill_links+0x8b/0x9d
>        [<ffffffff8147adea>] __rtnl_link_unregister+0x35/0x72
>        [<ffffffff8147b293>] rtnl_link_unregister+0x2c/0x43
>        [<ffffffffa0845ca6>] bonding_exit+0x5a/0x76 [bonding]
>        [<ffffffff810b7749>] sys_delete_module+0x306/0x3b1
>        [<ffffffff81003a5b>] system_call_fastpath+0x16/0x1b

This is bond_uninit() calling destroy_workqueue() but I don't get how
this thread would be already holding wq lock.

> -> #2 (rtnl_mutex){+.+.+.}:
>        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
>        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
>        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
>        [<ffffffff815523f8>] mutex_lock_nested+0x64/0x4e9
>        [<ffffffff8147af16>] rtnl_lock+0x1e/0x27
>        [<ffffffffa0836779>] bond_mii_monitor+0x39f/0x74b [bonding]
>        [<ffffffff8108654f>] worker_thread+0x2da/0x46c
>        [<ffffffff8108b1ea>] kthread+0xdd/0xec
>        [<ffffffff81004894>] kernel_thread_helper+0x4/0x10
>
> -> #1 ((&(&bond->mii_work)->work)){+.+...}:
>        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
>        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
>        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
>        [<ffffffff81086542>] worker_thread+0x2cd/0x46c
>        [<ffffffff8108b1ea>] kthread+0xdd/0xec
>        [<ffffffff81004894>] kernel_thread_helper+0x4/0x10

These two are form a workqueue worker thread and I don't quite
understand why they are here.

> -> #0 ((bond_dev->name)){+.+...}:
>        [<ffffffff810a6696>] validate_chain+0xaee/0x1540
>        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
>        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
>        [<ffffffff81085278>] cleanup_workqueue_thread+0x59/0x10b
>        [<ffffffff81085428>] destroy_workqueue+0x9c/0x107
>        [<ffffffffa0839d32>] bond_uninit+0x524/0x58a [bonding]
>        [<ffffffff8146967b>] rollback_registered_many+0x205/0x2e3
>        [<ffffffff81469783>] unregister_netdevice_many+0x2a/0x75
>        [<ffffffff8147ada3>] __rtnl_kill_links+0x8b/0x9d
>        [<ffffffff8147adea>] __rtnl_link_unregister+0x35/0x72
>        [<ffffffff8147b293>] rtnl_link_unregister+0x2c/0x43
>        [<ffffffffa0845ca6>] bonding_exit+0x5a/0x76 [bonding]
>        [<ffffffff810b7749>] sys_delete_module+0x306/0x3b1
>        [<ffffffff81003a5b>] system_call_fastpath+0x16/0x1b

This seems to be from the original thread of frame#3.  It's grabbing
wq lock here but the problem is that the lock will be released
immediately, so bond_dev->name (the wq) can't be held by the time it
reaches frame#3.  How is this dependency chain completed?  Is it
somehow transitive through rtnl_mutex?

> other info that might help us debug this:
>
> 2 locks held by modprobe/5264:
>  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8147af16>] rtnl_lock+0x1e/0x27
>  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810631d1>] cpu_maps_update_begin+0x1e/0x27

Isn't there a circular dependency here?  bonding_exit() calls
destroy_workqueue() under rtnl_mutex but destroy_workqueue() should
flush works which could be trying to grab rtnl_lock.  Or am I
completely misunderstanding locking here?

Thanks.

-- 
tejun
