Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0DACmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0DACl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:41:58 -0400
Message-ID: <4BB408AF.4080908@redhat.com>
Date: Thu, 01 Apr 2010 10:45:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to	destroy_workqueue()
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain> <20100331112559.GA17747@redhat.com>
In-Reply-To: <20100331112559.GA17747@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 03/31, Amerigo Wang wrote:
>> This fixes a lockdep warning when invoking destroy_workqueue(),
>> because the lockdep annotations are invoked under cpu_add_remove_lock.
> 
> Confused. Why does lockdep complains?

Because lockdep annotations are added to prevent other locks are taken
before calling these functions.

> 
>> So, move the lockdep annotations before taking cpu_add_remove_lock
>> in destroy_workqueue(), this will not affect the original purpose
>> of adding them for destroy_workqueue() etc.
>>
>> However, it will affect another caller of cleanup_workqueue_thread(),
>> that is, workqueue_cpu_callback(). This should be fine, because there
>> are no other cases than cpu hotplug could call it.
> 
> OK, but nobody should take cpu_maps_update_begin() under wq->lockdep_map,
> in particular work->func() must not.
> 
> I must have missed something, but it seems to me this patch tries to
> supress the valid warning.
> 
> Could you please clarify?
> 

Sure, below is the whole warning. Please teach me how this is valid.

Thanks.


Mar 31 16:15:00 dhcp-66-70-5 kernel: bonding: bond0: released all slaves
Mar 31 16:15:00 dhcp-66-70-5 kernel:
Mar 31 16:15:00 dhcp-66-70-5 kernel: =======================================================
Mar 31 16:15:00 dhcp-66-70-5 kernel: [ INFO: possible circular locking dependency detected ]
Mar 31 16:15:00 dhcp-66-70-5 kernel: 2.6.34-rc3 #90
Mar 31 16:15:00 dhcp-66-70-5 kernel: -------------------------------------------------------
Mar 31 16:15:00 dhcp-66-70-5 kernel: modprobe/5264 is trying to acquire lock:
Mar 31 16:15:00 dhcp-66-70-5 kernel:  ((bond_dev->name)){+.+...}, at: [<ffffffff8108524a>] cleanup_workqueue_thread+0x2b/0x10b
Mar 31 16:15:00 dhcp-66-70-5 kernel:
Mar 31 16:15:00 dhcp-66-70-5 kernel: but task is already holding lock:
Mar 31 16:15:00 dhcp-66-70-5 kernel:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810631d1>] cpu_maps_update_begin+0x1e/0x27
Mar 31 16:15:00 dhcp-66-70-5 kernel:
Mar 31 16:15:00 dhcp-66-70-5 kernel: which lock already depends on the new lock.
Mar 31 16:15:01 dhcp-66-70-5 kernel:
Mar 31 16:15:01 dhcp-66-70-5 kernel:
Mar 31 16:15:01 dhcp-66-70-5 kernel: the existing dependency chain (in reverse order) is:
Mar 31 16:15:01 dhcp-66-70-5 kernel:
Mar 31 16:15:01 dhcp-66-70-5 kernel: -> #3 (cpu_add_remove_lock){+.+.+.}:
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff815523f8>] mutex_lock_nested+0x64/0x4e9
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810631d1>] cpu_maps_update_begin+0x1e/0x27
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810853cd>] destroy_workqueue+0x41/0x107
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffffa0839d32>] bond_uninit+0x524/0x58a [bonding]
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8146967b>] rollback_registered_many+0x205/0x2e3
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff81469783>] unregister_netdevice_many+0x2a/0x75
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8147ada3>] __rtnl_kill_links+0x8b/0x9d
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8147adea>] __rtnl_link_unregister+0x35/0x72
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8147b293>] rtnl_link_unregister+0x2c/0x43
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffffa0845ca6>] bonding_exit+0x5a/0x76 [bonding]
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810b7749>] sys_delete_module+0x306/0x3b1
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff81003a5b>] system_call_fastpath+0x16/0x1b
Mar 31 16:15:02 dhcp-66-70-5 kernel:
Mar 31 16:15:02 dhcp-66-70-5 kernel: -> #2 (rtnl_mutex){+.+.+.}:
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff815523f8>] mutex_lock_nested+0x64/0x4e9
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8147af16>] rtnl_lock+0x1e/0x27
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffffa0836779>] bond_mii_monitor+0x39f/0x74b [bonding]
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8108654f>] worker_thread+0x2da/0x46c
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8108b1ea>] kthread+0xdd/0xec
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff81004894>] kernel_thread_helper+0x4/0x10
Mar 31 16:15:02 dhcp-66-70-5 kernel:
Mar 31 16:15:02 dhcp-66-70-5 kernel: -> #1 ((&(&bond->mii_work)->work)){+.+...}:
Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81086542>] worker_thread+0x2cd/0x46c
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8108b1ea>] kthread+0xdd/0xec
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81004894>] kernel_thread_helper+0x4/0x10
Mar 31 16:15:03 dhcp-66-70-5 kernel:
Mar 31 16:15:03 dhcp-66-70-5 kernel: -> #0 ((bond_dev->name)){+.+...}:
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810a6696>] validate_chain+0xaee/0x1540
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81085278>] cleanup_workqueue_thread+0x59/0x10b
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81085428>] destroy_workqueue+0x9c/0x107
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffffa0839d32>] bond_uninit+0x524/0x58a [bonding]
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8146967b>] rollback_registered_many+0x205/0x2e3
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81469783>] unregister_netdevice_many+0x2a/0x75
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8147ada3>] __rtnl_kill_links+0x8b/0x9d
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8147adea>] __rtnl_link_unregister+0x35/0x72
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8147b293>] rtnl_link_unregister+0x2c/0x43
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffffa0845ca6>] bonding_exit+0x5a/0x76 [bonding]
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810b7749>] sys_delete_module+0x306/0x3b1
Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81003a5b>] system_call_fastpath+0x16/0x1b
Mar 31 16:15:03 dhcp-66-70-5 kernel:
Mar 31 16:15:03 dhcp-66-70-5 kernel: other info that might help us debug this:
Mar 31 16:15:03 dhcp-66-70-5 kernel:
Mar 31 16:15:03 dhcp-66-70-5 kernel: 2 locks held by modprobe/5264:
Mar 31 16:15:03 dhcp-66-70-5 kernel:  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8147af16>] rtnl_lock+0x1e/0x27
Mar 31 16:15:03 dhcp-66-70-5 kernel:  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810631d1>] cpu_maps_update_begin+0x1e/0x27
Mar 31 16:15:03 dhcp-66-70-5 kernel:
Mar 31 16:15:03 dhcp-66-70-5 kernel: stack backtrace:
Mar 31 16:15:03 dhcp-66-70-5 kernel: Pid: 5264, comm: modprobe Not tainted 2.6.34-rc3 #90
Mar 31 16:15:03 dhcp-66-70-5 kernel: Call Trace:
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff810a50c1>] print_circular_bug+0x169/0x17e
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff810a6696>] validate_chain+0xaee/0x1540
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff8108524a>] ? cleanup_workqueue_thread+0x2b/0x10b
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff81085278>] cleanup_workqueue_thread+0x59/0x10b
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff8108524a>] ? cleanup_workqueue_thread+0x2b/0x10b
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff81085428>] destroy_workqueue+0x9c/0x107
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffffa0833a19>] ? bond_remove_proc_entry+0x0/0x109 [bonding]
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffffa0839d32>] bond_uninit+0x524/0x58a [bonding]
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff8146967b>] rollback_registered_many+0x205/0x2e3
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff81469783>] unregister_netdevice_many+0x2a/0x75
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff8147ada3>] __rtnl_kill_links+0x8b/0x9d
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff8147adea>] __rtnl_link_unregister+0x35/0x72
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff8147b293>] rtnl_link_unregister+0x2c/0x43
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffffa0845ca6>] bonding_exit+0x5a/0x76 [bonding]
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff810b7749>] sys_delete_module+0x306/0x3b1
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff81003a8c>] ? sysret_check+0x27/0x62
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff810a3268>] ? trace_hardirqs_on_caller+0x264/0x29f
Mar 31 16:15:03 dhcp-66-70-5 kernel:  [<ffffffff81003a5b>] system_call_fastpath+0x16/0x1b
