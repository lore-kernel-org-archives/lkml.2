Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1FMNnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:43:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:38460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab1FMNm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:42:59 -0400
Date: Mon, 13 Jun 2011 15:42:53 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/15] writeback: skip balance_dirty_pages() for
 in-memory fs
Message-ID: <20110613134253.GC4907@quack.suse.cz>
References: <20110607213236.634026193@intel.com>
 <20110607213854.764050631@intel.com>
 <20110611130730.GA23176@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110611130730.GA23176@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 11-06-11 21:07:31, Wu Fengguang wrote:
> > @@ -495,6 +490,9 @@ static void balance_dirty_pages(struct a
> >  	bool dirty_exceeded = false;
> >  	struct backing_dev_info *bdi = mapping->backing_dev_info;
> >  
> > +	if (!bdi_cap_account_dirty(bdi))
> > +		return;
> > +
> >  	for (;;) {
> >  		struct writeback_control wbc = {
> >  			.sync_mode	= WB_SYNC_NONE,
> > 
> 
> Update: it's slightly better to do early return in
> balance_dirty_pages_ratelimited_nr(). This way the tmpfs dirties won't
> unnecessarily disturb the per-cpu bdp_ratelimits counters.
  Yup, makes sense to me.

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> --- linux-next.orig/mm/page-writeback.c	2011-06-11 17:52:59.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-06-11 17:53:53.000000000 +0800
> @@ -1098,9 +1098,6 @@ static void balance_dirty_pages(struct a
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  	unsigned long start_time = jiffies;
>  
> -	if (!bdi_cap_account_dirty(bdi))
> -		return;
> -
>  	for (;;) {
>  		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>  					global_page_state(NR_UNSTABLE_NFS);
> @@ -1237,9 +1234,13 @@ static DEFINE_PER_CPU(unsigned long, bdp
>  void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
>  					unsigned long nr_pages_dirtied)
>  {
> +	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  	unsigned long ratelimit;
>  	unsigned long *p;
>  
> +	if (!bdi_cap_account_dirty(bdi))
> +		return;
> +
>  	ratelimit = ratelimit_pages;
>  	if (mapping->backing_dev_info->dirty_exceeded)
>  		ratelimit = 8;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
