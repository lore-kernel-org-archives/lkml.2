Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1DNVGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:06:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63582 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1DNVGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:06:37 -0400
MIME-Version: 1.0
Message-ID: <662075c7-1510-43f0-baaa-82541276b2c8@default>
Date: Thu, 14 Apr 2011 14:04:58 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: RE: linux-next: manual merge of the cleancache tree with Linus' tree
References: <20110324135524.261bb5a9.sfr@canb.auug.org.au>
 <20110323205615.6984f974.akpm@linux-foundation.org
 AANLkTikagME334Y6PH4P_Nybf_h=fov5CiNBAY7KxYyN@mail.gmail.com>
In-Reply-To: <AANLkTikagME334Y6PH4P_Nybf_h=fov5CiNBAY7KxYyN@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DA761C0.00F1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan.kim@gmail.com]
> Sent: Wednesday, March 23, 2011 11:38 PM
> To: Andrew Morton
> Cc: Stephen Rothwell; Dan Magenheimer; linux-next@vger.kernel.org;
> linux-kernel@vger.kernel.org; Linus
> Subject: Re: linux-next: manual merge of the cleancache tree with
> Linus' tree
> 
> On Thu, Mar 24, 2011 at 12:56 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 24 Mar 2011 13:55:24 +1100 Stephen Rothwell
> <sfr@canb.auug.org.au> wrote:
> >
> >> Hi Dan,
> >>
> >> Today's linux-next merge of the cleancache tree got a conflict in
> >> mm/truncate.c between commit 5adc7b518b54 ("mm: truncate: change
> >> remove_from_page_cache") from Linus' tree and commit 03e838947c8a
> >> ("mm/fs: add hooks to support cleancache") from the cleancache tree.
> >>
> >> I fixed it up (see below) but am really not sure of the fix.  I can
> carry
> >> this fix as necessary.
> >>
> >> Is this stuff going to be merged into Linus' tree this time round?
> >> --
> >> Cheers,
> >> Stephen Rothwell                    sfr@canb.auug.org.au
> >>
> >> diff --cc mm/truncate.c
> >> index a956675,cd94607..0000000
> >> --- a/mm/truncate.c
> >> +++ b/mm/truncate.c
> >> @@@ -106,8 -108,13 +108,12 @@@ truncate_complete_page(struct
> address_s
> >>       cancel_dirty_page(page, PAGE_CACHE_SIZE);
> >>
> >>       clear_page_mlock(page);
> >>  -    remove_from_page_cache(page);
> >>       ClearPageMappedToDisk(page);
> >>  +    delete_from_page_cache(page);
> >> +     /* this must be after the remove_from_page_cache which
> >> +      * calls cleancache_put_page (and note page->mapping is now
> NULL)
> >> +      */
> >> +     cleancache_flush_page(mapping, page);
> >>  -    page_cache_release(page);       /* pagecache ref */
> >>       return 0;
> >>   }
> >
> > I did the cleancache_flush_page() before the
> delete_from_page_cache(),
> > in case the delete_from_page_cache() freed the page.  I didn't
> actually
> > check whether that makes sense though.
> 
> I am not sure cleancache's put and flush semantic.
> If I understand rightly with old __remove_from_page_cache's comment,
> maybe cleancache_flush_page is to invalidate the page.(If I understand
> right, I hope the name is changed to cleancache_invalidate_page)
> 
> "        /*
>          * if we're uptodate, flush out into the cleancache, otherwise
>          * invalidate any existing cleancache entries.  We can't leave
>          * stale data around in the cleancache once our page is gone
>          */
>         if (PageUptodate(page))
>                 cleancache_put_page(page);
>         else
>                 cleancache_flush_page(mapping, page); "
> 
> So I think cleancache_flush_page should be done after
> delete_from_page_cache because delete_from_page_cache calls
> cleancache_put_page(maybe this function would flush the content of
> memory into cleancache's target) before we invalidates the page.
> 
> And it should not be a problem in case the delete_from_page_cache
> freed the page since cleancache should have a reference the page but I
> didn't check cleancahe always has a reference of page. If it isn't,
> it's a critical problem.
> 
> Dan, Could you comment this?

In case anyone was waiting for a resolution on this, it
was resolved offlist.

The answer is that the order doesn't matter and the V8
cleancache patch will include a fix for this.

Thanks,
Dan
