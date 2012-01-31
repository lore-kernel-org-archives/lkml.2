Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2AaKom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:44:42 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:33300 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2AaKoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:44:39 -0500
From: Barry Song <Barry.Song@csr.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <workgroup.linux@csr.com>, <linux-mtd@lists.infradead.org>,
        Barry Song <Baohua.Song@csr.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erik Gilling <konkers@google.com>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/3] platform: add common resource requesting and mapping helper
Date: Tue, 31 Jan 2012 18:00:00 +0800
Message-ID: <1328004002-24646-2-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

this patch helps to move the common pattern from

"
res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
if (!res) {
	ret = -ENODEV;
	goto err;
}

base = devm_request_and_ioremap(&dev->dev, mem_res);
if (!base) {
	ret = -ENODEV;
	goto err;
}
"

to

"
base = platform_devm_request_and_ioremap(pdev, 0);
if (!base) {
	ret = -ENODEV;
	goto err;
}
"

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Erik Gilling <konkers@google.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/base/platform.c         |   19 +++++++++++++++++++
 include/linux/platform_device.h |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f0c605e..39ca0ab 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -72,6 +72,25 @@ struct resource *platform_get_resource(struct platform_device *dev,
 EXPORT_SYMBOL_GPL(platform_get_resource);
 
 /**
+ * platform_devm_request_and_ioremap() - get resource, check, request region,
+ * and ioremap resource
+ * @dev: platform device
+ * @num: IOMEM resource index
+ */
+void __iomem *platform_devm_request_and_ioremap(struct platform_device *dev,
+	unsigned int num)
+{
+	struct resource *res;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, num);
+	if (!res)
+		return NULL;
+
+	return devm_request_and_ioremap(&dev->dev, res);
+}
+EXPORT_SYMBOL_GPL(platform_devm_request_and_ioremap);
+
+/**
  * platform_get_irq - get an IRQ for a device
  * @dev: platform device
  * @num: IRQ number index
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 60e9994..768c0d7 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -44,6 +44,7 @@ extern struct device platform_bus;
 
 extern void arch_setup_pdev_archdata(struct platform_device *);
 extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
+extern void __iomem *platform_devm_request_and_ioremap(struct platform_device *, unsigned int);
 extern int platform_get_irq(struct platform_device *, unsigned int);
 extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, const char *);
 extern int platform_get_irq_byname(struct platform_device *, const char *);
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
