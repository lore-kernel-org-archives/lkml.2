Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2CBQb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:31:26 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40725 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758109Ab2CBQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:31:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ik_V70AVM1lBMW_rGxXXsVszltTKqzQpq1kYz4MIAi2s4N9
 jwoHRyfExELJZ3ZS3vIVcM_t1t3w1V3rn2bYfsecwlPSbsFv8BHBRMKa7Tdf
 Z4iZXp26xdqt1gIRrs5Cf_bWr_nohqkSJ1E_W2rfLu7cPhn5NQ0VaW6qPBw6
 sc6__hR69cvzKjYbsQCCRQigzF32iQSZQqiHvxt32LOvrIUk3nBfSssNo_aM
 ZaMovMMV2zrnenYkLkjme033yoeqQeREAmzp_WM5N7x3wp8SXXP2BeKQMY42
 wg1kvu6_9ybzfWRL1JBIv5elPpyFgt8GjueK39LvCn6344mnX9ePawObmSxJ
 dtTz7Xfdk5.5LzfGOCuCTf5nvNhWtVgtVWbuxHraaBodvb.adkJWZKEnWl.J
 g
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Mar 2012 10:13:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Namhyung Kim <namhyung.kim@lge.com>
cc: Namhyung Kim <namhyung@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
In-Reply-To: <4F5072F4.3030505@lge.com>
Message-ID: <alpine.DEB.2.00.1203021013180.15125@router.home>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>  <alpine.DEB.2.00.1202290922210.32268@router.home> <1330587031.1762.46.camel@leonhard> <alpine.DEB.2.00.1203010901020.5004@router.home> <4F5072F4.3030505@lge.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Namhyung Kim wrote:

> > ?? One generally passed a struct page pointer to the page allocator. Slab
> > allocator takes pointers to object. The calls that take a pointer to an
> > object must have a page aligned value.
> >
>
> Please see free_pages(). It converts the pointer using virt_to_page().

Sure. As I said you still need a page aligned value. If you were
successful in doing what you claim then there is a bug in the page
allocator because it allowed the freeing of a tail page out of a compound
page.


> > Adding PG_tail to the flags checked on free should do the trick (at least
> > for 64 bit).
> >
>
> Yeah, but doing it requires to change free path of compound pages. It seems
> freeing normal compound pages would not clear PG_head/tail bits before
> free_pages_check() called. I guess moving destroy_compound_page() into
> free_pages_prepare() will solved this issue but I want to make sure it's the
> right approach since I have no idea how it affects huge page behaviors.

Freeing a tail page should cause a BUG() or some form of error handling.
It should not work.

> Besides, as it has no effect on 32 bit kernels I still want add the PG_slab
> flag to those pages. If you care about the performance of hot path, how about
> adding it under debug configurations at least?

One reason to *not* do the marking of each page is that it impacts the
allocation and free paths in the allocator.

The basic notion of compound pages is that the flags in the head page are
valid for all the pages in the compound. PG_slab is set already in the
head page. So the compound is marked as a slab page. Consulting
page->firstpage->flags and not page->flags will yield the correct result.



