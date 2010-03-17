Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0CQKoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:44:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:63247 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0CQKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=myK69qAjx6F8pHiQ2UL+A8k2TYi0U+WbA22I64TJXl2B84WLWcRX5y6K2MOBeiX3Zg
         pNSZdqB7yVKhNp989Y7Ne+lz+k3BbP5Mk7fWk8u06cziHnXSKXeDdcTRXMWHx9sj4mGv
         kGiyUhHFKmIDfB4LKc5G9hMLHwHCb2ASJzYNM=
Message-Id: <20100317104356.011052632@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 17 Mar 2010 13:37:00 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/2] x86, apic: Allow to use sertain functions without APIC built-in support
References: <20100317103659.717877821@openvz.org>
Content-Disposition: inline; filename=x86-apic-write-relax
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case even if the kernel is configured so that
no APIC support is built-in we still may allow
to use sertain apic functions as a dummy calls.

In particular we start using it in perf-events code.

Note that this is not that same as NOOP apic driver,
the reverse -- we don't have apic code compiled at all.

CC: H. Peter Anvin <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apic.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -373,6 +373,7 @@ extern atomic_t init_deasserted;
 extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
 #endif
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static inline u32 apic_read(u32 reg)
 {
 	return apic->read(reg);
@@ -403,10 +404,19 @@ static inline u32 safe_apic_wait_icr_idl
 	return apic->safe_wait_icr_idle();
 }
 
+#else /* CONFIG_X86_LOCAL_APIC */
+
+static inline u32 apic_read(u32 reg) { return 0; }
+static inline void apic_write(u32 reg, u32 val) { }
+static inline u64 apic_icr_read(void) { return 0; }
+static inline void apic_icr_write(u32 low, u32 high) { }
+static inline void apic_wait_icr_idle(void) { }
+static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
+
+#endif /* CONFIG_X86_LOCAL_APIC */
 
 static inline void ack_APIC_irq(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * ack_APIC_irq() actually gets compiled as a single instruction
 	 * ... yummie.
@@ -414,7 +424,6 @@ static inline void ack_APIC_irq(void)
 
 	/* Docs say use 0 for future compatibility */
 	apic_write(APIC_EOI, 0);
-#endif
 }
 
 static inline unsigned default_get_apic_id(unsigned long x)

