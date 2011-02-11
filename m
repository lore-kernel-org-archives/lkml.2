Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab1BKR67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:58:59 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55222
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757726Ab1BKR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:58:58 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 3/3]:Staging: hv:  Remove osd layer
Date: Fri, 11 Feb 2011 10:00:12 -0800
Message-Id: <1297447212-21838-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OSD layer was a wrapper around native interfaces
adding little value and was infact buggy -
refer to the osd_wait.patch for details. 
This patch gets rid of the OSD abstraction.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/Makefile       |    2 +-
 drivers/staging/hv/blkvsc.c       |    2 +-
 drivers/staging/hv/blkvsc_drv.c   |    2 +-
 drivers/staging/hv/channel.c      |    5 +-
 drivers/staging/hv/channel_mgmt.c |    2 +-
 drivers/staging/hv/connection.c   |    2 +-
 drivers/staging/hv/hv.c           |    2 +-
 drivers/staging/hv/hv_api.h       |    5 +
 drivers/staging/hv/hv_kvp.c       |    2 +-
 drivers/staging/hv/hv_util.c      |    2 +-
 drivers/staging/hv/logging.h      |    3 +
 drivers/staging/hv/netvsc.c       |    2 +-
 drivers/staging/hv/netvsc_drv.c   |    2 +-
 drivers/staging/hv/osd.c          |  194 -------------------------------------
 drivers/staging/hv/osd.h          |   62 ------------
 drivers/staging/hv/ring_buffer.c  |    1 -
 drivers/staging/hv/rndis_filter.c |    2 +-
 drivers/staging/hv/storvsc.c      |    2 +-
 drivers/staging/hv/storvsc_drv.c  |    2 +-
 drivers/staging/hv/vmbus_drv.c    |    2 +-
 20 files changed, 26 insertions(+), 272 deletions(-)
 delete mode 100644 drivers/staging/hv/osd.c
 delete mode 100644 drivers/staging/hv/osd.h

diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index 606ce7d..737e517 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_HYPERV_BLOCK)	+= hv_blkvsc.o
 obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
 obj-$(CONFIG_HYPERV_UTILS)	+= hv_utils.o
 
-hv_vmbus-y := vmbus_drv.o osd.o \
+hv_vmbus-y := vmbus_drv.o \
 		 hv.o connection.o channel.o \
 		 channel_mgmt.o ring_buffer.o
 hv_storvsc-y := storvsc_drv.o storvsc.o
diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index b0e07c1..7c8729b 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -22,7 +22,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "storvsc.c"
 
 static const char *g_blk_driver_name = "blkvsc";
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 58bbcd6..36a0adb 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -31,7 +31,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "version_info.h"
 #include "vmbus.h"
diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 5a0923c..775a52a 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -24,10 +24,13 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "vmbus_private.h"
 
+#define NUM_PAGES_SPANNED(addr, len) \
+((PAGE_ALIGN(addr + len) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT))
+
 /* Internal routines */
 static int create_gpadl_header(
 	void *kbuffer,	/* must be phys and virt contiguous */
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index da1e56a..325e0bc 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -26,7 +26,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/completion.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "vmbus_private.h"
 #include "utils.h"
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 51dd362..f7df479 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -26,7 +26,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "vmbus_private.h"
 
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 419b4d6..31b9073 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -23,7 +23,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "vmbus_private.h"
 
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 70e863a..7114fce 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -23,6 +23,11 @@
 #ifndef __HV_API_H
 #define __HV_API_H
 
+struct hv_guid {
+	unsigned char data[16];
+};
+
+
 
 /* Status codes for hypervisor operations. */
 
diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index bc1c20e..faf692e 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -28,7 +28,7 @@
 #include <linux/workqueue.h>
 
 #include "logging.h"
-#include "osd.h"
+#include "hv_api.h"
 #include "vmbus.h"
 #include "vmbus_packet_format.h"
 #include "vmbus_channel_interface.h"
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 43c7ec0..4792f2c 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -28,7 +28,7 @@
 #include <linux/pci.h>
 
 #include "logging.h"
-#include "osd.h"
+#include "hv_api.h"
 #include "vmbus.h"
 #include "vmbus_packet_format.h"
 #include "vmbus_channel_interface.h"
diff --git a/drivers/staging/hv/logging.h b/drivers/staging/hv/logging.h
index 20d4d12..1799951 100644
--- a/drivers/staging/hv/logging.h
+++ b/drivers/staging/hv/logging.h
@@ -25,6 +25,9 @@
 #ifndef _LOGGING_H_
 #define _LOGGING_H_
 
+#define LOWORD(dw) ((unsigned short)(dw))
+#define HIWORD(dw) ((unsigned short)(((unsigned int) (dw) >> 16) & 0xFFFF))
+
 /* #include <linux/init.h> */
 /* #include <linux/module.h> */
 
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 7233564..fa46a7e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -25,7 +25,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "netvsc.h"
 #include "rndis_filter.h"
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 6b8fd0c..e190738 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -36,7 +36,7 @@
 #include <net/route.h>
 #include <net/sock.h>
 #include <net/pkt_sched.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "version_info.h"
 #include "vmbus.h"
diff --git a/drivers/staging/hv/osd.c b/drivers/staging/hv/osd.c
deleted file mode 100644
index b5a3940..0000000
--- a/drivers/staging/hv/osd.c
+++ /dev/null
@@ -1,194 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/vmalloc.h>
-#include <linux/ioport.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/workqueue.h>
-#include <linux/kernel.h>
-#include <linux/jiffies.h>
-#include <linux/delay.h>
-#include <linux/time.h>
-#include <linux/io.h>
-#include <linux/bitops.h>
-#include <linux/slab.h>
-#include "osd.h"
-
-void *osd_virtual_alloc_exec(unsigned int size)
-{
-#ifdef __x86_64__
-	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL_EXEC);
-#else
-	return __vmalloc(size, GFP_KERNEL,
-			 __pgprot(__PAGE_KERNEL & (~_PAGE_NX)));
-#endif
-}
-
-/**
- * osd_page_alloc() - Allocate pages
- * @count:      Total number of Kernel pages you want to allocate
- *
- * Tries to allocate @count number of consecutive free kernel pages.
- * And if successful, it will set the pages to 0 before returning.
- * If successfull it will return pointer to the @count pages.
- * Mainly used by Hyper-V drivers.
- */
-void *osd_page_alloc(unsigned int count)
-{
-	void *p;
-
-	p = (void *)__get_free_pages(GFP_KERNEL, get_order(count * PAGE_SIZE));
-	if (p)
-		memset(p, 0, count * PAGE_SIZE);
-	return p;
-
-	/* struct page* page = alloc_page(GFP_KERNEL|__GFP_ZERO); */
-	/* void *p; */
-
-	/* BUGBUG: We need to use kmap in case we are in HIMEM region */
-	/* p = page_address(page); */
-	/* if (p) memset(p, 0, PAGE_SIZE); */
-	/* return p; */
-}
-EXPORT_SYMBOL_GPL(osd_page_alloc);
-
-/**
- * osd_page_free() - Free pages
- * @page:       Pointer to the first page to be freed
- * @count:      Total number of Kernel pages you free
- *
- * Frees the pages allocated by osd_page_alloc()
- * Mainly used by Hyper-V drivers.
- */
-void osd_page_free(void *page, unsigned int count)
-{
-	free_pages((unsigned long)page, get_order(count * PAGE_SIZE));
-	/*struct page* p = virt_to_page(page);
-	__free_page(p);*/
-}
-EXPORT_SYMBOL_GPL(osd_page_free);
-
-/**
- * osd_waitevent_create() - Create the event queue
- *
- * Allocates memory for a &struct osd_waitevent. And then calls
- * init_waitqueue_head to set up the wait queue for the event.
- * This structure is usually part of a another structure that contains
- * the actual Hyper-V device driver structure.
- *
- * Returns pointer to &struct osd_waitevent
- * Mainly used by Hyper-V drivers.
- */
-struct osd_waitevent *osd_waitevent_create(void)
-{
-	struct osd_waitevent *wait = kmalloc(sizeof(struct osd_waitevent),
-					     GFP_KERNEL);
-	if (!wait)
-		return NULL;
-
-	wait->condition = 0;
-	init_waitqueue_head(&wait->event);
-	return wait;
-}
-EXPORT_SYMBOL_GPL(osd_waitevent_create);
-
-
-/**
- * osd_waitevent_set() - Wake up the process
- * @wait_event: Structure to event to be woken up
- *
- * @wait_event is of type &struct osd_waitevent
- *
- * Wake up the sleeping process so it can do some work.
- * And set condition indicator in &struct osd_waitevent to indicate
- * the process is in a woken state.
- *
- * Only used by Network and Storage Hyper-V drivers.
- */
-void osd_waitevent_set(struct osd_waitevent *wait_event)
-{
-	wait_event->condition = 1;
-	wake_up_interruptible(&wait_event->event);
-}
-EXPORT_SYMBOL_GPL(osd_waitevent_set);
-
-/**
- * osd_waitevent_wait() - Wait for event till condition is true
- * @wait_event: Structure to event to be put to sleep
- *
- * @wait_event is of type &struct osd_waitevent
- *
- * Set up the process to sleep until waitEvent->condition get true.
- * And set condition indicator in &struct osd_waitevent to indicate
- * the process is in a sleeping state.
- *
- * Returns the status of 'wait_event_interruptible()' system call
- *
- * Mainly used by Hyper-V drivers.
- */
-int osd_waitevent_wait(struct osd_waitevent *wait_event)
-{
-	int ret = 0;
-
-	ret = wait_event_interruptible(wait_event->event,
-				       wait_event->condition);
-	wait_event->condition = 0;
-	return ret;
-}
-EXPORT_SYMBOL_GPL(osd_waitevent_wait);
-
-/**
- * osd_waitevent_waitex() - Wait for event or timeout for process wakeup
- * @wait_event: Structure to event to be put to sleep
- * @timeout_in_ms:       Total number of Milliseconds to wait before waking up
- *
- * @wait_event is of type &struct osd_waitevent
- * Set up the process to sleep until @waitEvent->condition get true or
- * @timeout_in_ms (Time out in Milliseconds) has been reached.
- * And set condition indicator in &struct osd_waitevent to indicate
- * the process is in a sleeping state.
- *
- * Returns the status of 'wait_event_interruptible_timeout()' system call
- *
- * Mainly used by Hyper-V drivers.
- */
-int osd_waitevent_waitex(struct osd_waitevent *wait_event, u32 timeout_in_ms)
-{
-	int ret = 0;
-
-	ret = wait_event_interruptible_timeout(wait_event->event,
-					       wait_event->condition,
-					       msecs_to_jiffies(timeout_in_ms));
-	wait_event->condition = 0;
-	return ret;
-}
-EXPORT_SYMBOL_GPL(osd_waitevent_waitex);
diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
deleted file mode 100644
index f787161..0000000
--- a/drivers/staging/hv/osd.h
+++ /dev/null
@@ -1,62 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-
-
-#ifndef _OSD_H_
-#define _OSD_H_
-
-#include <linux/kernel.h>
-#include <linux/workqueue.h>
-
-/* Defines */
-#define NUM_PAGES_SPANNED(addr, len)	((PAGE_ALIGN(addr + len) >> PAGE_SHIFT) - \
-					(addr >> PAGE_SHIFT))
-
-#define LOWORD(dw)	((unsigned short)(dw))
-#define HIWORD(dw)	((unsigned short)(((unsigned int) (dw) >> 16) & 0xFFFF))
-
-struct hv_guid {
-	unsigned char data[16];
-};
-
-struct osd_waitevent {
-	int condition;
-	wait_queue_head_t event;
-};
-
-/* Osd routines */
-
-extern void *osd_virtual_alloc_exec(unsigned int size);
-
-extern void *osd_page_alloc(unsigned int count);
-extern void osd_page_free(void *page, unsigned int count);
-
-extern struct osd_waitevent *osd_waitevent_create(void);
-extern void osd_waitevent_set(struct osd_waitevent *wait_event);
-extern int osd_waitevent_wait(struct osd_waitevent *wait_event);
-
-/* If >0, wait_event got signaled. If ==0, timeout. If < 0, error */
-extern int osd_waitevent_waitex(struct osd_waitevent *wait_event,
-			       u32 timeout_in_ms);
-
-#endif /* _OSD_H_ */
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 4d53392..66688fb 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include "osd.h"
 #include "logging.h"
 #include "ring_buffer.h"
 
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index e3bf004..9dde936 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -26,8 +26,8 @@
 #include <linux/io.h>
 #include <linux/if_ether.h>
 
-#include "osd.h"
 #include "logging.h"
+#include "hv_api.h"
 #include "netvsc_api.h"
 #include "rndis_filter.h"
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 2560342..e2ad729 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "storvsc_api.h"
 #include "vmbus_packet_format.h"
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 956c9eb..a8427ff 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -31,7 +31,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "version_info.h"
 #include "vmbus.h"
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index dacaa54..459c707 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include "version_info.h"
-#include "osd.h"
+#include "hv_api.h"
 #include "logging.h"
 #include "vmbus.h"
 #include "channel.h"
-- 
1.5.5.6

