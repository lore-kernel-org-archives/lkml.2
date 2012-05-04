Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2EDUpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:45:20 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2EDUpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:12 -0400
Message-Id: <20120504204226.532718404@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xi Wang <xi.wang@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 25/75] drm/i915: fix integer overflow in i915_gem_do_execbuffer()
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit 44afb3a04391a74309d16180d1e4f8386fdfa745 upstream.

On 32-bit systems, a large args->num_cliprects from userspace via ioctl
may overflow the allocation size, leading to out-of-bounds access.

This vulnerability was introduced in commit 432e58ed ("drm/i915: Avoid
allocation for execbuffer object list").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1082,6 +1082,11 @@ i915_gem_do_execbuffer(struct drm_device
 			return -EINVAL;
 		}
 
+		if (args->num_cliprects > UINT_MAX / sizeof(*cliprects)) {
+			DRM_DEBUG("execbuf with %u cliprects\n",
+				  args->num_cliprects);
+			return -EINVAL;
+		}
 		cliprects = kmalloc(args->num_cliprects * sizeof(*cliprects),
 				    GFP_KERNEL);
 		if (cliprects == NULL) {


