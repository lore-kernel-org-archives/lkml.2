Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1I3Bsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:48:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41049 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1I3Bsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:48:35 -0400
Date: Thu, 29 Sep 2011 20:48:24 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Nelson Elhage <nelhage@nelhage.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/2] cgroup/kmemleak: Annotate alloc_page() for cgroup
 allocations
Message-ID: <20110930014824.GA2455@elie.chipublib.org>
References: <20110930014334.GA2368@elie.chipublib.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930014334.GA2368@elie.chipublib.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 26 Jul 2011 15:19:16 -0400

When the cgroup base was allocated with kmalloc, it was necessary to
annotate the variable with kmemleak_not_leak(). But because it has
recently been changed to be allocated with alloc_page() (which skips
kmemleak checks) causes a warning on boot up.

I was triggering this output:

 allocated 8388608 bytes of page_cgroup
 please try 'cgroup_disable=memory' option if you don't want memory cgroups
 kmemleak: Trying to color unknown object at 0xf5840000 as Grey
 Pid: 0, comm: swapper Not tainted 3.0.0-test #12
 Call Trace:
  [<c17e34e6>] ? printk+0x1d/0x1f^M
  [<c10e2941>] paint_ptr+0x4f/0x78
  [<c178ab57>] kmemleak_not_leak+0x58/0x7d
  [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
  [<c1cdb462>] kmemleak_init+0x19d/0x1e9
  [<c1cbf771>] start_kernel+0x346/0x3ec
  [<c1cbf1b4>] ? loglevel+0x18/0x18
  [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0

After a bit of debugging I tracked the object 0xf840000 (and others)
down to the cgroup code. The change from allocating base with kmalloc to
alloc_page() has the base not calling kmemleak_alloc() which adds the
pointer to the object_tree_root, but kmemleak_not_leak() adds it to the
crt_early_log[] table. On kmemleak_init(), the entry is found in the
early_log[] but not the object_tree_root, and this error message is
displayed.

If alloc_page() fails then it defaults back to vmalloc() which still
uses the kmemleak_alloc() which makes us still need the
kmemleak_not_leak() call. The solution is to call the kmemleak_alloc()
directly if the alloc_page() succeeds.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
This patch is taken from [1].  The only change I made is to correct
"kmemcheck" above to "kmemleak" as suggested by Catalin.  Seems to
work ok. :)

[1] http://thread.gmane.org/gmane.linux.kernel/1171696/focus=1178619

 mm/page_cgroup.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 39d216d535ea..95e564cfe788 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -133,10 +133,13 @@ struct page *lookup_cgroup_page(struct page_cgroup *pc)
 static void *__meminit alloc_page_cgroup(size_t size, int nid)
 {
 	void *addr = NULL;
+	gfp_t flags = GFP_KERNEL | __GFP_NOWARN;
 
-	addr = alloc_pages_exact_nid(nid, size, GFP_KERNEL | __GFP_NOWARN);
-	if (addr)
+	addr = alloc_pages_exact_nid(nid, size, flags);
+	if (addr) {
+		kmemleak_alloc(addr, size, 1, flags);
 		return addr;
+	}
 
 	if (node_state(nid, N_HIGH_MEMORY))
 		addr = vmalloc_node(size, nid);
-- 
1.7.7.rc1

