Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1CCAqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:46:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:4596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1CCAqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:46:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="396661308"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Fix NUMA problems in transparent hugepages and KSM
Date: Wed,  2 Mar 2011 16:45:20 -0800
Message-Id: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Updated version, mainly for integrating Andrea's fixes.
This should be ready for merge now. At least the core
bug fixes for hugepaged I would like to see in 38.]

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

