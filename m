Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1GZGhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:37:34 -0400
Received: from home.keithp.com ([63.227.221.253]:48659 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1GZGgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:36:53 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: drm/i915: A selection of display port fixes
Date: Mon, 25 Jul 2011 23:36:29 -0700
Message-Id: <1311662194-4050-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH 1/5] drm/i915: Use dp_detect_common in hotplug helper
 [PATCH 2/5] drm/i915: Rename i915_dp_detect_common to
 [PATCH 3/5] drm/i915: In intel_dp_init, replace read of DPCD with

These three are simple cleanups to centralize all places where the
DPCD block was read from the device. Now everyone shares the same
function, and that function retries the reads.

 [PATCH 4/5] drm/i915: Delay 250ms before running the hotplug code

I was experimenting with DP hotplugging -- moving the plug in and out
of the jack very slowly and discovered that the hotplug interrupt
occurred well before or after the link for the aux data channel was
connected or disconnected. The result of this was that a sufficiently
rapid cycle back through user mode could easily beat the motion of the
plug and cause the hotplug detection to get the wrong status. Sticking
a 250ms delay before doing anything gives the user sufficient time to
actually get the plug connected or disconnected.

 [PATCH 5/5] drm/i915: DP_PIPE_ENABLED must check transcoder on CPT

This is a fairly nice bug fix to finally have. The symptom I saw was
that going from one two-head configuration to another would sometimes
turn off the monitor which was *not* being modified. For instance, I
would do:

 $ xrandr --output LVDS1 --below DP2

This would always turn off the DP2 monitor, and sometimes it wouldn't
turn back on.

Turns out the bug wasn't that the mode setting code was doing it wrong
and turning the DP2 output off intentionally as a part of the mode
change. Instead, the intel driver was trying to adjust the PCH link
for the LVDS1 output and thought it needed to turn the DP2 output off
because it mistakenly believed the DP2 output was sharing the same
pipe as the LVDS1 output. Just a matter of using the wrong mechanism
to detect which pipe the DP2 output was connected to.

In any case, review and testing appreciated.

-keith
