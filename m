Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0EVIUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:20:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:60291 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0EVIUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:20:49 -0400
Date: Sat, 22 May 2010 10:20:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Chirag Kantharia <chirag.kantharia@hp.com>, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/27] drivers/block: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221020260.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.  Some checkpatch cleanups in nearby code.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/block/cpqarray.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 91d1163..7e40462 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1225,17 +1225,11 @@ static int ida_ctlr_ioctl(ctlr_info_t *h, int dsk, ida_ioctl_t *io)
 	/* Pre submit processing */
 	switch(io->cmd) {
 	case PASSTHRU_A:
-		p = kmalloc(io->sg[0].size, GFP_KERNEL);
-		if (!p) 
-		{ 
-			error = -ENOMEM; 
-			cmd_free(h, c, 0); 
-			return(error);
-		}
-		if (copy_from_user(p, io->sg[0].addr, io->sg[0].size)) {
-			kfree(p);
-			cmd_free(h, c, 0); 
-			return -EFAULT;
+		p = memdup_user(io->sg[0].addr, io->sg[0].size);
+		if (IS_ERR(p)) {
+			error = PTR_ERR(p);
+			cmd_free(h, c, 0);
+			return error;
 		}
 		c->req.hdr.blk = pci_map_single(h->pci_dev, &(io->c), 
 				sizeof(ida_ioctl_t), 
@@ -1266,18 +1260,12 @@ static int ida_ctlr_ioctl(ctlr_info_t *h, int dsk, ida_ioctl_t *io)
 	case DIAG_PASS_THRU:
 	case COLLECT_BUFFER:
 	case WRITE_FLASH_ROM:
-		p = kmalloc(io->sg[0].size, GFP_KERNEL);
-		if (!p) 
- 		{ 
-                        error = -ENOMEM; 
-                        cmd_free(h, c, 0);
-                        return(error);
+		p = memdup_user(io->sg[0].addr, io->sg[0].size);
+		if (IS_ERR(p)) {
+			error = PTR_ERR(p);
+			cmd_free(h, c, 0);
+			return error;
                 }
-		if (copy_from_user(p, io->sg[0].addr, io->sg[0].size)) {
-			kfree(p);
-                        cmd_free(h, c, 0);
-			return -EFAULT;
-		}
 		c->req.sg[0].size = io->sg[0].size;
 		c->req.sg[0].addr = pci_map_single(h->pci_dev, p, 
 			c->req.sg[0].size, PCI_DMA_BIDIRECTIONAL); 
