Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2IMMg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:36:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51696 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2IMMgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:36:24 -0400
MIME-Version: 1.0
Date: Thu, 13 Sep 2012 14:36:23 +0200
Message-ID: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
Subject: RCU lockup in the SMP idle thread, help...
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul et al,

I have this sporadic lockup in the SMP idle thread on ARM U8500:

root@ME:/
root@ME:/
root@ME:/ INFO: rcu_preempt detected stalls on CPUs/tasks: { 0}
(detected by 1, t=23190 jiffies)
[<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c0068624>]
(rcu_check_callbacks+0x69c/0x6e0)
[<c0068624>] (rcu_check_callbacks+0x69c/0x6e0) from [<c0029cbc>]
(update_process_times+0x38/0x4c)
[<c0029cbc>] (update_process_times+0x38/0x4c) from [<c0055088>]
(tick_sched_timer+0x80/0xe4)
[<c0055088>] (tick_sched_timer+0x80/0xe4) from [<c003c120>]
(__run_hrtimer.isra.18+0x44/0xd0)
[<c003c120>] (__run_hrtimer.isra.18+0x44/0xd0) from [<c003cae0>]
(hrtimer_interrupt+0x118/0x2b4)
[<c003cae0>] (hrtimer_interrupt+0x118/0x2b4) from [<c0013658>]
(twd_handler+0x30/0x44)
[<c0013658>] (twd_handler+0x30/0x44) from [<c0063834>]
(handle_percpu_devid_irq+0x80/0xa0)
[<c0063834>] (handle_percpu_devid_irq+0x80/0xa0) from [<c00601ec>]
(generic_handle_irq+0x2c/0x40)
[<c00601ec>] (generic_handle_irq+0x2c/0x40) from [<c000ef58>]
(handle_IRQ+0x4c/0xac)
[<c000ef58>] (handle_IRQ+0x4c/0xac) from [<c00084bc>] (gic_handle_irq+0x24/0x58)
[<c00084bc>] (gic_handle_irq+0x24/0x58) from [<c000dc80>] (__irq_svc+0x40/0x70)
Exception stack(0xcf851f88 to 0xcf851fd0)
1f80:                   00000020 c05d5920 00000001 00000000 cf850000 cf850000
1fa0: c05f4d48 c02de0b4 c05d8d90 412fc091 cf850000 00000000 01000000 cf851fd0
1fc0: c000f234 c000f238 60000013 ffffffff
[<c000dc80>] (__irq_svc+0x40/0x70) from [<c000f238>] (default_idle+0x28/0x30)
[<c000f238>] (default_idle+0x28/0x30) from [<c000f438>] (cpu_idle+0x98/0xe4)
[<c000f438>] (cpu_idle+0x98/0xe4) from [<002d2ef4>] (0x2d2ef4)

The hangup has been there in the v3.6-rc series for a while (probably
since the merge window).

I haven't been able to bisect out why this is happening, because the bug
is pretty hazardous to check - you have to boot the system and leave it alone
or use it sporadically for a while. Then all of a sudden it happens.

So: reproducible, but not deterministically reproducible (I hate this kind
of thing...)

The code involved seems to be generic kernel code apart from the
ARM GIC and TWD timer drivers.

Any hints or debug options I should switch on?

Yours,
Linus Walleij
