Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab1D0TVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:21:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61516 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907Ab1D0TVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bh+Z/AGeNP5roKRDDy79xZynPSaAU2lavgJQ72G3fWtfddFTWIvQEatbeBhB6TzwN1
         O1KB7d3g5wxOvB/qawCdQz2nx8fLkEFSt0oaQ8/X3uKjncaluddV4aADR9UaU5D2GYfX
         woDZ6uCorP0i/rkZTal4cdIiSmYYVhi5NIx1U=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 1/2] hwrng: manage resource allocation in amd driver
Date: Wed, 27 Apr 2011 23:21:15 +0400
Message-Id: <1303932076-7428-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As amd driver doesn't bind to PCI device, we'd better manage reource
allocation on our own to disallow (possible) conflicts.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/char/hw_random/amd-rng.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 0d8c578..c6af038 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -133,6 +133,12 @@ found:
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0)
 		goto out;
+	if (!request_region(pmbase + 0xF0, 8, "AMD HWRNG")) {
+		dev_err(&pdev->dev, "AMD HWRNG region 0x%x already in use!\n",
+			pmbase + 0xF0);
+		err = -EBUSY;
+		goto out;
+	}
 	amd_rng.priv = (unsigned long)pmbase;
 	amd_pdev = pdev;
 
@@ -141,6 +147,7 @@ found:
 	if (err) {
 		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
 		       err);
+		release_region(pmbase + 0xF0, 8);
 		goto out;
 	}
 out:
@@ -149,6 +156,8 @@ out:
 
 static void __exit mod_exit(void)
 {
+	u32 pmbase = (unsigned long)amd_rng.priv;
+	release_region(pmbase + 0xF0, 8);
 	hwrng_unregister(&amd_rng);
 }
 
-- 
1.7.4.4

