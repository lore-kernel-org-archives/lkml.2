Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab1LQH6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:58:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LQH5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:57:52 -0500
Date: Fri, 16 Dec 2011 23:57:44 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] rtth: maintain nr_allocated atomically
In-Reply-To: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1112162356310.1981@eggly.anvils>
References: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone has been worrying about radix_tree_node leaks, and inserted a
lot of nr_allocated printfs; but it often came out negative because it
was not manipulated atomically.  We're already using userspace-rcu, so
use its uatomic implementation on nr_allocated (but the count still
doesn't go down to zero at the end).

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 linux.c |    5 +++--
 main.c  |    4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- rtth3/linux.c	2010-08-25 13:30:45.000000000 -0700
+++ rtth4/linux.c	2011-12-16 18:44:05.587897075 -0800
@@ -6,6 +6,7 @@
 
 #include <linux/mempool.h>
 #include <linux/slab.h>
+#include <urcu/uatomic_arch.h>
 
 int nr_allocated;
 
@@ -35,14 +36,14 @@ void *kmem_cache_alloc(struct kmem_cache
 	void *ret = malloc(cachep->size);
 	if (cachep->ctor)
 		cachep->ctor(ret);
-	nr_allocated++;
+	uatomic_inc(&nr_allocated);
 	return ret;
 }
 
 void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 {
 	assert(objp);
-	nr_allocated--;
+	uatomic_dec(&nr_allocated);
 	memset(objp, 0, cachep->size);
 	free(objp);
 }
--- rtth3/main.c	2011-01-24 22:12:10.000000000 -0800
+++ rtth4/main.c	2011-12-16 18:44:05.587897075 -0800
@@ -261,8 +261,10 @@ int main()
 
 	regression1_test();
 	regression2_test();
-
 	single_thread_tests();
 
+	sleep(1);
+	printf("after sleep(1): %d allocated\n", nr_allocated);
+
 	exit(0);
 }
