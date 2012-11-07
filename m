Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2KGHHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:07:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43434 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2KGHHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:07:46 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 7/7] IIO: ti_am335x_adc: Add DT support
Date: Wed, 7 Nov 2012 12:22:04 +0530
Message-ID: <1352271124-5513-8-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352271124-5513-1-git-send-email-rachna@ti.com>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support for client ADC driver.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 02a43c8..1f1ec0c 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -22,6 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/iio/iio.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 #include <linux/platform_data/ti_am335x_adc.h>
@@ -141,11 +143,18 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
 	struct iio_dev		*indio_dev;
 	struct tiadc_device	*adc_dev;
 	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
-	struct mfd_tscadc_board	*pdata;
+	struct mfd_tscadc_board	*pdata = NULL;
+	struct device_node	*node = NULL;
 	int			err;
+	u32			val32;
 
-	pdata = tscadc_dev->dev->platform_data;
-	if (!pdata || !pdata->adc_init) {
+	if (tscadc_dev->dev->of_node) {
+		node = tscadc_dev->dev->of_node;
+		node = of_find_node_by_name(node, "adc");
+	} else
+		pdata = tscadc_dev->dev->platform_data;
+
+	if (!pdata && !node) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
@@ -159,7 +168,14 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
 	adc_dev = iio_priv(indio_dev);
 
 	adc_dev->mfd_tscadc = tscadc_dev;
-	adc_dev->channels = pdata->adc_init->adc_channels;
+	if (node) {
+		err = of_property_read_u32(node, "adc-channels", &val32);
+		if (err < 0)
+			goto err_free_device;
+		else
+			adc_dev->channels = val32;
+	} else
+		adc_dev->channels = pdata->adc_init->adc_channels;
 
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->name = dev_name(&pdev->dev);
-- 
1.7.0.4

