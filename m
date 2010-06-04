Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0FDHyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:54:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61674 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0FDHyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=kZvY1ReQF1njYH86RwB0AkdxupNVzQw/12Vr4UOtTEZBuvtF4ihA664Ygau++1fQLi
         MQ09cMs2lX/F9bf6EnNyHBXgjMlfpKdUIEZSlKKz+KLKen7p6T5Abb2qIJ43mXVOdItP
         Gn+j1TQzZF+BoCBgp3YnWXPHBufcEWdfirb/k=
Date: Fri, 4 Jun 2010 15:53:56 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Commit 9b8c4a0b215e603497daebe8ecbc9b1f0f035808 broken X11 pointer
Message-ID: <Pine.LNX.4.64.1006041547530.2447@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The following commit broke X11 mouse pointer. Symptom is "mouse pointer" 
on X11 cannot change "shape" when positioned to the frames of xterm 
window.

Reverting it makes it work again.

Running on X.Org X Server 1.8.99. Xterm 258. Lenovo X201s.


Thanks,
Jeff


commit 9b8c4a0b215e603497daebe8ecbc9b1f0f035808
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu May 27 14:21:01 2010 +0100

     drm/i915: Avoid moving from CPU domain during pwrite

     We can avoid an early clflush when pwriting if we use the current CPU
     write domain rather than moving the object to the GTT domain for the
     purposes of the pwrite. This has the advantage of not flushing the
     presumably hot data that we want to upload into the bo, and of ascribing
     the clflush to the execution when profiling.

     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
     Signed-off-by: Eric Anholt <eric@anholt.net>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 42866c0..4590c78 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -971,7 +971,8 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
  	if (obj_priv->phys_obj)
  		ret = i915_gem_phys_pwrite(dev, obj, args, file_priv);
  	else if (obj_priv->tiling_mode == I915_TILING_NONE &&
-		 dev->gtt_total != 0) {
+		 dev->gtt_total != 0 &&
+		 obj->write_domain != I915_GEM_DOMAIN_CPU) {
  		ret = i915_gem_gtt_pwrite_fast(dev, obj, args, file_priv);
  		if (ret == -EFAULT) {
  			ret = i915_gem_gtt_pwrite_slow(dev, obj, args,
