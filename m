Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0L2V77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:59:59 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37728 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753807Ab0L2V76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:59:58 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Dec 2010 16:59:58 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UA1hkFu/xWpC5PK3Rgb0Q0INgEd237HyyH3E73Mqhi6VuXBWZnvK7GWwJGQpiwUE44Cp/VCXNJhIhD7p7+bRUw5VxscORNgIDsM2qQSiGwhoPhf2eiZzw3TM9jMYybjB;
Date: Wed, 29 Dec 2010 13:53:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <20101229135315.5fe5c4e5@jbarnes-desktop>
In-Reply-To: <20101229131852.0792aac0@jbarnes-desktop>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Doesn't change anything here. Display stays blank.
> 
> Sounds like your problem is separate from SSC then, more likely related
> to panel power or backlight control.  Have you tried bisecting for the
> problem between 2.6.35 and 2.6.36?

Nevermind, I just checked out the bug, looks like it is panel power
related.  Can you try this patch?

If it doesn't work, can you send me the output of intel_reg_dumper from
before you turn off the display and after you try to turn it back on?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index aa23070..830e3b0 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -82,8 +82,6 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 		lvds_reg = LVDS;
 	}
 
-	I915_WRITE(lvds_reg, I915_READ(lvds_reg) | LVDS_PORT_EN);
-
 	if (intel_lvds->pfit_dirty) {
 		/*
 		 * Enable automatic panel scaling so that non-native modes
@@ -104,7 +102,7 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 	}
 
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
-	POSTING_READ(lvds_reg);
+	POSTING_READ(ctl_reg);
 
 	intel_panel_set_backlight(dev, dev_priv->backlight_level);
 }
@@ -136,8 +134,7 @@ static void intel_lvds_disable(struct intel_lvds *intel_lvds)
 		intel_lvds->pfit_dirty = true;
 	}
 
-	I915_WRITE(lvds_reg, I915_READ(lvds_reg) & ~LVDS_PORT_EN);
-	POSTING_READ(lvds_reg);
+	POSTING_READ(ctl_reg);
 }
 
 static void intel_lvds_dpms(struct drm_encoder *encoder, int mode)
