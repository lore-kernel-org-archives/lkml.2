Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1HFRyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:54:16 -0400
Received: from home.keithp.com ([63.227.221.253]:41176 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab1HFRyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:54:15 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: drm/i915: Disabling unused outputs on CPT is broken
Date: Sat,  6 Aug 2011 10:54:04 -0700
Message-Id: <1312653248-3487-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a fun sequence:

$ xrandr --output LVDS1 --auto --crtc 1
$ sudo chvt 1

(then switch back to X)

The LVDS goes black. Why? The LVDS is *disabled*. Turns out that the
cause was that after the mode was all nicely set,
intel_disable_pch_ports went and turned it back off.

Well, a couple of weeks ago, we found that intel_disable_pch_ports was
doing the same thing to DP ports, and the cause was that the way to
tell which port a DP output was running from is different on CPT that
on every other chip. We fixed that, but didn't (foolishly) review the
non-DP code.

Oddly, the non-DP code had essentially the same bug:

 [PATCH 3/4] drm/i915: Fix PCH port pipe select in CPT disable paths

Also in this sequence is some code that validates the LVDS panel power
sequencing which discovered that the LVDS panel wasn't being disabled
correctly because the LVDS registers were locked in the DPMS
function. Instead of trying to get the LVDS locking right, I've just
unlocked the registers in the lvds initialization code and left them
unlocked after that:

 [PATCH 1/4] drm/i915: Wait for LVDS panel power sequence
 [PATCH 2/4] drm/i915: Leave LVDS registers unlocked

Finally, I removed an unused argument to dp_pipe_enable while I was
poking around in that code:

 [PATCH 4/4] drm/i915: Remove unused 'reg' argument to dp_pipe_enable

--
keith.packard@intel.com
