Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0KETFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:05:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:46559 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0KETFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:05:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: stern@rowland.harvard.edu
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: [RFC PATCH 1/5] usb-hcd: implement polling a specific usb device
Date: Fri,  5 Nov 2010 14:05:02 -0500
Message-Id: <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
References: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Nov 2010 19:05:15.0620 (UTC) FILETIME=[615C8240:01CB7D1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a generic capability to poll a specific usb device and
run its completion handler.

There will be two users of this functionality.
 1) usb serial port console devices
 2) usb keyboards for use with kdb

Any time the usb_irq_poll() function is called it has the possibility
to queue some urbs for completion at a later time.  Any code that uses
the usb_irq_poll() function must call usb_poll_irq_schedule_flush()
before all the other usb devices will start working again.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/core/hcd.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb.h    |    5 ++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 61800f7..2e07097 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -96,6 +96,10 @@ struct usb_busmap {
 };
 static struct usb_busmap busmap;
 
+/* Support polling for a single device's urbs */
+static struct usb_device *usb_poll_hcd_device;
+static LIST_HEAD(delayed_usb_complete_queue);
+
 /* used when updating list of hcds */
 DEFINE_MUTEX(usb_bus_list_lock);	/* exported only for usbfs */
 EXPORT_SYMBOL_GPL (usb_bus_list_lock);
@@ -1528,6 +1532,7 @@ int usb_hcd_unlink_urb (struct urb *urb, int status)
 }
 
 /*-------------------------------------------------------------------------*/
+static DEFINE_MUTEX(usb_poll_irq_flush_mutex);
 
 /**
  * usb_hcd_giveback_urb - return URB from HCD to device driver
@@ -1562,6 +1567,17 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
+	if (unlikely(usb_poll_hcd_device)) {
+		/*
+		 * Any other device than the one being polled should get
+		 * queued for a later flush.
+		 */
+		if (usb_poll_hcd_device != urb->dev) {
+			INIT_LIST_HEAD(&urb->poll_list);
+			list_add(&urb->poll_list, &delayed_usb_complete_queue);
+			return;
+		}
+	}
 	urb->complete (urb);
 	atomic_dec (&urb->use_count);
 	if (unlikely(atomic_read(&urb->reject)))
@@ -2425,6 +2441,47 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+void usb_poll_irq(struct usb_device *udev)
+{
+	struct usb_hcd *hcd;
+
+	hcd = bus_to_hcd(udev->bus);
+	usb_poll_hcd_device = udev;
+	usb_hcd_irq(0, hcd);
+	usb_poll_hcd_device = NULL;
+}
+EXPORT_SYMBOL_GPL(usb_poll_irq);
+
+static void usb_poll_irq_flush_helper(struct work_struct *dummy)
+{
+	struct urb *urb;
+	struct urb *scratch;
+	unsigned long flags;
+
+	mutex_lock(&usb_poll_irq_flush_mutex);
+	local_irq_save(flags);
+	list_for_each_entry_safe(urb, scratch, &delayed_usb_complete_queue,
+				 poll_list) {
+		list_del(&urb->poll_list);
+		urb->complete(urb);
+		atomic_dec(&urb->use_count);
+		if (unlikely(atomic_read(&urb->reject)))
+			wake_up(&usb_kill_urb_queue);
+		usb_put_urb(urb);
+	}
+	local_irq_restore(flags);
+	mutex_unlock(&usb_poll_irq_flush_mutex);
+}
+
+static DECLARE_WORK(usb_poll_irq_flush_work, usb_poll_irq_flush_helper);
+
+
+void usb_poll_irq_schedule_flush(void)
+{
+	schedule_work(&usb_poll_irq_flush_work);
+}
+EXPORT_SYMBOL_GPL(usb_poll_irq_schedule_flush);
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 35fe6ab..47ab24e 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -558,6 +558,10 @@ static inline void usb_mark_last_busy(struct usb_device *udev)
 
 /*-------------------------------------------------------------------------*/
 
+/* for polling the hcd device */
+extern void usb_poll_irq(struct usb_device *udev);
+extern void usb_poll_irq_schedule_flush(void);
+
 /* for drivers using iso endpoints */
 extern int usb_get_current_frame_number(struct usb_device *usb_dev);
 
@@ -1188,6 +1192,7 @@ struct urb {
 	struct list_head urb_list;	/* list head for use by the urb's
 					 * current owner */
 	struct list_head anchor_list;	/* the URB may be anchored */
+	struct list_head poll_list;	/* Added to the poll queue */
 	struct usb_anchor *anchor;
 	struct usb_device *dev;		/* (in) pointer to associated device */
 	struct usb_host_endpoint *ep;	/* (internal) pointer to endpoint */
-- 
1.6.3.3

