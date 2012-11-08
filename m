Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2KHKKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:10:17 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50160 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2KHKKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:10:15 -0500
Date: Thu, 8 Nov 2012 11:10:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.7-rc5
Message-ID: <20121108111006.4be14a7d@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12110810-2966-0000-0000-000005CF786F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive a couple of bug fixes. I keep the fingers crossed that we now
got transparent huge pages ready for prime time.

Cornelia Huck (1):
      s390: Move css limits from drivers/s390/cio/ to include/asm/.

Gerald Schaefer (2):
      s390/mm: use pmd_large() instead of pmd_huge()
      s390/thp: respect page protection in pmd_none() and pmd_present()

Heiko Carstens (1):
      s390/sclp: fix addressing mode clobber

Sebastian Ott (2):
      s390/cio: suppress 2nd path verification during resume
      s390/cio: fix length calculation in idset.c

 arch/s390/include/asm/cio.h     |    2 ++
 arch/s390/include/asm/pgtable.h |   35 ++++++++++++++++++++++-------------
 arch/s390/kernel/sclp.S         |    8 +++++++-
 arch/s390/lib/uaccess_pt.c      |    2 +-
 arch/s390/mm/gup.c              |    2 +-
 drivers/s390/cio/css.h          |    3 ---
 drivers/s390/cio/device.c       |    8 +-------
 drivers/s390/cio/idset.c        |    3 +--
 8 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index 55bde60..ad2b924 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -9,6 +9,8 @@
 
 #define LPM_ANYPATH 0xff
 #define __MAX_CSSID 0
+#define __MAX_SUBCHANNEL 65535
+#define __MAX_SSID 3
 
 #include <asm/scsw.h>
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index dd647c9..2d3b7cb 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -506,12 +506,15 @@ static inline int pud_bad(pud_t pud)
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN) != 0UL;
+	unsigned long mask = _SEGMENT_ENTRY_INV | _SEGMENT_ENTRY_RO;
+	return (pmd_val(pmd) & mask) == _HPAGE_TYPE_NONE ||
+	       !(pmd_val(pmd) & _SEGMENT_ENTRY_INV);
 }
 
 static inline int pmd_none(pmd_t pmd)
 {
-	return (pmd_val(pmd) & _SEGMENT_ENTRY_INV) != 0UL;
+	return (pmd_val(pmd) & _SEGMENT_ENTRY_INV) &&
+	       !(pmd_val(pmd) & _SEGMENT_ENTRY_RO);
 }
 
 static inline int pmd_large(pmd_t pmd)
@@ -1223,6 +1226,11 @@ static inline void __pmd_idte(unsigned long address, pmd_t *pmdp)
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+#define SEGMENT_NONE	__pgprot(_HPAGE_TYPE_NONE)
+#define SEGMENT_RO	__pgprot(_HPAGE_TYPE_RO)
+#define SEGMENT_RW	__pgprot(_HPAGE_TYPE_RW)
+
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
 
@@ -1242,16 +1250,15 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 
 static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
 {
-	unsigned long pgprot_pmd = 0;
-
-	if (pgprot_val(pgprot) & _PAGE_INVALID) {
-		if (pgprot_val(pgprot) & _PAGE_SWT)
-			pgprot_pmd |= _HPAGE_TYPE_NONE;
-		pgprot_pmd |= _SEGMENT_ENTRY_INV;
-	}
-	if (pgprot_val(pgprot) & _PAGE_RO)
-		pgprot_pmd |= _SEGMENT_ENTRY_RO;
-	return pgprot_pmd;
+	/*
+	 * pgprot is PAGE_NONE, PAGE_RO, or PAGE_RW (see __Pxxx / __Sxxx)
+	 * Convert to segment table entry format.
+	 */
+	if (pgprot_val(pgprot) == pgprot_val(PAGE_NONE))
+		return pgprot_val(SEGMENT_NONE);
+	if (pgprot_val(pgprot) == pgprot_val(PAGE_RO))
+		return pgprot_val(SEGMENT_RO);
+	return pgprot_val(SEGMENT_RW);
 }
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
@@ -1269,7 +1276,9 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
 
 static inline pmd_t pmd_mkwrite(pmd_t pmd)
 {
-	pmd_val(pmd) &= ~_SEGMENT_ENTRY_RO;
+	/* Do not clobber _HPAGE_TYPE_NONE pages! */
+	if (!(pmd_val(pmd) & _SEGMENT_ENTRY_INV))
+		pmd_val(pmd) &= ~_SEGMENT_ENTRY_RO;
 	return pmd;
 }
 
diff --git a/arch/s390/kernel/sclp.S b/arch/s390/kernel/sclp.S
index bf05389..b6506ee 100644
--- a/arch/s390/kernel/sclp.S
+++ b/arch/s390/kernel/sclp.S
@@ -44,6 +44,12 @@ _sclp_wait_int:
 #endif
 	mvc	.LoldpswS1-.LbaseS1(16,%r13),0(%r8)
 	mvc	0(16,%r8),0(%r9)
+#ifdef CONFIG_64BIT
+	epsw	%r6,%r7				# set current addressing mode
+	nill	%r6,0x1				# in new psw (31 or 64 bit mode)
+	nilh	%r7,0x8000
+	stm	%r6,%r7,0(%r8)
+#endif
 	lhi	%r6,0x0200			# cr mask for ext int (cr0.54)
 	ltr	%r2,%r2
 	jz	.LsetctS1
@@ -87,7 +93,7 @@ _sclp_wait_int:
 	.long	0x00080000, 0x80000000+.LwaitS1	# PSW to handle ext int
 #ifdef CONFIG_64BIT
 .LextpswS1_64:
-	.quad	0x0000000180000000, .LwaitS1	# PSW to handle ext int, 64 bit
+	.quad	0, .LwaitS1			# PSW to handle ext int, 64 bit
 #endif
 .LwaitpswS1:
 	.long	0x010a0000, 0x00000000+.LloopS1	# PSW to wait for ext int
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 2d37bb8..9017a63 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -39,7 +39,7 @@ static __always_inline unsigned long follow_table(struct mm_struct *mm,
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd))
 		return -0x10UL;
-	if (pmd_huge(*pmd)) {
+	if (pmd_large(*pmd)) {
 		if (write && (pmd_val(*pmd) & _SEGMENT_ENTRY_RO))
 			return -0x04UL;
 		return (pmd_val(*pmd) & HPAGE_MASK) + (addr & ~HPAGE_MASK);
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 60acb93..8b82853 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -126,7 +126,7 @@ static inline int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
 		 */
 		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
-		if (unlikely(pmd_huge(pmd))) {
+		if (unlikely(pmd_large(pmd))) {
 			if (!gup_huge_pmd(pmdp, pmd, addr, next,
 					  write, pages, nr))
 				return 0;
diff --git a/drivers/s390/cio/css.h b/drivers/s390/cio/css.h
index 33bb4d8..4af3dfe 100644
--- a/drivers/s390/cio/css.h
+++ b/drivers/s390/cio/css.h
@@ -112,9 +112,6 @@ extern int for_each_subchannel(int(*fn)(struct subchannel_id, void *), void *);
 extern void css_reiterate_subchannels(void);
 void css_update_ssd_info(struct subchannel *sch);
 
-#define __MAX_SUBCHANNEL 65535
-#define __MAX_SSID 3
-
 struct channel_subsystem {
 	u8 cssid;
 	int valid;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index fc916f5..fd3143c 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1424,7 +1424,7 @@ static enum io_sch_action sch_get_action(struct subchannel *sch)
 	}
 	if (device_is_disconnected(cdev))
 		return IO_SCH_REPROBE;
-	if (cdev->online)
+	if (cdev->online && !cdev->private->flags.resuming)
 		return IO_SCH_VERIFY;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
 		return IO_SCH_UNREG_ATTACH;
@@ -1469,12 +1469,6 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 		rc = 0;
 		goto out_unlock;
 	case IO_SCH_VERIFY:
-		if (cdev->private->flags.resuming == 1) {
-			if (cio_enable_subchannel(sch, (u32)(addr_t)sch)) {
-				ccw_device_set_notoper(cdev);
-				break;
-			}
-		}
 		/* Trigger path verification. */
 		io_subchannel_verify(sch);
 		rc = 0;
diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
index 199bc67..65d13e3 100644
--- a/drivers/s390/cio/idset.c
+++ b/drivers/s390/cio/idset.c
@@ -125,8 +125,7 @@ int idset_is_empty(struct idset *set)
 
 void idset_add_set(struct idset *to, struct idset *from)
 {
-	int len = min(__BITOPS_WORDS(to->num_ssid * to->num_id),
-		      __BITOPS_WORDS(from->num_ssid * from->num_id));
+	int len = min(to->num_ssid * to->num_id, from->num_ssid * from->num_id);
 
 	bitmap_or(to->bitmap, to->bitmap, from->bitmap, len);
 }

