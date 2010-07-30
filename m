Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab0G3SWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:22:49 -0400
Received: from kroah.org ([198.145.64.141]:58661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab0G3R4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:43 2010
Message-Id: <20100730175143.125651296@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [103/205] kmemleak: Add support for NO_BOOTMEM configurations
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 9078370c0d2cfe4a905aa34f398bbb0d65921a2b upstream.

With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
friends use the early_res functions for memory management when
NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
corresponding code paths for bootmem allocations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/early_res.c |    6 ++++++
 mm/page_alloc.c    |    5 +++++
 2 files changed, 11 insertions(+)

--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -7,6 +7,8 @@
 #include <linux/bootmem.h>
 #include <linux/mm.h>
 #include <linux/early_res.h>
+#include <linux/slab.h>
+#include <linux/kmemleak.h>
 
 /*
  * Early reserved memory areas.
@@ -319,6 +321,8 @@ void __init free_early(u64 start, u64 en
 	struct early_res *r;
 	int i;
 
+	kmemleak_free_part(__va(start), end - start);
+
 	i = find_overlapped_early(start, end);
 	r = &early_res[i];
 	if (i >= max_early_res || r->end != end || r->start != start)
@@ -333,6 +337,8 @@ void __init free_early_partial(u64 start
 	struct early_res *r;
 	int i;
 
+	kmemleak_free_part(__va(start), end - start);
+
 	if (start == end)
 		return;
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3440,6 +3440,11 @@ void * __init __alloc_memory_core_early(
 		ptr = phys_to_virt(addr);
 		memset(ptr, 0, size);
 		reserve_early_without_check(addr, addr + size, "BOOTMEM");
+		/*
+		 * The min_count is set to 0 so that bootmem allocated blocks
+		 * are never reported as leaks.
+		 */
+		kmemleak_alloc(ptr, size, 0, 0);
 		return ptr;
 	}
 


