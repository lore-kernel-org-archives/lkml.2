Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2EDUsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:48:38 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab2EDUse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:48:34 -0400
Message-Id: <20120504204246.005795756@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xi Wang <xi.wang@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 13/47] drm/i915: fix integer overflow in i915_gem_execbuffer2()
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit ed8cd3b2cd61004cab85380c52b1817aca1ca49b upstream.

On 32-bit systems, a large args->buffer_count from userspace via ioctl
may overflow the allocation size, leading to out-of-bounds access.

This vulnerability was introduced in commit 8408c282 ("drm/i915:
First try a normal large kmalloc for the temporary exec buffers").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1296,7 +1296,8 @@ i915_gem_execbuffer2(struct drm_device *
 	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
 	int ret;
 
-	if (args->buffer_count < 1) {
+	if (args->buffer_count < 1 ||
+	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
 		DRM_ERROR("execbuf2 with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}


