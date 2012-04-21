Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2DUL5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:57:05 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40624 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2DUL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:57:02 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 10/13] gadget/r8a66597: Remove conditional compilation of clk code
Date: Sat, 21 Apr 2012 17:17:37 +0530
Message-Id: <e4595fff33749f538945f0f0c578d630b9b3168e.1335008617.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/r8a66597-udc.c |   21 +++++++--------------
 drivers/usb/gadget/r8a66597-udc.h |    5 -----
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index c4401e7..85aa56d 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1818,12 +1818,11 @@ static int __exit r8a66597_remove(struct platform_device *pdev)
 		iounmap(r8a66597->sudmac_reg);
 	free_irq(platform_get_irq(pdev, 0), r8a66597);
 	r8a66597_free_request(&r8a66597->ep[0].ep, r8a66597->ep0_req);
-#ifdef CONFIG_HAVE_CLK
-	if (r8a66597->pdata->on_chip) {
+
+	if (r8a66597->pdata->on_chip && !IS_ERR(r8a66597->clk)) {
 		clk_disable(r8a66597->clk);
 		clk_put(r8a66597->clk);
 	}
-#endif
 	device_unregister(&r8a66597->gadget.dev);
 	kfree(r8a66597);
 	return 0;
@@ -1855,9 +1854,7 @@ static int __init r8a66597_sudmac_ioremap(struct r8a66597 *r8a66597,
 
 static int __init r8a66597_probe(struct platform_device *pdev)
 {
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	struct resource *res, *ires;
 	int irq;
 	void __iomem *reg = NULL;
@@ -1921,19 +1918,17 @@ static int __init r8a66597_probe(struct platform_device *pdev)
 	r8a66597->timer.data = (unsigned long)r8a66597;
 	r8a66597->reg = reg;
 
-#ifdef CONFIG_HAVE_CLK
 	if (r8a66597->pdata->on_chip) {
 		snprintf(clk_name, sizeof(clk_name), "usb%d", pdev->id);
 		r8a66597->clk = clk_get(&pdev->dev, clk_name);
 		if (IS_ERR(r8a66597->clk)) {
 			dev_err(&pdev->dev, "cannot get clock \"%s\"\n",
 				clk_name);
-			ret = PTR_ERR(r8a66597->clk);
-			goto clean_up_dev;
+		} else {
+			clk_enable(r8a66597->clk);
 		}
-		clk_enable(r8a66597->clk);
 	}
-#endif
+
 	if (r8a66597->pdata->sudmac) {
 		ret = r8a66597_sudmac_ioremap(r8a66597, pdev);
 		if (ret < 0)
@@ -1993,13 +1988,11 @@ err_add_udc:
 clean_up3:
 	free_irq(irq, r8a66597);
 clean_up2:
-#ifdef CONFIG_HAVE_CLK
-	if (r8a66597->pdata->on_chip) {
+	if (r8a66597->pdata->on_chip && !IS_ERR(r8a66597->clk)) {
 		clk_disable(r8a66597->clk);
 		clk_put(r8a66597->clk);
 	}
-clean_up_dev:
-#endif
+
 	device_unregister(&r8a66597->gadget.dev);
 clean_up:
 	if (r8a66597) {
diff --git a/drivers/usb/gadget/r8a66597-udc.h b/drivers/usb/gadget/r8a66597-udc.h
index 8e3de61..d2a5ad2 100644
--- a/drivers/usb/gadget/r8a66597-udc.h
+++ b/drivers/usb/gadget/r8a66597-udc.h
@@ -13,10 +13,7 @@
 #ifndef __R8A66597_H__
 #define __R8A66597_H__
 
-#ifdef CONFIG_HAVE_CLK
 #include <linux/clk.h>
-#endif
-
 #include <linux/usb/r8a66597.h>
 
 #define R8A66597_MAX_SAMPLING	10
@@ -92,9 +89,7 @@ struct r8a66597 {
 	void __iomem		*reg;
 	void __iomem		*sudmac_reg;
 
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
-#endif
 	struct r8a66597_platdata	*pdata;
 
 	struct usb_gadget		gadget;
-- 
1.7.9

