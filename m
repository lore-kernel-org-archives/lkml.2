Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab0FVR22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:28:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32311 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab0FVR2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/25] lmb: Add lmb_find_in_range()
Date: Tue, 22 Jun 2010 10:26:36 -0700
Message-Id: <1277227614-11581-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4C20F2A0.0008,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is a wrapper for lmb_find_base

make it more easy for x86 to use lmb. ( rebase )
x86 early_res is using find/reserve pattern instead of alloc.

keep it in weak version, so later We can use x86 own version if needed.
also We need it in lib/lmb.c, so one caller mm/page_alloc.c could get compiled

-v2: Change name to lmb_find_in_range() according to Michael Ellerman
-v3: Add generic weak version __lmb_find_in_range()
     so keep the path for fallback to x86 version that handle from low
-v4: use 0 for failing path
-v5: use LMB_ERROR again
-v6: remove __lmb_find_in_range()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    2 ++
 lib/lmb.c           |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 5310c7b..6ca5659 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -45,6 +45,8 @@ extern int lmb_debug;
 extern int lmb_can_resize;
 extern struct lmb_region lmb_reserved_init_regions[];
 
+u64 lmb_find_in_range(u64 start, u64 end, u64 size, u64 align);
+
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
 extern long lmb_add(phys_addr_t base, phys_addr_t size);
diff --git a/lib/lmb.c b/lib/lmb.c
index e45e967..2e00159 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -156,6 +156,14 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
 	return LMB_ERROR;
 }
 
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init __weak lmb_find_in_range(u64 start, u64 end, u64 size, u64 align)
+{
+	return lmb_find_base(size, align, start, end);
+}
+
 static void __init_lmb lmb_remove_region(struct lmb_type *type, unsigned long r)
 {
 	unsigned long i;
-- 
1.6.4.2

