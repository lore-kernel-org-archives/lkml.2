Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757Ab0HFTxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:53:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46135 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965695Ab0HFTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m3bHeU5PNUUcBtj6OSEVeR7R9P8Ve7XfaGZ37GUkXIQTvh6xFZZKGrPLqPCkXZxkz/
         hEBnTSgGezTTEVT9x1sTk5w3lPhekWdnG8UAckIRPge1/6Yq0PI7aYE66Q5pEDXIRjjw
         OmLFYn+iP/rSCeMoICesKwcF5RQQPtK4TMHrs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Wu Zhangjin <wuzhangjin@gmail.com>,
        Patrick Rooney <candyguitar@googlemail.com>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] staging: sm7xx: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:53:23 +0400
Message-Id: <1281124405-13971-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/sm7xx/smtcfb.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index f6b401c..24f47d6 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -848,7 +848,6 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		"Silicon Motion display driver " SMTC_LINUX_FB_VERSION "\n");
 
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
-
 	if (err)
 		return err;
 	err = -ENOMEM;
@@ -859,7 +858,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	sfb = smtc_alloc_fb_info(pdev, name);
 
 	if (!sfb)
-		goto failed;
+		goto failed_free;
 	/* Jason (08/13/2009)
 	 * Store fb_info to be further used when suspending and resuming
 	 */
@@ -917,7 +916,8 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 			printk(KERN_INFO
 				"%s: unable to map memory mapped IO\n",
 				sfb->fb.fix.id);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto failed_fb;
 		}
 
 		/* set MCLK = 14.31818 * (0x16 / 0x2) */
@@ -951,8 +951,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		printk(KERN_INFO
 		"No valid Silicon Motion display chip was detected!\n");
 
-		smtc_free_fb_info(sfb);
-		return err;
+		goto failed_fb;
 	}
 
 	/* can support 32 bpp */
@@ -986,8 +985,12 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	smtc_unmap_smem(sfb);
 	smtc_unmap_mmio(sfb);
+failed_fb:
 	smtc_free_fb_info(sfb);
 
+failed_free:
+	pci_disable_device(pdev);
+
 	return err;
 }
 
-- 
1.7.0.4

