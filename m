Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1FETQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:16:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6351 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1FETQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RBD+MvYP5hoKfDbFuIaMXva5oG9gtPZC9iy8+gHV5OInxc5qF+QMX/c0ggizqdHVVb
         g1DPkMcQBjm5W0DuGggQ==
Date: Sun, 5 Jun 2011 12:16:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org
Subject: Re: ENOSPC returned by handle_mm_fault()
In-Reply-To: <20110605134317.GF11521@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1106051141570.5792@sister.anvils>
References: <20110605134317.GF11521@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jun 2011, Al Viro wrote:
> 	When alloc_huge_page() runs afoul of quota, it returns ERR_PTR(-ENOSPC).
> Callers do not expect that - hugetlb_cow() returns ENOSPC if it gets that
> and so does hugetlb_no_page().  Eventually the thing propagates back to
> hugetlb_fault() and is returned by it.
> 
> 	Callers of hugetlb_fault() clearly expect a bitmap of VM_... and
> not something from errno.h: one place is 
>                         ret = hugetlb_fault(mm, vma, vaddr,
>                                 (flags & FOLL_WRITE) ? FAULT_FLAG_WRITE : 0);
>                         spin_lock(&mm->page_table_lock);
>                         if (!(ret & VM_FAULT_ERROR))
>                                 continue;
> and another is handle_mm_fault(), which ends up returning ENOSPC and *its*
> callers are definitely not ready to deal with that.
> 
> ENOSPC is 28, i.e. VM_FAULT_MAJOR | VM_FAULT_WRITE | VM_FAULT_HWPOISON;
> it's also theoretically possible to get ENOMEM if region_chg() ends up
> hitting
>                 nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
>                 if (!nrg)
>                         return -ENOMEM;
> region_chg() <- vma_needs_reservation() <- alloc_huge_page() and from that
> point as with ENOSPC.  ENOMEM is 12, i.e. VM_FAULT_MAJOR | VM_FAULT_WRITE...

Good find, news to me.  Interesting uses of -PTR_ERR()!
Looks like we'd better not have more than 12 VM_FAULT_ flags.

> 
> Am I right assuming that we want VM_FAULT_OOM in both cases?

No, where hugetlb_get_quota() fails it should be VM_FAULT_SIGBUS:
there's no excuse to go on an OOM-killing spree just because hugetlb
quota is exhausted.

VM_FAULT_OOM is appropriate where vma_needs_reservation() fails,
because region_chg() couldn't kmalloc a structure, as you point out.

(Though that doesn't matter much, since the only way the kmalloc can
fail is when this task is already selected for OOM-kill - I think.)

Hugh
