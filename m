Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1GGIFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:05:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51239 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1GGIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:05:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 7 Jul 2011 10:05:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: 3.0-rc6: USB khubd deadlock when hub is powered down
Message-ID: <20110707100501.68a21fb8@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday I updated from 3.0-rc4 to 3.0-rc6.  I have got an LCD monitor
with integrated USB hub and card reader.  Besides the card reader, I had a
keyboard and two mice attached to that integrated hub.

When I switched off the monitor yesterday, I go the following deadlock.  I
noticed it today when I switched the monitor back on and the USB subsystem
was dead.

Note, this is not necessarily a 3.0-rc4...3.0-rc6 regression.  USB device
unplugging has been unstable for me for several kernel releases.
(Although the major culprit hasn't been the USB subsystem but the SCSI and
maybe block subsystems which nowadays handle storage device removal in
Windows 95 fashion.)

So, here is last night's deadlock:

Jul  7 00:48:44 stein kernel: usb 1-3: USB disconnect, device number 2
Jul  7 00:48:44 stein kernel: usb 1-3.1: USB disconnect, device number 3
Jul  7 00:48:44 stein kernel: usb 1-3.1.1: USB disconnect, device number 6
Jul  7 00:48:44 stein kernel: generic-usb 0003:046D:C518.0005: can't reset device, 0000:00:12.2-3.1.3/input0, status -71
Jul  7 00:48:44 stein kernel: generic-usb 0003:046D:C042.0001: can't reset device, 0000:00:12.2-3.2/input0, status -71
Jul  7 00:48:44 stein kernel: generic-usb 0003:1267:0103.0003: can't reset device, 0000:00:12.2-3.3/input0, status -71
Jul  7 00:48:44 stein kernel: usb 1-3: clear tt 2 (0040) error -19
Jul  7 00:48:44 stein kernel: usb 1-3: clear tt 3 (0050) error -19
Jul  7 00:48:44 stein kernel: usb 1-3.1: clear tt 1 (0070) error -19
Jul  7 00:48:44 stein kernel: usb 1-3.1.3: USB disconnect, device number 7
Jul  7 00:48:44 stein kernel: usb 1-3.2: USB disconnect, device number 4
Jul  7 00:48:44 stein kernel: usb 1-3.3: USB disconnect, device number 5
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: =============================================
Jul  7 00:48:44 stein kernel: [ INFO: possible recursive locking detected ]
Jul  7 00:48:44 stein kernel: 3.0.0-rc6 #9
Jul  7 00:48:44 stein kernel: ---------------------------------------------
Jul  7 00:48:44 stein kernel: khubd/303 is trying to acquire lock:
Jul  7 00:48:44 stein kernel: (hcd->bandwidth_mutex){+.+.+.}, at: [<ffffffff8129f588>] usb_set_interface+0x84/0x210
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: but task is already holding lock:
Jul  7 00:48:44 stein kernel: (hcd->bandwidth_mutex){+.+.+.}, at: [<ffffffff81299d7d>] usb_disconnect+0x9a/0x140
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: other info that might help us debug this:
Jul  7 00:48:44 stein kernel: Possible unsafe locking scenario:
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: CPU0
Jul  7 00:48:44 stein kernel: ----
Jul  7 00:48:44 stein kernel: lock(hcd->bandwidth_mutex);
Jul  7 00:48:44 stein kernel: lock(hcd->bandwidth_mutex);
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: *** DEADLOCK ***
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: May be due to missing lock nesting notation
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: 4 locks held by khubd/303:
Jul  7 00:48:44 stein kernel: #0:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8129a891>] hub_thread+0xdf/0xe5a
Jul  7 00:48:44 stein kernel: #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81299d3c>] usb_disconnect+0x59/0x140
Jul  7 00:48:44 stein kernel: #2:  (hcd->bandwidth_mutex){+.+.+.}, at: [<ffffffff81299d7d>] usb_disconnect+0x9a/0x140
Jul  7 00:48:44 stein kernel: #3:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff812674fe>] device_release_driver+0x18/0x2d
Jul  7 00:48:44 stein kernel: 
Jul  7 00:48:44 stein kernel: stack backtrace:
Jul  7 00:48:44 stein kernel: Pid: 303, comm: khubd Not tainted 3.0.0-rc6 #9
Jul  7 00:48:44 stein kernel: Call Trace:
Jul  7 00:48:44 stein kernel: [<ffffffff8105cfaf>] __lock_acquire+0x169b/0x1734
Jul  7 00:48:44 stein kernel: [<ffffffff8105a1ff>] ? mark_held_locks+0x52/0x70
Jul  7 00:48:44 stein kernel: [<ffffffff8102e603>] ? sub_preempt_count+0x92/0xa6
Jul  7 00:48:44 stein kernel: [<ffffffff8134fcc1>] ? _raw_spin_unlock_irq+0x36/0x53
Jul  7 00:48:44 stein kernel: [<ffffffff810465eb>] ? wait_on_cpu_work+0x6a/0x99
Jul  7 00:48:44 stein kernel: [<ffffffff8129f588>] ? usb_set_interface+0x84/0x210
Jul  7 00:48:44 stein kernel: [<ffffffff8105d471>] lock_acquire+0x57/0x6d
Jul  7 00:48:44 stein kernel: [<ffffffff8129f588>] ? usb_set_interface+0x84/0x210
Jul  7 00:48:44 stein kernel: [<ffffffff8102e6c4>] ? add_preempt_count+0xad/0xb2
Jul  7 00:48:44 stein kernel: [<ffffffff8134e711>] mutex_lock_nested+0x5e/0x2f9
Jul  7 00:48:44 stein kernel: [<ffffffff8129f588>] ? usb_set_interface+0x84/0x210
Jul  7 00:48:44 stein kernel: [<ffffffff810466e1>] ? wait_on_work+0xc7/0x115
Jul  7 00:48:44 stein kernel: [<ffffffff8104661a>] ? wait_on_cpu_work+0x99/0x99
Jul  7 00:48:44 stein kernel: [<ffffffff8129f588>] usb_set_interface+0x84/0x210
Jul  7 00:48:44 stein kernel: [<ffffffff81046803>] ? __cancel_work_timer+0xd4/0x11d
Jul  7 00:48:44 stein kernel: [<ffffffff812a099b>] usb_unbind_interface+0x93/0xd1
Jul  7 00:48:44 stein kernel: [<ffffffff812673e6>] __device_release_driver+0x67/0xb0
Jul  7 00:48:44 stein kernel: [<ffffffff81267506>] device_release_driver+0x20/0x2d
Jul  7 00:48:44 stein kernel: [<ffffffff81266a24>] bus_remove_device+0xb1/0xc6
Jul  7 00:48:44 stein kernel: [<ffffffff812654fa>] device_del+0x11b/0x187
Jul  7 00:48:44 stein kernel: [<ffffffff8129e81b>] usb_disable_device+0x55/0x14b
Jul  7 00:48:44 stein kernel: [<ffffffff81299d87>] usb_disconnect+0xa4/0x140
Jul  7 00:48:44 stein kernel: [<ffffffff8129acef>] hub_thread+0x53d/0xe5a
Jul  7 00:48:44 stein kernel: [<ffffffff8134d259>] ? schedule+0x878/0x8b0
Jul  7 00:48:44 stein kernel: [<ffffffff8104b06d>] ? wake_up_bit+0x25/0x25
Jul  7 00:48:44 stein kernel: [<ffffffff8134fd24>] ? _raw_spin_unlock_irqrestore+0x46/0x64
Jul  7 00:48:44 stein kernel: [<ffffffff8129a7b2>] ? hub_probe+0x7f3/0x7f3
Jul  7 00:48:44 stein kernel: [<ffffffff8104acca>] kthread+0x7d/0x85
Jul  7 00:48:44 stein kernel: [<ffffffff81351594>] kernel_thread_helper+0x4/0x10
Jul  7 00:48:44 stein kernel: [<ffffffff8102e4f5>] ? finish_task_switch+0x42/0xbe
Jul  7 00:48:44 stein kernel: [<ffffffff813500c4>] ? retint_restore_args+0xe/0xe
Jul  7 00:48:44 stein kernel: [<ffffffff8104ac4d>] ? __init_kthread_worker+0x56/0x56
Jul  7 00:48:44 stein kernel: [<ffffffff81351590>] ? gs_change+0xb/0xb
Jul  7 00:51:26 stein kernel: INFO: task khubd:303 blocked for more than 120 seconds.
Jul  7 00:51:26 stein kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  7 00:51:26 stein kernel: khubd           D 0000000000000000     0   303      2 0x00000000
Jul  7 00:51:26 stein kernel: ffff88021e3c3af0 0000000000000046 ffffffff8134ccf0 ffffffff8194c2d0
Jul  7 00:51:26 stein kernel: ffff88021e1e6900 ffff88021e3c2010 ffff88021e1e6900 ffff88021e3c3fd8
Jul  7 00:51:26 stein kernel: 00000000000102c0 0000000000004000 ffff88021e3c3fd8 00000000000102c0
Jul  7 00:51:26 stein kernel: Call Trace:
Jul  7 00:51:26 stein kernel: [<ffffffff8134ccf0>] ? schedule+0x30f/0x8b0
Jul  7 00:51:26 stein kernel: [<ffffffff8102e603>] ? sub_preempt_count+0x92/0xa6
Jul  7 00:51:26 stein kernel: [<ffffffff8134fcc1>] ? _raw_spin_unlock_irq+0x36/0x53
Jul  7 00:51:26 stein kernel: [<ffffffff810465eb>] ? wait_on_cpu_work+0x6a/0x99
Jul  7 00:51:26 stein kernel: [<ffffffff8129f588>] ? usb_set_interface+0x84/0x210
Jul  7 00:51:26 stein kernel: [<ffffffff8134e857>] mutex_lock_nested+0x1a4/0x2f9
Jul  7 00:51:26 stein kernel: [<ffffffff8129f588>] ? usb_set_interface+0x84/0x210
Jul  7 00:51:26 stein kernel: [<ffffffff8104661a>] ? wait_on_cpu_work+0x99/0x99
Jul  7 00:51:26 stein kernel: [<ffffffff8129f588>] usb_set_interface+0x84/0x210
Jul  7 00:51:26 stein kernel: [<ffffffff81046803>] ? __cancel_work_timer+0xd4/0x11d
Jul  7 00:51:26 stein kernel: [<ffffffff812a099b>] usb_unbind_interface+0x93/0xd1
Jul  7 00:51:26 stein kernel: [<ffffffff812673e6>] __device_release_driver+0x67/0xb0
Jul  7 00:51:26 stein kernel: [<ffffffff81267506>] device_release_driver+0x20/0x2d
Jul  7 00:51:26 stein kernel: [<ffffffff81266a24>] bus_remove_device+0xb1/0xc6
Jul  7 00:51:26 stein kernel: [<ffffffff812654fa>] device_del+0x11b/0x187
Jul  7 00:51:26 stein kernel: [<ffffffff8129e81b>] usb_disable_device+0x55/0x14b
Jul  7 00:51:26 stein kernel: [<ffffffff81299d87>] usb_disconnect+0xa4/0x140
Jul  7 00:51:26 stein kernel: [<ffffffff8129acef>] hub_thread+0x53d/0xe5a
Jul  7 00:51:26 stein kernel: [<ffffffff8134d259>] ? schedule+0x878/0x8b0
Jul  7 00:51:26 stein kernel: [<ffffffff8104b06d>] ? wake_up_bit+0x25/0x25
Jul  7 00:51:26 stein kernel: [<ffffffff8134fd24>] ? _raw_spin_unlock_irqrestore+0x46/0x64
Jul  7 00:51:26 stein kernel: [<ffffffff8129a7b2>] ? hub_probe+0x7f3/0x7f3
Jul  7 00:51:26 stein kernel: [<ffffffff8104acca>] kthread+0x7d/0x85
Jul  7 00:51:26 stein kernel: [<ffffffff81351594>] kernel_thread_helper+0x4/0x10
Jul  7 00:51:26 stein kernel: [<ffffffff8102e4f5>] ? finish_task_switch+0x42/0xbe
Jul  7 00:51:26 stein kernel: [<ffffffff813500c4>] ? retint_restore_args+0xe/0xe
Jul  7 00:51:26 stein kernel: [<ffffffff8104ac4d>] ? __init_kthread_worker+0x56/0x56
Jul  7 00:51:26 stein kernel: [<ffffffff81351590>] ? gs_change+0xb/0xb
Jul  7 00:51:26 stein kernel: INFO: lockdep is turned off.

-- 
Stefan Richter
-=====-==-== -=== --===
http://arcgraph.de/sr/
