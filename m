Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009Ab0HFSgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:36:47 -0400
Received: from kroah.org ([198.145.64.141]:48765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964967Ab0HFSgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:03 2010
Message-Id: <20100806183203.408301655@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [38/38] drm/i915: Check overlay stride errata for i830 and i845
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit a1efd14a99483a4fb9308902397ed86b69454c99 upstream.

Apparently i830 and i845 cannot handle any stride that is not a multiple
of 256, unlike their brethren which do support 64 byte aligned strides.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_overlay.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -958,7 +958,7 @@ static int check_overlay_src(struct drm_
 	    || rec->src_width < N_HORIZ_Y_TAPS*4)
 		return -EINVAL;
 
-	/* check alingment constrains */
+	/* check alignment constraints */
 	switch (rec->flags & I915_OVERLAY_TYPE_MASK) {
 		case I915_OVERLAY_RGB:
 			/* not implemented */
@@ -990,7 +990,10 @@ static int check_overlay_src(struct drm_
 		return -EINVAL;
 
 	/* stride checking */
-	stride_mask = 63;
+	if (IS_I830(dev) || IS_845G(dev))
+		stride_mask = 255;
+	else
+		stride_mask = 63;
 
 	if (rec->stride_Y & stride_mask || rec->stride_UV & stride_mask)
 		return -EINVAL;


