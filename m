Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1DXFvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 01:51:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40281 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab1DXFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 01:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Gs6hBk5Ox9izZF18OcD2e4lJ5tVzcikPFpfH08XTOTvRfkQqmNWNgMqkYKmGd57MzX
         Z4uceJmQRHcjYaAoNVYUW6R/aKWheZL1+rXkC6Ao23VQDJfM2nUiNpmSTKD14XAkrhgx
         3aj0c1EVau24i9m9vA2NfWsRZ7dhKq0tnWqj0=
Date: Sun, 24 Apr 2011 14:50:58 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] Check PageActive when evictable page and unevicetable
 page race happen
Message-ID: <20110424055058.GA1826@barrios-desktop>
References: <1303604751-4980-1-git-send-email-minchan.kim@gmail.com>
 <BANLkTimzg184ZWraBomJ8ex1-B4Ypj6D9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimzg184ZWraBomJ8ex1-B4Ypj6D9Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Sun, Apr 24, 2011 at 12:02:57PM +0900, KOSAKI Motohiro wrote:
> 2011/4/24 Minchan Kim <minchan.kim@gmail.com>:
> > In putback_lru_page, unevictable page can be changed into evictable
> > 's one while we move it among lru. So we have checked it again and
> > rescued it. But we don't check PageActive, again. It could add
> > active page into inactive list so we can see the BUG in isolate_lru_pages.
> > (But I didn't see any report because I think it's very subtle)
> >
> > It could happen in race that zap_pte_range's mark_page_accessed and
> > putback_lru_page. It's subtle but could be possible.
> >
> > Note:
> > While I review the code, I found it. So it's not real report.
> >
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  mm/vmscan.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index b3a569f..c0cd1aa 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -562,7 +562,7 @@ int remove_mapping(struct address_space *mapping, struct page *page)
> >  void putback_lru_page(struct page *page)
> >  {
> >        int lru;
> > -       int active = !!TestClearPageActive(page);
> > +       int active;
> >        int was_unevictable = PageUnevictable(page);
> >
> >        VM_BUG_ON(PageLRU(page));
> > @@ -571,6 +571,7 @@ redo:
> >        ClearPageUnevictable(page);
> >
> >        if (page_evictable(page, NULL)) {
> > +               active = !!TestClearPageActive(page);
> >                /*
> >                 * For evictable pages, we can use the cache.
> >                 * In event of a race, worst case is we end up with an
> > @@ -584,6 +585,7 @@ redo:
> >                 * Put unevictable pages directly on zone's unevictable
> >                 * list.
> >                 */
> > +               ClearPageActive(page);
> >                lru = LRU_UNEVICTABLE;
> >                add_page_to_unevictable_list(page);
> 
> I think we forgot 'goto redo' case. following patch is better?
> 
> ------------------------------------------------
>         if (page_evictable(page, NULL)) {
>                 /*
>                  * For evictable pages, we can use the cache.
>                  * In event of a race, worst case is we end up with an
>                  * unevictable page on [in]active list.
>                  * We know how to handle that.
>                  */
>                 lru = active + page_lru_base_type(page);
> +              if (active)
> +                   SetPageActive(page);
>                 lru_cache_add_lru(page, lru);

PageActive is reset by lru_cache_add_lru so it's meaningless.
BTW, please ignore this patch. :)
 
I think LRU status of isolated page cannot be changed.
Thanks for the review. 


-- 
Kind regards,
Minchan Kim
