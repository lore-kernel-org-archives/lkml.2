Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2HVXlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:41:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34682 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2HVXlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:41:02 -0400
Date: Wed, 22 Aug 2012 16:40:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i915: use alloc_ordered_workqueue() instead of explicit
 UNBOUND w/ max_active = 1
Message-ID: <20120822234057.GR19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an equivalent conversion and will ease scheduled removal of
WQ_NON_REENTRANT.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/gpu/drm/i915/i915_dma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 9cf7dfe..a55ca7a 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1536,11 +1536,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	 *
 	 * All tasks on the workqueue are expected to acquire the dev mutex
 	 * so there is no point in running more than one instance of the
-	 * workqueue at any time: max_active = 1 and NON_REENTRANT.
+	 * workqueue at any time.  Use an ordered one.
 	 */
-	dev_priv->wq = alloc_workqueue("i915",
-				       WQ_UNBOUND | WQ_NON_REENTRANT,
-				       1);
+	dev_priv->wq = alloc_ordered_workqueue("i915", 0);
 	if (dev_priv->wq == NULL) {
 		DRM_ERROR("Failed to create our workqueue.\n");
 		ret = -ENOMEM;
