Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1EaNoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:44:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49214 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab1EaNoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h73dIfVrqd/y8T8ecoZgBoE3pUo59UEOS2DbyIk6d8+1huHE80QczN+YDV/EC5VNL8
         UL2Lq3VDeQxuBm3+j3fnHaYUOiIdLhkLZrVunXuJZgE6cU9pwBwnnufVNQagIPE82V//
         h/C49o9oSM5uXZh48kcjkhtyhtai1QjR+nbUE=
Date: Tue, 31 May 2011 22:44:05 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 03/10] Change isolate mode from int type to enum type
Message-ID: <20110531134405.GC3490@barrios-laptop>
References: <cover.1306689214.git.minchan.kim@gmail.com>
 <6e08f148630ffe1e7fe6a4d31d4340a9a47f4473.1306689214.git.minchan.kim@gmail.com>
 <20110531133611.GC3190@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531133611.GC3190@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:36:11PM +0200, Johannes Weiner wrote:
> On Mon, May 30, 2011 at 03:13:42AM +0900, Minchan Kim wrote:
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -957,23 +957,29 @@ keep_lumpy:
> >   *
> >   * returns 0 on success, -ve errno on failure.
> >   */
> > -int __isolate_lru_page(struct page *page, int mode, int file)
> > +int __isolate_lru_page(struct page *page, enum ISOLATE_PAGE_MODE mode,
> > +							int file)
> >  {
> > +	int active;
> >  	int ret = -EINVAL;
> > +	BUG_ON(mode & ISOLATE_BOTH &&
> > +		(mode & ISOLATE_INACTIVE || mode & ISOLATE_ACTIVE));
> >  
> >  	/* Only take pages on the LRU. */
> >  	if (!PageLRU(page))
> >  		return ret;
> >  
> > +	active = PageActive(page);
> > +
> >  	/*
> >  	 * When checking the active state, we need to be sure we are
> >  	 * dealing with comparible boolean values.  Take the logical not
> >  	 * of each.
> >  	 */
> > -	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
> > +	if (mode & ISOLATE_ACTIVE && !active)
> >  		return ret;
> >  
> > -	if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file)
> > +	if (mode & ISOLATE_INACTIVE && active)
> >  		return ret;
> 
> What happened to the check for file pages?

Shame on me. I should not change old behavior.
Will fix on v3.

Thanks, Hannes.

-- 
Kind regards
Minchan Kim
