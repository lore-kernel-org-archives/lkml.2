Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2BCJcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:32:03 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50732 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2BCJby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:31:54 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Date: Fri, 03 Feb 2012 10:31:50 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 02/15] mm: page_alloc: update migrate type of pages on pcp
 when isolating
In-reply-to: <op.v82hjbd13l0zgt@mpn-glaptop>
To: "'Michal Nazarewicz'" <mina86@mina86.com>, "'Mel Gorman'" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
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
Message-id: <008101cce256$a85e29f0$f91a7dd0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Aczh5FkRihRgMXOJQlu3qmkRbiVXZwAcW2eQ
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-3-git-send-email-m.szyprowski@samsung.com>
 <20120130111522.GE25268@csn.ul.ie> <op.v8wlu8ws3l0zgt@mpn-glaptop>
 <20120130161447.GU25268@csn.ul.ie>
 <022e01cce034$bc6cf440$3546dcc0$%szyprowski@samsung.com>
 <20120202124729.GA5796@csn.ul.ie> <op.v82hjbd13l0zgt@mpn-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, February 02, 2012 8:53 PM Michał Nazarewicz wrote:

> > On Tue, Jan 31, 2012 at 05:23:59PM +0100, Marek Szyprowski wrote:
> >> Pages, which have incorrect migrate type on free finally
> >> causes pageblock migration type change from MIGRATE_CMA to MIGRATE_MOVABLE.
> 
> On Thu, 02 Feb 2012 13:47:29 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> > I'm not quite seeing this. In free_hot_cold_page(), the pageblock
> > type is checked so the page private should be set to MIGRATE_CMA or
> > MIGRATE_ISOLATE for the CMA area. It's not clear how this can change a
> > pageblock to MIGRATE_MOVABLE in error.
> 
> Here's what I think may happen:
> 
> When drain_all_pages() is called, __free_one_page() is called for each page on
> pcp list with migrate type deducted from page_private() which is MIGRATE_CMA.
> This result in the page being put on MIGRATE_CMA freelist even though its
> pageblock's migrate type is MIGRATE_ISOLATE.
> 
> When allocation happens and pcp list is empty, rmqueue_bulk() will get executed
> with migratetype argument set to MIGRATE_MOVABLE.  It calls __rmqueue() to grab
> some pages and because the page described above is on MIGRATE_CMA freelist it
> may be returned back to rmqueue_bulk().
> 
> But, pageblock's migrate type is not MIGRATE_CMA but MIGRATE_ISOLATE, so the
> following code:
> 
> #ifdef CONFIG_CMA
> 		if (is_pageblock_cma(page))
> 			set_page_private(page, MIGRATE_CMA);
> 		else
> #endif
> 			set_page_private(page, migratetype);
> 
> will set it's private to MIGRATE_MOVABLE and in the end the page lands back
> on MIGRATE_MOVABLE pcp list but this time with page_private == MIGRATE_MOVABLE
> and not MIGRATE_CMA.
> 
> One more drain_all_pages() (which may happen since alloc_contig_range() calls
> set_migratetype_isolate() for each block) and next __rmqueue_fallback() may
> convert the whole pageblock to MIGRATE_MOVABLE.
> 
> I know, this sounds crazy and improbable, but I couldn't find an easier path
> to destruction.  As you pointed, once the page is allocated, free_hot_cold_page()
> will do the right thing by reading pageblock's migrate type.
> 
> Marek is currently experimenting with various patches including the following
> change:
> 
> #ifdef CONFIG_CMA
>                  int mt = get_pageblock_migratetype(page);
>                  if (is_migrate_cma(mt) || mt == MIGRATE_ISOLATE)
>                          set_page_private(page, mt);
>                  else
> #endif
>                          set_page_private(page, migratetype);
> 
> As a matter of fact, if __rmqueue() was changed to return migrate type of the
> freelist it took page from, we could avoid this get_pageblock_migratetype() all
> together.  For now, however, I'd rather not go that way just yet -- I'll be happy
> to dig into it once CMA gets merged.

After this and some other changes I'm unable to reproduce that issue. I did a whole
night tests and it still works fine, so it looks that it has been finally solved.
I will post v20 patchset soon :)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


