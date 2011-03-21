Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1CUXRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:17:49 -0400
Received: from kroah.org ([198.145.64.141]:52550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab1CUXRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:23 2011
Message-Id: <20110321230323.291383196@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [16/78] drm/i915: Replace vblank PM QoS with "Interrupt-Based AGPBUSY#"
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 8692d00e996ed2a6560702623e5cb646da0f9767 upstream.

I stumbled over this magic bit in the gen3 INSTPM:

Bit11 Interrupt-Based AGPBUSY# Enable:

‘0’ = Pending GMCH interrupts will not cause AGPBUSY# assertion.
‘1’ = Pending GMCH interrupts will cause AGPBUSY# assertion and hence
      can cause the CPU to exit C3.  There is no suppression of cacheable
      writes.

Note that in either case in C3 the interrupts are not lost. They will be
forwarded to the ICH when the GMCH is out of C3.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |    9 +++++++++
 drivers/gpu/drm/i915/i915_reg.h |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1377,7 +1377,12 @@ int i915_enable_vblank(struct drm_device
 	else
 		i915_enable_pipestat(dev_priv, pipe,
 				     PIPE_VBLANK_INTERRUPT_ENABLE);
+
+	/* maintain vblank delivery even in deep C-states */
+	if (dev_priv->info->gen == 3)
+		I915_WRITE(INSTPM, INSTPM_AGPBUSY_DIS << 16);
 	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
+
 	return 0;
 }
 
@@ -1390,6 +1395,10 @@ void i915_disable_vblank(struct drm_devi
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
+	if (dev_priv->info->gen == 3)
+		I915_WRITE(INSTPM,
+			   INSTPM_AGPBUSY_DIS << 16 | INSTPM_AGPBUSY_DIS);
+
 	if (HAS_PCH_SPLIT(dev))
 		ironlake_disable_display_irq(dev_priv, (pipe == 0) ?
 					     DE_PIPEA_VBLANK: DE_PIPEB_VBLANK);
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -405,9 +405,12 @@
 #define   I915_ERROR_INSTRUCTION			(1<<0)
 #define INSTPM	        0x020c0
 #define   INSTPM_SELF_EN (1<<12) /* 915GM only */
+#define   INSTPM_AGPBUSY_DIS (1<<11) /* gen3: when disabled, pending interrupts
+					will not assert AGPBUSY# and will only
+					be delivered when out of C3. */
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
-#define FW_BLC2	 	0x020dc
+#define FW_BLC2		0x020dc
 #define FW_BLC_SELF	0x020e0 /* 915+ only */
 #define   FW_BLC_SELF_EN_MASK      (1<<31)
 #define   FW_BLC_SELF_FIFO_MASK    (1<<16) /* 945 only */


