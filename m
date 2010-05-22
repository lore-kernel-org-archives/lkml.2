Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0EVI1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:27:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60808 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab0EVI1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:27:08 -0400
Date: Sat, 22 May 2010 10:27:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 27/27] drivers/staging/dream/camera: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221026430.13021@ask.diku.dk>
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
 drivers/staging/dream/camera/msm_vfe8x.c |   45 ++++++++-----------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/dream/camera/msm_vfe8x.c b/drivers/staging/dream/camera/msm_vfe8x.c
index e61fdba..d87d56f 100644
--- a/drivers/staging/dream/camera/msm_vfe8x.c
+++ b/drivers/staging/dream/camera/msm_vfe8x.c
@@ -644,17 +644,10 @@ static int vfe_config(struct msm_vfe_cfg_cmd *cmd, void *data)
 		if (!axid)
 			return -EFAULT;
 
-		axio =
-			kmalloc(sizeof(struct vfe_cmd_axi_output_config),
-				GFP_ATOMIC);
-		if (!axio)
-			return -ENOMEM;
-
-		if (copy_from_user(axio, (void __user *)(vfecmd.value),
-			sizeof(struct vfe_cmd_axi_output_config))) {
-			kfree(axio);
-			return -EFAULT;
-		}
+		axio = memdup_user((void __user *)(vfecmd.value),
+				   sizeof(struct vfe_cmd_axi_output_config));
+		if (IS_ERR(axio))
+			return PTR_ERR(axio);
 
 		vfe_config_axi(OUTPUT_1, axid, axio);
 		vfe_axi_output_config(axio);
@@ -669,17 +662,10 @@ static int vfe_config(struct msm_vfe_cfg_cmd *cmd, void *data)
 		if (!axid)
 			return -EFAULT;
 
-		axio =
-			kmalloc(sizeof(struct vfe_cmd_axi_output_config),
-				GFP_ATOMIC);
-		if (!axio)
-			return -ENOMEM;
-
-		if (copy_from_user(axio, (void __user *)(vfecmd.value),
-				sizeof(struct vfe_cmd_axi_output_config))) {
-			kfree(axio);
-			return -EFAULT;
-		}
+		axio = memdup_user((void __user *)(vfecmd.value),
+				   sizeof(struct vfe_cmd_axi_output_config));
+		if (IS_ERR(axio))
+			return PTR_ERR(axio);
 
 		vfe_config_axi(OUTPUT_2, axid, axio);
 
@@ -694,17 +680,10 @@ static int vfe_config(struct msm_vfe_cfg_cmd *cmd, void *data)
 		if (!axid)
 			return -EFAULT;
 
-		axio =
-			kmalloc(sizeof(struct vfe_cmd_axi_output_config),
-				GFP_ATOMIC);
-		if (!axio)
-			return -ENOMEM;
-
-		if (copy_from_user(axio, (void __user *)(vfecmd.value),
-			sizeof(struct vfe_cmd_axi_output_config))) {
-			kfree(axio);
-			return -EFAULT;
-		}
+		axio = memdup_user((void __user *)(vfecmd.value),
+				   sizeof(struct vfe_cmd_axi_output_config));
+		if (IS_ERR(axio))
+			return PTR_ERR(axio);
 
 		vfe_config_axi(OUTPUT_1_AND_2,
 			axid, axio);
