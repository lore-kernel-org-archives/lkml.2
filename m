Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1BRE5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:57:10 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:34182 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1BRE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:57:08 -0500
Message-ID: <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110217221329.GA3332@x61.home>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
    <20110216192658.GA7225@blimp.localdomain>
    <20110217221329.GA3332@x61.home>
Date: Fri, 18 Feb 2011 05:57:00 +0100 (CET)
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after 
     reopening lid
From: "Indan Zupancic" <indan@nul.nu>
To: "Alex Riesen" <raa.lkml@gmail.com>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: f0eed3f1d89bc5fb772880ef8d54351a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 17, 2011 23:13, Tino Keitel wrote:
> with kernel 2.6.37, the display brightness of my ThinkPad X61s was
> always reduced after lid open, resume from suspend etc.  With this
> patch on top of 2.6.38-rc5, the problem is gone.  Thanks.

Tino, I think Alex's patch only hides the problem and doesn't properly solve
the real bug. Can you confirm that this is the bit that fixes it for you?

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index c65992d..c4b1ca4 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -267,6 +235,9 @@ void intel_panel_enable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;

+	if (dev_priv->backlight_enabled)
+		return;
+
 	if (dev_priv->backlight_level == 0)
 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);

(Alex's patch edited by hand, offsets might be wrong.)

The other bits either don't change the logic, or should be harmless, or are
plain wrong, like setting the brightness to maximum at bootup.

If the above bit "fixes" it then it's because intel_panel_set_backlight() is called
less often, as that's the buggy function the problem doesn't show up (or is less
clear). Calling intel_panel_set_backlight() with the same value should keep the
brightness the same. Because of the buggy combination code it doesn't always.

Also, try suspending/resuming or "xset dpms force off/on" often in a loop with both
highest and lowest brightness and check if it works correctly with just Alex's patch.

Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447 fixes
it for you too? (Make sure you're at max brightness before rebooting.)

That said, the above bit of Alex's patch should be fine to apply, because it avoids
unnecessary register fiddling either way.

Greetings,

Indan


