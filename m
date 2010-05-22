Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0EVIXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:23:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44724 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0EVIWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:22:55 -0400
Date: Sat, 22 May 2010 10:22:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/27] drivers/mtd: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221022350.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

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
 drivers/mtd/mtdchar.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 000d65e..91c8013 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -404,14 +404,9 @@ static int mtd_do_writeoob(struct file *file, struct mtd_info *mtd,
 	if (ops.ooboffs && ops.ooblen > (mtd->oobsize - ops.ooboffs))
 		return -EINVAL;
 
-	ops.oobbuf = kmalloc(length, GFP_KERNEL);
-	if (!ops.oobbuf)
-		return -ENOMEM;
-
-	if (copy_from_user(ops.oobbuf, ptr, length)) {
-		kfree(ops.oobbuf);
-		return -EFAULT;
-	}
+	ops.oobbuf = memdup_user(ptr, length);
+	if (IS_ERR(ops.oobbuf))
+		return PTR_ERR(ops.oobbuf);
 
 	start &= ~((uint64_t)mtd->oobsize - 1);
 	ret = mtd->write_oob(mtd, start, &ops);
