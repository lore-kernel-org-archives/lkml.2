Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2ANVP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:15:58 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15130 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab2ANVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:15:57 -0500
Date: Sat, 14 Jan 2012 22:15:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, David Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jesse.barnes@intel.com>
Subject: [PATCH] intel, gma500, lvds: Fix use after free and mem leak in
 psb_intel_lvds_init()
In-Reply-To: <alpine.LNX.2.00.1201142156220.11547@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1201142211370.11547@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201142056190.11547@swampdragon.chaosbits.net> <alpine.LNX.2.00.1201142156220.11547@swampdragon.chaosbits.net>
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

We may also leak the memory we allocated for 'psb_intel_encoder' if we 
'goto failed_connector;' and the variable goes out of scope.

While I was there anyway, I also removed the pointless 'if
(psb_intel_connector)' before freeing it at the 'failed_connector:'
label - kfree() deals gracefully with NULL pointers, so it is not
needed.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_intel_lvds.c b/drivers/gpu/drm/gma500/psb_intel_lvds.c
index a25e4ca..0a43758 100644
--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -713,7 +713,6 @@ void psb_intel_lvds_init(struct drm_device *dev,
 
 	psb_intel_encoder =
 			kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
-
 	if (!psb_intel_encoder) {
 		dev_err(dev->dev, "psb_intel_encoder allocation error\n");
 		return;
@@ -721,10 +720,9 @@ void psb_intel_lvds_init(struct drm_device *dev,
 
 	psb_intel_connector =
 		kzalloc(sizeof(struct psb_intel_connector), GFP_KERNEL);
-
 	if (!psb_intel_connector) {
-		kfree(psb_intel_encoder);
 		dev_err(dev->dev, "psb_intel_connector allocation error\n");
+		goto failed_encoder;
 	}
 
 	lvds_priv = kzalloc(sizeof(struct psb_intel_lvds_priv), GFP_KERNEL);
@@ -862,7 +860,8 @@ failed_blc_i2c:
 	drm_encoder_cleanup(encoder);
 	drm_connector_cleanup(connector);
 failed_connector:
-	if (psb_intel_connector)
-		kfree(psb_intel_connector);
+	kfree(psb_intel_connector);
+failed_encoder:
+	kfree(psb_intel_encoder);
 }
 
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

