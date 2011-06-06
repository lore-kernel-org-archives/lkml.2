Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1FFOUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:20:06 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61316 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFOUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dZuObfGuS/9ARcVpMFio1hdx3x3mWGeIImAObYvQFMDNGOoBOUiWCD6FxVZTkUoJJr
         uwk8MDTPRIppT5sM/ImaUd/+SoF+WwdSvNwJRw05Oo6lFI+85gAfnjx6mAzeuA5PQN/k
         LBkEXMc9UGrji45ms9W/sucAUcSLkOTdCOyXI=
Date: Mon, 6 Jun 2011 23:19:52 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110606141952.GE1686@barrios-laptop>
References: <20110601214018.GC7306@suse.de>
 <20110601233036.GZ19505@random.random>
 <20110602010352.GD7306@suse.de>
 <20110602132954.GC19505@random.random>
 <20110602145019.GG7306@suse.de>
 <20110602153754.GF19505@random.random>
 <20110603020920.GA26753@suse.de>
 <20110603144941.GI7306@suse.de>
 <20110603154554.GK2802@random.random>
 <20110606103924.GD5247@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606103924.GD5247@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:39:24AM +0100, Mel Gorman wrote:
> On Fri, Jun 03, 2011 at 05:45:54PM +0200, Andrea Arcangeli wrote:
> > On Fri, Jun 03, 2011 at 03:49:41PM +0100, Mel Gorman wrote:
> > > Right idea of the wrong zone being accounted for but wrong place. I
> > > think the following patch should fix the problem;
> > 
> > Looks good thanks.
> > 
> > I also found this bug during my debugging that made NR_SHMEM underflow.
> > 
> > ===
> > Subject: migrate: don't account swapcache as shmem
> > 
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > swapcache will reach the below code path in migrate_page_move_mapping,
> > and swapcache is accounted as NR_FILE_PAGES but it's not accounted as
> > NR_SHMEM.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> Well spotted.
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 
> Minor nit. swapper_space is rarely referred to outside of the swap
> code. Might it be more readable to use
> 
> 	/*
> 	 * swapcache is accounted as NR_FILE_PAGES but it is not
> 	 * accounted as NR_SHMEM
> 	 *
> 	if (PageSwapBacked(page) && !PageSwapCache(page))

I like this. but as it's "and" operation, CPU have to execute two condition comparison.
but how about below?
	if (!PageSwapCache(page) && PageSwapBacked(page))

PageSwapCache implys PageSwapBacked so we can handle non-swapbacked pages as just 1 comparison.

> 
> ?
> 
> > ---
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index e4a5c91..2597a27 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -288,7 +288,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
> >  	 */
> >  	__dec_zone_page_state(page, NR_FILE_PAGES);
> >  	__inc_zone_page_state(newpage, NR_FILE_PAGES);
> > -	if (PageSwapBacked(page)) {
> > +	if (mapping != &swapper_space && PageSwapBacked(page)) {
> >  		__dec_zone_page_state(page, NR_SHMEM);
> >  		__inc_zone_page_state(newpage, NR_SHMEM);
> >  	}
> > 
> > 
> 
> -- 
> Mel Gorman
> SUSE Labs

-- 
Kind regards
Minchan Kim
