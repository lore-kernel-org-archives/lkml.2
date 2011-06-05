Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1FENnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 09:43:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46988 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1FENnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 09:43:20 -0400
Date: Sun, 5 Jun 2011 14:43:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: ENOSPC returned by handle_mm_fault()
Message-ID: <20110605134317.GF11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	When alloc_huge_page() runs afoul of quota, it returns ERR_PTR(-ENOSPC).
Callers do not expect that - hugetlb_cow() returns ENOSPC if it gets that
and so does hugetlb_no_page().  Eventually the thing propagates back to
hugetlb_fault() and is returned by it.

	Callers of hugetlb_fault() clearly expect a bitmap of VM_... and
not something from errno.h: one place is 
                        ret = hugetlb_fault(mm, vma, vaddr,
                                (flags & FOLL_WRITE) ? FAULT_FLAG_WRITE : 0);
                        spin_lock(&mm->page_table_lock);
                        if (!(ret & VM_FAULT_ERROR))
                                continue;
and another is handle_mm_fault(), which ends up returning ENOSPC and *its*
callers are definitely not ready to deal with that.

ENOSPC is 28, i.e. VM_FAULT_MAJOR | VM_FAULT_WRITE | VM_FAULT_HWPOISON;
it's also theoretically possible to get ENOMEM if region_chg() ends up
hitting
                nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
                if (!nrg)
                        return -ENOMEM;
region_chg() <- vma_needs_reservation() <- alloc_huge_page() and from that
point as with ENOSPC.  ENOMEM is 12, i.e. VM_FAULT_MAJOR | VM_FAULT_WRITE...

Am I right assuming that we want VM_FAULT_OOM in both cases?
