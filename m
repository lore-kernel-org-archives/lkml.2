Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2CMFg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:36:58 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:56070 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2CMFg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:36:57 -0400
From: Avery Pennarun <apenwarr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Avery Pennarun <apenwarr@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Yinghai LU <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/5] mm: nobootmem: implement reserve_bootmem() in terms of memblock.
Date: Tue, 13 Mar 2012 01:36:39 -0400
Message-Id: <1331617001-20906-4-git-send-email-apenwarr@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was an implementation for it in mm/bootmem.c, but it was left out of
nobootmem.c, and we can easily write a memblock implementation.  That way
code (eg.  printk) that wants to reserve memory early on can just always
call bootmem on all platforms.

Signed-off-by: Avery Pennarun <apenwarr@gmail.com>
---
 mm/nobootmem.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 24f0fc1..2c269da 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -193,6 +193,29 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 	memblock_free(addr, size);
 }
 
+/**
+ * reserve_bootmem - mark a page range as reserved
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ * @flags: reservation flags (see linux/bootmem.h)
+ *
+ * Partial pages will be reserved.
+ *
+ * The range must be contiguous but may span node boundaries.
+ */
+int __init reserve_bootmem(unsigned long addr, unsigned long size,
+			    int flags)
+{
+	if (flags & BOOTMEM_EXCLUSIVE) {
+		phys_addr_t m = memblock_find_in_range(addr, addr + size,
+					size, PAGE_SIZE);
+		if (m != addr)
+			return -EBUSY;
+	}
+	memblock_reserve(addr, size);
+	return 0;
+}
+
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
-- 
1.7.7.3

