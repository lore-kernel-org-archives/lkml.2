Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1BUIvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:51:06 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47949 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab1BUIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:51:03 -0500
Date: Mon, 21 Feb 2011 09:51:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.38-rc5
Message-ID: <20110221095102.0e954a57@mschwide.boeblingen.de.ibm.com>
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

Heiko Carstens (2):
      [S390] atomic: use ACCESS_ONCE() for atomic_read()
      [S390] atomic: use inline asm

Horst Hartmann (1):
      [S390] net: provide architecture specific NET_SKB_PAD

Martin Schwidefsky (1):
      [S390] correct ipl parameter block safe guard

Stefan Haberland (1):
      [S390] dasd: correct device table

 arch/s390/boot/compressed/misc.c |    5 +++--
 arch/s390/include/asm/atomic.h   |   26 ++++++++++++++++++--------
 arch/s390/include/asm/cache.h    |    1 +
 drivers/s390/block/dasd_eckd.c   |    2 +-
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 0851eb1..2751b3a 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -133,11 +133,12 @@ unsigned long decompress_kernel(void)
 	unsigned long output_addr;
 	unsigned char *output;
 
-	check_ipl_parmblock((void *) 0, (unsigned long) output + SZ__bss_start);
+	output_addr = ((unsigned long) &_end + HEAP_SIZE + 4095UL) & -4096UL;
+	check_ipl_parmblock((void *) 0, output_addr + SZ__bss_start);
 	memset(&_bss, 0, &_ebss - &_bss);
 	free_mem_ptr = (unsigned long)&_end;
 	free_mem_end_ptr = free_mem_ptr + HEAP_SIZE;
-	output = (unsigned char *) ((free_mem_end_ptr + 4095UL) & -4096UL);
+	output = (unsigned char *) output_addr;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/*
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 76daea1..5c5ba10 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -36,14 +36,19 @@
 
 static inline int atomic_read(const atomic_t *v)
 {
-	barrier();
-	return v->counter;
+	int c;
+
+	asm volatile(
+		"	l	%0,%1\n"
+		: "=d" (c) : "Q" (v->counter));
+	return c;
 }
 
 static inline void atomic_set(atomic_t *v, int i)
 {
-	v->counter = i;
-	barrier();
+	asm volatile(
+		"	st	%1,%0\n"
+		: "=Q" (v->counter) : "d" (i));
 }
 
 static inline int atomic_add_return(int i, atomic_t *v)
@@ -128,14 +133,19 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 static inline long long atomic64_read(const atomic64_t *v)
 {
-	barrier();
-	return v->counter;
+	long long c;
+
+	asm volatile(
+		"	lg	%0,%1\n"
+		: "=d" (c) : "Q" (v->counter));
+	return c;
 }
 
 static inline void atomic64_set(atomic64_t *v, long long i)
 {
-	v->counter = i;
-	barrier();
+	asm volatile(
+		"	stg	%1,%0\n"
+		: "=Q" (v->counter) : "d" (i));
 }
 
 static inline long long atomic64_add_return(long long i, atomic64_t *v)
diff --git a/arch/s390/include/asm/cache.h b/arch/s390/include/asm/cache.h
index 24aafa6..2a30d5a 100644
--- a/arch/s390/include/asm/cache.h
+++ b/arch/s390/include/asm/cache.h
@@ -13,6 +13,7 @@
 
 #define L1_CACHE_BYTES     256
 #define L1_CACHE_SHIFT     8
+#define NET_SKB_PAD	   32
 
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 318672d..a9fe23d 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -72,7 +72,7 @@ static struct dasd_discipline dasd_eckd_discipline;
 static struct ccw_device_id dasd_eckd_ids[] = {
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3390, 0), .driver_info = 0x1},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3390, 0), .driver_info = 0x2},
-	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3390, 0), .driver_info = 0x3},
+	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3380, 0), .driver_info = 0x3},
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3380, 0), .driver_info = 0x4},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3380, 0), .driver_info = 0x5},
 	{ CCW_DEVICE_DEVTYPE (0x9343, 0, 0x9345, 0), .driver_info = 0x6},
