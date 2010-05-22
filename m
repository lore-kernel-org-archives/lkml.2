Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab0EVIY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:24:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44742 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab0EVIY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:24:26 -0400
Date: Sat, 22 May 2010 10:24:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 19/27] drivers/telephony/ixj.c: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221023490.13021@ask.diku.dk>
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
 drivers/telephony/ixj.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index e89304c..b53deee 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -5879,20 +5879,13 @@ out:
 static int ixj_build_filter_cadence(IXJ *j, IXJ_FILTER_CADENCE __user * cp)
 {
 	IXJ_FILTER_CADENCE *lcp;
-	lcp = kmalloc(sizeof(IXJ_FILTER_CADENCE), GFP_KERNEL);
-	if (lcp == NULL) {
+	lcp = memdup_user(cp, sizeof(IXJ_FILTER_CADENCE));
+	if (IS_ERR(lcp)) {
 		if(ixjdebug & 0x0001) {
-			printk(KERN_INFO "Could not allocate memory for cadence\n");
+			printk(KERN_INFO "Could not allocate memory for cadence or could not copy cadence to kernel\n");
 		}
-		return -ENOMEM;
+		return PTR_ERR(lcp);
         }
-	if (copy_from_user(lcp, cp, sizeof(IXJ_FILTER_CADENCE))) {
-		if(ixjdebug & 0x0001) {
-			printk(KERN_INFO "Could not copy cadence to kernel\n");
-		}
-		kfree(lcp);
-		return -EFAULT;
-	}
 	if (lcp->filter > 5) {
 		if(ixjdebug & 0x0001) {
 			printk(KERN_INFO "Cadence out of range\n");
