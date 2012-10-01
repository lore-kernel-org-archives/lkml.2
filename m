Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2JAW73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:29 -0400
Received: from 1wt.eu ([62.212.114.60]:34956 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2JAW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:26 -0400
Message-Id: <20121001225158.595310500@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 023/180] drm/i915: Attempt to fix watermark setup on 85x (v2)
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 8f4695ed1c9e068772bcce4cd4ff03f88d57a008 upstream.

IS_MOBILE() catches 85x, so we'd always try to use the 9xx FIFO sizing;
since there's an explicit 85x version, this seems wrong.

v2: Handle 830m correctly too.

[jn: backport to 2.6.32.y to address
 https://bugzilla.kernel.org/show_bug.cgi?id=42839]

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/gpu/drm/i915/intel_display.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 79cc437..25b3e90 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4355,17 +4355,18 @@ static void intel_init_display(struct drm_device *dev)
 		dev_priv->display.update_wm = g4x_update_wm;
 	else if (IS_I965G(dev))
 		dev_priv->display.update_wm = i965_update_wm;
-	else if (IS_I9XX(dev) || IS_MOBILE(dev)) {
+	else if (IS_I9XX(dev)) {
 		dev_priv->display.update_wm = i9xx_update_wm;
 		dev_priv->display.get_fifo_size = i9xx_get_fifo_size;
+	} else if (IS_I85X(dev)) {
+		dev_priv->display.update_wm = i9xx_update_wm;
+		dev_priv->display.get_fifo_size = i85x_get_fifo_size;
 	} else {
-		if (IS_I85X(dev))
-			dev_priv->display.get_fifo_size = i85x_get_fifo_size;
-		else if (IS_845G(dev))
+		dev_priv->display.update_wm = i830_update_wm;
+		if (IS_845G(dev))
 			dev_priv->display.get_fifo_size = i845_get_fifo_size;
 		else
 			dev_priv->display.get_fifo_size = i830_get_fifo_size;
-		dev_priv->display.update_wm = i830_update_wm;
 	}
 }
 
-- 
1.7.2.1.45.g54fbc



