Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab0HLAW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:22:56 -0400
Received: from kroah.org ([198.145.64.141]:60296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759583Ab0HLAEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:32 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000126.925577446@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Christian Lamparter <chunkeey@googlemail.com>
Subject: [40/54] USB: fix thread-unsafe anchor utiliy routines
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit b3e670443b7fb8a2d29831b62b44a039c283e351 upstream.

This patch fixes a race condition in two utility routines
related to the removal/unlinking of urbs from an anchor.

If two threads are concurrently accessing the same anchor,
both could end up with the same urb - thinking they are
the exclusive owner.

Alan Stern pointed out a related issue in
usb_unlink_anchored_urbs:

"The URB isn't removed from the anchor until it completes
 (as a by-product of completion, in fact), which might not
 be for quite some time after the unlink call returns.
 In the meantime, the subroutine will keep trying to unlink
 it, over and over again."

Cc: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/urb.c |   50 ++++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -137,6 +137,16 @@ void usb_anchor_urb(struct urb *urb, str
 }
 EXPORT_SYMBOL_GPL(usb_anchor_urb);
 
+/* Callers must hold anchor->lock */
+static void __usb_unanchor_urb(struct urb *urb, struct usb_anchor *anchor)
+{
+	urb->anchor = NULL;
+	list_del(&urb->anchor_list);
+	usb_put_urb(urb);
+	if (list_empty(&anchor->urb_list))
+		wake_up(&anchor->wait);
+}
+
 /**
  * usb_unanchor_urb - unanchors an URB
  * @urb: pointer to the urb to anchor
@@ -156,17 +166,14 @@ void usb_unanchor_urb(struct urb *urb)
 		return;
 
 	spin_lock_irqsave(&anchor->lock, flags);
-	if (unlikely(anchor != urb->anchor)) {
-		/* we've lost the race to another thread */
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		return;
-	}
-	urb->anchor = NULL;
-	list_del(&urb->anchor_list);
+	/*
+	 * At this point, we could be competing with another thread which
+	 * has the same intention. To protect the urb from being unanchored
+	 * twice, only the winner of the race gets the job.
+	 */
+	if (likely(anchor == urb->anchor))
+		__usb_unanchor_urb(urb, anchor);
 	spin_unlock_irqrestore(&anchor->lock, flags);
-	usb_put_urb(urb);
-	if (list_empty(&anchor->urb_list))
-		wake_up(&anchor->wait);
 }
 EXPORT_SYMBOL_GPL(usb_unanchor_urb);
 
@@ -750,20 +757,11 @@ EXPORT_SYMBOL_GPL(usb_unpoison_anchored_
 void usb_unlink_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
-	unsigned long flags;
 
-	spin_lock_irqsave(&anchor->lock, flags);
-	while (!list_empty(&anchor->urb_list)) {
-		victim = list_entry(anchor->urb_list.prev, struct urb,
-				    anchor_list);
-		usb_get_urb(victim);
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		/* this will unanchor the URB */
+	while ((victim = usb_get_from_anchor(anchor)) != NULL) {
 		usb_unlink_urb(victim);
 		usb_put_urb(victim);
-		spin_lock_irqsave(&anchor->lock, flags);
 	}
-	spin_unlock_irqrestore(&anchor->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_unlink_anchored_urbs);
 
@@ -800,12 +798,11 @@ struct urb *usb_get_from_anchor(struct u
 		victim = list_entry(anchor->urb_list.next, struct urb,
 				    anchor_list);
 		usb_get_urb(victim);
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		usb_unanchor_urb(victim);
+		__usb_unanchor_urb(victim, anchor);
 	} else {
-		spin_unlock_irqrestore(&anchor->lock, flags);
 		victim = NULL;
 	}
+	spin_unlock_irqrestore(&anchor->lock, flags);
 
 	return victim;
 }
@@ -827,12 +824,7 @@ void usb_scuttle_anchored_urbs(struct us
 	while (!list_empty(&anchor->urb_list)) {
 		victim = list_entry(anchor->urb_list.prev, struct urb,
 				    anchor_list);
-		usb_get_urb(victim);
-		spin_unlock_irqrestore(&anchor->lock, flags);
-		/* this may free the URB */
-		usb_unanchor_urb(victim);
-		usb_put_urb(victim);
-		spin_lock_irqsave(&anchor->lock, flags);
+		__usb_unanchor_urb(victim, anchor);
 	}
 	spin_unlock_irqrestore(&anchor->lock, flags);
 }


