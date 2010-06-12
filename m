Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0FMN4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 09:56:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34251 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab0FMN4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 09:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OY7Shi5qPvpDSHhj5KRtkPOYrJWiIZgLYhFDo9Lpl1m2NYRCDh19LGQ0Usyn0XanE2
         PtX8Dpze3wbsc619FpWLV6F4vYagUNEEBmiI23b03jnsIObuCtnZ94w6IsKXc8I7Tmyo
         Et1JmbhgFQm8g+SE3SWhMJpaA4Kg2sKQBIAvY=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       reodge@gmail.com, andrea.gelmini@gelma.net, henuxd@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:comedi: Fixed coding convention issues.
Date: Sat, 12 Jun 2010 14:04:04 +0300
Message-Id: <1276340644-5211-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up and fixed coding convention issues as reporteed by
checkpatch.pl tool on the file `drivers.c'. Added logging macros
to `comedidev.h'.

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/comedi/comedidev.h |   54 ++++++++++++++++++++-
 drivers/staging/comedi/drivers.c   |   89 ++++++++++++++++++------------------
 2 files changed, 95 insertions(+), 48 deletions(-)

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
index 4a29ed7..a649e7f 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -117,8 +117,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			comedi_info("failed to increment module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -149,8 +148,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  report valid board names before returning error */
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk(KERN_INFO
-			       "comedi: failed to increment module count\n");
+			comedi_info("failed to increment module count\n");
 			continue;
 		}
 		comedi_report_boards(driv);
@@ -205,9 +203,8 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		mutex_lock(&dev->mutex);
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
-				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				printk(KERN_WARNING
+				       "BUG! detaching device with use_count=%d\n", dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -325,8 +322,8 @@ static void comedi_report_boards(struct comedi_driver *driv)
 	unsigned int i;
 	const char *const *name_ptr;
 
-	printk(KERN_INFO "comedi: valid board names for %s driver are:\n",
-	       driv->driver_name);
+	comedi_info("valid board names for %s driver are:\n",
+		    driv->driver_name);
 
 	name_ptr = driv->board_name;
 	for (i = 0; i < driv->num_names; i++) {
@@ -441,21 +438,19 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
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
@@ -478,26 +473,29 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
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
@@ -510,24 +508,27 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
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
@@ -646,8 +647,7 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 {
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
-		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		comedi_info("attempted to write-free more bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -683,8 +683,7 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
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

