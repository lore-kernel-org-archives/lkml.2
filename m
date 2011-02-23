Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1BWBwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:52:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:43154 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1BWBwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:52:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,209,1297065600"; 
   d="scan'208";a="890284761"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Fix NUMA problems in transparent hugepages v2
Date: Tue, 22 Feb 2011 17:51:54 -0800
Message-Id: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: I dropped the controversal KSM changes and fixed
the interleaving bug. Now it's purely for transparent huge pages.

The current transparent hugepages daemon can mess up local
memory affinity on NUMA systems. When it copies memory to a 
huge page it does not necessarily keep it on the same
node as the local allocations.

While fixing this I also found some more related issues:
- The NUMA policy interleaving for THP was using the small
page size, not the large parse size.
- THP copies also did not preserve the local node
- The accounting for local/remote allocations in the daemon
was misleading.
- There were no VM statistics counters for THP, which made it 
impossible to analyze.
 
At least some of the bug fixes are 2.6.38 candidates IMHO
because some of the NUMA problems are pretty bad. In some workloads
this can cause performance problems. 

What can be delayed are GFP_OTHERNODE and the statistics changes.

Git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git thp-numa

Andi Kleen (8):
      Fix interleaving for transparent hugepages v2
      Change alloc_pages_vma to pass down the policy node for local policy
      Add alloc_page_vma_node
      Preserve original node for transparent huge page copies
      Use correct numa policy node for transparent hugepages
      Add __GFP_OTHER_NODE flag
      Use GFP_OTHER_NODE for transparent huge pages
      Add VM counters for transparent hugepages

 include/linux/gfp.h    |   13 ++++++++---
 include/linux/vmstat.h |   11 ++++++++-
 mm/huge_memory.c       |   49 +++++++++++++++++++++++++++++++++--------------
 mm/mempolicy.c         |   16 +++++++-------
 mm/page_alloc.c        |    2 +-
 mm/vmstat.c            |   17 ++++++++++++++-
 6 files changed, 76 insertions(+), 32 deletions(-)

