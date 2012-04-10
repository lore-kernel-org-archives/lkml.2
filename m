Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2DJUbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:31:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61789 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab2DJUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:31:20 -0400
Date: Tue, 10 Apr 2012 22:32:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120410203212.GN4115@phenom.ffwll.local>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Slaby <jirislaby@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <4F717CE3.4040206@suse.cz>
 <4F717D80.9040207@suse.cz>
 <4F758400.3080907@suse.cz>
 <1333104359_155028@CP5-2952>
 <20120409101119.47e770b2@jbarnes-desktop>
 <4F83F3B5.8080704@suse.cz>
 <20120410092619.26a15165@jbarnes-desktop>
 <4F8477D1.4080102@suse.cz>
 <20120410113448.540e4c1d@jbarnes-desktop>
 <4F848F88.7060009@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F848F88.7060009@suse.cz>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 09:52:40PM +0200, Jiri Slaby wrote:
> On 04/10/2012 08:34 PM, Jesse Barnes wrote:
> > On Tue, 10 Apr 2012 20:11:29 +0200 Jiri Slaby <jslaby@suse.cz>
> > wrote:
> > 
> >> On 04/10/2012 06:26 PM, Jesse Barnes wrote:
> >>> So port hotplug is always reporting that port C has a hotplug 
> >>> interrupt though...  If you write 0x3 back to it does the
> >>> interrupt stop?
> >> 
> >> I'm not sure I got it right. This doesn't help: ---
> >> a/drivers/gpu/drm/i915/i915_irq.c +++
> >> b/drivers/gpu/drm/i915/i915_irq.c @@ -1416,6 +1416,17 @@ static
> >> irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS) iir = new_iir; 
> >> }
> >> 
> >> +       if (ret == IRQ_NONE) { +               u32 hp =
> >> I915_READ(PORT_HOTPLUG_STAT); +               if (hp) { +
> >> I915_WRITE(PORT_HOTPLUG_STAT, hp); +
> >> I915_READ(PORT_HOTPLUG_STAT); +               } + +
> >> if (printk_ratelimit()) +                       printk(KERN_DEBUG
> >> "%s: %.8x\n", __func__, hp); + +       }
> >> 
> >> return ret; }
> > 
> > Yeah that looks right, you still get 0x300?
> 
> Yes.
> 
> > You could try masking hotplug interrupts altogether.
> 
> This doesn't help:
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -2049,7 +2051,7 @@ static int i915_driver_irq_postinstall(struct
> drm_device *dev)
>         I915_WRITE(IER, enable_mask);
>         POSTING_READ(IER);
> 
> -       if (I915_HAS_HOTPLUG(dev)) {
> +       if (0 && I915_HAS_HOTPLUG(dev)) {
>                 u32 hotplug_en = I915_READ(PORT_HOTPLUG_EN);
> 
>                 /* Note HDMI and DP share bits */
> 
> 
> > Also, just to sanity check things, can you look at the output of
> > "lspci -s 02.0 -vvv -xxx" and see if the "INTx" field is + or -?
> > If it's +, then the interrupt is definitely coming from an un-acked
> > IRQ source on the gfx device.  If it's INTx-, it means something in
> > one of the upper MSI layers isn't getting handled right.
> 
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> I tried 3.2 and 3.3. Although the spurious interrupts were always
> there, they occurred with frequency lower by a magnitude (15 vs. 300
> after X starts). So I bisected that and it lead to a commit which
> fixes bad tiling for me:
> http://cgit.freedesktop.org/~ickle/linux-2.6/commit/?h=for-jiri&id=79710e6ccabdac80c65cd13b944695ecc3e42a9d

Pipelined fencing is pretty much just broken and we'll completely rip it
out in 3.5. Does this also happen with 3.4-rc2?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
