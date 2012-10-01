Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab2JAXDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:46 -0400
Received: from 1wt.eu ([62.212.114.60]:35683 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2JAXDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:44 -0400
Message-Id: <20121001225158.929563132@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Ming Lei <tom.leiming@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 031/180] usbnet: increase URB reference count before usb_unlink_urb
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: tom.leiming@gmail.com <tom.leiming@gmail.com>

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

Cc: stable@kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/usb/usbnet.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index da33dce..a92a415 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -584,6 +584,14 @@ static int unlink_urbs (struct usbnet *dev, struct sk_buff_head *q)
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
@@ -592,6 +600,7 @@ static int unlink_urbs (struct usbnet *dev, struct sk_buff_head *q)
 			devdbg (dev, "unlink urb err, %d", retval);
 		else
 			count++;
+		usb_put_urb(urb);
 		spin_lock_irqsave(&q->lock, flags);
 	}
 	spin_unlock_irqrestore (&q->lock, flags);
-- 
1.7.2.1.45.g54fbc



