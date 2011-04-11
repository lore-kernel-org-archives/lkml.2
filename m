Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1DKOxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1DKOxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:53:32 -0400
Subject: Strange block/scsi/workqueue issue
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Apr 2011 15:56:03 +0100
Message-ID: <1302533763.2596.23.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sometime around the -rc1 time (I'm not sure exactly, but it seemed to
start around then) my test box stopped booting. Lacking a serial console
I didn't get around to looking further before I went on holiday, but
since the problem is still there in the latest Linus' tree, I've been
looking again today.

My original problem was that the messages were scrolling off the screen
before I could read them. Using a video camera to try and capture them
was unsuccessful.

Today I used a serial console, and magically it seemed that the initial
boot issue had gone away - so I guess there is at least an element of
timing dependence. However, not very long after boot, I got the attached
messages. These look suspiciously similar (bearing in mind I could only
see the last few lines) to the messages I was getting with the boot
issue.

I should also say that the box was idle aside from the usual f14 start
up tasks, so there was not much I/O going on at the time.

Is the workqueue by any chance trying to wait synchronously for itself
to finish?

Steve.

INFO: task kworker/2:1:382 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/2:1     D ffff8800cb5d2500  4528   382      2 0x00000000
 ffff8800c88d5880 0000000000000086 00000000001d2500 ffff8800c88d57c8
 0000000000000086 ffff8800c88d5fd8 ffff8800c92d8b80 ffff8800c88d5fd8
 ffff8800c88d4000 ffff8800c88d4000 ffff8800c88d4000 ffff8800c88d5fd8
Call Trace:
 [<ffffffff8107fdea>] ? finish_task_switch+0x3a/0x110
 [<ffffffff8167ebe6>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8107fdea>] ? finish_task_switch+0x3a/0x110
 [<ffffffff8167b8e5>] schedule_timeout+0x295/0x310
 [<ffffffff816826b9>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8167a650>] wait_for_common+0x120/0x170
 [<ffffffff810898c0>] ? try_to_wake_up+0x360/0x360
 [<ffffffff8167a748>] wait_for_completion+0x18/0x20
 [<ffffffff810aba4c>] wait_on_cpu_work+0xec/0x100
 [<ffffffff810aa460>] ? do_work_for_cpu+0x30/0x30
 [<ffffffff810abb3b>] wait_on_work+0xdb/0x150
 [<ffffffff810aba60>] ? wait_on_cpu_work+0x100/0x100
 [<ffffffff810abc33>] __cancel_work_timer+0x83/0x130
 [<ffffffff810abced>] cancel_delayed_work_sync+0xd/0x10
 [<ffffffff813b24b4>] blk_sync_queue+0x24/0x50
 [<ffffffff813b24ef>] blk_cleanup_queue+0xf/0x60
 [<ffffffff81479a89>] scsi_free_queue+0x9/0x10
 [<ffffffff8147d30b>] scsi_device_dev_release_usercontext+0xeb/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d220>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d1f7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff814609f2>] device_release+0x22/0x90
 [<ffffffff8167ef98>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c8165>] kobject_release+0x45/0x90
 [<ffffffff813c8120>] ? kobject_del+0x40/0x40
 [<ffffffff813c9767>] kref_put+0x37/0x70
 [<ffffffff813c8027>] kobject_put+0x27/0x60
 [<ffffffff81460822>] put_device+0x12/0x20
 [<ffffffff81478bd9>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff81687064>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ebe6>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167ef98>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff81687060>] ? gs_change+0x13/0x13
INFO: lockdep is turned off.
INFO: task kworker/2:1:382 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/2:1     D ffff8800cb5d2500  4528   382      2 0x00000000
 ffff8800c88d5880 0000000000000086 00000000001d2500 ffff8800c88d57c8
 0000000000000086 ffff8800c88d5fd8 ffff8800c92d8b80 ffff8800c88d5fd8
 ffff8800c88d4000 ffff8800c88d4000 ffff8800c88d4000 ffff8800c88d5fd8
Call Trace:
 [<ffffffff8107fdea>] ? finish_task_switch+0x3a/0x110
 [<ffffffff8167ebe6>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8107fdea>] ? finish_task_switch+0x3a/0x110
 [<ffffffff8167b8e5>] schedule_timeout+0x295/0x310
 [<ffffffff816826b9>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff8167a650>] wait_for_common+0x120/0x170
 [<ffffffff810898c0>] ? try_to_wake_up+0x360/0x360
 [<ffffffff8167a748>] wait_for_completion+0x18/0x20
 [<ffffffff810aba4c>] wait_on_cpu_work+0xec/0x100
 [<ffffffff810aa460>] ? do_work_for_cpu+0x30/0x30
 [<ffffffff810abb3b>] wait_on_work+0xdb/0x150
 [<ffffffff810aba60>] ? wait_on_cpu_work+0x100/0x100
 [<ffffffff810abc33>] __cancel_work_timer+0x83/0x130
 [<ffffffff810abced>] cancel_delayed_work_sync+0xd/0x10
 [<ffffffff813b24b4>] blk_sync_queue+0x24/0x50
 [<ffffffff813b24ef>] blk_cleanup_queue+0xf/0x60
 [<ffffffff81479a89>] scsi_free_queue+0x9/0x10
 [<ffffffff8147d30b>] scsi_device_dev_release_usercontext+0xeb/0x140
 [<ffffffff810cbd5d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8147d220>] ? scsi_device_cls_release+0x20/0x20
 [<ffffffff810ac826>] execute_in_process_context+0x86/0xa0
 [<ffffffff8147d1f7>] scsi_device_dev_release+0x17/0x20
 [<ffffffff814609f2>] device_release+0x22/0x90
 [<ffffffff8167ef98>] ? retint_restore_args+0x13/0x13
 [<ffffffff813c8165>] kobject_release+0x45/0x90
 [<ffffffff813c8120>] ? kobject_del+0x40/0x40
 [<ffffffff813c9767>] kref_put+0x37/0x70
 [<ffffffff813c8027>] kobject_put+0x27/0x60
 [<ffffffff81460822>] put_device+0x12/0x20
 [<ffffffff81478bd9>] scsi_request_fn+0xb9/0x4a0
 [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
 [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
 [<ffffffff810aa9c7>] process_one_work+0x197/0x520
 [<ffffffff810aa961>] ? process_one_work+0x131/0x520
 [<ffffffff813b1f40>] ? blk_make_request+0x90/0x90
 [<ffffffff810acfec>] worker_thread+0x15c/0x330
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810ace90>] ? manage_workers.clone.20+0x240/0x240
 [<ffffffff810b1f16>] kthread+0xa6/0xb0
 [<ffffffff81687064>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107fe1f>] ? finish_task_switch+0x6f/0x110
 [<ffffffff8167ebe6>] ? _raw_spin_unlock_irq+0x46/0x70
 [<ffffffff8167ef98>] ? retint_restore_args+0x13/0x13
 [<ffffffff810b1e70>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff81687060>] ? gs_change+0x13/0x13
INFO: lockdep is turned off.


