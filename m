Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab1CXWSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:18:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab1CXWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LIFBbPHZoPKGdMaSsl7LIbWfxV1cm3NRCUu7ILgokmQiWTeWaD+G1UtGJnU4ftUbuU
         tNarnsYy9CkZfw3aKHhg==
Date: Thu, 24 Mar 2011 15:18:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Luck, Tony" <tony.luck@intel.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [patch] lib, arch: add filter argument to show_mem and fix private
 implementations
In-Reply-To: <20110323211346.9ae51356.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1103241457030.20718@chino.kir.corp.google.com>
References: <20110324143019.cce06baa.sfr@canb.auug.org.au> <20110323211346.9ae51356.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Andrew Morton wrote:

> So...  a suitable fix would be to remove __show_mem and to add the
> extra arg to show_mem() itself then fix up all callers and to fix up
> all implementations to honour "filter".
> 

I've done that below, I hope it's not too late to prevent the revert.  
Compile tested on arm, ia64, powerpc, and sparc32 defconfig.


lib, arch: add filter argument to show_mem and fix private implementations

ddd588b5dd55 (oom: suppress nodes that are not allowed from meminfo on oom 
kill) moved lib/show_mem.o out of lib/lib.a, which resulted in build 
warnings on all architectures that implement their own versions of 
show_mem():

	lib/lib.a(show_mem.o): In function `show_mem':
	show_mem.c:(.text+0x1f4): multiple definition of `show_mem'
	arch/sparc/mm/built-in.o:(.text+0xd70): first defined here

The fix is to remove __show_mem() and add its argument to show_mem() in 
all implementations to prevent this breakage.

Architectures that implement their own show_mem() actually don't do 
anything with the argument yet, but they could be made to filter nodes 
that aren't allowed in the current context in the future just like the 
generic implementation.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: James Bottomley <James.Bottomley@hansenpartnership.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/arm/mm/init.c        |    2 +-
 arch/ia64/mm/contig.c     |    2 +-
 arch/ia64/mm/discontig.c  |    2 +-
 arch/parisc/mm/init.c     |    2 +-
 arch/powerpc/xmon/xmon.c  |    2 +-
 arch/sparc/mm/init_32.c   |    2 +-
 arch/tile/mm/pgtable.c    |    2 +-
 arch/unicore32/mm/init.c  |    2 +-
 drivers/tty/sysrq.c       |    2 +-
 drivers/tty/vt/keyboard.c |    2 +-
 include/linux/mm.h        |    5 ++---
 lib/show_mem.c            |    7 +------
 mm/oom_kill.c             |    2 +-
 mm/page_alloc.c           |    2 +-
 14 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -78,7 +78,7 @@ __tagtable(ATAG_INITRD2, parse_tag_initrd2);
  */
 struct meminfo meminfo;
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int free = 0, total = 0, reserved = 0;
 	int shared = 0, cached = 0, slab = 0, i;
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -36,7 +36,7 @@ static unsigned long max_gap;
  * Shows a simple page count of reserved and used pages in the system.
  * For discontig machines, it does this on a per-pgdat basis.
  */
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int i, total_reserved = 0;
 	int total_shared = 0, total_cached = 0;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -614,7 +614,7 @@ void __cpuinit *per_cpu_init(void)
  * Shows a simple page count of reserved and used pages in the system.
  * For discontig machines, it does this on a per-pgdat basis.
  */
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int i, total_reserved = 0;
 	int total_shared = 0, total_cached = 0;
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -544,7 +544,7 @@ void __init mem_init(void)
 unsigned long *empty_zero_page __read_mostly;
 EXPORT_SYMBOL(empty_zero_page);
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int i,free = 0,total = 0,reserved = 0;
 	int shared = 0, cached = 0;
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -821,7 +821,7 @@ cmds(struct pt_regs *excp)
 				memzcan();
 				break;
 			case 'i':
-				show_mem();
+				show_mem(0);
 				break;
 			default:
 				termch = cmd;
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -75,7 +75,7 @@ void __init kmap_init(void)
 	kmap_prot = __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	printk("Mem-info:\n");
 	show_free_areas();
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -41,7 +41,7 @@
  * The normal show_free_areas() is too verbose on Tile, with dozens
  * of processors and often four NUMA zones each with high and lowmem.
  */
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	struct zone *zone;
 
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -55,7 +55,7 @@ early_param("initrd", early_initrd);
  */
 struct meminfo meminfo;
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int free = 0, total = 0, reserved = 0;
 	int shared = 0, cached = 0, slab = 0, i;
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -306,7 +306,7 @@ static struct sysrq_key_op sysrq_ftrace_dump_op = {
 
 static void sysrq_handle_showmem(int key)
 {
-	show_mem();
+	show_mem(0);
 }
 static struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -600,7 +600,7 @@ static void fn_scroll_back(struct vc_data *vc)
 
 static void fn_show_mem(struct vc_data *vc)
 {
-	show_mem();
+	show_mem(0);
 }
 
 static void fn_show_state(struct vc_data *vc)
diff --git a/include/linux/mm.h b/include/linux/mm.h
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -861,7 +861,7 @@ extern void pagefault_out_of_memory(void);
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 
 /*
- * Flags passed to __show_mem() and __show_free_areas() to suppress output in
+ * Flags passed to show_mem() and __show_free_areas() to suppress output in
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
@@ -1360,8 +1360,7 @@ extern void setup_per_zone_wmarks(void);
 extern void calculate_zone_inactive_ratio(struct zone *zone);
 extern void mem_init(void);
 extern void __init mmap_init(void);
-extern void show_mem(void);
-extern void __show_mem(unsigned int flags);
+extern void show_mem(unsigned int flags);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
diff --git a/lib/show_mem.c b/lib/show_mem.c
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -9,7 +9,7 @@
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
 
-void __show_mem(unsigned int filter)
+void show_mem(unsigned int filter)
 {
 	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, shared = 0,
@@ -61,8 +61,3 @@ void __show_mem(unsigned int filter)
 		quicklist_total_size());
 #endif
 }
-
-void show_mem(void)
-{
-	__show_mem(0);
-}
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -406,7 +406,7 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 	task_unlock(current);
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
-	__show_mem(SHOW_MEM_FILTER_NODES);
+	show_mem(SHOW_MEM_FILTER_NODES);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(mem, nodemask);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2195,7 +2195,7 @@ nopage:
 			current->comm, order, gfp_mask);
 		dump_stack();
 		if (!should_suppress_show_mem())
-			__show_mem(filter);
+			show_mem(filter);
 	}
 	return page;
 got_pg:
