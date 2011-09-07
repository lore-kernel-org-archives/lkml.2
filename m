Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1IGQdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1IGQdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:04 -0400
Subject: Re: [PATCH 05/18] writeback: per task dirty rate limit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Sep 2011 09:27:50 +0200
In-Reply-To: <20110906232738.GC31945@quack.suse.cz>
References: <20110904015305.367445271@intel.com>
	 <20110904020915.240747479@intel.com> <1315324030.14232.14.camel@twins>
	 <20110906232738.GC31945@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315380470.11101.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 01:27 +0200, Jan Kara wrote:
> On Tue 06-09-11 17:47:10, Peter Zijlstra wrote:
> > On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> > >  /*
> > > + * After a task dirtied this many pages, balance_dirty_pages_ratelimited_nr()
> > > + * will look to see if it needs to start dirty throttling.
> > > + *
> > > + * If dirty_poll_interval is too low, big NUMA machines will call the expensive
> > > + * global_page_state() too often. So scale it near-sqrt to the safety margin
> > > + * (the number of pages we may dirty without exceeding the dirty limits).
> > > + */
> > > +static unsigned long dirty_poll_interval(unsigned long dirty,
> > > +                                        unsigned long thresh)
> > > +{
> > > +       if (thresh > dirty)
> > > +               return 1UL << (ilog2(thresh - dirty) >> 1);
> > > +
> > > +       return 1;
> > > +}
> > 
> > Where does that sqrt come from? 
>   He does 2^{log_2(x)/2} which, if done in real numbers arithmetics, would
> result in x^{1/2}. Given the integer arithmetics, it might be twice as
> small but still it's some approximation...

Right, and I guess with a cpu that can do the fls its slightly faster
than our int_sqrt().
