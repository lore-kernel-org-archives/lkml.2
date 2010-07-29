Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0G2TrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:47:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19736 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab0G2TrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:47:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/17] memblock: Add memblock_free/reserve_reserved_regions()
Date: Thu, 29 Jul 2010 12:45:21 -0700
Message-Id: <1280432737-1808-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
References: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C51DA75.006A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can avoid export memblock_reserved_init_regions()
Suggested by Ben.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5334b22..a05eabc 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -48,6 +48,8 @@ extern int memblock_can_resize;
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
+int memblock_free_reserved_regions(void);
+int memblock_reserve_reserved_regions(void);
 
 extern void __init memblock_init(void);
 extern void __init memblock_analyze(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index e7029c8..4db9e25 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -170,6 +170,30 @@ u64 __init_memblock memblock_find_in_range(u64 start, u64 end, u64 size, u64 ali
 	return memblock_find_base(size, align, start, end);
 }
 
+/*
+ * Free memblock.reserved.regions
+ */
+int memblock_free_reserved_regions(void)
+{
+	if (memblock.reserved.regions == memblock_reserved_init_regions)
+		return 0;
+
+	return memblock_free(__pa(memblock.reserved.regions),
+		 sizeof(struct memblock_region) * memblock.reserved.max);
+}
+
+/*
+ * Reserve memblock.reserved.regions
+ */
+int memblock_reserve_reserved_regions(void)
+{
+	if (memblock.reserved.regions == memblock_reserved_init_regions)
+		return 0;
+
+	return memblock_reserve(__pa(memblock.reserved.regions),
+		 sizeof(struct memblock_region) * memblock.reserved.max);
+}
+
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
 	unsigned long i;
-- 
1.6.4.2

