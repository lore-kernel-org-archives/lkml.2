Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0KHKyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:54:50 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:43246 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0KHKyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:54:49 -0500
Subject: Re: [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b9dded$h0q3am@orsmga002.jf.intel.com>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	 <b9dded$h0q3am@orsmga002.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 05:54:55 -0500
Message-ID: <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 10:27 +0000, Chris Wilson wrote:
> On Mon, 08 Nov 2010 05:18:32 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
> > Hi Chris,
> > 
> > The following patch that you recently committed breaks my ASUS Eee PC
> > 1015PEM by causing the display to be offset by about 1 inch (a few
> > centimeters) when the mode is (re)set during boot. I previously posted
> > both photographs and video of the problem in another "PROBLEM" thread.
> 
> [snip]
> 
> > I'll look at the patch. Either the EDID is *not* consistent (in which
> > case, why are we not seeing other bugs like this?) or there is something
> > specific to this system or panel used.
> 
> Interesting. Or even downright bizarre! Can you disable the caching
> (hopefully the patch is still revertible) and save the EDID
> (/sys/class/drm/card0-LVDS-1/edid) periodically? Might be simplest just to
> dump the EDID every time we probe the LVDS if it has changed.

Already onto it. It's 6am here so I'll sleep soon ;) but I just applied
the following patch and booted it/logged into X without the problem
(apologies if evolution corrupts it, I usually send patches with mutt):

>From c2fed0d864935603b1d71c71ae53d197f52e346f Mon Sep 17 00:00:00 2001
From: Jon Masters <jcm@jonmasters.org>
Date: Mon, 8 Nov 2010 05:39:42 -0500
Subject: [PATCH] drm/i915: revert LVDS EDID cacheing

The previous commit v2.6.36-rc5-173-g219adae changed the Intel i915
driver to cache the EDID result obtained from the panel, but in so
doing broke some systems by causing weird modesetting problems.

Signed-off-by: Jon Masters <jcm@jonmasters.org>
---
 drivers/gpu/drm/i915/intel_lvds.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c
b/drivers/gpu/drm/i915/intel_lvds.c
index f1a6499..78153df 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -44,7 +44,7 @@
 struct intel_lvds {
 	struct intel_encoder base;
 
-	struct edid *edid;
+	bool edid_good;
 
 	int fitting_mode;
 	u32 pfit_control;
@@ -479,12 +479,14 @@ static int intel_lvds_get_modes(struct
drm_connector *connector)
 {
 	struct intel_lvds *intel_lvds = intel_attached_lvds(connector);
 	struct drm_device *dev = connector->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_display_mode *mode;
 
-	if (intel_lvds->edid) {
-		drm_mode_connector_update_edid_property(connector,
-							intel_lvds->edid);
-		return drm_add_edid_modes(connector, intel_lvds->edid);
+	if (intel_lvds->edid_good) {
+		int ret = intel_ddc_get_modes(connector,
+					      &dev_priv->gmbus[GMBUS_PORT_PANEL].adapter);
+		if (ret)
+			return ret;
 	}
 
 	mode = drm_mode_duplicate(dev, intel_lvds->fixed_mode);
@@ -937,10 +939,11 @@ void intel_lvds_init(struct drm_device *dev)
 	 * Attempt to get the fixed panel mode from DDC.  Assume that the
 	 * preferred mode is the right one.
 	 */
-	intel_lvds->edid = drm_get_edid(connector,
-					&dev_priv->gmbus[pin].adapter);
+	intel_lvds->edid_good = true;
+	if (!intel_ddc_get_modes(connector,
&dev_priv->gmbus[GMBUS_PORT_PANEL].adapter))
+		intel_lvds->edid_good = false;
 
-	if (!intel_lvds->edid) {
+	if (!intel_lvds->edid_good) {
 		/* Didn't get an EDID, so
 		 * Set wide sync ranges so we get all modes
 		 * handed to valid_mode for checking
-- 
1.7.3.2

Here is the EDID output after booting:

[jcm@monticello ~]$ hexdump /sys/class/drm/card0-LVDS-1/edid
0000000 ff00 ffff ffff 00ff 6422 03e9 8544 0001
0000010 141c 0301 1680 780d 860a 9426 5157 2790
0000020 4f21 0054 0000 0101 0101 0101 0101 0101
0000030 0101 0101 0101 1194 b000 5840 2019 2335
0000040 0045 81dc 0000 1900 1416 d800 5840 2026
0000050 235d 0415 81dc 0000 0000 0000 fe00 0000
0000060 0000 0000 0000 0000 0000 0000 0000 fe00
0000070 0000 0000 0000 0000 0100 0000 0000 f200
0000080

Sounds like you are suggesting that I hack up the intel_lvds to just
printk the EDID when it is read? I can look at that, probably after
sleeping. Perhaps you can also send me a patch to get what you want? I'm
on IRC, and pingable later on today if you want me to try stuff.

Jon.


