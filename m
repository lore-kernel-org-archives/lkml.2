Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab0GOPFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:05:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59423 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933472Ab0GOPFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:05:20 -0400
Subject: [PATCH] kmemleak: Annotate false positive in
 init_section_page_cgroup()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Adrien Dessemond <adrien.dessemond@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 15 Jul 2010 16:01:17 +0100
Message-ID: <20100715150117.21293.45752.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 15:01:17.0752 (UTC) FILETIME=[93D55B80:01CB242E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer to the page_cgroup table allocated in
init_section_page_cgroup() is stored in section->page_cgroup as (base -
pfn). Since this value does not point to the beginning or inside the
allocated memory block, kmemleak reports a false positive.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Adrien Dessemond <adrien.dessemond@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 6c00814..5bffada 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/swapops.h>
+#include <linux/kmemleak.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -126,6 +127,12 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
 			if (!base)
 				base = vmalloc(table_size);
 		}
+		/*
+		 * The value stored in section->page_cgroup is (base - pfn)
+		 * and it does not point to the memory block allocated above,
+		 * causing kmemleak false positives.
+		 */
+		kmemleak_not_leak(base);
 	} else {
 		/*
  		 * We don't have to allocate page_cgroup again, but

