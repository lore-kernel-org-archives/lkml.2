Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1HUW6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:58:20 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:60490 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932076Ab1HUW6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:58:14 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Hunold <michael@mihu.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] [media] saa7146: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:44 -0700
Message-Id: <cfcea15fc2bcd602d01444afb5d09bdfdfa133f7.1313966089.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize the mechanisms to emit logging messages.

A few other modules used an #include from saa7146,
convert those at the same time.

Add pr_fmt.
Convert printks to pr_<level>
Convert printks without KERN_<level> to appropriate pr_<level>.
Convert logging macros requiring multiple parentheses to normal style.
Removed embedded prefixes when pr_fmt was added.
Whitespace cleanups when around other conversions.
Use printf extension %pM to print mac address.
Coalesce format strings.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/saa7146_core.c  |   74 ++++++++-------
 drivers/media/common/saa7146_fops.c  |  118 +++++++++++++-----------
 drivers/media/common/saa7146_hlp.c   |   14 ++-
 drivers/media/common/saa7146_i2c.c   |   60 ++++++------
 drivers/media/common/saa7146_vbi.c   |   48 +++++-----
 drivers/media/common/saa7146_video.c |  171 ++++++++++++++++++----------------
 drivers/media/dvb/ttpci/av7110_v4l.c |   32 ++++---
 drivers/media/dvb/ttpci/budget-av.c  |   42 ++++----
 drivers/media/video/hexium_gemini.c  |   42 +++++----
 drivers/media/video/hexium_orion.c   |   38 ++++----
 drivers/media/video/mxb.c            |   80 +++++++++-------
 include/media/saa7146.h              |   36 +++++---
 12 files changed, 403 insertions(+), 352 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 31e53b6..d6b1cf6 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -18,6 +18,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <media/saa7146.h>
 #include <linux/module.h>
 
@@ -36,10 +38,9 @@ static void dump_registers(struct saa7146_dev* dev)
 {
 	int i = 0;
 
-	INFO((" @ %li jiffies:\n",jiffies));
-	for(i = 0; i <= 0x148; i+=4) {
-		printk("0x%03x: 0x%08x\n",i,saa7146_read(dev,i));
-	}
+	pr_info(" @ %li jiffies:\n", jiffies);
+	for (i = 0; i <= 0x148; i += 4)
+		pr_info("0x%03x: 0x%08x\n", i, saa7146_read(dev, i));
 }
 #endif
 
@@ -73,9 +74,8 @@ static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 		if (saa7146_read(dev, MC2) & 2)
 			break;
 		if (err) {
-			printk(KERN_ERR "%s: %s timed out while waiting for "
-					"registers getting programmed\n",
-					dev->name, __func__);
+			pr_err("%s: %s timed out while waiting for registers getting programmed\n",
+			       dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -89,8 +89,8 @@ static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 			break;
 		saa7146_read(dev, MC2);
 		if (err) {
-			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n",	dev->name, __func__));
+			DEB_S("%s: %s timed out while waiting for transfer completion\n",
+			      dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -110,9 +110,8 @@ static inline int saa7146_wait_for_debi_done_busyloop(struct saa7146_dev *dev,
 		if (saa7146_read(dev, MC2) & 2)
 			break;
 		if (!loops--) {
-			printk(KERN_ERR "%s: %s timed out while waiting for "
-					"registers getting programmed\n",
-					dev->name, __func__);
+			pr_err("%s: %s timed out while waiting for registers getting programmed\n",
+			       dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		udelay(1);
@@ -125,8 +124,8 @@ static inline int saa7146_wait_for_debi_done_busyloop(struct saa7146_dev *dev,
 			break;
 		saa7146_read(dev, MC2);
 		if (!loops--) {
-			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n", dev->name, __func__));
+			DEB_S("%s: %s timed out while waiting for transfer completion\n",
+			      dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		udelay(5);
@@ -265,7 +264,9 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 	ptr = pt->cpu;
 	for (i = 0; i < sglen; i++, list++) {
 /*
-		printk("i:%d, adr:0x%08x, len:%d, offset:%d\n", i,sg_dma_address(list), sg_dma_len(list), list->offset);
+		pr_debug("i:%d, adr:0x%08x, len:%d, offset:%d\n",
+			 i, sg_dma_address(list), sg_dma_len(list),
+			 list->offset);
 */
 		for (p = 0; p * 4096 < list->length; p++, ptr++) {
 			*ptr = cpu_to_le32(sg_dma_address(list) + p * 4096);
@@ -282,9 +283,9 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 
 /*
 	ptr = pt->cpu;
-	printk("offset: %d\n",pt->offset);
+	pr_debug("offset: %d\n", pt->offset);
 	for(i=0;i<5;i++) {
-		printk("ptr1 %d: 0x%08x\n",i,ptr[i]);
+		pr_debug("ptr1 %d: 0x%08x\n", i, ptr[i]);
 	}
 */
 	return 0;
@@ -315,7 +316,7 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 		}
 	}
 	if (0 != (isr & (MASK_27))) {
-		DEB_INT(("irq: RPS0 (0x%08x).\n",isr));
+		DEB_INT("irq: RPS0 (0x%08x)\n", isr);
 		if (dev->vv_data && dev->vv_callback)
 			dev->vv_callback(dev,isr);
 		isr &= ~MASK_27;
@@ -334,14 +335,15 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 		} else {
 			u32 psr = saa7146_read(dev, PSR);
 			u32 ssr = saa7146_read(dev, SSR);
-			printk(KERN_WARNING "%s: unexpected i2c irq: isr %08x psr %08x ssr %08x\n",
-			       dev->name, isr, psr, ssr);
+			pr_warn("%s: unexpected i2c irq: isr %08x psr %08x ssr %08x\n",
+				dev->name, isr, psr, ssr);
 		}
 		isr &= ~(MASK_16|MASK_17);
 	}
 	if( 0 != isr ) {
-		ERR(("warning: interrupt enabled, but not handled properly.(0x%08x)\n",isr));
-		ERR(("disabling interrupt source(s)!\n"));
+		ERR("warning: interrupt enabled, but not handled properly.(0x%08x)\n",
+		    isr);
+		ERR("disabling interrupt source(s)!\n");
 		SAA7146_IER_DISABLE(dev,isr);
 	}
 	saa7146_write(dev, ISR, ack_isr);
@@ -361,15 +363,15 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	/* clear out mem for sure */
 	dev = kzalloc(sizeof(struct saa7146_dev), GFP_KERNEL);
 	if (!dev) {
-		ERR(("out of memory.\n"));
+		ERR("out of memory\n");
 		goto out;
 	}
 
-	DEB_EE(("pci:%p\n",pci));
+	DEB_EE("pci:%p\n", pci);
 
 	err = pci_enable_device(pci);
 	if (err < 0) {
-		ERR(("pci_enable_device() failed.\n"));
+		ERR("pci_enable_device() failed\n");
 		goto err_free;
 	}
 
@@ -390,7 +392,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	dev->mem = ioremap(pci_resource_start(pci, 0),
 			   pci_resource_len(pci, 0));
 	if (!dev->mem) {
-		ERR(("ioremap() failed.\n"));
+		ERR("ioremap() failed\n");
 		err = -ENODEV;
 		goto err_release;
 	}
@@ -415,7 +417,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
 			  dev->name, dev);
 	if (err < 0) {
-		ERR(("request_irq() failed.\n"));
+		ERR("request_irq() failed\n");
 		goto err_unmap;
 	}
 
@@ -445,7 +447,9 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	/* create a nice device name */
 	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
 
-	INFO(("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x).\n", dev->mem, dev->revision, pci->irq, pci->subsystem_vendor, pci->subsystem_device));
+	pr_info("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x)\n",
+		dev->mem, dev->revision, pci->irq,
+		pci->subsystem_vendor, pci->subsystem_device);
 	dev->ext = ext;
 
 	mutex_init(&dev->v4l2_lock);
@@ -465,12 +469,12 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	err = -ENODEV;
 
 	if (ext->probe && ext->probe(dev)) {
-		DEB_D(("ext->probe() failed for %p. skipping device.\n",dev));
+		DEB_D("ext->probe() failed for %p. skipping device.\n", dev);
 		goto err_free_i2c;
 	}
 
 	if (ext->attach(dev, pci_ext)) {
-		DEB_D(("ext->attach() failed for %p. skipping device.\n",dev));
+		DEB_D("ext->attach() failed for %p. skipping device.\n", dev);
 		goto err_free_i2c;
 	}
 	/* V4L extensions will set the pci drvdata to the v4l2_device in the
@@ -522,7 +526,7 @@ static void saa7146_remove_one(struct pci_dev *pdev)
 		{ NULL, 0 }
 	}, *p;
 
-	DEB_EE(("dev:%p\n",dev));
+	DEB_EE("dev:%p\n", dev);
 
 	dev->ext->detach(dev);
 	/* Zero the PCI drvdata after use. */
@@ -553,21 +557,21 @@ static void saa7146_remove_one(struct pci_dev *pdev)
 
 int saa7146_register_extension(struct saa7146_extension* ext)
 {
-	DEB_EE(("ext:%p\n",ext));
+	DEB_EE("ext:%p\n", ext);
 
 	ext->driver.name = ext->name;
 	ext->driver.id_table = ext->pci_tbl;
 	ext->driver.probe = saa7146_init_one;
 	ext->driver.remove = saa7146_remove_one;
 
-	printk("saa7146: register extension '%s'.\n",ext->name);
+	pr_info("register extension '%s'\n", ext->name);
 	return pci_register_driver(&ext->driver);
 }
 
 int saa7146_unregister_extension(struct saa7146_extension* ext)
 {
-	DEB_EE(("ext:%p\n",ext));
-	printk("saa7146: unregister extension '%s'.\n",ext->name);
+	DEB_EE("ext:%p\n", ext);
+	pr_info("unregister extension '%s'\n", ext->name);
 	pci_unregister_driver(&ext->driver);
 	return 0;
 }
diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index e4547af..71f8e01 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <media/saa7146_vv.h>
 #include <linux/module.h>
 
@@ -10,21 +12,23 @@ int saa7146_res_get(struct saa7146_fh *fh, unsigned int bit)
 	struct saa7146_vv *vv = dev->vv_data;
 
 	if (fh->resources & bit) {
-		DEB_D(("already allocated! want: 0x%02x, cur:0x%02x\n",bit,vv->resources));
+		DEB_D("already allocated! want: 0x%02x, cur:0x%02x\n",
+		      bit, vv->resources);
 		/* have it already allocated */
 		return 1;
 	}
 
 	/* is it free? */
 	if (vv->resources & bit) {
-		DEB_D(("locked! vv->resources:0x%02x, we want:0x%02x\n",vv->resources,bit));
+		DEB_D("locked! vv->resources:0x%02x, we want:0x%02x\n",
+		      vv->resources, bit);
 		/* no, someone else uses it */
 		return 0;
 	}
 	/* it's free, grab it */
-	fh->resources  |= bit;
+	fh->resources |= bit;
 	vv->resources |= bit;
-	DEB_D(("res: get 0x%02x, cur:0x%02x\n",bit,vv->resources));
+	DEB_D("res: get 0x%02x, cur:0x%02x\n", bit, vv->resources);
 	return 1;
 }
 
@@ -35,9 +39,9 @@ void saa7146_res_free(struct saa7146_fh *fh, unsigned int bits)
 
 	BUG_ON((fh->resources & bits) != bits);
 
-	fh->resources  &= ~bits;
+	fh->resources &= ~bits;
 	vv->resources &= ~bits;
-	DEB_D(("res: put 0x%02x, cur:0x%02x\n",bits,vv->resources));
+	DEB_D("res: put 0x%02x, cur:0x%02x\n", bits, vv->resources);
 }
 
 
@@ -48,7 +52,7 @@ void saa7146_dma_free(struct saa7146_dev *dev,struct videobuf_queue *q,
 						struct saa7146_buf *buf)
 {
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-	DEB_EE(("dev:%p, buf:%p\n",dev,buf));
+	DEB_EE("dev:%p, buf:%p\n", dev, buf);
 
 	BUG_ON(in_interrupt());
 
@@ -67,18 +71,19 @@ int saa7146_buffer_queue(struct saa7146_dev *dev,
 			 struct saa7146_buf *buf)
 {
 	assert_spin_locked(&dev->slock);
-	DEB_EE(("dev:%p, dmaq:%p, buf:%p\n", dev, q, buf));
+	DEB_EE("dev:%p, dmaq:%p, buf:%p\n", dev, q, buf);
 
 	BUG_ON(!q);
 
 	if (NULL == q->curr) {
 		q->curr = buf;
-		DEB_D(("immediately activating buffer %p\n", buf));
+		DEB_D("immediately activating buffer %p\n", buf);
 		buf->activate(dev,buf,NULL);
 	} else {
 		list_add_tail(&buf->vb.queue,&q->queue);
 		buf->vb.state = VIDEOBUF_QUEUED;
-		DEB_D(("adding buffer %p to queue. (active buffer present)\n", buf));
+		DEB_D("adding buffer %p to queue. (active buffer present)\n",
+		      buf);
 	}
 	return 0;
 }
@@ -88,14 +93,14 @@ void saa7146_buffer_finish(struct saa7146_dev *dev,
 			   int state)
 {
 	assert_spin_locked(&dev->slock);
-	DEB_EE(("dev:%p, dmaq:%p, state:%d\n", dev, q, state));
-	DEB_EE(("q->curr:%p\n",q->curr));
+	DEB_EE("dev:%p, dmaq:%p, state:%d\n", dev, q, state);
+	DEB_EE("q->curr:%p\n", q->curr);
 
 	BUG_ON(!q->curr);
 
 	/* finish current buffer */
 	if (NULL == q->curr) {
-		DEB_D(("aiii. no current buffer\n"));
+		DEB_D("aiii. no current buffer\n");
 		return;
 	}
 
@@ -113,7 +118,7 @@ void saa7146_buffer_next(struct saa7146_dev *dev,
 
 	BUG_ON(!q);
 
-	DEB_INT(("dev:%p, dmaq:%p, vbi:%d\n", dev, q, vbi));
+	DEB_INT("dev:%p, dmaq:%p, vbi:%d\n", dev, q, vbi);
 
 	assert_spin_locked(&dev->slock);
 	if (!list_empty(&q->queue)) {
@@ -123,10 +128,11 @@ void saa7146_buffer_next(struct saa7146_dev *dev,
 		if (!list_empty(&q->queue))
 			next = list_entry(q->queue.next,struct saa7146_buf, vb.queue);
 		q->curr = buf;
-		DEB_INT(("next buffer: buf:%p, prev:%p, next:%p\n", buf, q->queue.prev,q->queue.next));
+		DEB_INT("next buffer: buf:%p, prev:%p, next:%p\n",
+			buf, q->queue.prev, q->queue.next);
 		buf->activate(dev,buf,next);
 	} else {
-		DEB_INT(("no next buffer. stopping.\n"));
+		DEB_INT("no next buffer. stopping.\n");
 		if( 0 != vbi ) {
 			/* turn off video-dma3 */
 			saa7146_write(dev,MC1, MASK_20);
@@ -163,11 +169,11 @@ void saa7146_buffer_timeout(unsigned long data)
 	struct saa7146_dev *dev = q->dev;
 	unsigned long flags;
 
-	DEB_EE(("dev:%p, dmaq:%p\n", dev, q));
+	DEB_EE("dev:%p, dmaq:%p\n", dev, q);
 
 	spin_lock_irqsave(&dev->slock,flags);
 	if (q->curr) {
-		DEB_D(("timeout on %p\n", q->curr));
+		DEB_D("timeout on %p\n", q->curr);
 		saa7146_buffer_finish(dev,q,VIDEOBUF_ERROR);
 	}
 
@@ -195,12 +201,12 @@ static int fops_open(struct file *file)
 
 	enum v4l2_buf_type type;
 
-	DEB_EE(("file:%p, dev:%s\n", file, video_device_node_name(vdev)));
+	DEB_EE("file:%p, dev:%s\n", file, video_device_node_name(vdev));
 
 	if (mutex_lock_interruptible(&saa7146_devices_lock))
 		return -ERESTARTSYS;
 
-	DEB_D(("using: %p\n",dev));
+	DEB_D("using: %p\n", dev);
 
 	type = vdev->vfl_type == VFL_TYPE_GRABBER
 	     ? V4L2_BUF_TYPE_VIDEO_CAPTURE
@@ -208,7 +214,7 @@ static int fops_open(struct file *file)
 
 	/* check if an extension is registered */
 	if( NULL == dev->ext ) {
-		DEB_S(("no extension registered for this device.\n"));
+		DEB_S("no extension registered for this device\n");
 		result = -ENODEV;
 		goto out;
 	}
@@ -216,7 +222,7 @@ static int fops_open(struct file *file)
 	/* allocate per open data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
 	if (NULL == fh) {
-		DEB_S(("cannot allocate memory for per open data.\n"));
+		DEB_S("cannot allocate memory for per open data\n");
 		result = -ENOMEM;
 		goto out;
 	}
@@ -226,13 +232,13 @@ static int fops_open(struct file *file)
 	fh->type = type;
 
 	if( fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		DEB_S(("initializing vbi...\n"));
+		DEB_S("initializing vbi...\n");
 		if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
 			result = saa7146_vbi_uops.open(dev,file);
 		if (dev->ext_vv_data->vbi_fops.open)
 			dev->ext_vv_data->vbi_fops.open(file);
 	} else {
-		DEB_S(("initializing video...\n"));
+		DEB_S("initializing video...\n");
 		result = saa7146_video_uops.open(dev,file);
 	}
 
@@ -260,7 +266,7 @@ static int fops_release(struct file *file)
 	struct saa7146_fh  *fh  = file->private_data;
 	struct saa7146_dev *dev = fh->dev;
 
-	DEB_EE(("file:%p\n", file));
+	DEB_EE("file:%p\n", file);
 
 	if (mutex_lock_interruptible(&saa7146_devices_lock))
 		return -ERESTARTSYS;
@@ -290,12 +296,14 @@ static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE: {
-		DEB_EE(("V4L2_BUF_TYPE_VIDEO_CAPTURE: file:%p, vma:%p\n",file, vma));
+		DEB_EE("V4L2_BUF_TYPE_VIDEO_CAPTURE: file:%p, vma:%p\n",
+		       file, vma);
 		q = &fh->video_q;
 		break;
 		}
 	case V4L2_BUF_TYPE_VBI_CAPTURE: {
-		DEB_EE(("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, vma:%p\n",file, vma));
+		DEB_EE("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, vma:%p\n",
+		       file, vma);
 		q = &fh->vbi_q;
 		break;
 		}
@@ -313,14 +321,14 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 	struct videobuf_buffer *buf = NULL;
 	struct videobuf_queue *q;
 
-	DEB_EE(("file:%p, poll:%p\n",file, wait));
+	DEB_EE("file:%p, poll:%p\n", file, wait);
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if( 0 == fh->vbi_q.streaming )
 			return videobuf_poll_stream(file, &fh->vbi_q, wait);
 		q = &fh->vbi_q;
 	} else {
-		DEB_D(("using video queue.\n"));
+		DEB_D("using video queue\n");
 		q = &fh->video_q;
 	}
 
@@ -328,17 +336,17 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 		buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
 
 	if (!buf) {
-		DEB_D(("buf == NULL!\n"));
+		DEB_D("buf == NULL!\n");
 		return POLLERR;
 	}
 
 	poll_wait(file, &buf->done, wait);
 	if (buf->state == VIDEOBUF_DONE || buf->state == VIDEOBUF_ERROR) {
-		DEB_D(("poll succeeded!\n"));
+		DEB_D("poll succeeded!\n");
 		return POLLIN|POLLRDNORM;
 	}
 
-	DEB_D(("nothing to poll for, buf->state:%d\n",buf->state));
+	DEB_D("nothing to poll for, buf->state:%d\n", buf->state);
 	return 0;
 }
 
@@ -347,18 +355,20 @@ static ssize_t fops_read(struct file *file, char __user *data, size_t count, lof
 	struct saa7146_fh *fh = file->private_data;
 
 	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE: {
-//		DEB_EE(("V4L2_BUF_TYPE_VIDEO_CAPTURE: file:%p, data:%p, count:%lun", file, data, (unsigned long)count));
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+/*
+		DEB_EE("V4L2_BUF_TYPE_VIDEO_CAPTURE: file:%p, data:%p, count:%lun",
+		       file, data, (unsigned long)count);
+*/
 		return saa7146_video_uops.read(file,data,count,ppos);
-		}
-	case V4L2_BUF_TYPE_VBI_CAPTURE: {
-//		DEB_EE(("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, data:%p, count:%lu\n", file, data, (unsigned long)count));
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+/*
+		DEB_EE("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, data:%p, count:%lu\n",
+		       file, data, (unsigned long)count);
+*/
 		if (fh->dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
 			return saa7146_vbi_uops.read(file,data,count,ppos);
-		else
-			return -EINVAL;
-		}
-		break;
+		return -EINVAL;
 	default:
 		BUG();
 		return 0;
@@ -399,22 +409,22 @@ static void vv_callback(struct saa7146_dev *dev, unsigned long status)
 {
 	u32 isr = status;
 
-	DEB_INT(("dev:%p, isr:0x%08x\n",dev,(u32)status));
+	DEB_INT("dev:%p, isr:0x%08x\n", dev, (u32)status);
 
 	if (0 != (isr & (MASK_27))) {
-		DEB_INT(("irq: RPS0 (0x%08x).\n",isr));
+		DEB_INT("irq: RPS0 (0x%08x)\n", isr);
 		saa7146_video_uops.irq_done(dev,isr);
 	}
 
 	if (0 != (isr & (MASK_28))) {
 		u32 mc2 = saa7146_read(dev, MC2);
 		if( 0 != (mc2 & MASK_15)) {
-			DEB_INT(("irq: RPS1 vbi workaround (0x%08x).\n",isr));
+			DEB_INT("irq: RPS1 vbi workaround (0x%08x)\n", isr);
 			wake_up(&dev->vv_data->vbi_wq);
 			saa7146_write(dev,MC2, MASK_31);
 			return;
 		}
-		DEB_INT(("irq: RPS1 (0x%08x).\n",isr));
+		DEB_INT("irq: RPS1 (0x%08x)\n", isr);
 		saa7146_vbi_uops.irq_done(dev,isr);
 	}
 }
@@ -430,13 +440,13 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 
 	vv = kzalloc(sizeof(struct saa7146_vv), GFP_KERNEL);
 	if (vv == NULL) {
-		ERR(("out of memory. aborting.\n"));
+		ERR("out of memory. aborting.\n");
 		return -ENOMEM;
 	}
 	ext_vv->ops = saa7146_video_ioctl_ops;
 	ext_vv->core_ops = &saa7146_video_ioctl_ops;
 
-	DEB_EE(("dev:%p\n",dev));
+	DEB_EE("dev:%p\n", dev);
 
 	/* set default values for video parts of the saa7146 */
 	saa7146_write(dev, BCS_CTRL, 0x80400040);
@@ -451,7 +461,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 
 	vv->d_clipping.cpu_addr = pci_alloc_consistent(dev->pci, SAA7146_CLIPPING_MEM, &vv->d_clipping.dma_handle);
 	if( NULL == vv->d_clipping.cpu_addr ) {
-		ERR(("out of memory. aborting.\n"));
+		ERR("out of memory. aborting.\n");
 		kfree(vv);
 		return -1;
 	}
@@ -472,7 +482,7 @@ int saa7146_vv_release(struct saa7146_dev* dev)
 {
 	struct saa7146_vv *vv = dev->vv_data;
 
-	DEB_EE(("dev:%p\n",dev));
+	DEB_EE("dev:%p\n", dev);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 	pci_free_consistent(dev->pci, SAA7146_CLIPPING_MEM, vv->d_clipping.cpu_addr, vv->d_clipping.dma_handle);
@@ -491,7 +501,7 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 	int err;
 	int i;
 
-	DEB_EE(("dev:%p, name:'%s', type:%d\n",dev,name,type));
+	DEB_EE("dev:%p, name:'%s', type:%d\n", dev, name, type);
 
 	// released by vfd->release
 	vfd = video_device_alloc();
@@ -510,13 +520,13 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 
 	err = video_register_device(vfd, type, -1);
 	if (err < 0) {
-		ERR(("cannot register v4l2 device. skipping.\n"));
+		ERR("cannot register v4l2 device. skipping.\n");
 		video_device_release(vfd);
 		return err;
 	}
 
-	INFO(("%s: registered device %s [v4l2]\n",
-		dev->name, video_device_node_name(vfd)));
+	pr_info("%s: registered device %s [v4l2]\n",
+		dev->name, video_device_node_name(vfd));
 
 	*vid = vfd;
 	return 0;
@@ -525,7 +535,7 @@ EXPORT_SYMBOL_GPL(saa7146_register_device);
 
 int saa7146_unregister_device(struct video_device **vid, struct saa7146_dev* dev)
 {
-	DEB_EE(("dev:%p\n",dev));
+	DEB_EE("dev:%p\n", dev);
 
 	video_unregister_device(*vid);
 	*vid = NULL;
diff --git a/drivers/media/common/saa7146_hlp.c b/drivers/media/common/saa7146_hlp.c
index c9c6e9a..bc1f545 100644
--- a/drivers/media/common/saa7146_hlp.c
+++ b/drivers/media/common/saa7146_hlp.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <media/saa7146_vv.h>
@@ -712,8 +714,8 @@ static int calculate_video_dma_grab_packed(struct saa7146_dev* dev, struct saa71
 
 	int depth = sfmt->depth;
 
-	DEB_CAP(("[size=%dx%d,fields=%s]\n",
-		width,height,v4l2_field_names[field]));
+	DEB_CAP("[size=%dx%d,fields=%s]\n",
+		width, height, v4l2_field_names[field]);
 
 	if( bytesperline != 0) {
 		vdma1.pitch = bytesperline*2;
@@ -838,8 +840,8 @@ static int calculate_video_dma_grab_planar(struct saa7146_dev* dev, struct saa71
 	BUG_ON(0 == buf->pt[1].dma);
 	BUG_ON(0 == buf->pt[2].dma);
 
-	DEB_CAP(("[size=%dx%d,fields=%s]\n",
-		width,height,v4l2_field_names[field]));
+	DEB_CAP("[size=%dx%d,fields=%s]\n",
+		width, height, v4l2_field_names[field]);
 
 	/* fixme: look at bytesperline! */
 
@@ -999,12 +1001,12 @@ void saa7146_set_capture(struct saa7146_dev *dev, struct saa7146_buf *buf, struc
 	struct saa7146_vv *vv = dev->vv_data;
 	u32 vdma1_prot_addr;
 
-	DEB_CAP(("buf:%p, next:%p\n",buf,next));
+	DEB_CAP("buf:%p, next:%p\n", buf, next);
 
 	vdma1_prot_addr = saa7146_read(dev, PROT_ADDR1);
 	if( 0 == vdma1_prot_addr ) {
 		/* clear out beginning of streaming bit (rps register 0)*/
-		DEB_CAP(("forcing sync to new frame\n"));
+		DEB_CAP("forcing sync to new frame\n");
 		saa7146_write(dev, MC2, MASK_27 );
 	}
 
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index b2ba9dc..2202719 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -1,8 +1,10 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <media/saa7146_vv.h>
 
 static u32 saa7146_i2c_func(struct i2c_adapter *adapter)
 {
-//fm	DEB_I2C(("'%s'.\n", adapter->name));
+	/* DEB_I2C("'%s'\n", adapter->name); */
 
 	return	  I2C_FUNC_I2C
 		| I2C_FUNC_SMBUS_QUICK
@@ -14,9 +16,7 @@ static u32 saa7146_i2c_func(struct i2c_adapter *adapter)
 static inline u32 saa7146_i2c_status(struct saa7146_dev *dev)
 {
 	u32 iicsta = saa7146_read(dev, I2C_STATUS);
-/*
-	DEB_I2C(("status: 0x%08x\n",iicsta));
-*/
+	/* DEB_I2C("status: 0x%08x\n", iicsta); */
 	return iicsta;
 }
 
@@ -39,10 +39,11 @@ static int saa7146_i2c_msg_prepare(const struct i2c_msg *m, int num, __le32 *op)
 	   plus one extra byte to address the device */
 	mem = 1 + ((mem-1) / 3);
 
-	/* we assume that op points to a memory of at least SAA7146_I2C_MEM bytes
-	   size. if we exceed this limit... */
-	if ( (4*mem) > SAA7146_I2C_MEM ) {
-//fm		DEB_I2C(("cannot prepare i2c-message.\n"));
+	/* we assume that op points to a memory of at least
+	 * SAA7146_I2C_MEM bytes size. if we exceed this limit...
+	 */
+	if ((4 * mem) > SAA7146_I2C_MEM) {
+		/* DEB_I2C("cannot prepare i2c-message\n"); */
 		return -ENOMEM;
 	}
 
@@ -123,7 +124,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
 	if ( 0 != ( status & SAA7146_I2C_BUSY) ) {
 
 		/* yes, kill ongoing operation */
-		DEB_I2C(("busy_state detected.\n"));
+		DEB_I2C("busy_state detected\n");
 
 		/* set "ABORT-OPERATION"-bit (bit 7)*/
 		saa7146_write(dev, I2C_STATUS, (dev->i2c_bitrate | MASK_07));
@@ -141,7 +142,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
 
 	if ( dev->i2c_bitrate != status ) {
 
-		DEB_I2C(("error_state detected. status:0x%08x\n",status));
+		DEB_I2C("error_state detected. status:0x%08x\n", status);
 
 		/* Repeat the abort operation. This seems to be necessary
 		   after serious protocol errors caused by e.g. the SAA7740 */
@@ -164,7 +165,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
 	/* if any error is still present, a fatal error has occurred ... */
 	status = saa7146_i2c_status(dev);
 	if ( dev->i2c_bitrate != status ) {
-		DEB_I2C(("fatal error. status:0x%08x\n",status));
+		DEB_I2C("fatal error. status:0x%08x\n", status);
 		return -1;
 	}
 
@@ -181,7 +182,8 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int shor
 	unsigned long timeout;
 
 	/* write out i2c-command */
-	DEB_I2C(("before: 0x%08x (status: 0x%08x), %d\n",*dword,saa7146_read(dev, I2C_STATUS), dev->i2c_op));
+	DEB_I2C("before: 0x%08x (status: 0x%08x), %d\n",
+		*dword, saa7146_read(dev, I2C_STATUS), dev->i2c_op);
 
 	if( 0 != (SAA7146_USE_I2C_IRQ & dev->ext->flags)) {
 
@@ -202,7 +204,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int shor
 				/* a signal arrived */
 				return -ERESTARTSYS;
 
-			printk(KERN_WARNING "%s %s [irq]: timed out waiting for end of xfer\n",
+			pr_warn("%s %s [irq]: timed out waiting for end of xfer\n",
 				dev->name, __func__);
 			return -EIO;
 		}
@@ -220,7 +222,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int shor
 				break;
 			}
 			if (time_after(jiffies,timeout)) {
-				printk(KERN_WARNING "%s %s: timed out waiting for MC2\n",
+				pr_warn("%s %s: timed out waiting for MC2\n",
 					dev->name, __func__);
 				return -EIO;
 			}
@@ -237,7 +239,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int shor
 				/* this is normal when probing the bus
 				 * (no answer from nonexisistant device...)
 				 */
-				printk(KERN_WARNING "%s %s [poll]: timed out waiting for end of xfer\n",
+				pr_warn("%s %s [poll]: timed out waiting for end of xfer\n",
 					dev->name, __func__);
 				return -EIO;
 			}
@@ -257,24 +259,24 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int shor
 		if ( 0 == (status & SAA7146_I2C_ERR) ||
 		     0 == (status & SAA7146_I2C_BUSY) ) {
 			/* it may take some time until ERR goes high - ignore */
-			DEB_I2C(("unexpected i2c status %04x\n", status));
+			DEB_I2C("unexpected i2c status %04x\n", status);
 		}
 		if( 0 != (status & SAA7146_I2C_SPERR) ) {
-			DEB_I2C(("error due to invalid start/stop condition.\n"));
+			DEB_I2C("error due to invalid start/stop condition\n");
 		}
 		if( 0 != (status & SAA7146_I2C_DTERR) ) {
-			DEB_I2C(("error in data transmission.\n"));
+			DEB_I2C("error in data transmission\n");
 		}
 		if( 0 != (status & SAA7146_I2C_DRERR) ) {
-			DEB_I2C(("error when receiving data.\n"));
+			DEB_I2C("error when receiving data\n");
 		}
 		if( 0 != (status & SAA7146_I2C_AL) ) {
-			DEB_I2C(("error because arbitration lost.\n"));
+			DEB_I2C("error because arbitration lost\n");
 		}
 
 		/* we handle address-errors here */
 		if( 0 != (status & SAA7146_I2C_APERR) ) {
-			DEB_I2C(("error in address phase.\n"));
+			DEB_I2C("error in address phase\n");
 			return -EREMOTEIO;
 		}
 
@@ -284,7 +286,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, __le32 *dword, int shor
 	/* read back data, just in case we were reading ... */
 	*dword = cpu_to_le32(saa7146_read(dev, I2C_TRANSFER));
 
-	DEB_I2C(("after: 0x%08x\n",*dword));
+	DEB_I2C("after: 0x%08x\n", *dword);
 	return 0;
 }
 
@@ -299,7 +301,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 		return -ERESTARTSYS;
 
 	for(i=0;i<num;i++) {
-		DEB_I2C(("msg:%d/%d\n",i+1,num));
+		DEB_I2C("msg:%d/%d\n", i+1, num);
 	}
 
 	/* prepare the message(s), get number of u32s to transfer */
@@ -316,7 +318,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 		/* reset the i2c-device if necessary */
 		err = saa7146_i2c_reset(dev);
 		if ( 0 > err ) {
-			DEB_I2C(("could not reset i2c-device.\n"));
+			DEB_I2C("could not reset i2c-device\n");
 			goto out;
 		}
 
@@ -336,7 +338,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 				   address error and trust the saa7146 address error detection. */
 				if (-EREMOTEIO == err && 0 != (SAA7146_USE_I2C_IRQ & dev->ext->flags))
 					goto out;
-				DEB_I2C(("error while sending message(s). starting again.\n"));
+				DEB_I2C("error while sending message(s). starting again\n");
 				break;
 			}
 		}
@@ -356,13 +358,13 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 
 	/* if any things had to be read, get the results */
 	if ( 0 != saa7146_i2c_msg_cleanup(msgs, num, buffer)) {
-		DEB_I2C(("could not cleanup i2c-message.\n"));
+		DEB_I2C("could not cleanup i2c-message\n");
 		err = -1;
 		goto out;
 	}
 
 	/* return the number of delivered messages */
-	DEB_I2C(("transmission successful. (msg:%d).\n",err));
+	DEB_I2C("transmission successful. (msg:%d)\n", err);
 out:
 	/* another bug in revision 0: the i2c-registers get uploaded randomly by other
 	   uploads, so we better clear them out before continuing */
@@ -370,7 +372,7 @@ out:
 		__le32 zero = 0;
 		saa7146_i2c_reset(dev);
 		if( 0 != saa7146_i2c_writeout(dev, &zero, short_delay)) {
-			INFO(("revision 0 error. this should never happen.\n"));
+			pr_info("revision 0 error. this should never happen\n");
 		}
 	}
 
@@ -400,7 +402,7 @@ static struct i2c_algorithm saa7146_algo = {
 
 int saa7146_i2c_adapter_prepare(struct saa7146_dev *dev, struct i2c_adapter *i2c_adapter, u32 bitrate)
 {
-	DEB_EE(("bitrate: 0x%08x\n",bitrate));
+	DEB_EE("bitrate: 0x%08x\n", bitrate);
 
 	/* enable i2c-port pins */
 	saa7146_write(dev, MC1, (MASK_08 | MASK_24));
diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index afe8580..b2e7183 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -14,7 +14,7 @@ static int vbi_workaround(struct saa7146_dev *dev)
 
 	DECLARE_WAITQUEUE(wait, current);
 
-	DEB_VBI(("dev:%p\n",dev));
+	DEB_VBI("dev:%p\n", dev);
 
 	/* once again, a bug in the saa7146: the brs acquisition
 	   is buggy and especially the BXO-counter does not work
@@ -40,14 +40,14 @@ static int vbi_workaround(struct saa7146_dev *dev)
 	WRITE_RPS1(0xc000008c);
 	/* wait for vbi_a or vbi_b*/
 	if ( 0 != (SAA7146_USE_PORT_B_FOR_VBI & dev->ext_vv_data->flags)) {
-		DEB_D(("...using port b\n"));
+		DEB_D("...using port b\n");
 		WRITE_RPS1(CMD_PAUSE | CMD_OAN | CMD_SIG1 | CMD_E_FID_B);
 		WRITE_RPS1(CMD_PAUSE | CMD_OAN | CMD_SIG1 | CMD_O_FID_B);
 /*
 		WRITE_RPS1(CMD_PAUSE | MASK_09);
 */
 	} else {
-		DEB_D(("...using port a\n"));
+		DEB_D("...using port a\n");
 		WRITE_RPS1(CMD_PAUSE | MASK_10);
 	}
 	/* upload brs */
@@ -103,7 +103,7 @@ static int vbi_workaround(struct saa7146_dev *dev)
 
 		schedule();
 
-		DEB_VBI(("brs bug workaround %d/1.\n",i));
+		DEB_VBI("brs bug workaround %d/1\n", i);
 
 		remove_wait_queue(&vv->vbi_wq, &wait);
 		current->state = TASK_RUNNING;
@@ -116,7 +116,8 @@ static int vbi_workaround(struct saa7146_dev *dev)
 
 		if(signal_pending(current)) {
 
-			DEB_VBI(("aborted (rps:0x%08x).\n",saa7146_read(dev,RPS_ADDR1)));
+			DEB_VBI("aborted (rps:0x%08x)\n",
+				saa7146_read(dev, RPS_ADDR1));
 
 			/* stop rps1 for sure */
 			saa7146_write(dev, MC1, MASK_29);
@@ -207,7 +208,7 @@ static int buffer_activate(struct saa7146_dev *dev,
 	struct saa7146_vv *vv = dev->vv_data;
 	buf->vb.state = VIDEOBUF_ACTIVE;
 
-	DEB_VBI(("dev:%p, buf:%p, next:%p\n",dev,buf,next));
+	DEB_VBI("dev:%p, buf:%p, next:%p\n", dev, buf, next);
 	saa7146_set_vbi_capture(dev,buf,next);
 
 	mod_timer(&vv->vbi_q.timeout, jiffies+BUFFER_TIMEOUT);
@@ -228,10 +229,10 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,e
 	llength = vbi_pixel_to_capture;
 	size = lines * llength;
 
-	DEB_VBI(("vb:%p\n",vb));
+	DEB_VBI("vb:%p\n", vb);
 
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size) {
-		DEB_VBI(("size mismatch.\n"));
+		DEB_VBI("size mismatch\n");
 		return -EINVAL;
 	}
 
@@ -263,7 +264,7 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,e
 	return 0;
 
  oops:
-	DEB_VBI(("error out.\n"));
+	DEB_VBI("error out\n");
 	saa7146_dma_free(dev,q,buf);
 
 	return err;
@@ -279,7 +280,7 @@ static int buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned
 	*size = lines * llength;
 	*count = 2;
 
-	DEB_VBI(("count:%d, size:%d\n",*count,*size));
+	DEB_VBI("count:%d, size:%d\n", *count, *size);
 
 	return 0;
 }
@@ -292,7 +293,7 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_vv *vv = dev->vv_data;
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
-	DEB_VBI(("vb:%p\n",vb));
+	DEB_VBI("vb:%p\n", vb);
 	saa7146_buffer_queue(dev,&vv->vbi_q,buf);
 }
 
@@ -303,7 +304,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
-	DEB_VBI(("vb:%p\n",vb));
+	DEB_VBI("vb:%p\n", vb);
 	saa7146_dma_free(dev,q,buf);
 }
 
@@ -321,7 +322,7 @@ static void vbi_stop(struct saa7146_fh *fh, struct file *file)
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_vv *vv = dev->vv_data;
 	unsigned long flags;
-	DEB_VBI(("dev:%p, fh:%p\n",dev, fh));
+	DEB_VBI("dev:%p, fh:%p\n", dev, fh);
 
 	spin_lock_irqsave(&dev->slock,flags);
 
@@ -354,14 +355,14 @@ static void vbi_read_timeout(unsigned long data)
 	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_dev *dev = fh->dev;
 
-	DEB_VBI(("dev:%p, fh:%p\n",dev, fh));
+	DEB_VBI("dev:%p, fh:%p\n", dev, fh);
 
 	vbi_stop(fh, file);
 }
 
 static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 {
-	DEB_VBI(("dev:%p\n",dev));
+	DEB_VBI("dev:%p\n", dev);
 
 	INIT_LIST_HEAD(&vv->vbi_q.queue);
 
@@ -380,11 +381,11 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 	u32 arbtr_ctrl	= saa7146_read(dev, PCI_BT_V1);
 	int ret = 0;
 
-	DEB_VBI(("dev:%p, fh:%p\n",dev,fh));
+	DEB_VBI("dev:%p, fh:%p\n", dev, fh);
 
 	ret = saa7146_res_get(fh, RESOURCE_DMA3_BRS);
 	if (0 == ret) {
-		DEB_S(("cannot get vbi RESOURCE_DMA3_BRS resource\n"));
+		DEB_S("cannot get vbi RESOURCE_DMA3_BRS resource\n");
 		return -EBUSY;
 	}
 
@@ -425,7 +426,7 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 		saa7146_write(dev, BRS_CTRL, 0x00000001);
 
 		if (0 != (ret = vbi_workaround(dev))) {
-			DEB_VBI(("vbi workaround failed!\n"));
+			DEB_VBI("vbi workaround failed!\n");
 			/* return ret;*/
 		}
 	}
@@ -439,7 +440,7 @@ static void vbi_close(struct saa7146_dev *dev, struct file *file)
 {
 	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
-	DEB_VBI(("dev:%p, fh:%p\n",dev,fh));
+	DEB_VBI("dev:%p, fh:%p\n", dev, fh);
 
 	if( fh == vv->vbi_streaming ) {
 		vbi_stop(fh, file);
@@ -453,13 +454,13 @@ static void vbi_irq_done(struct saa7146_dev *dev, unsigned long status)
 	spin_lock(&dev->slock);
 
 	if (vv->vbi_q.curr) {
-		DEB_VBI(("dev:%p, curr:%p\n",dev,vv->vbi_q.curr));
+		DEB_VBI("dev:%p, curr:%p\n", dev, vv->vbi_q.curr);
 		/* this must be += 2, one count for each field */
 		vv->vbi_fieldcount+=2;
 		vv->vbi_q.curr->vb.field_count = vv->vbi_fieldcount;
 		saa7146_buffer_finish(dev,&vv->vbi_q,VIDEOBUF_DONE);
 	} else {
-		DEB_VBI(("dev:%p\n",dev));
+		DEB_VBI("dev:%p\n", dev);
 	}
 	saa7146_buffer_next(dev,&vv->vbi_q,1);
 
@@ -473,7 +474,7 @@ static ssize_t vbi_read(struct file *file, char __user *data, size_t count, loff
 	struct saa7146_vv *vv = dev->vv_data;
 	ssize_t ret = 0;
 
-	DEB_VBI(("dev:%p, fh:%p\n",dev,fh));
+	DEB_VBI("dev:%p, fh:%p\n", dev, fh);
 
 	if( NULL == vv->vbi_streaming ) {
 		// fixme: check if dma3 is available
@@ -482,7 +483,8 @@ static ssize_t vbi_read(struct file *file, char __user *data, size_t count, loff
 	}
 
 	if( fh != vv->vbi_streaming ) {
-		DEB_VBI(("open %p is already using vbi capture.",vv->vbi_streaming));
+		DEB_VBI("open %p is already using vbi capture\n",
+			vv->vbi_streaming);
 		return -EBUSY;
 	}
 
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 3a00253..cbde644 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <media/saa7146_vv.h>
 #include <media/v4l2-chip-ident.h>
 #include <linux/module.h>
@@ -95,7 +97,7 @@ struct saa7146_format* saa7146_format_by_fourcc(struct saa7146_dev *dev, int fou
 		}
 	}
 
-	DEB_D(("unknown pixelformat:'%4.4s'\n",(char *)&fourcc));
+	DEB_D("unknown pixelformat:'%4.4s'\n", (char *)&fourcc);
 	return NULL;
 }
 
@@ -108,32 +110,32 @@ int saa7146_start_preview(struct saa7146_fh *fh)
 	struct v4l2_format fmt;
 	int ret = 0, err = 0;
 
-	DEB_EE(("dev:%p, fh:%p\n",dev,fh));
+	DEB_EE("dev:%p, fh:%p\n", dev, fh);
 
 	/* check if we have overlay informations */
 	if( NULL == fh->ov.fh ) {
-		DEB_D(("no overlay data available. try S_FMT first.\n"));
+		DEB_D("no overlay data available. try S_FMT first.\n");
 		return -EAGAIN;
 	}
 
 	/* check if streaming capture is running */
 	if (IS_CAPTURE_ACTIVE(fh) != 0) {
-		DEB_D(("streaming capture is active.\n"));
+		DEB_D("streaming capture is active\n");
 		return -EBUSY;
 	}
 
 	/* check if overlay is running */
 	if (IS_OVERLAY_ACTIVE(fh) != 0) {
 		if (vv->video_fh == fh) {
-			DEB_D(("overlay is already active.\n"));
+			DEB_D("overlay is already active\n");
 			return 0;
 		}
-		DEB_D(("overlay is already active in another open.\n"));
+		DEB_D("overlay is already active in another open\n");
 		return -EBUSY;
 	}
 
 	if (0 == saa7146_res_get(fh, RESOURCE_DMA1_HPS|RESOURCE_DMA2_CLP)) {
-		DEB_D(("cannot get necessary overlay resources\n"));
+		DEB_D("cannot get necessary overlay resources\n");
 		return -EBUSY;
 	}
 
@@ -146,13 +148,13 @@ int saa7146_start_preview(struct saa7146_fh *fh)
 	fh->ov.win = fmt.fmt.win;
 	vv->ov_data = &fh->ov;
 
-	DEB_D(("%dx%d+%d+%d %s field=%s\n",
-		fh->ov.win.w.width,fh->ov.win.w.height,
-		fh->ov.win.w.left,fh->ov.win.w.top,
-		vv->ov_fmt->name,v4l2_field_names[fh->ov.win.field]));
+	DEB_D("%dx%d+%d+%d %s field=%s\n",
+	      fh->ov.win.w.width, fh->ov.win.w.height,
+	      fh->ov.win.w.left, fh->ov.win.w.top,
+	      vv->ov_fmt->name, v4l2_field_names[fh->ov.win.field]);
 
 	if (0 != (ret = saa7146_enable_overlay(fh))) {
-		DEB_D(("enabling overlay failed: %d\n",ret));
+		DEB_D("enabling overlay failed: %d\n", ret);
 		saa7146_res_free(vv->video_fh, RESOURCE_DMA1_HPS|RESOURCE_DMA2_CLP);
 		return ret;
 	}
@@ -169,22 +171,22 @@ int saa7146_stop_preview(struct saa7146_fh *fh)
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_vv *vv = dev->vv_data;
 
-	DEB_EE(("dev:%p, fh:%p\n",dev,fh));
+	DEB_EE("dev:%p, fh:%p\n", dev, fh);
 
 	/* check if streaming capture is running */
 	if (IS_CAPTURE_ACTIVE(fh) != 0) {
-		DEB_D(("streaming capture is active.\n"));
+		DEB_D("streaming capture is active\n");
 		return -EBUSY;
 	}
 
 	/* check if overlay is running at all */
 	if ((vv->video_status & STATUS_OVERLAY) == 0) {
-		DEB_D(("no active overlay.\n"));
+		DEB_D("no active overlay\n");
 		return 0;
 	}
 
 	if (vv->video_fh != fh) {
-		DEB_D(("overlay is active, but in another open.\n"));
+		DEB_D("overlay is active, but in another open\n");
 		return -EBUSY;
 	}
 
@@ -269,7 +271,7 @@ static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *bu
 	int length = dma->sglen;
 	struct saa7146_format *sfmt = saa7146_format_by_fourcc(dev,buf->fmt->pixelformat);
 
-	DEB_EE(("dev:%p, buf:%p, sg_len:%d\n",dev,buf,length));
+	DEB_EE("dev:%p, buf:%p, sg_len:%d\n", dev, buf, length);
 
 	if( 0 != IS_PLANAR(sfmt->trans)) {
 		struct saa7146_pgtable *pt1 = &buf->pt[0];
@@ -289,7 +291,8 @@ static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *bu
 				m3 = ((size+(size/2)+PAGE_SIZE)/PAGE_SIZE)-1;
 				o1 = size%PAGE_SIZE;
 				o2 = (size+(size/4))%PAGE_SIZE;
-				DEB_CAP(("size:%d, m1:%d, m2:%d, m3:%d, o1:%d, o2:%d\n",size,m1,m2,m3,o1,o2));
+				DEB_CAP("size:%d, m1:%d, m2:%d, m3:%d, o1:%d, o2:%d\n",
+					size, m1, m2, m3, o1, o2);
 				break;
 			}
 			case 16: {
@@ -299,7 +302,8 @@ static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *bu
 				m3 = ((2*size+PAGE_SIZE)/PAGE_SIZE)-1;
 				o1 = size%PAGE_SIZE;
 				o2 = (size+(size/2))%PAGE_SIZE;
-				DEB_CAP(("size:%d, m1:%d, m2:%d, m3:%d, o1:%d, o2:%d\n",size,m1,m2,m3,o1,o2));
+				DEB_CAP("size:%d, m1:%d, m2:%d, m3:%d, o1:%d, o2:%d\n",
+					size, m1, m2, m3, o1, o2);
 				break;
 			}
 			default: {
@@ -388,23 +392,23 @@ static int video_begin(struct saa7146_fh *fh)
 	unsigned int resource;
 	int ret = 0, err = 0;
 
-	DEB_EE(("dev:%p, fh:%p\n",dev,fh));
+	DEB_EE("dev:%p, fh:%p\n", dev, fh);
 
 	if ((vv->video_status & STATUS_CAPTURE) != 0) {
 		if (vv->video_fh == fh) {
-			DEB_S(("already capturing.\n"));
+			DEB_S("already capturing\n");
 			return 0;
 		}
-		DEB_S(("already capturing in another open.\n"));
+		DEB_S("already capturing in another open\n");
 		return -EBUSY;
 	}
 
 	if ((vv->video_status & STATUS_OVERLAY) != 0) {
-		DEB_S(("warning: suspending overlay video for streaming capture.\n"));
+		DEB_S("warning: suspending overlay video for streaming capture\n");
 		vv->ov_suspend = vv->video_fh;
 		err = saa7146_stop_preview(vv->video_fh); /* side effect: video_status is now 0, video_fh is NULL */
 		if (0 != err) {
-			DEB_D(("suspending video failed. aborting\n"));
+			DEB_D("suspending video failed. aborting\n");
 			return err;
 		}
 	}
@@ -421,7 +425,7 @@ static int video_begin(struct saa7146_fh *fh)
 
 	ret = saa7146_res_get(fh, resource);
 	if (0 == ret) {
-		DEB_S(("cannot get capture resource %d\n",resource));
+		DEB_S("cannot get capture resource %d\n", resource);
 		if (vv->ov_suspend != NULL) {
 			saa7146_start_preview(vv->ov_suspend);
 			vv->ov_suspend = NULL;
@@ -449,15 +453,15 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 	unsigned long flags;
 	unsigned int resource;
 	u32 dmas = 0;
-	DEB_EE(("dev:%p, fh:%p\n",dev,fh));
+	DEB_EE("dev:%p, fh:%p\n", dev, fh);
 
 	if ((vv->video_status & STATUS_CAPTURE) != STATUS_CAPTURE) {
-		DEB_S(("not capturing.\n"));
+		DEB_S("not capturing\n");
 		return 0;
 	}
 
 	if (vv->video_fh != fh) {
-		DEB_S(("capturing, but in another open.\n"));
+		DEB_S("capturing, but in another open\n");
 		return -EBUSY;
 	}
 
@@ -531,7 +535,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 	struct saa7146_vv *vv = dev->vv_data;
 	struct saa7146_format *fmt;
 
-	DEB_EE(("VIDIOC_S_FBUF\n"));
+	DEB_EE("VIDIOC_S_FBUF\n");
 
 	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -543,13 +547,13 @@ static int vidioc_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 
 	/* planar formats are not allowed for overlay video, clipping and video dma would clash */
 	if (fmt->flags & FORMAT_IS_PLANAR)
-		DEB_S(("planar pixelformat '%4.4s' not allowed for overlay\n",
-					(char *)&fmt->pixelformat));
+		DEB_S("planar pixelformat '%4.4s' not allowed for overlay\n",
+		      (char *)&fmt->pixelformat);
 
 	/* check if overlay is running */
 	if (IS_OVERLAY_ACTIVE(fh) != 0) {
 		if (vv->video_fh != fh) {
-			DEB_D(("refusing to change framebuffer informations while overlay is active in another open.\n"));
+			DEB_D("refusing to change framebuffer informations while overlay is active in another open\n");
 			return -EBUSY;
 		}
 	}
@@ -560,7 +564,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 
 	if (vv->ov_fb.fmt.bytesperline < vv->ov_fb.fmt.width) {
 		vv->ov_fb.fmt.bytesperline = vv->ov_fb.fmt.width * fmt->depth / 8;
-		DEB_D(("setting bytesperline to %d\n", vv->ov_fb.fmt.bytesperline));
+		DEB_D("setting bytesperline to %d\n", vv->ov_fb.fmt.bytesperline);
 	}
 	return 0;
 }
@@ -589,7 +593,7 @@ static int vidioc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *
 	if (ctrl == NULL)
 		return -EINVAL;
 
-	DEB_EE(("VIDIOC_QUERYCTRL: id:%d\n", c->id));
+	DEB_EE("VIDIOC_QUERYCTRL: id:%d\n", c->id);
 	*c = *ctrl;
 	return 0;
 }
@@ -608,25 +612,25 @@ static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *c)
 	case V4L2_CID_BRIGHTNESS:
 		value = saa7146_read(dev, BCS_CTRL);
 		c->value = 0xff & (value >> 24);
-		DEB_D(("V4L2_CID_BRIGHTNESS: %d\n", c->value));
+		DEB_D("V4L2_CID_BRIGHTNESS: %d\n", c->value);
 		break;
 	case V4L2_CID_CONTRAST:
 		value = saa7146_read(dev, BCS_CTRL);
 		c->value = 0x7f & (value >> 16);
-		DEB_D(("V4L2_CID_CONTRAST: %d\n", c->value));
+		DEB_D("V4L2_CID_CONTRAST: %d\n", c->value);
 		break;
 	case V4L2_CID_SATURATION:
 		value = saa7146_read(dev, BCS_CTRL);
 		c->value = 0x7f & (value >> 0);
-		DEB_D(("V4L2_CID_SATURATION: %d\n", c->value));
+		DEB_D("V4L2_CID_SATURATION: %d\n", c->value);
 		break;
 	case V4L2_CID_VFLIP:
 		c->value = vv->vflip;
-		DEB_D(("V4L2_CID_VFLIP: %d\n", c->value));
+		DEB_D("V4L2_CID_VFLIP: %d\n", c->value);
 		break;
 	case V4L2_CID_HFLIP:
 		c->value = vv->hflip;
-		DEB_D(("V4L2_CID_HFLIP: %d\n", c->value));
+		DEB_D("V4L2_CID_HFLIP: %d\n", c->value);
 		break;
 	default:
 		return -EINVAL;
@@ -642,7 +646,7 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
 
 	ctrl = ctrl_by_id(c->id);
 	if (NULL == ctrl) {
-		DEB_D(("unknown control %d\n", c->id));
+		DEB_D("unknown control %d\n", c->id);
 		return -EINVAL;
 	}
 
@@ -687,14 +691,14 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
 	case V4L2_CID_HFLIP:
 		/* fixme: we can support changing VFLIP and HFLIP here... */
 		if (IS_CAPTURE_ACTIVE(fh) != 0) {
-			DEB_D(("V4L2_CID_HFLIP while active capture.\n"));
+			DEB_D("V4L2_CID_HFLIP while active capture\n");
 			return -EBUSY;
 		}
 		vv->hflip = c->value;
 		break;
 	case V4L2_CID_VFLIP:
 		if (IS_CAPTURE_ACTIVE(fh) != 0) {
-			DEB_D(("V4L2_CID_VFLIP while active capture.\n"));
+			DEB_D("V4L2_CID_VFLIP while active capture\n");
 			return -EBUSY;
 		}
 		vv->vflip = c->value;
@@ -749,7 +753,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_forma
 	int maxw, maxh;
 	int calc_bpl;
 
-	DEB_EE(("V4L2_BUF_TYPE_VIDEO_CAPTURE: dev:%p, fh:%p\n", dev, fh));
+	DEB_EE("V4L2_BUF_TYPE_VIDEO_CAPTURE: dev:%p, fh:%p\n", dev, fh);
 
 	fmt = saa7146_format_by_fourcc(dev, f->fmt.pix.pixelformat);
 	if (NULL == fmt)
@@ -778,7 +782,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_forma
 		vv->last_field = V4L2_FIELD_INTERLACED;
 		break;
 	default:
-		DEB_D(("no known field mode '%d'.\n", field));
+		DEB_D("no known field mode '%d'\n", field);
 		return -EINVAL;
 	}
 
@@ -797,8 +801,9 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_forma
 		f->fmt.pix.bytesperline = calc_bpl;
 
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
-	DEB_D(("w:%d, h:%d, bytesperline:%d, sizeimage:%d\n", f->fmt.pix.width,
-			f->fmt.pix.height, f->fmt.pix.bytesperline, f->fmt.pix.sizeimage));
+	DEB_D("w:%d, h:%d, bytesperline:%d, sizeimage:%d\n",
+	      f->fmt.pix.width, f->fmt.pix.height,
+	      f->fmt.pix.bytesperline, f->fmt.pix.sizeimage);
 
 	return 0;
 }
@@ -812,22 +817,23 @@ static int vidioc_try_fmt_vid_overlay(struct file *file, void *fh, struct v4l2_f
 	enum v4l2_field field;
 	int maxw, maxh;
 
-	DEB_EE(("dev:%p\n", dev));
+	DEB_EE("dev:%p\n", dev);
 
 	if (NULL == vv->ov_fb.base) {
-		DEB_D(("no fb base set.\n"));
+		DEB_D("no fb base set\n");
 		return -EINVAL;
 	}
 	if (NULL == vv->ov_fmt) {
-		DEB_D(("no fb fmt set.\n"));
+		DEB_D("no fb fmt set\n");
 		return -EINVAL;
 	}
 	if (win->w.width < 48 || win->w.height < 32) {
-		DEB_D(("min width/height. (%d,%d)\n", win->w.width, win->w.height));
+		DEB_D("min width/height. (%d,%d)\n",
+		      win->w.width, win->w.height);
 		return -EINVAL;
 	}
 	if (win->clipcount > 16) {
-		DEB_D(("clipcount too big.\n"));
+		DEB_D("clipcount too big\n");
 		return -EINVAL;
 	}
 
@@ -849,7 +855,7 @@ static int vidioc_try_fmt_vid_overlay(struct file *file, void *fh, struct v4l2_f
 	case V4L2_FIELD_INTERLACED:
 		break;
 	default:
-		DEB_D(("no known field mode '%d'.\n", field));
+		DEB_D("no known field mode '%d'\n", field);
 		return -EINVAL;
 	}
 
@@ -869,16 +875,17 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *__fh, struct v4l2_forma
 	struct saa7146_vv *vv = dev->vv_data;
 	int err;
 
-	DEB_EE(("V4L2_BUF_TYPE_VIDEO_CAPTURE: dev:%p, fh:%p\n", dev, fh));
+	DEB_EE("V4L2_BUF_TYPE_VIDEO_CAPTURE: dev:%p, fh:%p\n", dev, fh);
 	if (IS_CAPTURE_ACTIVE(fh) != 0) {
-		DEB_EE(("streaming capture is active\n"));
+		DEB_EE("streaming capture is active\n");
 		return -EBUSY;
 	}
 	err = vidioc_try_fmt_vid_cap(file, fh, f);
 	if (0 != err)
 		return err;
 	fh->video_fmt = f->fmt.pix;
-	DEB_EE(("set to pixelformat '%4.4s'\n", (char *)&fh->video_fmt.pixelformat));
+	DEB_EE("set to pixelformat '%4.4s'\n",
+	       (char *)&fh->video_fmt.pixelformat);
 	return 0;
 }
 
@@ -889,7 +896,7 @@ static int vidioc_s_fmt_vid_overlay(struct file *file, void *__fh, struct v4l2_f
 	struct saa7146_vv *vv = dev->vv_data;
 	int err;
 
-	DEB_EE(("V4L2_BUF_TYPE_VIDEO_OVERLAY: dev:%p, fh:%p\n", dev, fh));
+	DEB_EE("V4L2_BUF_TYPE_VIDEO_OVERLAY: dev:%p, fh:%p\n", dev, fh);
 	err = vidioc_try_fmt_vid_overlay(file, fh, f);
 	if (0 != err)
 		return err;
@@ -932,7 +939,7 @@ static int vidioc_g_std(struct file *file, void *fh, v4l2_std_id *norm)
 		if (e->index < 0 )
 			return -EINVAL;
 		if( e->index < dev->ext_vv_data->num_stds ) {
-			DEB_EE(("VIDIOC_ENUMSTD: index:%d\n",e->index));
+			DEB_EE("VIDIOC_ENUMSTD: index:%d\n", e->index);
 			v4l2_video_std_construct(e, dev->ext_vv_data->stds[e->index].id, dev->ext_vv_data->stds[e->index].name);
 			return 0;
 		}
@@ -947,10 +954,10 @@ static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *id)
 	int found = 0;
 	int err, i;
 
-	DEB_EE(("VIDIOC_S_STD\n"));
+	DEB_EE("VIDIOC_S_STD\n");
 
 	if ((vv->video_status & STATUS_CAPTURE) == STATUS_CAPTURE) {
-		DEB_D(("cannot change video standard while streaming capture is active\n"));
+		DEB_D("cannot change video standard while streaming capture is active\n");
 		return -EBUSY;
 	}
 
@@ -958,7 +965,7 @@ static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *id)
 		vv->ov_suspend = vv->video_fh;
 		err = saa7146_stop_preview(vv->video_fh); /* side effect: video_status is now 0, video_fh is NULL */
 		if (0 != err) {
-			DEB_D(("suspending video failed. aborting\n"));
+			DEB_D("suspending video failed. aborting\n");
 			return err;
 		}
 	}
@@ -979,11 +986,11 @@ static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *id)
 	}
 
 	if (!found) {
-		DEB_EE(("VIDIOC_S_STD: standard not found.\n"));
+		DEB_EE("VIDIOC_S_STD: standard not found\n");
 		return -EINVAL;
 	}
 
-	DEB_EE(("VIDIOC_S_STD: set to standard to '%s'\n", vv->standard->name));
+	DEB_EE("VIDIOC_S_STD: set to standard to '%s'\n", vv->standard->name);
 	return 0;
 }
 
@@ -991,7 +998,7 @@ static int vidioc_overlay(struct file *file, void *fh, unsigned int on)
 {
 	int err;
 
-	DEB_D(("VIDIOC_OVERLAY on:%d\n", on));
+	DEB_D("VIDIOC_OVERLAY on:%d\n", on);
 	if (on)
 		err = saa7146_start_preview(fh);
 	else
@@ -1048,7 +1055,7 @@ static int vidioc_streamon(struct file *file, void *__fh, enum v4l2_buf_type typ
 	struct saa7146_fh *fh = __fh;
 	int err;
 
-	DEB_D(("VIDIOC_STREAMON, type:%d\n", type));
+	DEB_D("VIDIOC_STREAMON, type:%d\n", type);
 
 	err = video_begin(fh);
 	if (err)
@@ -1067,18 +1074,18 @@ static int vidioc_streamoff(struct file *file, void *__fh, enum v4l2_buf_type ty
 	struct saa7146_vv *vv = dev->vv_data;
 	int err;
 
-	DEB_D(("VIDIOC_STREAMOFF, type:%d\n", type));
+	DEB_D("VIDIOC_STREAMOFF, type:%d\n", type);
 
 	/* ugly: we need to copy some checks from video_end(),
 	   because videobuf_streamoff() relies on the capture running.
 	   check and fix this */
 	if ((vv->video_status & STATUS_CAPTURE) != STATUS_CAPTURE) {
-		DEB_S(("not capturing.\n"));
+		DEB_S("not capturing\n");
 		return 0;
 	}
 
 	if (vv->video_fh != fh) {
-		DEB_S(("capturing, but in another open.\n"));
+		DEB_S("capturing, but in another open\n");
 		return -EBUSY;
 	}
 
@@ -1088,7 +1095,7 @@ static int vidioc_streamoff(struct file *file, void *__fh, enum v4l2_buf_type ty
 	else if (type == V4L2_BUF_TYPE_VBI_CAPTURE)
 		err = videobuf_streamoff(&fh->vbi_q);
 	if (0 != err) {
-		DEB_D(("warning: videobuf_streamoff() failed.\n"));
+		DEB_D("warning: videobuf_streamoff() failed\n");
 		video_end(fh, file);
 	} else {
 		err = video_end(fh, file);
@@ -1175,25 +1182,27 @@ static int buffer_prepare(struct videobuf_queue *q,
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 	int size,err = 0;
 
-	DEB_CAP(("vbuf:%p\n",vb));
+	DEB_CAP("vbuf:%p\n", vb);
 
 	/* sanity checks */
 	if (fh->video_fmt.width  < 48 ||
 	    fh->video_fmt.height < 32 ||
 	    fh->video_fmt.width  > vv->standard->h_max_out ||
 	    fh->video_fmt.height > vv->standard->v_max_out) {
-		DEB_D(("w (%d) / h (%d) out of bounds.\n",fh->video_fmt.width,fh->video_fmt.height));
+		DEB_D("w (%d) / h (%d) out of bounds\n",
+		      fh->video_fmt.width, fh->video_fmt.height);
 		return -EINVAL;
 	}
 
 	size = fh->video_fmt.sizeimage;
 	if (0 != buf->vb.baddr && buf->vb.bsize < size) {
-		DEB_D(("size mismatch.\n"));
+		DEB_D("size mismatch\n");
 		return -EINVAL;
 	}
 
-	DEB_CAP(("buffer_prepare [size=%dx%d,bytes=%d,fields=%s]\n",
-		fh->video_fmt.width,fh->video_fmt.height,size,v4l2_field_names[fh->video_fmt.field]));
+	DEB_CAP("buffer_prepare [size=%dx%d,bytes=%d,fields=%s]\n",
+		fh->video_fmt.width, fh->video_fmt.height,
+		size, v4l2_field_names[fh->video_fmt.field]);
 	if (buf->vb.width  != fh->video_fmt.width  ||
 	    buf->vb.bytesperline != fh->video_fmt.bytesperline ||
 	    buf->vb.height != fh->video_fmt.height ||
@@ -1239,7 +1248,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 	return 0;
 
  oops:
-	DEB_D(("error out.\n"));
+	DEB_D("error out\n");
 	saa7146_dma_free(dev,q,buf);
 
 	return err;
@@ -1260,7 +1269,7 @@ static int buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned
 		*count = (max_memory*1048576) / *size;
 	}
 
-	DEB_CAP(("%d buffers, %d bytes each.\n",*count,*size));
+	DEB_CAP("%d buffers, %d bytes each\n", *count, *size);
 
 	return 0;
 }
@@ -1273,7 +1282,7 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_vv *vv = dev->vv_data;
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
-	DEB_CAP(("vbuf:%p\n",vb));
+	DEB_CAP("vbuf:%p\n", vb);
 	saa7146_buffer_queue(fh->dev,&vv->video_q,buf);
 }
 
@@ -1284,7 +1293,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
-	DEB_CAP(("vbuf:%p\n",vb));
+	DEB_CAP("vbuf:%p\n", vb);
 
 	saa7146_dma_free(dev,q,buf);
 
@@ -1369,7 +1378,7 @@ static void video_irq_done(struct saa7146_dev *dev, unsigned long st)
 	struct saa7146_dmaqueue *q = &vv->video_q;
 
 	spin_lock(&dev->slock);
-	DEB_CAP(("called.\n"));
+	DEB_CAP("called\n");
 
 	/* only finish the buffer if we have one... */
 	if( NULL != q->curr ) {
@@ -1387,15 +1396,15 @@ static ssize_t video_read(struct file *file, char __user *data, size_t count, lo
 	struct saa7146_vv *vv = dev->vv_data;
 	ssize_t ret = 0;
 
-	DEB_EE(("called.\n"));
+	DEB_EE("called\n");
 
 	if ((vv->video_status & STATUS_CAPTURE) != 0) {
 		/* fixme: should we allow read() captures while streaming capture? */
 		if (vv->video_fh == fh) {
-			DEB_S(("already capturing.\n"));
+			DEB_S("already capturing\n");
 			return -EBUSY;
 		}
-		DEB_S(("already capturing in another open.\n"));
+		DEB_S("already capturing in another open\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index cdd31ca..ee8ee1d 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -25,6 +25,8 @@
  * the project's page is at http://www.linuxtv.org/ 
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/delay.h>
@@ -253,7 +255,7 @@ static int av7110_dvb_c_switch(struct saa7146_fh *fh)
 
 		switch (av7110->current_input) {
 		case 1:
-			dprintk(1, "switching SAA7113 to Analog Tuner Input.\n");
+			dprintk(1, "switching SAA7113 to Analog Tuner Input\n");
 			msp_writereg(av7110, MSP_WR_DSP, 0x0008, 0x0000); // loudspeaker source
 			msp_writereg(av7110, MSP_WR_DSP, 0x0009, 0x0000); // headphone source
 			msp_writereg(av7110, MSP_WR_DSP, 0x000a, 0x0000); // SCART 1 source
@@ -263,7 +265,7 @@ static int av7110_dvb_c_switch(struct saa7146_fh *fh)
 
 			if (av7110->analog_tuner_flags & ANALOG_TUNER_VES1820) {
 				if (ves1820_writereg(dev, 0x09, 0x0f, 0x60))
-					dprintk(1, "setting band in demodulator failed.\n");
+					dprintk(1, "setting band in demodulator failed\n");
 			} else if (av7110->analog_tuner_flags & ANALOG_TUNER_STV0297) {
 				saa7146_setgpio(dev, 1, SAA7146_GPIO_OUTHI); // TDA9819 pin9(STD)
 				saa7146_setgpio(dev, 3, SAA7146_GPIO_OUTHI); // TDA9819 pin30(VIF)
@@ -272,17 +274,17 @@ static int av7110_dvb_c_switch(struct saa7146_fh *fh)
 				dprintk(1, "saa7113 write failed @ card %d", av7110->dvb_adapter.num);
 			break;
 		case 2:
-			dprintk(1, "switching SAA7113 to Video AV CVBS Input.\n");
+			dprintk(1, "switching SAA7113 to Video AV CVBS Input\n");
 			if (i2c_writereg(av7110, 0x48, 0x02, 0xd2) != 1)
 				dprintk(1, "saa7113 write failed @ card %d", av7110->dvb_adapter.num);
 			break;
 		case 3:
-			dprintk(1, "switching SAA7113 to Video AV Y/C Input.\n");
+			dprintk(1, "switching SAA7113 to Video AV Y/C Input\n");
 			if (i2c_writereg(av7110, 0x48, 0x02, 0xd9) != 1)
 				dprintk(1, "saa7113 write failed @ card %d", av7110->dvb_adapter.num);
 			break;
 		default:
-			dprintk(1, "switching SAA7113 to Input: AV7110: SAA7113: invalid input.\n");
+			dprintk(1, "switching SAA7113 to Input: AV7110: SAA7113: invalid input\n");
 		}
 	} else {
 		adswitch = 0;
@@ -299,7 +301,7 @@ static int av7110_dvb_c_switch(struct saa7146_fh *fh)
 
 		if (av7110->analog_tuner_flags & ANALOG_TUNER_VES1820) {
 			if (ves1820_writereg(dev, 0x09, 0x0f, 0x20))
-				dprintk(1, "setting band in demodulator failed.\n");
+				dprintk(1, "setting band in demodulator failed\n");
 		} else if (av7110->analog_tuner_flags & ANALOG_TUNER_STV0297) {
 			saa7146_setgpio(dev, 1, SAA7146_GPIO_OUTLO); // TDA9819 pin9(STD)
 			saa7146_setgpio(dev, 3, SAA7146_GPIO_OUTLO); // TDA9819 pin30(VIF)
@@ -413,7 +415,7 @@ static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
 
-	dprintk(2, "VIDIOC_G_FREQ: freq:0x%08x.\n", f->frequency);
+	dprintk(2, "VIDIOC_G_FREQ: freq:0x%08x\n", f->frequency);
 
 	if (!av7110->analog_tuner_flags || av7110->current_input != 1)
 		return -EINVAL;
@@ -429,7 +431,7 @@ static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
 
-	dprintk(2, "VIDIOC_S_FREQUENCY: freq:0x%08x.\n", f->frequency);
+	dprintk(2, "VIDIOC_S_FREQUENCY: freq:0x%08x\n", f->frequency);
 
 	if (!av7110->analog_tuner_flags || av7110->current_input != 1)
 		return -EINVAL;
@@ -689,12 +691,12 @@ int av7110_init_analog_module(struct av7110 *av7110)
 
 	if (i2c_writereg(av7110, 0x80, 0x0, 0x80) == 1 &&
 	    i2c_writereg(av7110, 0x80, 0x0, 0) == 1) {
-		printk("dvb-ttpci: DVB-C analog module @ card %d detected, initializing MSP3400\n",
+		pr_info("DVB-C analog module @ card %d detected, initializing MSP3400\n",
 			av7110->dvb_adapter.num);
 		av7110->adac_type = DVB_ADAC_MSP34x0;
 	} else if (i2c_writereg(av7110, 0x84, 0x0, 0x80) == 1 &&
 		   i2c_writereg(av7110, 0x84, 0x0, 0) == 1) {
-		printk("dvb-ttpci: DVB-C analog module @ card %d detected, initializing MSP3415\n",
+		pr_info("DVB-C analog module @ card %d detected, initializing MSP3415\n",
 			av7110->dvb_adapter.num);
 		av7110->adac_type = DVB_ADAC_MSP34x5;
 	} else
@@ -715,7 +717,7 @@ int av7110_init_analog_module(struct av7110 *av7110)
 	msp_writereg(av7110, MSP_WR_DSP, 0x000d, 0x1900); // prescale SCART
 
 	if (i2c_writereg(av7110, 0x48, 0x01, 0x00)!=1) {
-		INFO(("saa7113 not accessible.\n"));
+		pr_info("saa7113 not accessible\n");
 	} else {
 		u8 *i = saa7113_init_regs;
 
@@ -733,7 +735,7 @@ int av7110_init_analog_module(struct av7110 *av7110)
 		/* setup for DVB by default */
 		if (av7110->analog_tuner_flags & ANALOG_TUNER_VES1820) {
 			if (ves1820_writereg(av7110->dev, 0x09, 0x0f, 0x20))
-				dprintk(1, "setting band in demodulator failed.\n");
+				dprintk(1, "setting band in demodulator failed\n");
 		} else if (av7110->analog_tuner_flags & ANALOG_TUNER_STV0297) {
 			saa7146_setgpio(av7110->dev, 1, SAA7146_GPIO_OUTLO); // TDA9819 pin9(STD)
 			saa7146_setgpio(av7110->dev, 3, SAA7146_GPIO_OUTLO); // TDA9819 pin30(VIF)
@@ -797,7 +799,7 @@ int av7110_init_v4l(struct av7110 *av7110)
 	ret = saa7146_vv_init(dev, vv_data);
 
 	if (ret) {
-		ERR(("cannot init capture device. skipping.\n"));
+		ERR("cannot init capture device. skipping\n");
 		return -ENODEV;
 	}
 	vv_data->ops.vidioc_enum_input = vidioc_enum_input;
@@ -814,12 +816,12 @@ int av7110_init_v4l(struct av7110 *av7110)
 	vv_data->ops.vidioc_s_fmt_sliced_vbi_out = vidioc_s_fmt_sliced_vbi_out;
 
 	if (saa7146_register_device(&av7110->v4l_dev, dev, "av7110", VFL_TYPE_GRABBER)) {
-		ERR(("cannot register capture device. skipping.\n"));
+		ERR("cannot register capture device. skipping\n");
 		saa7146_vv_release(dev);
 		return -ENODEV;
 	}
 	if (saa7146_register_device(&av7110->vbi_dev, dev, "av7110", VFL_TYPE_VBI))
-		ERR(("cannot register vbi v4l2 device. skipping.\n"));
+		ERR("cannot register vbi v4l2 device. skipping\n");
 	return 0;
 }
 
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index e957d76..5934142 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -33,6 +33,8 @@
  * the project's page is at http://www.linuxtv.org/ 
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "budget.h"
 #include "stv0299.h"
 #include "stb0899_drv.h"
@@ -149,7 +151,7 @@ static int ciintf_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int ad
 	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 0xfff, 1, 0, 1);
 	if (result == -ETIMEDOUT) {
 		ciintf_slot_shutdown(ca, slot);
-		printk(KERN_INFO "budget-av: cam ejected 1\n");
+		pr_info("cam ejected 1\n");
 	}
 	return result;
 }
@@ -168,7 +170,7 @@ static int ciintf_write_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int a
 	result = ttpci_budget_debiwrite(&budget_av->budget, DEBICICAM, address & 0xfff, 1, value, 0, 1);
 	if (result == -ETIMEDOUT) {
 		ciintf_slot_shutdown(ca, slot);
-		printk(KERN_INFO "budget-av: cam ejected 2\n");
+		pr_info("cam ejected 2\n");
 	}
 	return result;
 }
@@ -187,7 +189,7 @@ static int ciintf_read_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 addre
 	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 3, 1, 0, 0);
 	if (result == -ETIMEDOUT) {
 		ciintf_slot_shutdown(ca, slot);
-		printk(KERN_INFO "budget-av: cam ejected 3\n");
+		pr_info("cam ejected 3\n");
 		return -ETIMEDOUT;
 	}
 	return result;
@@ -207,7 +209,7 @@ static int ciintf_write_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 addr
 	result = ttpci_budget_debiwrite(&budget_av->budget, DEBICICAM, address & 3, 1, value, 0, 0);
 	if (result == -ETIMEDOUT) {
 		ciintf_slot_shutdown(ca, slot);
-		printk(KERN_INFO "budget-av: cam ejected 5\n");
+		pr_info("cam ejected 5\n");
 	}
 	return result;
 }
@@ -289,7 +291,7 @@ static int ciintf_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open
 		if (saa7146_read(saa, PSR) & MASK_06) {
 			if (budget_av->slot_status == SLOTSTATUS_NONE) {
 				budget_av->slot_status = SLOTSTATUS_PRESENT;
-				printk(KERN_INFO "budget-av: cam inserted A\n");
+				pr_info("cam inserted A\n");
 			}
 		}
 		saa7146_setgpio(saa, 3, SAA7146_GPIO_OUTLO);
@@ -306,11 +308,11 @@ static int ciintf_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open
 		result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, 0, 1, 0, 1);
 		if ((result >= 0) && (budget_av->slot_status == SLOTSTATUS_NONE)) {
 			budget_av->slot_status = SLOTSTATUS_PRESENT;
-			printk(KERN_INFO "budget-av: cam inserted B\n");
+			pr_info("cam inserted B\n");
 		} else if (result < 0) {
 			if (budget_av->slot_status != SLOTSTATUS_NONE) {
 				ciintf_slot_shutdown(ca, slot);
-				printk(KERN_INFO "budget-av: cam ejected 5\n");
+				pr_info("cam ejected 5\n");
 				return 0;
 			}
 		}
@@ -365,11 +367,11 @@ static int ciintf_init(struct budget_av *budget_av)
 
 	if ((result = dvb_ca_en50221_init(&budget_av->budget.dvb_adapter,
 					  &budget_av->ca, 0, 1)) != 0) {
-		printk(KERN_ERR "budget-av: ci initialisation failed.\n");
+		pr_err("ci initialisation failed\n");
 		goto error;
 	}
 
-	printk(KERN_INFO "budget-av: ci interface initialised.\n");
+	pr_info("ci interface initialised\n");
 	return 0;
 
 error:
@@ -1343,8 +1345,7 @@ static void frontend_init(struct budget_av *budget_av)
 	}
 
 	if (fe == NULL) {
-		printk(KERN_ERR "budget-av: A frontend driver was not found "
-				"for device [%04x:%04x] subsystem [%04x:%04x]\n",
+		pr_err("A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       saa->pci->vendor,
 		       saa->pci->device,
 		       saa->pci->subsystem_vendor,
@@ -1356,7 +1357,7 @@ static void frontend_init(struct budget_av *budget_av)
 
 	if (dvb_register_frontend(&budget_av->budget.dvb_adapter,
 				  budget_av->budget.dvb_frontend)) {
-		printk(KERN_ERR "budget-av: Frontend registration failed!\n");
+		pr_err("Frontend registration failed!\n");
 		dvb_frontend_detach(budget_av->budget.dvb_frontend);
 		budget_av->budget.dvb_frontend = NULL;
 	}
@@ -1414,7 +1415,7 @@ static struct v4l2_input knc1_inputs[KNC1_INPUTS] = {
 
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
-	dprintk(1, "VIDIOC_ENUMINPUT %d.\n", i->index);
+	dprintk(1, "VIDIOC_ENUMINPUT %d\n", i->index);
 	if (i->index >= KNC1_INPUTS)
 		return -EINVAL;
 	memcpy(i, &knc1_inputs[i->index], sizeof(struct v4l2_input));
@@ -1428,7 +1429,7 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
 
 	*i = budget_av->cur_input;
 
-	dprintk(1, "VIDIOC_G_INPUT %d.\n", *i);
+	dprintk(1, "VIDIOC_G_INPUT %d\n", *i);
 	return 0;
 }
 
@@ -1437,7 +1438,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct budget_av *budget_av = (struct budget_av *)dev->ext_priv;
 
-	dprintk(1, "VIDIOC_S_INPUT %d.\n", input);
+	dprintk(1, "VIDIOC_S_INPUT %d\n", input);
 	return saa7113_setinput(budget_av, input);
 }
 
@@ -1476,7 +1477,7 @@ static int budget_av_attach(struct saa7146_dev *dev, struct saa7146_pci_extensio
 
 		if (0 != saa7146_vv_init(dev, &vv_data)) {
 			/* fixme: proper cleanup here */
-			ERR(("cannot init vv subsystem.\n"));
+			ERR("cannot init vv subsystem\n");
 			return err;
 		}
 		vv_data.ops.vidioc_enum_input = vidioc_enum_input;
@@ -1485,7 +1486,7 @@ static int budget_av_attach(struct saa7146_dev *dev, struct saa7146_pci_extensio
 
 		if ((err = saa7146_register_device(&budget_av->vd, dev, "knc1", VFL_TYPE_GRABBER))) {
 			/* fixme: proper cleanup here */
-			ERR(("cannot register capture v4l2 device.\n"));
+			ERR("cannot register capture v4l2 device\n");
 			saa7146_vv_release(dev);
 			return err;
 		}
@@ -1502,13 +1503,12 @@ static int budget_av_attach(struct saa7146_dev *dev, struct saa7146_pci_extensio
 
 	mac = budget_av->budget.dvb_adapter.proposed_mac;
 	if (i2c_readregs(&budget_av->budget.i2c_adap, 0xa0, 0x30, mac, 6)) {
-		printk(KERN_ERR "KNC1-%d: Could not read MAC from KNC1 card\n",
+		pr_err("KNC1-%d: Could not read MAC from KNC1 card\n",
 		       budget_av->budget.dvb_adapter.num);
 		memset(mac, 0, 6);
 	} else {
-		printk(KERN_INFO "KNC1-%d: MAC addr = %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
-		       budget_av->budget.dvb_adapter.num,
-		       mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+		pr_info("KNC1-%d: MAC addr = %pM\n",
+			budget_av->budget.dvb_adapter.num, mac);
 	}
 
 	budget_av->budget.dvb_adapter.priv = budget_av;
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index a470756..a465196 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -21,6 +21,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DEBUG_VARIABLE debug
 
 #include <media/saa7146_vv.h>
@@ -176,13 +178,14 @@ static int hexium_init_done(struct saa7146_dev *dev)
 	union i2c_smbus_data data;
 	int i = 0;
 
-	DEB_D(("hexium_init_done called.\n"));
+	DEB_D("hexium_init_done called\n");
 
 	/* initialize the helper ics to useful values */
 	for (i = 0; i < sizeof(hexium_ks0127b); i++) {
 		data.byte = hexium_ks0127b[i];
 		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, i, I2C_SMBUS_BYTE_DATA, &data)) {
-			printk("hexium_gemini: hexium_init_done() failed for address 0x%02x\n", i);
+			pr_err("hexium_init_done() failed for address 0x%02x\n",
+			       i);
 		}
 	}
 
@@ -193,7 +196,7 @@ static int hexium_set_input(struct hexium *hexium, int input)
 {
 	union i2c_smbus_data data;
 
-	DEB_D((".\n"));
+	DEB_D("\n");
 
 	data.byte = hexium_input_select[input].byte;
 	if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, hexium_input_select[input].adr, I2C_SMBUS_BYTE_DATA, &data)) {
@@ -208,12 +211,13 @@ static int hexium_set_standard(struct hexium *hexium, struct hexium_data *vdec)
 	union i2c_smbus_data data;
 	int i = 0;
 
-	DEB_D((".\n"));
+	DEB_D("\n");
 
 	while (vdec[i].adr != -1) {
 		data.byte = vdec[i].byte;
 		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x6c, 0, I2C_SMBUS_WRITE, vdec[i].adr, I2C_SMBUS_BYTE_DATA, &data)) {
-			printk("hexium_init_done: hexium_set_standard() failed for address 0x%02x\n", i);
+			pr_err("hexium_init_done: hexium_set_standard() failed for address 0x%02x\n",
+			       i);
 			return -1;
 		}
 		i++;
@@ -223,14 +227,14 @@ static int hexium_set_standard(struct hexium *hexium, struct hexium_data *vdec)
 
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
-	DEB_EE(("VIDIOC_ENUMINPUT %d.\n", i->index));
+	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
 
 	if (i->index >= HEXIUM_INPUTS)
 		return -EINVAL;
 
 	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
 
-	DEB_D(("v4l2_ioctl: VIDIOC_ENUMINPUT %d.\n", i->index));
+	DEB_D("v4l2_ioctl: VIDIOC_ENUMINPUT %d\n", i->index);
 	return 0;
 }
 
@@ -241,7 +245,7 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *input)
 
 	*input = hexium->cur_input;
 
-	DEB_D(("VIDIOC_G_INPUT: %d\n", *input));
+	DEB_D("VIDIOC_G_INPUT: %d\n", *input);
 	return 0;
 }
 
@@ -250,7 +254,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
 
-	DEB_EE(("VIDIOC_S_INPUT %d.\n", input));
+	DEB_EE("VIDIOC_S_INPUT %d\n", input);
 
 	if (input >= HEXIUM_INPUTS)
 		return -EINVAL;
@@ -271,7 +275,7 @@ static int vidioc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *
 	for (i = HEXIUM_CONTROLS - 1; i >= 0; i--) {
 		if (hexium_controls[i].id == qc->id) {
 			*qc = hexium_controls[i];
-			DEB_D(("VIDIOC_QUERYCTRL %d.\n", qc->id));
+			DEB_D("VIDIOC_QUERYCTRL %d\n", qc->id);
 			return 0;
 		}
 	}
@@ -294,7 +298,7 @@ static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
 
 	if (vc->id == V4L2_CID_PRIVATE_BASE) {
 		vc->value = hexium->cur_bw;
-		DEB_D(("VIDIOC_G_CTRL BW:%d.\n", vc->value));
+		DEB_D("VIDIOC_G_CTRL BW:%d\n", vc->value);
 		return 0;
 	}
 	return -EINVAL;
@@ -317,7 +321,7 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
 	if (vc->id == V4L2_CID_PRIVATE_BASE)
 		hexium->cur_bw = vc->value;
 
-	DEB_D(("VIDIOC_S_CTRL BW:%d.\n", hexium->cur_bw));
+	DEB_D("VIDIOC_S_CTRL BW:%d\n", hexium->cur_bw);
 
 	if (0 == hexium->cur_bw && V4L2_STD_PAL == hexium->cur_std) {
 		hexium_set_standard(hexium, hexium_pal);
@@ -355,11 +359,11 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
 	int ret;
 
-	DEB_EE((".\n"));
+	DEB_EE("\n");
 
 	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
 	if (NULL == hexium) {
-		printk("hexium_gemini: not enough kernel memory in hexium_attach().\n");
+		pr_err("not enough kernel memory in hexium_attach()\n");
 		return -ENOMEM;
 	}
 	dev->ext_priv = hexium;
@@ -372,7 +376,7 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	};
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
-		DEB_S(("cannot register i2c-device. skipping.\n"));
+		DEB_S("cannot register i2c-device. skipping.\n");
 		kfree(hexium);
 		return -EFAULT;
 	}
@@ -403,11 +407,11 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	vv_data.ops.vidioc_s_input = vidioc_s_input;
 	ret = saa7146_register_device(&hexium->video_dev, dev, "hexium gemini", VFL_TYPE_GRABBER);
 	if (ret < 0) {
-		printk("hexium_gemini: cannot register capture v4l2 device. skipping.\n");
+		pr_err("cannot register capture v4l2 device. skipping.\n");
 		return ret;
 	}
 
-	printk("hexium_gemini: found 'hexium gemini' frame grabber-%d.\n", hexium_num);
+	pr_info("found 'hexium gemini' frame grabber-%d\n", hexium_num);
 	hexium_num++;
 
 	return 0;
@@ -417,7 +421,7 @@ static int hexium_detach(struct saa7146_dev *dev)
 {
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
 
-	DEB_EE(("dev:%p\n", dev));
+	DEB_EE("dev:%p\n", dev);
 
 	saa7146_unregister_device(&hexium->video_dev, dev);
 	saa7146_vv_release(dev);
@@ -509,7 +513,7 @@ static struct saa7146_extension hexium_extension = {
 static int __init hexium_init_module(void)
 {
 	if (0 != saa7146_register_extension(&hexium_extension)) {
-		DEB_S(("failed to register extension.\n"));
+		DEB_S("failed to register extension\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index 62a5c8b..23debc9 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -21,6 +21,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DEBUG_VARIABLE debug
 
 #include <media/saa7146_vv.h>
@@ -210,7 +212,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 	union i2c_smbus_data data;
 	int err = 0;
 
-	DEB_EE((".\n"));
+	DEB_EE("\n");
 
 	/* there are no hexium orion cards with revision 0 saa7146s */
 	if (0 == dev->revision) {
@@ -219,7 +221,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 
 	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
 	if (NULL == hexium) {
-		printk("hexium_orion: hexium_probe: not enough kernel memory.\n");
+		pr_err("hexium_probe: not enough kernel memory\n");
 		return -ENOMEM;
 	}
 
@@ -235,7 +237,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 	};
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
-		DEB_S(("cannot register i2c-device. skipping.\n"));
+		DEB_S("cannot register i2c-device. skipping.\n");
 		kfree(hexium);
 		return -EFAULT;
 	}
@@ -249,7 +251,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 
 	/* detect newer Hexium Orion cards by subsystem ids */
 	if (0x17c8 == dev->pci->subsystem_vendor && 0x0101 == dev->pci->subsystem_device) {
-		printk("hexium_orion: device is a Hexium Orion w/ 1 SVHS + 3 BNC inputs.\n");
+		pr_info("device is a Hexium Orion w/ 1 SVHS + 3 BNC inputs\n");
 		/* we store the pointer in our private data field */
 		dev->ext_priv = hexium;
 		hexium->type = HEXIUM_ORION_1SVHS_3BNC;
@@ -257,7 +259,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 	}
 
 	if (0x17c8 == dev->pci->subsystem_vendor && 0x2101 == dev->pci->subsystem_device) {
-		printk("hexium_orion: device is a Hexium Orion w/ 4 BNC inputs.\n");
+		pr_info("device is a Hexium Orion w/ 4 BNC inputs\n");
 		/* we store the pointer in our private data field */
 		dev->ext_priv = hexium;
 		hexium->type = HEXIUM_ORION_4BNC;
@@ -267,7 +269,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 	/* check if this is an old hexium Orion card by looking at
 	   a saa7110 at address 0x4e */
 	if (0 == (err = i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_READ, 0x00, I2C_SMBUS_BYTE_DATA, &data))) {
-		printk("hexium_orion: device is a Hexium HV-PCI6/Orion (old).\n");
+		pr_info("device is a Hexium HV-PCI6/Orion (old)\n");
 		/* we store the pointer in our private data field */
 		dev->ext_priv = hexium;
 		hexium->type = HEXIUM_HV_PCI6_ORION;
@@ -289,13 +291,13 @@ static int hexium_init_done(struct saa7146_dev *dev)
 	union i2c_smbus_data data;
 	int i = 0;
 
-	DEB_D(("hexium_init_done called.\n"));
+	DEB_D("hexium_init_done called\n");
 
 	/* initialize the helper ics to useful values */
 	for (i = 0; i < sizeof(hexium_saa7110); i++) {
 		data.byte = hexium_saa7110[i];
 		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_WRITE, i, I2C_SMBUS_BYTE_DATA, &data)) {
-			printk("hexium_orion: failed for address 0x%02x\n", i);
+			pr_err("failed for address 0x%02x\n", i);
 		}
 	}
 
@@ -307,7 +309,7 @@ static int hexium_set_input(struct hexium *hexium, int input)
 	union i2c_smbus_data data;
 	int i = 0;
 
-	DEB_D((".\n"));
+	DEB_D("\n");
 
 	for (i = 0; i < 8; i++) {
 		int adr = hexium_input_select[input].data[i].adr;
@@ -315,7 +317,7 @@ static int hexium_set_input(struct hexium *hexium, int input)
 		if (0 != i2c_smbus_xfer(&hexium->i2c_adapter, 0x4e, 0, I2C_SMBUS_WRITE, adr, I2C_SMBUS_BYTE_DATA, &data)) {
 			return -1;
 		}
-		printk("%d: 0x%02x => 0x%02x\n",input, adr,data.byte);
+		pr_debug("%d: 0x%02x => 0x%02x\n", input, adr, data.byte);
 	}
 
 	return 0;
@@ -323,14 +325,14 @@ static int hexium_set_input(struct hexium *hexium, int input)
 
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
-	DEB_EE(("VIDIOC_ENUMINPUT %d.\n", i->index));
+	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
 
 	if (i->index >= HEXIUM_INPUTS)
 		return -EINVAL;
 
 	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
 
-	DEB_D(("v4l2_ioctl: VIDIOC_ENUMINPUT %d.\n", i->index));
+	DEB_D("v4l2_ioctl: VIDIOC_ENUMINPUT %d\n", i->index);
 	return 0;
 }
 
@@ -341,7 +343,7 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *input)
 
 	*input = hexium->cur_input;
 
-	DEB_D(("VIDIOC_G_INPUT: %d\n", *input));
+	DEB_D("VIDIOC_G_INPUT: %d\n", *input);
 	return 0;
 }
 
@@ -366,18 +368,18 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 {
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
 
-	DEB_EE((".\n"));
+	DEB_EE("\n");
 
 	saa7146_vv_init(dev, &vv_data);
 	vv_data.ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.ops.vidioc_g_input = vidioc_g_input;
 	vv_data.ops.vidioc_s_input = vidioc_s_input;
 	if (0 != saa7146_register_device(&hexium->video_dev, dev, "hexium orion", VFL_TYPE_GRABBER)) {
-		printk("hexium_orion: cannot register capture v4l2 device. skipping.\n");
+		pr_err("cannot register capture v4l2 device. skipping.\n");
 		return -1;
 	}
 
-	printk("hexium_orion: found 'hexium orion' frame grabber-%d.\n", hexium_num);
+	pr_err("found 'hexium orion' frame grabber-%d\n", hexium_num);
 	hexium_num++;
 
 	/* the rest */
@@ -391,7 +393,7 @@ static int hexium_detach(struct saa7146_dev *dev)
 {
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
 
-	DEB_EE(("dev:%p\n", dev));
+	DEB_EE("dev:%p\n", dev);
 
 	saa7146_unregister_device(&hexium->video_dev, dev);
 	saa7146_vv_release(dev);
@@ -480,7 +482,7 @@ static struct saa7146_extension extension = {
 static int __init hexium_init_module(void)
 {
 	if (0 != saa7146_register_extension(&extension)) {
-		DEB_S(("failed to register extension.\n"));
+		DEB_S("failed to register extension\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 243dc60..2e41317 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -21,6 +21,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DEBUG_VARIABLE debug
 
 #include <media/saa7146_vv.h>
@@ -172,7 +174,7 @@ static int mxb_probe(struct saa7146_dev *dev)
 
 	mxb = kzalloc(sizeof(struct mxb), GFP_KERNEL);
 	if (mxb == NULL) {
-		DEB_D(("not enough kernel memory.\n"));
+		DEB_D("not enough kernel memory\n");
 		return -ENOMEM;
 	}
 
@@ -180,7 +182,7 @@ static int mxb_probe(struct saa7146_dev *dev)
 
 	saa7146_i2c_adapter_prepare(dev, &mxb->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&mxb->i2c_adapter) < 0) {
-		DEB_S(("cannot register i2c-device. skipping.\n"));
+		DEB_S("cannot register i2c-device. skipping.\n");
 		kfree(mxb);
 		return -EFAULT;
 	}
@@ -201,7 +203,7 @@ static int mxb_probe(struct saa7146_dev *dev)
 	/* check if all devices are present */
 	if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||
 	    !mxb->tda9840 || !mxb->saa7111a || !mxb->tuner) {
-		printk("mxb: did not find all i2c devices. aborting\n");
+		pr_err("did not find all i2c devices. aborting\n");
 		i2c_del_adapter(&mxb->i2c_adapter);
 		kfree(mxb);
 		return -ENODEV;
@@ -347,11 +349,11 @@ static int mxb_init_done(struct saa7146_dev* dev)
 			msg.buf = &mxb_saa7740_init[i].data[0];
 			err = i2c_transfer(&mxb->i2c_adapter, &msg, 1);
 			if (err != 1) {
-				DEB_D(("failed to initialize 'sound arena module'.\n"));
+				DEB_D("failed to initialize 'sound arena module'\n");
 				goto err;
 			}
 		}
-		INFO(("'sound arena module' detected.\n"));
+		pr_info("'sound arena module' detected\n");
 	}
 err:
 	/* the rest for saa7146: you should definitely set some basic values
@@ -391,7 +393,7 @@ static int vidioc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *
 	for (i = MAXCONTROLS - 1; i >= 0; i--) {
 		if (mxb_controls[i].id == qc->id) {
 			*qc = mxb_controls[i];
-			DEB_D(("VIDIOC_QUERYCTRL %d.\n", qc->id));
+			DEB_D("VIDIOC_QUERYCTRL %d\n", qc->id);
 			return 0;
 		}
 	}
@@ -414,11 +416,11 @@ static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
 
 	if (vc->id == V4L2_CID_AUDIO_MUTE) {
 		vc->value = mxb->cur_mute;
-		DEB_D(("VIDIOC_G_CTRL V4L2_CID_AUDIO_MUTE:%d.\n", vc->value));
+		DEB_D("VIDIOC_G_CTRL V4L2_CID_AUDIO_MUTE:%d\n", vc->value);
 		return 0;
 	}
 
-	DEB_EE(("VIDIOC_G_CTRL V4L2_CID_AUDIO_MUTE:%d.\n", vc->value));
+	DEB_EE("VIDIOC_G_CTRL V4L2_CID_AUDIO_MUTE:%d\n", vc->value);
 	return 0;
 }
 
@@ -441,14 +443,14 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
 		/* switch the audio-source */
 		tea6420_route_line(mxb, vc->value ? 6 :
 				video_audio_connect[mxb->cur_input]);
-		DEB_EE(("VIDIOC_S_CTRL, V4L2_CID_AUDIO_MUTE: %d.\n", vc->value));
+		DEB_EE("VIDIOC_S_CTRL, V4L2_CID_AUDIO_MUTE: %d\n", vc->value);
 	}
 	return 0;
 }
 
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
-	DEB_EE(("VIDIOC_ENUMINPUT %d.\n", i->index));
+	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
 	if (i->index >= MXB_INPUTS)
 		return -EINVAL;
 	memcpy(i, &mxb_inputs[i->index], sizeof(struct v4l2_input));
@@ -461,7 +463,7 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 	*i = mxb->cur_input;
 
-	DEB_EE(("VIDIOC_G_INPUT %d.\n", *i));
+	DEB_EE("VIDIOC_G_INPUT %d\n", *i);
 	return 0;
 }
 
@@ -472,7 +474,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	int err = 0;
 	int i = 0;
 
-	DEB_EE(("VIDIOC_S_INPUT %d.\n", input));
+	DEB_EE("VIDIOC_S_INPUT %d\n", input);
 
 	if (input >= MXB_INPUTS)
 		return -EINVAL;
@@ -515,7 +517,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 
 	/* switch video in saa7111a */
 	if (saa7111a_call(mxb, video, s_routing, i, SAA7111_FMT_CCIR, 0))
-		printk(KERN_ERR "VIDIOC_S_INPUT: could not address saa7111a.\n");
+		pr_err("VIDIOC_S_INPUT: could not address saa7111a\n");
 
 	/* switch the audio-source only if necessary */
 	if (0 == mxb->cur_mute)
@@ -530,11 +532,12 @@ static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
 	if (t->index) {
-		DEB_D(("VIDIOC_G_TUNER: channel %d does not have a tuner attached.\n", t->index));
+		DEB_D("VIDIOC_G_TUNER: channel %d does not have a tuner attached\n",
+		      t->index);
 		return -EINVAL;
 	}
 
-	DEB_EE(("VIDIOC_G_TUNER: %d\n", t->index));
+	DEB_EE("VIDIOC_G_TUNER: %d\n", t->index);
 
 	memset(t, 0, sizeof(*t));
 	strlcpy(t->name, "TV Tuner", sizeof(t->name));
@@ -551,7 +554,8 @@ static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
 	if (t->index) {
-		DEB_D(("VIDIOC_S_TUNER: channel %d does not have a tuner attached.\n", t->index));
+		DEB_D("VIDIOC_S_TUNER: channel %d does not have a tuner attached\n",
+		      t->index);
 		return -EINVAL;
 	}
 
@@ -565,14 +569,14 @@ static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
 	if (mxb->cur_input) {
-		DEB_D(("VIDIOC_G_FREQ: channel %d does not have a tuner!\n",
-					mxb->cur_input));
+		DEB_D("VIDIOC_G_FREQ: channel %d does not have a tuner!\n",
+		      mxb->cur_input);
 		return -EINVAL;
 	}
 
 	*f = mxb->cur_freq;
 
-	DEB_EE(("VIDIOC_G_FREQ: freq:0x%08x.\n", mxb->cur_freq.frequency));
+	DEB_EE("VIDIOC_G_FREQ: freq:0x%08x\n", mxb->cur_freq.frequency);
 	return 0;
 }
 
@@ -589,12 +593,13 @@ static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency
 		return -EINVAL;
 
 	if (mxb->cur_input) {
-		DEB_D(("VIDIOC_S_FREQ: channel %d does not have a tuner!\n", mxb->cur_input));
+		DEB_D("VIDIOC_S_FREQ: channel %d does not have a tuner!\n",
+		      mxb->cur_input);
 		return -EINVAL;
 	}
 
 	mxb->cur_freq = *f;
-	DEB_EE(("VIDIOC_S_FREQUENCY: freq:0x%08x.\n", mxb->cur_freq.frequency));
+	DEB_EE("VIDIOC_S_FREQUENCY: freq:0x%08x\n", mxb->cur_freq.frequency);
 
 	/* tune in desired frequency */
 	tuner_call(mxb, tuner, s_frequency, &mxb->cur_freq);
@@ -613,18 +618,18 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
 	if (a->index > MXB_INPUTS) {
-		DEB_D(("VIDIOC_G_AUDIO %d out of range.\n", a->index));
+		DEB_D("VIDIOC_G_AUDIO %d out of range\n", a->index);
 		return -EINVAL;
 	}
 
-	DEB_EE(("VIDIOC_G_AUDIO %d.\n", a->index));
+	DEB_EE("VIDIOC_G_AUDIO %d\n", a->index);
 	memcpy(a, &mxb_audios[video_audio_connect[mxb->cur_input]], sizeof(struct v4l2_audio));
 	return 0;
 }
 
 static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
-	DEB_D(("VIDIOC_S_AUDIO %d.\n", a->index));
+	DEB_D("VIDIOC_S_AUDIO %d\n", a->index);
 	return 0;
 }
 
@@ -656,11 +661,11 @@ static long vidioc_default(struct file *file, void *fh, bool valid_prio,
 		int i = *(int *)arg;
 
 		if (i < 0 || i >= MXB_AUDIOS) {
-			DEB_D(("illegal argument to MXB_S_AUDIO_CD: i:%d.\n", i));
+			DEB_D("invalid argument to MXB_S_AUDIO_CD: i:%d\n", i);
 			return -EINVAL;
 		}
 
-		DEB_EE(("MXB_S_AUDIO_CD: i:%d.\n", i));
+		DEB_EE("MXB_S_AUDIO_CD: i:%d\n", i);
 
 		tea6420_route_cd(mxb, i);
 		return 0;
@@ -670,17 +675,18 @@ static long vidioc_default(struct file *file, void *fh, bool valid_prio,
 		int i = *(int *)arg;
 
 		if (i < 0 || i >= MXB_AUDIOS) {
-			DEB_D(("illegal argument to MXB_S_AUDIO_LINE: i:%d.\n", i));
+			DEB_D("invalid argument to MXB_S_AUDIO_LINE: i:%d\n",
+			      i);
 			return -EINVAL;
 		}
 
-		DEB_EE(("MXB_S_AUDIO_LINE: i:%d.\n", i));
+		DEB_EE("MXB_S_AUDIO_LINE: i:%d\n", i);
 		tea6420_route_line(mxb, i);
 		return 0;
 	}
 	default:
 /*
-		DEB2(printk("does not handle this ioctl.\n"));
+		DEB2(pr_err("does not handle this ioctl\n"));
 */
 		return -ENOIOCTLCMD;
 	}
@@ -694,7 +700,7 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 {
 	struct mxb *mxb;
 
-	DEB_EE(("dev:%p\n", dev));
+	DEB_EE("dev:%p\n", dev);
 
 	saa7146_vv_init(dev, &vv_data);
 	if (mxb_probe(dev)) {
@@ -721,7 +727,7 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 #endif
 	vv_data.ops.vidioc_default = vidioc_default;
 	if (saa7146_register_device(&mxb->video_dev, dev, "mxb", VFL_TYPE_GRABBER)) {
-		ERR(("cannot register capture v4l2 device. skipping.\n"));
+		ERR("cannot register capture v4l2 device. skipping.\n");
 		saa7146_vv_release(dev);
 		return -1;
 	}
@@ -729,11 +735,11 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	/* initialization stuff (vbi) (only for revision > 0 and for extensions which want it)*/
 	if (MXB_BOARD_CAN_DO_VBI(dev)) {
 		if (saa7146_register_device(&mxb->vbi_dev, dev, "mxb", VFL_TYPE_VBI)) {
-			ERR(("cannot register vbi v4l2 device. skipping.\n"));
+			ERR("cannot register vbi v4l2 device. skipping.\n");
 		}
 	}
 
-	printk("mxb: found Multimedia eXtension Board #%d.\n", mxb_num);
+	pr_info("found Multimedia eXtension Board #%d\n", mxb_num);
 
 	mxb_num++;
 	mxb_init_done(dev);
@@ -744,7 +750,7 @@ static int mxb_detach(struct saa7146_dev *dev)
 {
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
-	DEB_EE(("dev:%p\n", dev));
+	DEB_EE("dev:%p\n", dev);
 
 	saa7146_unregister_device(&mxb->video_dev,dev);
 	if (MXB_BOARD_CAN_DO_VBI(dev))
@@ -766,7 +772,7 @@ static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standa
 	if (V4L2_STD_PAL_I == standard->id) {
 		v4l2_std_id std = V4L2_STD_PAL_I;
 
-		DEB_D(("VIDIOC_S_STD: setting mxb for PAL_I.\n"));
+		DEB_D("VIDIOC_S_STD: setting mxb for PAL_I\n");
 		/* set the 7146 gpio register -- I don't know what this does exactly */
 		saa7146_write(dev, GPIO_CTRL, 0x00404050);
 		/* unset the 7111 gpio register -- I don't know what this does exactly */
@@ -775,7 +781,7 @@ static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standa
 	} else {
 		v4l2_std_id std = V4L2_STD_PAL_BG;
 
-		DEB_D(("VIDIOC_S_STD: setting mxb for PAL/NTSC/SECAM.\n"));
+		DEB_D("VIDIOC_S_STD: setting mxb for PAL/NTSC/SECAM\n");
 		/* set the 7146 gpio register -- I don't know what this does exactly */
 		saa7146_write(dev, GPIO_CTRL, 0x00404050);
 		/* set the 7111 gpio register -- I don't know what this does exactly */
@@ -853,7 +859,7 @@ static struct saa7146_extension extension = {
 static int __init mxb_init_module(void)
 {
 	if (saa7146_register_extension(&extension)) {
-		DEB_S(("failed to register extension.\n"));
+		DEB_S("failed to register extension\n");
 		return -ENODEV;
 	}
 
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 6e84cde..0f037e8 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -24,24 +24,32 @@
 
 extern unsigned int saa7146_debug;
 
-//#define DEBUG_PROLOG printk("(0x%08x)(0x%08x) %s: %s(): ",(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,RPS_ADDR0))),(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,IER))),KBUILD_MODNAME,__func__)
-
 #ifndef DEBUG_VARIABLE
 	#define DEBUG_VARIABLE saa7146_debug
 #endif
 
-#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME, __func__)
-#define INFO(x) { printk("%s: ",KBUILD_MODNAME); printk x; }
-
-#define ERR(x) { DEBUG_PROLOG; printk x; }
-
-#define DEB_S(x)    if (0!=(DEBUG_VARIABLE&0x01)) { DEBUG_PROLOG; printk x; } /* simple debug messages */
-#define DEB_D(x)    if (0!=(DEBUG_VARIABLE&0x02)) { DEBUG_PROLOG; printk x; } /* more detailed debug messages */
-#define DEB_EE(x)   if (0!=(DEBUG_VARIABLE&0x04)) { DEBUG_PROLOG; printk x; } /* print enter and exit of functions */
-#define DEB_I2C(x)  if (0!=(DEBUG_VARIABLE&0x08)) { DEBUG_PROLOG; printk x; } /* i2c debug messages */
-#define DEB_VBI(x)  if (0!=(DEBUG_VARIABLE&0x10)) { DEBUG_PROLOG; printk x; } /* vbi debug messages */
-#define DEB_INT(x)  if (0!=(DEBUG_VARIABLE&0x20)) { DEBUG_PROLOG; printk x; } /* interrupt debug messages */
-#define DEB_CAP(x)  if (0!=(DEBUG_VARIABLE&0x40)) { DEBUG_PROLOG; printk x; } /* capture debug messages */
+#define ERR(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
+
+#define _DBG(mask, fmt, ...)						\
+do {									\
+	if (DEBUG_VARIABLE & mask)					\
+		pr_debug("%s(): " fmt, __func__, ##__VA_ARGS__);	\
+} while (0)
+
+/* simple debug messages */
+#define DEB_S(fmt, ...)		_DBG(0x01, fmt, ##__VA_ARGS__)
+/* more detailed debug messages */
+#define DEB_D(fmt, ...)		_DBG(0x02, fmt, ##__VA_ARGS__)
+/* print enter and exit of functions */
+#define DEB_EE(fmt, ...)	_DBG(0x04, fmt, ##__VA_ARGS__)
+/* i2c debug messages */
+#define DEB_I2C(fmt, ...)	_DBG(0x08, fmt, ##__VA_ARGS__)
+/* vbi debug messages */
+#define DEB_VBI(fmt, ...)	_DBG(0x10, fmt, ##__VA_ARGS__)
+/* interrupt debug messages */
+#define DEB_INT(fmt, ...)	_DBG(0x20, fmt, ##__VA_ARGS__)
+/* capture debug messages */
+#define DEB_CAP(fmt, ...)	_DBG(0x40, fmt, ##__VA_ARGS__)
 
 #define SAA7146_ISR_CLEAR(x,y) \
 	saa7146_write(x, ISR, (y));
-- 
1.7.6.405.gc1be0

