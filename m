Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2EYHeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:34:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61476 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2EYHeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:34:21 -0400
Date: Fri, 25 May 2012 09:35:40 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: drm: add helper to clflush a virtual address range
Message-ID: <20120525073540.GB4726@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20120524195529.234567C007E@ra.kernel.org>
 <20120525052432.GA15480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525052432.GA15480@kroah.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, May 25, 2012 at 02:24:32PM +0900, Greg KH wrote:
> I see you say you wanted the patch below for the stable tree, due to
> some later patch needing it, yet this patch was not "marked" for the
> stable tree, and I can't seem to figure out which "later patch" you are
> referring to here.
> 
> Any hints on what I should do for the 3.4-stable kernel tree with this?

Oops, I've changed plans for that bug and sent a more minimal patch that
simply covers over the problem rather well than fixes it 100% perfect.
I've dropped the Cc: stable, bug forgot to adjust the commit message.

So this patch isn't for stable any more, sorry for wasting your time.

Yours, Daniel

> 
> thanks,
> 
> greg k-h
> 
> On Thu, May 24, 2012 at 07:55:29PM +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=6d5cd9cb1e32e4f4e4468704430b26bcb0bfb129
> > Commit:     6d5cd9cb1e32e4f4e4468704430b26bcb0bfb129
> > Parent:     dbf7bff074d5fdc87c61b1b41d8e809109cf0bf8
> > Author:     Daniel Vetter <daniel.vetter@ffwll.ch>
> > AuthorDate: Sun Mar 25 19:47:30 2012 +0200
> > Committer:  Daniel Vetter <daniel.vetter@ffwll.ch>
> > CommitDate: Tue Mar 27 13:19:45 2012 +0200
> > 
> >     drm: add helper to clflush a virtual address range
> >     
> >     Useful when the page is already mapped to copy date in/out.
> >     
> >     For -stable because the next patch (fixing phys obj pwrite) needs this
> >     little helper function.
> >     
> >     Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
> >     Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> >     Cc: dri-devel@lists.freedesktop.org
> >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/drm_cache.c |   23 +++++++++++++++++++++++
> >  include/drm/drmP.h          |    1 +
> >  2 files changed, 24 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
> > index 5928653..c7c8f6b 100644
> > --- a/drivers/gpu/drm/drm_cache.c
> > +++ b/drivers/gpu/drm/drm_cache.c
> > @@ -98,3 +98,26 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
> >  #endif
> >  }
> >  EXPORT_SYMBOL(drm_clflush_pages);
> > +
> > +void
> > +drm_clflush_virt_range(char *addr, unsigned long length)
> > +{
> > +#if defined(CONFIG_X86)
> > +	if (cpu_has_clflush) {
> > +		char *end = addr + length;
> > +		mb();
> > +		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
> > +			clflush(addr);
> > +		clflush(end - 1);
> > +		mb();
> > +		return;
> > +	}
> > +
> > +	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
> > +		printk(KERN_ERR "Timed out waiting for cache flush.\n");
> > +#else
> > +	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
> > +	WARN_ON_ONCE(1);
> > +#endif
> > +}
> > +EXPORT_SYMBOL(drm_clflush_virt_range);
> > diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> > index 92f0981..d33597b 100644
> > --- a/include/drm/drmP.h
> > +++ b/include/drm/drmP.h
> > @@ -1332,6 +1332,7 @@ extern int drm_remove_magic(struct drm_master *master, drm_magic_t magic);
> >  
> >  /* Cache management (drm_cache.c) */
> >  void drm_clflush_pages(struct page *pages[], unsigned long num_pages);
> > +void drm_clflush_virt_range(char *addr, unsigned long length);
> >  
> >  				/* Locking IOCTL support (drm_lock.h) */
> >  extern int drm_lock(struct drm_device *dev, void *data,
> > --
> > To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
