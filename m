Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1FOUdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:33:04 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51064 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751357Ab1FOUdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:33:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AviXFUh2GcrGKBRm5Ix56nM/OaUrKCX2hQKsJkGlX5yb5gHFOFjD20LqDAUx1tyu40AcRYmQmpPM1mooiaUUsCnN1tkTSAmJg13VO4+qYdfGDo8VLIadyIVJ3c4WeHqy;
Date: Wed, 15 Jun 2011 13:32:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Keith Packard <keithp@keithp.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Oops in i915 intel_init_clock_gating
Message-ID: <20110615133256.113293a0@jbarnes-desktop>
In-Reply-To: <Pine.LNX.4.44L0.1106151555400.1650-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1106151555400.1650-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 16:08:51 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> The problem of dev_priv->display.init_clock_gating not getting set is 
> still present in 3.0-rc3.  On my system this happens because 
> intel_init_display() never gets called in the first place.
> 
> AFAICT, the normal calling sequence during driver initialization is:
> 
> 	i915_driver_load() -> i915_load_modeset_init() ->
> 		intel_modeset_init() -> intel_init_display().
> 
> But in my case the call to i915_load_modeset_init() doesn't occur 
> because drm_core_check_feature(dev, DRIVER_MODESET) is False.

Ouch, a non-KMS config.  Any reason you can't use KMS?

This patch should help at any rate.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 0defd42..a1a28fb 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -429,6 +429,9 @@ static int i915_drm_thaw(struct drm_device *dev)
 	/* KMS EnterVT equivalent */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		mutex_lock(&dev->struct_mutex);
+
+		intel_init_clock_gating(dev);
+
 		dev_priv->mm.suspended = 0;
 
 		error = i915_gem_init_ringbuffer(dev);
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 60a94d2..b478d16 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -863,8 +863,6 @@ int i915_restore_state(struct drm_device *dev)
 		I915_WRITE(IMR, dev_priv->saveIMR);
 	}
 
-	intel_init_clock_gating(dev);
-
 	if (IS_IRONLAKE_M(dev)) {
 		ironlake_enable_drps(dev);
 		intel_init_emon(dev);

