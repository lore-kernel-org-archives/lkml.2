Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0G0JMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 05:12:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0G0JMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 05:12:47 -0400
Date: Tue, 27 Jul 2010 11:12:20 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
Message-ID: <20100727091220.GD3358@quack.suse.cz>
References: <20100711020656.340075560@intel.com>
 <20100711021748.735126772@intel.com>
 <20100726151946.GH3280@quack.suse.cz>
 <20100727035941.GA15007@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727035941.GA15007@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-07-10 11:59:41, Wu Fengguang wrote:
> > > This patch slightly changes behavior by replacing clip_bdi_dirty_limit()
> > > with the explicit check (nr_reclaimable + nr_writeback >= dirty_thresh)
> > > to avoid exceeding the dirty limit. Since the bdi dirty limit is mostly
> > > accurate we don't need to do routinely clip. A simple dirty limit check
> > > would be enough.
> > > 
> > > The check is necessary because, in principle we should throttle
> > > everything calling balance_dirty_pages() when we're over the total
> > > limit, as said by Peter.
> > > 
> > > We now set and clear dirty_exceeded not only based on bdi dirty limits,
> > > but also on the global dirty limits. This is a bit counterintuitive, but
> > > the global limits are the ultimate goal and shall be always imposed.
> >   Thinking about this again - what you did is rather big change for systems
> > with more active BDIs. For example if I have two disks sda and sdb and
> > write for some time to sda, then dirty limit for sdb gets scaled down.
> > So when we start writing to sbd we'll heavily throttle the threads until
> > the dirty limit for sdb ramps up regardless of how far are we to reach the
> > global limit...
> 
> The global threshold check is added in place of clip_bdi_dirty_limit()
> for safety and not intended as a behavior change. If ever leading to
> big behavior change and regression, that it would be indicating some
> too permissive per-bdi threshold calculation.
> 
> Did you see the global dirty threshold get exceeded when writing to 2+
> devices? Occasional small exceeding should be OK though. I tried the
> following debug patch and see no warnings when doing two concurrent cp
> over local disk and NFS.
  Oops, sorry. I've misread the code. You're right. There shouldn't be a big
change in the behavior.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
