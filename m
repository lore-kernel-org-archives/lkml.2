Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0GTRmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:42:35 -0400
Received: from mail.candelatech.com ([208.74.158.172]:45303 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0GTRmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:42:33 -0400
Message-ID: <4C45E007.4050100@candelatech.com>
Date: Tue, 20 Jul 2010 10:42:31 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.34.1+hacks:  stopping oprofile locked system for several minutes.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on my custom-compiled kernel, with my proprietary module included,
(ie, tainted), so feel free to ignore.

OS is Fedora 11, 64-bit.

I was running oprofile on a system under heavy network load.  Once,
the machine rebooted when I clicked 'Stop' in oprof_start.  I added
serial console and did some more testing.  Normally stop works fine,
but one time, the whole system was totally locked (as far as I could tell)
for several minutes..then miraculously recovered.  I noticed this in
'dmesg':

INFO: task events/1:28 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/1      D ffff88033096b480     0    28      2 0x00000000
  ffff88033213bce0 0000000000000046 ffff88033213bcb0 ffff880332128f40
  ffff88032ab39e80 ffff880332129200 0000000000000002 0000000000000001
  ffff88033213bce0 ffff88033213bfd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff813de1ba>] ? _raw_spin_unlock_irq+0x34/0x3f
  [<ffffffff810386d2>] ? finish_task_switch+0x4a/0xa1
  [<ffffffff8103510c>] ? need_resched+0x1e/0x28
  [<ffffffff813dc808>] ? schedule+0x4cf/0x4e6
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task events/2:29 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/2      D 0000000000000002     0    29      2 0x00000000
  ffff88033213dce0 0000000000000046 ffff880001a8fee0 ffff8803321296e0
  ffff88033209db80 ffff8803321299a0 0000000000000000 0000000000004158
  0000000100000c00 ffff88033213dfd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff813de1ba>] ? _raw_spin_unlock_irq+0x34/0x3f
  [<ffffffff81038707>] ? finish_task_switch+0x7f/0xa1
  [<ffffffff8103510c>] ? need_resched+0x1e/0x28
  [<ffffffff813dc808>] ? schedule+0x4cf/0x4e6
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task events/3:30 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/3      D 0000000000000003     0    30      2 0x00000000
  ffff88033213fce0 0000000000000046 ffff880001acfee0 ffff880332129e80
  ffff8803320d8000 ffff88033212a140 0000000000000000 0000000000004158
  0000000100000c00 ffff88033213ffd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff813de1ba>] ? _raw_spin_unlock_irq+0x34/0x3f
  [<ffffffff81038707>] ? finish_task_switch+0x7f/0xa1
  [<ffffffff8103510c>] ? need_resched+0x1e/0x28
  [<ffffffff813dc808>] ? schedule+0x4cf/0x4e6
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task events/4:31 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/4      D ffff880322448000     0    31      2 0x00000000
  ffff880332141ce0 0000000000000046 ffff880332128000 ffff88033212a620
  ffff88032ab387a0 ffff88033212a8e0 ffff880332141cc0 0000000000000046
  ffff880332141cd0 ffff880332141fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff813de1ba>] ? _raw_spin_unlock_irq+0x34/0x3f
  [<ffffffff810386d2>] ? finish_task_switch+0x4a/0xa1
  [<ffffffff8103510c>] ? need_resched+0x1e/0x28
  [<ffffffff813dc808>] ? schedule+0x4cf/0x4e6
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task events/5:32 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/5      D 0000000000000005     0    32      2 0x00000000
  ffff880332143ce0 0000000000000046 ffff880001b4fee0 ffff88033212adc0
  ffff8803320dbd00 ffff88033212b080 ffff880332143cc0 0000000000000046
  0000000132143cd0 ffff880332143fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff813de1ba>] ? _raw_spin_unlock_irq+0x34/0x3f
  [<ffffffff81038707>] ? finish_task_switch+0x7f/0xa1
  [<ffffffff8103510c>] ? need_resched+0x1e/0x28
  [<ffffffff813dc808>] ? schedule+0x4cf/0x4e6
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task events/6:33 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/6      D 0000000000000006     0    33      2 0x00000000
  ffff880332145ce0 0000000000000046 ffff880001b8fee0 ffff88033212b560
  ffff8803320ddb80 ffff88033212b820 ffff880332145cc0 0000000000000046
  0000000132145cd0 ffff880332145fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff810aafd4>] ? refresh_cpu_vm_stats+0x105/0x146
  [<ffffffff8104c1eb>] ? mod_timer+0x1e/0x20
  [<ffffffff8104c204>] ? add_timer+0x17/0x19
  [<ffffffff8105334b>] ? queue_delayed_work_on+0x91/0xa1
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task events/7:34 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
events/7      D 0000000000000007     0    34      2 0x00000000
  ffff880332147ce0 0000000000000046 ffff880001bcfee0 ffff88033212bd00
  ffff880332128000 ffff88033212bfc0 0000000000000000 0000000000004041
  0000000100000800 ffff880332147fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff813de1ba>] ? _raw_spin_unlock_irq+0x34/0x3f
  [<ffffffff81038707>] ? finish_task_switch+0x7f/0xa1
  [<ffffffff8103510c>] ? need_resched+0x1e/0x28
  [<ffffffff813dc808>] ? schedule+0x4cf/0x4e6
  [<ffffffffa025f855>] ? wq_sync_buffer+0x0/0x84 [oprofile]
  [<ffffffffa025f8b9>] wq_sync_buffer+0x64/0x84 [oprofile]
  [<ffffffff810534c6>] worker_thread+0x112/0x1ba
  [<ffffffff81056344>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff810533b4>] ? worker_thread+0x0/0x1ba
  [<ffffffff81056130>] kthread+0x69/0x71
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
  [<ffffffff810560c7>] ? kthread+0x0/0x71
  [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
INFO: task rsyslogd:8499 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsyslogd      D 0000000000000007     0  8499      1 0x00000080
  ffff8803186c9cc8 0000000000000082 ffffffff8141b2c0 ffff880322535b80
  ffff880332128000 ffff880322535e40 0000000000000050 0000000000000000
  0000000100000000 ffff8803186c9fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff8109ab22>] ? generic_file_aio_write+0x85/0xa1
  [<ffffffff81143b50>] ? ext4_file_write+0x90/0xa0
  [<ffffffffa02601d4>] task_exit_notify+0x11/0x15 [oprofile]
  [<ffffffff813e105a>] notifier_call_chain+0x33/0x5b
  [<ffffffff8105a5ce>] __blocking_notifier_call_chain+0x4d/0x6a
  [<ffffffff8105a5fa>] blocking_notifier_call_chain+0xf/0x11
  [<ffffffff8105d209>] profile_task_exit+0x15/0x17
  [<ffffffff81045144>] do_exit+0x25/0x679
  [<ffffffff810e0190>] ? path_put+0x1d/0x22
  [<ffffffff81083b91>] ? audit_syscall_entry+0xfe/0x12a
  [<ffffffff81045855>] complete_and_exit+0x0/0x1e
  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
INFO: task ip:8931 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ip            D 0000000000000007     0  8931   8930 0x00000080
  ffff880318351c98 0000000000000082 ffff880318351c58 ffff88031e1f8f40
  ffff880332128000 ffff88031e1f9200 0000000000000000 0000000000000000
  0000000100000000 ffff880318351fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff81099e36>] ? wake_up_page+0x20/0x25
  [<ffffffff81099e87>] ? unlock_page+0xf/0x11
  [<ffffffff810ae0b9>] ? __do_fault+0x34b/0x388
  [<ffffffff8132d2f2>] ? __sys_recvmsg+0x18d/0x226
  [<ffffffffa02601d4>] task_exit_notify+0x11/0x15 [oprofile]
  [<ffffffff813e105a>] notifier_call_chain+0x33/0x5b
  [<ffffffff8105a5ce>] __blocking_notifier_call_chain+0x4d/0x6a
  [<ffffffff8105a5fa>] blocking_notifier_call_chain+0xf/0x11
  [<ffffffff8105d209>] profile_task_exit+0x15/0x17
  [<ffffffff81045144>] do_exit+0x25/0x679
  [<ffffffff813e0f18>] ? do_page_fault+0x278/0x287
  [<ffffffff8104582c>] sys_exit_group+0x0/0x16
  [<ffffffff8104583e>] sys_exit_group+0x12/0x16
  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
INFO: task ps:8933 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ps            D 0000000000000001     0  8933   8932 0x00000080
  ffff88030e871c98 0000000000000086 ffff88030e871c58 ffff88031e1f9e80
  ffff88033209bd00 ffff88031e1fa140 ffff88030e871c68 ffffffff81034fb4
  000000010e871cb8 ffff88030e871fd8 ffffffffa02650c0 0000000000000246
Call Trace:
  [<ffffffff81034fb4>] ? task_rq_unlock+0xc/0xe
  [<ffffffff813dd0a9>] __mutex_lock_common+0x242/0x3ac
  [<ffffffff81056355>] ? autoremove_wake_function+0x11/0x38
  [<ffffffff813dd253>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813dd2c2>] mutex_lock+0x27/0x3e
  [<ffffffffa025fd7c>] sync_buffer+0x2d/0x3fe [oprofile]
  [<ffffffff81099e36>] ? wake_up_page+0x20/0x25
  [<ffffffff81099e87>] ? unlock_page+0xf/0x11
  [<ffffffff810ae0b9>] ? __do_fault+0x34b/0x388
  [<ffffffffa02601d4>] task_exit_notify+0x11/0x15 [oprofile]
  [<ffffffff813e105a>] notifier_call_chain+0x33/0x5b
  [<ffffffff8105a5ce>] __blocking_notifier_call_chain+0x4d/0x6a
  [<ffffffff8105a5fa>] blocking_notifier_call_chain+0xf/0x11
  [<ffffffff8105d209>] profile_task_exit+0x15/0x17
  [<ffffffff81045144>] do_exit+0x25/0x679
  [<ffffffff813e0f18>] ? do_page_fault+0x278/0x287
  [<ffffffff8104582c>] sys_exit_group+0x0/0x16
  [<ffffffff8104583e>] sys_exit_group+0x12/0x16
  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

