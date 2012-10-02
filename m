Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2JBWbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:31:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab2JBWbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:31:50 -0400
Date: Tue, 2 Oct 2012 15:31:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v3 00/10] Introduce huge zero page
Message-Id: <20121002153148.1ae1020a.akpm@linux-foundation.org>
In-Reply-To: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Oct 2012 18:19:22 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> During testing I noticed big (up to 2.5 times) memory consumption overhead
> on some workloads (e.g. ft.A from NPB) if THP is enabled.
> 
> The main reason for that big difference is lacking zero page in THP case.
> We have to allocate a real page on read page fault.
> 
> A program to demonstrate the issue:
> #include <assert.h>
> #include <stdlib.h>
> #include <unistd.h>
> 
> #define MB 1024*1024
> 
> int main(int argc, char **argv)
> {
>         char *p;
>         int i;
> 
>         posix_memalign((void **)&p, 2 * MB, 200 * MB);
>         for (i = 0; i < 200 * MB; i+= 4096)
>                 assert(p[i] == 0);
>         pause();
>         return 0;
> }
> 
> With thp-never RSS is about 400k, but with thp-always it's 200M.
> After the patcheset thp-always RSS is 400k too.

I'd like to see a full description of the design, please.

>From reading the code, it appears that we initially allocate a huge
page and point the pmd at that.  If/when there is a write fault against
that page we then populate the mm with ptes which point at the normal
4k zero page and populate the pte at the fault address with a newly
allocated page?   Correct and complete?  If not, please fix ;)

Also, IIRC, the early versions of the patch did not allocate the
initial huge page at all - it immediately filled the mm with ptes which
point at the normal 4k zero page.  Is that a correct recollection?
If so, why the change?

Also IIRC, Andrea had a little test app which demonstrated the TLB
costs of the inital approach, and they were high?

Please, let's capture all this knowledge in a single place, right here
in the changelog.  And in code comments, where appropriate.  Otherwise
people won't know why we made these decisions unless they go off and
find lengthy, years-old and quite possibly obsolete email threads.


Also, you've presented some data on the memory savings, but no
quantitative testing results on the performance cost.  Both you and
Andrea have run these tests and those results are important.  Let's
capture them here.  And when designing such tests we should not just
try to demonstrate the benefits of a code change - we should think of
test cases whcih might be adversely affected and run those as well.


It's not an appropriate time to be merging new features - please plan
on preparing this patchset against 3.7-rc1.

