Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2KVSkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:49648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab2KVSke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rhys <rhyspuk@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 049/171] drm/i915: fix overlay on i830M
Date: Wed, 21 Nov 2012 16:39:55 -0800
Message-Id: <20121122004038.293228923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_overlay.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -427,9 +427,17 @@ static int intel_overlay_off(struct inte
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


