Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1BVWV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:58 -0500
Received: from kroah.org ([198.145.64.141]:46762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1BVWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.710164960@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [37/70] drm/radeon/kms: add missing frac fb div flag for dce4+
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 9f4283f49f0a96a64c5a45fe56f0f8c942885eef upstream.

The fixed ref/post dividers are set by the AdjustPll table
rather than the ss info table on dce4+.  Make sure we enable
the fractional feedback dividers when using a fixed post
or ref divider on them as well.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=29272

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -533,9 +533,9 @@ static u32 atombios_adjust_pll(struct dr
 
 			/* use recommended ref_div for ss */
 			if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
-				pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
 				if (ss_enabled) {
 					if (ss->refdiv) {
+						pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
 						pll->flags |= RADEON_PLL_USE_REF_DIV;
 						pll->reference_div = ss->refdiv;
 						if (ASIC_IS_AVIVO(rdev))
@@ -650,10 +650,12 @@ static u32 atombios_adjust_pll(struct dr
 						   index, (uint32_t *)&args);
 				adjusted_clock = le32_to_cpu(args.v3.sOutput.ulDispPllFreq) * 10;
 				if (args.v3.sOutput.ucRefDiv) {
+					pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 					pll->flags |= RADEON_PLL_USE_REF_DIV;
 					pll->reference_div = args.v3.sOutput.ucRefDiv;
 				}
 				if (args.v3.sOutput.ucPostDiv) {
+					pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 					pll->flags |= RADEON_PLL_USE_POST_DIV;
 					pll->post_div = args.v3.sOutput.ucPostDiv;
 				}


