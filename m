Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0EVITs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:19:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:33806 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab0EVITl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:19:41 -0400
Date: Sat, 22 May 2010 10:19:36 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Joseph Chan <JosephChan@via.com.tw>, Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/27] drivers/video/via: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221019180.13021@ask.diku.dk>
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
 drivers/video/via/viafbdev.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 2bc40e6..1082541 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -578,14 +578,9 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		break;
 
 	case VIAFB_SET_GAMMA_LUT:
-		viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
-		if (!viafb_gamma_table)
-			return -ENOMEM;
-		if (copy_from_user(viafb_gamma_table, argp,
-				256 * sizeof(u32))) {
-			kfree(viafb_gamma_table);
-			return -EFAULT;
-		}
+		viafb_gamma_table = memdup_user(argp, 256 * sizeof(u32));
+		if (IS_ERR(viafb_gamma_table))
+			return PTR_ERR(viafb_gamma_table);
 		viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
 		kfree(viafb_gamma_table);
 		break;
