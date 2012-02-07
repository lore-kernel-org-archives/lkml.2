Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2BGToG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:44:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2BGToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:44:03 -0500
Date: Tue, 7 Feb 2012 11:43:18 -0800
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-c98fdeaa92731308ed80386261fa2589addefa47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com, andreas.herrmann3@amd.com,
        peterz@infradead.org, bp@amd64.org, bp@alien8.de,
        robert.richter@amd.com, acme@infradead.org, tglx@linutronix.de,
        mingo@elte.hu, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        andreas.herrmann3@amd.com, peterz@infradead.org, bp@alien8.de,
        bp@amd64.org, robert.richter@amd.com, acme@infradead.org,
        tglx@linutronix.de, venki@google.com, mingo@elte.hu
In-Reply-To: <20120206132546.GA30854@quad>
References: <20120206132546.GA30854@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/sched/perf/AMD: Set sched_clock_stable
Git-Commit-ID: c98fdeaa92731308ed80386261fa2589addefa47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:43:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c98fdeaa92731308ed80386261fa2589addefa47
Gitweb:     http://git.kernel.org/tip/c98fdeaa92731308ed80386261fa2589addefa47
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Tue, 7 Feb 2012 13:08:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Feb 2012 13:12:08 +0100

x86/sched/perf/AMD: Set sched_clock_stable

Stephane Eranian reported that doing a scheduler latency
measurements with perf on AMD doesn't work out as expected due
to the fact that the sched_clock() granularity is too coarse,
i.e. done in jiffies due to the sched_clock_stable not set,
which, if set, would mean that we get to use the TSC as sample
source which would give us much higher precision.

However, there's no reason not to set sched_clock_stable on AMD
because all families from F10h and upwards do have an invariant
TSC and have the CPUID flag to prove (CPUID_8000_0007_EDX[8]).

Make it so, #1.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20120206132546.GA30854@quad
[ Should any non-standard system break the TSC, we should
  mark them so explicitly, in their platform init handler, or
  in a DMI quirk. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
