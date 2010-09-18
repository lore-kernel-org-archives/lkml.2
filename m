Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0IRTF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:05:58 -0400
Received: from kroah.org ([198.145.64.141]:51926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0IRTCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:31 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:03 2010
Message-Id: <20100918190003.110047560@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [120/123] i915: return -EFAULT if copy_to_user fails
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=i915-return-efault-if-copy_to_user-fails.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -683,8 +683,10 @@ static int i915_batchbuffer(struct drm_d
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
@@ -725,8 +727,10 @@ static int i915_cmdbuffer(struct drm_dev
 		return -ENOMEM;
 
 	ret = copy_from_user(batch_data, cmdbuf->buf, cmdbuf->sz);
-	if (ret != 0)
+	if (ret != 0) {
+		ret = -EFAULT;
 		goto fail_batch_free;
+	}
 
 	if (cmdbuf->num_cliprects) {
 		cliprects = kcalloc(cmdbuf->num_cliprects,
@@ -737,8 +741,10 @@ static int i915_cmdbuffer(struct drm_dev
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


