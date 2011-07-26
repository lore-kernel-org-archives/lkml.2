Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1GZSRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:17:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1GZSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:17:31 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=UFEwzb39EKQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=QqmXBP8GPko3f0F5R2YA:9 a=Ho6RsOiVcw95PemDdCwA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH v2] cgroup/kmemcheck: Annotate alloc_page() for cgroup
 allocations
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <1311702244.3526.100.camel@gandalf.stny.rr.com>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
	 <20110726173816.GA26597@tiehlicka.suse.cz>
	 <1311702110.3526.98.camel@gandalf.stny.rr.com>
	 <1311702244.3526.100.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Jul 2011 14:17:29 -0400
Message-ID: <1311704249.3526.106.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the cgroup base was allocated with kmalloc, it was necessary to
annotate the variable with kmemcheck_not_leak(). But because it has
recently been changed to be allocated with alloc_page() (which skips
kmemleak checks) causes a warning on boot up.

I was triggering this output:

allocated 8388608 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory
cgroups
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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 53bffc6..79c0e00 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -135,8 +135,10 @@ static void *__meminit alloc_page_cgroup(size_t size, int nid)
 	void *addr = NULL;
 
 	addr = alloc_pages_exact_nid(nid, size, GFP_KERNEL | __GFP_NOWARN);
-	if (addr)
+	if (addr) {
+		kmemleak_alloc(addr, size, 1, GFP_KERNEL | __GFP_NOWARN);
 		return addr;
+	}
 
 	if (node_state(nid, N_HIGH_MEMORY))
 		addr = vmalloc_node(size, nid);


