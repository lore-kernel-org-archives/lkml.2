Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1EVW1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:27:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1EVW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=thzTrgw6x1slLpd8ZzFELPc6mrxD2GkcR3bxbF097zfbAdtGFvvJyy8gkDRwyS4fwz
         GVH01B6i2sQDtauLepBA==
Date: Sun, 22 May 2011 15:27:41 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Consistency of loops in mm/truncate.c?
Message-ID: <alpine.LSU.2.00.1105221526020.17400@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I have a series aimed at 2.6.41 to remove mm/shmem.c's peculiar radix
tree of swap entries, using slots in the file's standard radix_tree
instead - prompted in part by https://lkml.org/lkml/2011/1/22/110

There's a patch to give shmem its own truncation loop, handling pages
and swap entries in the same pass.  For that I want to start from a
copy of truncate_inode_page_range(), but notice some discrepancies
between the different loops in mm/truncate.c, so want to standardize
them first before copying.

The advancement of index is hard to follow: we rely upon page->index
of an unlocked page persisting, yet we're ashamed of doing so, sometimes
reading it again once locked.  invalidate_mapping_pages() apologizes for
this, but I think we should now just document that page->index is not
modified until the page is freed.

invalidate_inode_pages2_range() has two sophistications not seen
elsewhere, which 7afadfdc says were folded in by akpm (along with
a page->index one):

- Don't look up more pages than we're going to use:
  seems a good thing for me to fold into truncate_inode_pages_range()
  and invalidate_mapping_pages() too.

- Check for the cursor wrapping at the end of the mapping:
  but with

#if BITS_PER_LONG==32
#define MAX_LFS_FILESIZE (((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
#elif BITS_PER_LONG==64
#define MAX_LFS_FILESIZE 0x7fffffffffffffffUL
#endif

  I don't see how page->index + 1 would ever be 0, even if one or
  other of those "-1"s went away; so may I delete the "wrapped" case?

Thanks,
Hugh
