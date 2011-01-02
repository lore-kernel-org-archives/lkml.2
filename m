Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1ABHzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:55:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:35427 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1ABHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 104/260] i915: return -EFAULT if copy_to_user fails
Date: Sun,  2 Jan 2011 02:16:40 -0500
Message-Id: <1293952756-15010-105-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:04.0086 (UTC) FILETIME=[C134D560:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 9927a403ca8c97798129953fa9cbb5dc259c7cb9 upstream.

copy_to_user returns the number of bytes remaining to be copied, but we
want to return a negative error code here.  These are returned to
userspace.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/i915/i915_dma.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 9550230..b0ac371 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -691,8 +691,10 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 		ret = copy_from_user(cliprects, batch->cliprects,
 				     batch->num_cliprects *
 				     sizeof(struct drm_clip_rect));
-		if (ret != 0)
+		if (ret != 0) {
+			ret = -EFAULT;
 			goto fail_free;
+		}
 	}
 
 	mutex_lock(&dev->struct_mutex);
@@ -733,8 +735,10 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 		return -ENOMEM;
 
 	ret = copy_from_user(batch_data, cmdbuf->buf, cmdbuf->sz);
-	if (ret != 0)
+	if (ret != 0) {
+		ret = -EFAULT;
 		goto fail_batch_free;
+	}
 
 	if (cmdbuf->num_cliprects) {
 		cliprects = kcalloc(cmdbuf->num_cliprects,
@@ -747,8 +751,10 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 		ret = copy_from_user(cliprects, cmdbuf->cliprects,
 				     cmdbuf->num_cliprects *
 				     sizeof(struct drm_clip_rect));
-		if (ret != 0)
+		if (ret != 0) {
+			ret = -EFAULT;
 			goto fail_clip_free;
+		}
 	}
 
 	mutex_lock(&dev->struct_mutex);
-- 
1.7.3.3

