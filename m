Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2KHGwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:52:04 -0500
Received: from mx2.parallels.com ([64.131.90.16]:44037 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2KHGwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:52:02 -0500
Message-ID: <509B5673.8020801@parallels.com>
Date: Thu, 8 Nov 2012 07:51:31 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v6 28/29] slub: slub-specific propagation changes.
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-29-git-send-email-glommer@parallels.com> <509A83F8.6040402@oracle.com>
In-Reply-To: <509A83F8.6040402@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.50.55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 04:53 PM, Sasha Levin wrote:
> On 11/01/2012 08:07 AM, Glauber Costa wrote:
>> SLUB allows us to tune a particular cache behavior with sysfs-based
>> tunables.  When creating a new memcg cache copy, we'd like to preserve
>> any tunables the parent cache already had.
>>
>> This can be done by tapping into the store attribute function provided
>> by the allocator. We of course don't need to mess with read-only
>> fields. Since the attributes can have multiple types and are stored
>> internally by sysfs, the best strategy is to issue a ->show() in the
>> root cache, and then ->store() in the memcg cache.
>>
>> The drawback of that, is that sysfs can allocate up to a page in
>> buffering for show(), that we are likely not to need, but also can't
>> guarantee. To avoid always allocating a page for that, we can update the
>> caches at store time with the maximum attribute size ever stored to the
>> root cache. We will then get a buffer big enough to hold it. The
>> corolary to this, is that if no stores happened, nothing will be
>> propagated.
>>
>> It can also happen that a root cache has its tunables updated during
>> normal system operation. In this case, we will propagate the change to
>> all caches that are already active.
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> CC: Christoph Lameter <cl@linux.com>
>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> CC: Michal Hocko <mhocko@suse.cz>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Johannes Weiner <hannes@cmpxchg.org>
>> CC: Suleiman Souhlal <suleiman@google.com>
>> CC: Tejun Heo <tj@kernel.org>
>> ---
> 
> Hi guys,
> 
> This patch is making lockdep angry! *bark bark*
> 
> [  351.935003] ======================================================
> [  351.937693] [ INFO: possible circular locking dependency detected ]
> [  351.939720] 3.7.0-rc4-next-20121106-sasha-00008-g353b62f #117 Tainted: G        W
> [  351.942444] -------------------------------------------------------
> [  351.943528] trinity-child13/6961 is trying to acquire lock:
> [  351.943528]  (s_active#43){++++.+}, at: [<ffffffff812f9e11>] sysfs_addrm_finish+0x31/0x60
> [  351.943528]
> [  351.943528] but task is already holding lock:
> [  351.943528]  (slab_mutex){+.+.+.}, at: [<ffffffff81228a42>] kmem_cache_destroy+0x22/0xe0
> [  351.943528]
> [  351.943528] which lock already depends on the new lock.
> [  351.943528]
> [  351.943528]
> [  351.943528] the existing dependency chain (in reverse order) is:
> [  351.943528]
> -> #1 (slab_mutex){+.+.+.}:
> [  351.960334]        [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
> [  351.960334]        [<ffffffff83a944d9>] __mutex_lock_common+0x59/0x5a0
> [  351.960334]        [<ffffffff83a94a5f>] mutex_lock_nested+0x3f/0x50
> [  351.960334]        [<ffffffff81256a6e>] slab_attr_store+0xde/0x110
> [  351.960334]        [<ffffffff812f820a>] sysfs_write_file+0xfa/0x150
> [  351.960334]        [<ffffffff8127a220>] vfs_write+0xb0/0x180
> [  351.960334]        [<ffffffff8127a540>] sys_pwrite64+0x60/0xb0
> [  351.960334]        [<ffffffff83a99298>] tracesys+0xe1/0xe6
> [  351.960334]
> -> #0 (s_active#43){++++.+}:
> [  351.960334]        [<ffffffff811825af>] __lock_acquire+0x14df/0x1ca0
> [  351.960334]        [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
> [  351.960334]        [<ffffffff812f9272>] sysfs_deactivate+0x122/0x1a0
> [  351.960334]        [<ffffffff812f9e11>] sysfs_addrm_finish+0x31/0x60
> [  351.960334]        [<ffffffff812fa369>] sysfs_remove_dir+0x89/0xd0
> [  351.960334]        [<ffffffff819e1d96>] kobject_del+0x16/0x40
> [  351.960334]        [<ffffffff8125ed40>] __kmem_cache_shutdown+0x40/0x60
> [  351.960334]        [<ffffffff81228a60>] kmem_cache_destroy+0x40/0xe0
> [  351.960334]        [<ffffffff82b21058>] mon_text_release+0x78/0xe0
> [  351.960334]        [<ffffffff8127b3b2>] __fput+0x122/0x2d0
> [  351.960334]        [<ffffffff8127b569>] ____fput+0x9/0x10
> [  351.960334]        [<ffffffff81131b4e>] task_work_run+0xbe/0x100
> [  351.960334]        [<ffffffff81110742>] do_exit+0x432/0xbd0
> [  351.960334]        [<ffffffff81110fa4>] do_group_exit+0x84/0xd0
> [  351.960334]        [<ffffffff8112431d>] get_signal_to_deliver+0x81d/0x930
> [  351.960334]        [<ffffffff8106d5aa>] do_signal+0x3a/0x950
> [  351.960334]        [<ffffffff8106df1e>] do_notify_resume+0x3e/0x90
> [  351.960334]        [<ffffffff83a993aa>] int_signal+0x12/0x17
> [  351.960334]
> [  351.960334] other info that might help us debug this:
> [  351.960334]
> [  351.960334]  Possible unsafe locking scenario:
> [  351.960334]
> [  351.960334]        CPU0                    CPU1
> [  351.960334]        ----                    ----
> [  351.960334]   lock(slab_mutex);
> [  351.960334]                                lock(s_active#43);
> [  351.960334]                                lock(slab_mutex);
> [  351.960334]   lock(s_active#43);
> [  351.960334]
> [  351.960334]  *** DEADLOCK ***
> [  351.960334]
> [  351.960334] 2 locks held by trinity-child13/6961:
> [  351.960334]  #0:  (mon_lock){+.+.+.}, at: [<ffffffff82b21005>] mon_text_release+0x25/0xe0
> [  351.960334]  #1:  (slab_mutex){+.+.+.}, at: [<ffffffff81228a42>] kmem_cache_destroy+0x22/0xe0
> [  351.960334]
> [  351.960334] stack backtrace:
> [  351.960334] Pid: 6961, comm: trinity-child13 Tainted: G        W    3.7.0-rc4-next-20121106-sasha-00008-g353b62f #117
> [  351.960334] Call Trace:
> [  351.960334]  [<ffffffff83a3c736>] print_circular_bug+0x1fb/0x20c
> [  351.960334]  [<ffffffff811825af>] __lock_acquire+0x14df/0x1ca0
> [  351.960334]  [<ffffffff81184045>] ? debug_check_no_locks_freed+0x185/0x1e0
> [  351.960334]  [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
> [  351.960334]  [<ffffffff812f9e11>] ? sysfs_addrm_finish+0x31/0x60
> [  351.960334]  [<ffffffff812f9272>] sysfs_deactivate+0x122/0x1a0
> [  351.960334]  [<ffffffff812f9e11>] ? sysfs_addrm_finish+0x31/0x60
> [  351.960334]  [<ffffffff812f9e11>] sysfs_addrm_finish+0x31/0x60
> [  351.960334]  [<ffffffff812fa369>] sysfs_remove_dir+0x89/0xd0
> [  351.960334]  [<ffffffff819e1d96>] kobject_del+0x16/0x40
> [  351.960334]  [<ffffffff8125ed40>] __kmem_cache_shutdown+0x40/0x60
> [  351.960334]  [<ffffffff81228a60>] kmem_cache_destroy+0x40/0xe0
> [  351.960334]  [<ffffffff82b21058>] mon_text_release+0x78/0xe0
> [  351.960334]  [<ffffffff8127b3b2>] __fput+0x122/0x2d0
> [  351.960334]  [<ffffffff8127b569>] ____fput+0x9/0x10
> [  351.960334]  [<ffffffff81131b4e>] task_work_run+0xbe/0x100
> [  351.960334]  [<ffffffff81110742>] do_exit+0x432/0xbd0
> [  351.960334]  [<ffffffff811243b9>] ? get_signal_to_deliver+0x8b9/0x930
> [  351.960334]  [<ffffffff8117d402>] ? get_lock_stats+0x22/0x70
> [  351.960334]  [<ffffffff8117d48e>] ? put_lock_stats.isra.16+0xe/0x40
> [  351.960334]  [<ffffffff83a977fb>] ? _raw_spin_unlock_irq+0x2b/0x80
> [  351.960334]  [<ffffffff81110fa4>] do_group_exit+0x84/0xd0
> [  351.960334]  [<ffffffff8112431d>] get_signal_to_deliver+0x81d/0x930
> [  351.960334]  [<ffffffff8117d48e>] ? put_lock_stats.isra.16+0xe/0x40
> [  351.960334]  [<ffffffff8106d5aa>] do_signal+0x3a/0x950
> [  351.960334]  [<ffffffff811c8b33>] ? rcu_cleanup_after_idle+0x23/0x170
> [  351.960334]  [<ffffffff811cc1c4>] ? rcu_eqs_exit_common+0x64/0x3a0
> [  351.960334]  [<ffffffff811caa5d>] ? rcu_user_enter+0x10d/0x140
> [  351.960334]  [<ffffffff811cc8d5>] ? rcu_user_exit+0xc5/0xf0
> [  351.960334]  [<ffffffff8106df1e>] do_notify_resume+0x3e/0x90
> [  351.960334]  [<ffffffff83a993aa>] int_signal+0x12/0x17
> 
> 
> Thanks,
> Sasha

Hello Sasha,

May I ask how did you trigger this ?



