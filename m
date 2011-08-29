Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1H2Qtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:49:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21066 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab1H2Qta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:49:30 -0400
Date: Mon, 29 Aug 2011 09:48:48 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: [PATCH V8 1/4] mm: frontswap: swap data structure changes
Message-ID: <20110829164848.GA27185@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4E5BC2FC.0122,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V8 1/4] mm: frontswap: swap data structure changes

This first patch of four in the frontswap series makes available core
swap data structures (swap_lock, swap_list and swap_info) that are
needed by frontswap.c but we don't need to expose them to the dozens
of files that include swap.h so we create a new swapfile.h just to
extern-ify these.

Also add frontswap-related elements to swap_info_struct.  Frontswap_map
points to vzalloc'ed one-bit-per-swap-page metadata that indicates
whether the swap page is in frontswap or in the device and frontswap_pages
counts how many pages are in frontswap.

[v8: rebase to 3.0-rc4]
[v8: kamezawa.hiroyu@jp.fujitsu.com: frontswap_pages should be atomic_t]
[v8: kamezawa.hiroyu@jp.fujitsu.com: comment to clarify informational counters]
[v7: rebase to 3.0-rc3]
[v7: JBeulich@novell.com: add new swap struct elements only if config'd]
[v6: rebase to 3.0-rc1]
[v5: no change from v4]
[v4: rebase to 2.6.39]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
Reviewed-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Jan Beulich <JBeulich@novell.com>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Rik Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

--- linux/include/linux/swapfile.h	1969-12-31 17:00:00.000000000 -0700
+++ frontswap/include/linux/swapfile.h	2011-08-29 09:52:14.305755924 -0600
@@ -0,0 +1,13 @@
+#ifndef _LINUX_SWAPFILE_H
+#define _LINUX_SWAPFILE_H
+
+/*
+ * these were static in swapfile.c but frontswap.c needs them and we don't
+ * want to expose them to the dozens of source files that include swap.h
+ */
+extern spinlock_t swap_lock;
+extern struct swap_list_t swap_list;
+extern struct swap_info_struct *swap_info[];
+extern int try_to_unuse(unsigned int, bool, unsigned long);
+
+#endif /* _LINUX_SWAPFILE_H */
--- linux/include/linux/swap.h	2011-08-08 08:19:25.880690134 -0600
+++ frontswap/include/linux/swap.h	2011-08-29 10:02:53.152685666 -0600
@@ -194,6 +194,10 @@ struct swap_info_struct {
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
+#ifdef CONFIG_FRONTSWAP
+	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
+	atomic_t frontswap_pages;	/* frontswap pages in-use counter */
+#endif
 };
 
 struct swap_list_t {
