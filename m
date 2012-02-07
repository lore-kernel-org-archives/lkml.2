Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2BGMJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:09:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47686 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab2BGMJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:09:00 -0500
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Venki Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86, AMD: Set sched_clock_stable
Date: Tue,  7 Feb 2012 13:08:52 +0100
Message-Id: <1328616532-13783-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120207095000.GF15359@elte.hu>
References: <20120207095000.GF15359@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian reported that doing a scheduler latency measurements
with perf on AMD doesn't work out as expected due to the fact that the
sched_clock() granularity is too coarse, i.e. done in jiffies due to the
sched_clock_stable not set, which, if set, would mean that we get to use
the TSC as sample source which would give us much higher precision.

However, there's no reason not to set sched_clock_stable on AMD because
all families from F10h and upwards do have an invariant TSC and have the
CPUID flag to prove (CPUID_8000_0007_EDX[8]).

Make it so, #1.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/20120206132546.GA30854@quad
---
 arch/x86/kernel/cpu/amd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f4773f4..0a44b90 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
@@ -456,6 +457,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		if (!check_tsc_unstable())
+			sched_clock_stable = 1;
 	}
 
 #ifdef CONFIG_X86_64
-- 
1.7.9

