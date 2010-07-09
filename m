Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0GIRgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:36:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0GIRgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:36:19 -0400
Date: Fri, 9 Jul 2010 19:36:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
Message-ID: <20100709173612.GF5741@random.random>
References: <4C373AEC.6000502@goop.org>
 <20100709151211.GE13493@random.random>
 <4C37458B.8040408@goop.org>
 <20100709162255.GA5741@random.random>
 <4C375CC8.2030705@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C375CC8.2030705@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 10:30:48AM -0700, Jeremy Fitzhardinge wrote:
> On 07/09/2010 09:22 AM, Andrea Arcangeli wrote:
> > mmu notifier only relevant for userland mappings, not kernel
> > mappings. I don't know about the xen use, but for vmalloc certainly it
> > can't be a problem to remove those two mmu notifier invalidates.
> >
> > Only bit that is worrysome is the mm == &init_mm
> > pte_alloc_kernel|pte_alloc_map_lock. That seems to imply it may also
> > be used to mangle over userland. But apparently all users are passing
> > &init_mm as expected. I guess if you remove the mm parameter and you
> > default to &init_mm definitely there will be no risk in removing the
> > mmu notifier range_start/end invalidates.
> >   
> 
> No, we do have some users which use it on user memory.  But those users
> are using it as part of their own mmu notifier backend, so the recursive
> calls are causing a problem.  My point is that anyone using
> apply_to_page_range should be making their own calls to mmu notifiers as
> appropriate to whatever they're doing.

Makes sense, it was hard in fact to see how it would cause any problem
for you considering nobody registers mmu notifiers into mm_init...

I've to say it's next to trivial for them to detect recursion and skip
the inner superflous call if they run it under a lock. But be careful
that pte_alloc/pmd_alloc and friends can block and break the mmu
notifier locking. I'm not really sure if it apply_to_page_range is a
sane interface to use inside mmu notifier methods considering it's
supposedly a blocking operation, caller must be careful to use that
inside a mmu notifier callback anyway...

I'm not opposed to removing it, I've been wondering if it made any
sense in the first place but then there was no point not to add
it. Just calling apply_to_page_range in non blocking context doesn't
look so good.
