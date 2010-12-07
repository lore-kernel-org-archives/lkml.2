Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0LGWv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:51:27 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43705 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0LGWv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vk1c+779+Sgug2RUbWvTz8+hxdZjiFPaCF8O8Mgjm69cnIsH5Umw+ej3ap8eJSst5e
         XH76zLOFSQcO7FR6Eila0ZZZUogmx0/9294l2Bnh7f7X5eOK8TB/0YYTBxS7GnIur6fP
         A8EpUzWSAvWHKOPrLPKU24KCeo796H7t8Ax2o=
MIME-Version: 1.0
In-Reply-To: <20101207155645.GG2356@cmpxchg.org>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<d57730effe4b48012d31ceca07938ed3eb401aba.1291568905.git.minchan.kim@gmail.com>
	<20101207144923.GB2356@cmpxchg.org>
	<20101207150710.GA26613@barrios-desktop>
	<20101207151939.GF2356@cmpxchg.org>
	<20101207152625.GB608@barrios-desktop>
	<20101207155645.GG2356@cmpxchg.org>
Date: Wed, 8 Dec 2010 07:51:25 +0900
Message-ID: <AANLkTi=iNGT_p_VfW9GxdaKXLt2xBHM2jdwmCbF_u8uh@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] deactivate invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 12:56 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Wed, Dec 08, 2010 at 12:26:25AM +0900, Minchan Kim wrote:
>> On Tue, Dec 07, 2010 at 04:19:39PM +0100, Johannes Weiner wrote:
>> > On Wed, Dec 08, 2010 at 12:07:10AM +0900, Minchan Kim wrote:
>> > > On Tue, Dec 07, 2010 at 03:49:24PM +0100, Johannes Weiner wrote:
>> > > > On Mon, Dec 06, 2010 at 02:29:10AM +0900, Minchan Kim wrote:
>> > > > > Changelog since v3:
>> > > > >  - Change function comments - suggested by Johannes
>> > > > >  - Change function name - suggested by Johannes
>> > > > >  - add only dirty/writeback pages to deactive pagevec
>> > > >
>> > > > Why the extra check?
>> > > >
>> > > > > @@ -359,8 +360,16 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
>> > > > >                       if (lock_failed)
>> > > > >                               continue;
>> > > > >
>> > > > > -                     ret += invalidate_inode_page(page);
>> > > > > -
>> > > > > +                     ret = invalidate_inode_page(page);
>> > > > > +                     /*
>> > > > > +                      * If the page is dirty or under writeback, we can not
>> > > > > +                      * invalidate it now.  But we assume that attempted
>> > > > > +                      * invalidation is a hint that the page is no longer
>> > > > > +                      * of interest and try to speed up its reclaim.
>> > > > > +                      */
>> > > > > +                     if (!ret && (PageDirty(page) || PageWriteback(page)))
>> > > > > +                             deactivate_page(page);
>> > > >
>> > > > The writeback completion handler does not take the page lock, so you
>> > > > can still miss pages that finish writeback before this test, no?
>> > >
>> > > Yes. but I think it's rare and even though it happens, it's not critical.
>> > > >
>> > > > Can you explain why you felt the need to add these checks?
>> > >
>> > > invalidate_inode_page can return 0 although the pages is !{dirty|writeback}.
>> > > Look invalidate_complete_page. As easiest example, if the page has buffer and
>> > > try_to_release_page can't release the buffer, it could return 0.
>> >
>> > Ok, but somebody still tried to truncate the page, so why shouldn't we
>> > try to reclaim it?  The reason for deactivating at this location is
>> > that truncation is a strong hint for reclaim, not that it failed due
>> > to dirty/writeback pages.
>> >
>> > What's the problem with deactivating pages where try_to_release_page()
>> > failed?
>>
>> If try_to_release_page fails and the such pages stay long time in pagevec,
>> pagevec drain often happens.
>
> You mean because the pagevec becomes full more often?  These are not
> many pages you get extra without the checks, the race window is very
> small after all.

Right.
It was a totally bad answer. The work in midnight makes my mind to be hurt. :)

Another point is that we can move such pages(!try_to_release_page,
someone else holding the ref) into tail of inactive.
We can't expect such pages will be freed sooner or later and it can
stir lru pages unnecessary.
On the other hand it's a _really_ rare so couldn't we move the pages into tail?
If it can be justified, I will remove the check.
What do you think about it?

>
>> I think such pages are rare so skip such pages doesn't hurt goal of
>> this patch.
>
> Well, you add extra checks, extra detail to this mechanism.  Instead
> of just saying 'tried to truncate, failed, deactivate the page', you
> add more ifs and buts.
>
> There should be a real justification for it.  'It can not hurt' is not
> a good justification for extra code and making a simple model more
> complex.
>
> 'It will hurt without treating these pages differently' is a good
> justification.  Remember that we have to understand and maintain all
> this.  The less checks and operations we need to implement a certain
> idea, the better.
>
> Sorry for being so adamant about this, but I think these random checks
> are a really sore point of mm code already.

Never mind. I totally support your opinion.
It always make me confusing to review the mm codes.
Nowadays, many reviewers want detail comment and description. Given
that mm code changing are bigger, I believe it's a way to go

>
> [ For example, we tried discussing lumpy reclaim mode recently and
>  none of us could reliably remember how it actually behaved.  There
>  are so many special conditions in there that we already end up with
>  some of them being dead code and the checks even contradicting each
>  other. ]
>

Thanks for good comment, Hannes.




-- 
Kind regards,
Minchan Kim
