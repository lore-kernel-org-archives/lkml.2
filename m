Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab1D1Nbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:31:42 -0400
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:61117 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802Ab1D1Nbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:31:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0oABlsuU1UXebr/2dsb2JhbACCNIJfkz6NL3eyYQKHTYkXDoVoBJJwglyHGQ
Subject: mutex deadlock in w1/slaves/w1_ds2760
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <johnpol@2ka.mipt.ru>
Date: Thu, 28 Apr 2011 13:31:37 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.38 x86_64 [http://email.cleancode.org])
Message-Id: <E1QFRJi-0003wk-Dm@outmx07.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a mutex deadlock in w1/slaves/w1_ds2760. The deadlock is intermittent in linux-2.6.39-rc4 (as though a race condition) but seems consistent in linux-2.6.39-rc5. The platform is an iPAQ hx4700 (XScale-PXA270).

I can demonstrate the deadlock by adding some printk() calls, replacing the mutex_lock() call in w1_ds2760_io() with mutex_trylock(), and dumping the stack trace if mutex_trylock() fails.

Here's the dmesg output:

w1_process: mutex_lock(0xc3921e68)
w1_ds2760_io: mutex_trylock(0xc3921e68)
 [<c0023c44>] save_stack_trace_tsk+0x0/0xc4
 [<c0023d2c>] save_stack_trace+0x24/0x28
 [<c0193d58>] w1_ds2760_io+0x12c/0x144
 [<c0193db0>] w1_ds2760_read+0x1c/0x24
 [<c0195ed0>] ds2760_battery_read_status+0x3c/0x31c
 [<c0196418>] ds2760_battery_probe+0xb0/0x26c
 [<c015fff0>] platform_drv_probe+0x1c/0x20
 [<c015eb74>] driver_probe_device+0x88/0x18c
 [<c015ed58>] __device_attach+0x48/0x4c
 [<c015e05c>] bus_for_each_drv+0x6c/0x94
 [<c015edec>] device_attach+0x64/0x7c
 [<c015de58>] bus_probe_device+0x30/0x50
 [<c015c630>] device_add+0x4ec/0x5cc
 [<c0160654>] platform_device_add+0x100/0x198
 [<c0193b0c>] w1_ds2760_add_slave+0x90/0xfc
 [<c0191548>] w1_attach_slave_device+0x1a4/0x370
 [<c019186c>] w1_slave_found+0x158/0x15c
 [<c0193750>] ds1wm_search+0xd8/0xdc
 [<c0192d88>] w1_search_devices+0x44/0x50
 [<c0191dcc>] w1_search_process+0x5c/0xf0
 [<c0191f54>] w1_process+0xf4/0x120
 [<c004b9e4>] kthread+0x90/0x98
 [<c003563c>] do_exit+0x0/0x6e8
 [<ffffffff>] 0xffffffff
w1_process: mutex_unlock(0xc3921e68)

Explanation:

1. w1_process() locks the mutex at 0xc3921e68.
2. w1_ds2760_io() locks the same mutex at 0xc3921e68 and thus mutex_trylock() fails.
3. stack trace showing the function path from w1_process() to w1_ds2760_io().
4. w1_process() unlocks the mutex at 0xc3921e68.

