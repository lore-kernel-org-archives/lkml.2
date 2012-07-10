Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2GJKmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:42:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57315 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab2GJKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:42:43 -0400
Date: Tue, 10 Jul 2012 11:42:34 +0100
From: Will Deacon <will.deacon@arm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120710104234.GI9108@mudshark.cambridge.arm.com>
References: <1341412376-6272-1-git-send-email-will.deacon@arm.com>
 <20120709122523.GC4627@tiehlicka.suse.cz>
 <20120709141324.GK7315@mudshark.cambridge.arm.com>
 <alpine.LSU.2.00.1207091622470.2261@eggly.anvils>
 <20120710094513.GB9108@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710094513.GB9108@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:45:13AM +0100, Will Deacon wrote:
> On Tue, Jul 10, 2012 at 12:57:14AM +0100, Hugh Dickins wrote:
> > If I start to grep the architectures for non-empty flush_dcache_page(),
> > I soon find things in arch/arm such as v4_mc_copy_user_highpage() doing
> > if (!test_and_set_bit(PG_dcache_clean,)) __flush_dcache_page() - where
> > the naming suggests that I'm right, it's the architecture's responsibility
> > to arrange whatever flushing is needed in its copy and clear page functions.
> 
> On ARM the flushing is there to deal with dcache aliasing and highmem, so the
> clear/copy functions won't actually do explicit flushing on modern (ARMv7)
> cores. Instead we flush the page when writing the pte and noticing that
> PG_arch_1 (PG_dcache_clean) is clear...
> 
> ...so the real question is why this wasn't being triggered for huge pages.
> I'll go and take another look since I would expect PG_arch_1 to be cleared
> for pages coming back from alloc_huge_page.

Ok, so this is exactly the problem. The hugetlb allocator uses its own
pool of huge pages, so free_huge_page followed by a later alloc_huge_page
will give you something where the page flags of the compound head do not
guarantee that PG_arch_1 is clear.

I tried hacking arch_release_hugepage to clear the bit, but that's only
called when actually releasing the hugepages via __free_pages which is
precisely the case that works correctly anyway!

Will
