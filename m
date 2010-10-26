Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab0JZNiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:38:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41748 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab0JZNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:36:46 -0400
Date: Tue, 26 Oct 2010 15:38:55 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 4/7] USB: gadget: f_mass_storage: drop START_TRANSFER() macro
In-reply-to: <e4d7faa839773178984edc8e17cffed7b44e1411.1288099890.git.m.nazarewicz@samsung.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <1fb12ac8cc8a5dfd642353eaf4a5e8ba3e868baa.1288099890.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <7214986593243afb11434ddb86da7e0460dc1f51.1288099890.git.m.nazarewicz@samsung.com>
 <4a6e11ec91ee592689f553dc69df515b4302691b.1288099890.git.m.nazarewicz@samsung.com>
 <e4d7faa839773178984edc8e17cffed7b44e1411.1288099890.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit drops START_TRANSFER_OR() and START_TRANSFER()
macros with a pair of nice inline functions which are actually
more readable and easier to use.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |   49 +++++++++++++++++------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

Honestly...  I don't know what I was thinking when I wrote those horrible
macros...

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 2a4aca1..c71f69f 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -692,16 +692,23 @@ static void start_transfer(struct fsg_dev *fsg, struct usb_ep *ep,
 	}
 }
 
-#define START_TRANSFER_OR(common, ep_name, req, pbusy, state)		\
-	if (fsg_is_set(common))						\
-		start_transfer((common)->fsg, (common)->fsg->ep_name,	\
-			       req, pbusy, state);			\
-	else
-
-#define START_TRANSFER(common, ep_name, req, pbusy, state)		\
-	START_TRANSFER_OR(common, ep_name, req, pbusy, state) (void)0
-
+static bool start_in_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
+{
+	if (!fsg_is_set(common))
+		return false;
+	start_transfer(common->fsg, common->fsg->bulk_in,
+		       bh->inreq, &bh->inreq_busy, &bh->state);
+	return true;
+}
 
+static bool start_out_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
+{
+	if (!fsg_is_set(common))
+		return false;
+	start_transfer(common->fsg, common->fsg->bulk_out,
+		       bh->outreq, &bh->outreq_busy, &bh->state);
+	return true;
+}
 
 static int sleep_thread(struct fsg_common *common)
 {
@@ -842,10 +849,8 @@ static int do_read(struct fsg_common *common)
 
 		/* Send this buffer and go read some more */
 		bh->inreq->zero = 0;
-		START_TRANSFER_OR(common, bulk_in, bh->inreq,
-			       &bh->inreq_busy, &bh->state)
-			/* Don't know what to do if
-			 * common->fsg is NULL */
+		if (!start_in_transfer(common, bh))
+			/* Don't know what to do if common->fsg is NULL */
 			return -EIO;
 		common->next_buffhd_to_fill = bh->next;
 	}
@@ -961,8 +966,7 @@ static int do_write(struct fsg_common *common)
 			bh->outreq->length = amount;
 			bh->bulk_out_intended_length = amount;
 			bh->outreq->short_not_ok = 1;
-			START_TRANSFER_OR(common, bulk_out, bh->outreq,
-					  &bh->outreq_busy, &bh->state)
+			if (!start_out_transfer(common, bh))
 				/* Don't know what to do if
 				 * common->fsg is NULL */
 				return -EIO;
@@ -1636,8 +1640,7 @@ static int throw_away_data(struct fsg_common *common)
 			bh->outreq->length = amount;
 			bh->bulk_out_intended_length = amount;
 			bh->outreq->short_not_ok = 1;
-			START_TRANSFER_OR(common, bulk_out, bh->outreq,
-					  &bh->outreq_busy, &bh->state)
+			if (!start_out_transfer(common, bh))
 				/* Don't know what to do if
 				 * common->fsg is NULL */
 				return -EIO;
@@ -1688,8 +1691,7 @@ static int finish_reply(struct fsg_common *common)
 		/* If there's no residue, simply send the last buffer */
 		} else if (common->residue == 0) {
 			bh->inreq->zero = 0;
-			START_TRANSFER_OR(common, bulk_in, bh->inreq,
-					  &bh->inreq_busy, &bh->state)
+			if (!start_in_transfer(common, bh))
 				return -EIO;
 			common->next_buffhd_to_fill = bh->next;
 
@@ -1698,8 +1700,7 @@ static int finish_reply(struct fsg_common *common)
 		 * stall, pad out the remaining data with 0's. */
 		} else if (common->can_stall) {
 			bh->inreq->zero = 1;
-			START_TRANSFER_OR(common, bulk_in, bh->inreq,
-					  &bh->inreq_busy, &bh->state)
+			if (!start_in_transfer(common, bh))
 				/* Don't know what to do if
 				 * common->fsg is NULL */
 				rc = -EIO;
@@ -1798,8 +1799,7 @@ static int send_status(struct fsg_common *common)
 
 	bh->inreq->length = USB_BULK_CS_WRAP_LEN;
 	bh->inreq->zero = 0;
-	START_TRANSFER_OR(common, bulk_in, bh->inreq,
-			  &bh->inreq_busy, &bh->state)
+	if (!start_in_transfer(common, bh))
 		/* Don't know what to do if common->fsg is NULL */
 		return -EIO;
 
@@ -2287,8 +2287,7 @@ static int get_next_command(struct fsg_common *common)
 	/* Queue a request to read a Bulk-only CBW */
 	set_bulk_out_req_length(common, bh, USB_BULK_CB_WRAP_LEN);
 	bh->outreq->short_not_ok = 1;
-	START_TRANSFER_OR(common, bulk_out, bh->outreq,
-			  &bh->outreq_busy, &bh->state)
+	if (!start_out_transfer(common, bh))
 		/* Don't know what to do if common->fsg is NULL */
 		return -EIO;
 
-- 
1.7.1

