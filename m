Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0LTC6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:58:52 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49549 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0LTC6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xw3v2kBr+eL4MtCuZgqAMdblUOkpGHJ1OFkhBzIgHciMR2O7Do3/9dEjdiKQOgN6HI
         KSXur0KiKSE8tQgI6CMaj5tK8o6X3gmq07TjnzhklHUha1gURaaJsDoSSMC6H19dm0qZ
         sWamAV1paoDRP96TiiKzO+gEz896FpGXfMdWE=
MIME-Version: 1.0
In-Reply-To: <20101220112733.064f2fe3.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<02ab98b3a1450f7a1c31edc48ccc57e887cee900.1292604746.git.minchan.kim@gmail.com>
	<20101220112227.E566.A69D9226@jp.fujitsu.com>
	<20101220112733.064f2fe3.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Dec 2010 11:58:50 +0900
Message-ID: <AANLkTi=UfmZNfKWCisrs6ezzoWqpcwUOT5bs8LGwN7Rv@mail.gmail.com>
Subject: Re: [RFC 5/5] truncate: Remove unnecessary page release
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 11:27 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 20 Dec 2010 11:21:52 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> > This patch series changes remove_from_page_cache's page ref counting
>> > rule. page cache ref count is decreased in remove_from_page_cache.
>> > So we don't need call again in caller context.
>> >
>> > Cc: Nick Piggin <npiggin@suse.de>
>> > Cc: Al Viro <viro@zeniv.linux.org.uk>
>> > Cc: linux-mm@kvack.org
>> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> > ---
>> >  mm/truncate.c |    1 -
>> >  1 files changed, 0 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/mm/truncate.c b/mm/truncate.c
>> > index 9ee5673..8decb93 100644
>> > --- a/mm/truncate.c
>> > +++ b/mm/truncate.c
>> > @@ -114,7 +114,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
>> >      * calls cleancache_put_page (and note page->mapping is now NULL)
>> >      */
>> >     cleancache_flush_page(mapping, page);
>> > -   page_cache_release(page);       /* pagecache ref */
>> >     return 0;
>>
>> Do we _always_ have stable page reference here? IOW, I can assume
>> cleancache_flush_page() doesn't cause NULL deref?
>>
> Hmm, my review was bad.
>
> I think cleancache_flush_page() here should eat (mapping, index) as argument
> rather than "page".
>
> BTW,  I can't understand
> ==
> void __cleancache_flush_page(struct address_space *mapping, struct page *page)
> {
>        /* careful... page->mapping is NULL sometimes when this is called */
>        int pool_id = mapping->host->i_sb->cleancache_poolid;
>        struct cleancache_filekey key = { .u.key = { 0 } };
> ==
>
> Why above is safe...
> I think (mapping,index) should be passed instead of page.

I don't think current code isn't safe.

void __cleancache_flush_page(struct address_space *mapping, struct page *page)
{
        /* careful... page->mapping is NULL sometimes when this is called */
        int pool_id = mapping->host->i_sb->cleancache_poolid;
        struct cleancache_filekey key = { .u.key = { 0 } };

        if (pool_id >= 0) {
                VM_BUG_ON(!PageLocked(page));

it does check PageLocked. So caller should hold a page reference to
prevent freeing ramined PG_locked
If the caller doesn't hold a ref of page, I think it's BUG of caller.

In our case, caller calls truncate_complete_page have to make sure it, I think.

>
>
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
