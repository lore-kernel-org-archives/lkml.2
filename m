Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0KGUoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:44:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21826 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0KGUoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:44:06 -0500
Date: Sun, 7 Nov 2010 21:32:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: devel@driverdev.osuosl.org,
        Gustavo Silva <silvagustavo@users.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Arun Thomas <arun.thomas@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        "Chris R. Baugher" <baugher@enteract.com>,
        "David A. Schleef" <ds@schleef.org>
Subject: [PATCH] staging, comedi, das16: das16_attach() needs to free allocated
 resources on failure
Message-ID: <alpine.LNX.2.00.1011072126150.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In drivers/staging/comedi/drivers/das16.c::das16_attach() there are many 
potential failure scenarios. However, the driver neglects to free 
resources it has allocated if failures happen. This patch changes that so 
that all allocated resources are freed on error in proper order.

Unfortunately I have no hardware to test this patch with, so it is compile 
tested only.

Please review and consider for inclusion (and please CC me on replies).


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 das16.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 0af1b46..75ee2f3 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1507,19 +1507,30 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dma_chan = it->options[2];
 	if (dma_chan == 1 || dma_chan == 3) {
 		/*  allocate dma buffers */
-		int i;
-		for (i = 0; i < 2; i++) {
-			devpriv->dma_buffer[i] = pci_alloc_consistent(
-						NULL, DAS16_DMA_SIZE,
-						&devpriv->dma_buffer_addr[i]);
+		ret = -ENOMEM;
+		devpriv->dma_buffer[0] = pci_alloc_consistent(NULL,
+							      DAS16_DMA_SIZE,
+							      &devpriv->dma_buffer_addr[0]);
+		if (!devpriv->dma_buffer[0])
+			goto out_free_irq;
+
+		devpriv->dma_buffer[1] = pci_alloc_consistent(NULL,
+							      DAS16_DMA_SIZE,
+							      &devpriv->dma_buffer_addr[1]);
+		if (!devpriv->dma_buffer[1])
+			goto out_free_dma_buffers_0;
+
+		devpriv->dma_buffer[2] = pci_alloc_consistent(NULL,
+							      DAS16_DMA_SIZE,
+							      &devpriv->dma_buffer_addr[2]);
+		if (!devpriv->dma_buffer[2])
+			goto out_free_dma_buffers_1;
 
-			if (devpriv->dma_buffer[i] == NULL)
-				return -ENOMEM;
-		}
 		if (request_dma(dma_chan, "das16")) {
 			printk(KERN_ERR " failed to allocate dma channel %i\n",
 			       dma_chan);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_free_dma_buffers_2;
 		}
 		devpriv->dma_chan = dma_chan;
 		flags = claim_dma_lock();
@@ -1531,7 +1542,8 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_INFO " ( no dma )\n");
 	} else {
 		printk(KERN_ERR " invalid dma channel\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free_irq;
 	}
 
 	/*  get any user-defined input range */
@@ -1541,6 +1553,10 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->user_ai_range_table =
 		    kmalloc(sizeof(struct comedi_lrange) +
 			    sizeof(struct comedi_krange), GFP_KERNEL);
+		if (!devpriv->user_ai_range_table) {
+			ret = -ENOMEM;
+			goto out_free_dma;
+		}
 		/*  initialize ai range */
 		devpriv->user_ai_range_table->length = 1;
 		user_ai_range = devpriv->user_ai_range_table->range;
@@ -1554,6 +1570,10 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->user_ao_range_table =
 		    kmalloc(sizeof(struct comedi_lrange) +
 			    sizeof(struct comedi_krange), GFP_KERNEL);
+		if (!devpriv->user_ao_range_table) {
+			ret = -ENOMEM;
+			goto out_free_user_ai_range_table;
+		}
 		/*  initialize ao range */
 		devpriv->user_ao_range_table->length = 1;
 		user_ao_range = devpriv->user_ao_range_table->range;
@@ -1571,7 +1591,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	ret = alloc_subdevices(dev, 5);
 	if (ret < 0)
-		return ret;
+		goto out_free_user_ao_range_table;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
@@ -1673,6 +1693,28 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	return 0;
+
+ out_free_user_ao_range_table:
+	kfree(devpriv->user_ao_range_table);
+ out_free_user_ai_range_table:
+	kfree(devpriv->user_ai_range_table);
+ out_free_dma:
+	if (devpriv->dma_chan)
+		free_dma(devpriv->dma_chan);
+ out_free_dma_buffers_2:
+	pci_free_consistent(NULL, DAS16_DMA_SIZE, devpriv->dma_buffer[2],
+			    devpriv->dma_buffer_addr[2]);
+ out_free_dma_buffers_1:
+	pci_free_consistent(NULL, DAS16_DMA_SIZE, devpriv->dma_buffer[1],
+			    devpriv->dma_buffer_addr[1]);
+ out_free_dma_buffers_0:
+	pci_free_consistent(NULL, DAS16_DMA_SIZE, devpriv->dma_buffer[0],
+			    devpriv->dma_buffer_addr[0]);
+ out_free_irq:
+	if (irq > 1 && irq < 8)
+		free_irq(dev->irq, dev);
+
+	return ret;
 }
 
 static int das16_detach(struct comedi_device *dev)



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

