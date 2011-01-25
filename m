Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1AYRv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:51:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47627 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AYRv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:51:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pr5ZosMf8wH202amML3UrYge8IecAxXytlGgiKJZSDMh+xciqNBz5zjkNhRWFFweEu
         mebgyckTUGDmL4WO6V4+Gy+k+eK9zECP/GKGnjjmJv1jQrqlpvb1cL0mlP0Ay1GKivfN
         lOjgSFsU8LM1Uxpz6h7+7eTp5+EwXaqW7gPdk=
Subject: [PATCH v1 1/6] set up MSP VPE1 timer.
From: Anoop P A <anoop.pa@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295943561-20000-1-git-send-email-anoop.pa@gmail.com>
References: <1295943561-20000-1-git-send-email-anoop.pa@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 23:38:16 +0530
Message-ID: <1295978896.27661.567.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since original:
Corrected repeated word in comment
---
VPE1 timer will be required for MIPS_MT modes ( VSMP / SMTC ).
This patch will setup VPE1 timer irq.This has been tested with
both SMTC and VSMP

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/pmc-sierra/msp71xx/msp_time.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pmc-sierra/msp71xx/msp_time.c
b/arch/mips/pmc-sierra/msp71xx/msp_time.c
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

