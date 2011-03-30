Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248Ab1C3VJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965220Ab1C3VJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238878"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jhovold@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [238/275] USB: cdc-acm: fix potential null-pointer dereference on disconnect
Message-Id: <20110330210804.497AD3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/class/cdc-acm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/class/cdc-acm.c	2011-03-29 23:03:03.154219461 -0700
+++ linux-2.6.35.y/drivers/usb/class/cdc-acm.c	2011-03-29 23:03:03.173218975 -0700
@@ -297,6 +297,8 @@
 	if (!ACM_READY(acm))
 		goto exit;
 
+	usb_mark_last_busy(acm->dev);
+
 	data = (unsigned char *)(dr + 1);
 	switch (dr->bNotificationType) {
 	case USB_CDC_NOTIFY_NETWORK_CONNECTION:
@@ -336,7 +338,6 @@
 		break;
 	}
 exit:
-	usb_mark_last_busy(acm->dev);
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&urb->dev->dev, "%s - usb_submit_urb failed with "
