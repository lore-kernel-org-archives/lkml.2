Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2BBMrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:47:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39510 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab2BBMro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:47:44 -0500
Date: Thu, 2 Feb 2012 12:47:29 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Michal Nazarewicz'" <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 02/15] mm: page_alloc: update migrate type of pages on
 pcp when isolating
Message-ID: <20120202124729.GA5796@csn.ul.ie>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-3-git-send-email-m.szyprowski@samsung.com>
 <20120130111522.GE25268@csn.ul.ie>
 <op.v8wlu8ws3l0zgt@mpn-glaptop>
 <20120130161447.GU25268@csn.ul.ie>
 <022e01cce034$bc6cf440$3546dcc0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <022e01cce034$bc6cf440$3546dcc0$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 05:23:59PM +0100, Marek Szyprowski wrote:
> > > >>+		page = pfn_to_page(pfn);
> > > >>+		if (PageBuddy(page)) {
> > > >>+			pfn += 1 << page_order(page);
> > > >>+		} else if (page_count(page) == 0) {
> > > >>+			set_page_private(page, MIGRATE_ISOLATE);
> > > >>+			++pfn;
> > > >
> > > >This is dangerous for two reasons. If the page_count is 0, it could
> > > >be because the page is in the process of being freed and is not
> > > >necessarily on the per-cpu lists yet and you cannot be sure if the
> > > >contents of page->private are important. Second, there is nothing to
> > > >prevent another CPU allocating this page from its per-cpu list while
> > > >the private field is getting updated from here which might lead to
> > > >some interesting races.
> > > >
> > > >I recognise that what you are trying to do is respond to Gilad's
> > > >request that you really check if an IPI here is necessary. I think what
> > > >you need to do is check if a page with a count of 0 is encountered
> > > >and if it is, then a draining of the per-cpu lists is necessary. To
> > > >address Gilad's concerns, be sure to only this this once per attempt at
> > > >CMA rather than for every page encountered with a count of 0 to avoid a
> > > >storm of IPIs.
> > >
> > > It's actually more then that.
> > >
> > > This is the same issue that I first fixed with a change to free_pcppages_bulk()
> > > function[1].  At the time of positing, you said you'd like me to try and find
> > > a different solution which would not involve paying the price of calling
> > > get_pageblock_migratetype().  Later I also realised that this solution is
> > > not enough.
> > >
> > > [1] http://article.gmane.org/gmane.linux.kernel.mm/70314
> > >
> > 
> > Yes. I had forgotten the history but looking at that patch again,
> > I would reach the conclusion that this was adding a new call to
> > get_pageblock_migratetype() in the bulk free path. That would affect
> > everybody whether they were using CMA or not.
> 
> This will be a bit ugly, but we can also use that code and compile it conditionally
> when CMA has been enabled.

That would also be very unfortunate because it means enabling CMA incurs
a performance cost to everyone whether they use CMA or not. For ARM,
this may not be a problem but it would be for other arches if they
wanted to use CMA or if it ever became part of a distro contig.

> Pages, which have incorrect migrate type on free finally
> causes pageblock migration type change from MIGRATE_CMA to MIGRATE_MOVABLE.

I'm not quite seeing this. In free_hot_cold_page(), the pageblock
type is checked so the page private should be set to MIGRATE_CMA or
MIGRATE_ISOLATE for the CMA area. It's not clear how this can change a
pageblock to MIGRATE_MOVABLE in error. If it turns out that you
absolutely have to call get_pageblock_migratetype() from
free_pcppages_bulk() and my alternative suggestion did not work out then
document all these issues in a comment when putting the call under
CONFIG_CMA so that it is not forgotten.

-- 
Mel Gorman
SUSE Labs
