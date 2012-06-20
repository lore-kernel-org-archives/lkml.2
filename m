Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2FTSlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:41:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab2FTSVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:32 -0400
Message-Id: <20120620173021.334111012@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Jackson <ajax@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 04/61] Revert "drm/i915/dp: Use auxch precharge value of 5 everywhere"
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 6b4e0a93ff6e45714c72bdce193f719ed94810e3 upstream.

This reverts commit 092945e11c5b84f66dd08f0b87fb729715d377bc.

This commit prevents a DP screen from properly training the link.
Oddly enough it works, once the machine has been warm-booted with an
older kernel.

According to DP docs this _should_ have been the right precharge time.
Also, the commit that originally introduces this was just general snb
DP enabling and didn't mention any specific reason for this special
value. Whatever, trust the reporter that this makes things worse and
let's just revert it.

v2: Less spelling fail.

Cc: Adam Jackson <ajax@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reported-by: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Buglink: https://lkml.org/lkml/2012/6/14/301
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -368,7 +368,7 @@ intel_dp_aux_ch(struct intel_dp *intel_d
 	int recv_bytes;
 	uint32_t status;
 	uint32_t aux_clock_divider;
-	int try, precharge = 5;
+	int try, precharge;
 
 	intel_dp_check_edp(intel_dp);
 	/* The clock divider is based off the hrawclk,
@@ -388,6 +388,11 @@ intel_dp_aux_ch(struct intel_dp *intel_d
 	else
 		aux_clock_divider = intel_hrawclk(dev) / 2;
 
+	if (IS_GEN6(dev))
+		precharge = 3;
+	else
+		precharge = 5;
+
 	/* Try to wait for any previous AUX channel activity */
 	for (try = 0; try < 3; try++) {
 		status = I915_READ(ch_ctl);


