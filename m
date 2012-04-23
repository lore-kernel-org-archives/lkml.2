Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2DWIHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:07:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44655 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2DWIHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:07:06 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        Xi Wang <xi.wang@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] drm/i915: fix integer overflow in i915_gem_do_execbuffer()
Date: Mon, 23 Apr 2012 04:06:42 -0400
Message-Id: <1335168402-25174-2-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335168402-25174-1-git-send-email-xi.wang@gmail.com>
References: <1335168402-25174-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit systems, a large args->num_cliprects from userspace via ioctl
may overflow the allocation size, leading to out-of-bounds access.

This vulnerability was introduced in commit 432e58ed ("drm/i915: Avoid
allocation for execbuffer object list").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 7c50e58..de43194 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1133,6 +1133,11 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
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
-- 
1.7.5.4

