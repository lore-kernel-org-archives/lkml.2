Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab2HXOe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:34:56 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60670 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab2HXOey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:34:54 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 3/5] mm/memblock: reduce overhead in binary search
Date: Fri, 24 Aug 2012 22:33:38 +0800
Message-Id: <1345818820-12102-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345818820-12102-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082414-5564-0000-0000-0000042C6034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

When checking the indicated address belongs to the memory
or reserved region, the memory or reserved regions are checked
one by one through binary search, which would be a little
time consuming. If the indicated address isn't in memory
region, then we needn't do the time-sonsuming search. The
patch adds more check on the indicated address for that purpose.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memblock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 2feff8d..880e461 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -871,6 +871,10 @@ static int __init_memblock memblock_search(struct memblock_type *type, phys_addr
 {
 	unsigned int left = 0, right = type->cnt;
 
+	if (unlikely(addr < memblock_start_of_DRAM() ||
+		addr >= memblock_end_of_DRAM()))
+			return 0;
+
 	do {
 		unsigned int mid = (right + left) / 2;
 
-- 
1.7.5.4

