Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161772Ab2GLWkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:40:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161755Ab2GLWkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 072/187] drm/nouveau/fbcon: using nv_two_heads is not a good idea
Date: Thu, 12 Jul 2012 15:33:48 -0700
Message-Id: <20120712191529.079783605@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -497,7 +497,7 @@ int nouveau_fbcon_init(struct drm_device
 	nfbdev->helper.funcs = &nouveau_fbcon_helper_funcs;
 
 	ret = drm_fb_helper_init(dev, &nfbdev->helper,
-				 nv_two_heads(dev) ? 2 : 1, 4);
+				 dev->mode_config.num_crtc, 4);
 	if (ret) {
 		kfree(nfbdev);
 		return ret;


