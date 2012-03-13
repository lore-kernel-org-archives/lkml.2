Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab2CMFhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:37:00 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:54485 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2CMFg5 (ORCPT
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
Subject: [PATCH 2/5] mm: bootmem: it's okay to reserve_bootmem an invalid address.
Date: Tue, 13 Mar 2012 01:36:38 -0400
Message-Id: <1331617001-20906-3-git-send-email-apenwarr@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...but only if you provide BOOTMEM_EXCLUSIVE, which should guarantee that
you're actually checking the return value.  In that case, just return an
error code if the memory you tried to get is invalid.  This lets callers
safely probe around for a valid memory range.

If you don't use BOOTMEM_EXCLUSIVE and the memory address is invalid, just
crash as before, since the caller is probably not bothering to check the
return value.

Signed-off-by: Avery Pennarun <apenwarr@gmail.com>
---
 mm/bootmem.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 7a9f505..d397dae 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -351,7 +351,10 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 			return 0;
 		pos = bdata->node_low_pfn;
 	}
-	BUG();
+	/* people who don't use BOOTMEM_EXCLUSIVE don't check the return
+	 * value, so BUG() if it goes wrong. */
+	BUG_ON(!(reserve && (flags & BOOTMEM_EXCLUSIVE));
+	return -ENOENT;
 }
 
 /**
@@ -421,7 +424,7 @@ int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 }
 
 /**
- * reserve_bootmem - mark a page range as usable
+ * reserve_bootmem - mark a page range as reserved
  * @addr: starting address of the range
  * @size: size of the range in bytes
  * @flags: reservation flags (see linux/bootmem.h)
-- 
1.7.7.3

