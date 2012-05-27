Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782Ab2E0BSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:18:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422761Ab2E0BR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:57 -0400
Message-Id: <20120527002518.233473197@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:58 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huajun Li <huajun.li.lee@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oncaphillis <oncaphillis@snafu.de>
Subject: [ 52/91] USB: Remove races in devio.c
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huajun Li <huajun.li.lee@gmail.com>

commit 4e09dcf20f7b5358615514c2ec8584b248ab8874 upstream.

There exist races in devio.c, below is one case,
and there are similar races in destroy_async()
and proc_unlinkurb().  Remove these races.

 cancel_bulk_urbs()        async_completed()
-------------------                -----------------------
 spin_unlock(&ps->lock);

                           list_move_tail(&as->asynclist,
		                    &ps->async_completed);

                           wake_up(&ps->wait);

                           Lead to free_async() be triggered,
                           then urb and 'as' will be freed.

 usb_unlink_urb(as->urb);
 ===> refer to the freed 'as'

Signed-off-by: Huajun Li <huajun.li.lee@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oncaphillis <oncaphillis@snafu.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -333,17 +333,14 @@ static struct async *async_getcompleted(
 static struct async *async_getpending(struct dev_state *ps,
 					     void __user *userurb)
 {
-	unsigned long flags;
 	struct async *as;
 
-	spin_lock_irqsave(&ps->lock, flags);
 	list_for_each_entry(as, &ps->async_pending, asynclist)
 		if (as->userurb == userurb) {
 			list_del_init(&as->asynclist);
-			spin_unlock_irqrestore(&ps->lock, flags);
 			return as;
 		}
-	spin_unlock_irqrestore(&ps->lock, flags);
+
 	return NULL;
 }
 
@@ -398,6 +395,7 @@ static void cancel_bulk_urbs(struct dev_
 __releases(ps->lock)
 __acquires(ps->lock)
 {
+	struct urb *urb;
 	struct async *as;
 
 	/* Mark all the pending URBs that match bulk_addr, up to but not
@@ -420,8 +418,11 @@ __acquires(ps->lock)
 	list_for_each_entry(as, &ps->async_pending, asynclist) {
 		if (as->bulk_status == AS_UNLINK) {
 			as->bulk_status = 0;		/* Only once */
+			urb = as->urb;
+			usb_get_urb(urb);
 			spin_unlock(&ps->lock);		/* Allow completions */
-			usb_unlink_urb(as->urb);
+			usb_unlink_urb(urb);
+			usb_put_urb(urb);
 			spin_lock(&ps->lock);
 			goto rescan;
 		}
@@ -472,6 +473,7 @@ static void async_completed(struct urb *
 
 static void destroy_async(struct dev_state *ps, struct list_head *list)
 {
+	struct urb *urb;
 	struct async *as;
 	unsigned long flags;
 
@@ -479,10 +481,13 @@ static void destroy_async(struct dev_sta
 	while (!list_empty(list)) {
 		as = list_entry(list->next, struct async, asynclist);
 		list_del_init(&as->asynclist);
+		urb = as->urb;
+		usb_get_urb(urb);
 
 		/* drop the spinlock so the completion handler can run */
 		spin_unlock_irqrestore(&ps->lock, flags);
-		usb_kill_urb(as->urb);
+		usb_kill_urb(urb);
+		usb_put_urb(urb);
 		spin_lock_irqsave(&ps->lock, flags);
 	}
 	spin_unlock_irqrestore(&ps->lock, flags);
@@ -1410,12 +1415,24 @@ static int proc_submiturb(struct dev_sta
 
 static int proc_unlinkurb(struct dev_state *ps, void __user *arg)
 {
+	struct urb *urb;
 	struct async *as;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ps->lock, flags);
 	as = async_getpending(ps, arg);
-	if (!as)
+	if (!as) {
+		spin_unlock_irqrestore(&ps->lock, flags);
 		return -EINVAL;
-	usb_kill_urb(as->urb);
+	}
+
+	urb = as->urb;
+	usb_get_urb(urb);
+	spin_unlock_irqrestore(&ps->lock, flags);
+
+	usb_kill_urb(urb);
+	usb_put_urb(urb);
+
 	return 0;
 }
 


