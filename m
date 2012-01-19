Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2ASXhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:37:53 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53473 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2ASXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:37:50 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>, Simon Glass <sjg@chromium.org>
Subject: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot time
Date: Thu, 19 Jan 2012 15:37:42 -0800
Message-Id: <1327016262-17957-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the boot to progress while USB is being probed - which
otherwise takes about 70ms per controller on my Tegra2 system.

It was mentioned some years ago in an email from Linus Torvalds:

https://lkml.org/lkml/2008/10/10/411

>  - they call usb_add_hcd, and usb_add_hcd is a horrible and slow
> piece of crap that doesn't just add the host controller, but does all
> the probing too.
>
> In other words, what should be fixed is not the initcall sequence,
> and certainly not make PCI device probing (or other random buses) be
> partly asynchronous, but simply make that USB host controller startup
> function be asynchronous.

It might be better to delay the work until much later unless USB is needed
for the root disk, but that might have to be a command line option.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/usb/core/hcd.c  |   75 +++++++++++++++++++++++++++++++++++++++-------
 drivers/usb/core/usb.c  |    5 +++
 include/linux/usb/hcd.h |    9 +++++
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index eb19cba..a201062 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -111,6 +111,9 @@ static DEFINE_SPINLOCK(hcd_urb_unlink_lock);
 /* wait queue for synchronous unlinks */
 DECLARE_WAIT_QUEUE_HEAD(usb_kill_urb_queue);
 
+/* work queue to handle reset and probing */
+static struct workqueue_struct *hcd_workq;
+
 static inline int is_root_hub(struct usb_device *udev)
 {
 	return (udev->parent == NULL);
@@ -2362,17 +2365,7 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 	return 0;
 }
 
-/**
- * usb_add_hcd - finish generic HCD structure initialization and register
- * @hcd: the usb_hcd structure to initialize
- * @irqnum: Interrupt line to allocate
- * @irqflags: Interrupt type flags
- *
- * Finish the remaining parts of generic HCD initialization: allocate the
- * buffers of consistent memory, register the bus, request the IRQ line,
- * and call the driver's reset() and start() routines.
- */
-int usb_add_hcd(struct usb_hcd *hcd,
+int usb_add_hcd_work(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags)
 {
 	int retval;
@@ -2517,7 +2510,50 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 	return retval;
-} 
+}
+
+/* This is the work function for usb_add_hcd() */
+void probe_hcd(struct work_struct *item)
+{
+	struct usb_hcd *hcd = container_of(item, struct usb_hcd,
+					   init_work.work);
+	int err;
+
+	err = usb_add_hcd_work(hcd, hcd->init_irqnum, hcd->init_irqflags);
+	if (err)
+		printk(KERN_ERR "probe_hcd failed with error %d\n", err);
+}
+
+/**
+ * usb_add_hcd - finish generic HCD structure initialization and register
+ * @hcd: the usb_hcd structure to initialize
+ * @irqnum: Interrupt line to allocate
+ * @irqflags: Interrupt type flags
+ *
+ * Finish the remaining parts of generic HCD initialization: allocate the
+ * buffers of consistent memory, register the bus, request the IRQ line,
+ * and call the driver's reset() and start() routines.
+ */
+int usb_add_hcd(struct usb_hcd *hcd,
+		unsigned int irqnum, unsigned long irqflags)
+{
+	/*
+	 * Perhaps we should have a pointer to an allocated structure since
+	 * these fields are not used after init.
+	 */
+	INIT_DELAYED_WORK(&hcd->init_work, probe_hcd);
+	hcd->init_irqnum = irqnum;
+	hcd->init_irqflags = irqflags;
+
+	/*
+	 * I'm sure we can't delay this by a second. Should we start it
+	 * immediately? Are we allowed to delay a little? Sometimes USB will
+	 * provide the root disk, so perhaps not.
+	 */
+	if (!queue_delayed_work(hcd_workq, &hcd->init_work, HZ))
+		return -ENOMEM;
+	return 0;
+}
 EXPORT_SYMBOL_GPL(usb_add_hcd);
 
 /**
@@ -2591,6 +2627,21 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+int usb_hcd_init(void)
+{
+	hcd_workq = alloc_workqueue("usb_hcd",
+				WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 1);
+	if (!hcd_workq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void usb_hcd_cleanup(void)
+{
+	destroy_workqueue(hcd_workq);
+}
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 8ca9f99..5e5b944 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1036,10 +1036,14 @@ static int __init usb_init(void)
 	retval = usb_hub_init();
 	if (retval)
 		goto hub_init_failed;
+	retval = usb_hcd_init();
+	if (retval)
+		goto hcd_init_failed;
 	retval = usb_register_device_driver(&usb_generic_driver, THIS_MODULE);
 	if (!retval)
 		goto out;
 
+hcd_init_failed:
 	usb_hub_cleanup();
 hub_init_failed:
 	usbfs_cleanup();
@@ -1069,6 +1073,7 @@ static void __exit usb_exit(void)
 		return;
 
 	usb_deregister_device_driver(&usb_generic_driver);
+	usb_hcd_cleanup();
 	usb_major_cleanup();
 	usbfs_cleanup();
 	usb_deregister(&usbfs_driver);
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index b2f62f3..49e445b 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -87,6 +87,9 @@ struct usb_hcd {
 #ifdef CONFIG_USB_SUSPEND
 	struct work_struct	wakeup_work;	/* for remote wakeup */
 #endif
+	struct delayed_work	init_work;	/* for initial init */
+	unsigned int		init_irqnum;	/* requested irqnum */
+	unsigned long		init_irqflags;	/* requested irq flags */
 
 	/*
 	 * hardware info/state
@@ -668,6 +671,12 @@ extern struct rw_semaphore ehci_cf_port_reset_rwsem;
 #define USB_EHCI_LOADED		2
 extern unsigned long usb_hcds_loaded;
 
+/* Initalise the HCD ready for use, Must be called before usb_add_hcd() */
+int usb_hcd_init(void);
+
+/* Clean up HCD */
+void usb_hcd_cleanup(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* __USB_CORE_HCD_H */
-- 
1.7.7.3

