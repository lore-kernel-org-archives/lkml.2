Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0EZP7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:59:19 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46369 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0EZP7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:59:16 -0400
Date: Wed, 26 May 2010 17:59:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 16/17] drivers/staging/vme/bridges: Add missing unlocks
Message-ID: <Pine.LNX.4.64.1005261758540.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock and mutex_unlock missing on the error path.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 0c82eb4..f38f7b7 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -900,7 +900,8 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	/* Address must be 4-byte aligned */
 	if (pci_addr & 0x3) {
 		dev_err(dev, "RMW Address not 4-byte aligned\n");
-		return -EINVAL;
+		result = -EINVAL;
+		goto out;
 	}
 
 	/* Ensure RMW Disabled whilst configuring */
@@ -921,6 +922,7 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	/* Disable RMW */
 	iowrite32(0, bridge->base + SCYC_CTL);
 
+out:
 	spin_unlock(&(image->lock));
 
 	mutex_unlock(&(bridge->vme_rmw));
