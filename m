Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2GBX4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 19:56:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48799 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2GBX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 19:56:37 -0400
Date: Mon, 2 Jul 2012 20:56:32 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pravin B Shelar <pshelar@nicira.com>,
        Amey Bhide <abhide@nicira.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [ 07/48] mm: fix slab->page _count corruption when using slub
Message-ID: <20120702235631.GC3552@herton-Z68MA-D2H-B3>
References: <20120701172006.535271340@decadent.org.uk>
 <20120701172007.694144055@decadent.org.uk>
 <20120702234610.GB3552@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702234610.GB3552@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 08:46:12PM -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, Jul 01, 2012 at 06:20:13PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Pravin B Shelar <pshelar@nicira.com>
> > 
> > commit abca7c4965845924f65d40e0aa1092bdd895e314 upstream.
> > 
> > On arches that do not support this_cpu_cmpxchg_double() slab_lock is used
> > to do atomic cmpxchg() on double word which contains page->_count.  The
> > page count can be changed from get_page() or put_page() without taking
> > slab_lock.  That corrupts page counter.
> > 
> > Fix it by moving page->_count out of cmpxchg_double data.  So that slub
> > does no change it while updating slub meta-data in struct page.
> 
> Hi,
> 
> I got a frozen machine on boot with 3.2.22 proposed patches, bisect
> pointed out to this commit (and reverting only this commit on top of
> 3.2.22 patches confirmed it). So far I was able to reproduce always.
> 
> Only happened with an x86_64 kernel, gzipped config attached. Using
> earlyprintk=vga, I'm able to see the boot process is stuck just right
> after "Memory: ...k available..." message (right before SLUB prints
> its initialization message).

So, 3.2 didn't have the CONFIG_HAVE_CMPXCHG_DOUBLE and
CONFIG_HAVE_ALIGNED_STRUCT_PAGE defines, it had instead CMPXCHG_DOUBLE
and HAVE_ALIGNED_STRUCT_PAGE is a new logic. So the patch is broken for
3.2 indeed.

> 
> > 
> > [akpm@linux-foundation.org: use standard comment layout, tweak comment text]
> > Reported-by: Amey Bhide <abhide@nicira.com>
> > Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
> > Acked-by: Christoph Lameter <cl@linux.com>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  include/linux/mm_types.h |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index dad95bd..704a626 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -57,8 +57,18 @@ struct page {
> >  		};
> >  
> >  		union {
> > +#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
> > +	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
> >  			/* Used for cmpxchg_double in slub */
> >  			unsigned long counters;
> > +#else
> > +			/*
> > +			 * Keep _count separate from slub cmpxchg_double data.
> > +			 * As the rest of the double word is protected by
> > +			 * slab_lock but _count is not.
> > +			 */
> > +			unsigned counters;
> > +#endif
> >  
> >  			struct {
> >  
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> []'s
> Herton


-- 
[]'s
Herton
