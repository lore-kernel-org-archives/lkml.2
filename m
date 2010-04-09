Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0DIGN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:13:29 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:27752 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0DIGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:07:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 26/39] nobootmem: use lmb.default_alloc_limit in alloc_bootmem path
Date: Thu,  8 Apr 2010 23:03:55 -0700
Message-Id: <1270793048-23796-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBEC3F3.008E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic version __lmb_find_area() is going from high to low, and for 32bit
active_region for 32bit does include high pages

need to replace the limit with lmb.default_alloc_limit, aka get_max_mapped()

with this patch, x86 32bit could use generic version of __lmb_find_area()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/page_alloc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 79bd44b..256aed0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3445,6 +3445,9 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 
 	u64 addr;
 
+	if (limit > lmb.default_alloc_limit)
+		limit = lmb.default_alloc_limit;
+
 	addr = find_memory_core_early(nid, size, align, goal, limit);
 
 	if (addr == -1ULL)
-- 
1.6.4.2

