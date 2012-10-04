Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2JDKgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab2JDKf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:35:59 -0400
Date: Thu, 4 Oct 2012 12:35:48 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH 0/8] THP support for Sparc64
Message-ID: <20121004103548.GB6793@redhat.com>
References: <20121002.182601.845433592794197720.davem@davemloft.net>
 <20121002155544.2c67b1e8.akpm@linux-foundation.org>
 <20121003.220027.1636081487098835868.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003.220027.1636081487098835868.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Wed, Oct 03, 2012 at 10:00:27PM -0400, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 2 Oct 2012 15:55:44 -0700
> 
> > I had a shot at integrating all this onto the pending stuff in linux-next. 
> > "mm: Add and use update_mmu_cache_pmd() in transparent huge page code."
> > needed minor massaging in huge_memory.c.  But as Andrea mentioned, we
> > ran aground on Gerald's
> > http://ozlabs.org/~akpm/mmotm/broken-out/thp-remove-assumptions-on-pgtable_t-type.patch,
> > part of the thp-for-s390 work.
> 
> While working on a rebase relative to this work, I noticed that the
> s390 patches don't even compile.
> 
> It's because of that pmd_pgprot() change from Peter Z. which arrives
> asynchonously via the linux-next tree.  It makes THP start using
> pmd_pgprot() (a new interface) which the s390 patches don't provide.

My suggestion would be to ignore linux-next and port it to -mm only
and re-send to Andrew. schednuma is by mistake in linux-next, and
it's not going to get merged as far as I can tell.

Even if schednuma would get merged by mistake, pmd_pgprot is a micro
optimization and it's by no means necessary. I don't think it's clean
to add arch dependencies like that just for a micro optimization mixed
up with schednuma code. The implementation of the AutoNUMA NUMA
hinting page faults that was introduced recently in schednuma is also
very bad, all checks on the vmas vm_page_prot are totally unnecessary
because _PAGE_PROTNONE and _PAGE_NUMA are mutually exclusive code
paths, _PAGE_PROTNONE would segfault before ever entering
handle_mm_fault and so checking if it's _PAGE_PROTNONE in
handle_mm_fault is unnecessary. Calling pte_numa do_prot_none also
sounds very confusing to me.
