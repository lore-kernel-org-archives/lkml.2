Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506Ab2FHIHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:07:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40562 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108Ab2FHIG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:06:57 -0400
Date: Fri, 8 Jun 2012 10:06:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>, Rus <rus@sfinxsoft.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>
Subject: Re: lockdep and kmemcheck
Message-ID: <20120608080651.GA9109@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Rus <rus@sfinxsoft.com>,
	linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <cl@linux.com>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
 <20120607142459.GB5053@x1.osrc.amd.com>
 <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
 <20120607151352.GA8261@x1.osrc.amd.com>
 <CAKgfjTn67KwR7-+icNZm7e5ZRfjqt1159kWMYD6S83WuhNfprQ@mail.gmail.com>
 <20120607193331.GA20723@liondog.tnic>
 <1339142536.23343.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339142536.23343.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:02:16AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-07 at 21:33 +0200, Borislav Petkov wrote:
> > > WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc+0xcd/0xd0()
> > > Hardware name: To be filled by O.E.M.
> > > Modules linked in:
> > > Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1 #3
> > > Call Trace:
> > >  [<ffffffff8104123a>] warn_slowpath_common+0x7a/0xb0
> > >  [<ffffffff81041285>] warn_slowpath_null+0x15/0x20
> > >  [<ffffffff81096f2d>] lockdep_trace_alloc+0xcd/0xd0
> > >  [<ffffffff810ee48e>] __alloc_pages_nodemask+0x7e/0x890
> > >  [<ffffffff810ee599>] ? __alloc_pages_nodemask+0x189/0x890
> > >  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> > >  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> > >  [<ffffffff815c07d0>] ? error_exit+0x30/0xb0
> > >  [<ffffffff811260c9>] kmemcheck_alloc_shadow+0x29/0xb0
> > >  [<ffffffff8112409a>] new_slab+0x1fa/0x2e0
> > >  [<ffffffff815b70ec>] __slab_alloc.isra.51.constprop.55+0x3e8/0x40e
> > >  [<ffffffff815c07d0>] ? error_exit+0x30/0xb0
> > >  [<ffffffff811251f7>] kmem_cache_alloc+0x87/0xb0
> > >  [<ffffffff8126d7c0>] idr_pre_get+0x60/0x90
> > >  [<ffffffff8126dd8b>] ida_pre_get+0x1b/0x90
> > >  [<ffffffff810593b2>] create_worker+0x42/0x170
> > >  [<ffffffff81ae441d>] init_workqueues+0x1f2/0x393
> > >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> > >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> > >  [<ffffffff81002122>] do_one_initcall+0x122/0x180
> > >  [<ffffffff81acbc7a>] kernel_init+0x9b/0x1f6
> > >  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
> > >  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
> > >  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
> > >  [<ffffffff815c1f70>] ? gs_change+0x13/0x13 
> 
> Using SLUB are you?

Who, mee? Nah :-)

Rus reported this WARN while testing -rc1.

> Looks like SLUB is buggy here.. does this fix it?

@Rus: can you apply the patch below ontop of -rc1 and retest with the
same BIOS settings and kernel .config you used to trigger the above?

Don't hesitate to ask questions if you don't know how to apply patches,
build kernels, etc.

> ---
>  mm/slub.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fb2ef09..6b9e3f6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1314,13 +1314,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  			stat(s, ORDER_FALLBACK);
>  	}
>  
> -	if (flags & __GFP_WAIT)
> -		local_irq_disable();
> -
> -	if (!page)
> -		return NULL;
> -
> -	if (kmemcheck_enabled
> +	if (page && kmemcheck_enabled
>  		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>  		int pages = 1 << oo_order(oo);
>  
> @@ -1336,6 +1330,12 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  			kmemcheck_mark_unallocated_pages(page, pages);
>  	}
>  
> +	if (flags & __GFP_WAIT)
> +		local_irq_disable();
> +
> +	if (!page)
> +		return NULL;
> +
>  	page->objects = oo_objects(oo);
>  	mod_zone_page_state(page_zone(page),
>  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
> 
> 

Thanks.

-- 
Regards/Gruss,
    Boris.
