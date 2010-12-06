Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0LFQlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:41:16 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:48292 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0LFQlP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 6 Dec 2010 11:41:15 -0500
Message-Id: <4CFD20370200007800026269@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 06 Dec 2010 16:41:11 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <akpm@linux-foundation.org>
Subject: [PATCH] use total_highpages when calculating lowmem-only
	 allocation sizes (core)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those (large) table allocations that come only from lowmem, the
total amount of memory shouldn't really matter.

For vfs_caches_init(), in the same spirit also replace the use of
nr_free_pages() by nr_free_buffer_pages().

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 fs/dcache.c                       |    4 ++--
 init/main.c                       |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.37-rc4/fs/dcache.c
+++ 2.6.37-rc4-use-totalhigh_pages/fs/dcache.c
@@ -2474,10 +2474,10 @@ void __init vfs_caches_init(unsigned lon
 {
 	unsigned long reserve;
 
-	/* Base hash sizes on available memory, with a reserve equal to
+	/* Base hash sizes on available lowmem memory, with a reserve equal to
            150% of current kernel size */
 
-	reserve = min((mempages - nr_free_pages()) * 3/2, mempages - 1);
+	reserve = min((mempages - nr_free_buffer_pages()) * 3/2, mempages - 1);
 	mempages -= reserve;
 
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
--- linux-2.6.37-rc4/init/main.c
+++ 2.6.37-rc4-use-totalhigh_pages/init/main.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/initrd.h>
 #include <linux/bootmem.h>
+#include <linux/highmem.h>
 #include <linux/acpi.h>
 #include <linux/tty.h>
 #include <linux/percpu.h>
@@ -673,13 +674,13 @@ asmlinkage void __init start_kernel(void
 #endif
 	thread_info_cache_init();
 	cred_init();
-	fork_init(totalram_pages);
+	fork_init(totalram_pages - totalhigh_pages);
 	proc_caches_init();
 	buffer_init();
 	key_init();
 	security_init();
 	dbg_late_init();
-	vfs_caches_init(totalram_pages);
+	vfs_caches_init(totalram_pages - totalhigh_pages);
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();



