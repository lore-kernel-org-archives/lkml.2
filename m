Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1F1PJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:09:57 -0400
Received: from service87.mimecast.com ([94.185.240.25]:59753 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758466Ab1F1PIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:08:47 -0400
Message-ID: <4E09EE75.9040204@arm.com>
Date: Tue, 28 Jun 2011 16:08:37 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [next][bug] rcu_dyntick_kick_cpu() kills ARM SMP.
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 28 Jun 2011 15:08:42.0471 (UTC) FILETIME=[44A91770:01CC35A5]
X-MC-Unique: 111062816084400401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I've updated my -next tree (to next-20110628) today, and discovered 
that my favorite ARM board wouldn't boot anymore:

[...]
Hierarchical RCU implementation.
NR_IRQS:128 nr_irqs:128 128
Console: colour dummy device 80x30
Calibrating delay loop... 83.35 BogoMIPS (lpj=416768)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
Calibrating local timer... 104.04MHz.
CPU1: Booted secondary processor
CPU1: Unknown IPI message 0x1
CPU2: Booted secondary processor
CPU2: Unknown IPI message 0x1
CPU3: Booted secondary processor
CPU3: Unknown IPI message 0x1
Brought up 4 CPUs
SMP: Total of 4 processors activated (333.92 BogoMIPS).
------------[ cut here ]------------
WARNING: at kernel/smp.c:320 smp_call_function_single+0xe4/0x1c0()
NET: Registered protocol family 16
Modules linked in:
[<c00415d4>] (unwind_backtrace+0x0/0xf4) from [<c0056184>] (warn_slowpath_common+0x4c/0x64)
[<c0056184>] (warn_slowpath_common+0x4c/0x64) from [<c00561b8>] (warn_slowpath_null+0x1c/0x24)
[<c00561b8>] (warn_slowpath_null+0x1c/0x24) from [<c0088218>] (smp_call_function_single+0xe4/0x1c0)
[<c0088218>] (smp_call_function_single+0xe4/0x1c0) from [<c0094804>] (rcu_start_gp+0x184/0x310)
[<c0094804>] (rcu_start_gp+0x184/0x310) from [<c00955b0>] (__rcu_process_callbacks+0x274/0x398)
[<c00955b0>] (__rcu_process_callbacks+0x274/0x398) from [<c0095708>] (rcu_process_callbacks+0x34/0x5c)
[<c0095708>] (rcu_process_callbacks+0x34/0x5c) from [<c005c964>] (__do_softirq+0xa4/0x16c)
[<c005c964>] (__do_softirq+0xa4/0x16c) from [<c005cc0c>] (irq_exit+0x80/0x9c)
[<c005cc0c>] (irq_exit+0x80/0x9c) from [<c00353cc>] (do_local_timer+0x54/0x70)
[<c00353cc>] (do_local_timer+0x54/0x70) from [<c003b618>] (__irq_svc+0x38/0xc0)
Exception stack(0xdf467f90 to 0xdf467fd8)
7f80:                                     df466000 00000000 df467fd8 00000000
7fa0: df466000 c045dd24 c034f6cc 00000000 c0445514 410fb020 70409ddc 00000000
7fc0: 00000000 df467fd8 c003c4ac c003c4b0 60000013 ffffffff
[<c003b618>] (__irq_svc+0x38/0xc0) from [<c003c4b0>] (default_idle+0x24/0x28)
[<c003c4b0>] (default_idle+0x24/0x28) from [<c003ccd0>] (cpu_idle+0x9c/0xdc)
[<c003ccd0>] (cpu_idle+0x9c/0xdc) from [<70348734>] (0x70348734)
---[ end trace 1b75b31a2719ed1c ]---

... and here it dies.

The offending commit is b983032b7 (rcu: Avoid grace-period overflow for 
long dyntick-idle periods). rcu_dyntick_kick_cpu() tries to do a CPU 
cross-call with interrupts disabled, which kills the box. Reverting this
patch results in a working system.

My RCU-foo being rather low, I haven't dug deeper into this. Please let
me know if you want me to test anything.

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

