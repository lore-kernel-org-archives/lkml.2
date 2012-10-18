Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2JRX6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:58:37 -0400
Received: from shutemov.name ([176.9.204.213]:59962 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2JRX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:58:36 -0400
Date: Fri, 19 Oct 2012 02:59:41 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-ID: <20121018235941.GA32397@shutemov.name>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
 <20121018164502.b32791e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018164502.b32791e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 04:45:02PM -0700, Andrew Morton wrote:
> On Mon, 15 Oct 2012 09:00:59 +0300
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > H. Peter Anvin doesn't like huge zero page which sticks in memory forever
> > after the first allocation. Here's implementation of lockless refcounting
> > for huge zero page.
> > 
> > We have two basic primitives: {get,put}_huge_zero_page(). They
> > manipulate reference counter.
> > 
> > If counter is 0, get_huge_zero_page() allocates a new huge page and
> > takes two references: one for caller and one for shrinker. We free the
> > page only in shrinker callback if counter is 1 (only shrinker has the
> > reference).
> > 
> > put_huge_zero_page() only decrements counter. Counter is never zero
> > in put_huge_zero_page() since shrinker holds on reference.
> > 
> > Freeing huge zero page in shrinker callback helps to avoid frequent
> > allocate-free.
> 
> I'd like more details on this please.  The cost of freeing then
> reinstantiating that page is tremendous, because it has to be zeroed
> out again.  If there is any way at all in which the kernel can be made
> to enter a high-frequency free/reinstantiate pattern then I expect the
> effects would be quite bad.
> 
> Do we have sufficient mechanisms in there to prevent this from
> happening in all cases?  If so, what are they, because I'm not seeing
> them?

We only free huge zero page in shrinker callback if nobody in the system
uses it. Never on put_huge_zero_page(). Shrinker runs only under memory
pressure or if user asks (drop_caches).
Do you think we need an additional protection mechanism?

> 
> > Refcounting has cost. On 4 socket machine I observe ~1% slowdown on
> > parallel (40 processes) read page faulting comparing to lazy huge page
> > allocation.  I think it's pretty reasonable for synthetic benchmark.

-- 
 Kirill A. Shutemov
