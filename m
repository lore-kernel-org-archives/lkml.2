Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1HKAzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:55:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:2136 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1HKAzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,353,1309762800"; 
   d="scan'208";a="37262148"
Date: Thu, 11 Aug 2011 08:55:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
Message-ID: <20110811005539.GA4413@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094527.002914580@intel.com>
 <20110809174621.GF6482@redhat.com>
 <20110810032954.GC24486@localhost>
 <20110810181854.GD3396@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810181854.GD3396@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:18:54AM +0800, Vivek Goyal wrote:
> On Wed, Aug 10, 2011 at 11:29:54AM +0800, Wu Fengguang wrote:
> 
> [..]
> > > > -	ratelimit = ratelimit_pages;
> > > > -	if (mapping->backing_dev_info->dirty_exceeded)
> > > > +	ratelimit = current->nr_dirtied_pause;
> > > > +	if (bdi->dirty_exceeded)
> > > >  		ratelimit = 8;
> > > 
> > > Should we make sure that ratelimit is more than 8? It could be that
> > > ratelimit is 1 and we set it higher (just reverse of what we wanted?)
> > 
> > Good catch! I actually just fixed it in that direction :)
> > 
> >         if (bdi->dirty_exceeded)
> > -               ratelimit = 8;
> > +               ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
> 
> With page size 64K, will above lead to retelimit 0? Is that what you want.
> I wouldn't think so.

Yeah, it looks a bit weird.. however ratelimit=0 would behave the
same with ratelimit=1 because balance_dirty_pages_ratelimited_nr()
is always called with (nr_pages_dirtied >= 1).

Thanks,
Fengguang
