Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0E0QKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:10:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53745 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0E0QKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:10:14 -0400
Date: Thu, 27 May 2010 18:10:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Vrabel <david.vrabel@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/usb/host: Eliminate NULL dereference
Message-ID: <Pine.LNX.4.64.1005271809090.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The test above allows std to be NULL, so check that std is not NULL before
doing the dereference.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff --git a/drivers/usb/host/whci/qset.c b/drivers/usb/host/whci/qset.c
index ab5a14f..dc0ab83 100644
--- a/drivers/usb/host/whci/qset.c
+++ b/drivers/usb/host/whci/qset.c
@@ -475,7 +475,7 @@ static int qset_add_urb_sg(struct whc *whc, struct whc_qset *qset, struct urb *u
 			    || (prev_end & (WHCI_PAGE_SIZE-1))
 			    || (dma_addr & (WHCI_PAGE_SIZE-1))
 			    || std->len + WHCI_PAGE_SIZE > QTD_MAX_XFER_SIZE) {
-				if (std->len % qset->max_packet != 0)
+				if (std && std->len % qset->max_packet != 0)
 					return -EINVAL;
 				std = qset_new_std(whc, qset, urb, mem_flags);
 				if (std == NULL) {
