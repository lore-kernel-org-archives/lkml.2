Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1HPWLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 18:11:20 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:29904
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab1HPWLS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 18:11:18 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzc89bh146fK1432N98dKzz1202hzz8275bh8275dhz32i668h839h93fh64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQ1KAL-01-2MA-02
X-M-MSG: 
Date: Wed, 17 Aug 2011 00:11:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] oprofile, x86: Fix overflow and warning (commit 1d12d35)
Message-ID: <20110816221108.GB11702@erda.amd.com>
References: <4E35A14E.90702@gmail.com>
 <20110801070742.GA11795@erda.amd.com>
 <4E36C18B.7050502@gmail.com>
 <20110801213142.GE11795@erda.amd.com>
 <20110801214130.GF27083@one.firstfloor.org>
 <20110801221625.GF11795@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20110801221625.GF11795@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.11 00:16:25, Robert Richter wrote:
> On 01.08.11 17:41:30, Andi Kleen wrote:
> > And what happens when the CPU reports more than 32 counters?
> > You have a silent buffer overflow then.
> 
> From the layout of IA32_PERF_GLOBAL_CTRL MSR it seems to be limited to
> 32. Anyway, if there might be cpus out soon with more than 32 counters
> we can either extend the array to 256 or limit the counters used to 32.

See my patch below.

-Robert


>From 298557db42eb2d6efca81669dc369425b46c5be6 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 16 Aug 2011 23:39:53 +0200
Subject: [PATCH] oprofile, x86: Fix overflow and warning (commit 1d12d35)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Following fixes for:

 1d12d35 oprofile, x86: Convert memory allocation to static array

Fix potential buffer overflow.

Fix the following warning:

 arch/x86/oprofile/op_model_ppro.c: In function ‘ppro_check_ctrs’:
 arch/x86/oprofile/op_model_ppro.c:143: warning: label ‘out’ defined but not used

Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_ppro.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 608874b..d90528e 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -140,7 +140,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 	}
 
-out:
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
 	 * doesn't hurt other P6 variant */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
@@ -220,7 +219,7 @@ static void arch_perfmon_setup_counters(void)
 		eax.split.bit_width = 40;
 	}
 
-	num_counters = eax.split.num_counters;
+	num_counters = min((int)eax.split.num_counters, OP_MAX_COUNTER);
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
-- 
1.7.5.3



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

