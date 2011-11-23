Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1KWJTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:19:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab1KWJTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:19:38 -0500
Date: Wed, 23 Nov 2011 09:19:33 +0000
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] mm: compaction: make isolate_lru_page() filter-aware
 again
Message-ID: <20111123091933.GL19415@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-6-git-send-email-mgorman@suse.de>
 <20111122173018.GD15253@barrios-laptop.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111122173018.GD15253@barrios-laptop.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 02:30:18AM +0900, Minchan Kim wrote:
> > <SNIP>
> > +	/*
> > +	 * To minimise LRU disruption, the caller can indicate that it only
> > +	 * wants to isolate pages it will be able to operate on without
> > +	 * blocking - clean pages for the most part.
> > +	 *
> > +	 * ISOLATE_CLEAN means that only clean pages should be isolated. This
> > +	 * is used by reclaim when it is cannot write to backing storage
> > +	 *
> > +	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
> > +	 * that it is possible to migrate without blocking with a ->migratepage
> > +	 * handler
> > +	 */
> > +	if (mode & (ISOLATE_CLEAN|ISOLATE_ASYNC_MIGRATE)) {
> > +		/* All the caller can do on PageWriteback is block */
> > +		if (PageWriteback(page))
> > +			return ret;
> > +
> > +		if (PageDirty(page)) {
> > +			struct address_space *mapping;
> > +
> > +			/* ISOLATE_CLEAN means only clean pages */
> > +			if (mode & ISOLATE_CLEAN)
> > +				return ret;
> > +
> > +			/*
> > +			 * Only the ->migratepage callback knows if a dirty
> > +			 * page can be migrated without blocking. Skip the
> > +			 * page unless there is a ->migratepage callback.
> > +			 */
> > +			mapping = page_mapping(page);
> > +			if (!mapping || !mapping->a_ops->migratepage)
> 
> I didn't review 4/7 carefully yet.

Thanks for reviewing the others.

> In case of page_mapping is NULL, move_to_new_page calls migrate_page
> which is non-blocking function. So, I guess it could be migrated without blocking.
>  

Well spotted

                        /*
                         * Only pages without mappings or that have a
                         * ->migratepage callback are possible to
                         * migrate without blocking
                         */
                        mapping = page_mapping(page);
                        if (mapping && !mapping->a_ops->migratepage)
                                return ret;

-- 
Mel Gorman
SUSE Labs
