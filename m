Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0EKSiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:38:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab0EKSiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:38:54 -0400
Date: Tue, 11 May 2010 11:35:55 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: DRM Error on Acer Aspire One
Message-Id: <20100511113555.a78c9c8e.akpm@linux-foundation.org>
In-Reply-To: <89khjo$fd26d3@orsmga002.jf.intel.com>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	<89kc63$grtht6@fmsmga002.fm.intel.com>
	<20100511104818.8382a7de.akpm@linux-foundation.org>
	<89khjo$fd26d3@orsmga002.jf.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 19:19:26 +0100 Chris Wilson <chris@chris-wilson.co.uk> wrote:

> On Tue, 11 May 2010 10:48:18 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Tue, 11 May 2010 17:10:53 +0100 Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > 
> > > On Tue, 11 May 2010 20:30:07 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> > > > Hello,
> > > > 
> > > > With latest git kernel, I am getting following DRM error and not
> > > > getting XWindows :
> > > 
> > > [snip]
> > > 
> > > Hmm, there are still patches for capturing error state that haven't gone
> > > upstream, shame on me.
> > > 
> > > That error is a secondary issue to the GPU hang that is being reported. If
> > > it is a regression caused by a kernel update it would be very useful if
> > > you could bisect to the erroneous commit.
> > 
> > It helps if one reads the code and the trace...
> > 
> > i915_error_object_create() is using KM_USER0 from softirq context. 
> > That's a bug, and a pretty serious one.  If some innocent civilian is
> > writing highmem data to disk and this timer interrupt fires and trashes
> > his KM_USER0 slot, the disk contents will be corrupted.
> > 
> > Something like this...
> > 
> > --- a/drivers/gpu/drm/i915/i915_irq.c~a
> > +++ a/drivers/gpu/drm/i915/i915_irq.c
> > @@ -456,11 +456,15 @@ i915_error_object_create(struct drm_devi
> >  
> >  	for (page = 0; page < page_count; page++) {
> >  		void *s, *d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> > +		unsigned long flags;
> > +
> >  		if (d == NULL)
> >  			goto unwind;
> > -		s = kmap_atomic(src_priv->pages[page], KM_USER0);
> > +		local_irq_save(flags);
> > +		s = kmap_atomic(src_priv->pages[page], KM_IRQ0);
> >  		memcpy(d, s, PAGE_SIZE);
> > -		kunmap_atomic(s, KM_USER0);
> > +		kunmap_atomic(s, KM_IRQ0);
> > +		local_irq_restore(flags);
> >  		dst->pages[page] = d;
> >  	}
> >  	dst->page_count = page_count;
> > _
> > 
> > Please let's get a tested fix for this into 2.6.34.
> 
> The change that I actually want is to replace the kmap_atomic(cpu_page) with an
> io_mapping_map_atomic_wc(gtt_page), in case there is a incoherency between
> the CPU and the GPU, we want to record what the GPU executed. Do you know
> how if similar precautions are required with io_mapping_map_atomic_wc()?

gack, wtf is io_mapping_map_atomic_wc()?

<looks>

Could do with some interface documentation. Looks too large to be inlined.

No, io_mapping_map_atomic_wc() cannot be used from [soft]irq context:
it hardwires use of KM_USER0.  I suggest that io_mapping_create_wc(),
io_mapping_map_atomic_wc() etc be changed so that the caller passes in the
KM_foo kmap slot index.


