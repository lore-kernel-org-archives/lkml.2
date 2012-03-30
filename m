Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936078Ab2C3V0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:26:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58046 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966237Ab2C3VWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:41 -0400
Message-Id: <20120330194847.971182042@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Ming Lei <tom.leiming@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 111/175] usbnet: increase URB reference count before usb_unlink_urb
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "tom.leiming@gmail.com" <tom.leiming@gmail.com>

commit 0956a8c20b23d429e79ff86d4325583fc06f9eb4 upstream.

Commit 4231d47e6fe69f061f96c98c30eaf9fb4c14b96d(net/usbnet: avoid
recursive locking in usbnet_stop()) fixes the recursive locking
problem by releasing the skb queue lock, but it makes usb_unlink_urb
racing with defer_bh, and the URB to being unlinked may be freed before
or during calling usb_unlink_urb, so use-after-free problem may be
triggerd inside usb_unlink_urb.

The patch fixes the use-after-free problem by increasing URB
reference count with skb queue lock held before calling
usb_unlink_urb, so the URB won't be freed until return from
usb_unlink_urb.

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/usbnet.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -589,6 +589,14 @@ static int unlink_urbs (struct usbnet *d
 		entry = (struct skb_data *) skb->cb;
 		urb = entry->urb;
 
+		/*
+		 * Get reference count of the URB to avoid it to be
+		 * freed during usb_unlink_urb, which may trigger
+		 * use-after-free problem inside usb_unlink_urb since
+		 * usb_unlink_urb is always racing with .complete
+		 * handler(include defer_bh).
+		 */
+		usb_get_urb(urb);
 		spin_unlock_irqrestore(&q->lock, flags);
 		// during some PM-driven resume scenarios,
 		// these (async) unlinks complete immediately
@@ -597,6 +605,7 @@ static int unlink_urbs (struct usbnet *d
 			netdev_dbg(dev->net, "unlink urb err, %d\n", retval);
 		else
 			count++;
+		usb_put_urb(urb);
 		spin_lock_irqsave(&q->lock, flags);
 	}
 	spin_unlock_irqrestore (&q->lock, flags);


