Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2JRXpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:45:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2JRXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:45:03 -0400
Date: Thu, 18 Oct 2012 16:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-Id: <20121018164502.b32791e7.akpm@linux-foundation.org>
In-Reply-To: <1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 09:00:59 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> H. Peter Anvin doesn't like huge zero page which sticks in memory forever
> after the first allocation. Here's implementation of lockless refcounting
> for huge zero page.
> 
> We have two basic primitives: {get,put}_huge_zero_page(). They
> manipulate reference counter.
> 
> If counter is 0, get_huge_zero_page() allocates a new huge page and
> takes two references: one for caller and one for shrinker. We free the
> page only in shrinker callback if counter is 1 (only shrinker has the
> reference).
> 
> put_huge_zero_page() only decrements counter. Counter is never zero
> in put_huge_zero_page() since shrinker holds on reference.
> 
> Freeing huge zero page in shrinker callback helps to avoid frequent
> allocate-free.

I'd like more details on this please.  The cost of freeing then
reinstantiating that page is tremendous, because it has to be zeroed
out again.  If there is any way at all in which the kernel can be made
to enter a high-frequency free/reinstantiate pattern then I expect the
effects would be quite bad.

Do we have sufficient mechanisms in there to prevent this from
happening in all cases?  If so, what are they, because I'm not seeing
them?

> Refcounting has cost. On 4 socket machine I observe ~1% slowdown on
> parallel (40 processes) read page faulting comparing to lazy huge page
> allocation.  I think it's pretty reasonable for synthetic benchmark.
