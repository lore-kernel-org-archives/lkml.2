Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2EVCuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:50:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52780 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753Ab2EVCuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:50:02 -0400
Message-ID: <1337654999.24226.9.camel@joe2Laptop>
Subject: [PATCH 1/2] x86: asm: Add KERN_<LEVEL> to printks
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Date: Mon, 21 May 2012 19:49:59 -0700
In-Reply-To: <4FBA821F.60806@zytor.com>
References: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>
	 <tip-29d679ffd850ea37a303bb930142be14982611e4@git.kernel.org>
	 <1337621394.13812.2.camel@joe2Laptop> <4FBA7E95.5040101@zytor.com>
	 <1337622999.13812.11.camel@joe2Laptop> <4FBA821F.60806@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert some printks to pr_<level>.
Add KERN_<LEVEL> where appropriate.
Neaten DBG macro and use printf verification when
not #defined.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Mon, 2012-05-21 at 10:57 -0700, H. Peter Anvin wrote:
> Feel free to submit a patchset...
 
 arch/x86/include/asm/floppy.h         |    2 +-
 arch/x86/include/asm/pci_x86.h        |    8 ++++++--
 arch/x86/include/asm/pgtable-2level.h |    4 ++--
 arch/x86/include/asm/pgtable-3level.h |    6 +++---
 arch/x86/include/asm/pgtable_64.h     |    8 ++++----
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/floppy.h b/arch/x86/include/asm/floppy.h
index dbe82a5..d3d7469 100644
--- a/arch/x86/include/asm/floppy.h
+++ b/arch/x86/include/asm/floppy.h
@@ -99,7 +99,7 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 		virtual_dma_residue += virtual_dma_count;
 		virtual_dma_count = 0;
 #ifdef TRACE_FLPY_INT
-		printk("count=%x, residue=%x calls=%d bytes=%d dma_wait=%d\n",
+		printk(KERN_DEBUG "count=%x, residue=%x calls=%d bytes=%d dma_wait=%d\n",
 		       virtual_dma_count, virtual_dma_residue, calls, bytes,
 		       dma_wait);
 		calls = 0;
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b3a5317..5ad24a8 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -7,9 +7,13 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(x...) printk(x)
+#define DBG(fmt, ...) printk(fmt, ##__VA_ARGS__)
 #else
-#define DBG(x...)
+#define DBG(fmt, ...)				\
+do {						\
+	if (0)					\
+		printk(fmt, ##__VA_ARGS__);	\
+} while (0)
 #endif
 
 #define PCI_PROBE_BIOS		0x0001
diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index 98391db..f2b489c 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -2,9 +2,9 @@
 #define _ASM_X86_PGTABLE_2LEVEL_H
 
 #define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, (e).pte_low)
+	pr_err("%s:%d: bad pte %08lx\n", __FILE__, __LINE__, (e).pte_low)
 #define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
+	pr_err("%s:%d: bad pgd %08lx\n", __FILE__, __LINE__, pgd_val(e))
 
 /*
  * Certain architectures need to do special things when PTEs
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index effff47..bbfc29c 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -9,13 +9,13 @@
  */
 
 #define pte_ERROR(e)							\
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n",			\
+	pr_err("%s:%d: bad pte %p(%08lx%08lx)\n",			\
 	       __FILE__, __LINE__, &(e), (e).pte_high, (e).pte_low)
 #define pmd_ERROR(e)							\
-	printk("%s:%d: bad pmd %p(%016Lx).\n",				\
+	pr_err("%s:%d: bad pmd %p(%016Lx)\n",				\
 	       __FILE__, __LINE__, &(e), pmd_val(e))
 #define pgd_ERROR(e)							\
-	printk("%s:%d: bad pgd %p(%016Lx).\n",				\
+	pr_err("%s:%d: bad pgd %p(%016Lx)\n",				\
 	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 /* Rules for using set_pte: the pte being assigned *must* be
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 975f709..8251be0 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -26,16 +26,16 @@ extern pgd_t init_level4_pgt[];
 extern void paging_init(void);
 
 #define pte_ERROR(e)					\
-	printk("%s:%d: bad pte %p(%016lx).\n",		\
+	pr_err("%s:%d: bad pte %p(%016lx)\n",		\
 	       __FILE__, __LINE__, &(e), pte_val(e))
 #define pmd_ERROR(e)					\
-	printk("%s:%d: bad pmd %p(%016lx).\n",		\
+	pr_err("%s:%d: bad pmd %p(%016lx)\n",		\
 	       __FILE__, __LINE__, &(e), pmd_val(e))
 #define pud_ERROR(e)					\
-	printk("%s:%d: bad pud %p(%016lx).\n",		\
+	pr_err("%s:%d: bad pud %p(%016lx)\n",		\
 	       __FILE__, __LINE__, &(e), pud_val(e))
 #define pgd_ERROR(e)					\
-	printk("%s:%d: bad pgd %p(%016lx).\n",		\
+	pr_err("%s:%d: bad pgd %p(%016lx)\n",		\
 	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 struct mm_struct;
-- 
1.7.8.111.gad25c.dirty


