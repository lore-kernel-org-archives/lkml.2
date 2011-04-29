Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab1D2S7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:59:00 -0400
Received: from kroah.org ([198.145.64.141]:35087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206Ab1D2S6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:56 2011
Message-Id: <20110429185656.804658161@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>,
        Americo Wang <xiyou.wangcong@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [44/55] vfs: avoid large kmalloc()s for the fdtable
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 6d4831c283530a5f2c6bd8172c13efa236eb149d upstream.

Azurit reports large increases in system time after 2.6.36 when running
Apache.  It was bisected down to a892e2d7dcdfa6c76e6 ("vfs: use kmalloc()
to allocate fdmem if possible").

That patch caused the vfs to use kmalloc() for very large allocations and
this is causing excessive work (and presumably excessive reclaim) within
the page allocator.

Fix it by falling back to vmalloc() earlier - when the allocation attempt
would have been considered "costly" by reclaim.

Reported-by: azurIt <azurit@pobox.sk>
Tested-by: azurIt <azurit@pobox.sk>
Acked-by: Changli Gao <xiaosuo@gmail.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/file.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/mmzone.h>
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -39,14 +40,17 @@ int sysctl_nr_open_max = 1024 * 1024; /*
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static inline void *alloc_fdmem(unsigned int size)
+static void *alloc_fdmem(unsigned int size)
 {
-	void *data;
-
-	data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
-	if (data != NULL)
-		return data;
-
+	/*
+	 * Very large allocations can stress page reclaim, so fall back to
+	 * vmalloc() if the allocation size will be considered "large" by the VM.
+	 */
+	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		if (data != NULL)
+			return data;
+	}
 	return vmalloc(size);
 }
 


