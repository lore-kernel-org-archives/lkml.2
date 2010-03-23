Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0CWIvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:51:52 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:35694 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0CWIvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:51:50 -0400
Date: Tue, 23 Mar 2010 09:51:46 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.34-rc2
Message-ID: <20100323095146.316a9487@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

a few bug fixes for s390, please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Christian Borntraeger (1):
      [S390] system.h: Fix compile error for 1 and 2 byte cmpxchg

Hans-Joachim Picht (1):
      [S390] fix broken proc interface for sclp_async

Heiko Carstens (2):
      [S390] smp: fix lowcore allocation
      [S390] sclp: avoid 64 bit division

Martin Schwidefsky (1):
      [S390] fix boot failures with compressed kernels

Michael Holzheu (1):
      [S390] zcore: CPU registers are not saved under LPAR

Stefan Haberland (1):
      [S390] dasd: check tsb validity

Stefan Weinhuber (1):
      [S390] dasd: fix alignment of transport mode recovery TCW

 arch/s390/boot/compressed/misc.c   |    5 +++--
 arch/s390/include/asm/system.h     |    9 +++++----
 arch/s390/kernel/head.S            |    3 +++
 arch/s390/kernel/head64.S          |    2 --
 arch/s390/kernel/setup.c           |    4 ++--
 arch/s390/kernel/smp.c             |    6 +++---
 arch/s390/mm/maccess.c             |   26 ++++++++++++++++++++++++++
 drivers/s390/block/dasd_3990_erp.c |    7 ++++---
 drivers/s390/block/dasd_eckd.c     |    4 ++--
 drivers/s390/char/sclp_async.c     |    1 +
 drivers/s390/char/sclp_cmd.c       |   14 +++++++-------
 drivers/s390/char/zcore.c          |   31 ++-----------------------------
 12 files changed, 58 insertions(+), 54 deletions(-)

diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index a97d695..66b0563 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -24,8 +24,8 @@
 /* Symbols defined by linker scripts */
 extern char input_data[];
 extern int input_len;
-extern int _text;
-extern int _end;
+extern char _text, _end;
+extern char _bss, _ebss;
 
 static void error(char *m);
 
@@ -129,6 +129,7 @@ unsigned long decompress_kernel(void)
 	unsigned long output_addr;
 	unsigned char *output;
 
+	memset(&_bss, 0, &_ebss - &_bss);
 	free_mem_ptr = (unsigned long)&_end;
 	free_mem_end_ptr = free_mem_ptr + HEAP_SIZE;
 	output = (unsigned char *) ((free_mem_end_ptr + 4095UL) & -4096UL);
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index 67ee6c3..1741c15 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -110,6 +110,7 @@ extern void pfault_fini(void);
 #endif /* CONFIG_PFAULT */
 
 extern void cmma_init(void);
+extern int memcpy_real(void *, void *, size_t);
 
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
@@ -218,8 +219,8 @@ __cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
 			"	l	%0,%2\n"
 			"0:	nr	%0,%5\n"
 			"	lr	%1,%0\n"
-			"	or	%0,%2\n"
-			"	or	%1,%3\n"
+			"	or	%0,%3\n"
+			"	or	%1,%4\n"
 			"	cs	%0,%1,%2\n"
 			"	jnl	1f\n"
 			"	xr	%1,%0\n"
@@ -239,8 +240,8 @@ __cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
 			"	l	%0,%2\n"
 			"0:	nr	%0,%5\n"
 			"	lr	%1,%0\n"
-			"	or	%0,%2\n"
-			"	or	%1,%3\n"
+			"	or	%0,%3\n"
+			"	or	%1,%4\n"
 			"	cs	%0,%1,%2\n"
 			"	jnl	1f\n"
 			"	xr	%1,%0\n"
diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index ca4a62b..9d1f767 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -517,7 +517,10 @@ startup:
 	lhi	%r1,2			# mode 2 = esame (dump)
 	sigp	%r1,%r0,0x12		# switch to esame mode
 	sam64				# switch to 64 bit mode
+	larl	%r13,4f
+	lmh	%r0,%r15,0(%r13)	# clear high-order half
 	jg	startup_continue
+4:	.fill	16,4,0x0
 #else
 	mvi	__LC_AR_MODE_ID,0	# set ESA flag (mode 0)
 	l	%r13,4f-.LPG0(%r13)
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index 39580e7..1f70970 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -21,7 +21,6 @@ startup_continue:
 	larl	%r1,sched_clock_base_cc
 	mvc	0(8,%r1),__LC_LAST_UPDATE_CLOCK
 	larl	%r13,.LPG1		# get base
-	lmh	%r0,%r15,.Lzero64-.LPG1(%r13)	# clear high-order half
 	lctlg	%c0,%c15,.Lctl-.LPG1(%r13)	# load control registers
 	lg	%r12,.Lparmaddr-.LPG1(%r13)	# pointer to parameter area
 					# move IPL device to lowcore
@@ -67,7 +66,6 @@ startup_continue:
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
 .Lnop:	.long	0x07000700
-.Lzero64:.fill	16,4,0x0
 .Lparmaddr:
 	.quad	PARMAREA
 	.align	64
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 77a63ae..ba363d9 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -401,7 +401,7 @@ setup_lowcore(void)
 	 * Setup lowcore for boot cpu
 	 */
 	BUILD_BUG_ON(sizeof(struct _lowcore) != LC_PAGES * 4096);
-	lc = __alloc_bootmem(LC_PAGES * PAGE_SIZE, LC_PAGES * PAGE_SIZE, 0);
+	lc = __alloc_bootmem_low(LC_PAGES * PAGE_SIZE, LC_PAGES * PAGE_SIZE, 0);
 	lc->restart_psw.mask = PSW_BASE_BITS | PSW_DEFAULT_KEY;
 	lc->restart_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) restart_int_handler;
@@ -433,7 +433,7 @@ setup_lowcore(void)
 #ifndef CONFIG_64BIT
 	if (MACHINE_HAS_IEEE) {
 		lc->extended_save_area_addr = (__u32)
-			__alloc_bootmem(PAGE_SIZE, PAGE_SIZE, 0);
+			__alloc_bootmem_low(PAGE_SIZE, PAGE_SIZE, 0);
 		/* enable extended save area */
 		__ctl_set_bit(14, 29);
 	}
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 29f65bc..d7d24fc 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -292,9 +292,9 @@ static void __init smp_get_save_area(unsigned int cpu, unsigned int phy_cpu)
 	zfcpdump_save_areas[cpu] = kmalloc(sizeof(struct save_area), GFP_KERNEL);
 	while (raw_sigp(phy_cpu, sigp_stop_and_store_status) == sigp_busy)
 		cpu_relax();
-	memcpy(zfcpdump_save_areas[cpu],
-	       (void *)(unsigned long) store_prefix() + SAVE_AREA_BASE,
-	       sizeof(struct save_area));
+	memcpy_real(zfcpdump_save_areas[cpu],
+		    (void *)(unsigned long) store_prefix() + SAVE_AREA_BASE,
+		    sizeof(struct save_area));
 }
 
 struct save_area *zfcpdump_save_areas[NR_CPUS + 1];
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 8175627..a8c2af8 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -59,3 +59,29 @@ long probe_kernel_write(void *dst, void *src, size_t size)
 	}
 	return copied < 0 ? -EFAULT : 0;
 }
+
+int memcpy_real(void *dest, void *src, size_t count)
+{
+	register unsigned long _dest asm("2") = (unsigned long) dest;
+	register unsigned long _len1 asm("3") = (unsigned long) count;
+	register unsigned long _src  asm("4") = (unsigned long) src;
+	register unsigned long _len2 asm("5") = (unsigned long) count;
+	unsigned long flags;
+	int rc = -EFAULT;
+
+	if (!count)
+		return 0;
+	flags = __raw_local_irq_stnsm(0xf8UL);
+	asm volatile (
+		"0:	mvcle	%1,%2,0x0\n"
+		"1:	jo	0b\n"
+		"	lhi	%0,0x0\n"
+		"2:\n"
+		EX_TABLE(1b,2b)
+		: "+d" (rc), "+d" (_dest), "+d" (_src), "+d" (_len1),
+		  "+d" (_len2), "=m" (*((long *) dest))
+		: "m" (*((long *) src))
+		: "cc", "memory");
+	__raw_local_irq_ssm(flags);
+	return rc;
+}
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index 51224f7..b3736b8 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2287,7 +2287,8 @@ static struct dasd_ccw_req *dasd_3990_erp_add_erp(struct dasd_ccw_req *cqr)
 
 	if (cqr->cpmode == 1) {
 		cplength = 0;
-		datasize = sizeof(struct tcw) + sizeof(struct tsb);
+		/* TCW needs to be 64 byte aligned, so leave enough room */
+		datasize = 64 + sizeof(struct tcw) + sizeof(struct tsb);
 	} else {
 		cplength = 2;
 		datasize = 0;
@@ -2316,8 +2317,8 @@ static struct dasd_ccw_req *dasd_3990_erp_add_erp(struct dasd_ccw_req *cqr)
 	if (cqr->cpmode == 1) {
 		/* make a shallow copy of the original tcw but set new tsb */
 		erp->cpmode = 1;
-		erp->cpaddr = erp->data;
-		tcw = erp->data;
+		erp->cpaddr = PTR_ALIGN(erp->data, 64);
+		tcw = erp->cpaddr;
 		tsb = (struct tsb *) &tcw[1];
 		*tcw = *((struct tcw *)cqr->cpaddr);
 		tcw->tsb = (long)tsb;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 01f4e7a..0cb2331 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3155,11 +3155,11 @@ static void dasd_eckd_dump_sense_tcw(struct dasd_device *device,
 
 	tsb = NULL;
 	sense = NULL;
-	if (irb->scsw.tm.tcw)
+	if (irb->scsw.tm.tcw && (irb->scsw.tm.fcxs == 0x01))
 		tsb = tcw_get_tsb(
 			(struct tcw *)(unsigned long)irb->scsw.tm.tcw);
 
-	if (tsb && (irb->scsw.tm.fcxs == 0x01)) {
+	if (tsb) {
 		len += sprintf(page + len, KERN_ERR PRINTK_HEADER
 			       " tsb->length %d\n", tsb->length);
 		len += sprintf(page + len, KERN_ERR PRINTK_HEADER
diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
index 740fe40..f449c69 100644
--- a/drivers/s390/char/sclp_async.c
+++ b/drivers/s390/char/sclp_async.c
@@ -84,6 +84,7 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
 		rc = copy_from_user(buf, buffer, sizeof(buf));
 		if (rc != 0)
 			return -EFAULT;
+		buf[len - 1] = '\0';
 		if (strict_strtoul(buf, 0, &val) != 0)
 			return -EINVAL;
 		if (val != 0 && val != 1)
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index fc7ae05..4b60ede 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -308,6 +308,13 @@ struct assign_storage_sccb {
 	u16 rn;
 } __packed;
 
+int arch_get_memory_phys_device(unsigned long start_pfn)
+{
+	if (!rzm)
+		return 0;
+	return PFN_PHYS(start_pfn) >> ilog2(rzm);
+}
+
 static unsigned long long rn2addr(u16 rn)
 {
 	return (unsigned long long) (rn - 1) * rzm;
@@ -704,13 +711,6 @@ int sclp_chp_deconfigure(struct chp_id chpid)
 	return do_chp_configure(SCLP_CMDW_DECONFIGURE_CHPATH | chpid.id << 8);
 }
 
-int arch_get_memory_phys_device(unsigned long start_pfn)
-{
-	if (!rzm)
-		return 0;
-	return PFN_PHYS(start_pfn) / rzm;
-}
-
 struct chp_info_sccb {
 	struct sccb_header header;
 	u8 recognized[SCLP_CHP_INFO_MASK_SIZE];
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 3438658..3166d85 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -141,33 +141,6 @@ static int memcpy_hsa_kernel(void *dest, unsigned long src, size_t count)
 	return memcpy_hsa(dest, src, count, TO_KERNEL);
 }
 
-static int memcpy_real(void *dest, unsigned long src, size_t count)
-{
-	unsigned long flags;
-	int rc = -EFAULT;
-	register unsigned long _dest asm("2") = (unsigned long) dest;
-	register unsigned long _len1 asm("3") = (unsigned long) count;
-	register unsigned long _src  asm("4") = src;
-	register unsigned long _len2 asm("5") = (unsigned long) count;
-
-	if (count == 0)
-		return 0;
-	flags = __raw_local_irq_stnsm(0xf8UL); /* switch to real mode */
-	asm volatile (
-		"0:	mvcle	%1,%2,0x0\n"
-		"1:	jo	0b\n"
-		"	lhi	%0,0x0\n"
-		"2:\n"
-		EX_TABLE(1b,2b)
-		: "+d" (rc), "+d" (_dest), "+d" (_src), "+d" (_len1),
-		  "+d" (_len2), "=m" (*((long*)dest))
-		: "m" (*((long*)src))
-		: "cc", "memory");
-	__raw_local_irq_ssm(flags);
-
-	return rc;
-}
-
 static int memcpy_real_user(void __user *dest, unsigned long src, size_t count)
 {
 	static char buf[4096];
@@ -175,7 +148,7 @@ static int memcpy_real_user(void __user *dest, unsigned long src, size_t count)
 
 	while (offs < count) {
 		size = min(sizeof(buf), count - offs);
-		if (memcpy_real(buf, src + offs, size))
+		if (memcpy_real(buf, (void *) src + offs, size))
 			return -EFAULT;
 		if (copy_to_user(dest + offs, buf, size))
 			return -EFAULT;
@@ -663,7 +636,7 @@ static int __init zcore_reipl_init(void)
 	if (ipib_info.ipib < ZFCPDUMP_HSA_SIZE)
 		rc = memcpy_hsa_kernel(ipl_block, ipib_info.ipib, PAGE_SIZE);
 	else
-		rc = memcpy_real(ipl_block, ipib_info.ipib, PAGE_SIZE);
+		rc = memcpy_real(ipl_block, (void *) ipib_info.ipib, PAGE_SIZE);
 	if (rc) {
 		free_page((unsigned long) ipl_block);
 		return rc;
