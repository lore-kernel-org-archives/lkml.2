Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2HZJBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:01:40 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:60654 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2HZJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:00:50 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 1/4] mm/memblock: reduce overhead in binary search
Date: Sun, 26 Aug 2012 17:00:23 +0800
Message-Id: <1345971626-17090-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12082609-3864-0000-0000-000004562E3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"v1 -> v2": 
* move check from memblock_search to memblock_is_memory
* modify changelog

When checking the indicated address belongs to the memory region, the 
memory regions are checked one by one through binary search, which would 
be a little time consuming. If the indicated address isn't in memory 
region, then we needn't do the time-sonsuming search. The patch adds
more check on the indicated address for that purpose.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memblock.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 4d9393c..258e81d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -888,6 +888,11 @@ int __init memblock_is_reserved(phys_addr_t addr)
 
 int __init_memblock memblock_is_memory(phys_addr_t addr)
 {
+
+	if (unlikely(addr < memblock_start_of_DRAM() ||
+		addr >= memblock_end_of_DRAM()))
+		return 0;
+
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
-- 
1.7.5.4

