Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2KOVwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:52:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KOVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:52:47 -0500
Date: Thu, 15 Nov 2012 13:52:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 08/11] thp: setup huge zero page on non-write page
 fault
In-Reply-To: <20121115093209.GF9676@otc-wbsnb-06>
Message-ID: <alpine.DEB.2.00.1211151348080.27188@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-9-git-send-email-kirill.shutemov@linux.intel.com> <alpine.DEB.2.00.1211141531110.22537@chino.kir.corp.google.com> <20121115093209.GF9676@otc-wbsnb-06>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Kirill A. Shutemov wrote:

> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index f36bc7d..41f05f1 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -726,6 +726,16 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
> > >  			return VM_FAULT_OOM;
> > >  		if (unlikely(khugepaged_enter(vma)))
> > >  			return VM_FAULT_OOM;
> > > +		if (!(flags & FAULT_FLAG_WRITE)) {
> > > +			pgtable_t pgtable;
> > > +			pgtable = pte_alloc_one(mm, haddr);
> > > +			if (unlikely(!pgtable))
> > > +				goto out;
> > 
> > No use in retrying, just return VM_FAULT_OOM.
> 
> Hm. It's consistent with non-hzp path: if pte_alloc_one() in
> __do_huge_pmd_anonymous_page() fails __do_huge_pmd_anonymous_page()
> returns VM_FAULT_OOM which leads to "goto out".
> 

If the pte_alloc_one(), which wraps __pte_alloc(), you're adding fails, 
it's pointless to "goto out" to try __pte_alloc() which we know won't 
succeed.

> Should it be fixed too?
> 

It's done for maintainablility because although 
__do_huge_pmd_anonymous_page() will only return VM_FAULT_OOM today when 
pte_alloc_one() fails, if it were to ever fail in a different way then the 
caller is already has a graceful failure.
