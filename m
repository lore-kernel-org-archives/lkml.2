Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab0LMQv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:51:26 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758132Ab0LMQvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:51:24 -0500
To: mingo@elte.hu
Subject: [PATCH] x86: use native_halt on a halt
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1PSBcz-0001g1-FM@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 13 Dec 2010 10:51:57 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


halt() should use native_halt()
safe_halt() uses native_safe_halt()

If CONFIG_PARAVIRT=y, halt() is defined in arch/x86/include/asm/paravirt.h as

static inline void halt(void)
{
        PVOP_VCALL0(pv_irq_ops.safe_halt);
}

Otherwise (no CONFIG_PARAVIRT) halt() in arch/x86/include/asm/irqflags.h is

static inline void halt(void)
{
        native_halt();
}

So it looks to me like the CONFIG_PARAVIRT case of using native_safe_halt()
for a halt() is an oversight.
Am I missing something?

It probably hasn't shown up as a problem because the local apic is disabled
on a shutdown or restart.  But if we disable interrupts and call halt()
we shouldn't expect that the halt() will re-enable interrupts.

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/kernel/apic/apic.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/include/asm/paravirt.h
===================================================================
--- linux.orig/arch/x86/include/asm/paravirt.h
+++ linux/arch/x86/include/asm/paravirt.h
@@ -112,7 +112,7 @@ static inline void raw_safe_halt(void)
 
 static inline void halt(void)
 {
-	PVOP_VCALL0(pv_irq_ops.safe_halt);
+	PVOP_VCALL0(pv_irq_ops.halt);
 }
 
 static inline void wbinvd(void)
