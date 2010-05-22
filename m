Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0EVIWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:22:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44712 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0EVIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:22:06 -0400
Date: Sat, 22 May 2010 10:22:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/27] drivers/ieee1394: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221021460.13021@ask.diku.dk>
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
 drivers/ieee1394/video1394.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/ieee1394/video1394.c b/drivers/ieee1394/video1394.c
index a42bd68..a77483b 100644
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -1045,14 +1045,9 @@ static long video1394_ioctl(struct file *file,
 			if (get_user(qv, &p->packet_sizes))
 				return -EFAULT;
 
-			psizes = kmalloc(buf_size, GFP_KERNEL);
-			if (!psizes)
-				return -ENOMEM;
-
-			if (copy_from_user(psizes, qv, buf_size)) {
-				kfree(psizes);
-				return -EFAULT;
-			}
+			psizes = memdup_user(qv, buf_size);
+			if (IS_ERR(psizes))
+				return PTR_ERR(psizes);
 		}
 
 		spin_lock_irqsave(&d->lock,flags);
