Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2DKKjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:39:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57754 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2DKKjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:39:21 -0400
Date: Wed, 11 Apr 2012 12:40:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120411104012.GI4296@phenom.ffwll.local>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Slaby <jirislaby@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <4F758400.3080907@suse.cz>
 <1333104359_155028@CP5-2952>
 <20120409101119.47e770b2@jbarnes-desktop>
 <4F83F3B5.8080704@suse.cz>
 <20120410092619.26a15165@jbarnes-desktop>
 <4F8477D1.4080102@suse.cz>
 <20120410113448.540e4c1d@jbarnes-desktop>
 <4F848F88.7060009@suse.cz>
 <20120410203212.GN4115@phenom.ffwll.local>
 <20120410133411.52dc52ed@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410133411.52dc52ed@jbarnes-desktop>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 01:34:11PM -0700, Jesse Barnes wrote:
> On Tue, 10 Apr 2012 22:32:12 +0200
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Tue, Apr 10, 2012 at 09:52:40PM +0200, Jiri Slaby wrote:
> > > Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > > 
> > > I tried 3.2 and 3.3. Although the spurious interrupts were always
> > > there, they occurred with frequency lower by a magnitude (15 vs. 300
> > > after X starts). So I bisected that and it lead to a commit which
> > > fixes bad tiling for me:
> > > http://cgit.freedesktop.org/~ickle/linux-2.6/commit/?h=for-jiri&id=79710e6ccabdac80c65cd13b944695ecc3e42a9d
> > 
> > Pipelined fencing is pretty much just broken and we'll completely rip it
> > out in 3.5. Does this also happen with 3.4-rc2?
> 
> Does INTx- stay that way?  Or does it frequently read INTx+ if you
> sample it a lot?  If it stays as INTx-, then something other than the
> GPU is getting stuck (though it's possible this could be related to
> pipelined fencing, if the fences are programmed to point at some funky
> memory space).

Shot in the dark, let's disable msi a bit. Can you try the below patch?


diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 785f67f..249d5fe 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -2071,6 +2071,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	else if (IS_GEN5(dev))
 		i915_ironlake_get_mem_freq(dev);
 
+#if 0
 	/* On the 945G/GM, the chipset reports the MSI capability on the
 	 * integrated graphics even though the support isn't actually there
 	 * according to the published specs.  It doesn't appear to function
@@ -2084,6 +2085,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	 */
 	if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
+#endif
 
 	spin_lock_init(&dev_priv->gt_lock);
 	spin_lock_init(&dev_priv->irq_lock);
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
