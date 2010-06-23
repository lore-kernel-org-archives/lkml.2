Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0FWLWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:22:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53974 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0FWLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=nElTKouLgfEPQrS+qSj6p+JNTxeTmMkrpskXJHKhCYRwfifikXSa7UwiSzVl9489ST
         gTvkYQT//b9eWXiIv4qfk+tLrqAl6FDEE3ZDdqzLN1hZh+JZ7cT5TXqBkVZI8RpPXCWm
         XN+JGKOJ8jD4naIpCeNqqs3myDneHJXZjx9JQ=
Date: Wed, 23 Jun 2010 13:19:55 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, nanhai.zou@intel.com,
       Benny Halevy <bhalevy@panasas.com>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: [patch] i915: take struct_mutex in i915_dma_cleanup()
Message-ID: <20100623111954.GA16433@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Zhenyu Wang <zhenyuw@linux.intel.com>, nanhai.zou@intel.com,
	Benny Halevy <bhalevy@panasas.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_cleanup_ring_buffer() calls drm_gem_object_unreference() (as
opposed to drm_gem_object_unreference_unlocked()) so it needs to be
called with "struct_mutex" held.  If we don't hold the lock, it triggers
a BUG_ON(!mutex_is_locked(&dev->struct_mutex));

I also audited the other places that call intel_cleanup_ring_buffer()
and they all hold the lock so they're OK.

This was introduced in: 8187a2b70e3 "drm/i915: introduce
intel_ring_buffer structure (V2)" and it's a regression from v2.6.34.

Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=16247

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reported-by: Benny Halevy <bhalevy@panasas.com>
Tested-by: Benny Halevy <bhalevy@panasas.com>

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 59a2bf8..3325af1 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -128,9 +128,11 @@ static int i915_dma_cleanup(struct drm_device * dev)
 	if (dev->irq_enabled)
 		drm_irq_uninstall(dev);
 
+	mutex_lock(&dev->struct_mutex);
 	intel_cleanup_ring_buffer(dev, &dev_priv->render_ring);
 	if (HAS_BSD(dev))
 		intel_cleanup_ring_buffer(dev, &dev_priv->bsd_ring);
+	mutex_unlock(&dev->struct_mutex);
 
 	/* Clear the HWS virtual address at teardown */
 	if (I915_NEED_GFX_HWS(dev))

