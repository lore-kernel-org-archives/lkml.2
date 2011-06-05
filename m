Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1FEJgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:36:14 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:46151 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1FEJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:36:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@googlemail.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/atari: Use the resource subsystem to allocate from the ST-RAM pool
Date: Sun,  5 Jun 2011 11:36:03 +0200
Message-Id: <1307266563-25245-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Replace the custom allocator in the ST-RAM pool by the existing allocator
    in the resource subsystem,
  - Remove mem_init_done and its hook, as memory init is now done before
    device init,
  - Remove /proc/stram, as ST-RAM usage now shows up under /proc/iomem, e.g.

	005f2000-006f1fff : ST-RAM Pool
	  005f2000-0063dfff : atafb
	  0063e000-00641fff : ataflop
	  00642000-00642fff : SCSI

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig.mmu               |    6 -
 arch/m68k/atari/stram.c             |  437 +++++------------------------------
 arch/m68k/include/asm/atari_stram.h |    3 +-
 arch/m68k/mm/init_mm.c              |    5 -
 4 files changed, 63 insertions(+), 388 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 04b7acc..20e27d1 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -396,12 +396,6 @@ config AMIGA_PCMCIA
 	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
 	  600. If you intend to use pcmcia cards say Y; otherwise say N.
 
-config STRAM_PROC
-	bool "ST-RAM statistics in /proc"
-	depends on ATARI
-	help
-	  Say Y here to report ST-RAM usage statistics in /proc/stram.
-
 config HEARTBEAT
 	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
 	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index 5ed292f..cffbd14 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -1,5 +1,5 @@
 /*
- * arch/m68k/atari/stram.c: Functions for ST-RAM allocations
+ * Functions for ST-RAM allocations
  *
  * Copyright 1994-97 Roman Hodek <Roman.Hodek@informatik.uni-erlangen.de>
  *
@@ -30,114 +30,23 @@
 #include <asm/atari_stram.h>
 #include <asm/io.h>
 
-#undef DEBUG
-
-#ifdef DEBUG
-#define	DPRINTK(fmt,args...) printk( fmt, ##args )
-#else
-#define DPRINTK(fmt,args...)
-#endif
-
-#if defined(CONFIG_PROC_FS) && defined(CONFIG_STRAM_PROC)
-/* abbrev for the && above... */
-#define DO_PROC
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#endif
 
 /*
- * ++roman:
- *
- * New version of ST-Ram buffer allocation. Instead of using the
- * 1 MB - 4 KB that remain when the ST-Ram chunk starts at $1000
- * (1 MB granularity!), such buffers are reserved like this:
- *
- *  - If the kernel resides in ST-Ram anyway, we can take the buffer
- *    from behind the current kernel data space the normal way
- *    (incrementing start_mem).
- *
- *  - If the kernel is in TT-Ram, stram_init() initializes start and
- *    end of the available region. Buffers are allocated from there
- *    and mem_init() later marks the such used pages as reserved.
- *    Since each TT-Ram chunk is at least 4 MB in size, I hope there
- *    won't be an overrun of the ST-Ram region by normal kernel data
- *    space.
- *
- * For that, ST-Ram may only be allocated while kernel initialization
- * is going on, or exactly: before mem_init() is called. There is also
- * no provision now for freeing ST-Ram buffers. It seems that isn't
- * really needed.
- *
- * MSch 22/10/10: Because mem_init is now called before device init,
- * devices that rely on ST-RAM may find all ST-RAM already allocated to
- * other users by the time device init happens. In particular, a large
- * initrd RAM disk may use up enough of ST-RAM to cause stram_alloc to
- * resort to get_dma_pages allocation.
- * In the current state of Atari memory management, all of RAM is marked
- * DMA capable, so get_dma_pages may well return RAM that is not in actual
- * fact DMA capable. Using this for frame buffer or SCSI DMA buffer causes
- * subtle failure.
- *
- * The ST-RAM allocator has been changed to allocate memory from a pool of
- * reserved ST-RAM of configurable size, set aside on ST-RAM init (i.e.
- * before mem_init). As long as this pool is not exhausted, allocation of
- * real ST-RAM can be guaranteed.
- * Currently, pool ST-RAM freed is not returned to the pool free list so
- * it will be lost. Code to move such freed ST-RAM from alloc_list to
- * stram_free_list may be added if needed.
+ * The ST-RAM allocator allocate memory from a pool of reserved ST-RAM of
+ * configurable size, set aside on ST-RAM init.
+ * As long as this pool is not exhausted, allocation of real ST-RAM can be
+ * guaranteed.
  */
 
-/* Start and end (virtual) of ST-RAM */
-static void *stram_start, *stram_end;
-
-/* set after memory_init() executed and allocations via start_mem aren't
- * possible anymore */
-static int mem_init_done;
-
 /* set if kernel is in ST-RAM */
 static int kernel_in_stram;
 
-typedef struct stram_block {
-	struct stram_block *next;
-	void *start;
-	unsigned long size;
-	unsigned flags;
-	const char *owner;
-} BLOCK;
-
-/* values for flags field */
-#define BLOCK_FREE	0x01	/* free structure in the BLOCKs pool */
-#define BLOCK_KMALLOCED	0x02	/* structure allocated by kmalloc() */
-#define BLOCK_POOL	0x04	/* block allocated from static pool */
-#define BLOCK_GFP	0x08	/* block allocated with __get_dma_pages() */
-
-/* list of allocated blocks */
-static BLOCK *alloc_list;
-
-static BLOCK *stram_free_list;
-static unsigned long stram_pool, stram_pool_start, stram_pool_end;
-
-/* We can't always use kmalloc() to allocate BLOCK structures, since
- * stram_alloc() can be called rather early. So we need some pool of
- * statically allocated structures. 20 of them is more than enough, so in most
- * cases we never should need to call kmalloc(). */
-#define N_STATIC_BLOCKS	20
-static BLOCK static_blocks[N_STATIC_BLOCKS];
-
-/***************************** Prototypes *****************************/
-
-static BLOCK *add_region( void *addr, unsigned long size );
-static BLOCK *find_region( void *addr );
-static int remove_region( BLOCK *block );
-
-/************************* End of Prototypes **************************/
+static struct resource stram_pool = {
+	.name = "ST-RAM Pool"
+};
 
-
-/* ------------------------------------------------------------------------ */
-/*							   Public Interface								*/
-/* ------------------------------------------------------------------------ */
+static unsigned long pool_size = 1024*1024;
 
-static int pool_size = 1024*1024;
 
 static int __init atari_stram_setup(char *arg)
 {
@@ -150,6 +59,7 @@ static int __init atari_stram_setup(char *arg)
 
 early_param("stram_pool", atari_stram_setup);
 
+
 /*
  * This init function is called very early by atari/config.c
  * It initializes some internal variables needed for stram_alloc()
@@ -157,25 +67,23 @@ early_param("stram_pool", atari_stram_setup);
 void __init atari_stram_init(void)
 {
 	int i;
+	void *stram_start;
 
-	/* initialize static blocks */
-	for( i = 0; i < N_STATIC_BLOCKS; ++i )
-		static_blocks[i].flags = BLOCK_FREE;
-
-	/* determine whether kernel code resides in ST-RAM (then ST-RAM is the
-	 * first memory block at virtual 0x0) */
+	/*
+	 * determine whether kernel code resides in ST-RAM
+	 * (then ST-RAM is the first memory block at virtual 0x0)
+	 */
 	stram_start = phys_to_virt(0);
 	kernel_in_stram = (stram_start == 0);
 
-	for( i = 0; i < m68k_num_memory; ++i ) {
+	for (i = 0; i < m68k_num_memory; ++i) {
 		if (m68k_memory[i].addr == 0) {
-			/* skip first 2kB or page (supervisor-only!) */
-			stram_end = stram_start + m68k_memory[i].size;
 			return;
 		}
 	}
+
 	/* Should never come here! (There is always ST-Ram!) */
-	panic( "atari_stram_init: no ST-RAM found!" );
+	panic("atari_stram_init: no ST-RAM found!");
 }
 
 
@@ -185,289 +93,68 @@ void __init atari_stram_init(void)
  */
 void __init atari_stram_reserve_pages(void *start_mem)
 {
-	/* always reserve first page of ST-RAM, the first 2 kB are
-	 * supervisor-only! */
+	/*
+	 * always reserve first page of ST-RAM, the first 2 kB are
+	 * supervisor-only!
+	 */
 	if (!kernel_in_stram)
 		reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
 
-	stram_pool       = (unsigned long) alloc_bootmem_low(pool_size);
-	stram_pool_start = stram_pool;
-	stram_pool_end   = stram_pool + pool_size - 1;
-	DPRINTK("atari_stram pool: size=%d bytes, start=%08lx, end=%08lx\n",
-		pool_size, stram_pool, stram_pool_end);
-}
+	stram_pool.start = (resource_size_t)alloc_bootmem_low_pages(pool_size);
+	stram_pool.end = stram_pool.start + pool_size - 1;
+	request_resource(&iomem_resource, &stram_pool);
 
-void atari_stram_mem_init_hook (void)
-{
-	mem_init_done = 1;
+	pr_debug("atari_stram pool: size = %lu bytes, resource = %pR\n",
+		 pool_size, &stram_pool);
 }
 
-/* find a region (by size) in the free list */
-static void *find_free_stram(long size)
-{
-	BLOCK *p, *q, *r;
-	unsigned long item;
 
-	q = NULL;
-	r = stram_free_list;
-	for (p = stram_free_list; p; p = p->next) {
-		if (p->size >= size) {
-			q = p;
-			break;
-		}
-		r = p;
-	}
-
-	/* remove from free list */
-	if (q) {
-		item = (unsigned long) q->start;
-		r->next = q->next;
-		return (void *) item;
-	}
-	/* nothing found on free list? take from pool */
-	if ((stram_pool_end - stram_pool) > size) {
-		item = stram_pool;
-		stram_pool += size;
-		return (void *) item;
-	}
-
-	return NULL;
-}
-
-
-/*
- * This is main public interface: somehow allocate a ST-RAM block
- *
- *  - If we're before mem_init(), we have to make a static allocation. The
- *    region is taken in the kernel data area (if the kernel is in ST-RAM) or
- *    from the start of ST-RAM (if the kernel is in TT-RAM) and added to the
- *    rsvd_stram_* region. The ST-RAM is somewhere in the middle of kernel
- *    address space in the latter case.
- *
- *  - If mem_init() already has been called, try with __get_dma_pages().
- *    This has the disadvantage that it's very hard to get more than 1 page,
- *    and it is likely to fail :-(
- *
- */
-void *atari_stram_alloc(long size, const char *owner)
+void *atari_stram_alloc(unsigned long size, const char *owner)
 {
-	void *addr = NULL;
-	BLOCK *block;
-	int flags;
-
-	DPRINTK("atari_stram_alloc(size=%08lx,owner=%s) ... ", size, owner);
-
-	if (!mem_init_done)
-		/*
-		 * This will trigger a section mismatch warning which is
-		 * actually harmless:
-		 * once mem_init has run (before free_initdata), we will not
-		 * call this code path anymore
-		 */
-		return alloc_bootmem_low(size);
-	else {
-		/*
-		 * After mem_init(): can only resort to allocating from
-		 * reserved pool ...
-		 */
-		addr = find_free_stram(size);
-		if (addr) {
-			flags = BLOCK_POOL;
-			DPRINTK("after mem_init, allocating from pool, "
-				"find_free_stram=%p\n", addr);
-		} else {
-			/* or resort to __get_dma_pages() !! */
-			addr = (void *)__get_dma_pages(GFP_KERNEL,
-						       get_order(size));
-			flags = BLOCK_GFP;
-			DPRINTK("after mem_init, allocating dma pages, "
-				"get_dma_pages=%p\n", addr);
-		}
+	struct resource *res;
+	int error;
+
+	pr_debug("atari_stram_alloc: allocate %lu bytes\n", size);
+
+	/* round up */
+	size = PAGE_ALIGN(size);
+
+	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	res->name = owner;
+	error = allocate_resource(&stram_pool, res, size, 0, UINT_MAX,
+				  PAGE_SIZE, NULL, NULL);
+	if (error < 0) {
+		pr_err("atari_stram_alloc: allocate_resource() failed %d!\n",
+		       error);
+		kfree(res);
+		return NULL;
 	}
 
-	if (addr) {
-		if (!(block = add_region( addr, size ))) {
-			/* out of memory for BLOCK structure :-( */
-			DPRINTK( "atari_stram_alloc: out of mem for BLOCK -- "
-					 "freeing again\n" );
-			free_pages((unsigned long)addr, get_order(size));
-			return( NULL );
-		}
-		block->owner = owner;
-		block->flags |= flags;
-	}
-	return( addr );
+	pr_debug("atari_stram_alloc: returning %pR\n", res);
+	return (void *)res->start;
 }
 EXPORT_SYMBOL(atari_stram_alloc);
 
-void atari_stram_free( void *addr )
 
+void atari_stram_free(void *addr)
 {
-	BLOCK *block;
-
-	DPRINTK( "atari_stram_free(addr=%p)\n", addr );
+	unsigned long start = (unsigned long)addr;
+	struct resource *res;
+	unsigned long size;
 
-	if (!(block = find_region( addr ))) {
-		printk( KERN_ERR "Attempt to free non-allocated ST-RAM block at %p "
-				"from %p\n", addr, __builtin_return_address(0) );
+	res = lookup_resource(&stram_pool, start);
+	if (!res) {
+		pr_err("atari_stram_free: trying to free nonexistent region "
+		       "at %p\n", addr);
 		return;
 	}
-	DPRINTK( "atari_stram_free: found block (%p): size=%08lx, owner=%s, "
-			 "flags=%02x\n", block, block->size, block->owner, block->flags );
-
-	if (!(block->flags & BLOCK_GFP || block->flags & BLOCK_POOL))
-		goto fail;
-
-	DPRINTK("atari_stram_free: is kmalloced, order_size=%d\n",
-		get_order(block->size));
 
-	/*
-	 * pages allocated from stram pool cannot be freed - only pages
-	 * allocated by get_free_pages can
-	 */
-	if ((block->flags & BLOCK_GFP))
-		free_pages((unsigned long)addr, get_order(block->size));
-	remove_region( block );
-	return;
-
-  fail:
-	printk( KERN_ERR "atari_stram_free: cannot free block at %p "
-			"(called from %p)\n", addr, __builtin_return_address(0) );
+	size = resource_size(res);
+	pr_debug("atari_stram_free: free %lu bytes at %p\n", size, addr);
+	release_resource(res);
+	kfree(res);
 }
 EXPORT_SYMBOL(atari_stram_free);
-
-
-/* ------------------------------------------------------------------------ */
-/*							  Region Management								*/
-/* ------------------------------------------------------------------------ */
-
-
-/* insert a region into the alloced list (sorted) */
-static BLOCK *add_region( void *addr, unsigned long size )
-{
-	BLOCK **p, *n = NULL;
-	int i;
-
-	for( i = 0; i < N_STATIC_BLOCKS; ++i ) {
-		if (static_blocks[i].flags & BLOCK_FREE) {
-			n = &static_blocks[i];
-			n->flags = 0;
-			break;
-		}
-	}
-	if (!n && mem_init_done) {
-		/* if statics block pool exhausted and we can call kmalloc() already
-		 * (after mem_init()), try that */
-		n = kmalloc( sizeof(BLOCK), GFP_KERNEL );
-		if (n)
-			n->flags = BLOCK_KMALLOCED;
-	}
-	if (!n) {
-		printk( KERN_ERR "Out of memory for ST-RAM descriptor blocks\n" );
-		return( NULL );
-	}
-	n->start = addr;
-	n->size  = size;
-
-	for( p = &alloc_list; *p; p = &((*p)->next) )
-		if ((*p)->start > addr) break;
-	n->next = *p;
-	*p = n;
-
-	return( n );
-}
-
-
-/* find a region (by start addr) in the alloced list */
-static BLOCK *find_region( void *addr )
-{
-	BLOCK *p;
-
-	for( p = alloc_list; p; p = p->next ) {
-		if (p->start == addr)
-			return( p );
-		if (p->start > addr)
-			break;
-	}
-	return( NULL );
-}
-
-
-/* remove a block from the alloced list */
-static int remove_region( BLOCK *block )
-{
-	BLOCK **p;
-
-	for( p = &alloc_list; *p; p = &((*p)->next) )
-		if (*p == block) break;
-	if (!*p)
-		return( 0 );
-
-	*p = block->next;
-	if (block->flags & BLOCK_KMALLOCED)
-		kfree( block );
-	else
-		block->flags |= BLOCK_FREE;
-	return( 1 );
-}
-
-
-
-/* ------------------------------------------------------------------------ */
-/*						 /proc statistics file stuff						*/
-/* ------------------------------------------------------------------------ */
-
-#ifdef DO_PROC
-
-#define	PRINT_PROC(fmt,args...) seq_printf( m, fmt, ##args )
-
-static int stram_proc_show(struct seq_file *m, void *v)
-{
-	BLOCK *p;
-
-	PRINT_PROC("Total ST-RAM:      %8u kB\n",
-			   (stram_end - stram_start) >> 10);
-	PRINT_PROC( "Allocated regions:\n" );
-	for( p = alloc_list; p; p = p->next ) {
-		PRINT_PROC("0x%08lx-0x%08lx: %s (",
-			   virt_to_phys(p->start),
-			   virt_to_phys(p->start+p->size-1),
-			   p->owner);
-		if (p->flags & BLOCK_GFP)
-			PRINT_PROC("page-alloced)\n");
-		else if (p->flags & BLOCK_POOL)
-			PRINT_PROC("pool-alloced)\n");
-		else
-			PRINT_PROC("??)\n");
-	}
-
-	return 0;
-}
-
-static int stram_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, stram_proc_show, NULL);
-}
-
-static const struct file_operations stram_proc_fops = {
-	.open		= stram_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init proc_stram_init(void)
-{
-	proc_create("stram", 0, NULL, &stram_proc_fops);
-	return 0;
-}
-module_init(proc_stram_init);
-#endif
-
-
-/*
- * Local variables:
- *  c-indent-level: 4
- *  tab-width: 4
- * End:
- */
diff --git a/arch/m68k/include/asm/atari_stram.h b/arch/m68k/include/asm/atari_stram.h
index 7546d13..62e2759 100644
--- a/arch/m68k/include/asm/atari_stram.h
+++ b/arch/m68k/include/asm/atari_stram.h
@@ -6,12 +6,11 @@
  */
 
 /* public interface */
-void *atari_stram_alloc(long size, const char *owner);
+void *atari_stram_alloc(unsigned long size, const char *owner);
 void atari_stram_free(void *);
 
 /* functions called internally by other parts of the kernel */
 void atari_stram_init(void);
 void atari_stram_reserve_pages(void *start_mem);
-void atari_stram_mem_init_hook (void);
 
 #endif /*_M68K_ATARI_STRAM_H */
diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
index 9113c2f..bbe5254 100644
--- a/arch/m68k/mm/init_mm.c
+++ b/arch/m68k/mm/init_mm.c
@@ -83,11 +83,6 @@ void __init mem_init(void)
 	int initpages = 0;
 	int i;
 
-#ifdef CONFIG_ATARI
-	if (MACH_IS_ATARI)
-		atari_stram_mem_init_hook();
-#endif
-
 	/* this will put all memory onto the freelists */
 	totalram_pages = num_physpages = 0;
 	for_each_online_pgdat(pgdat) {
-- 
1.7.0.4

