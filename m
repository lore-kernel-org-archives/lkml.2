Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab2E1DeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:34:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52138 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab2E1D3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:48 -0400
Message-Id: <20120528031211.849807410@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huajun Li <huajun.li.lee@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oncaphillis <oncaphillis@snafu.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 065/117] USB: Remove races in devio.c
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/devio.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index c4a1af8..e0f1079 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -333,17 +333,14 @@ static struct async *async_getcompleted(struct dev_state *ps)
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
 
@@ -398,6 +395,7 @@ static void cancel_bulk_urbs(struct dev_state *ps, unsigned bulk_addr)
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
@@ -472,6 +473,7 @@ static void async_completed(struct urb *urb)
 
 static void destroy_async(struct dev_state *ps, struct list_head *list)
 {
+	struct urb *urb;
 	struct async *as;
 	unsigned long flags;
 
@@ -479,10 +481,13 @@ static void destroy_async(struct dev_state *ps, struct list_head *list)
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
@@ -1399,12 +1404,24 @@ static int proc_submiturb(struct dev_state *ps, void __user *arg)
 
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
 


