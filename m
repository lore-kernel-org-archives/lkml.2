Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab2FHFYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:24:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43204 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761117Ab2FHFHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:18 -0400
Message-Id: <20120608041842.765027267@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [ 14/82] drm/i915: wait for a vblank to pass after tv detect
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit bf2125e2f7e931b50a6c76ba0435ba001409ccbf upstream.

Otherwise the hw will get confused and result in a black screen.

This regression has been most likely introduce in

commit 974b93315b2213b74a42a87e8a9d4fc8c0dbe90c
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sun Sep 5 00:44:20 2010 +0100

    drm/i915/tv: Poll for DAC state change

That commit replace the first msleep(20) with a busy-loop, but failed
to keep the 2nd msleep around. Later on we've replaced all these
msleep(20) by proper vblanks.

For reference also see the commit in xf86-video-intel:

commit 1142be53eb8d2ee8a9b60ace5d49f0ba27332275
Author: Jesse Barnes <jbarnes@hobbes.lan>
Date:   Mon Jun 9 08:52:59 2008 -0700

    Fix TV programming:  add vblank wait after TV_CTL writes

    Fxies FDO bug #14000; we need to wait for vblank after
    writing TV_CTL or following "DPMS on" calls may not actually enable the output.

v2: As suggested by Chris Wilson, add a small comment to ensure that
no one accidentally removes this vblank wait again - there really
seems to be no sane explanation for why we need it, but it is
required.

Launchpad: https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/763688
Reported-and-Tested-by: Robert Lowery <rglowery@exemail.com.au>
Cc: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_tv.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 3346612..475f6d4 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1194,6 +1194,11 @@ intel_tv_detect_type(struct intel_tv *intel_tv,
 
 	I915_WRITE(TV_DAC, save_tv_dac & ~TVDAC_STATE_CHG_EN);
 	I915_WRITE(TV_CTL, save_tv_ctl);
+	POSTING_READ(TV_CTL);
+
+	/* For unknown reasons the hw barfs if we don't do this vblank wait. */
+	intel_wait_for_vblank(intel_tv->base.base.dev,
+			      to_intel_crtc(intel_tv->base.base.crtc)->pipe);
 
 	/* Restore interrupt config */
 	if (connector->polled & DRM_CONNECTOR_POLL_HPD) {


