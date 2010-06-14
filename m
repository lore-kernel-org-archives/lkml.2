Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0FNGea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:34:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58963 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0FNGe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MygmR2+EDP9mv6jrCRemcAsRhDsJNMao2AgbQTP08o3LDeEgK7X5gNUaZrmmmAwZeN
         +weClsaEHfpY9VYIDoQy93ahhGk/WW6mx01MFcJ/hKr6d2me62XR3jODdwlS6SEjEJ6S
         SNkVyR4xM1jowill9M3Ekgx0FbZXsBLwH4bt4=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       reodge@gmail.com, andrea.gelmini@gelma.net, henuxd@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:comedi: Fixed coding convention issues.
Date: Mon, 14 Jun 2010 09:34:15 +0300
Message-Id: <1276497255-2186-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up and fixed coding convention issues as reporteed by
checkpatch.pl tool on the file `drivers.c'. Added logging macros
to `comedidev.h'.  Replaced "BUG:" printk functions calls with
BUG_ON macro.

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/comedi/comedidev.h |   54 +++++++++++++++-
 drivers/staging/comedi/drivers.c   |  118 +++++++++++++++--------------------
 2 files changed, 102 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 4eb2b77..5c78564 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -43,11 +43,59 @@
 
 #include "comedi.h"
 
-#define DPRINTK(format, args...)	do {		\
-	if (comedi_debug)				\
-		printk(KERN_DEBUG "comedi: " format , ## args);	\
+#define comedi_printk(level, fmt, args...) \
+	printk(level "comedi: " pr_fmt(fmt), ##args)
+
+#define DPRINTK(format, args...) \
+do { \
+	if (comedi_debug) \
+		comedi_printk(KERN_DEBUG, fmt, ##args); \
 } while (0)
 
+#define comedi_emerg(fmt, ...) \
+	comedi_printk(KERN_EMERG, fmt, ##__VA_ARGS__)
+#define comedi_alert(fmt, ...) \
+	comedi_printk(KERN_ALERT, fmt, ##__VA_ARGS__)
+#define comedi_crit(fmt, ...) \
+	comedi_printk(KERN_CRIT, fmt, ##__VA_ARGS__)
+#define comedi_err(fmt, ...) \
+	comedi_printk(KERN_ERR, fmt, ##__VA_ARGS__)
+#define comedi_warn(fmt, ...) \
+	comedi_printk(KERN_WARN, fmt, ##__VA_ARGS__)
+#define comedi_notice(fmt, ...) \
+	comedi_printk(KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define comedi_info(fmt, ...) \
+	comedi_printk(KERN_INFO, fmt, ##__VA_ARGS__)
+
+/* comedi_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define comedi_devel(fmt, ...) \
+	comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__)
+#else
+#define comedi_devel(fmt, ...) \
+({ \
+	if (0) \
+		comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS_); \
+	0; \
+})
+#endif
+
+#if defined(DEBUG)
+#define comedi_debug(fmt, ..) \
+	comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define comedi_debug(fmt, ...) \
+	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#else
+#define comedi_debug(fmt, ...) \
+({ \
+	if (0) \
+		comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__); \
+	0; \
+})
+#endif
+
 #define COMEDI_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
 #define COMEDI_VERSION_CODE COMEDI_VERSION(COMEDI_MAJORVERSION, \
 	COMEDI_MINORVERSION, COMEDI_MICROVERSION)
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..410e83e 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -92,11 +92,8 @@ static void cleanup_device(struct comedi_device *dev)
 static void __comedi_device_detach(struct comedi_device *dev)
 {
 	dev->attached = 0;
-	if (dev->driver)
-		dev->driver->detach(dev);
-	else
-		printk(KERN_WARNING
-		       "BUG: dev->driver=NULL in comedi_device_detach()\n");
+	BUG_ON(!dev->driver);
+	dev->driver->detach(dev);
 	cleanup_device(dev);
 }
 
@@ -117,8 +114,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			comedi_info("failed to increment module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -149,8 +145,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  report valid board names before returning error */
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk(KERN_INFO
-			       "comedi: failed to increment module count\n");
+			comedi_info("failed to increment module count\n");
 			continue;
 		}
 		comedi_report_boards(driv);
@@ -167,11 +162,7 @@ attached:
 		return ret;
 	}
 
-	if (!dev->board_name) {
-		printk(KERN_WARNING "BUG: dev->board_name=<%p>\n",
-		       dev->board_name);
-		dev->board_name = "BUG";
-	}
+	BUG_ON(!dev->board_name);
 	smp_wmb();
 	dev->attached = 1;
 
@@ -204,10 +195,7 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 
 		mutex_lock(&dev->mutex);
 		if (dev->attached && dev->driver == driver) {
-			if (dev->use_count)
-				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+			BUG_ON(dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -252,8 +240,7 @@ static int postconfig(struct comedi_device *dev)
 			async =
 			    kzalloc(sizeof(struct comedi_async), GFP_KERNEL);
 			if (async == NULL) {
-				printk(KERN_INFO
-				       "failed to allocate async struct\n");
+				comedi_info("failed to allocate async struct\n");
 				return -ENOMEM;
 			}
 			init_waitqueue_head(&async->wait_head);
@@ -268,7 +255,7 @@ static int postconfig(struct comedi_device *dev)
 			async->prealloc_buf = NULL;
 			async->prealloc_bufsz = 0;
 			if (comedi_buf_alloc(dev, s, DEFAULT_BUF_SIZE) < 0) {
-				printk(KERN_INFO "Buffer allocation failed\n");
+				comedi_info("Buffer allocation failed\n");
 				return -ENOMEM;
 			}
 			if (s->buf_change) {
@@ -325,17 +312,17 @@ static void comedi_report_boards(struct comedi_driver *driv)
 	unsigned int i;
 	const char *const *name_ptr;
 
-	printk(KERN_INFO "comedi: valid board names for %s driver are:\n",
-	       driv->driver_name);
+	comedi_info("valid board names for %s driver are:\n",
+		    driv->driver_name);
 
 	name_ptr = driv->board_name;
 	for (i = 0; i < driv->num_names; i++) {
-		printk(KERN_INFO " %s\n", *name_ptr);
+		comedi_info("%s\n", *name_ptr);
 		name_ptr = (const char **)((char *)name_ptr + driv->offset);
 	}
 
 	if (driv->num_names == 0)
-		printk(KERN_INFO " %s\n", driv->driver_name);
+		comedi_info(" %s\n", driv->driver_name);
 }
 
 static int poll_invalid(struct comedi_device *dev, struct comedi_subdevice *s)
@@ -441,21 +428,19 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (async->buf_page_list) {
 		unsigned i;
 		for (i = 0; i < async->n_buf_pages; ++i) {
-			if (async->buf_page_list[i].virt_addr) {
-				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+			void *virt_addr = async->buf_page_list[i].virt_addr;
+			dma_addr_t dma_addr = async->buf_page_list[i].dma_addr;
+
+			if (virt_addr) {
+				struct page *page = virt_to_page(virt_addr);
+				clear_bit(PG_reserved, &page->flags);
 				if (s->async_dma_dir != DMA_NONE) {
 					dma_free_coherent(dev->hw_dev,
 							  PAGE_SIZE,
-							  async->
-							  buf_page_list
-							  [i].virt_addr,
-							  async->
-							  buf_page_list
-							  [i].dma_addr);
+							  virt_addr,
+							  dma_addr);
 				} else {
-					free_page((unsigned long)
-						  async->buf_page_list[i].
-						  virt_addr);
+					free_page((unsigned long) virt_addr);
 				}
 			}
 		}
@@ -478,26 +463,29 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		}
 		if (pages) {
 			for (i = 0; i < n_pages; i++) {
+				struct comedi_buf_page *buf_page =
+					&async->buf_page_list[i];
+				dma_addr_t dma_addr = buf_page->dma_addr;
+				struct page *page;
+
 				if (s->async_dma_dir != DMA_NONE) {
-					async->buf_page_list[i].virt_addr =
+					buf_page->virt_addr =
 					    dma_alloc_coherent(dev->hw_dev,
 							       PAGE_SIZE,
-							       &async->
-							       buf_page_list
-							       [i].dma_addr,
+							       &dma_addr,
 							       GFP_KERNEL |
 							       __GFP_COMP);
 				} else {
-					async->buf_page_list[i].virt_addr =
+					buf_page->virt_addr =
 					    (void *)
 					    get_zeroed_page(GFP_KERNEL);
 				}
-				if (async->buf_page_list[i].virt_addr == NULL)
+				if (buf_page->virt_addr == NULL)
 					break;
 
-				set_bit(PG_reserved,
-					&(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-				pages[i] = virt_to_page(async->buf_page_list[i].virt_addr);
+				page = virt_to_page(buf_page->virt_addr);
+				set_bit(PG_reserved, &page->flags);
+				pages[i] = page;
 			}
 		}
 		if (i == n_pages) {
@@ -510,24 +498,27 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 			/* Some allocation failed above. */
 			if (async->buf_page_list) {
 				for (i = 0; i < n_pages; i++) {
-					if (async->buf_page_list[i].virt_addr ==
-					    NULL) {
+					struct comedi_buf_page *buf_page =
+						&async->buf_page_list[i];
+					void *virt_addr =
+						buf_page->virt_addr;
+					dma_addr_t dma_addr =
+						buf_page->dma_addr;
+					struct page *page =
+						virt_to_page(virt_addr);
+
+					if (virt_addr == NULL)
 						break;
-					}
-					clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+
+					clear_bit(PG_reserved, &page->flags);
 					if (s->async_dma_dir != DMA_NONE) {
 						dma_free_coherent(dev->hw_dev,
 								  PAGE_SIZE,
-								  async->
-								  buf_page_list
-								  [i].virt_addr,
-								  async->
-								  buf_page_list
-								  [i].dma_addr);
+								  virt_addr,
+								  dma_addr);
 					} else {
 						free_page((unsigned long)
-							  async->buf_page_list
-							  [i].virt_addr);
+							  virt_addr);
 					}
 				}
 				vfree(async->buf_page_list);
@@ -562,12 +553,7 @@ static unsigned int comedi_buf_munge(struct comedi_async *async,
 		int block_size;
 
 		block_size = num_bytes - count;
-		if (block_size < 0) {
-			printk(KERN_WARNING
-			       "%s: %s: bug! block_size is negative\n",
-			       __FILE__, __func__);
-			break;
-		}
+		BUG_ON(block_size < 0);
 		if ((int)(async->munge_ptr + block_size -
 			  async->prealloc_bufsz) > 0)
 			block_size = async->prealloc_bufsz - async->munge_ptr;
@@ -646,8 +632,7 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 {
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
-		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		comedi_info("attempted to write-free more bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -683,8 +668,7 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 	smp_mb();
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
-		printk(KERN_INFO
-		       "comedi: attempted to read-free more bytes than have been read-allocated.\n");
+		comedi_info("attempted to read-free more bytes than have been read-allocated.\n");
 		nbytes = async->buf_read_alloc_count - async->buf_read_count;
 	}
 	async->buf_read_count += nbytes;
-- 
1.7.1

