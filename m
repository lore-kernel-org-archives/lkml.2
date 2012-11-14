Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2KNFvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55331 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932428Ab2KNFvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:18 -0500
Message-Id: <20121114053936.526288450@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rhys <rhyspuk@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [ 19/82] drm/i915: fix overlay on i830M
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit a9193983f4f292a82a00c72971c17ec0ee8c6c15 upstream.

The overlay on the i830M has a peculiar failure mode: It works the
first time around after boot-up, but consistenly hangs the second time
it's used.

Chris Wilson has dug out a nice errata:

"1.5.12 Clock Gating Disable for Display Register
Address Offset:	06200h–06203h

"Bit 3
Ovrunit Clock Gating Disable.
0 = Clock gating controlled by unit enabling logic
1 = Disable clock gating function
DevALM Errata ALM049: Overlay Clock Gating Must be Disabled:  Overlay
& L2 Cache clock gating must be disabled in order to prevent device
hangs when turning off overlay.SW must turn off Ovrunit clock gating
(6200h) and L2 Cache clock gating (C8h)."

Now I've nowhere found that 0xc8 register and hence couldn't apply the
l2 cache workaround. But I've remembered that part of the magic that
the OVERLAY_ON/OFF commands are supposed to do is to rearrange cache
allocations so that the overlay scaler has some scratch space.

And while pondering how that could explain the hang the 2nd time we
enable the overlay, I've remembered that the old ums overlay code did
_not_ issue the OVERLAY_OFF cmd.

And indeed, disabling the OFF cmd results in the overlay working
flawlessly, so I guess we can workaround the lack of the above
workaround by simply never disabling the overlay engine once it's
enabled.

Note that we have the first part of the above w/a already implemented
in i830_init_clock_gating - leave that as-is to avoid surprises.

v2: Add a comment in the code.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=47827
Tested-by: Rhys <rhyspuk@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2:
 - Adjust context
 - s/intel_ring_emit(ring, /OUT_RING(/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_overlay.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -428,9 +428,17 @@ static int intel_overlay_off(struct inte
 	OUT_RING(flip_addr);
 	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
 	/* turn overlay off */
-	OUT_RING(MI_OVERLAY_FLIP | MI_OVERLAY_OFF);
-	OUT_RING(flip_addr);
-	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
+	if (IS_I830(dev)) {
+		/* Workaround: Don't disable the overlay fully, since otherwise
+		 * it dies on the next OVERLAY_ON cmd. */
+		OUT_RING(MI_NOOP);
+		OUT_RING(MI_NOOP);
+		OUT_RING(MI_NOOP);
+	} else {
+		OUT_RING(MI_OVERLAY_FLIP | MI_OVERLAY_OFF);
+		OUT_RING(flip_addr);
+		OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
+	}
 	ADVANCE_LP_RING();
 
 	return intel_overlay_do_wait_request(overlay, request,


