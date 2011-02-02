Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1BBIx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:53:58 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:38839 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1BBIx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:53:57 -0500
Date: Wed, 2 Feb 2011 09:53:57 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.38-rc3
Message-ID: <20110202095357.7837b3e9@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Akinobu Mita (1):
      [S390] use asm-generic/cacheflush.h

Heiko Carstens (1):
      [S390] tlb: fix build error caused by THP

Jan Glauber (1):
      [S390] qdio: prevent compile warning under CONFIG_32BIT

Martin Schwidefsky (2):
      [S390] pgtable_list corruption
      [S390] missing sacf in uaccess

Sebastian Ott (1):
      [S390] reset default for CONFIG_CHSC_SCH

Stefan Haberland (1):
      [S390] dasd: prevent panic with unresumed devices

 arch/s390/Kconfig                  |    2 +-
 arch/s390/include/asm/cacheflush.h |   23 +----------------------
 arch/s390/include/asm/tlb.h        |    1 +
 arch/s390/lib/uaccess_std.c        |   10 ++++------
 arch/s390/mm/pgtable.c             |    3 ++-
 drivers/s390/block/dasd_alias.c    |    6 ++++++
 drivers/s390/cio/qdio_main.c       |    4 ++--
 7 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ff19efd..636bcb8 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -406,7 +406,7 @@ config QDIO
 	  If unsure, say Y.
 
 config CHSC_SCH
-	def_tristate y
+	def_tristate m
 	prompt "Support for CHSC subchannels"
 	help
 	  This driver allows usage of CHSC subchannels. A CHSC subchannel
diff --git a/arch/s390/include/asm/cacheflush.h b/arch/s390/include/asm/cacheflush.h
index 405cc97..7e1f776 100644
--- a/arch/s390/include/asm/cacheflush.h
+++ b/arch/s390/include/asm/cacheflush.h
@@ -1,29 +1,8 @@
 #ifndef _S390_CACHEFLUSH_H
 #define _S390_CACHEFLUSH_H
 
-/* Keep includes the same across arches.  */
-#include <linux/mm.h>
-
 /* Caches aren't brain-dead on the s390. */
-#define flush_cache_all()			do { } while (0)
-#define flush_cache_mm(mm)			do { } while (0)
-#define flush_cache_dup_mm(mm)			do { } while (0)
-#define flush_cache_range(vma, start, end)	do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-#define flush_dcache_page(page)			do { } while (0)
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-#define flush_icache_range(start, end)		do { } while (0)
-#define flush_icache_page(vma,pg)		do { } while (0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
-#define flush_cache_vmap(start, end)		do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
-
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+#include <asm-generic/cacheflush.h>
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void kernel_map_pages(struct page *page, int numpages, int enable);
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index f1f644f..9074a54 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -22,6 +22,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <asm/processor.h>
 #include <asm/pgalloc.h>
diff --git a/arch/s390/lib/uaccess_std.c b/arch/s390/lib/uaccess_std.c
index 07deaee..a6c4f7e 100644
--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -125,9 +125,9 @@ static size_t copy_in_user_std(size_t size, void __user *to,
 	unsigned long tmp1;
 
 	asm volatile(
+		"   sacf  256\n"
 		"  "AHI"  %0,-1\n"
 		"   jo    5f\n"
-		"   sacf  256\n"
 		"   bras  %3,3f\n"
 		"0:"AHI"  %0,257\n"
 		"1: mvc   0(1,%1),0(%2)\n"
@@ -142,9 +142,8 @@ static size_t copy_in_user_std(size_t size, void __user *to,
 		"3:"AHI"  %0,-256\n"
 		"   jnm   2b\n"
 		"4: ex    %0,1b-0b(%3)\n"
-		"   sacf  0\n"
 		"5: "SLR"  %0,%0\n"
-		"6:\n"
+		"6: sacf  0\n"
 		EX_TABLE(1b,6b) EX_TABLE(2b,0b) EX_TABLE(4b,0b)
 		: "+a" (size), "+a" (to), "+a" (from), "=a" (tmp1)
 		: : "cc", "memory");
@@ -156,9 +155,9 @@ static size_t clear_user_std(size_t size, void __user *to)
 	unsigned long tmp1, tmp2;
 
 	asm volatile(
+		"   sacf  256\n"
 		"  "AHI"  %0,-1\n"
 		"   jo    5f\n"
-		"   sacf  256\n"
 		"   bras  %3,3f\n"
 		"   xc    0(1,%1),0(%1)\n"
 		"0:"AHI"  %0,257\n"
@@ -178,9 +177,8 @@ static size_t clear_user_std(size_t size, void __user *to)
 		"3:"AHI"  %0,-256\n"
 		"   jnm   2b\n"
 		"4: ex    %0,0(%3)\n"
-		"   sacf  0\n"
 		"5: "SLR"  %0,%0\n"
-		"6:\n"
+		"6: sacf  0\n"
 		EX_TABLE(1b,6b) EX_TABLE(2b,0b) EX_TABLE(4b,0b)
 		: "+a" (size), "+a" (to), "=a" (tmp1), "=a" (tmp2)
 		: : "cc", "memory");
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 0c719c6..e1850c2 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -336,7 +336,8 @@ void page_table_free(struct mm_struct *mm, unsigned long *table)
 	page->flags ^= bits;
 	if (page->flags & FRAG_MASK) {
 		/* Page now has some free pgtable fragments. */
-		list_move(&page->lru, &mm->context.pgtable_list);
+		if (!list_empty(&page->lru))
+			list_move(&page->lru, &mm->context.pgtable_list);
 		page = NULL;
 	} else
 		/* All fragments of the 4K page have been freed. */
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 4155805..2b771f1 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -319,6 +319,9 @@ void dasd_alias_disconnect_device_from_lcu(struct dasd_device *device)
 
 	private = (struct dasd_eckd_private *) device->private;
 	lcu = private->lcu;
+	/* nothing to do if already disconnected */
+	if (!lcu)
+		return;
 	device->discipline->get_uid(device, &uid);
 	spin_lock_irqsave(&lcu->lock, flags);
 	list_del_init(&device->alias_list);
@@ -680,6 +683,9 @@ int dasd_alias_remove_device(struct dasd_device *device)
 
 	private = (struct dasd_eckd_private *) device->private;
 	lcu = private->lcu;
+	/* nothing to do if already removed */
+	if (!lcu)
+		return 0;
 	spin_lock_irqsave(&lcu->lock, flags);
 	_remove_device_from_lcu(lcu, device);
 	spin_unlock_irqrestore(&lcu->lock, flags);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index e9fff2b..5640c89 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -476,7 +476,7 @@ static inline void inbound_primed(struct qdio_q *q, int count)
 static int get_inbound_buffer_frontier(struct qdio_q *q)
 {
 	int count, stop;
-	unsigned char state;
+	unsigned char state = 0;
 
 	/*
 	 * Don't check 128 buffers, as otherwise qdio_inbound_q_moved
@@ -643,7 +643,7 @@ void qdio_inbound_processing(unsigned long data)
 static int get_outbound_buffer_frontier(struct qdio_q *q)
 {
 	int count, stop;
-	unsigned char state;
+	unsigned char state = 0;
 
 	if (need_siga_sync(q))
 		if (((queue_type(q) != QDIO_IQDIO_QFMT) &&
