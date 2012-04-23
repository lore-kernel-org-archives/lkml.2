Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2DWIHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:07:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65086 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2DWIHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:07:01 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        Xi Wang <xi.wang@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
Date: Mon, 23 Apr 2012 04:06:41 -0400
Message-Id: <1335168402-25174-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit systems, a large args->buffer_count from userspace via ioctl
may overflow the allocation size, leading to out-of-bounds access.

This vulnerability was introduced in commit 8408c282 ("drm/i915:
First try a normal large kmalloc for the temporary exec buffers").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index f51a696..7c50e58 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1404,7 +1404,8 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
 	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
 	int ret;
 
-	if (args->buffer_count < 1) {
+	if (args->buffer_count < 1 ||
+	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
 		DRM_DEBUG("execbuf2 with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
-- 
1.7.5.4

