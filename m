Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0IBWrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:47:19 -0400
Received: from ns2.cypress.com ([157.95.67.5]:55684 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0IBWrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:47:17 -0400
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, cyasgadget fixes
 and mpage_cleardirty
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1283386101.17399.10.camel@odc-laptop>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu>
	 <1283386101.17399.10.camel@odc-laptop>
Content-Type: text/plain
Organization: Cypress
Date: Thu, 02 Sep 2010 15:47:04 -0700
Message-Id: <1283467624.4378.14.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains update to the gadget driver, some of which are based on feedback from the Linux community concerning the usage of fat_get_block.
It also contains the addition of mpage_clear_dirty, a function used to clear dirty pages from the page cache. These two patches are also interdependent
and difficult to separate. As such, they are included as one patch.
Thanks,
David

Signed-off-by: David Cross <david.cross@cypress.com>
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-26 11:18:18.000000000 -0700
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
@@ -752,6 +756,9 @@ static int cyasgadget_queue(
 	_req->status = -EINPROGRESS;
 	_req->actual = 0;
 
+	if (as_req)
+		list_add_tail(&as_req->queue, &as_ep->queue);
+
 	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
 
 	/* Call Async functions */
@@ -772,16 +779,6 @@ static int cyasgadget_queue(
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
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
@@ -817,8 +814,7 @@ static int cyasgadget_queue(
 				"cy_as_usb_write_data_async failed with "
 				"error code %d\n", ret) ;
 		}
-
-	} else if (list_empty(&as_ep->queue)) {
+	} else { /* read function not to EP 0*/
 		#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async being called since "
@@ -836,13 +832,6 @@ static int cyasgadget_queue(
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
 
@@ -1146,11 +1135,9 @@ static int cyasgadget_ioctl(
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
 
@@ -1158,10 +1145,10 @@ static int cyasgadget_ioctl(
 			cy_as_hal_print_message("%s: fhandle is OK, "
 				"calling vfs_getattr\n", __func__);
 			#endif
-
+			
 			ret_stat = vfs_getattr(file_to_allocate->f_path.mnt,
 				file_to_allocate->f_path.dentry, &stat);
-
+			
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message("%s: returned from "
 				"vfs_getattr() stat->blksize=0x%lx\n",
@@ -1171,15 +1158,11 @@ static int cyasgadget_ioctl(
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
-
+			
 			bh.b_state = 0;
 			bh.b_blocknr = 0;
 			/* block size is arbitrary , we'll use sector size*/
@@ -1190,42 +1173,6 @@ static int cyasgadget_ioctl(
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
@@ -1246,7 +1193,7 @@ static int cyasgadget_ioctl(
 					"mpage_cleardirty() "
 					"for %d pages\n", __func__, nr_pages);
 			#endif
-
+			
 			ret_stat = mpage_cleardirty(mapping, nr_pages);
 
 			/*fill up the the block table from the addr mapping  */
@@ -1363,6 +1310,9 @@ static int cyasgadget_ioctl(
 				__func__);
 			#endif
 			sg_init_one(&sg, &blk_table, sizeof(blk_table));
+
+			cy_as_acquire_common_lock();
+
 			ret_stat = cy_as_mtp_init_send_object(dev->dev_handle,
 				(cy_as_mtp_block_table *)&sg,
 				k_d.num_bytes, 0, 0);
@@ -1379,7 +1329,6 @@ static int cyasgadget_ioctl(
 				__func__, alloc_filename);
 		} /* end if (file_to_allocate)*/
 		#endif
-initsoj_safe_exit:
 			ret_stat = 0;
 			retval = __put_user(ret_stat,
 				(uint32_t __user *)(&(usr_d->ret_val)));
@@ -1541,6 +1490,8 @@ initsoj_safe_exit:
 				k_d.num_bytes);
 			#endif
 
+			cy_as_acquire_common_lock();
+
 			ret_stat = cy_as_mtp_init_get_object(
 				dev->dev_handle,
 				(cy_as_mtp_block_table *)&sg,
@@ -2151,7 +2102,21 @@ static int cyasgadget_initialize(void)
 	/*strcpy(cy_as_dev->gadget.dev.bus_id, "cyasgadget");*/
 	cy_as_dev->gadget.dev.release = cyas_gadget_release;
 	cy_as_dev->gadget.name = cy_as_driver_name;
-
+	
+	/* this "gadget" abstracts/virtualizes the controller */
+	dev_set_name(&cy_as_dev->gadget.dev, "cyas" );
+	cy_as_dev->gadget.dev.parent = cy_as_dev->cy_controller;
+
+	retval = device_register(&cy_as_dev->gadget.dev);
+	if (retval != 0) {
+		cy_as_hal_print_message( "%s: can not register device\n", __func__) ;
+		return retval;
+	}
+	#ifndef WESTBRIDGE_NDEBUG
+	else
+		cy_as_hal_print_message( "%s: successfully registered device\n", __func__) ;
+	#endif
+	
 	/* Get the device handle */
 	cy_as_dev->dev_handle = cyasdevice_getdevhandle() ;
 	if (0 == cy_as_dev->dev_handle) {
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
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/fs/mpage.c linux-next-incl-sdk/fs/mpage.c
--- linux-next-vanilla/fs/mpage.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/fs/mpage.c	2010-09-01 16:12:40.000000000 -0700
@@ -716,3 +716,49 @@ int mpage_writepage(struct page *page, g
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepage);
+
+int mpage_cleardirty(struct address_space *mapping, int num_pages)
+{
+	int ret = 0;
+	int nr_pages;
+	struct pagevec pvec;
+	pgoff_t index = 0;
+	pgoff_t end;
+
+	pagevec_init(&pvec, 0);
+	index = mapping->writeback_index;
+	end = index + num_pages;
+    	      
+	while ((index <= end) &&
+	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					      PAGECACHE_TAG_DIRTY,
+					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+		unsigned i;
+		
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			lock_page(page);
+			ret = clear_page_dirty_for_io(page);
+			if (page_has_private(page))
+				do_invalidatepage(page, 0);
+
+			cancel_dirty_page(page, PAGE_CACHE_SIZE);
+
+			remove_from_page_cache(page);
+			ClearPageMappedToDisk(page);
+			page_cache_release(page);	/* pagecache ref */
+			unlock_page(page);
+
+			if (!ret) {
+				printk(KERN_INFO "mpage_cleardirty: clear_page_dirty_for_io returned %d\n", ret);
+				return ret;
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(mpage_cleardirty);


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

