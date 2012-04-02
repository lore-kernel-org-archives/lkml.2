Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2DBDi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 23:38:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:56923 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab2DBDi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:38:27 -0400
Message-ID: <1333337899.30734.31.camel@pasglop>
Subject: [PATCH] nouveau/bios: Fix tracking of BIOS image data
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: dri-devel@lists.freedesktop.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>
Date: Mon, 02 Apr 2012 13:38:19 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code tries various methods for retreiving the BIOS data. However
it doesn't clear the bios->data pointer between the iterations.

In some cases, the shadow() method will fail and not update bios->data
at all, which will cause us to "score" the old data and incorrectly
attribute that score to the new method. This can cause double frees
later when disposing of the unused data.

Additionally, we were not freeing the data for methods that fail the
score test (we only freed when a "best" is superseeded, not when the
new method has a lower score than the exising "best"). Fix that as well.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This was found by code inspection while chasing a different bug,
I do not hit the problem path on my machine.

 drivers/gpu/drm/nouveau/nouveau_bios.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 80963d0..1947d61 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -273,6 +273,7 @@ bios_shadow(struct drm_device *dev)
 		mthd->score = score_vbios(bios, mthd->rw);
 		mthd->size = bios->length;
 		mthd->data = bios->data;
+		bios->data = NULL;
 	} while (mthd->score != 3 && (++mthd)->shadow);
 
 	mthd = shadow_methods;
@@ -281,7 +282,8 @@ bios_shadow(struct drm_device *dev)
 		if (mthd->score > best->score) {
 			kfree(best->data);
 			best = mthd;
-		}
+		} else
+			kfree(mthd->data);
 	} while ((++mthd)->shadow);
 
 	if (best->score) {
-- 
1.7.9.5



