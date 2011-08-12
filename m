Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1HNQ1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:27:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab1HNQHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.416104190@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keith Packard <keithp@keithp.com>
Subject: [26/90] drm/i915: Initialize RCS ring status page address in intel_render_ring_init_dri
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

commit f3234706a77bd6e1592ae71fb3268e04cb030dba upstream.

Physically-addressed hardware status pages are initialized early in
the driver load process by i915_init_phys_hws. For UMS environments,
the ring structure is not initialized until the X server starts. At
that point, the entire ring structure is re-initialized with all new
values. Any values set in the ring structure (including
ring->status_page.page_addr) will be lost when the ring is
re-initialized.

This patch moves the initialization of the status_page.page_addr value
to intel_render_ring_init_dri.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c         |    6 ++----
 drivers/gpu/drm/i915/intel_ringbuffer.c |    3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -61,7 +61,6 @@ static void i915_write_hws_pga(struct dr
 static int i915_init_phys_hws(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_ring_buffer *ring = LP_RING(dev_priv);
 
 	/* Program Hardware Status Page */
 	dev_priv->status_page_dmah =
@@ -71,10 +70,9 @@ static int i915_init_phys_hws(struct drm
 		DRM_ERROR("Can not allocate hardware status page\n");
 		return -ENOMEM;
 	}
-	ring->status_page.page_addr =
-		(void __force __iomem *)dev_priv->status_page_dmah->vaddr;
 
-	memset_io(ring->status_page.page_addr, 0, PAGE_SIZE);
+	memset_io((void __force __iomem *)dev_priv->status_page_dmah->vaddr,
+		  0, PAGE_SIZE);
 
 	i915_write_hws_pga(dev);
 
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1319,6 +1319,9 @@ int intel_render_ring_init_dri(struct dr
 		ring->get_seqno = pc_render_get_seqno;
 	}
 
+	if (!I915_NEED_GFX_HWS(dev))
+		ring->status_page.page_addr = dev_priv->status_page_dmah->vaddr;
+
 	ring->dev = dev;
 	INIT_LIST_HEAD(&ring->active_list);
 	INIT_LIST_HEAD(&ring->request_list);


