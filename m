Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2GASZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:25:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46967 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab2GASQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:36 -0400
Message-Id: <20120701172008.531189599@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Timo Aaltonen <timo.aaltonen@canonical.com>
Subject: [ 13/48] drm/i915: Remove use of the autoreported ringbuffer HEAD  position
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

This is a revert of 6aa56062eaba67adfb247cded244fd877329588d.

This was originally introduced to workaround reads of the ringbuffer
registers returning 0 on SandyBridge causing hangs due to ringbuffer
overflow. The root cause here was reads through the GT powerwell require
the forcewake dance, something we only learnt of later. Now it appears
that reading the reported head position from the HWS is returning
garbage, leading once again to hangs.

For example, on q35 the autoreported head reports:
  [  217.975608] head now 00010000, actual 00010000
  [  436.725613] head now 00200000, actual 00200000
  [  462.956033] head now 00210000, actual 00210010
  [  485.501409] head now 00400000, actual 00400020
  [  508.064280] head now 00410000, actual 00410000
  [  530.576078] head now 00600000, actual 00600020
  [  553.273489] head now 00610000, actual 00610018
which appears reasonably sane. In contrast, if we look at snb:
  [  141.970680] head now 00e10000, actual 00008238
  [  141.974062] head now 02734000, actual 000083c8
  [  141.974425] head now 00e10000, actual 00008488
  [  141.980374] head now 032b5000, actual 000088b8
  [  141.980885] head now 03271000, actual 00008950
  [  142.040628] head now 02101000, actual 00008b40
  [  142.180173] head now 02734000, actual 00009050
  [  142.181090] head now 00000000, actual 00000ae0
  [  142.183737] head now 02734000, actual 00009050

In addition, the automatic reporting of the head position is scheduled
to be defeatured in the future. It has no more utility, remove it.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=45492
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
(cherry picked from commit 5d031e5b633d910f35e6e0abce94d9d842390006)
Signed-off-by: Timo Aaltonen <timo.aaltonen@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 62f9ac5..5d369b1 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -301,7 +301,7 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
-			| RING_REPORT_64K | RING_VALID);
+			| RING_VALID);
 
 	/* If the head is still not zero, the ring is dead */
 	if ((I915_READ_CTL(ring) & RING_VALID) == 0 ||
@@ -1143,18 +1143,6 @@ int intel_wait_ring_buffer(struct intel_ring_buffer *ring, int n)
 	struct drm_device *dev = ring->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long end;
-	u32 head;
-
-	/* If the reported head position has wrapped or hasn't advanced,
-	 * fallback to the slow and accurate path.
-	 */
-	head = intel_read_status_page(ring, 4);
-	if (head > ring->head) {
-		ring->head = head;
-		ring->space = ring_space(ring);
-		if (ring->space >= n)
-			return 0;
-	}
 
 	trace_i915_ring_wait_begin(ring);
 	end = jiffies + 3 * HZ;


