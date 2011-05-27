Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1E0NrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:47:02 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51299 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1E0NrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=UXTJE+8qhLtnc48oWMjlmMAsoiujxLeKD6xfFIblZ8kmw72Xa2Yawi28UC6ZFgRnxY
         9xqc3W8cpybIN8hT++hmM3vzLUYDUk+Yxkb5rlYtOWSdNtxDD7KgPSNiMBHbsNDwHey+
         Sq3J41Gikpct4iIAOqWfxJSM3536KOnGgtji8=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: fix regression after clock gating init split
Date: Fri, 27 May 2011 23:44:19 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r5; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105272344.20084.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

In revision 6067aaeadb5b3df26f27ac827256b1ef01e674f5, the function
intel_enable_clock_gating is split up by device. drm_i915_display_funcs then
gained a function pointer called init_clock_gating that intel_init_display
sets to the appropriate function. However, there are some code paths, notably
IS_PINEVIEW(dev), where init_clock_gating is not set and not needed. Calling
it then fails. This patch fixes it by simply adding a null-pointer check.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
---
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f553ddf..6809339 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7559,7 +7559,8 @@ void intel_init_clock_gating(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	dev_priv->display.init_clock_gating(dev);
+	if (dev_priv->display.init_clock_gating)
+		dev_priv->display.init_clock_gating(dev);
 
 	if (dev_priv->display.init_pch_clock_gating)
 		dev_priv->display.init_pch_clock_gating(dev);
