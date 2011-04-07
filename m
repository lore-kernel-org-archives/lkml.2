Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab1DGRXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:23:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48667 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab1DGRXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:23:07 -0400
Subject: [PATCH] print vmalloc() state after allocation failures
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 07 Apr 2011 10:23:02 -0700
Message-Id: <20110407172302.3B7546DA@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was tracking down a page allocation failure that ended up in vmalloc().
Since vmalloc() uses 0-order pages, if somebody asks for an insane amount
of memory, we'll still get a warning with "order:0" in it.  That's not
very useful.

During recovery, vmalloc() also nicely frees all of the memory that it
got up to the point of the failure.  That is wonderful, but it also
quickly hides any issues.  We have a much different sitation if vmalloc()
repeatedly fails 10GB in to:

	vmalloc(100 * 1<<30);

versus repeatedly failing 4096 bytes in to a:

	vmalloc(8192);

This will print out messages that look like this:

[   30.040774] bash: vmalloc failure allocating after 0 / 73728 bytes

As a side issue, I also noticed that ctl_ioctl() does vmalloc() based
solely on an unverified value passed in from userspace.  Granted, it's
under CAP_SYS_ADMIN, but it still frightens me a bit.

multipathd: page allocation failure. order:0, mode:0xd2
Call Trace:
[c0000000f34ef570] [c000000000012d84] .show_stack+0x74/0x1c0 (unreliable)
[c0000000f34ef620] [c000000000159ed4] .__alloc_pages_nodemask+0x574/0x830
[c0000000f34ef7a0] [c00000000019306c] .alloc_pages_current+0x8c/0x110
[c0000000f34ef840] [c000000000183bdc] .__vmalloc_area_node+0x17c/0x220
[c0000000f34ef900] [d00000000132bb24] .copy_params+0x74/0xc0 [dm_mod]
[c0000000f34efad0] [d00000000132bcec] .ctl_ioctl+0x17c/0x2c0 [dm_mod]
[c0000000f34efb90] [d00000000132be48] .dm_ctl_ioctl+0x18/0x30 [dm_mod]
[c0000000f34efc00] [c0000000001c4ee4] .vfs_ioctl+0x54/0x140
[c0000000f34efc90] [c0000000001c5130] .do_vfs_ioctl+0x90/0x7c0
[c0000000f34efd80] [c0000000001c5914] .SyS_ioctl+0xb4/0xd0
[c0000000f34efe30] [c00000000000852c] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
...


Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/mm/vmalloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/vmalloc.c~vmalloc-warn mm/vmalloc.c
--- linux-2.6.git/mm/vmalloc.c~vmalloc-warn	2011-04-07 10:21:27.792401938 -0700
+++ linux-2.6.git-dave/mm/vmalloc.c	2011-04-07 10:21:27.800401934 -0700
@@ -1579,6 +1579,18 @@ static void *__vmalloc_area_node(struct 
 	return area->addr;
 
 fail:
+	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
+		/*
+		 * We probably did a show_mem() and a stack dump above
+		 * inside of alloc_page*().  This is only so we can
+		 * tell how big the vmalloc() really was.  This will
+		 * also not be exactly the same as what was passed
+		 * to vmalloc() due to alignment and the guard page.
+		 */
+		printk(KERN_WARNING "%s: vmalloc: allocation failure, "
+			"allocated %ld of %ld bytes\n", current->comm,
+			(area->nr_pages*PAGE_SIZE), area->size);
+	}
 	vfree(area->addr);
 	return NULL;
 }
_
