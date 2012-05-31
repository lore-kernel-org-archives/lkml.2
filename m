Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2EaF0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:26:20 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58988 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab2EaF0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:26:15 -0400
Date: Thu, 31 May 2012 10:55:40 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -V7 05/14] hugetlb: avoid taking i_mmap_mutex in
 unmap_single_vma() for hugetlb
Message-ID: <20120531052540.GA24855@skywalker.linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205301857170.25774@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301857170.25774@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12053019-0260-0000-0000-000001433D7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 06:57:47PM -0700, David Rientjes wrote:
> On Wed, 30 May 2012, Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > i_mmap_mutex lock was added in unmap_single_vma by 502717f4e ("hugetlb:
> > fix linked list corruption in unmap_hugepage_range()") but we don't use
> > page->lru in unmap_hugepage_range any more.  Also the lock was taken
> > higher up in the stack in some code path.  That would result in deadlock.
> > 
> > unmap_mapping_range (i_mmap_mutex)
> >  -> unmap_mapping_range_tree
> >     -> unmap_mapping_range_vma
> >        -> zap_page_range_single
> >          -> unmap_single_vma
> > 	      -> unmap_hugepage_range (i_mmap_mutex)
> > 
> 
> You should be able to show this with lockdep?

I was not able to get a lockdep report

> 
> > For shared pagetable support for huge pages, since pagetable pages are ref
> > counted we don't need any lock during huge_pmd_unshare.  We do take
> > i_mmap_mutex in huge_pmd_share while walking the vma_prio_tree in mapping.
> > (39dde65c9940c97f ("shared page table for hugetlb page")).
> > 
> 
> I think this should be folded into patch 4, the code you're removing here 
> is just added in that function unnecessarily.
> 

I am removing i_mmap_mutex in this patch. That is not added in patch 4.

-aneesh

