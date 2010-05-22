Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0EVIX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:23:57 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34946 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab0EVIXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:23:54 -0400
Date: Sat, 22 May 2010 10:23:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 18/27] drivers/message/i2o/i2o_config.c: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221023270.13021@ask.diku.dk>
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
 drivers/message/i2o/i2o_config.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index d33693c..c4b117f 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -186,14 +186,9 @@ static int i2o_cfg_parms(unsigned long arg, unsigned int type)
 	if (!dev)
 		return -ENXIO;
 
-	ops = kmalloc(kcmd.oplen, GFP_KERNEL);
-	if (!ops)
-		return -ENOMEM;
-
-	if (copy_from_user(ops, kcmd.opbuf, kcmd.oplen)) {
-		kfree(ops);
-		return -EFAULT;
-	}
+	ops = memdup_user(kcmd.opbuf, kcmd.oplen);
+	if (IS_ERR(ops))
+		return PTR_ERR(ops);
 
 	/*
 	 * It's possible to have a _very_ large table
