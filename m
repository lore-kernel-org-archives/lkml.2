Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0CRRiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:38:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:55026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0CRRiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:38:21 -0400
Date: Thu, 18 Mar 2010 17:37:45 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100317104356.232371479@openvz.org>
References: <20100317104356.232371479@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Use apic_write unconditionally
Message-ID: <tip-7335f75e9ca166044e38a96abad422d8e6e364b5@git.kernel.org>
Git-Commit-ID: 7335f75e9ca166044e38a96abad422d8e6e364b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 17:37:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7335f75e9ca166044e38a96abad422d8e6e364b5
Gitweb:     http://git.kernel.org/tip/7335f75e9ca166044e38a96abad422d8e6e364b5
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 17 Mar 2010 13:37:01 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 17:03:22 +0100

x86, perf: Use apic_write unconditionally

Since apic_write() maps to a plain noop in the !CONFIG_X86_LOCAL_APIC
case we're safe to remove this conditional compilation and clean up
the code a bit.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: fweisbec@gmail.com
Cc: acme@redhat.com
Cc: eranian@google.com
Cc: peterz@infradead.org
LKML-Reference: <20100317104356.232371479@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c    |    4 ----
 arch/x86/kernel/cpu/perf_event_p4.c |    2 --
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c97d5b5..14eca80 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1136,7 +1136,6 @@ void set_perf_event_pending(void)
 
 void perf_events_lapic_init(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	if (!x86_pmu.apic || !x86_pmu_initialized())
 		return;
 
@@ -1144,7 +1143,6 @@ void perf_events_lapic_init(void)
 	 * Always use NMI for PMU
 	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-#endif
 }
 
 static int __kprobes
@@ -1168,9 +1166,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-#endif
 	/*
 	 * Can't rely on the handled return value to say it was our NMI, two
 	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index a11ce73..0367889 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -363,10 +363,8 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	}
 
 	if (handled) {
-#ifdef CONFIG_X86_LOCAL_APIC
 		/* p4 quirk: unmask it again */
 		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
-#endif
 		inc_irq_stat(apic_perf_irqs);
 	}
 
