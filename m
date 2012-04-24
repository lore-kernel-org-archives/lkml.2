Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2DXLe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:34:57 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:45828 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565Ab2DXLen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:34:43 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, Viresh Kumar <viresh.kumar@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH V3 10/12] gadget/m66592: Remove conditional compilation of clk code
Date: Tue, 24 Apr 2012 16:51:32 +0530
Message-ID: <e5a35cbdb9ef16b457516b01bc68780e2e573f91.1335266056.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335266056.git.viresh.kumar@st.com>
References: <cover.1335266056.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 drivers/usb/gadget/m66592-udc.c |    9 +--------
 drivers/usb/gadget/m66592-udc.h |    5 -----
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 3608b3b..51c24d2 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1583,12 +1583,10 @@ static int __exit m66592_remove(struct platform_device *pdev)
 	iounmap(m66592->reg);
 	free_irq(platform_get_irq(pdev, 0), m66592);
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
-#ifdef CONFIG_HAVE_CLK
 	if (m66592->pdata->on_chip) {
 		clk_disable(m66592->clk);
 		clk_put(m66592->clk);
 	}
-#endif
 	kfree(m66592);
 	return 0;
 }
@@ -1602,9 +1600,7 @@ static int __init m66592_probe(struct platform_device *pdev)
 	struct resource *res, *ires;
 	void __iomem *reg = NULL;
 	struct m66592 *m66592 = NULL;
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	int ret = 0;
 	int i;
 
@@ -1671,7 +1667,6 @@ static int __init m66592_probe(struct platform_device *pdev)
 		goto clean_up;
 	}
 
-#ifdef CONFIG_HAVE_CLK
 	if (m66592->pdata->on_chip) {
 		snprintf(clk_name, sizeof(clk_name), "usbf%d", pdev->id);
 		m66592->clk = clk_get(&pdev->dev, clk_name);
@@ -1683,7 +1678,7 @@ static int __init m66592_probe(struct platform_device *pdev)
 		}
 		clk_enable(m66592->clk);
 	}
-#endif
+
 	INIT_LIST_HEAD(&m66592->gadget.ep_list);
 	m66592->gadget.ep0 = &m66592->ep[0].ep;
 	INIT_LIST_HEAD(&m66592->gadget.ep0->ep_list);
@@ -1731,13 +1726,11 @@ err_add_udc:
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
 
 clean_up3:
-#ifdef CONFIG_HAVE_CLK
 	if (m66592->pdata->on_chip) {
 		clk_disable(m66592->clk);
 		clk_put(m66592->clk);
 	}
 clean_up2:
-#endif
 	free_irq(ires->start, m66592);
 clean_up:
 	if (m66592) {
diff --git a/drivers/usb/gadget/m66592-udc.h b/drivers/usb/gadget/m66592-udc.h
index 9d9f7e3..a044ad3 100644
--- a/drivers/usb/gadget/m66592-udc.h
+++ b/drivers/usb/gadget/m66592-udc.h
@@ -13,10 +13,7 @@
 #ifndef __M66592_UDC_H__
 #define __M66592_UDC_H__
 
-#ifdef CONFIG_HAVE_CLK
 #include <linux/clk.h>
-#endif
-
 #include <linux/usb/m66592.h>
 
 #define M66592_SYSCFG		0x00
@@ -468,9 +465,7 @@ struct m66592_ep {
 struct m66592 {
 	spinlock_t		lock;
 	void __iomem		*reg;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
-#endif
 	struct m66592_platdata	*pdata;
 	unsigned long		irq_trigger;
 
-- 
1.7.9

