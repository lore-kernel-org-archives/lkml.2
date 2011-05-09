Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1EIPX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:23:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37200 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752458Ab1EIPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:23:55 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 2/2] gma500: Fix dumb create crash
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 09 May 2011 16:04:45 +0100
Message-ID: <20110509150437.28865.72860.stgit@localhost.localdomain>
In-Reply-To: <20110509150334.28865.25665.stgit@localhost.localdomain>
References: <20110509150334.28865.25665.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error path from gtt_alloc returns NULL not a ptr error. The underlying
fail is caused by a bug in the size calculation. With these two fixed it
passes kmstest, although it's not really doing anything useful yet.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_gem.c |    6 +++---
 drivers/staging/gma500/psb_gtt.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index d47c187..518f8c1 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -100,8 +100,8 @@ static int psb_gem_create(struct drm_file *file,
 	/* Allocate our object - for now a direct gtt range which is not 
 	   stolen memory backed */
 	r = psb_gtt_alloc_range(dev, size, "gem", 0);
-	if (IS_ERR(r))
-		return PTR_ERR(r);
+	if (r == NULL)
+		return -ENOSPC;
 	/* Initialize the extra goodies GEM needs to do all the hard work */
 	if (drm_gem_object_init(dev, &r->gem, size) != 0) {
 		psb_gtt_free_range(dev, r);
@@ -135,7 +135,7 @@ static int psb_gem_create(struct drm_file *file,
 int psb_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 			struct drm_mode_create_dumb *args)
 {
-	args->pitch = ALIGN(args->width & ((args->bpp + 1) / 8), 64);
+	args->pitch = ALIGN(args->width * ((args->bpp + 7) / 8), 64);
 	args->size = args->pitch * args->height;
 	return psb_gem_create(file, dev, args->size, &args->handle);
 }
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 10d772a..dc0a4b7 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -277,7 +277,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
         } else {
                 /* The rest we will use for GEM backed objects */
                 start = r->start + dev_priv->pg->stolen_size;
-                end = -1;
+                end = r->end;
         }
 
 	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);

