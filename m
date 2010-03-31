Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0CaCWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:22:33 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:24703 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952Ab0CaCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:22:17 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/33] lmb: Add lmb_find_area_node()
Date: Tue, 30 Mar 2010 19:16:58 -0700
Message-Id: <1270001838-15857-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB2B16D.00B5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can be used to find NODE_DATA for numa.

Need to make sure early_node_map[] is filled before it is called, otherwise
it will fallback to lmb_find_area(), with node range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 mm/lmb.c            |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 5dbc4ef..4078825 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -91,6 +91,7 @@ void lmb_add_memory(u64 start, u64 end);
 u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
+u64 lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
 
 void lmb_to_bootmem(u64 start, u64 end);
 struct range;
diff --git a/mm/lmb.c b/mm/lmb.c
index 72448a5..868886f 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -791,6 +791,21 @@ u64 __init lmb_find_area(u64 start, u64 end, u64 size, u64 align)
 	return -1ULL;
 }
 /*
+ * Need to call this function after lmb_register_active_regions,
+ * so early_node_map[] is filled already.
+ */
+u64 __init lmb_find_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	u64 addr;
+	addr = find_memory_core_early(nid, size, align, start, end);
+	if (addr != -1ULL)
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

