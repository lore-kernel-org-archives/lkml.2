Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2GASQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46960 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973Ab2GASQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:35 -0400
Message-Id: <20120701172008.953154856@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Keith Packard <keithp@keithp.com>
Subject: [ 16/48] drm/i915: Do the fallback non-IRQ wait in ring throttle, too.
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 7ea29b13e5e3e1e61e612349eb0366efdb6457f3 upstream.

As a workaround for IRQ synchronization issues in the gen7 BLT ring,
we want to turn the two wait functions into polling loops.

Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Acked-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 8359dc7..66e0a55 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3309,6 +3309,10 @@ i915_gem_ring_throttle(struct drm_device *dev, struct drm_file *file)
 
 			if (ret == 0 && atomic_read(&dev_priv->mm.wedged))
 				ret = -EIO;
+		} else if (wait_for(i915_seqno_passed(ring->get_seqno(ring),
+						      seqno) ||
+				    atomic_read(&dev_priv->mm.wedged), 3000)) {
+			ret = -EBUSY;
 		}
 	}
 


