Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0J1PcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:32:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014Ab0J1PcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Ll0d66VEmhhfcNX61SS61TA9af9uP5MVQm0nBmUQF4MJvvwYjI8JR1o3xGaBIJLJ9V
         GPm+xzOie/dAcPjXdNFgsRO85OmnMKNWxGsVhCkEIZ8MK0gS8OL+2ykqwu4xKD88nVsh
         5CHT4v3Epw8+a5Vm3pHBABzFk+GIqWNX9bkVQ=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 4/7] USB: gadget: f_mass_storage: drop START_TRANSFER() macro
Date: Thu, 28 Oct 2010 17:31:21 +0200
Message-Id: <204661a3e3ee24a4a6dc68cc6db9f07de3bffe4c.1288256118.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
References: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit drops START_TRANSFER_OR() and START_TRANSFER()
macros with a pair of nice inline functions which are actually
more readable and easier to use.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |   49 +++++++++++++++++------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

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

