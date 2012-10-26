Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2JZJHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:07:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58827 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757831Ab2JZJHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:07:39 -0400
Date: Fri, 26 Oct 2012 10:07:15 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-ID: <20121026090715.GB20914@mudshark.cambridge.arm.com>
References: <1351183471-14710-1-git-send-email-will.deacon@arm.com>
 <20121026074435.GA871@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026074435.GA871@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 08:44:35AM +0100, Kirill A. Shutemov wrote:
> On Thu, Oct 25, 2012 at 05:44:31PM +0100, Will Deacon wrote:
> > On x86 memory accesses to pages without the ACCESSED flag set result in the
> > ACCESSED flag being set automatically. With the ARM architecture a page access
> > fault is raised instead (and it will continue to be raised until the ACCESSED
> > flag is set for the appropriate PTE/PMD).
> > 
> > For normal memory pages, handle_pte_fault will call pte_mkyoung (effectively
> > setting the ACCESSED flag). For transparent huge pages, pmd_mkyoung will only
> > be called for a write fault.
> > 
> > This patch ensures that faults on transparent hugepages which do not result
> > in a CoW update the access flags for the faulting pmd.
> > 
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> > 
> > Ok chaps, I rebased this thing onto today's next (which basically
> > necessitated a rewrite) so I've reluctantly dropped my acks and kindly
> > ask if you could eyeball the new code, especially where the locking is
> > concerned. In the numa code (do_huge_pmd_prot_none), Peter checks again
> > that the page is not splitting, but I can't see why that is required.
> 
> In handle_mm_fault() we check if the pmd is under splitting without
> page_table_lock. It's kind of speculative cheap check. We need to re-check
> if the PMD is really not under splitting after taking page_table_lock.

I appreciate the need to check whether the thing is splitting, but I thought
that the pmd_same(*pmd, orig_pmd) check after taking the page_table_lock
would be sufficient, because we know that the entry hasn't changed and that
it wasn't splitting before we took the lock. This also mirrors the approach
taken by do_huge_pmd_wp_page.

Is there something I'm missing?

Cheers,

Will
