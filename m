Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0D1Ah4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:37:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0D1Ahz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:37:55 -0400
Date: Wed, 28 Apr 2010 00:30:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs
 when page tables are being moved after the VMA has already moved
Message-ID: <20100427223004.GF8860@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 10:30:52PM +0100, Mel Gorman wrote:
> During exec(), a temporary stack is setup and moved later to its final
> location. There is a race between migration and exec whereby a migration
> PTE can be placed in the temporary stack. When this VMA is moved under the
> lock, migration no longer knows where the PTE is, fails to remove the PTE
> and the migration PTE gets copied to the new location.  This later causes
> a bug when the migration PTE is discovered but the page is not locked.

This is the real bug, the patch 1 should be rejected and the
expanation-trace has the ordering wrong. The ordering is subtle but
fundamental to prevent that race, split_huge_page also requires the
same anon-vma list_add_tail to avoid the same race between fork and
rmap_walk. It should work fine already with old and new anon-vma code
as they both add new vmas always to the tail of the list.

So the bug in very short, is that "move_page_tables runs out of sync
with vma_adjust in shift_arg_pages"?

> This patch handles the situation by removing the migration PTE when page
> tables are being moved in case migration fails to find them. The alternative
> would require significant modification to vma_adjust() and the locks taken
> to ensure a VMA move and page table copy is atomic with respect to migration.

I'll now evaluate the fix and see if I can find any other
way to handle this.

Great, I'm quite sure with patch 3 we'll move the needle and fix the
bug, it perfectly explains why we only get the oops inside execve in
the stack page.

Patch 2 I didn't check it yet but it's only relevant for the new
anon-vma code, I suggest to handle it separately from the rest.
