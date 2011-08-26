Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1HZM7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:59:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:43588 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1HZM72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:59:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,285,1312182000"; 
   d="scan'208";a="42719578"
Date: Fri, 26 Aug 2011 20:59:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] writeback: per task dirty rate limit
Message-ID: <20110826125924.GA6014@localhost>
References: <20110826113813.895522398@intel.com>
 <20110826114619.268843347@intel.com>
 <1314363069.11049.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314363069.11049.3.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 08:51:09PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-26 at 19:38 +0800, Wu Fengguang wrote:
> > +       preempt_disable();
> >         /*
> > -        * Check the rate limiting. Also, we do not want to throttle real-time
> > -        * tasks in balance_dirty_pages(). Period.
> > +        * This prevents one CPU to accumulate too many dirtied pages without
> > +        * calling into balance_dirty_pages(), which can happen when there are
> > +        * 1000+ tasks, all of them start dirtying pages at exactly the same
> > +        * time, hence all honoured too large initial task->nr_dirtied_pause.
> >          */
> > -       preempt_disable();
> >         p =  &__get_cpu_var(bdp_ratelimits);
> 
> 	p = &get_cpu_var(bdp_ratelimits);

Ah yeah.. I actually followed your suggestion, and then find we'll
eventually do two __get_cpu_var() calls here, one for bdp_ratelimits
and the other for dirty_leaks in a planned patch. So let's keep the
preempt_disable()/preempt_enable().

> > -       *p += nr_pages_dirtied;
> > -       if (unlikely(*p >= ratelimit)) {
> > -               ratelimit = sync_writeback_pages(*p);
> > +       if (unlikely(current->nr_dirtied >= ratelimit))
> >                 *p = 0;
> > -               preempt_enable();
> > -               balance_dirty_pages(mapping, ratelimit);
> > -               return;
> > +       else {
> > +               *p += nr_pages_dirtied;
> > +               if (unlikely(*p >= ratelimit_pages)) {
> > +                       *p = 0;
> > +                       ratelimit = 0;
> > +               }
> >         }
> >         preempt_enable(); 
> 
> 	put_cpu_var(bdp_ratelimits);

ditto.

Thanks,
Fengguang
