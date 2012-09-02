Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2IBKVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:21:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2IBKVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:21:20 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] unicore32: pwm: Properly remap memory-mapped registers
Date: Sun,  2 Sep 2012 12:21:08 +0200
Message-Id: <1346581273-7041-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:SJ48zthq5+uS9EX5SSKdu48iC9Nmhz/5I8wMvsoexcM
 DBKhvas/31P3SpSPJT6SyLlJs/glMxE97lhccdUuFj3dl/MO9j
 fkQ4LWEYMoynwOTfETowT2gvB3/B4Tpmv3SOZ8mZEHcgtTAqlb
 rvsGHhMbMYrSthHBRYtb52dL/hWI5polG9p7XNwP/BDqKRvIpB
 tldndRLp1xDUsXSov4OmPoNjP2gKdg7PCUdBwXE/3oq35IIiWg
 tqofrEt8BEPwXqOlLQlAN1TQwuHnx9FYlaUHoGKsuLcdo4AE+h
 4sS3wlRLXqw+BEBIT2yMxpqunlYxfYt0ErUIQBZHTb8tQEg3Rv
 wDvuG/+Khjt77hdFOtMBSFdUUefCqdMyQznSSWgwDI3gj7kD/W
 KcPr8Z9qeES9jxazbmkZJPMBNW1fGVnjwBf5AIOSyxV2Cf5DZx
 YpsM5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of writing to the timer controller registers by dereferencing a
pointer to the memory location, properly remap the memory region with a
call to ioremap_nocache() and access the registers using writel().

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/unicore32/kernel/pwm.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
index 4615d51..410b786 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -23,10 +23,16 @@
 #include <asm/div64.h>
 #include <mach/hardware.h>
 
+#define PWCR 0x00
+#define DCCR 0x04
+#define PCR  0x08
+
 struct pwm_device {
 	struct list_head	node;
 	struct platform_device *pdev;
 
+	void __iomem	*base;
+
 	const char	*label;
 	struct clk	*clk;
 	int		clk_enabled;
@@ -69,9 +75,11 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 	 * before writing to the registers
 	 */
 	clk_enable(pwm->clk);
-	OST_PWMPWCR = prescale;
-	OST_PWMDCCR = pv - dc;
-	OST_PWMPCR  = pv;
+
+	writel(prescale, pwm->base + PWCR);
+	writel(pv - dc, pwm->base + DCCR);
+	writel(pv, pwm->base + PCR);
+
 	clk_disable(pwm->clk);
 
 	return 0;
@@ -190,10 +198,19 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
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
@@ -224,6 +241,8 @@ static int __devexit pwm_remove(struct platform_device *pdev)
 	list_del(&pwm->node);
 	mutex_unlock(&pwm_lock);
 
+	iounmap(pwm->base);
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
 
-- 
1.7.12

