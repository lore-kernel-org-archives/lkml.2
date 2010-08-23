Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0HWQOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:14:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43473 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab0HWQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=jrmObjVg5P0SIDdF1y+r6yyHloaUxRr89vPp6XxUDVtatMT+K1cscROFuz/VoNBB9P
         N7gBlcuErT0ieSeZpvb1qzNVtnO7hmTJiGWcXBHE+NKkI4XJ2myWIa+IjBK82SGai0GE
         QVff58tZxEZj72opcg8ZM3ebOjDRBNTCJl5tg=
Date: Mon, 23 Aug 2010 18:14:07 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zou Nan hai <nanhai.zou@intel.com>,
        Xiang Hai hao <haihao.xiang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] i915: signedness bugs in i915 ring buffer
Message-ID: <20100823161407.GB19909@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Zou Nan hai <nanhai.zou@intel.com>,
	Xiang Hai hao <haihao.xiang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ring->space" is unsigned so it's never less than zero.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 51e9c9e..a331898 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -208,9 +208,10 @@ static int init_ring_common(struct drm_device *dev,
 	else {
 		ring->head = ring->get_head(dev, ring);
 		ring->tail = ring->get_tail(dev, ring);
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		if (ring->head >= ring->tail + 8)
+			ring->space = ring->head - (ring->tail + 8);
+		else
+			ring->space = ring->head - (ring->tail + 8) + ring->size;
 	}
 	return 0;
 }
@@ -666,9 +667,10 @@ int intel_init_ring_buffer(struct drm_device *dev,
 	else {
 		ring->head = ring->get_head(dev, ring);
 		ring->tail = ring->get_tail(dev, ring);
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		if (ring->head >= ring->tail + 8)
+			ring->space = ring->head - (ring->tail + 8);
+		else
+			ring->space = ring->head - (ring->tail + 8) + ring->size;
 	}
 	INIT_LIST_HEAD(&ring->active_list);
 	INIT_LIST_HEAD(&ring->request_list);
@@ -735,9 +737,10 @@ int intel_wait_ring_buffer(struct drm_device *dev,
 	end = jiffies + 3 * HZ;
 	do {
 		ring->head = ring->get_head(dev, ring);
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		if (ring->head >= ring->tail + 8)
+			ring->space = ring->head - (ring->tail + 8);
+		else
+			ring->space = ring->head - (ring->tail + 8) + ring->size;
 		if (ring->space >= n) {
 			trace_i915_ring_wait_end (dev);
 			return 0;
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 44af317..707f32f 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -109,9 +109,10 @@ void i915_kernel_lost_context(struct drm_device * dev)
 
 	ring->head = I915_READ(PRB0_HEAD) & HEAD_ADDR;
 	ring->tail = I915_READ(PRB0_TAIL) & TAIL_ADDR;
-	ring->space = ring->head - (ring->tail + 8);
-	if (ring->space < 0)
-		ring->space += ring->size;
+	if (ring->head >= ring->tail + 8)
+		ring->space = ring->head - (ring->tail + 8);
+	else
+		ring->space = ring->head - (ring->tail + 8) + ring->size;
 
 	if (!dev->primary->master)
 		return;
