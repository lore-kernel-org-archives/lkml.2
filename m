Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2GASQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47079 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576Ab2GASQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:52 -0400
Message-Id: <20120701172009.653307435@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 21/48] drm/nouveau/fbcon: using nv_two_heads is not a good idea
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 9bd0c15fcfb42f6245447c53347d65ad9e72080b upstream.

nv_two_heads() was never meant to be used outside of pre-nv50 code.  The
code checks for >= NV_10 for 2 CRTCs, then downgrades a few specific
chipsets to 1 CRTC based on (pci_device & 0x0ff0).

The breakage example seen is on GTX 560Ti, with a pciid of 0x1200, which
gets detected as an NV20 (0x020x) with 1 CRTC by nv_two_heads(), causing
memory corruption because there's actually 2 CRTCs..

This switches fbcon to use the CRTC count directly from the mode_config
structure, which will also fix the same issue on Kepler boards which have
4 CRTCs.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 153b9a1..1074bc5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -467,7 +467,7 @@ int nouveau_fbcon_init(struct drm_device *dev)
 	nfbdev->helper.funcs = &nouveau_fbcon_helper_funcs;
 
 	ret = drm_fb_helper_init(dev, &nfbdev->helper,
-				 nv_two_heads(dev) ? 2 : 1, 4);
+				 dev->mode_config.num_crtc, 4);
 	if (ret) {
 		kfree(nfbdev);
 		return ret;


