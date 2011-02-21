Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1BUTIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:08:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:8560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1BUTIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:08:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,201,1297065600"; 
   d="scan'208";a="711415550"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        lwoodman@redhat.com
Subject: Fix NUMA problems in transparent hugepages and KSM
Date: Mon, 21 Feb 2011 11:07:42 -0800
Message-Id: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current transparent hugepages daemon can mess up local
memory affinity on NUMA systems. When it copies memory to a 
huge page it does not necessarily keep it on the same
node as the local allocations.

While fixing this I also found some more related issues:
- The NUMA policy interleaving for THP was using the small
page size, not the large parse size.
- KSM and THP copies also did not preserve the local node
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
      Fix interleaving for transparent hugepages
      Change alloc_pages_vma to pass down the policy node for local policy
      Preserve local node for KSM copies
      Preserve original node for transparent huge page copies
      Use correct numa policy node for transparent hugepages
      Add __GFP_OTHER_NODE flag
      Use GFP_OTHER_NODE for transparent huge pages
      Add VM counters for transparent hugepages

 include/linux/gfp.h    |   13 ++++++++---
 include/linux/vmstat.h |   11 ++++++++-
 mm/huge_memory.c       |   49 +++++++++++++++++++++++++++++++++--------------
 mm/ksm.c               |    3 +-
 mm/mempolicy.c         |   16 +++++++-------
 mm/page_alloc.c        |    2 +-
 mm/vmstat.c            |   17 ++++++++++++++-
 7 files changed, 78 insertions(+), 33 deletions(-)

-Andi
