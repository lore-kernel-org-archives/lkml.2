Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab1GNVb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:31:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab1GNV34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
Date: Thu, 14 Jul 2011 21:29:46 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-f9b18db3b1cedc75e5d002a4d7097891c3399736@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, davem@davemloft.net, benh@kernel.crashing.org,
        tj@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, davem@davemloft.net
In-Reply-To: <1310460395-30913-6-git-send-email-tj@kernel.org>
References: <1310460395-30913-6-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Don't allow archs to override memblock_nid_range()
Git-Commit-ID: f9b18db3b1cedc75e5d002a4d7097891c3399736
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:29:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9b18db3b1cedc75e5d002a4d7097891c3399736
Gitweb:     http://git.kernel.org/tip/f9b18db3b1cedc75e5d002a4d7097891c3399736
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 10:46:32 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:45:33 -0700

memblock: Don't allow archs to override memblock_nid_range()

memblock_nid_range() is used to implement memblock_[try_]alloc_nid().
The generic version determines the range by walking early_node_map
with for_each_mem_pfn_range().  The generic version is defined __weak
to allow arch override.

Currently, only sparc overrides it; however, with the previous update
to the generic implementation, there isn't much to be gained with arch
override.  Sparc would behave exactly the same with the generic
implementation.

This patch disallows arch override for memblock_nid_range() and make
both generic and sparc versions static.

sparc is only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310460395-30913-6-git-send-email-tj@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/sparc/mm/init_64.c  |    4 ++--
 include/linux/memblock.h |    1 -
 mm/memblock.c            |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 3fd8e18..8415f61 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -785,7 +785,7 @@ static int find_node(unsigned long addr)
 	return -1;
 }
 
-u64 memblock_nid_range(u64 start, u64 end, int *nid)
+static u64 memblock_nid_range(u64 start, u64 end, int *nid)
 {
 	*nid = find_node(start);
 	start += PAGE_SIZE;
@@ -803,7 +803,7 @@ u64 memblock_nid_range(u64 start, u64 end, int *nid)
 	return start;
 }
 #else
-u64 memblock_nid_range(u64 start, u64 end, int *nid)
+static u64 memblock_nid_range(u64 start, u64 end, int *nid)
 {
 	*nid = 0;
 	return end;
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 3496888..329ffb2 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -89,7 +89,6 @@ extern int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 extern void memblock_dump_all(void);
 
 /* Provided by the architecture */
-extern phys_addr_t memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid);
 extern int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 				   phys_addr_t addr2, phys_addr_t size2);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 97f3486..22cd999 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -508,7 +508,7 @@ phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
  * have been done to populate it.
  */
 
-phys_addr_t __weak __init memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid)
+static phys_addr_t __init memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid)
 {
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 	unsigned long start_pfn, end_pfn;
