Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1CJCpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:45:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1CJCoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tJIZApSeQ5GRKIzLIRJ8/pq5yck5F9HezNxOqfO7oG/p3KvFWXR+Qro0Zs2lKF8m+U
         xrzhv5lUtOG616hrNoM/E6hCXMwSBDbOBjeF+FHkc0hBaGa3tEubVC9PSvrFJhEd3ece
         WjSNSqO5eqv9TjAzVjAXujoRjJgbFQQ97hxyA=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 3/6] staging: brcm80211: fix memory leaks
Date: Thu, 10 Mar 2011 05:43:05 +0300
Message-Id: <1299724988-25351-3-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
References: <1299724988-25351-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free resources before exit.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index b74b3c6..28bc553 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -5649,6 +5649,10 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 		unsigned char *ularray;
 
 		ularray = kmalloc(bus->ramsize, GFP_ATOMIC);
+		if (!ularray) {
+			bcmerror = BCME_NOMEM;
+			goto err;
+		}
 		/* Upload image to verify downloaded contents. */
 		offset = 0;
 		memset(ularray, 0xaa, bus->ramsize);
@@ -5660,7 +5664,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 				DHD_ERROR(("%s: error %d on reading %d membytes"
 					" at 0x%08x\n",
 					__func__, bcmerror, MEMBLOCK, offset));
-				goto err;
+				goto free;
 			}
 
 			offset += MEMBLOCK;
@@ -5674,7 +5678,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 				DHD_ERROR(("%s: error %d on reading %d membytes at 0x%08x\n",
 				__func__, bcmerror,
 				sizeof(dlarray) - offset, offset));
-				goto err;
+				goto free;
 			}
 		}
 
@@ -5682,11 +5686,11 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 			DHD_ERROR(("%s: Downloaded image is corrupted.\n",
 				   __func__));
 			ASSERT(0);
-			goto err;
+			goto free;
 		} else
 			DHD_ERROR(("%s: Download/Upload/Compare succeeded.\n",
 				__func__));
-
+free:
 		kfree(ularray);
 	}
 #endif				/* DHD_DEBUG */
-- 
1.7.4.1

