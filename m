Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2BVIpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:45:39 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48565 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVIph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:45:37 -0500
Message-ID: <4F44AB09.9000606@linux.vnet.ibm.com>
Date: Wed, 22 Feb 2012 14:14:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH 0/7] PM: Implement autosleep and "wake locks", take
 2
References: <201202070200.55505.rjw@sisk.pl>	 <201202220031.46219.rjw@sisk.pl> <1329886179.2229.2.camel@js-netbook>
In-Reply-To: <1329886179.2229.2.camel@js-netbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022122-1618-0000-0000-000000DDAF98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 10:19 AM, John Stultz wrote:

> On Wed, 2012-02-22 at 00:31 +0100, Rafael J. Wysocki wrote:
>> Hi all,
>>
>> After the feedback so far I've decided to follow up with a refreshed patchset.
>> The first two patches from the previous one went to linux-pm/linux-next
>> and I included the recent evdev patch from Arve (with some modifications)
>> to this patchset for completness.
> 
> Hey Rafael, 
> 	Thanks again for posting this! I've started playing around with it in a
> kvm environment, and got the following warning after echoing off >
> autosleep:
> ...
> PM: resume of devices complete after 185.615 msecs
> PM: Finishing wakeup.
> Restarting tasks ... done.
> PM: Syncing filesystems ... done.
> PM: Preparing system for mem sleep
> Freezing user space processes ... 
> Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
> bash            D ffff880015714010 


Ah.. I think I know what is the problem here..

The kernel was freezing userspace processes and meanwhile, you wrote "off"
to autosleep. So, as a result, this userspace process (bash) just now
entered kernel mode. Unfortunately, the autosleep_lock is held for too long,
that is, something like:

acquire autosleep_lock
modify autosleep_state
                               <============== "A"
 pm_suspend or hibernate()

release autosleep_lock

At point marked "A", we should have released the autosleep lock and only then
entered pm_suspend or hibernate(). Since the current code holds the lock and
enters suspend/hibernate, the userspace process that wrote "off" to autosleep
(or even userspace process that writes to /sys/power/state will end up waiting
on autosleep_lock, thus failing the freezing operation.)

So the solution is to always release the autosleep lock before entering
suspend/hibernation.

 
Regards,
Srivatsa S. Bhat

> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.3.0-rc3john+ #131 Not tainted
> -------------------------------
> kernel/sched/core.c:4784 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 5 locks held by kworker/u:1/10:
>  #0:  (autosleep){.+.+.+}, at: [<ffffffff81066db8>] process_one_work+0x2d8/0x8c0
>  #1:  (suspend_work){+.+.+.}, at: [<ffffffff81066db8>] process_one_work+0x2d8/0x8c0
>  #2:  (autosleep_lock){+.+.+.}, at: [<ffffffff810a2d3d>] try_to_suspend+0x2d/0xe0
>  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff8109b9fc>] pm_suspend+0x8c/0x210
>  #4:  (tasklist_lock){.+.+..}, at: [<ffffffff8109b0f1>] try_to_freeze_tasks+0x2d1/0x400
> 
> stack backtrace:
> Pid: 10, comm: kworker/u:1 Not tainted 3.3.0-rc3john+ #131
> Call Trace:
>  [<ffffffff81040d82>] ? vprintk+0x242/0x530
>  [<ffffffff810b0fdb>] lockdep_rcu_suspicious+0xeb/0x100
>  [<ffffffff81083371>] sched_show_task+0x121/0x180
>  [<ffffffff8109b1e5>] try_to_freeze_tasks+0x3c5/0x400
>  [<ffffffff810a2d10>] ? pm_autosleep_set_state+0x80/0x80
>  [<ffffffff8109b2eb>] freeze_processes+0x3b/0xb0
>  [<ffffffff8109baad>] pm_suspend+0x13d/0x210
>  [<ffffffff810a2d5d>] try_to_suspend+0x4d/0xe0
>  [<ffffffff81066f02>] process_one_work+0x422/0x8c0
>  [<ffffffff81066db8>] ? process_one_work+0x2d8/0x8c0
>  [<ffffffff810b063e>] ? put_lock_stats+0xe/0x40
>  [<ffffffff81067a16>] worker_thread+0x476/0x550
>  [<ffffffff810675a0>] ? rescuer_thread+0x200/0x200
>  [<ffffffff810706fe>] kthread+0xae/0xc0
>  [<ffffffff81af4cb4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81af3078>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81070650>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff81af4cb0>] ? gs_change+0x13/0x13
>     0  1981   1980 0x00020004
>  ffff880015715d88 0000000000000046 ffff880015715c88 ffffffff8102c22b
>  ffff880015714010 ffff880015715fd8 ffff880015714010 ffff880015714000
>  ffff880015715fd8 ffff880015714000 ffff880015c4e3c0 ffff88001342e540
> Call Trace:
>  [<ffffffff8102c22b>] ? kvm_clock_read+0x6b/0x90
>  [<ffffffff810b1f2d>] ? mark_held_locks+0xad/0x150
>  [<ffffffff81af10bf>] schedule+0x3f/0x60
>  [<ffffffff81aef33b>] mutex_lock_nested+0x1cb/0x4c0
>  [<ffffffff810a2cae>] ? pm_autosleep_set_state+0x1e/0x80
>  [<ffffffff810a2cae>] ? pm_autosleep_set_state+0x1e/0x80
>  [<ffffffff810a2cae>] pm_autosleep_set_state+0x1e/0x80
>  [<ffffffff8109a74b>] autosleep_store+0x3b/0x80
>  [<ffffffff813856e7>] kobj_attr_store+0x17/0x20
>  [<ffffffff81200dcc>] sysfs_write_file+0xec/0x170
>  [<ffffffff8118085f>] vfs_write+0x11f/0x1b0
>  [<ffffffff811809f4>] sys_write+0x54/0xa0
>  [<ffffffff81af4e66>] sysenter_dispatch+0x7/0x26
>  [<ffffffff8139238e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> 
> Restarting tasks ... done.
> 
> 
> 

