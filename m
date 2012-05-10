Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab2EJRxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:53:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65132 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757531Ab2EJRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:53:03 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: davinci: turn off DDR PHY when entering deep sleep
Date: Thu, 10 May 2012 19:52:32 +0200
Message-Id: <1336672352-23191-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deepsleep is the most power saving state on the davinci-platform.
The DDR PHY consumes about 25mW and should be turned off in this low
power state.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 arch/arm/mach-davinci/include/mach/memory.h |    2 ++
 arch/arm/mach-davinci/sleep.S               |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/memory.h b/arch/arm/mach-davinci/include/mach/memory.h
index 7873194..1b1b8ac 100644
--- a/arch/arm/mach-davinci/include/mach/memory.h
+++ b/arch/arm/mach-davinci/include/mach/memory.h
@@ -36,6 +36,8 @@
 #define DDR2_MCLKSTOPEN_BIT	BIT(30)
 #define DDR2_LPMODEN_BIT	BIT(31)
 
+#define DDR2_DRPHYC1R_OFFSET 	0xe4
+#define DDR_PWRDNEN_BIT 		BIT(6)
 /*
  * Increase size of DMA-consistent memory region
  */
diff --git a/arch/arm/mach-davinci/sleep.S b/arch/arm/mach-davinci/sleep.S
index 5f1e045..30713b2 100644
--- a/arch/arm/mach-davinci/sleep.S
+++ b/arch/arm/mach-davinci/sleep.S
@@ -57,6 +57,11 @@ ENTRY(davinci_cpu_suspend)
 
 	ldmia	r0, {r0-r4}
 
+	/* Turn PHY off */
+	ldr	ip, [r0, #DDR2_DRPHYC1R_OFFSET]
+	orr	ip, ip, #DDR_PWRDNEN_BIT 	
+	str	ip, [r0, #DDR2_DRPHYC1R_OFFSET]
+
 	/*
 	 * Switch DDR to self-refresh mode.
 	 */
@@ -171,6 +176,11 @@ ENTRY(davinci_cpu_suspend)
 	bic	ip, ip, #DDR2_LPMODEN_BIT
 	str	ip, [r0, #DDR2_SDRCR_OFFSET]
 
+	/* Turn PHY on */
+	ldr	ip, [r0, #DDR2_DRPHYC1R_OFFSET]
+	bic	ip, ip, #DDR_PWRDNEN_BIT 	
+	str	ip, [r0, #DDR2_DRPHYC1R_OFFSET]
+
 	/* Restore registers and return */
 	ldmfd   sp!, {r0-r12, pc}
 
-- 
1.7.5.4

