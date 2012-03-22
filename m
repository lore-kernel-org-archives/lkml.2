Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2CVCZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:25:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36667 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2CVCZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:25:23 -0400
Message-ID: <1332383117.13011.3.camel@phoenix>
Subject: [PATCH] mfd: rc5t583: Improve readability of volatile_reg function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 22 Mar 2012 10:25:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, we have some duplicate entries in current code:
RC5T583_GPIO_GPEDGE1, RC5T583_GPIO_GPEDGE2, RC5T583_GPIO_EN_INT are also in the
range of ((reg >= RC5T583_GPIO_IOSEL) && (reg <= RC5T583_GPIO_GPOFUNC)).

Let's just list the cases to return false in volatile_reg function.
Otherwise, the default is to return true.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/rc5t583.c |   33 +++++++++------------------------
 1 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 99ef944..ad2c204 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -241,32 +241,17 @@ static bool volatile_reg(struct device *dev, unsigned int reg)
 	case RC5T583_INT_EN_ADC1:
 	case RC5T583_INT_EN_ADC2:
 	case RC5T583_INT_EN_ADC3:
-	case RC5T583_GPIO_GPEDGE1:
-	case RC5T583_GPIO_GPEDGE2:
-	case RC5T583_GPIO_EN_INT:
+	/* Enable caching in gpio registers, except RC5T583_GPIO_MON_IOIN which
+	 * is gpio input register */
+	case RC5T583_GPIO_IOSEL ... RC5T583_GPIO_EN_INT:
+	case RC5T583_GPIO_GPOFUNC:
+	/* Enable caching in sleep seq registers */
+	case RC5T583_SLPSEQ1 ... RC5T583_SLPSEQ11:
+	/* Enable caching of regulator registers */
+	case RC5T583_REG_DC0CTL ... RC5T583_REG_SR3CTL:
+	case RC5T583_REG_LDOEN1 ... RC5T583_REG_LDO9DAC_DS:
 		return false;
-
-	case RC5T583_GPIO_MON_IOIN:
-		/* This is gpio input register */
-		return true;
-
 	default:
-		/* Enable caching in gpio registers */
-		if ((reg >= RC5T583_GPIO_IOSEL) &&
-				(reg <= RC5T583_GPIO_GPOFUNC))
-			return false;
-
-		/* Enable caching in sleep seq registers */
-		if ((reg >= RC5T583_SLPSEQ1) && (reg <= RC5T583_SLPSEQ11))
-			return false;
-
-		/* Enable caching of regulator registers */
-		if ((reg >= RC5T583_REG_DC0CTL) && (reg <= RC5T583_REG_SR3CTL))
-			return false;
-		if ((reg >= RC5T583_REG_LDOEN1) &&
-					(reg <= RC5T583_REG_LDO9DAC_DS))
-			return false;
-
 		break;
 	}
 
-- 
1.7.5.4



