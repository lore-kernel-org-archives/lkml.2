Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082Ab2EJRtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:49:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245Ab2EJRdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:42 -0400
Message-Id: <20120510173133.504940463@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 06/52] drm/i915: disable sdvo hotplug on i945g/gm
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 768b107e4b3be0acf6f58e914afe4f337c00932b upstream.

Chris Wilson dug out a hw erratum saying that there's noise on the
interrupt line on i945G chips. We also have a bug report from a i945GM
chip with an sdvo hotplug interrupt storm (and no apparent cause).

Play it safe and disable sdvo hotplug on all i945 variants.

Note that this is a regression that has been introduced in 3.1,
when we've enabled sdvo hotplug support with

commit cc68c81aed7d892deaf12d720d5455208e94cd0a
Author: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Date:   Wed Sep 21 17:13:30 2011 +0100

    drm/i915: Enable SDVO hotplug interrupts for HDMI and DVI

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=38442
Reported-and-tested-by: Dominik Köppl <dominik@devwork.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1221,8 +1221,14 @@ static bool intel_sdvo_get_capabilities(
 
 static int intel_sdvo_supports_hotplug(struct intel_sdvo *intel_sdvo)
 {
+	struct drm_device *dev = intel_sdvo->base.base.dev;
 	u8 response[2];
 
+	/* HW Erratum: SDVO Hotplug is broken on all i945G chips, there's noise
+	 * on the line. */
+	if (IS_I945G(dev) || IS_I945GM(dev))
+		return false;
+
 	return intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_HOT_PLUG_SUPPORT,
 				    &response, 2) && response[0];
 }


