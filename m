Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0EVIXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:23:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44734 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0EVIXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:23:31 -0400
Date: Sat, 22 May 2010 10:23:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 17/27] drivers/char/vt.c: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221023090.13021@ask.diku.dk>
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
 drivers/char/vt.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bd1d116..7cdb6ee 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -3967,13 +3967,9 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 	font.charcount = op->charcount;
 	font.height = op->height;
 	font.width = op->width;
-	font.data = kmalloc(size, GFP_KERNEL);
-	if (!font.data)
-		return -ENOMEM;
-	if (copy_from_user(font.data, op->data, size)) {
-		kfree(font.data);
-		return -EFAULT;
-	}
+	font.data = memdup_user(op->data, size);
+	if (IS_ERR(font.data))
+		return PTR_ERR(font.data);
 	acquire_console_sem();
 	if (vc->vc_sw->con_font_set)
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
