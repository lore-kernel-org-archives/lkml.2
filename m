Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0G1PO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:14:59 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:23514 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755242Ab0G1PO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:14:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7VUJacQVM1nLae8e3Gn1jaM7axYdcM6nU0S1wbvg3Zls5r5
 sKRFGXCyNO.WtQcE1ho101NYymIkRo5LCbC4dkbth8_Y7lX9kijOKnFd6DeO
 uD1ieKBg6AWIK127X7k19J2rCbpwBZzLK77KyoWaiynzWz500fFjCFJ2WBmc
 dtb18N9yc8pdQznmENSect1XiIqf42iRUNGLhYpXvMlSoQHgIRfmAdE2ngXh
 b
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 28 Jul 2010 10:14:51 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007281005440.21717@router.home>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com> <alpine.DEB.2.00.1007261136160.5438@router.home> <pfn.valid.v4.reply.1@mdm.bga.com> <AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com> <pfn.valid.v4.reply.2@mdm.bga.com>
 <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com> <alpine.DEB.2.00.1007270929290.28648@router.home> <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010, Minchan Kim wrote:

> static inline int memmap_valid(unsigned long pfn)
> {
>        struct page *page = pfn_to_page(pfn);
>        struct page *__pg = virt_to_page(page);

Does that work both for vmemmap and real mmapping?

>        return page_private(__pg) == MAGIC_MEMMAP && PageReserved(__pg);
> }

Problem is that pages may be allocated for the mmap from a variety of
places. The pages in mmap_init_zone() and allocated during boot may have
PageReserved set whereas the page allocated via vmemmap_alloc_block() have
PageReserved cleared since they came from the page allocator.

You need to have consistent use of PageReserved in page structs for the
mmap in order to do this properly.

Simplest scheme would be to clear PageReserved() in all page struct
associated with valid pages and clear those for page structs that do not
refer to valid pages.

Then

mmap_valid = !PageReserved(xxx(pfn_to_page(pfn))
