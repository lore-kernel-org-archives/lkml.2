Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1DOQML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:12:11 -0400
Received: from smtp.nokia.com ([147.243.1.48]:40098 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1DOQMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:12:07 -0400
Date: Fri, 15 Apr 2011 19:07:01 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: make read-only accessors take const parameters
Message-ID: <20110415160701.GE7112@esdhcp04044.research.nokia.com>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com> <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com> <alpine.DEB.2.00.1104150949210.5863@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104150949210.5863@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/11 09:51 -0500, ext Christoph Lameter wrote:
> On Fri, 15 Apr 2011, Phil Carmody wrote:
> 
> > +++ b/include/linux/mm.h
> > @@ -353,9 +353,16 @@ static inline struct page *compound_head(struct page *page)
> >  	return page;
> >  }
> >
> > -static inline int page_count(struct page *page)
> > +static inline const struct page *compound_head_ro(const struct page *page)
> >  {
> > -	return atomic_read(&compound_head(page)->_count);
> > +	if (unlikely(PageTail(page)))
> > +		return page->first_page;
> > +	return page;
> > +}
> 
> Can you make compound_head take a const pointer too to avoid this?

Not in C, alas. As it returns what it's given I wouldn't want it to lie
about the type of what it returns, and some of its clients want it to
return something writeable.

The simplest macro would have multiple-evaluation issues:

#define compound_head(page) (PageTail(page) ? (page)->first_page : (page))

Not that there are any clients who would misuse that currently, but setting
traps isn't a good way to make things cleaner.

Phil
