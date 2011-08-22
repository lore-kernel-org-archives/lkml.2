Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1HVPGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:06:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38781 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1HVPF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:05:59 -0400
MIME-Version: 1.0
Date: Mon, 22 Aug 2011 08:05:58 -0700
Message-ID: <CAK3+h2z-wxhgNsS1OYfJRJ7oWch6o3KM=Jcq0LXFUKvLc_j24w@mail.gmail.com>
Subject: Add dump_stack in softdog doesn't dump "current" process stack trace
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to add dump_stack() in softdog like below:

100 static void watchdog_fire(unsigned long data)
101 {
102         if (test_and_clear_bit(0, &orphan_timer))
103                 module_put(THIS_MODULE);
104
105         if (soft_noboot)
106                 printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
107         else if (soft_panic) {
108                 printk(KERN_CRIT PFX "Initiating panic.\n");
109                 panic("Software Watchdog Timer expired.");
110         } else {
111                 printk(KERN_CRIT PFX "Initiating system reboot.\n");
                      dump_stack(); <--------add here to dump current
process call trace before restart
112                 emergency_restart();
113                 printk(KERN_CRIT PFX "Reboot didn't ?????\n");
114         }
115 }

I would like to see the stack trace of current process right before
emergency_restart to see what is going on in the user mode current
process to find clue what triggers the softdog timer out. I run a
stress program to trigger softdog timer out and see stack trace below:

#stress --cpu 1000 --io 1000 --vm 1000 --hdd 1000 --vm-bytes 128M --timeout 300s

 stress: info: [12774] dispatching hogs: 1000 cpu, 1000 io, 1000 vm, 1000 hdd

SoftDog: Initiating system reboot.

Call Trace:
 <IRQ>  [<ffffffff882ce22e>] :softdog:watchdog_fire+0x8b/0xa0
 [<ffffffff80090175>] run_timer_softirq+0x133/0x1af
 [<ffffffff80010558>] __do_softirq+0x5e/0xd6
 [<ffffffff8005a2fc>] call_softirq+0x1c/0x28
 [<ffffffff80068863>] do_softirq+0x2c/0x85
 [<ffffffff80059c8e>] apic_timer_interrupt+0x66/0x6c
 <EOI>

I am hoping that dump_stack will dump call trace of stress program,
but instead, it dumps kernel function that kicks of watchdog_fire in
softdog which isn't really that helpful to find out what user land
process to cause the softdog timer out. do you have better idea how I
can do this.

Thanks

Vincent
