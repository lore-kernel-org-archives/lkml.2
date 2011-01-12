Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1ALWWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:22:12 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:60716 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750977Ab1ALWWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:22:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dscpFKjHOJLpcM+jFdudNLlhuYPYKE+JtsCPf1udRvMMUQMWXjpj375OHOXW0WhrvhTlBKKmhx3uMZL6VUNCNiasnTJ1afVciDILNVb+zWCTrgUB/p1dROvw6PFtmbjh;
Date: Wed, 12 Jan 2011 14:22:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm intel only fixes
Message-ID: <20110112142206.37a1b76d@jbarnes-desktop>
In-Reply-To: <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
	<AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
	<20110112114649.5365d518@jbarnes-desktop>
	<AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
	<AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 13:28:53 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jan 12, 2011 at 12:27 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Jan 12, 2011 at 11:46 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >>
> >> Since I doubt we're actually offloading to our video decode kernels for
> >> Flash video on your machine
> >
> > It's the latest 64-bit beta flash player, so maybe it does use hw acceleration.
> >
> >
> >>                       it could very well be a memory bw issue.
> >> Can you try this small patch to see if one of the low power watermarks
> >> is giving you trouble (note: cut & pasted)?
> >
> > No difference.
> 
> Oh, and I'm also seeing corruption on my sandybridge machine. No video
> involved, the gdm login screen is already corrupted this way. Similar
> odd shifted lines etc, so I'd assume it's related.

Ah, ok.  So it could be our internal FDI link is underrunning; it goes
between the CPU and PCH and carries display bits.

Are these both desktop type machines with DVI attached monitors?

If it's an FDI or transcoder problem, something like the below may give
us more info.

Can you take a picture of the corruption?  If I see it I can try to
reproduce it here by messing with FDI, transcoder, and DP link settings
to see if they're the problem.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index e418e8b..4c6c465 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -428,6 +428,15 @@ static void pch_irq_handler(struct drm_device *dev)
 		fdia = I915_READ(FDI_RXA_IIR);
 		fdib = I915_READ(FDI_RXB_IIR);
 		DRM_DEBUG_DRIVER("PCH FDI RX interrupt; FDI RXA IIR: 0x%08x, FDI RXB IIR: 0x%08x\n", fdia, fdib);
+
+		if (fdia & FDI_RX_ERR_MASK) {
+			DRM_ERROR("FDI A RX error: 0x%08x\n", fdia);
+			I915_WRITE(FDI_RXA_IIR, FDI_RX_ERR_MASK);
+		}
+		if (fdib & FDI_RX_ERR_MASK) {
+			DRM_ERROR("FDI B RX error: 0x%08x\n", fdib);
+			I915_WRITE(FDI_RXB_IIR, FDI_RX_ERR_MASK);
+		}
 	}
 
 	if (pch_iir & (SDE_TRANSB_CRC_DONE | SDE_TRANSA_CRC_DONE))
@@ -437,9 +446,9 @@ static void pch_irq_handler(struct drm_device *dev)
 		DRM_DEBUG_DRIVER("PCH transcoder CRC error interrupt\n");
 
 	if (pch_iir & SDE_TRANSB_FIFO_UNDER)
-		DRM_DEBUG_DRIVER("PCH transcoder B underrun interrupt\n");
+		DRM_ERROR("PCH transcoder B underrun interrupt\n");
 	if (pch_iir & SDE_TRANSA_FIFO_UNDER)
-		DRM_DEBUG_DRIVER("PCH transcoder A underrun interrupt\n");
+		DRM_ERROR("PCH transcoder A underrun interrupt\n");
 }
 
 static irqreturn_t ironlake_irq_handler(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 40a407f..6e81d97 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3101,6 +3101,11 @@
 #define FDI_RX_PIXEL_FIFO_OVERFLOW      (1<<2)
 #define FDI_RX_CROSS_CLOCK_OVERFLOW     (1<<1)
 #define FDI_RX_SYMBOL_QUEUE_OVERFLOW    (1<<0)
+#define FDI_RX_ERR_MASK (FDI_RX_FS_CODE_ERR | FDI_RX_FE_CODE_ERR |	\
+			 FDI_RX_SYMBOL_ERR_RATE_ABOVE |			\
+			 FDI_RX_PIXEL_FIFO_OVERFLOW |			\
+			 FDI_RX_CROSS_CLOCK_OVERFLOW |			\
+			 FDI_RX_SYMBOL_QUEUE_OVERFLOW)
 
 #define FDI_RXA_IIR             0xf0014
 #define FDI_RXA_IMR             0xf0018
