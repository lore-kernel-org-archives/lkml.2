Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab1CZAIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:08:19 -0400
Received: from kroah.org ([198.145.64.141]:35949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455Ab1CZAGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:59 2011
Message-Id: <20110326000458.978778682@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:04:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [30/35] USB: cdc-acm: fix potential null-pointer dereference on disconnect
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7e7797e7f6f7bfab73fca02c65e40eaa5bb9000c upstream.

Fix potential null-pointer exception on disconnect introduced by commit
11ea859d64b69a747d6b060b9ed1520eab1161fe (USB: additional power savings
for cdc-acm devices that support remote wakeup).

Only access acm->dev after making sure it is non-null in control urb
completion handler.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -297,6 +297,8 @@ static void acm_ctrl_irq(struct urb *urb
 	if (!ACM_READY(acm))
 		goto exit;
 
+	usb_mark_last_busy(acm->dev);
+
 	data = (unsigned char *)(dr + 1);
 	switch (dr->bNotificationType) {
 	case USB_CDC_NOTIFY_NETWORK_CONNECTION:
@@ -336,7 +338,6 @@ static void acm_ctrl_irq(struct urb *urb
 		break;
 	}
 exit:
-	usb_mark_last_busy(acm->dev);
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&urb->dev->dev, "%s - usb_submit_urb failed with "


