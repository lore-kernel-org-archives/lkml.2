Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0CQQ0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:26:51 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:54062 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0CQQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:26:48 -0400
X-Spam-Processed: digidescorp.com, Wed, 17 Mar 2010 11:26:47 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16925da2b5=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, Grant Likely <grant.likely@secretlab.ca>,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH 4/4] dmaengine: xlldma OF bus driver
Date: Wed, 17 Mar 2010 11:26:36 -0500
Message-Id: <1268843196-15315-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open Firmware bus attachment for the Xilinx MPMC Soft Direct Memory
Access Controller DMA engine.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/drivers/dma/xlldma_of.c b/drivers/dma/xlldma_of.c
--- a/drivers/dma/xlldma_of.c	1969-12-31 18:00:00.000000000 -0600
+++ b/drivers/dma/xlldma_of.c	2010-03-17 11:11:16.000000000 -0500
@@ -0,0 +1,252 @@
+/*
+ * Xilinx Multi-Port Memory Controller (MPMC) DMA Engine support
+ *
+ * Copyright (C) 2010 Digital Design Corporation. All rights reserved.
+ *
+ * Author:
+ *   Steve Magnani <steve@digidescorp.com>, Mar 2010
+ *
+ * Description:
+ *   OpenFirmware bus attachment for the Xilinx MPMC Soft Direct Memory
+ *   Access Controller DMA engine.
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/of_platform.h>
+#include <linux/module.h>
+
+#include "xlldma.h"
+
+static int __devinit xlldma_of_chan_probe(struct xlldma_device *xdev,
+					  struct device_node *node,
+					  const char *compatible)
+{
+	struct xlldma_chan *chan;
+	int err;
+#ifdef CONFIG_PPC_DCR_NATIVE
+	unsigned int dcrs;
+#endif
+
+	/* alloc channel */
+	chan = kzalloc(sizeof(struct xlldma_chan), GFP_KERNEL);
+	if (!chan) {
+		dev_err(xdev->dev, "No free memory for allocating "
+			"dma channels!\n");
+		return -ENOMEM;
+	}
+
+	/* get dma channel register base */
+#ifdef CONFIG_PPC_DCR_NATIVE
+	dcrs = dcr_resource_start(node, 0);
+	if (dcrs == 0) {
+		dev_err(xdev->dev, "could not get DMA register address\n");
+		goto err_no_reg;
+	}
+	chan->dcr_c    = dcr_resource_len(node, 0);
+	chan->reg_dcrs = dcr_map(node, dcrs, dcr_c);
+	dev_dbg(xdev->dev, "DCR base: %x\n", dcrs);
+#else
+	chan->reg_base = NULL;
+
+	err = of_address_to_resource(node, 0, &chan->reg);
+	if (err) {
+		dev_err(xdev->dev, "Can't get %s property 'reg'\n",
+			node->full_name);
+		goto err_no_reg;
+	}
+
+	chan->reg_base = of_iomap(node, 0);
+	if (chan->reg_base) {
+		dev_dbg(xdev->dev, "MEM base: %p\n", chan->reg_base);
+	} else {
+		dev_err(xdev->dev, "unable to map DMA registers\n");
+		goto err_no_reg;
+	}
+#endif
+
+	chan->xdev = xdev;
+
+	chan->id = xdev->common.chancnt;
+	if (chan->id >= XLLDMA_MAX_CHANS_PER_DEVICE) {
+		dev_err(xdev->dev, "There is no %d channel!\n",
+			chan->id);
+		err = -EINVAL;
+		goto err_no_chan;
+	}
+	xdev->chan[chan->id] = chan;
+	tasklet_init(&chan->tasklet, xlldma_cleanup_tasklet,
+		     (unsigned long)chan);
+
+	spin_lock_init(&chan->desc_lock);
+	INIT_LIST_HEAD(&chan->desc_queue);
+	INIT_LIST_HEAD(&chan->pending_free);
+
+	chan->common.device = &xdev->common;
+
+	/* Add the channel to DMA device channel list */
+	list_add_tail(&chan->common.device_node, &xdev->common.channels);
+	xdev->common.chancnt++;
+
+	/* RX interrupt is required, and first */
+	chan->rx_irq = irq_of_parse_and_map(node, 0);
+	if (chan->rx_irq == NO_IRQ) {
+		err = -ENXIO;
+		goto err_no_irq;
+	}
+
+	err = request_irq(chan->rx_irq,
+			  &xlldma_chan_rx_interrupt, IRQF_SHARED,
+			  "xlldma-rx", chan);
+	if (err) {
+		dev_err(xdev->dev, "DMA channel %s request_irq error "
+			"with return %d\n", node->full_name, err);
+		goto err_no_irq;
+	}
+
+	/* TX interrupt is optional, and second */
+	chan->tx_irq = irq_of_parse_and_map(node, 1);
+	if (chan->tx_irq != NO_IRQ) {
+		err = request_irq(chan->tx_irq,
+				  &xlldma_chan_tx_interrupt, IRQF_SHARED,
+				  "xlldma-tx", chan);
+		if (err) {
+			dev_err(xdev->dev, "DMA channel %s request_irq error "
+				"with return %d\n", node->full_name, err);
+			goto err_rx_irq;
+		}
+	}
+
+	dev_info(xdev->dev, "#%d (%s), tx irq %d, rx irq %d\n", chan->id,
+		 compatible, chan->tx_irq, chan->rx_irq);
+
+	return 0;
+err_rx_irq:
+	free_irq(chan->rx_irq, chan);
+err_no_irq:
+	list_del(&chan->common.device_node);
+err_no_chan:
+#ifdef CONFIG_PPC_DCR_NATIVE
+	dcr_unmap(chan->reg_dcrs, chan->dcr_c);
+#else
+	iounmap(chan->reg_base);
+#endif
+err_no_reg:
+	kfree(chan);
+	return err;
+}
+
+static int __devinit xlldma_probe_channels(struct device *dev)
+{
+	struct of_device     *odev = to_of_device(dev);
+	struct xlldma_device *xdev = dev_get_drvdata(dev);
+	struct device_node *child;
+	int rc = 0;
+
+	/* We cannot use of_platform_bus_probe() because there is no
+	 * of_platform_bus_remove.  Instead, we manually instantiate every DMA
+	 * channel object.
+	 */
+	for_each_child_of_node(odev->node, child) {
+		if (of_device_is_compatible(child, "xlnx,ll-dma-channel")) {
+			rc = xlldma_of_chan_probe(xdev, child,
+						  "xlnx,ll-dma-channel");
+			if (rc)
+				break;
+		}
+	}
+
+	return rc;
+}
+
+static int __devinit xlldma_of_probe(struct of_device *dev,
+				     const struct of_device_id *match)
+{
+	struct xlldma_device *xdev;
+	int i, rc;
+
+	dev_info(&dev->dev,
+		 "Probe the Xilinx DMA driver for %s controller...\n",
+		 match->compatible);
+
+
+	xdev = kzalloc(sizeof(struct xlldma_device), GFP_KERNEL);
+	if (!xdev) {
+		dev_err(&dev->dev, "Not enough memory for 'priv'\n");
+		rc = -ENOMEM;
+		goto fail_alloc;
+	}
+	xdev->dev = &dev->dev;
+	INIT_LIST_HEAD(&xdev->common.channels);
+
+	xdev->common.dev = &dev->dev;
+	dev_set_drvdata(&dev->dev, xdev);
+
+	rc = xlldma_probe_channels(xdev->dev);
+	if (xdev->common.chancnt == 0)
+		goto fail_nochan;
+
+	rc = xlldma_device_setup(xdev->dev);
+	if (rc == 0)
+		return 0;
+
+/* fail: */
+	for (i = 0; i < XLLDMA_MAX_CHANS_PER_DEVICE; i++) {
+		if (xdev->chan[i])
+			xlldma_chan_remove(xdev->chan[i]);
+	}
+fail_nochan:
+	dev_set_drvdata(&dev->dev, NULL);
+	kfree(xdev);
+
+fail_alloc:
+	return rc;
+}
+
+static int __devexit xlldma_of_remove(struct of_device *op)
+{
+	return xlldma_device_teardown(&op->dev);
+}
+
+static const struct of_device_id xlldma_of_ids[] = {
+	{ .compatible = "xlnx,ll-dma-1.00.a", },
+	{ .compatible = "xlnx,ll-dma-1.00.b", },
+	{ .compatible = "xlnx,ll-dma-1.01.a", },
+	{}
+};
+
+static struct of_platform_driver xlldma_of_driver = {
+	.name = "xlldma",
+	.match_table = xlldma_of_ids,
+	.probe = xlldma_of_probe,
+	.remove = __devexit_p(xlldma_of_remove),
+};
+
+static __init int xlldma_of_init(void)
+{
+	int ret;
+
+	pr_info("Xilinx LocalLink DMA driver\n");
+
+	ret = of_register_platform_driver(&xlldma_of_driver);
+	if (ret)
+		pr_err("xlldma: failed to register platform driver\n");
+
+	return ret;
+}
+
+static void __exit xlldma_of_exit(void)
+{
+	of_unregister_platform_driver(&xlldma_of_driver);
+}
+
+module_init(xlldma_of_init);
+module_exit(xlldma_of_exit);
+
+MODULE_AUTHOR("Digital Design Corporation");
+MODULE_DESCRIPTION("Xilinx LocalLink DMA OpenFirmware driver");
+MODULE_LICENSE("GPL");


