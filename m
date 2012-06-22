Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab2FVPjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:39:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47070 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab2FVPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:39:19 -0400
Message-ID: <1340379615.11290.1.camel@lappy>
Subject: RCU hangs in latest linux-next
From: Sasha Levin <levinsasha928@gmail.com>
To: paulmck <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jun 2012 17:40:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

The following tends to happen quite often when I run the trinity fuzzer on a KVM tools guest using latest linux-next:

[  242.223240] INFO: task rcu_bh:14 blocked for more than 120 seconds.
[  242.225587] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.230227] rcu_bh          D 0000000000000000  6424    14      2 0x00000000
[  242.231297]  ffff88000d5a1d50 0000000000000046 ffffffff84a6b020 0000000000000286
[  242.231995]  ffff88000d5a0000 ffff88000d5a0010 ffff88000d5a1fd8 ffff88000d5a0000
[  242.232825]  ffff88000d5a0010 ffff88000d5a1fd8 ffff88000d5b0000 ffff88000d59b000
[  242.233533] Call Trace:
[  242.233752]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.234866]  [<ffffffff836e9355>] schedule+0x55/0x60
[  242.235827]  [<ffffffff811ab3fb>] rcu_gp_kthread+0xfb/0xac0
[  242.236725]  [<ffffffff836eae5b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  242.237905]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.239206]  [<ffffffff8116339d>] ? trace_hardirqs_on+0xd/0x10
[  242.240100]  [<ffffffff836e91bd>] ? __schedule+0x84d/0x880
[  242.241917]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.244162]  [<ffffffff8111b930>] ? wake_up_bit+0x40/0x40
[  242.245998]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.248226]  [<ffffffff8111b102>] kthread+0xb2/0xc0
[  242.250102]  [<ffffffff836ed234>] kernel_thread_helper+0x4/0x10
[  242.251887]  [<ffffffff836eb4b4>] ? retint_restore_args+0x13/0x13
[  242.254243]  [<ffffffff8111b050>] ? __init_kthread_worker+0x70/0x70
[  242.256304]  [<ffffffff836ed230>] ? gs_change+0x13/0x13
[  242.258207] no locks held by rcu_bh/14.
[  242.259523] INFO: task rcu_sched:15 blocked for more than 120 seconds.
[  242.261795] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.264267] rcu_sched       D 0000000000000000  6552    15      2 0x00000000
[  242.266855]  ffff88000d5a3d50 0000000000000046 ffffffff84964020 0000000000000286
[  242.269297]  ffff88000d5a2000 ffff88000d5a2010 ffff88000d5a3fd8 ffff88000d5a2000
[  242.272035]  ffff88000d5a2010 ffff88000d5a3fd8 ffff88000d528000 ffff88000d5b0000
[  242.274263] Call Trace:
[  242.275345]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.277550]  [<ffffffff836e9355>] schedule+0x55/0x60
[  242.279317]  [<ffffffff811ab3fb>] rcu_gp_kthread+0xfb/0xac0
[  242.281129]  [<ffffffff836eae5b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  242.283256]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.292260]  [<ffffffff8116339d>] ? trace_hardirqs_on+0xd/0x10
[  242.292264]  [<ffffffff836e91bd>] ? __schedule+0x84d/0x880
[  242.292268]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.292271]  [<ffffffff8111b930>] ? wake_up_bit+0x40/0x40
[  242.292274]  [<ffffffff811ab300>] ? synchronize_rcu_expedited+0x220/0x220
[  242.292277]  [<ffffffff8111b102>] kthread+0xb2/0xc0
[  242.292280]  [<ffffffff836ed234>] kernel_thread_helper+0x4/0x10
[  242.292283]  [<ffffffff836eb4b4>] ? retint_restore_args+0x13/0x13
[  242.292286]  [<ffffffff8111b050>] ? __init_kthread_worker+0x70/0x70
[  242.292289]  [<ffffffff836ed230>] ? gs_change+0x13/0x13
[  242.292291] no locks held by rcu_sched/15.

