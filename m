Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2CWMCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:02:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2CWMCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:02:11 -0400
Message-ID: <1332504120.16159.17.camel@twins>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 13:02:00 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05D65B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
	 <1332332739.18960.488.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05C092@SHSMSX101.ccr.corp.intel.com>
	 <1332498333.16159.9.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05D65B@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 11:32 +0000, Liu, Chuansheng wrote:
> In fact, I started two scripts running:
> 1/ One script:
> echo 0 > /sys/devices/system/cpuX/online
> echo 1 > /sys/devices/system/cpuX/online
> Rerunning the above commands in loop
> 
> 2/Another script:
> echo 1 > /debug/smp_call_test
> usleep 50000
> Rerunning the above command in loop
> 
> This race issue can be easy to be reproduced in several minutes;
> For simplify your test as mine(just two CPUs), you can set other non-booting CPUs as offline
> at first and just leave one non-booting CPU.

So this is exactly what I did and it ran for 30+ minutes without fail. I
found I forgot to log the serial output so I just re-ran this to make
sure. 10+ minutes and not a single WARN in the console output.

If I pop my change to select_fallback_rq() I can indeed trigger this:

------------[ cut here ]------------
WARNING: at /usr/src/linux-2.6/arch/x86/kernel/smp.c:120
native_smp_send_reschedule+0x5b/0x60()
Hardware name: X8DTN
Modules linked in: [last unloaded: scsi_wait_scan]
Pid: 1542, comm: abrtd Not tainted 3.3.0-01725-gd6eb054-dirty #63
Call Trace:
 <IRQ>  [<ffffffff810775df>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8107763a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8105f79b>] native_smp_send_reschedule+0x5b/0x60
 [<ffffffff810aa67a>] try_to_wake_up+0x1fa/0x2c0
 [<ffffffff810acaec>] ? sched_slice.isra.38+0x5c/0x90
 [<ffffffff810aa795>] wake_up_process+0x15/0x20
 [<ffffffff81085c6e>] process_timeout+0xe/0x10
 [<ffffffff81086cb3>] run_timer_softirq+0x143/0x460
 [<ffffffff81384a94>] ? timerqueue_add+0x74/0xc0
 [<ffffffff81085c60>] ? usleep_range+0x50/0x50
 [<ffffffff8107e81d>] __do_softirq+0xbd/0x290
 [<ffffffff810c5e64>] ? clockevents_program_event+0x74/0x100
 [<ffffffff810c72d4>] ? tick_program_event+0x24/0x30
 [<ffffffff8194ba4c>] call_softirq+0x1c/0x30
 [<ffffffff810433d5>] do_softirq+0x55/0x90
 [<ffffffff8107ed2e>] irq_exit+0x9e/0xe0
 [<ffffffff8194c07e>] smp_apic_timer_interrupt+0x6e/0x99
 [<ffffffff8194b107>] apic_timer_interrupt+0x67/0x70
 <EOI> 
---[ end trace d2b2cbf78c1ddd2e ]---


But let me re-run with the select_fallback_rq() change and let it run
for several hours while I go play outside.. 
