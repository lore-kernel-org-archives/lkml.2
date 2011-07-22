Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1GVUYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:24:55 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:48339 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab1GVUYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:24:54 -0400
Date: Sat, 23 Jul 2011 00:23:36 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Keith Packard <keithp@keithp.com>
Cc: Pekka Enberg <penberg@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Luke-Jr <luke@dashjr.org>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
Message-ID: <20110722202336.GA14375@tugrik.mns.mnsspb.ru>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru> <yun7h7atcty.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun7h7atcty.fsf@aiko.keithp.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith,

first of all thanks for your prompt reply. Then...

On Fri, Jul 22, 2011 at 11:00:41AM -0700, Keith Packard wrote:
> On Fri, 22 Jul 2011 15:08:06 +0400, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> 
> > And now after v3.0 is out, I've tested it again, and yes, like it was
> > broken on v3.0-rc5, it is (now even more) broken on v3.0 -- after first
> > bad io access the system freezes completely:
> 
> I looked at this when I first saw it (a couple of weeks ago), and I
> couldn't see any obvious reason this patch would cause this particular
> problem. I didn't want to revert the patch at that point as I feared it
> would cause other subtle problems. Given that you've got a work-around,
> it seemed best to just push this off past 3.0.

What kind of a workaround are you talking about? Sorry, to me it all
looked like "UMS is being ignored forever". Anyway, let's move on to try
to solve the issue.


> Given the failing address passed to ioread32, this seems like it's
> probably the call to READ_BREADCRUMB -- I915_BREADCRUMB_INDEX is 0x21,
> which is an offset in 32-bit units within the hardware status page. If
> the status_page.page_addr value was zero, then the computed address
> would end up being 0x84.
> 
> And, it looks like status_page.page_addr *will* end up being zero as a
> result of the patch in question. The patch resets the entire ring
> structure contents back to the initial values, which includes smashing
> the status_page structure to zero, clearing the value of
> status_page.page_addr set in i915_init_phys_hws.
> 
> Here's an untested patch which moves the initialization of
> status_page.page_addr into intel_render_ring_init_dri. I note that
> intel_init_render_ring_buffer *already* has the setting of the
> status_page.page_addr value, and so I've removed the setting of
> status_page.page_addr from i915_init_phys_hws.
> 
> I suspect we could remove the memset from intel_init_render_ring_buffer;
> it seems entirely superfluous given the memset in i915_init_phys_hws.
> 
> From 159ba1dd207fc52590ce8a3afd83f40bd2cedf46 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Fri, 22 Jul 2011 10:44:39 -0700
> Subject: [PATCH] drm/i915: Initialize RCS ring status page address in
>  intel_render_ring_init_dri
> 
> Physically-addressed hardware status pages are initialized early in
> the driver load process by i915_init_phys_hws. For UMS environments,
> the ring structure is not initialized until the X server starts. At
> that point, the entire ring structure is re-initialized with all new
> values. Any values set in the ring structure (including
> ring->status_page.page_addr) will be lost when the ring is
> re-initialized.
> 
> This patch moves the initialization of the status_page.page_addr value
> to intel_render_ring_init_dri.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_dma.c         |    6 ++----
>  drivers/gpu/drm/i915/intel_ringbuffer.c |    3 +++
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 1271282..8a3942c 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -61,7 +61,6 @@ static void i915_write_hws_pga(struct drm_device *dev)
>  static int i915_init_phys_hws(struct drm_device *dev)
>  {
>  	drm_i915_private_t *dev_priv = dev->dev_private;
> -	struct intel_ring_buffer *ring = LP_RING(dev_priv);
>  
>  	/* Program Hardware Status Page */
>  	dev_priv->status_page_dmah =
> @@ -71,10 +70,9 @@ static int i915_init_phys_hws(struct drm_device *dev)
>  		DRM_ERROR("Can not allocate hardware status page\n");
>  		return -ENOMEM;
>  	}
> -	ring->status_page.page_addr =
> -		(void __force __iomem *)dev_priv->status_page_dmah->vaddr;
>  
> -	memset_io(ring->status_page.page_addr, 0, PAGE_SIZE);
> +	memset_io((void __force __iomem *)dev_priv->status_page_dmah->vaddr,
> +		  0, PAGE_SIZE);
>  
>  	i915_write_hws_pga(dev);
>  
> diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
> index e961568..47b9b27 100644
> --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> @@ -1321,6 +1321,9 @@ int intel_render_ring_init_dri(struct drm_device *dev, u64 start, u32 size)
>  		ring->get_seqno = pc_render_get_seqno;
>  	}
>  
> +	if (!I915_NEED_GFX_HWS(dev))
> +		ring->status_page.page_addr = dev_priv->status_page_dmah->vaddr;
> +
>  	ring->dev = dev;
>  	INIT_LIST_HEAD(&ring->active_list);
>  	INIT_LIST_HEAD(&ring->request_list);

I can't tell whether this is correct, because intel gfx driver is
unknown to me, but from the first glance your description sounds reasonable.

I'm out of office till ~ next week's tuesday, and on return I'll try
to test it on the hardware in question.


Thanks again,
Kirill
