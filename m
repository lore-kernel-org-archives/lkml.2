Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1CWXAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:00:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26293 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1CWXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:00:45 -0400
Date: Thu, 24 Mar 2011 00:00:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org,
        James.Bottomley@suse.de
Subject: [PATCH][RESEND] SCSI, Brocade FC HBA: Remember to always release_firmware()
 so we don't leak memory. 
Message-ID: <alpine.LNX.2.00.1103232356510.28372@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we've called request_firmware() we must remember to call
release_firmware() to free memory. We don't currently do this in
bfad_read_firmware(); causing a memory leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Jing Huang <huangj@brocade.com>
---
 bfad.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

 Could someone merge this please?

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 44524cf..d7bafeb 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1558,23 +1558,22 @@ bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
 
 	if (request_firmware(&fw, fw_name, &pdev->dev)) {
 		printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
-		goto error;
+		*bfi_image = NULL;
+		goto out;
 	}
 
 	*bfi_image = vmalloc(fw->size);
 	if (NULL == *bfi_image) {
 		printk(KERN_ALERT "Fail to allocate buffer for fw image "
 			"size=%x!\n", (u32) fw->size);
-		goto error;
+		goto out;
 	}
 
 	memcpy(*bfi_image, fw->data, fw->size);
 	*bfi_image_size = fw->size/sizeof(u32);
-
+out:
+	release_firmware(fw);
 	return *bfi_image;
-
-error:
-	return NULL;
 }
 
 u32 *


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

