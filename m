Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2ANT7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 14:59:37 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14233 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2ANT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 14:59:35 -0500
Date: Sat, 14 Jan 2012 20:59:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, David Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jesse.barnes@intel.com>
Subject: [PATCH] intel, gma500, lvds: Fix use after free on
 psb_intel_lvds_init()
Message-ID: <alpine.LNX.2.00.1201142056190.11547@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In psb_intel_lvds_init(), if we fail to allocate memory for
'psb_intel_connector' we free the memory we previously allocated for
'psb_intel_encoder', but we then proceed to use that free'd pointer
when we do 'psb_intel_encoder->dev_priv = lvds_priv;'.

I believe the proper way to handle this is to simply return after the
allocation for 'psb_intel_connector' has failed. That is what this
patch does.

While I was there anyway, I also removed the pointless 'if
(psb_intel_connector)' before freeing it at the 'failed_connector:'
label - kfree() deals gracefully with NULL pointers, so it is not
needed.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

 I considered adding a new label at the end and use a goto instead, but
 settled on this minimal solution. If consolidating all exits from the 
 function is prefered then I can rework the patch to do that
 instead. Just let me know.

 Patch is compile tested only since I don't have the hardware to
 actually test it properly.

diff --git a/drivers/gpu/drm/gma500/psb_intel_lvds.c b/drivers/gpu/drm/gma500/psb_intel_lvds.c
index a25e4ca..7d23ef9 100644
--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -725,6 +725,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	if (!psb_intel_connector) {
 		kfree(psb_intel_encoder);
 		dev_err(dev->dev, "psb_intel_connector allocation error\n");
+		return;
 	}
 
 	lvds_priv = kzalloc(sizeof(struct psb_intel_lvds_priv), GFP_KERNEL);
@@ -862,7 +863,6 @@ failed_blc_i2c:
 	drm_encoder_cleanup(encoder);
 	drm_connector_cleanup(connector);
 failed_connector:
-	if (psb_intel_connector)
-		kfree(psb_intel_connector);
+	kfree(psb_intel_connector);
 }
 
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

