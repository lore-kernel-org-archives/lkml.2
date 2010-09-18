Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0IRTQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:34 -0400
Received: from kroah.org ([198.145.64.141]:43946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0IRTQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:32 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.662287627@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [121/129] i915: return -EFAULT if copy_to_user fails
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -612,8 +612,10 @@ static int i915_batchbuffer(struct drm_d
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
@@ -654,8 +656,10 @@ static int i915_cmdbuffer(struct drm_dev
 		return -ENOMEM;
 
 	ret = copy_from_user(batch_data, cmdbuf->buf, cmdbuf->sz);
-	if (ret != 0)
+	if (ret != 0) {
+		ret = -EFAULT;
 		goto fail_batch_free;
+	}
 
 	if (cmdbuf->num_cliprects) {
 		cliprects = kcalloc(cmdbuf->num_cliprects,
@@ -668,8 +672,10 @@ static int i915_cmdbuffer(struct drm_dev
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


