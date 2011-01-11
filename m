Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1AKLpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:45:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33600 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1AKLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:45:17 -0500
Date: Tue, 11 Jan 2011 11:44:54 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix migration hangs on anon_vma lock
Message-ID: <20110111114453.GC11932@csn.ul.ie>
References: <alpine.LSU.2.00.1101102259160.24988@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1101102259160.24988@sister.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 11:08:04PM -0800, Hugh Dickins wrote:
> Increased usage of page migration in mmotm reveals that the anon_vma
> locking in unmap_and_move() has been deficient since 2.6.36 (or even
> earlier). 

Hmm, a certain amount of the compaction work was spent fixing migration
bugs. I wonder if there are mysterious bug reports out there related to the
use of move_pages() that are only getting fixed now.

> Review at the time of f18194275c39835cb84563500995e0d503a32d9a
> "mm: fix hang on anon_vma->root->lock" missed the issue here: the anon_vma
> to which we get a reference may already have been freed back to its slab
> (it is in use when we check page_mapped, but that can change), and so its
> anon_vma->root may be switched at any moment by reuse in anon_vma_prepare.
> 
> Perhaps we could fix that with a get_anon_vma_unless_zero(), but let's not:
> just rely on page_lock_anon_vma() to do all the hard thinking for us, then
> we don't need any rcu read locking over here.
> 
> In removing the rcu_unlock label: since PageAnon is a bit in page->mapping,
> it's impossible for a !page->mapping page to be anon; but insert VM_BUG_ON
> in case the implementation ever changes.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@kernel.org [2.6.37, 2.6.36]

Reasoning and patch look correct. Light testing did not show up any
obvious problems.

Reviewed-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
