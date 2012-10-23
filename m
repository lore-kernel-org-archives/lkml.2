Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2JWHtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:49:17 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:49774 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2JWHtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:49:15 -0400
Date: Tue, 23 Oct 2012 09:48:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.7-rc3
Message-ID: <20121023094832.6a947e3b@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12102307-6892-0000-0000-00000350DDBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Among the usual minor bug fixes the more interesting patches are the perf
counters for the latest machine, the missing select to enable transparent
huge pages and a build fix for the UAPI rework.

David Howells (1):
      s390,uapi: do not use uapi/asm-generic/kvm_para.h

Gerald Schaefer (1):
      s390/thp: select HAVE_ARCH_TRANSPARENT_HUGEPAGE

Heiko Carstens (2):
      s390: fix linker script for 31 bit builds
      s390/cache: fix data/instruction cache output

Hendrik Brueckner (1):
      perf_cpum_cf: Add support for counters available with IBM zEC12

Michael Holzheu (1):
      s390/kdump: Use 64 bit mode for 0x10000 entry point

Sebastian Ott (3):
      s390/chpid: make headers usable (again)
      s390/cio: use generic bitmap functions
      s390/css: stop stsch loop after cc 3

 arch/s390/Kconfig                       |    1 +
 arch/s390/boot/compressed/vmlinux.lds.S |    2 +-
 arch/s390/include/asm/perf_event.h      |    2 +-
 arch/s390/include/uapi/asm/Kbuild       |    2 --
 arch/s390/include/uapi/asm/chpid.h      |   10 +++++-----
 arch/s390/include/uapi/asm/kvm_para.h   |   11 +++++++++++
 arch/s390/kernel/cache.c                |    9 ++++++---
 arch/s390/kernel/head_kdump.S           |   10 ++--------
 arch/s390/kernel/perf_cpum_cf.c         |    6 +++++-
 arch/s390/kernel/vmlinux.lds.S          |    2 +-
 drivers/s390/cio/css.c                  |    7 ++++++-
 drivers/s390/cio/idset.c                |   26 ++++++++++++++------------
 drivers/s390/cio/idset.h                |    3 ++-
 13 files changed, 55 insertions(+), 36 deletions(-)
 create mode 100644 arch/s390/include/uapi/asm/kvm_para.h

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3f3d9ca..5dba755 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -130,6 +130,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select HAVE_UID16 if 32BIT
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/s390/boot/compressed/vmlinux.lds.S b/arch/s390/boot/compressed/vmlinux.lds.S
index d80f79d..8e1fb82 100644
--- a/arch/s390/boot/compressed/vmlinux.lds.S
+++ b/arch/s390/boot/compressed/vmlinux.lds.S
@@ -5,7 +5,7 @@ OUTPUT_FORMAT("elf64-s390", "elf64-s390", "elf64-s390")
 OUTPUT_ARCH(s390:64-bit)
 #else
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
-OUTPUT_ARCH(s390)
+OUTPUT_ARCH(s390:31-bit)
 #endif
 
 ENTRY(startup)
diff --git a/arch/s390/include/asm/perf_event.h b/arch/s390/include/asm/perf_event.h
index 7941968..5f0173a 100644
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -9,7 +9,7 @@
 #include <asm/cpu_mf.h>
 
 /* CPU-measurement counter facility */
-#define PERF_CPUM_CF_MAX_CTR		160
+#define PERF_CPUM_CF_MAX_CTR		256
 
 /* Per-CPU flags for PMU states */
 #define PMU_F_RESERVED			0x1000
diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index 59b67ed..7bf68ff 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -1,8 +1,6 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-generic-y += kvm_para.h
-
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
diff --git a/arch/s390/include/uapi/asm/chpid.h b/arch/s390/include/uapi/asm/chpid.h
index 581992d..6b4fb29 100644
--- a/arch/s390/include/uapi/asm/chpid.h
+++ b/arch/s390/include/uapi/asm/chpid.h
@@ -1,5 +1,5 @@
 /*
- *    Copyright IBM Corp. 2007
+ *    Copyright IBM Corp. 2007, 2012
  *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
  */
 
@@ -12,10 +12,10 @@
 #define __MAX_CHPID 255
 
 struct chp_id {
-	u8 reserved1;
-	u8 cssid;
-	u8 reserved2;
-	u8 id;
+	__u8 reserved1;
+	__u8 cssid;
+	__u8 reserved2;
+	__u8 id;
 } __attribute__((packed));
 
 
diff --git a/arch/s390/include/uapi/asm/kvm_para.h b/arch/s390/include/uapi/asm/kvm_para.h
new file mode 100644
index 0000000..ff1f4e7
--- /dev/null
+++ b/arch/s390/include/uapi/asm/kvm_para.h
@@ -0,0 +1,11 @@
+/*
+ * User API definitions for paravirtual devices on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ */
diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
index 8df8d8a1..64b2465 100644
--- a/arch/s390/kernel/cache.c
+++ b/arch/s390/kernel/cache.c
@@ -59,8 +59,8 @@ enum {
 
 enum {
 	CACHE_TI_UNIFIED = 0,
-	CACHE_TI_INSTRUCTION = 0,
-	CACHE_TI_DATA,
+	CACHE_TI_DATA = 0,
+	CACHE_TI_INSTRUCTION,
 };
 
 struct cache_info {
@@ -121,7 +121,10 @@ static int __init cache_add(int level, int private, int type)
 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
 	if (!cache)
 		return -ENOMEM;
-	ti = type == CACHE_TYPE_DATA ? CACHE_TI_DATA : CACHE_TI_UNIFIED;
+	if (type == CACHE_TYPE_INSTRUCTION)
+		ti = CACHE_TI_INSTRUCTION;
+	else
+		ti = CACHE_TI_UNIFIED;
 	cache->size = ecag(EXTRACT_SIZE, level, ti);
 	cache->line_size = ecag(EXTRACT_LINE_SIZE, level, ti);
 	cache->associativity = ecag(EXTRACT_ASSOCIATIVITY, level, ti);
diff --git a/arch/s390/kernel/head_kdump.S b/arch/s390/kernel/head_kdump.S
index acaaaf4..085a95e 100644
--- a/arch/s390/kernel/head_kdump.S
+++ b/arch/s390/kernel/head_kdump.S
@@ -85,16 +85,10 @@
 .align 2
 startup_kdump_relocated:
 	basr	%r13,0
-0:
-	mvc	0(8,%r0),.Lrestart_psw-0b(%r13)	# Setup restart PSW
-	sam31					# Switch to 31 bit addr mode
-	sr	%r1,%r1				# Erase register r1
-	sr	%r2,%r2				# Erase register r2
-	sigp	%r1,%r2,SIGP_SET_ARCHITECTURE	# Switch to 31 bit arch mode
-	lpsw	0				# Start new kernel...
+0:	lpswe	.Lrestart_psw-0b(%r13)		# Start new kernel...
 .align	8
 .Lrestart_psw:
-	.long	0x00080000,0x80000000 + startup
+	.quad	0x0000000080000000,0x0000000000000000 + startup
 #else
 .align 2
 .Lep_startup_kdump:
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 9871b19..c4e7269 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -94,7 +94,7 @@ static int get_counter_set(u64 event)
 		set = CPUMF_CTR_SET_USER;
 	else if (event < 128)
 		set = CPUMF_CTR_SET_CRYPTO;
-	else if (event < 160)
+	else if (event < 256)
 		set = CPUMF_CTR_SET_EXT;
 
 	return set;
@@ -138,6 +138,10 @@ static int validate_ctr_version(const struct hw_perf_event *hwc)
 	case CPUMF_CTR_SET_EXT:
 		if (cpuhw->info.csvn < 1)
 			err = -EOPNOTSUPP;
+		if ((cpuhw->info.csvn == 1 && hwc->config > 159) ||
+		    (cpuhw->info.csvn == 2 && hwc->config > 175) ||
+		    (cpuhw->info.csvn  > 2 && hwc->config > 255))
+			err = -EOPNOTSUPP;
 		break;
 	}
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index de8fa9b..79cb51a 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -8,7 +8,7 @@
 
 #ifndef CONFIG_64BIT
 OUTPUT_FORMAT("elf32-s390", "elf32-s390", "elf32-s390")
-OUTPUT_ARCH(s390)
+OUTPUT_ARCH(s390:31-bit)
 ENTRY(startup)
 jiffies = jiffies_64 + 4;
 #else
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index b4d572f..fd00afd 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -377,7 +377,11 @@ static int css_evaluate_new_subchannel(struct subchannel_id schid, int slow)
 		/* Will be done on the slow path. */
 		return -EAGAIN;
 	}
-	if (stsch_err(schid, &schib) || !css_sch_is_valid(&schib)) {
+	if (stsch_err(schid, &schib)) {
+		/* Subchannel is not provided. */
+		return -ENXIO;
+	}
+	if (!css_sch_is_valid(&schib)) {
 		/* Unusable - ignore. */
 		return 0;
 	}
@@ -536,6 +540,7 @@ static int slow_eval_unknown_fn(struct subchannel_id schid, void *data)
 		case -ENOMEM:
 		case -EIO:
 			/* These should abort looping */
+			idset_sch_del_subseq(slow_subchannel_set, schid);
 			break;
 		default:
 			rc = 0;
diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
index e6d5f8c..199bc67 100644
--- a/drivers/s390/cio/idset.c
+++ b/drivers/s390/cio/idset.c
@@ -1,9 +1,10 @@
 /*
- *    Copyright IBM Corp. 2007
+ *    Copyright IBM Corp. 2007, 2012
  *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
  */
 
 #include <linux/vmalloc.h>
+#include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include "idset.h"
 #include "css.h"
@@ -89,6 +90,14 @@ void idset_sch_del(struct idset *set, struct subchannel_id schid)
 	idset_del(set, schid.ssid, schid.sch_no);
 }
 
+/* Clear ids starting from @schid up to end of subchannel set. */
+void idset_sch_del_subseq(struct idset *set, struct subchannel_id schid)
+{
+	int pos = schid.ssid * set->num_id + schid.sch_no;
+
+	bitmap_clear(set->bitmap, pos, set->num_id - schid.sch_no);
+}
+
 int idset_sch_contains(struct idset *set, struct subchannel_id schid)
 {
 	return idset_contains(set, schid.ssid, schid.sch_no);
@@ -111,20 +120,13 @@ int idset_sch_get_first(struct idset *set, struct subchannel_id *schid)
 
 int idset_is_empty(struct idset *set)
 {
-	int bitnum;
-
-	bitnum = find_first_bit(set->bitmap, set->num_ssid * set->num_id);
-	if (bitnum >= set->num_ssid * set->num_id)
-		return 1;
-	return 0;
+	return bitmap_empty(set->bitmap, set->num_ssid * set->num_id);
 }
 
 void idset_add_set(struct idset *to, struct idset *from)
 {
-	unsigned long i, len;
+	int len = min(__BITOPS_WORDS(to->num_ssid * to->num_id),
+		      __BITOPS_WORDS(from->num_ssid * from->num_id));
 
-	len = min(__BITOPS_WORDS(to->num_ssid * to->num_id),
-		  __BITOPS_WORDS(from->num_ssid * from->num_id));
-	for (i = 0; i < len ; i++)
-		to->bitmap[i] |= from->bitmap[i];
+	bitmap_or(to->bitmap, to->bitmap, from->bitmap, len);
 }
diff --git a/drivers/s390/cio/idset.h b/drivers/s390/cio/idset.h
index 3d943f0..06d3bc0 100644
--- a/drivers/s390/cio/idset.h
+++ b/drivers/s390/cio/idset.h
@@ -1,5 +1,5 @@
 /*
- *    Copyright IBM Corp. 2007
+ *    Copyright IBM Corp. 2007, 2012
  *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
  */
 
@@ -17,6 +17,7 @@ void idset_fill(struct idset *set);
 struct idset *idset_sch_new(void);
 void idset_sch_add(struct idset *set, struct subchannel_id id);
 void idset_sch_del(struct idset *set, struct subchannel_id id);
+void idset_sch_del_subseq(struct idset *set, struct subchannel_id schid);
 int idset_sch_contains(struct idset *set, struct subchannel_id id);
 int idset_sch_get_first(struct idset *set, struct subchannel_id *id);
 int idset_is_empty(struct idset *set);

