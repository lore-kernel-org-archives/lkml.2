Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1GEIXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:23:42 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34481 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab1GEIXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:23:07 -0400
From: Ankita Garg <ankita@in.ibm.com>
To: linux-mm@kvack.org
Cc: ankita@in.ibm.com, svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] Capture references to page cache pages
Date: Tue,  5 Jul 2011 13:52:38 +0530
Message-Id: <1309854159-8277-5-git-send-email-ankita@in.ibm.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
References: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Page cache accesses may not be mapped, hence fake an access when a
pagecache page is looked up, by marking the corresponding memory
address block as accessed.

Signed-off-by: Ankita Garg <ankita@in.ibm.com>
---
 mm/filemap.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a8251a8..7ae7f36 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -36,6 +36,7 @@
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include <linux/cleancache.h>
 #include "internal.h"
+#include <linux/memtrace.h>
 
 /*
  * FIXME: remove all knowledge of the buffer layer from the core VM
@@ -730,6 +731,13 @@ repeat:
 			page_cache_release(page);
 			goto repeat;
 		}
+#if defined(CONFIG_MEMTRACE)
+		if(get_pg_trace_pid() != -1 && current->mem_trace) {
+			unsigned long pfn = page_to_pfn(page);
+			if(pfn_valid(pfn))
+				mark_memtrace_block_accessed(pfn << PAGE_SHIFT);
+		}
+#endif
 	}
 out:
 	rcu_read_unlock();
-- 
1.7.4

