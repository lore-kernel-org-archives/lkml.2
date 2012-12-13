Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2LMPNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:13:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2LMOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:00:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 003/241] drm/i915: fix overlay on i830M
Date: Thu, 13 Dec 2012 11:56:08 -0200
Message-Id: <1355407206-17100-4-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_overlay.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index 458743d..bd63f2f 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -431,9 +431,17 @@ static int intel_overlay_off(struct intel_overlay *overlay)
 	intel_ring_emit(ring, flip_addr);
 	intel_ring_emit(ring, MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
 	/* turn overlay off */
-	intel_ring_emit(ring, MI_OVERLAY_FLIP | MI_OVERLAY_OFF);
-	intel_ring_emit(ring, flip_addr);
-	intel_ring_emit(ring, MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
+	if (IS_I830(dev)) {
+		/* Workaround: Don't disable the overlay fully, since otherwise
+		 * it dies on the next OVERLAY_ON cmd. */
+		intel_ring_emit(ring, MI_NOOP);
+		intel_ring_emit(ring, MI_NOOP);
+		intel_ring_emit(ring, MI_NOOP);
+	} else {
+		intel_ring_emit(ring, MI_OVERLAY_FLIP | MI_OVERLAY_OFF);
+		intel_ring_emit(ring, flip_addr);
+		intel_ring_emit(ring, MI_WAIT_FOR_EVENT | MI_WAIT_FOR_OVERLAY_FLIP);
+	}
 	intel_ring_advance(ring);
 
 	return intel_overlay_do_wait_request(overlay, request,
-- 
1.7.9.5

