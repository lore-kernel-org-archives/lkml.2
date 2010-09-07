Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0IGToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:44:16 -0400
Received: from ns2.cypress.com ([157.95.67.5]:41163 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925Ab0IGToN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:44:13 -0400
Subject: Re: [PATCH] west bridge, cyasgadget fixes
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Tue, 07 Sep 2010 12:44:07 -0700
Message-Id: <1283888647.7250.28.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains update to the gadget driver, some of which are based
on feedback from the Linux community concerning the usage of fat_get_block.
This function call has since been removed along with all file system 
specific calls.
It also contains some fixes for locking issues.
Please let me know if there are issues or concerns with this patch.
Thanks,
David

Signed-off-by: David Cross <david.cross@cypress.com>

diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-07 11:12:44.000000000 -0700
@@ -154,7 +154,7 @@ static void cy_as_gadget_usb_event_callb
 		#ifndef WESTBRIDGE_NDEBUG
 		ctrlreq = (struct usb_ctrlrequest *)evdata;
 
-		cy_as_hal_print_message("<1>_cy_as_event_usb_setup_packet "
+		printk(KERN_INFO "<1>_cy_as_event_usb_setup_packet "
 							"received"
 							"bRequestType=0x%x,"
 							"bRequest=0x%x,"
@@ -224,6 +224,8 @@ static void cy_as_gadget_mtp_event_callb
 			cy_as_mtp_send_object_complete_data *send_obj_data =
 				(cy_as_mtp_send_object_complete_data *) evdata ;
 
+			cy_as_release_common_lock();
+
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
 				"<6>MTP EVENT: send_object_complete\n");
@@ -246,6 +248,8 @@ static void cy_as_gadget_mtp_event_callb
 		{
 			cy_as_mtp_get_object_complete_data *get_obj_data =
 				(cy_as_mtp_get_object_complete_data *) evdata ;
+;
+			cy_as_release_common_lock();
 
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
@@ -341,7 +345,7 @@ static void cyasgadget_setupwritecallbac
 	(void)buf ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>%s called status=0x%x\n",
+		printk(KERN_INFO "<1>%s called status=0x%x\n",
 			__func__, status);
 	#endif
 
@@ -357,7 +361,7 @@ static void cyasgadget_setupwritecallbac
 	stopped = an_ep->stopped ;
 
 #ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("setup_write_callback: ep=%d, "
+	printk(KERN_INFO "setup_write_callback: ep=%d, "
 		"count=%d, status=%d\n", ep, count, status) ;
 #endif
 
@@ -404,7 +408,7 @@ static void cyasgadget_readcallback(
 	stopped = an_ep->stopped ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: ep=%d, count=%d, status=%d\n",
+		printk(KERN_INFO "%s: ep=%d, count=%d, status=%d\n",
 			__func__, ep, count, status) ;
 	#endif
 
@@ -447,7 +451,7 @@ static void cyasgadget_readcallback(
 				an_req->req.buf, cyasgadget_readcallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				printk(KERN_INFO "<1>_cy_as_gadget: "
 					"cy_as_usb_read_data_async failed "
 					"with error code %d\n", ret) ;
 			else
@@ -485,7 +489,7 @@ static void cyasgadget_writecallback(
 		return ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: ep=%d, count=%d, status=%d\n",
+		printk(KERN_INFO "%s: ep=%d, count=%d, status=%d\n",
 			__func__, ep, count, status) ;
 	#endif
 
@@ -524,7 +528,7 @@ static void cyasgadget_writecallback(
 				cy_false, cyasgadget_writecallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				printk(KERN_INFO "<1>_cy_as_gadget: "
 					"cy_as_usb_write_data_async "
 					"failed with error code %d\n", ret) ;
 			else
@@ -543,7 +547,7 @@ static void cyasgadget_stallcallback(
 {
 	#ifndef WESTBRIDGE_NDEBUG
 	if (status != CY_AS_ERROR_SUCCESS)
-		cy_as_hal_print_message("<1>_set/_clear stall "
+		printk(KERN_INFO "<1>_set/_clear stall "
 			"failed with status %d\n", status) ;
 	#endif
 }
@@ -583,7 +587,7 @@ static int cyasgadget_enable(
 
 	if (an_ep->cyepconfig.enabled != cy_true) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		printk(KERN_INFO "<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on enabled\n", an_ep->usb_ep_inst.name) ;
 		#endif
@@ -599,7 +603,7 @@ static int cyasgadget_enable(
 	case USB_ENDPOINT_XFER_ISOC:
 		if (an_ep->cyepconfig.type != cy_as_usb_iso) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
 				an_ep->cyepconfig.type, cy_as_usb_iso) ;
@@ -610,7 +614,7 @@ static int cyasgadget_enable(
 	case USB_ENDPOINT_XFER_INT:
 		if (an_ep->cyepconfig.type != cy_as_usb_int) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
 				an_ep->cyepconfig.type, cy_as_usb_int) ;
@@ -621,7 +625,7 @@ static int cyasgadget_enable(
 	default:
 		if (an_ep->cyepconfig.type != cy_as_usb_bulk) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
 				an_ep->cyepconfig.type, cy_as_usb_bulk) ;
@@ -637,7 +641,7 @@ static int cyasgadget_enable(
 	if ((an_ep->cyepconfig.dir == cy_as_usb_in) &&
 	(!an_ep->is_in)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		printk(KERN_INFO "<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on dir %d %d\n", an_ep->usb_ep_inst.name,
 			an_ep->cyepconfig.dir, cy_as_usb_in) ;
@@ -646,7 +650,7 @@ static int cyasgadget_enable(
 	} else if ((an_ep->cyepconfig.dir == cy_as_usb_out) &&
 	(an_ep->is_in)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		printk(KERN_INFO "<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on dir %d %d\n", an_ep->usb_ep_inst.name,
 			an_ep->cyepconfig.dir, cy_as_usb_out) ;
@@ -657,7 +661,7 @@ static int cyasgadget_enable(
 	cy_as_usb_clear_stall(an_dev->dev_handle, an_ep->num,
 		cyasgadget_stallcallback, 0);
 
-	cy_as_hal_print_message("%s enabled %s (ep%d-%d) max %04x\n",
+	printk(KERN_INFO "%s enabled %s (ep%d-%d) max %04x\n",
 		__func__, _ep->name, an_ep->num, tmp, max);
 
 	return 0;
@@ -752,12 +756,15 @@ static int cyasgadget_queue(
 	_req->status = -EINPROGRESS;
 	_req->actual = 0;
 
+	if (as_req)
+		list_add_tail(&as_req->queue, &as_ep->queue);
+
 	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
 
 	/* Call Async functions */
 	if (as_ep->is_in) {
 		#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async being called "
 				"on ep %d\n", as_ep->num) ;
 		#endif
@@ -766,25 +773,15 @@ static int cyasgadget_queue(
 			as_ep->num, _req->length, _req->buf,
 			cy_false, cyasgadget_writecallback) ;
 		if (ret != CY_AS_ERROR_SUCCESS)
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with "
 				"error code %d\n", ret) ;
 		else
 			_req->status = -EALREADY ;
 	} else if (as_ep->num == 0) {
-		/*
-		ret = cy_as_usb_write_data_async(cy_as_dev->dev_handle,
-			as_ep->num, _req->length, _req->buf, cy_false,
-			cyasgadget_setupwritecallback) ;
-
-		if (ret != CY_AS_ERROR_SUCCESS)
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
-				"cy_as_usb_write_data_async failed with error "
-				"code %d\n", ret) ;
-		*/
 		if ((cy_as_dev->outsetupreq) && (_req->length)) {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				printk(KERN_INFO "<1>_cy_as_gadget: "
 					"cy_as_usb_read_data_async "
 					"being called on ep %d\n",
 					as_ep->num) ;
@@ -796,13 +793,13 @@ static int cyasgadget_queue(
 				cyasgadget_setupreadcallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async failed with "
 				"error code %d\n", ret) ;
 
 		} else {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				printk(KERN_INFO "<1>_cy_as_gadget: "
 					"cy_as_usb_write_data_async "
 					"being called on ep %d\n",
 					as_ep->num) ;
@@ -813,14 +810,13 @@ static int cyasgadget_queue(
 			cyasgadget_setupwritecallback) ;
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with "
 				"error code %d\n", ret) ;
 		}
-
-	} else if (list_empty(&as_ep->queue)) {
+	} else { /* read function not to EP 0*/
 		#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async being called since "
 				"ep queue empty%d\n", ret) ;
 		#endif
@@ -829,20 +825,13 @@ static int cyasgadget_queue(
 			as_ep->num, cy_false, _req->length, _req->buf,
 			cyasgadget_readcallback) ;
 		if (ret != CY_AS_ERROR_SUCCESS)
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			printk(KERN_INFO "<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async failed with error "
 				"code %d\n", ret) ;
 		else
 			_req->status = -EALREADY ;
 	}
 
-	spin_lock_irqsave(&cy_as_dev->lock, flags);
-
-	if (as_req)
-		list_add_tail(&as_req->queue, &as_ep->queue);
-
-	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
-
 	return 0;
 }
 
@@ -858,7 +847,7 @@ static int cyasgadget_dequeue(
 	dev = an_ep->dev ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>%s called\n", __func__);
+		printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	cy_as_usb_cancel_async(dev->dev_handle, an_ep->num);
@@ -875,7 +864,7 @@ static int cyasgadget_set_halt(
 	int			retval = 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	an_ep = container_of(_ep, cyasgadget_ep, usb_ep_inst);
@@ -913,7 +902,7 @@ static int cyasgadget_fifo_status(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	return 0 ;
@@ -924,7 +913,7 @@ static void cyasgadget_fifo_flush(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 }
 
@@ -948,7 +937,7 @@ static int cyasgadget_get_frame(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 	return 0 ;
 }
@@ -958,7 +947,7 @@ static int cyasgadget_wakeup(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 	return 0;
 }
@@ -969,7 +958,7 @@ static int cyasgadget_set_selfpowered(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 	return 0;
 }
@@ -983,7 +972,7 @@ static int cyasgadget_pullup(
 	unsigned long   flags;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	if (!_gadget)
@@ -1015,7 +1004,7 @@ static int cyasgadget_ioctl(
 	cyasgadget *dev = cy_as_gadget_controller ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called, code=%d, param=%ld\n",
+	printk(KERN_INFO "<1>%s called, code=%d, param=%ld\n",
 		__func__, code, param);
 	#endif
 	/*
@@ -1024,7 +1013,7 @@ static int cyasgadget_ioctl(
 	 */
 	if (_IOC_TYPE(code) != CYASGADGET_IOC_MAGIC) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s, bad magic number = 0x%x\n",
+		printk(KERN_INFO "%s, bad magic number = 0x%x\n",
 			__func__, _IOC_TYPE(code));
 		#endif
 		return -ENOTTY;
@@ -1032,7 +1021,7 @@ static int cyasgadget_ioctl(
 
 	if (_IOC_NR(code) > CYASGADGET_IOC_MAXNR) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s, bad ioctl code = 0x%x\n",
+		printk(KERN_INFO "%s, bad ioctl code = 0x%x\n",
 			__func__, _IOC_NR(code));
 		#endif
 		return -ENOTTY;
@@ -1052,7 +1041,7 @@ static int cyasgadget_ioctl(
 			(void __user *)param, _IOC_SIZE(code));
 
 	if (err) {
-		cy_as_hal_print_message("%s, bad ioctl dir = 0x%x\n",
+		printk(KERN_INFO "%s, bad ioctl dir = 0x%x\n",
 			__func__, _IOC_DIR(code));
 		return -EFAULT;
 	}
@@ -1064,7 +1053,7 @@ static int cyasgadget_ioctl(
 			(cy_as_gadget_ioctl_tmtp_status *)param ;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: got CYASGADGET_GETMTPSTATUS\n",
+		printk(KERN_INFO "%s: got CYASGADGET_GETMTPSTATUS\n",
 			__func__);
 		#endif
 
@@ -1089,7 +1078,7 @@ static int cyasgadget_ioctl(
 	case CYASGADGET_CLEARTMTPSTATUS:
 		{
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s got CYASGADGET_CLEARTMTPSTATUS\n",
+		printk(KERN_INFO "%s got CYASGADGET_CLEARTMTPSTATUS\n",
 			__func__);
 		#endif
 
@@ -1110,7 +1099,7 @@ static int cyasgadget_ioctl(
 		struct file *file_to_allocate;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s got CYASGADGET_INITSOJ\n",
+		printk(KERN_INFO "%s got CYASGADGET_INITSOJ\n",
 			__func__);
 		#endif
 
@@ -1128,7 +1117,7 @@ static int cyasgadget_ioctl(
 		if (copy_from_user(alloc_filename, k_d.file_name,
 			k_d.name_length + 1)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: CYASGADGET_INITSOJ, "
+			printk(KERN_INFO "%s: CYASGADGET_INITSOJ, "
 				"copy file name from user space failed\n",
 				__func__);
 			#endif
@@ -1146,16 +1135,14 @@ static int cyasgadget_ioctl(
 			struct inode *inode = mapping->host;
 			struct inode *alloc_inode =
 				file_to_allocate->f_path.dentry->d_inode;
-			int cluster = 0;
 			uint32_t num_clusters = 0;
 			struct buffer_head bh;
 			struct kstat stat;
-			struct iattr alloc_iattr;
 			int nr_pages = 0;
 			int ret_stat = 0;
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: fhandle is OK, "
+			printk(KERN_INFO "%s: fhandle is OK, "
 				"calling vfs_getattr\n", __func__);
 			#endif
 
@@ -1163,7 +1150,7 @@ static int cyasgadget_ioctl(
 				file_to_allocate->f_path.dentry, &stat);
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: returned from "
+			printk(KERN_INFO "%s: returned from "
 				"vfs_getattr() stat->blksize=0x%lx\n",
 				__func__, stat.blksize);
 			#endif
@@ -1171,14 +1158,10 @@ static int cyasgadget_ioctl(
 			/* TODO:  get this from disk properties
 			 * (from blockdevice)*/
 			#define SECTOR_SIZE 512
-			if (stat.blksize != 0) {
 				num_clusters = (k_d.num_bytes) / SECTOR_SIZE;
 
-				if (((k_d.num_bytes) % SECTOR_SIZE) != 0)
+			if (((k_d.num_bytes) % SECTOR_SIZE) != 0)
 						num_clusters++;
-			} else {
-				goto initsoj_safe_exit;
-			}
 
 			bh.b_state = 0;
 			bh.b_blocknr = 0;
@@ -1186,46 +1169,10 @@ static int cyasgadget_ioctl(
 			bh.b_size = SECTOR_SIZE ;
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: getting fat blocks %d "
+			printk(KERN_INFO "%s: getting fat blocks %d "
 				"size of  %d\n", __func__,
 				num_clusters, bh.b_size);
 			#endif
-			for (cluster = 0; cluster < num_clusters; cluster++)  {
-				ret_stat = fat_get_block(inode,
-					cluster, &bh, 1);
-				if (ret_stat) {
-					cy_as_hal_print_message(
-						"%s: unable to get fat block, "
-						"ret_stat=0x%d\n",
-						__func__, ret_stat);
-					goto initsoj_safe_exit;
-				}
-			}
-
-			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: allocated clusters "
-				"successfully (fat_get_block), check bmap..."
-				"\n", __func__);
-			#endif
-
-			alloc_iattr.ia_valid = ATTR_SIZE;
-			alloc_iattr.ia_size = k_d.num_bytes;
-
-			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: calling fat_notify_change "
-				"(ia_valid:%d, ia_size:%d)\n", __func__,
-				alloc_iattr.ia_valid,
-				(int)alloc_iattr.ia_size);
-			#endif
-
-			/* adjust the filesize */
-			ret_stat = alloc_inode->i_op->setattr(
-				file_to_allocate->f_path.dentry, &alloc_iattr);
-			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: fat_setattr() "
-				"returned 0x%x\n",
-				__func__, ret_stat);
-			#endif
 
 			/* clear dirty pages in page cache
 			 * (if were any allocated) */
@@ -1237,12 +1184,12 @@ static int cyasgadget_ioctl(
 			#ifndef WESTBRIDGE_NDEBUG
 			/*check out how many pages where actually allocated */
 			if (mapping->nrpages != nr_pages)
-				cy_as_hal_print_message("%s mpage_cleardirty "
+				printk(KERN_INFO "%s mpage_cleardirty "
 					"mapping->nrpages %d != num_pages %d\n",
 					__func__, (int) mapping->nrpages,
 					nr_pages);
 
-				cy_as_hal_print_message("%s: calling "
+				printk(KERN_INFO "%s: calling "
 					"mpage_cleardirty() "
 					"for %d pages\n", __func__, nr_pages);
 			#endif
@@ -1363,11 +1310,14 @@ static int cyasgadget_ioctl(
 				__func__);
 			#endif
 			sg_init_one(&sg, &blk_table, sizeof(blk_table));
+
+			cy_as_acquire_common_lock();
+
 			ret_stat = cy_as_mtp_init_send_object(dev->dev_handle,
 				(cy_as_mtp_block_table *)&sg,
 				k_d.num_bytes, 0, 0);
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: returned from "
+			printk(KERN_INFO "%s: returned from "
 				"cy_as_mtp_init_send_object()\n", __func__);
 			#endif
 
@@ -1379,7 +1329,6 @@ static int cyasgadget_ioctl(
 				__func__, alloc_filename);
 		} /* end if (file_to_allocate)*/
 		#endif
-initsoj_safe_exit:
 			ret_stat = 0;
 			retval = __put_user(ret_stat,
 				(uint32_t __user *)(&(usr_d->ret_val)));
@@ -1413,14 +1362,14 @@ initsoj_safe_exit:
 		if (copy_from_user(map_filename, k_d.file_name,
 			k_d.name_length + 1)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: copy file name from "
+			printk(KERN_INFO "%s: copy file name from "
 				"user space failed\n", __func__);
 			#endif
 			return -EFAULT;
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<*>%s: opening %s for kernel "
+		printk(KERN_INFO "<*>%s: opening %s for kernel "
 			"mode access map\n", __func__, map_filename);
 		#endif
 		file_to_map = filp_open(map_filename, O_RDWR, 0);
@@ -1541,6 +1490,8 @@ initsoj_safe_exit:
 				k_d.num_bytes);
 			#endif
 
+			cy_as_acquire_common_lock();
+
 			ret_stat = cy_as_mtp_init_get_object(
 				dev->dev_handle,
 				(cy_as_mtp_block_table *)&sg,
@@ -1590,7 +1541,7 @@ initsoj_safe_exit:
 			(cy_as_gadget_ioctl_cancel *)param ;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: got CYASGADGET_CANCELGOJ\n",
+		printk(KERN_INFO "%s: got CYASGADGET_CANCELGOJ\n",
 			__func__);
 		#endif
 
@@ -1603,10 +1554,10 @@ initsoj_safe_exit:
 	default:
 		{
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: unknown ioctl received: %d\n",
+		printk(KERN_INFO "%s: unknown ioctl received: %d\n",
 			__func__, code);
 
-		cy_as_hal_print_message("%s: known codes:\n"
+		printk(KERN_INFO "%s: known codes:\n"
 			"CYASGADGET_GETMTPSTATUS=%d\n"
 			"CYASGADGET_CLEARTMTPSTATUS=%d\n"
 			"CYASGADGET_INITSOJ=%d\n"
@@ -1651,7 +1602,7 @@ static void cyas_ep_reset(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	an_ep->desc = NULL;
@@ -1674,7 +1625,7 @@ static void cyas_usb_reset(
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_device *dev_p = (cy_as_device *)cy_as_dev->dev_handle ;
 
-	cy_as_hal_print_message("<1>%s called mtp_firmware=0x%x\n",
+	printk(KERN_INFO "<1>%s called mtp_firmware=0x%x\n",
 		__func__, dev_p->is_mtp_firmware);
 	#endif
 
@@ -1682,7 +1633,7 @@ static void cyas_usb_reset(
 		cy_as_bus_u_s_b) ;
 	if (ret != CY_AS_ERROR_SUCCESS && ret !=
 		CY_AS_ERROR_RESOURCE_NOT_OWNED) {
-		cy_as_hal_print_message("<1>_cy_as_gadget: cannot "
+		printk(KERN_INFO "<1>_cy_as_gadget: cannot "
 			"release usb resource: failed with error code %d\n",
 			ret) ;
 		return ;
@@ -1692,7 +1643,7 @@ static void cyas_usb_reset(
 
 	ret = cy_as_usb_start(cy_as_dev->dev_handle, 0, 0) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		printk(KERN_INFO "<1>_cy_as_gadget: "
 			"cy_as_usb_start failed with error code %d\n",
 			ret) ;
 		return ;
@@ -1708,7 +1659,7 @@ static void cyas_usb_reset(
 		ret = cy_as_mtp_start(cy_as_dev->dev_handle,
 			cy_as_gadget_mtp_event_callback, 0, 0);
 		if (ret == CY_AS_ERROR_SUCCESS)  {
-			cy_as_hal_print_message("MTP start passed, enumerating "
+			printk(KERN_INFO "MTP start passed, enumerating "
 				"MTP interface\n");
 			config.mtp_interface = append_mtp ;
 			/*Do not enumerate NAND storage*/
@@ -1718,7 +1669,7 @@ static void cyas_usb_reset(
 			config.devices_to_enumerate[1][0] = cy_true;
 		}
 	} else {
-		cy_as_hal_print_message("MTP start not attempted, not "
+		printk(KERN_INFO "MTP start not attempted, not "
 			"enumerating MTP interface\n");
 		config.mtp_interface = 0 ;
 		/* enumerate mass storage based on module parameters */
@@ -1729,7 +1680,7 @@ static void cyas_usb_reset(
 	ret = cy_as_usb_set_enum_config(cy_as_dev->dev_handle,
 		&config, 0, 0) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		printk(KERN_INFO "<1>_cy_as_gadget: "
 			"cy_as_usb_set_enum_config failed with error "
 			"code %d\n", ret) ;
 		return ;
@@ -1751,7 +1702,7 @@ static void cyas_usb_reinit(
 	INIT_LIST_HEAD(&cy_as_dev->gadget.ep_list);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called, is_mtp_firmware = "
+	printk(KERN_INFO "<1>%s called, is_mtp_firmware = "
 		"0x%x\n", __func__, dev_p->is_mtp_firmware);
 	#endif
 
@@ -1792,7 +1743,7 @@ static void cyas_usb_reinit(
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
 		3, &an_ep_p->cyepconfig) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
+		printk(KERN_INFO "cy_as_usb_set_end_point_config "
 			"failed with error code %d\n", ret) ;
 	}
 
@@ -1807,7 +1758,7 @@ static void cyas_usb_reinit(
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
 		5, &an_ep_p->cyepconfig) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
+		printk(KERN_INFO "cy_as_usb_set_end_point_config "
 			"failed with error code %d\n", ret) ;
 	}
 
@@ -1822,7 +1773,7 @@ static void cyas_usb_reinit(
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
 		9, &an_ep_p->cyepconfig) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
+		printk(KERN_INFO "cy_as_usb_set_end_point_config "
 			"failed with error code %d\n", ret) ;
 	}
 
@@ -1867,14 +1818,14 @@ static void cyas_ep0_start(
 	cy_as_return_status_t ret ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	ret = cy_as_usb_register_callback(dev->dev_handle,
 		cy_as_gadget_usb_event_callback) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cy_as_usb_register_callback "
+		printk(KERN_INFO "%s: cy_as_usb_register_callback "
 			"failed with error code %d\n", __func__, ret) ;
 		#endif
 		return ;
@@ -1883,28 +1834,28 @@ static void cyas_ep0_start(
 	ret = cy_as_usb_commit_config(dev->dev_handle, 0, 0) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cy_as_usb_commit_config "
+		printk(KERN_INFO "%s: cy_as_usb_commit_config "
 			"failed with error code %d\n", __func__, ret) ;
 		#endif
 		return ;
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: cy_as_usb_commit_config "
+	printk(KERN_INFO "%s: cy_as_usb_commit_config "
 		"message sent\n", __func__) ;
 	#endif
 
 	ret = cy_as_usb_connect(dev->dev_handle, 0, 0) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cy_as_usb_connect failed "
+		printk(KERN_INFO "%s: cy_as_usb_connect failed "
 			"with error code %d\n", __func__, ret) ;
 		#endif
 		return ;
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: cy_as_usb_connect message "
+	printk(KERN_INFO "%s: cy_as_usb_connect message "
 		"sent\n", __func__) ;
 	#endif
 }
@@ -1924,7 +1875,7 @@ int usb_gadget_register_driver(
 	int		retval;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called driver=0x%x\n",
+	printk(KERN_INFO "<1>%s called driver=0x%x\n",
 		__func__, (unsigned int) driver);
 	#endif
 
@@ -1956,7 +1907,7 @@ int usb_gadget_register_driver(
 	retval = driver->bind(&dev->gadget);
 	if (retval) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s bind to driver %s --> %d\n",
+		printk(KERN_INFO "%s bind to driver %s --> %d\n",
 			__func__, driver->driver.name, retval);
 		#endif
 
@@ -1981,7 +1932,7 @@ static void cyasgadget_nuke(
 	cyasgadget	*dev = cy_as_gadget_controller ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	cy_as_usb_cancel_async(dev->dev_handle, an_ep->num);
@@ -2004,7 +1955,7 @@ static void cyasgadget_stop_activity(
 	int index ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	/* don't disconnect if it's not connected */
@@ -2034,14 +1985,14 @@ static void cyasgadget_stop_activity(
 		driver->disconnect(&dev->gadget);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cy_as_usb_disconnect returned success");
+	printk(KERN_INFO "cy_as_usb_disconnect returned success");
 	#endif
 
 	/* Stop Usb */
 	cy_as_usb_stop(dev->dev_handle, 0, 0) ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cy_as_usb_stop returned success");
+	printk(KERN_INFO "cy_as_usb_stop returned success");
 	#endif
 }
 
@@ -2052,7 +2003,7 @@ int usb_gadget_unregister_driver(
 	cyasgadget	*dev = cy_as_gadget_controller ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	if (!dev)
@@ -2068,7 +2019,7 @@ int usb_gadget_unregister_driver(
 	dev->driver = NULL;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("unregistered driver '%s'\n",
+	printk(KERN_INFO "unregistered driver '%s'\n",
 		driver->driver.name) ;
 	#endif
 
@@ -2083,7 +2034,7 @@ static void cyas_gadget_release(
 	cyasgadget *dev = dev_get_drvdata(_dev);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	printk(KERN_INFO "<1>%s called\n", __func__);
 	#endif
 
 	kfree(dev);
@@ -2095,12 +2046,12 @@ static void cyasgadget_deinit(
 			)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>_cy_as_gadget deinitialize called\n") ;
+	printk(KERN_INFO "<1>_cy_as_gadget deinitialize called\n") ;
 	#endif
 
 	if (!cy_as_dev) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget_deinit: "
+		printk(KERN_INFO "<1>_cy_as_gadget_deinit: "
 			"invalid cyasgadget device\n") ;
 		#endif
 		return ;
@@ -2109,7 +2060,7 @@ static void cyasgadget_deinit(
 	if (cy_as_dev->driver) {
 		/* should have been done already by driver model core */
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1> cy_as_gadget: '%s' "
+		printk(KERN_INFO "<1> cy_as_gadget: '%s' "
 			"is still registered\n",
 			cy_as_dev->driver->driver.name);
 		#endif
@@ -2127,18 +2078,18 @@ static int cyasgadget_initialize(void)
 	int		 retval = 0 ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>_cy_as_gadget [V1.1] initialize called\n") ;
+	printk(KERN_INFO "<1>_cy_as_gadget [V1.1] initialize called\n") ;
 	#endif
 
 	if (cy_as_gadget_controller != 0) {
-		cy_as_hal_print_message("<1> cy_as_gadget: the device has "
+		printk(KERN_INFO "<1> cy_as_gadget: the device has "
 			"already been initilaized. ignoring\n") ;
 		return -EBUSY ;
 	}
 
 	cy_as_dev = kzalloc(sizeof(cyasgadget), GFP_ATOMIC);
 	if (cy_as_dev == NULL) {
-		cy_as_hal_print_message("<1> cy_as_gadget: memory "
+		printk(KERN_INFO "<1> cy_as_gadget: memory "
 			"allocation failed\n") ;
 		return -ENOMEM;
 	}
@@ -2152,11 +2103,27 @@ static int cyasgadget_initialize(void)
 	cy_as_dev->gadget.dev.release = cyas_gadget_release;
 	cy_as_dev->gadget.name = cy_as_driver_name;
 
+	/* this "gadget" abstracts/virtualizes the controller */
+	dev_set_name(&cy_as_dev->gadget.dev, "cyas");
+	cy_as_dev->gadget.dev.parent = cy_as_dev->cy_controller;
+
+	retval = device_register(&cy_as_dev->gadget.dev);
+	if (retval != 0) {
+		printk(KERN_INFO
+			"%s: can not register device\n", __func__) ;
+		return retval;
+	}
+	#ifndef WESTBRIDGE_NDEBUG
+	else
+		printk(KERN_INFO
+			"%s: successfully registered device\n", __func__) ;
+	#endif
+
 	/* Get the device handle */
 	cy_as_dev->dev_handle = cyasdevice_getdevhandle() ;
 	if (0 == cy_as_dev->dev_handle) {
 		#ifndef NDEBUG
-		cy_as_hal_print_message("<1> cy_as_gadget: "
+		printk(KERN_INFO "<1> cy_as_gadget: "
 			"no west bridge device\n") ;
 		#endif
 		retval = -EFAULT ;
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.h linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.h
--- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.h	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.h	2010-08-25 18:28:27.000000000 -0700
@@ -83,8 +83,9 @@
 #include <linux/uaccess.h>	/* copy_*_user */
 
 extern int mpage_cleardirty(struct address_space *mapping, int num_pages);
-extern int fat_get_block(struct inode *, sector_t , struct buffer_head *, int);
 extern cy_as_device_handle *cyasdevice_getdevhandle(void) ;
+extern void cy_as_acquire_common_lock(void);
+extern void cy_as_release_common_lock(void);
 
 /* Driver data structures and utilities */
 typedef struct cyasgadget_ep {
@@ -119,6 +120,7 @@ typedef struct cyasgadget {
 	struct usb_gadget			gadget;
 	spinlock_t					lock;
 	struct cyasgadget_ep		an_gadget_ep[16];
+	struct device			*cy_controller;
 	struct usb_gadget_driver	 *driver;
 	/* Handle to the West Bridge device */
 	cy_as_device_handle			dev_handle;


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

