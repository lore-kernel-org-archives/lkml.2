Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2IJOsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:48:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2IJOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:48:13 -0400
Subject: Re: [PATCH v2 10/10] thp: implement refcounting for huge zero page
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20120910144438.GA31697@otc-wbsnb-06>
References: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1347282813-21935-11-git-send-email-kirill.shutemov@linux.intel.com>
	 <1347285759.1234.1645.camel@edumazet-glaptop>
	 <20120910144438.GA31697@otc-wbsnb-06>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 16:48:07 +0200
Message-ID: <1347288487.1234.1692.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 17:44 +0300, Kirill A. Shutemov wrote:
> On Mon, Sep 10, 2012 at 04:02:39PM +0200, Eric Dumazet wrote:
> > On Mon, 2012-09-10 at 16:13 +0300, Kirill A. Shutemov wrote:
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > 
> > > H. Peter Anvin doesn't like huge zero page which sticks in memory forever
> > > after the first allocation. Here's implementation of lockless refcounting
> > > for huge zero page.
> > > 
> > ...
> > 
> > > +static unsigned long get_huge_zero_page(void)
> > > +{
> > > +	struct page *zero_page;
> > > +retry:
> > > +	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
> > > +		return ACCESS_ONCE(huge_zero_pfn);
> > > +
> > > +	zero_page = alloc_pages(GFP_TRANSHUGE | __GFP_ZERO, HPAGE_PMD_ORDER);
> > > +	if (!zero_page)
> > > +		return 0;
> > > +	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
> > > +		__free_page(zero_page);
> > > +		goto retry;
> > > +	}
> > 
> > This might break if preemption can happen here ?
> > 
> > The second thread might loop forever because huge_zero_refcount is 0,
> > and huge_zero_pfn not zero.
> 
> I fail to see why the second thread might loop forever. Long time yes, but
> forever?
> 
> Yes, disabling preemption before alloc_pages() and enabling after
> atomic_set() looks reasonable. Thanks.

If you have one online cpu, and the second thread is real time or
something like that, it wont give cpu back to preempted thread.



