Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0LTCdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:33:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54011 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0LTCdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:33:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Dec 2010 11:27:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC 5/5] truncate: Remove unnecessary page release
Message-Id: <20101220112733.064f2fe3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101220112227.E566.A69D9226@jp.fujitsu.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<02ab98b3a1450f7a1c31edc48ccc57e887cee900.1292604746.git.minchan.kim@gmail.com>
	<20101220112227.E566.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 11:21:52 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > This patch series changes remove_from_page_cache's page ref counting
> > rule. page cache ref count is decreased in remove_from_page_cache.
> > So we don't need call again in caller context.
> > 
> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  mm/truncate.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/truncate.c b/mm/truncate.c
> > index 9ee5673..8decb93 100644
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -114,7 +114,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
> >  	 * calls cleancache_put_page (and note page->mapping is now NULL)
> >  	 */
> >  	cleancache_flush_page(mapping, page);
> > -	page_cache_release(page);	/* pagecache ref */
> >  	return 0;
> 
> Do we _always_ have stable page reference here? IOW, I can assume 
> cleancache_flush_page() doesn't cause NULL deref?
> 
Hmm, my review was bad.

I think cleancache_flush_page() here should eat (mapping, index) as argument
rather than "page".

BTW,  I can't understand
==
void __cleancache_flush_page(struct address_space *mapping, struct page *page)
{
        /* careful... page->mapping is NULL sometimes when this is called */
        int pool_id = mapping->host->i_sb->cleancache_poolid;
        struct cleancache_filekey key = { .u.key = { 0 } };
==

Why above is safe...
I think (mapping,index) should be passed instead of page.


-Kame

