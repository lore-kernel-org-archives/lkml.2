Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2CGFTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:19:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:54249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2CGFTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:19:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115696327"
Date: Tue, 6 Mar 2012 21:14:18 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ilya Tumaykin <librarian_rus@yahoo.com>
Subject: Re: [ 03/34] lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit
 kernel
Message-ID: <20120307051418.GA10819@localhost>
References: <20120301214654.GA13231@kroah.com>
 <20120301213922.703908387@linuxfoundation.org>
 <20120305150657.GB11238@quack.suse.cz>
 <20120305213126.GA16807@localhost>
 <20120306203508.GB8781@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306203508.GB8781@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 09:35:08PM +0100, Jan Kara wrote:
> On Mon 05-03-12 13:31:26, Wu Fengguang wrote:
> > On Mon, Mar 05, 2012 at 04:06:57PM +0100, Jan Kara wrote:
> > > On Thu 01-03-12 13:39:25, Greg KH wrote:
> > > > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > >   Not that I'd see anything wrong with this patch for 2.6.32. But it is
> > > also unnecessary since the code which was triggering the overflow does not
> > > exist in 2.6.32. So maybe just on the grounds of not applying unneeded
> > > patchs I'd skip this one.
> > 
> > FYI I never see this divide error for pre-3.2 kernels. However I've
> > run into problem (2) before 3.2 which makes bdi dirty threshold go
> > wild. So it seems safer to go with this patch.
> > 
> > To be frank the boxes that run into bugs (1) or (2) do not have
> > Terabytes of memory to create the big shift value in
> > calc_period_shift() which is the sufficient condition for triggering
> > the bugs as described in the below changelog. However the bugs do
> > magically go away with the patch applied. Perhaps this patch breaks
> > one necessary condition for triggering the bugs in a small memory box.
>   The patch went in -stable kernel so this is mostly an academic discussion
> but Documentation/stable_kernel_rules.txt says among other things:
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
>  - It must fix a problem that causes a build error (but not for things
>    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
>    security issue, or some "oh, that's not good" issue.  In short,
>    something critical.
> 
>   This patch simply didn't pass these two conditions for me for 2.6.32 and
> your arguments didn't convince me it's a critical thing either...

I see the point. We need *demonstrated* critical bugs for pushing the
fix to -stable.

By this criterion, I agree that there are no strong reasons for
including this patch in -stable.

Thanks,
Fengguang

> 								Honza
> 
> > > > ------------------
> > > > 
> > > > From: Wu Fengguang <fengguang.wu@intel.com>
> > > > 
> > > > commit 3310225dfc71a35a2cc9340c15c0e08b14b3c754 upstream.
> > > > 
> > > > PROP_MAX_SHIFT should be set to <=32 on 64-bit box. This fixes two bugs
> > > > in the below lines of bdi_dirty_limit():
> > > > 
> > > > 	bdi_dirty *= numerator;
> > > > 	do_div(bdi_dirty, denominator);
> > > > 
> > > > 1) divide error: do_div() only uses the lower 32 bit of the denominator,
> > > >    which may trimmed to be 0 when PROP_MAX_SHIFT > 32.
> > > > 
> > > > 2) overflow: (bdi_dirty * numerator) could easily overflow if numerator
> > > >    used up to 48 bits, leaving only 16 bits to bdi_dirty
> > > > 
> > > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Reported-by: Ilya Tumaykin <librarian_rus@yahoo.com>
> > > > Tested-by: Ilya Tumaykin <librarian_rus@yahoo.com>
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > ---
> > > >  include/linux/proportions.h |    4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > --- a/include/linux/proportions.h
> > > > +++ b/include/linux/proportions.h
> > > > @@ -81,7 +81,11 @@ void prop_inc_percpu(struct prop_descrip
> > > >   * Limit the time part in order to ensure there are some bits left for the
> > > >   * cycle counter and fraction multiply.
> > > >   */
> > > > +#if BITS_PER_LONG == 32
> > > >  #define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
> > > > +#else
> > > > +#define PROP_MAX_SHIFT (BITS_PER_LONG/2)
> > > > +#endif
> > > >  
> > > >  #define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
> > > >  #define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
> > > > 
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > -- 
> > > Jan Kara <jack@suse.cz>
> > > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
