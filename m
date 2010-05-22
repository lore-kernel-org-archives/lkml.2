Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0EVIXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:23:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44730 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0EVIXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:23:13 -0400
Date: Sat, 22 May 2010 10:23:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 16/27] drivers/char/applicom.c: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221022500.13021@ask.diku.dk>
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
 drivers/char/applicom.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 63313a3..f4ae0e0 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -703,14 +703,9 @@ static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	/* In general, the device is only openable by root anyway, so we're not
 	   particularly concerned that bogus ioctls can flood the console. */
 
-	adgl = kmalloc(sizeof(struct st_ram_io), GFP_KERNEL);
-	if (!adgl)
-		return -ENOMEM;
-
-	if (copy_from_user(adgl, argp, sizeof(struct st_ram_io))) {
-		kfree(adgl);
-		return -EFAULT;
-	}
+	adgl = memdup_user(argp, sizeof(struct st_ram_io));
+	if (IS_ERR(adgl))
+		return PTR_ERR(adgl);
 
 	lock_kernel();	
 	IndexCard = adgl->num_card-1;
