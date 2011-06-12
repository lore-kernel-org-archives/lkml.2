Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1FLLPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:15:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18405 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1FLLPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:15:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6374"; a="97005903"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list),
        linuxppc-dev@lists.ozlabs.org (open list:FREESCALE USB PER...),
        linux-omap@vger.kernel.org (open list:OMAP USB SUPPORT)
Subject: [PATCH] usb:gadget: use min_t() macro instead of min()
Date: Sun, 12 Jun 2011 14:14:46 +0300
Message-Id: <1307877290-26672-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/composite.c      |   16 ++++++++--------
 drivers/usb/gadget/dummy_hcd.c      |    2 +-
 drivers/usb/gadget/f_fs.c           |    6 +++---
 drivers/usb/gadget/f_mass_storage.c |   20 ++++++++++----------
 drivers/usb/gadget/file_storage.c   |   22 +++++++++++-----------
 drivers/usb/gadget/fsl_udc_core.c   |    4 ++--
 drivers/usb/gadget/gmidi.c          |   10 +++++-----
 drivers/usb/gadget/inode.c          |   12 ++++++------
 drivers/usb/gadget/mv_udc_core.c    |    4 ++--
 drivers/usb/gadget/omap_udc.c       |    6 +++---
 drivers/usb/gadget/printer.c        |   16 ++++++++--------
 drivers/usb/gadget/usbstring.c      |    2 +-
 drivers/usb/gadget/uvc_video.c      |    4 ++--
 13 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d825dbc..aa2db3f 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1085,7 +1085,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 					cdev->desc.bcdUSB = cpu_to_le16(0x0210);
 			}
 
-			value = min(w_length, (u16) sizeof cdev->desc);
+			value = min_t(u16, w_length, sizeof(cdev->desc));
 			memcpy(req->buf, &cdev->desc, value);
 			break;
 		case USB_DT_DEVICE_QUALIFIER:
@@ -1104,18 +1104,18 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		case USB_DT_CONFIG:
 			value = config_desc(cdev, w_value);
 			if (value >= 0)
-				value = min(w_length, (u16) value);
+				value = min_t(u16, w_length, value);
 			break;
 		case USB_DT_STRING:
 			value = get_string(cdev, req->buf,
 					w_index, w_value & 0xff);
 			if (value >= 0)
-				value = min(w_length, (u16) value);
+				value = min_t(u16, w_length, value);
 			break;
 		case USB_DT_BOS:
 			if (gadget_is_superspeed(gadget)) {
 				value = bos_desc(cdev);
-				value = min(w_length, (u16) value);
+				value = min_t(u16, w_length, value);
 			}
 			break;
 		}
@@ -1144,7 +1144,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			*(u8 *)req->buf = cdev->config->bConfigurationValue;
 		else
 			*(u8 *)req->buf = 0;
-		value = min(w_length, (u16) 1);
+		value = min_t(u16, w_length, 1);
 		break;
 
 	/* function drivers must handle get/set altsetting; if there's
@@ -1183,7 +1183,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		if (value < 0)
 			break;
 		*((u8 *)req->buf) = value;
-		value = min(w_length, (u16) 1);
+		value = min_t(u16, w_length, 1);
 		break;
 
 	/*
@@ -1607,8 +1607,8 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
-	composite_driver.speed = min((u8)composite_driver.speed,
-				     (u8)driver->max_speed);
+	composite_driver.speed = min_t(u8, composite_driver.speed,
+				       driver->max_speed);
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 74b7655..e134ea8 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -1213,7 +1213,7 @@ top:
 			/* not enough bandwidth left? */
 			if (limit < ep->ep.maxpacket && limit < len)
 				break;
-			len = min (len, (unsigned) limit);
+			len = min_t(unsigned, len, limit);
 			if (len == 0)
 				break;
 
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index c161a9a..468e935 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -502,7 +502,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		}
 
 		/* FFS_SETUP_PENDING and not stall */
-		len = min(len, (size_t)le16_to_cpu(ffs->ev.setup.wLength));
+		len = min_t(size_t, len, le16_to_cpu(ffs->ev.setup.wLength));
 
 		spin_unlock_irq(&ffs->ev.waitq.lock);
 
@@ -636,7 +636,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 		}
 
 		return __ffs_ep0_read_events(ffs, buf,
-					     min(n, (size_t)ffs->ev.count));
+					     min_t(size_t, n, ffs->ev.count));
 
 	case FFS_SETUP_PENDING:
 		if (ffs->ev.setup.bRequestType & USB_DIR_IN) {
@@ -645,7 +645,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 			goto done_mutex;
 		}
 
-		len = min(len, (size_t)le16_to_cpu(ffs->ev.setup.wLength));
+		len = min_t(size_t, len, le16_to_cpu(ffs->ev.setup.wLength));
 
 		spin_unlock_irq(&ffs->ev.waitq.lock);
 
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 5b93395..d7b3f9f 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -646,7 +646,7 @@ static int fsg_setup(struct usb_function *f,
 		*(u8 *)req->buf = fsg->common->nluns - 1;
 
 		/* Respond with data/status */
-		req->length = min((u16)1, w_length);
+		req->length = min_t(u16, 1, w_length);
 		return ep0_queue(fsg->common);
 	}
 
@@ -790,11 +790,11 @@ static int do_read(struct fsg_common *common)
 		 *	the end of file.
 		 */
 		amount = min(amount_left, FSG_BUFLEN);
-		amount = min((loff_t)amount,
+		amount = min_t(loff_t, amount,
 			     curlun->file_length - file_offset);
 		partial_page = file_offset & (PAGE_CACHE_SIZE - 1);
 		if (partial_page > 0)
-			amount = min(amount, (unsigned int)PAGE_CACHE_SIZE -
+			amount = min_t(unsigned int, amount, PAGE_CACHE_SIZE -
 					     partial_page);
 
 		/* Wait for the next buffer to become available */
@@ -943,12 +943,12 @@ static int do_write(struct fsg_common *common)
 			 * Finally, round down to a block boundary.
 			 */
 			amount = min(amount_left_to_req, FSG_BUFLEN);
-			amount = min((loff_t)amount,
+			amount = min_t(loff_t, amount,
 				     curlun->file_length - usb_offset);
 			partial_page = usb_offset & (PAGE_CACHE_SIZE - 1);
 			if (partial_page > 0)
-				amount = min(amount,
-	(unsigned int)PAGE_CACHE_SIZE - partial_page);
+				amount = min_t(unsigned int, amount,
+					       PAGE_CACHE_SIZE - partial_page);
 
 			if (amount == 0) {
 				get_some_more = 0;
@@ -1152,7 +1152,7 @@ static int do_verify(struct fsg_common *common)
 		 * past the end of file.
 		 */
 		amount = min(amount_left, FSG_BUFLEN);
-		amount = min((loff_t)amount,
+		amount = min_t(loff_t, amount,
 			     curlun->file_length - file_offset);
 		if (amount == 0) {
 			curlun->sense_data =
@@ -2203,7 +2203,7 @@ unknown_cmnd:
 	if (reply == -EINVAL)
 		reply = 0;		/* Error reply length */
 	if (reply >= 0 && common->data_dir == DATA_DIR_TO_HOST) {
-		reply = min((u32)reply, common->data_size_from_cmnd);
+		reply = min_t(u32, reply, common->data_size_from_cmnd);
 		bh->inreq->length = reply;
 		bh->state = BUF_STATE_FULL;
 		common->residue -= reply;
@@ -3129,8 +3129,8 @@ fsg_config_from_params(struct fsg_config *cfg,
 
 	/* Configure LUNs */
 	cfg->nluns =
-		min(params->luns ?: (params->file_count ?: 1u),
-		    (unsigned)FSG_MAX_LUNS);
+		min_t(unsigned, params->luns ?: (params->file_count ?: 1u),
+		    FSG_MAX_LUNS);
 	for (i = 0, lun = cfg->luns; i < cfg->nluns; ++i, ++lun) {
 		lun->ro = !!params->ro[i];
 		lun->cdrom = !!params->cdrom[i];
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 0d55dee..aa8144d 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -1169,12 +1169,12 @@ static int do_read(struct fsg_dev *fsg)
 		 *	the next page.
 		 * If this means reading 0 then we were asked to read past
 		 *	the end of file. */
-		amount = min((unsigned int) amount_left, mod_data.buflen);
-		amount = min((loff_t) amount,
+		amount = min_t(unsigned int, amount_left, mod_data.buflen);
+		amount = min_t(loff_t, amount,
 				curlun->file_length - file_offset);
 		partial_page = file_offset & (PAGE_CACHE_SIZE - 1);
 		if (partial_page > 0)
-			amount = min(amount, (unsigned int) PAGE_CACHE_SIZE -
+			amount = min_t(unsigned int, amount, PAGE_CACHE_SIZE -
 					partial_page);
 
 		/* Wait for the next buffer to become available */
@@ -1316,12 +1316,12 @@ static int do_write(struct fsg_dev *fsg)
 			 *	to write past the end of file.
 			 * Finally, round down to a block boundary. */
 			amount = min(amount_left_to_req, mod_data.buflen);
-			amount = min((loff_t) amount, curlun->file_length -
+			amount = min_t(loff_t, amount, curlun->file_length -
 					usb_offset);
 			partial_page = usb_offset & (PAGE_CACHE_SIZE - 1);
 			if (partial_page > 0)
-				amount = min(amount,
-	(unsigned int) PAGE_CACHE_SIZE - partial_page);
+				amount = min_t(unsigned int, amount,
+					       PAGE_CACHE_SIZE - partial_page);
 
 			if (amount == 0) {
 				get_some_more = 0;
@@ -1515,8 +1515,8 @@ static int do_verify(struct fsg_dev *fsg)
 		 * And don't try to read past the end of the file.
 		 * If this means reading 0 then we were asked to read
 		 * past the end of file. */
-		amount = min((unsigned int) amount_left, mod_data.buflen);
-		amount = min((loff_t) amount,
+		amount = min_t(unsigned int, amount_left, mod_data.buflen);
+		amount = min_t(loff_t, amount,
 				curlun->file_length - file_offset);
 		if (amount == 0) {
 			curlun->sense_data =
@@ -1974,8 +1974,8 @@ static int throw_away_data(struct fsg_dev *fsg)
 		/* Try to submit another request if we need one */
 		bh = fsg->next_buffhd_to_fill;
 		if (bh->state == BUF_STATE_EMPTY && fsg->usb_amount_left > 0) {
-			amount = min(fsg->usb_amount_left,
-					(u32) mod_data.buflen);
+			amount = min_t(u32, fsg->usb_amount_left,
+				       mod_data.buflen);
 
 			/* amount is always divisible by 512, hence by
 			 * the bulk-out maxpacket size */
@@ -2568,7 +2568,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 	if (reply == -EINVAL)
 		reply = 0;		// Error reply length
 	if (reply >= 0 && fsg->data_dir == DATA_DIR_TO_HOST) {
-		reply = min((u32) reply, fsg->data_size_from_cmnd);
+		reply = min_t(u32, reply, fsg->data_size_from_cmnd);
 		bh->inreq->length = reply;
 		bh->state = BUF_STATE_FULL;
 		fsg->residue -= reply;
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 2cd9a60..5df6a1c 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -761,8 +761,8 @@ static struct ep_td_struct *fsl_build_dtd(struct fsl_req *req, unsigned *length,
 	struct ep_td_struct *dtd;
 
 	/* how big will this transfer be? */
-	*length = min(req->req.length - req->req.actual,
-			(unsigned)EP_MAX_LENGTH_TRANSFER);
+	*length = min_t(unsigned, req->req.length - req->req.actual,
+			EP_MAX_LENGTH_TRANSFER);
 
 	dtd = dma_pool_alloc(udc_controller->td_pool, GFP_KERNEL, dma);
 	if (dtd == NULL)
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 4f40f14..9dab7a9 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -695,7 +695,7 @@ static int gmidi_setup(struct usb_gadget *gadget,
 		switch (w_value >> 8) {
 
 		case USB_DT_DEVICE:
-			value = min(w_length, (u16) sizeof(device_desc));
+			value = min_t(u16, w_length, sizeof(device_desc));
 			memcpy(req->buf, &device_desc, value);
 			break;
 		case USB_DT_CONFIG:
@@ -703,7 +703,7 @@ static int gmidi_setup(struct usb_gadget *gadget,
 					w_value >> 8,
 					w_value & 0xff);
 			if (value >= 0) {
-				value = min(w_length, (u16)value);
+				value = min_t(u16, w_length, value);
 			}
 			break;
 
@@ -716,7 +716,7 @@ static int gmidi_setup(struct usb_gadget *gadget,
 			value = usb_gadget_get_string(&stringtab,
 					w_value & 0xff, req->buf);
 			if (value >= 0) {
-				value = min(w_length, (u16)value);
+				value = min_t(u16, w_length, value);
 			}
 			break;
 		}
@@ -743,7 +743,7 @@ static int gmidi_setup(struct usb_gadget *gadget,
 			goto unknown;
 		}
 		*(u8 *)req->buf = dev->config;
-		value = min(w_length, (u16)1);
+		value = min_t(u16, w_length, 1);
 		break;
 
 	/* until we add altsetting support, or other interfaces,
@@ -785,7 +785,7 @@ static int gmidi_setup(struct usb_gadget *gadget,
 			break;
 		}
 		*(u8 *)req->buf = 0;
-		value = min(w_length, (u16)1);
+		value = min_t(u16, w_length, 1);
 		break;
 
 	default:
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index a9a4556..0a8c719 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -564,7 +564,7 @@ static ssize_t ep_aio_read_retry(struct kiocb *iocb)
 	len = 0;
 	to_copy = priv->buf;
 	for (i=0; i < priv->nr_segs; i++) {
-		ssize_t this = min((ssize_t)(priv->iv[i].iov_len), total);
+		ssize_t this = min_t(ssize_t, priv->iv[i].iov_len, total);
 
 		if (copy_to_user(priv->iv[i].iov_base, to_copy, this)) {
 			if (len == 0)
@@ -1048,7 +1048,7 @@ ep0_read (struct file *fd, char __user *buf, size_t len, loff_t *ptr)
 			if (dev->setup_out_error)
 				retval = -EIO;
 			else {
-				len = min (len, (size_t)dev->req->actual);
+				len = min_t(size_t, len, dev->req->actual);
 // FIXME don't call this with the spinlock held ...
 				if (copy_to_user (buf, dev->req->buf, len))
 					retval = -EFAULT;
@@ -1431,14 +1431,14 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		switch (w_value >> 8) {
 
 		case USB_DT_DEVICE:
-			value = min (w_length, (u16) sizeof *dev->dev);
+			value = min_t(u16, w_length, sizeof(*dev->dev));
 			req->buf = dev->dev;
 			break;
 #ifdef	CONFIG_USB_GADGET_DUALSPEED
 		case USB_DT_DEVICE_QUALIFIER:
 			if (!dev->hs_config)
 				break;
-			value = min (w_length, (u16)
+			value = min_t(u16, w_length,
 				sizeof (struct usb_qualifier_descriptor));
 			make_qualifier (dev);
 			break;
@@ -1450,7 +1450,7 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 					w_value >> 8,
 					w_value & 0xff);
 			if (value >= 0)
-				value = min (w_length, (u16) value);
+				value = min_t(u16, w_length, value);
 			break;
 		case USB_DT_STRING:
 			goto unrecognized;
@@ -1512,7 +1512,7 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 		if (ctrl->bRequestType != 0x80)
 			goto unrecognized;
 		*(u8 *)req->buf = dev->current_config;
-		value = min (w_length, (u16) 1);
+		value = min_t(u16, w_length, 1);
 		break;
 #endif
 
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index b1a8146..30d0b48 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -387,8 +387,8 @@ static struct mv_dtd *build_dtd(struct mv_req *req, unsigned *length,
 	struct mv_udc *udc;
 
 	/* how big will this transfer be? */
-	*length = min(req->req.length - req->req.actual,
-			(unsigned)EP_MAX_LENGTH_TRANSFER);
+	*length = min_t(unsigned, req->req.length - req->req.actual,
+			EP_MAX_LENGTH_TRANSFER);
 
 	udc = req->ep->udc;
 
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 82fd249..1183b7a 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -558,8 +558,8 @@ static void next_in_dma(struct omap_ep *ep, struct omap_req *req)
 		omap_set_dma_transfer_params(ep->lch, OMAP_DMA_DATA_TYPE_S8,
 				length, 1, sync_mode, dma_trigger, 0);
 	} else {
-		length = min(length / ep->maxpacket,
-				(unsigned) UDC_TXN_TSC + 1);
+		length = min_t(unsigned, length / ep->maxpacket,
+				UDC_TXN_TSC + 1);
 		txdma_ctrl = length;
 		omap_set_dma_transfer_params(ep->lch, OMAP_DMA_DATA_TYPE_S16,
 				ep->ep.maxpacket >> 1, length, sync_mode,
@@ -626,7 +626,7 @@ static void next_out_dma(struct omap_ep *ep, struct omap_req *req)
 	} else {
 		/* set up this DMA transfer, enable the fifo, start */
 		packets /= ep->ep.maxpacket;
-		packets = min(packets, (unsigned)UDC_RXN_TC + 1);
+		packets = min_t(unsigned, packets, UDC_RXN_TC + 1);
 		req->dma_bytes = packets * ep->ep.maxpacket;
 		omap_set_dma_transfer_params(ep->lch, OMAP_DMA_DATA_TYPE_S16,
 				ep->ep.maxpacket >> 1, packets,
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 00e5f19..f30bc7d 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1148,15 +1148,15 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			switch (wValue >> 8) {
 
 			case USB_DT_DEVICE:
-				value = min(wLength, (u16) sizeof device_desc);
+				value = min_t(u16, wLength, sizeof device_desc);
 				memcpy(req->buf, &device_desc, value);
 				break;
 #ifdef CONFIG_USB_GADGET_DUALSPEED
 			case USB_DT_DEVICE_QUALIFIER:
 				if (!gadget->is_dualspeed)
 					break;
-				value = min(wLength,
-						(u16) sizeof dev_qualifier);
+				value = min_t(u16, wLength,
+						sizeof(dev_qualifier));
 				memcpy(req->buf, &dev_qualifier, value);
 				break;
 
@@ -1171,14 +1171,14 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 						wValue & 0xff,
 						gadget->is_otg);
 				if (value >= 0)
-					value = min(wLength, (u16) value);
+					value = min_t(u16, wLength, value);
 				break;
 
 			case USB_DT_STRING:
 				value = usb_gadget_get_string(&stringtab,
 						wValue & 0xff, req->buf);
 				if (value >= 0)
-					value = min(wLength, (u16) value);
+					value = min_t(u16, wLength, value);
 				break;
 			}
 			break;
@@ -1198,7 +1198,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 			if (ctrl->bRequestType != USB_DIR_IN)
 				break;
 			*(u8 *)req->buf = dev->config;
-			value = min(wLength, (u16) 1);
+			value = min_t(u16, wLength, 1);
 			break;
 
 		case USB_REQ_SET_INTERFACE:
@@ -1215,7 +1215,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				break;
 
 			*(u8 *)req->buf = dev->interface;
-			value = min(wLength, (u16) 1);
+			value = min_t(u16, wLength, 1);
 			break;
 
 		default:
@@ -1242,7 +1242,7 @@ printer_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				break;
 
 			*(u8 *)req->buf = dev->printer_status;
-			value = min(wLength, (u16) 1);
+			value = min_t(u16, wLength, 1);
 			break;
 
 		case 2: /* Soft Reset */
diff --git a/drivers/usb/gadget/usbstring.c b/drivers/usb/gadget/usbstring.c
index 58c4d37..f65916a 100644
--- a/drivers/usb/gadget/usbstring.c
+++ b/drivers/usb/gadget/usbstring.c
@@ -124,7 +124,7 @@ usb_gadget_get_string (struct usb_gadget_strings *table, int id, u8 *buf)
 		return -EINVAL;
 
 	/* string descriptors have length, tag, then UTF16-LE text */
-	len = min ((size_t) 126, strlen (s->s));
+	len = min_t(size_t, 126, strlen(s->s));
 	memset (buf + 2, 0, 2 * len);	/* zero all the bytes */
 	len = utf8_to_utf16le(s->s, (__le16 *)&buf[2], len);
 	if (len < 0)
diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
index b08f354..0e3a34d 100644
--- a/drivers/usb/gadget/uvc_video.c
+++ b/drivers/usb/gadget/uvc_video.c
@@ -49,7 +49,7 @@ uvc_video_encode_data(struct uvc_video *video, struct uvc_buffer *buf,
 
 	/* Copy video data to the USB buffer. */
 	mem = queue->mem + buf->buf.m.offset + queue->buf_used;
-	nbytes = min((unsigned int)len, buf->buf.bytesused - queue->buf_used);
+	nbytes = min_t(unsigned int, len, buf->buf.bytesused - queue->buf_used);
 
 	memcpy(data, mem, nbytes);
 	queue->buf_used += nbytes;
@@ -74,7 +74,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 	}
 
 	/* Process video data. */
-	len = min((int)(video->max_payload_size - video->payload_size), len);
+	len = min_t(int, video->max_payload_size - video->payload_size, len);
 	ret = uvc_video_encode_data(video, buf, mem, len);
 
 	video->payload_size += ret;
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
