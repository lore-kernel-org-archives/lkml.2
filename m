Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0CRRiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:38:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:57636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0CRRh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:37:57 -0400
Date: Thu, 18 Mar 2010 17:37:27 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100317104356.011052632@openvz.org>
References: <20100317104356.011052632@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, apic: Allow to use certain functions without APIC built-in support
Message-ID: <tip-d674cd1963129b70bc5f631c51fb30fb73213fb2@git.kernel.org>
Git-Commit-ID: d674cd1963129b70bc5f631c51fb30fb73213fb2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 17:37:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d674cd1963129b70bc5f631c51fb30fb73213fb2
Gitweb:     http://git.kernel.org/tip/d674cd1963129b70bc5f631c51fb30fb73213fb2
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 17 Mar 2010 13:37:00 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 17:03:21 +0100

x86, apic: Allow to use certain functions without APIC built-in support

In case even if the kernel is configured so that
no APIC support is built-in we still may allow
to use certain apic functions as dummy calls.

In particular we start using it in perf-events code.

Note that this is not that same as NOOP apic driver (which
is used if APIC support is present but no physical APIC is
available), this is for the case when we don't have apic code
compiled in at all.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20100317104356.011052632@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b4ac2cd..1fa03e0 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -373,6 +373,7 @@ extern atomic_t init_deasserted;
 extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
 #endif
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static inline u32 apic_read(u32 reg)
 {
 	return apic->read(reg);
@@ -403,10 +404,19 @@ static inline u32 safe_apic_wait_icr_idle(void)
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
