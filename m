Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2FOABL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:01:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab2FOABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:01:05 -0400
Message-Id: <20120614235627.349117919@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 39/42] drm/i915: Mark the ringbuffers as being in the GTT domain
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 3eef8918ff440837f6af791942d8dd07e1a268ee upstream.

By correctly describing the rinbuffers as being in the GTT domain, it
appears that we are more careful with the management of the CPU cache
upon resume and so prevent some coherency issue when submitting commands
to the GPU later. A secondary effect is that the debug logs are then
consistent with the actual usage (i.e. they no longer describe the
ringbuffers as being in the CPU write domain when we are accessing them
through an wc iomapping.)

Reported-and-tested-by: Daniel Gnoutcheff <daniel@gnoutcheff.name>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41092
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1027,6 +1027,10 @@ int intel_init_ring_buffer(struct drm_de
 	if (ret)
 		goto err_unref;
 
+	ret = i915_gem_object_set_to_gtt_domain(obj, true);
+	if (ret)
+		goto err_unpin;
+
 	ring->map.size = ring->size;
 	ring->map.offset = dev->agp->base + obj->gtt_offset;
 	ring->map.type = 0;


