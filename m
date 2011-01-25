Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1AYIDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:03:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53629 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1AYIDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cgUSSj0I+nonaNWWDYAxnupjMs0GWaXes9jAZBDHrPgo9AARP8NdhDOQ3ovK9qpUyH
         JVahKXJowTy5L/NWp+nbMh1N1WCWh77BNeqHJJM+SHv5fGNU2oYR5fe8v35xpoM9d5CZ
         AQ/B0vuIQoYv3dlKYaW2ouEa18Kv8Nq5UNjSI=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 1/6] set up MSP VPE1 timer.
Date: Tue, 25 Jan 2011 13:49:21 +0530
Message-Id: <1295943561-20000-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

VPE1 timer will be required for MIPS_MT modes ( VSMP / SMTC ).
This patch will setup will setup VPE1 timer irq.This has been
tested with both SMTC and VSMP

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/pmc-sierra/msp71xx/msp_time.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pmc-sierra/msp71xx/msp_time.c b/arch/mips/pmc-sierra/msp71xx/msp_time.c
index 01df84c..b6c2d33 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_time.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_time.c
@@ -36,6 +36,13 @@
 #include <msp_int.h>
 #include <msp_regs.h>
 
+#define get_current_vpe()   \
+	((read_c0_tcbind() >> TCBIND_CURVPE_SHIFT) & TCBIND_CURVPE)
+
+extern struct irqaction c0_compare_irqaction;
+static struct irqaction timer_vpe1;
+static int tim_installed;
+
 void __init plat_time_init(void)
 {
 	char    *endp, *s;
@@ -83,5 +90,11 @@ void __init plat_time_init(void)
 
 unsigned int __cpuinit get_c0_compare_int(void)
 {
-	return MSP_INT_VPE0_TIMER;
+	/* MIPS_MT modes may want timer for second VPE */
+	if ((get_current_vpe()) && !tim_installed) {
+		memcpy(&timer_vpe1, &c0_compare_irqaction, sizeof(timer_vpe1));
+		setup_irq(MSP_INT_VPE1_TIMER, &timer_vpe1);
+		tim_installed++;
+	}
+	return (get_current_vpe() ? MSP_INT_VPE1_TIMER : MSP_INT_VPE0_TIMER);
 }
-- 
1.7.0.4

