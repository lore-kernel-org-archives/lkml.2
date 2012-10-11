Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2JKVee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:34:34 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:46068 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2JKVec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:34:32 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhafAFc6d1BV5h1yPGdsb2JhbABEiky0BwR9GQEBAQEfGQ0ngiABAQQBJxMcEwEPBQsIAxEDAQIvFCUKDA4KCYd+CrlcFIszCSYDhQ5gA5VshXKNLoFY
X-IronPort-AV: E=Sophos;i="4.80,574,1344204000"; 
   d="scan'208";a="424996293"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 11 Oct 2012 23:37:07 +0200
To: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121011213707.GA2187@polaris.bitmath.org>
References: <20121010203118.GA792@polaris.bitmath.org>
 <5076819C.9010504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5076819C.9010504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

> Oh what fun (not). The best way to figure out what really is going
> on is to get some usb level traces. Note my first hunch is that what
> you're seeing is a device firmware bug, as this patch together with
> a new libusb (which you seem to also have) will make bulk transfers
> run slightly faster, which might be just enough to overwhelm your
> device ...

Or, the large bulk transfer actually never worked in the first place.
The list you gave me seemed boringly long, so I read the patch more
closely instead. The fix below is the result. Greg, will you please
take it through your tree?

Thanks,
Henrik

>From 40b70394747eea51fdd07cc8213dd6afd24b1b30 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Thu, 11 Oct 2012 23:27:04 +0200
Subject: [PATCH] usbdevfs: Fix broken scatter-gather transfer

The recently introduced handling of large bulk transfers is completely
broken; the same user page is read over and over again. Fixed with
this patch.

Cc: stable@kernel.org
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/usb/core/devio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index ebb8a9d..6e58b59 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1172,6 +1172,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	struct usb_ctrlrequest *dr = NULL;
 	unsigned int u, totlen, isofrmlen;
 	int i, ret, is_in, num_sgs = 0, ifnum = -1;
+	void __user *userbuf;
 	void *buf;
 
 	if (uurb->flags & ~(USBDEVFS_URB_ISO_ASAP |
@@ -1333,6 +1334,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		as->urb->num_sgs = num_sgs;
 		sg_init_table(as->urb->sg, as->urb->num_sgs);
 
+		userbuf = uurb->buffer;
 		totlen = uurb->buffer_length;
 		for (i = 0; i < as->urb->num_sgs; i++) {
 			u = (totlen > USB_SG_SIZE) ? USB_SG_SIZE : totlen;
@@ -1344,11 +1346,12 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			sg_set_buf(&as->urb->sg[i], buf, u);
 
 			if (!is_in) {
-				if (copy_from_user(buf, uurb->buffer, u)) {
+				if (copy_from_user(buf, userbuf, u)) {
 					ret = -EFAULT;
 					goto error;
 				}
 			}
+			userbuf += u;
 			totlen -= u;
 		}
 	} else if (uurb->buffer_length > 0) {
-- 
1.7.12.2

