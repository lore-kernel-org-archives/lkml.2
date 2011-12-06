Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1LFUTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:19:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1LFUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:19:15 -0500
Date: Tue, 6 Dec 2011 12:18:47 -0800
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-b3d9468a8bd218a695e3a0ff112cd4efd27b670a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1320929850-10480-8-git-send-email-gleb@redhat.com>
References: <1320929850-10480-8-git-send-email-gleb@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Expose perf capability to other modules
Git-Commit-ID: b3d9468a8bd218a695e3a0ff112cd4efd27b670a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:18:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3d9468a8bd218a695e3a0ff112cd4efd27b670a
Gitweb:     http://git.kernel.org/tip/b3d9468a8bd218a695e3a0ff112cd4efd27b670a
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Thu, 10 Nov 2011 14:57:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:41:08 +0100

perf, x86: Expose perf capability to other modules

KVM needs to know perf capability to decide which PMU it can expose to a
guest.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1320929850-10480-8-git-send-email-gleb@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h |   15 +++++++++++++++
 arch/x86/kernel/cpu/perf_event.c  |   12 ++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index c6998bc..b50e9d1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -95,6 +95,15 @@ union cpuid10_edx {
 	unsigned int full;
 };
 
+struct x86_pmu_capability {
+	int		version;
+	int		num_counters_gp;
+	int		num_counters_fixed;
+	int		bit_width_gp;
+	int		bit_width_fixed;
+	unsigned int	events_mask;
+	int		events_mask_len;
+};
 
 /*
  * Fixed-purpose performance events:
@@ -216,6 +225,7 @@ struct perf_guest_switch_msr {
 };
 
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 #else
 static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
@@ -223,6 +233,11 @@ static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 	return NULL;
 }
 
+static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
+{
+	memset(cap, 0, sizeof(*cap));
+}
+
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 55889e0..930fe48 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1696,3 +1696,15 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 	return misc;
 }
+
+void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
+{
+	cap->version		= x86_pmu.version;
+	cap->num_counters_gp	= x86_pmu.num_counters;
+	cap->num_counters_fixed	= x86_pmu.num_counters_fixed;
+	cap->bit_width_gp	= x86_pmu.cntval_bits;
+	cap->bit_width_fixed	= x86_pmu.cntval_bits;
+	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
+	cap->events_mask_len	= x86_pmu.events_mask_len;
+}
+EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
