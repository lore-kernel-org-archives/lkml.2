Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2BUI6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:58:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38672 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2BUI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:58:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of geunsik.lim@gmail.com designates 10.68.196.168 as permitted sender) smtp.mail=geunsik.lim@gmail.com; dkim=pass header.i=geunsik.lim@gmail.com
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH, v2] Fix potentially derefencing uninitialized 'r'.
Date: Tue, 21 Feb 2012 17:58:23 +0900
Message-Id: <1329814703-14398-1-git-send-email-geunsik.lim@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

v2: reorganize the code with better way to avoid compilation warning
via the comment of Andrew Morton.

v1: struct memblock_region 'r' will not be initialized potentially
because of while() condition in __next_mem_pfn_range()function.
Solve the compilation warning related problem by initializing
r data structure.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 mm/memblock.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 77b5f22..b8c40c5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -673,14 +673,18 @@ void __init_memblock __next_mem_pfn_range(int *idx, int nid,
 	struct memblock_type *type = &memblock.memory;
 	struct memblock_region *r;
 
-	while (++*idx < type->cnt) {
+	do {
 		r = &type->regions[*idx];
 
+	   if (++*idx < type->cnt) {
 		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
 			continue;
 		if (nid == MAX_NUMNODES || nid == r->nid)
 			break;
-	}
+	   } else
+		break;
+	} while (1);
+
 	if (*idx >= type->cnt) {
 		*idx = -1;
 		return;
-- 
1.7.8.1

