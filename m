Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0CQKoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:44:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:63247 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0CQKoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=OnzPIzdNbx9iyOwELhmQRswOiBd3j6DEz2I3oA1ip0aWmjO2VJK786Fxr64uY7bxGS
         KNvQvOEV2Ml7T9grdqXzAjZNaOr5vlOOOVy75bJ5gNVDuVeyx3n7fSkh8K6Udj5LAqgK
         ITwQtB4WPplue5G2rmAuFDEaI/laMiyUsdjyI=
Message-Id: <20100317104356.232371479@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 17 Mar 2010 13:37:01 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, fweisbec@gmail.com, acme@redhat.com, eranian@google.com,
       peterz@infradead.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/2] x86, perf: Use apic_write unconditionally
References: <20100317103659.717877821@openvz.org>
Content-Disposition: inline; filename=x86-perf-use-apic-dummy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since apic_write maps to a plain noop in !CONFIG_X86_LOCAL_APIC
case we're safe to remove this conditional compilation
and clean code a bit.

CC: fweisbec@gmail.com
CC: acme@redhat.com
CC: eranian@google.com
CC: peterz@infradead.org
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c    |    4 ----
 arch/x86/kernel/cpu/perf_event_p4.c |    2 --
 2 files changed, 6 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1135,7 +1135,6 @@ void set_perf_event_pending(void)
 
 void perf_events_lapic_init(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	if (!x86_pmu.apic || !x86_pmu_initialized())
 		return;
 
@@ -1143,7 +1142,6 @@ void perf_events_lapic_init(void)
 	 * Always use NMI for PMU
 	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-#endif
 }
 
 static int __kprobes
@@ -1167,9 +1165,7 @@ perf_event_nmi_handler(struct notifier_b
 
 	regs = args->regs;
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-#endif
 	/*
 	 * Can't rely on the handled return value to say it was our NMI, two
 	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -363,10 +363,8 @@ static int p4_pmu_handle_irq(struct pt_r
 	}
 
 	if (handled) {
-#ifdef CONFIG_X86_LOCAL_APIC
 		/* p4 quirk: unmask it again */
 		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
-#endif
 		inc_irq_stat(apic_perf_irqs);
 	}
 

