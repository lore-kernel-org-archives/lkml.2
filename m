Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2DFM7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:59:06 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49596 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2DFM6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:58:48 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 2/2] drm/i915: fix integer overflow in i915_gem_do_execbuffer()
Date: Fri,  6 Apr 2012 08:58:19 -0400
Message-Id: <1333717099-32679-2-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333717099-32679-1-git-send-email-xi.wang@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large args->num_cliprects from userspace may overflow the allocation
size, leading to out-of-bounds access.

| i915_gem_do_execbuffer()
| i915_gem_execbuffer()

Use kmalloc_array() to avoid that.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 19962bd..607be3d 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1133,8 +1133,8 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			return -EINVAL;
 		}
 
-		cliprects = kmalloc(args->num_cliprects * sizeof(*cliprects),
-				    GFP_KERNEL);
+		cliprects = kmalloc_array(args->num_cliprects, sizeof(*cliprects),
+					  GFP_KERNEL);
 		if (cliprects == NULL) {
 			ret = -ENOMEM;
 			goto pre_mutex_err;
-- 
1.7.5.4

