Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1KBGUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:20:49 -0400
Received: from home.keithp.com ([63.227.221.253]:58234 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1KBGUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:20:46 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 0/7] drm/i915: Fix PCH eDP support for SNB
Date: Tue,  1 Nov 2011 23:20:23 -0700
Message-Id: <1320214830-12696-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch sequence which makes my PCH-connected eDP panel
work. The main bug was a pile of places where the driver was
incorrectly treating a PCH connected eDP panel like a CPU connected
eDP panel, setting incorrect bits in the DP_CTL register and failing
to configure the TRANS_DP_CTL register entirely.

Beyond that, this eDP panel appears very sensitive to panel power
sequencing, and I found a bunch of minor errors there. I switched from
using blind timings to polling the panel power sequencing status
register to make sure we waited until that thought things were done,
and so that any panel power sequencing errors would show up in the
kernel log.

Finally, I noticed that the BIOS tried harder to get the link trained,
by simply starting over when it failed and trying the whole sequence
up to 5 times. This is not part of the DP spec, but given how bad
failing to train a panel is, it seems like it might be a good idea.

The three most interesting patches are the one which handles PCH eDP
more like PCH DP, the one which switches to using the panel power
sequencing hardware for all delays and finally the patch which tries
to do the panel power-up/down in the same order for both
dp_prepare/commit and dp_dpms.

All of these patches are on my pch-edp-fixes branch at

	git://people.freedesktop.org/~keithp/linux

If you've got a PCH connected eDP display, I'd love to know if this
makes it work. If you've got a CPU connected eDP display or PCH
connected DP, please see if this causes any problems.

(I've got several machines failing to resume with this patch, but I've
checked and it's not the fault of anything in the i915 directory;
applying this sequence to v3.1 makes suspend/resume work fine).

