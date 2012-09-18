Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab2IRIYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:24:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2IRIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:24:13 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Qin Rui <qinrui@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] unicore32: pwm: Properly remap memory-mapped registers
Date: Tue, 18 Sep 2012 10:23:49 +0200
Message-Id: <1347956633-15667-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:T83zC6Q1UNXB/eQnQyt0ewC5m2rCYX5lf/pu2/gBYKk
 EbtjMfX4Ith0dmXy9tJsU0v42UPHLYmV5cokVnISMBsLKidexj
 Ua49gvwaUTXecHZiHZbikAm8+kplhZC6Gs8U5oI9bXRK79Nna2
 ElEKqAvFr6aC11VigcyWwnr2angpwkHgVBNkjViPhsjM/mGStU
 yZKC20esP/t3DGUXjdo+p/gAovTV8eJPntJ5y1IgGivabZB2af
 cCxhB0FAvCtZUmaLgpmNqIiqAnXhWpWpK44jJGQxYBmy+I+YQ7
 rDOdy6aHA1wGepQPR+mQZX6u3gfA77UM3hcdXQa4rGGSjgtYqv
 7DVeS8a2i/pyNq5/YjjM6IcGqWu30Mi6V9H0kEXf0WcHxDfqdt
 XDYco1fpWExss/zyrk2WbwpTKSIZiHqeSsizxSTPA/8qI6LTCP
 cJ750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of writing to the timer controller registers by dereferencing a
pointer to the memory location, properly remap the memory region with a
call to ioremap_nocache() and access the registers using writel().

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
---
 arch/unicore32/include/mach/regs-ost.h | 18 ++++++++----------
 arch/unicore32/kernel/pwm.c            | 21 ++++++++++++++++++---
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/unicore32/include/mach/regs-ost.h b/arch/unicore32/include/mach/regs-ost.h
index 7b91fe6..4a85fb4 100644
--- a/arch/unicore32/include/mach/regs-ost.h
+++ b/arch/unicore32/include/mach/regs-ost.h
@@ -33,18 +33,16 @@
  * Interrupt Enable Reg OST_OIER
  */
 #define OST_OIER	(PKUNITY_OST_BASE + 0x001C)
+
 /*
- * PWM Pulse Width Control Reg OST_PWMPWCR
- */
-#define OST_PWMPWCR	(PKUNITY_OST_BASE + 0x0080)
-/*
- * PWM Duty Cycle Control Reg OST_PWMDCCR
- */
-#define OST_PWMDCCR	(PKUNITY_OST_BASE + 0x0084)
-/*
- * PWM Period Control Reg OST_PWMPCR
+ * PWM Registers: IO base address: PKUNITY_OST_BASE + 0x80
+ *      PWCR: Pulse Width Control Reg
+ *      DCCR: Duty Cycle Control Reg
+ *      PCR: Period Control Reg
  */
-#define OST_PWMPCR	(PKUNITY_OST_BASE + 0x0088)
+#define OST_PWM_PWCR	(0x00)
+#define OST_PWM_DCCR	(0x04)
+#define OST_PWM_PCR 	(0x08)
 
 /*
  * Match detected 0 OST_OSSR_M0
diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
index 4615d51..885bbcd 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -27,6 +27,8 @@ struct pwm_device {
 	struct list_head	node;
 	struct platform_device *pdev;
 
+	void __iomem	*base;
+
 	const char	*label;
 	struct clk	*clk;
 	int		clk_enabled;
@@ -69,9 +71,11 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	 * before writing to the registers
 	 */
 	clk_enable(pwm->clk);
-	OST_PWMPWCR = prescale;
-	OST_PWMDCCR = pv - dc;
-	OST_PWMPCR  = pv;
+
+	writel(prescale, pwm->base + OST_PWM_PWCR);
+	writel(pv - dc, pwm->base + OST_PWM_DCCR);
+	writel(pv, pwm->base + OST_PWM_PCR);
+
 	clk_disable(pwm->clk);
 
 	return 0;
@@ -190,10 +194,19 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 		goto err_free_clk;
 	}
 
+	pwm->base = ioremap_nocache(r->start, resource_size(r));
+	if (pwm->base == NULL) {
+		dev_err(&pdev->dev, "failed to remap memory resource\n");
+		ret = -EADDRNOTAVAIL;
+		goto err_release_mem;
+	}
+
 	__add_pwm(pwm);
 	platform_set_drvdata(pdev, pwm);
 	return pwm;
 
+err_release_mem:
+	release_mem_region(r->start, resource_size(r));
 err_free_clk:
 	clk_put(pwm->clk);
 err_free:
@@ -224,6 +237,8 @@ static int __devexit pwm_remove(struct platform_device *pdev)
 	list_del(&pwm->node);
 	mutex_unlock(&pwm_lock);
 
+	iounmap(pwm->base);
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
 
-- 
1.7.12

