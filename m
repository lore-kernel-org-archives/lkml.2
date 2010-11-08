Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0KHPj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:39:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:57496 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0KHPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:39:26 -0500
Message-ID: <4CD81995.8060003@windriver.com>
Date: Mon, 08 Nov 2010 09:39:01 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, Alan Cox <alan@linux.intel.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC PATCH 1/5] usb-hcd: implement polling a specific usb device
References: <Pine.LNX.4.44L0.1011061422080.28403-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011061422080.28403-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Nov 2010 15:39:02.0779 (UTC) FILETIME=[11D00CB0:01CB7F5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 01:32 PM, Alan Stern wrote:
> On Fri, 5 Nov 2010, Jason Wessel wrote:
> 
>> This patch adds a generic capability to poll a specific usb device and
>> run its completion handler.
>>
>> @@ -1562,6 +1567,17 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
>>  
>>  	/* pass ownership to the completion handler */
>>  	urb->status = status;
>> +	if (unlikely(usb_poll_hcd_device)) {
>> +		/*
>> +		 * Any other device than the one being polled should get
>> +		 * queued for a later flush.
>> +		 */
>> +		if (usb_poll_hcd_device != urb->dev) {
>> +			INIT_LIST_HEAD(&urb->poll_list);
> 
> Why initialize the list_head here if the next line is going to 
> overwrite it?


Oops, I simply didn't know the list_add() obviated the need for
initialization.  Having now looked at the macro I see why.

> 
>> +			list_add(&urb->poll_list, &delayed_usb_complete_queue);
> 
> You need to use list_add_tail, not list_add.  This is supposed to be a 
> queue, not a LIFO stack.


Thanks for pointing that out.  All fixed.

>>  
>> +void usb_poll_irq(struct usb_device *udev)
>> +{
> 
> Please add a little kerneldoc explaining what this function does and 
> why it is here.  Also mention that it must be called with interrupts 
> disabled.


Sure.  I think it is also wise to put in: WARN_ON_ONCE(!irqs_disabled());


>> +static void usb_poll_irq_flush_helper(struct work_struct *dummy)
>> +{
>> +	struct urb *urb;
>> +	struct urb *scratch;
>> +	unsigned long flags;
>> +
>> +	mutex_lock(&usb_poll_irq_flush_mutex);
> 
> What is this mutex used for?


This mutex exists because I did not see a way to create a static
workqueue with the attribute WQ_NON_REENTRANT.  When the workqueue
does not have this attribute there is a corner case that between two
usb poll intervals (one being handled on cpu 0 and the next on cpu 1)
that you can get two units of work to run concurrently.

> 
>> +	local_irq_save(flags);
> 
> Isn't this function meant to be called with interrupts disabled on all 
> CPUs anyway?


The usb_poll_irq_flush_helper() is called from a work queue at some
point after the work had been originally been scheduled with the IRQ's
off.  We might be able to simply lock the HCD instead, but it looked
like the this code should really be called with the irq's off.  I came
to that conclusion based on looking at if the irqs were on or off in
the original context the HCD giveback was executed.

If you believe we don't need it, we'll simply remove the irq
save/restore.


>> +void usb_poll_irq_schedule_flush(void)
>> +{
>> +	schedule_work(&usb_poll_irq_flush_work);
>> +}
>> +EXPORT_SYMBOL_GPL(usb_poll_irq_schedule_flush);
> 
> Why do you want to do this in a workqueue?  Just move all the code from 
> usb_poll_irq_flush_helper over here directly.
> 


I want this in a work queue because we need to schedule this to run at
a later point when the interrupts are restored.  If I don't put the
code here, it has to get duplicated in the kdb keyboard stack, as well
as the usb serial console code.  The alternative is that we need a
logical place to drain the queue at another point in the kernel or a
timer.

The "schedule later via a workqueue" seemed the path of least
resistance.

You could argue that we might have a user of this API that would want
to flush the delayed urb queue in a safe place.  For now though, the
two users of the new poll API (kdb, and usb serial console) do not
need it and this leads me to believe we would be best served to not
export the flush helper.


> 
>> --- a/include/linux/usb.h
>> @@ -1188,6 +1192,7 @@ struct urb {
>> +	struct list_head poll_list;	/* Added to the poll queue */
> 
> You don't need to add an additional list_head to struct urb -- it
> already contains too much stuff.  Simply use urb_list; that's what it's
> for.
> 


It looked to me like it might have already been used when I was
sifting through the other code in drivers/usb/*, but if you say it is
safe, I trust you.  :-)

A new copy of the patch is included below.

Jason.

---
 drivers/usb/core/hcd.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb.h    |    4 ++
 2 files changed, 79 insertions(+)

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
@@ -1528,6 +1532,7 @@ int usb_hcd_unlink_urb (struct urb *urb,
 }
 
 /*-------------------------------------------------------------------------*/
+static DEFINE_MUTEX(usb_poll_irq_flush_mutex);
 
 /**
  * usb_hcd_giveback_urb - return URB from HCD to device driver
@@ -1562,6 +1567,16 @@ void usb_hcd_giveback_urb(struct usb_hcd
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
+	if (unlikely(usb_poll_hcd_device)) {
+		/*
+		 * Any other device than the one being polled should get
+		 * queued for a later flush.
+		 */
+		if (usb_poll_hcd_device != urb->dev) {
+			list_add_tail(&urb->urb_list, &delayed_usb_complete_queue);
+			return;
+		}
+	}
 	urb->complete (urb);
 	atomic_dec (&urb->use_count);
 	if (unlikely(atomic_read(&urb->reject)))
@@ -2425,6 +2440,66 @@ usb_hcd_platform_shutdown(struct platfor
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+/**
+ * usb_poll_irq - run HCD to call all urb->complete's for a usb device
+ * @udev: The usb device to poll
+ *
+ * The intent of this function is to run the completion handlers for
+ * any urbs for the specified usb device.  Any other devices will have
+ * the urb completions queued to be run at a later point.  Any user of
+ * this function needs call usb_poll_irq_schedule_flush() at a later
+ * point to schedule the processing of the queue.  This function MUST
+ * be called with the interrupts off.
+ */
+void usb_poll_irq(struct usb_device *udev)
+{
+	struct usb_hcd *hcd;
+
+	WARN_ON_ONCE(!irqs_disabled());
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
+	WARN_ON_ONCE(!irqs_disabled());
+	mutex_lock(&usb_poll_irq_flush_mutex);
+	local_irq_save(flags);
+	list_for_each_entry_safe(urb, scratch, &delayed_usb_complete_queue,
+				 urb_list) {
+		list_del(&urb->urb_list);
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
+/**
+ * usb_poll_irq_sechedule_flush()
+ *
+ * For any function that invoked usb_poll_irq() this function needs to
+ * be called to schedule the draining of the urb completion queue in
+ * order to restore normal processing of the usb devices.
+ */
+void usb_poll_irq_schedule_flush(void)
+{
+	schedule_work(&usb_poll_irq_flush_work);
+}
+EXPORT_SYMBOL_GPL(usb_poll_irq_schedule_flush);
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -558,6 +558,10 @@ static inline void usb_mark_last_busy(st
 
 /*-------------------------------------------------------------------------*/
 
+/* for polling the hcd device */
+extern void usb_poll_irq(struct usb_device *udev);
+extern void usb_poll_irq_schedule_flush(void);
+
 /* for drivers using iso endpoints */
 extern int usb_get_current_frame_number(struct usb_device *usb_dev);
 
