Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0ENA2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:28:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53088 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0ENAYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/35] x86, lmb: Add lmb_find_area_node()
Date: Thu, 13 May 2010 17:19:33 -0700
Message-Id: <1273796396-29649-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BEC97C9.01B3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can be used to find NODE_DATA for numa.

Need to make sure early_node_map[] is filled before it is called, otherwise
it will fallback to lmb_find_area(), with node range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    1 +
 arch/x86/mm/lmb.c          |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index d0ae19f..358d8a6 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -15,5 +15,6 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
 void lmb_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 lmb_hole_size(u64 start, u64 end);
+u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index faa9ce6..c5fa1dd 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -254,6 +254,21 @@ void __init lmb_free_area(u64 start, u64 end)
 }
 
 /*
+ * Need to call this function after lmb_register_active_regions,
+ * so early_node_map[] is filled already.
+ */
+u64 __init lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	u64 addr;
+	addr = find_memory_core_early(nid, size, align, start, end);
+	if (addr != LMB_ERROR)
+		return addr;
+
+	/* Fallback, should already have start end within node range */
+	return lmb_find_area(start, end, size, align);
+}
+
+/*
  * Finds an active region in the address range from start_pfn to last_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the lmb entry.
  */
-- 
1.6.4.2

