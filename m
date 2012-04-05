Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2DEEG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:06:56 -0400
Received: from mail4.comsite.net ([205.238.176.238]:41196 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2DEEGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:06:55 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Sasha Levin <levinsasha928@gmail.com>
Message-Id: <smp-call-function-lockup-1@mdm.bga.com>
In-Reply-To: <CA+1xoqeqyFT0eHS2k+vskPFQ-5gJ_Uq1HVsq2DA2sS1uN9C0vw@mail.gmail.com>
References: <CA+1xoqeqyFT0eHS2k+vskPFQ-5gJ_Uq1HVsq2DA2sS1uN9C0vw@mail.gmail.com>
Subject: CPU softlockup due to smp_call_function()
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Dave Jones <davej@redhat.com>, <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Date: Wed, 04 Apr 2012 23:06:54 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Apr 2012 about 22:12:36 +0200, Sasha Levin wrote:
> I've starting seeing soft lockups resulting from smp_call_function()
> calls. I've attached two different backtraces of this happening with
> different code paths.
> 
> This is running inside a KVM guest with the trinity fuzzer, using
> today's linux-next kernel.

Hi Sasha.

You have two different call sites (arch/x86/mm/pageattr.c
cpa_flush_range and net/core/dev.c netdev_run_todo), and both use
call on_each_cpu with wait=1.

I tried a few options but can't get close enough to your compiled
length of 2a0 to know if the code is spinning on the first
csd_lock_wait in csd_lock or in the second csd_lock_wait after the
call to arch_send_call_function_ipi_mask (aka smp_ops + 0x44 in my
x86_64 compile).  Please check your disassembly and report.

If its the first lock, then the current stack is an innocent victim.
In either case we need to find what the cpu(s) holding up the reporting
cpus call function data (cfd_data per_cpu var) is(are) doing.

Since interrupts are on, we could read the time at entry (even jiffies)
and report both the function and mask of cpus that have not processed
the cpus entry if the elapsed time has exceeded some threshold.

I described the call flow of smp_call_function_many and outlined some
debug sanity checks that could be added at [1] if you suspect the function
list is getting corrupted.

Let me know if you need help creating this debug code.

[1] https://lkml.org/lkml/2012/1/13/308

milton
