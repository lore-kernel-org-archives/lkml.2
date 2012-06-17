Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2FQSWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50070 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757849Ab2FQSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:21:59 -0400
Message-Id: <20120617175941.500052113@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 01/69] drm/i915: Mark the ringbuffers as being in the GTT domain
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1045,6 +1045,10 @@
 	if (ret)
 		goto err_unref;
 
+	ret = i915_gem_object_set_to_gtt_domain(obj, true);
+	if (ret)
+		goto err_unpin;
+
 	ring->map.size = ring->size;
 	ring->map.offset = dev->agp->base + obj->gtt_offset;
 	ring->map.type = 0;


