Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab0GDHBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:01:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64001 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab0GDHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:01:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/23] x86, lmb: Add lmb_x86_find_in_range_node()
Date: Sat,  3 Jul 2010 23:56:19 -0700
Message-Id: <1278226587-31213-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
References: <1278226587-31213-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C303196.01EA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can be used to find NODE_DATA for numa.

Need to make sure early_node_map[] is filled before it is called, otherwise
it will fallback to lmb_find_in_range(), with node range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    1 +
 arch/x86/mm/lmb.c          |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index f7595fd..2ba2394 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -14,5 +14,6 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
 void lmb_x86_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_x86_hole_size(u64 start, u64 end);
+u64 lmb_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index d17e115..a99f879 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -240,6 +240,21 @@ void __init lmb_x86_free_range(u64 start, u64 end)
 }
 
 /*
+ * Need to call this function after lmb_x86_register_active_regions,
+ * so early_node_map[] is filled already.
+ */
+u64 __init lmb_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	u64 addr;
+	addr = find_memory_core_early(nid, size, align, start, end);
+	if (addr != LMB_ERROR)
+		return addr;
+
+	/* Fallback, should already have start end within node range */
+	return lmb_find_in_range(start, end, size, align);
+}
+
+/*
  * Finds an active region in the address range from start_pfn to last_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the lmb entry.
  */
-- 
1.6.4.2

