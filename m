Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab1CYMSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:18:31 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:43058 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1CYMS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:18:28 -0400
Date: Fri, 25 Mar 2011 13:18:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.39 #2
Message-ID: <20110325131827.405563bc@mschwide.boeblingen.de.ibm.com>
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

Chen Liu (1):
      [S390] early: Fix possible overlapping data buffer

Heiko Carstens (10):
      [S390] early: limit savesys cmd string handling
      [S390] oprofile: disable hw sampling for CONFIG_32BIT
      [S390] wire up sys_name_to_handle_at
      [S390] wire up sys_open_by_handle_at
      [S390] wire up sys_clock_adjtime
      [S390] wire up sys_syncfs
      [S390] setup: simplify setup_resources()
      [S390] setup: register bss section as resource
      [S390] xchg/cmpxchg: move to own header file
      [S390] cmpxchg: implement cmpxchg64()

Jan Glauber (1):
      [S390] qdio: prevent handling of buffers if count is zero

Sebastian Ott (3):
      [S390] ccw_driver: remove duplicate members
      [S390] ccw_bus_type: make it static
      [S390] ccwgroup_driver: remove duplicate members

 arch/s390/include/asm/ccwdev.h    |    4 -
 arch/s390/include/asm/ccwgroup.h  |    4 -
 arch/s390/include/asm/cmpxchg.h   |  225 +++++++++++++++++++++++++++++++++++++
 arch/s390/include/asm/system.h    |  196 +--------------------------------
 arch/s390/include/asm/unistd.h    |    6 +-
 arch/s390/kernel/compat_wrapper.S |   27 +++++
 arch/s390/kernel/early.c          |   22 ++--
 arch/s390/kernel/setup.c          |   88 +++++++--------
 arch/s390/kernel/syscalls.S       |    4 +
 arch/s390/oprofile/Makefile       |    3 +-
 arch/s390/oprofile/init.c         |   15 ++-
 drivers/s390/block/dasd_eckd.c    |    6 +-
 drivers/s390/block/dasd_fba.c     |    6 +-
 drivers/s390/char/con3215.c       |    6 +-
 drivers/s390/char/raw3270.c       |    6 +-
 drivers/s390/char/tape_34xx.c     |    6 +-
 drivers/s390/char/tape_3590.c     |    6 +-
 drivers/s390/char/vmur.c          |    6 +-
 drivers/s390/cio/ccwgroup.c       |    6 +-
 drivers/s390/cio/device.c         |   11 +-
 drivers/s390/cio/device.h         |    1 -
 drivers/s390/cio/qdio_main.c      |    3 +-
 drivers/s390/net/claw.c           |   12 ++-
 drivers/s390/net/ctcm_main.c      |   12 ++-
 drivers/s390/net/lcs.c            |   12 ++-
 drivers/s390/net/qeth_core_main.c |   10 +-
 drivers/s390/scsi/zfcp_ccw.c      |    6 +-
 27 files changed, 403 insertions(+), 306 deletions(-)
 create mode 100644 arch/s390/include/asm/cmpxchg.h

diff --git a/arch/s390/include/asm/ccwdev.h b/arch/s390/include/asm/ccwdev.h
index ff6f62e..623f2fb 100644
--- a/arch/s390/include/asm/ccwdev.h
+++ b/arch/s390/include/asm/ccwdev.h
@@ -112,7 +112,6 @@ enum uc_todo {
 
 /**
  * struct ccw driver - device driver for channel attached devices
- * @owner: owning module
  * @ids: ids supported by this driver
  * @probe: function called on probe
  * @remove: function called on remove
@@ -128,10 +127,8 @@ enum uc_todo {
  * @restore: callback for restoring after hibernation
  * @uc_handler: callback for unit check handler
  * @driver: embedded device driver structure
- * @name: device driver name
  */
 struct ccw_driver {
-	struct module *owner;
 	struct ccw_device_id *ids;
 	int (*probe) (struct ccw_device *);
 	void (*remove) (struct ccw_device *);
@@ -147,7 +144,6 @@ struct ccw_driver {
 	int (*restore)(struct ccw_device *);
 	enum uc_todo (*uc_handler) (struct ccw_device *, struct irb *);
 	struct device_driver driver;
-	char *name;
 };
 
 extern struct ccw_device *get_ccwdev_by_busid(struct ccw_driver *cdrv,
diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index c79c1e7..f2ea2c5 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -29,8 +29,6 @@ struct ccwgroup_device {
 
 /**
  * struct ccwgroup_driver - driver for ccw group devices
- * @owner: driver owner
- * @name: driver name
  * @max_slaves: maximum number of slave devices
  * @driver_id: unique id
  * @probe: function called on probe
@@ -46,8 +44,6 @@ struct ccwgroup_device {
  * @driver: embedded driver structure
  */
 struct ccwgroup_driver {
-	struct module *owner;
-	char *name;
 	int max_slaves;
 	unsigned long driver_id;
 
diff --git a/arch/s390/include/asm/cmpxchg.h b/arch/s390/include/asm/cmpxchg.h
new file mode 100644
index 0000000..7488e52
--- /dev/null
+++ b/arch/s390/include/asm/cmpxchg.h
@@ -0,0 +1,225 @@
+/*
+ * Copyright IBM Corp. 1999, 2011
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
+ */
+
+#ifndef __ASM_CMPXCHG_H
+#define __ASM_CMPXCHG_H
+
+#include <linux/types.h>
+
+extern void __xchg_called_with_bad_pointer(void);
+
+static inline unsigned long __xchg(unsigned long x, void *ptr, int size)
+{
+	unsigned long addr, old;
+	int shift;
+
+	switch (size) {
+	case 1:
+		addr = (unsigned long) ptr;
+		shift = (3 ^ (addr & 3)) << 3;
+		addr ^= addr & 3;
+		asm volatile(
+			"	l	%0,%4\n"
+			"0:	lr	0,%0\n"
+			"	nr	0,%3\n"
+			"	or	0,%2\n"
+			"	cs	%0,0,%4\n"
+			"	jl	0b\n"
+			: "=&d" (old), "=Q" (*(int *) addr)
+			: "d" (x << shift), "d" (~(255 << shift)),
+			  "Q" (*(int *) addr) : "memory", "cc", "0");
+		return old >> shift;
+	case 2:
+		addr = (unsigned long) ptr;
+		shift = (2 ^ (addr & 2)) << 3;
+		addr ^= addr & 2;
+		asm volatile(
+			"	l	%0,%4\n"
+			"0:	lr	0,%0\n"
+			"	nr	0,%3\n"
+			"	or	0,%2\n"
+			"	cs	%0,0,%4\n"
+			"	jl	0b\n"
+			: "=&d" (old), "=Q" (*(int *) addr)
+			: "d" (x << shift), "d" (~(65535 << shift)),
+			  "Q" (*(int *) addr) : "memory", "cc", "0");
+		return old >> shift;
+	case 4:
+		asm volatile(
+			"	l	%0,%3\n"
+			"0:	cs	%0,%2,%3\n"
+			"	jl	0b\n"
+			: "=&d" (old), "=Q" (*(int *) ptr)
+			: "d" (x), "Q" (*(int *) ptr)
+			: "memory", "cc");
+		return old;
+#ifdef CONFIG_64BIT
+	case 8:
+		asm volatile(
+			"	lg	%0,%3\n"
+			"0:	csg	%0,%2,%3\n"
+			"	jl	0b\n"
+			: "=&d" (old), "=m" (*(long *) ptr)
+			: "d" (x), "Q" (*(long *) ptr)
+			: "memory", "cc");
+		return old;
+#endif /* CONFIG_64BIT */
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+#define xchg(ptr, x)							  \
+({									  \
+	__typeof__(*(ptr)) __ret;					  \
+	__ret = (__typeof__(*(ptr)))					  \
+		__xchg((unsigned long)(x), (void *)(ptr), sizeof(*(ptr)));\
+	__ret;								  \
+})
+
+/*
+ * Atomic compare and exchange.	 Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.	Success is
+ * indicated by comparing RETURN with OLD.
+ */
+
+#define __HAVE_ARCH_CMPXCHG
+
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static inline unsigned long __cmpxchg(void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long addr, prev, tmp;
+	int shift;
+
+	switch (size) {
+	case 1:
+		addr = (unsigned long) ptr;
+		shift = (3 ^ (addr & 3)) << 3;
+		addr ^= addr & 3;
+		asm volatile(
+			"	l	%0,%2\n"
+			"0:	nr	%0,%5\n"
+			"	lr	%1,%0\n"
+			"	or	%0,%3\n"
+			"	or	%1,%4\n"
+			"	cs	%0,%1,%2\n"
+			"	jnl	1f\n"
+			"	xr	%1,%0\n"
+			"	nr	%1,%5\n"
+			"	jnz	0b\n"
+			"1:"
+			: "=&d" (prev), "=&d" (tmp), "=Q" (*(int *) ptr)
+			: "d" (old << shift), "d" (new << shift),
+			  "d" (~(255 << shift)), "Q" (*(int *) ptr)
+			: "memory", "cc");
+		return prev >> shift;
+	case 2:
+		addr = (unsigned long) ptr;
+		shift = (2 ^ (addr & 2)) << 3;
+		addr ^= addr & 2;
+		asm volatile(
+			"	l	%0,%2\n"
+			"0:	nr	%0,%5\n"
+			"	lr	%1,%0\n"
+			"	or	%0,%3\n"
+			"	or	%1,%4\n"
+			"	cs	%0,%1,%2\n"
+			"	jnl	1f\n"
+			"	xr	%1,%0\n"
+			"	nr	%1,%5\n"
+			"	jnz	0b\n"
+			"1:"
+			: "=&d" (prev), "=&d" (tmp), "=Q" (*(int *) ptr)
+			: "d" (old << shift), "d" (new << shift),
+			  "d" (~(65535 << shift)), "Q" (*(int *) ptr)
+			: "memory", "cc");
+		return prev >> shift;
+	case 4:
+		asm volatile(
+			"	cs	%0,%3,%1\n"
+			: "=&d" (prev), "=Q" (*(int *) ptr)
+			: "0" (old), "d" (new), "Q" (*(int *) ptr)
+			: "memory", "cc");
+		return prev;
+#ifdef CONFIG_64BIT
+	case 8:
+		asm volatile(
+			"	csg	%0,%3,%1\n"
+			: "=&d" (prev), "=Q" (*(long *) ptr)
+			: "0" (old), "d" (new), "Q" (*(long *) ptr)
+			: "memory", "cc");
+		return prev;
+#endif /* CONFIG_64BIT */
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
+				       (unsigned long)(n), sizeof(*(ptr))))
+
+#ifdef CONFIG_64BIT
+#define cmpxchg64(ptr, o, n)						\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+})
+#else /* CONFIG_64BIT */
+static inline unsigned long long __cmpxchg64(void *ptr,
+					     unsigned long long old,
+					     unsigned long long new)
+{
+	register_pair rp_old = {.pair = old};
+	register_pair rp_new = {.pair = new};
+
+	asm volatile(
+		"	cds	%0,%2,%1"
+		: "+&d" (rp_old), "=Q" (ptr)
+		: "d" (rp_new), "Q" (ptr)
+		: "cc");
+	return rp_old.pair;
+}
+#define cmpxchg64(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
+					 (unsigned long long)(o),	\
+					 (unsigned long long)(n)))
+#endif /* CONFIG_64BIT */
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(void *ptr,
+					    unsigned long old,
+					    unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+	case 2:
+	case 4:
+#ifdef CONFIG_64BIT
+	case 8:
+#endif
+		return __cmpxchg(ptr, old, new, size);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr, o, n)	cmpxchg64((ptr), (o), (n))
+
+#endif /* __ASM_CMPXCHG_H */
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index 8f8d759..d382629 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -14,6 +14,7 @@
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/lowcore.h>
+#include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
 
@@ -120,161 +121,6 @@ extern int memcpy_real(void *, void *, size_t);
 
 #define nop() asm volatile("nop")
 
-#define xchg(ptr,x)							  \
-({									  \
-	__typeof__(*(ptr)) __ret;					  \
-	__ret = (__typeof__(*(ptr)))					  \
-		__xchg((unsigned long)(x), (void *)(ptr),sizeof(*(ptr))); \
-	__ret;								  \
-})
-
-extern void __xchg_called_with_bad_pointer(void);
-
-static inline unsigned long __xchg(unsigned long x, void * ptr, int size)
-{
-	unsigned long addr, old;
-	int shift;
-
-        switch (size) {
-	case 1:
-		addr = (unsigned long) ptr;
-		shift = (3 ^ (addr & 3)) << 3;
-		addr ^= addr & 3;
-		asm volatile(
-			"	l	%0,%4\n"
-			"0:	lr	0,%0\n"
-			"	nr	0,%3\n"
-			"	or	0,%2\n"
-			"	cs	%0,0,%4\n"
-			"	jl	0b\n"
-			: "=&d" (old), "=Q" (*(int *) addr)
-			: "d" (x << shift), "d" (~(255 << shift)),
-			  "Q" (*(int *) addr) : "memory", "cc", "0");
-		return old >> shift;
-	case 2:
-		addr = (unsigned long) ptr;
-		shift = (2 ^ (addr & 2)) << 3;
-		addr ^= addr & 2;
-		asm volatile(
-			"	l	%0,%4\n"
-			"0:	lr	0,%0\n"
-			"	nr	0,%3\n"
-			"	or	0,%2\n"
-			"	cs	%0,0,%4\n"
-			"	jl	0b\n"
-			: "=&d" (old), "=Q" (*(int *) addr)
-			: "d" (x << shift), "d" (~(65535 << shift)),
-			  "Q" (*(int *) addr) : "memory", "cc", "0");
-		return old >> shift;
-	case 4:
-		asm volatile(
-			"	l	%0,%3\n"
-			"0:	cs	%0,%2,%3\n"
-			"	jl	0b\n"
-			: "=&d" (old), "=Q" (*(int *) ptr)
-			: "d" (x), "Q" (*(int *) ptr)
-			: "memory", "cc");
-		return old;
-#ifdef __s390x__
-	case 8:
-		asm volatile(
-			"	lg	%0,%3\n"
-			"0:	csg	%0,%2,%3\n"
-			"	jl	0b\n"
-			: "=&d" (old), "=m" (*(long *) ptr)
-			: "d" (x), "Q" (*(long *) ptr)
-			: "memory", "cc");
-		return old;
-#endif /* __s390x__ */
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-
-#define __HAVE_ARCH_CMPXCHG 1
-
-#define cmpxchg(ptr, o, n)						\
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))))
-
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
-{
-	unsigned long addr, prev, tmp;
-	int shift;
-
-        switch (size) {
-	case 1:
-		addr = (unsigned long) ptr;
-		shift = (3 ^ (addr & 3)) << 3;
-		addr ^= addr & 3;
-		asm volatile(
-			"	l	%0,%2\n"
-			"0:	nr	%0,%5\n"
-			"	lr	%1,%0\n"
-			"	or	%0,%3\n"
-			"	or	%1,%4\n"
-			"	cs	%0,%1,%2\n"
-			"	jnl	1f\n"
-			"	xr	%1,%0\n"
-			"	nr	%1,%5\n"
-			"	jnz	0b\n"
-			"1:"
-			: "=&d" (prev), "=&d" (tmp), "=Q" (*(int *) ptr)
-			: "d" (old << shift), "d" (new << shift),
-			  "d" (~(255 << shift)), "Q" (*(int *) ptr)
-			: "memory", "cc");
-		return prev >> shift;
-	case 2:
-		addr = (unsigned long) ptr;
-		shift = (2 ^ (addr & 2)) << 3;
-		addr ^= addr & 2;
-		asm volatile(
-			"	l	%0,%2\n"
-			"0:	nr	%0,%5\n"
-			"	lr	%1,%0\n"
-			"	or	%0,%3\n"
-			"	or	%1,%4\n"
-			"	cs	%0,%1,%2\n"
-			"	jnl	1f\n"
-			"	xr	%1,%0\n"
-			"	nr	%1,%5\n"
-			"	jnz	0b\n"
-			"1:"
-			: "=&d" (prev), "=&d" (tmp), "=Q" (*(int *) ptr)
-			: "d" (old << shift), "d" (new << shift),
-			  "d" (~(65535 << shift)), "Q" (*(int *) ptr)
-			: "memory", "cc");
-		return prev >> shift;
-	case 4:
-		asm volatile(
-			"	cs	%0,%3,%1\n"
-			: "=&d" (prev), "=Q" (*(int *) ptr)
-			: "0" (old), "d" (new), "Q" (*(int *) ptr)
-			: "memory", "cc");
-		return prev;
-#ifdef __s390x__
-	case 8:
-		asm volatile(
-			"	csg	%0,%3,%1\n"
-			: "=&d" (prev), "=Q" (*(long *) ptr)
-			: "0" (old), "d" (new), "Q" (*(long *) ptr)
-			: "memory", "cc");
-		return prev;
-#endif /* __s390x__ */
-        }
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
 /*
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking
@@ -353,46 +199,6 @@ __cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
 	__ctl_load(__dummy, cr, cr);	\
 })
 
-#include <linux/irqflags.h>
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-	case 2:
-	case 4:
-#ifdef __s390x__
-	case 8:
-#endif
-		return __cmpxchg(ptr, old, new, size);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new, size);
-	}
-
-	return old;
-}
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-			(unsigned long)(n), sizeof(*(ptr))))
-#ifdef __s390x__
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-#else
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-#endif
-
 /*
  * Use to set psw mask except for the first byte which
  * won't be changed by this function.
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 1049ef2..e821525 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -272,7 +272,11 @@
 #define __NR_fanotify_init	332
 #define __NR_fanotify_mark	333
 #define __NR_prlimit64		334
-#define NR_syscalls 335
+#define __NR_name_to_handle_at	335
+#define __NR_open_by_handle_at	336
+#define __NR_clock_adjtime	337
+#define __NR_syncfs		338
+#define NR_syscalls 339
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 8e60fb2..1dc96ea 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1877,3 +1877,30 @@ sys_prlimit64_wrapper:
 	llgtr	%r4,%r4			# const struct rlimit64 __user *
 	llgtr	%r5,%r5			# struct rlimit64 __user *
 	jg	sys_prlimit64		# branch to system call
+
+	.globl	sys_name_to_handle_at_wrapper
+sys_name_to_handle_at_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# const char __user *
+	llgtr	%r4,%r4			# struct file_handle __user *
+	llgtr	%r5,%r5			# int __user *
+	lgfr	%r6,%r6			# int
+	jg	sys_name_to_handle_at
+
+	.globl	compat_sys_open_by_handle_at_wrapper
+compat_sys_open_by_handle_at_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# struct file_handle __user *
+	lgfr	%r4,%r4			# int
+	jg	compat_sys_open_by_handle_at
+
+	.globl	compat_sys_clock_adjtime_wrapper
+compat_sys_clock_adjtime_wrapper:
+	lgfr	%r2,%r2			# clockid_t (int)
+	llgtr	%r3,%r3			# struct compat_timex __user *
+	jg	compat_sys_clock_adjtime
+
+	.globl	sys_syncfs_wrapper
+sys_syncfs_wrapper:
+	lgfr	%r2,%r2			# int
+	jg	sys_syncfs
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 3b7e7dd..068f846 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -94,6 +94,7 @@ static noinline __init void create_kernel_nss(void)
 	unsigned int sinitrd_pfn, einitrd_pfn;
 #endif
 	int response;
+	int hlen;
 	size_t len;
 	char *savesys_ptr;
 	char defsys_cmd[DEFSYS_CMD_SIZE];
@@ -124,24 +125,27 @@ static noinline __init void create_kernel_nss(void)
 	end_pfn = PFN_UP(__pa(&_end));
 	min_size = end_pfn << 2;
 
-	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
-		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
-		eshared_pfn, end_pfn);
+	hlen = snprintf(defsys_cmd, DEFSYS_CMD_SIZE,
+			"DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
+			kernel_nss_name, stext_pfn - 1, stext_pfn,
+			eshared_pfn - 1, eshared_pfn, end_pfn);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (INITRD_START && INITRD_SIZE) {
 		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
 		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
 		min_size = einitrd_pfn << 2;
-		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
-		sinitrd_pfn, einitrd_pfn);
+		hlen += snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen,
+				 " EW %.5X-%.5X", sinitrd_pfn, einitrd_pfn);
 	}
 #endif
 
-	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13",
-		defsys_cmd, min_size);
-	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
-		kernel_nss_name, kernel_nss_name);
+	snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen,
+		 " EW MINSIZE=%.7iK PARMREGS=0-13", min_size);
+	defsys_cmd[DEFSYS_CMD_SIZE - 1] = '\0';
+	snprintf(savesys_cmd, SAVESYS_CMD_SIZE, "SAVESYS %s \n IPL %s",
+		 kernel_nss_name, kernel_nss_name);
+	savesys_cmd[SAVESYS_CMD_SIZE - 1] = '\0';
 
 	__cpcmd(defsys_cmd, NULL, 0, &response);
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 6f63508..ed183c2 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -102,16 +102,6 @@ EXPORT_SYMBOL(lowcore_ptr);
 
 #include <asm/setup.h>
 
-static struct resource code_resource = {
-	.name  = "Kernel code",
-	.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
-};
-
-static struct resource data_resource = {
-	.name = "Kernel data",
-	.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
-};
-
 /*
  * condev= and conmode= setup parameter.
  */
@@ -436,21 +426,43 @@ setup_lowcore(void)
 	lowcore_ptr[0] = lc;
 }
 
-static void __init
-setup_resources(void)
+static struct resource code_resource = {
+	.name  = "Kernel code",
+	.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
+};
+
+static struct resource data_resource = {
+	.name = "Kernel data",
+	.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
+};
+
+static struct resource bss_resource = {
+	.name = "Kernel bss",
+	.flags = IORESOURCE_BUSY | IORESOURCE_MEM,
+};
+
+static struct resource __initdata *standard_resources[] = {
+	&code_resource,
+	&data_resource,
+	&bss_resource,
+};
+
+static void __init setup_resources(void)
 {
-	struct resource *res, *sub_res;
-	int i;
+	struct resource *res, *std_res, *sub_res;
+	int i, j;
 
 	code_resource.start = (unsigned long) &_text;
 	code_resource.end = (unsigned long) &_etext - 1;
 	data_resource.start = (unsigned long) &_etext;
 	data_resource.end = (unsigned long) &_edata - 1;
+	bss_resource.start = (unsigned long) &__bss_start;
+	bss_resource.end = (unsigned long) &__bss_stop - 1;
 
 	for (i = 0; i < MEMORY_CHUNKS; i++) {
 		if (!memory_chunk[i].size)
 			continue;
-		res = alloc_bootmem_low(sizeof(struct resource));
+		res = alloc_bootmem_low(sizeof(*res));
 		res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
 		switch (memory_chunk[i].type) {
 		case CHUNK_READ_WRITE:
@@ -464,40 +476,24 @@ setup_resources(void)
 			res->name = "reserved";
 		}
 		res->start = memory_chunk[i].addr;
-		res->end = memory_chunk[i].addr +  memory_chunk[i].size - 1;
+		res->end = res->start + memory_chunk[i].size - 1;
 		request_resource(&iomem_resource, res);
 
-		if (code_resource.start >= res->start  &&
-			code_resource.start <= res->end &&
-			code_resource.end > res->end) {
-			sub_res = alloc_bootmem_low(sizeof(struct resource));
-			memcpy(sub_res, &code_resource,
-				sizeof(struct resource));
-			sub_res->end = res->end;
-			code_resource.start = res->end + 1;
-			request_resource(res, sub_res);
-		}
-
-		if (code_resource.start >= res->start &&
-			code_resource.start <= res->end &&
-			code_resource.end <= res->end)
-			request_resource(res, &code_resource);
-
-		if (data_resource.start >= res->start &&
-			data_resource.start <= res->end &&
-			data_resource.end > res->end) {
-			sub_res = alloc_bootmem_low(sizeof(struct resource));
-			memcpy(sub_res, &data_resource,
-				sizeof(struct resource));
-			sub_res->end = res->end;
-			data_resource.start = res->end + 1;
-			request_resource(res, sub_res);
+		for (j = 0; j < ARRAY_SIZE(standard_resources); j++) {
+			std_res = standard_resources[j];
+			if (std_res->start < res->start ||
+			    std_res->start > res->end)
+				continue;
+			if (std_res->end > res->end) {
+				sub_res = alloc_bootmem_low(sizeof(*sub_res));
+				*sub_res = *std_res;
+				sub_res->end = res->end;
+				std_res->start = res->end + 1;
+				request_resource(res, sub_res);
+			} else {
+				request_resource(res, std_res);
+			}
 		}
-
-		if (data_resource.start >= res->start &&
-			data_resource.start <= res->end &&
-			data_resource.end <= res->end)
-			request_resource(res, &data_resource);
 	}
 }
 
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index a8fee1b..9c65fd4 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -343,3 +343,7 @@ SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
 SYSCALL(sys_fanotify_init,sys_fanotify_init,sys_fanotify_init_wrapper)
 SYSCALL(sys_fanotify_mark,sys_fanotify_mark,sys_fanotify_mark_wrapper)
 SYSCALL(sys_prlimit64,sys_prlimit64,sys_prlimit64_wrapper)
+SYSCALL(sys_name_to_handle_at,sys_name_to_handle_at,sys_name_to_handle_at_wrapper) /* 335 */
+SYSCALL(sys_open_by_handle_at,sys_open_by_handle_at,compat_sys_open_by_handle_at_wrapper)
+SYSCALL(sys_clock_adjtime,sys_clock_adjtime,compat_sys_clock_adjtime_wrapper)
+SYSCALL(sys_syncfs,sys_syncfs,sys_syncfs_wrapper)
diff --git a/arch/s390/oprofile/Makefile b/arch/s390/oprofile/Makefile
index d698cdd..524c4b6 100644
--- a/arch/s390/oprofile/Makefile
+++ b/arch/s390/oprofile/Makefile
@@ -6,4 +6,5 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		oprofilefs.o oprofile_stats.o  \
 		timer_int.o )
 
-oprofile-y :=	$(DRIVER_OBJS) init.o backtrace.o hwsampler.o
+oprofile-y :=	$(DRIVER_OBJS) init.o backtrace.o
+oprofile-$(CONFIG_64BIT)	+= hwsampler.o
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 16c76de..c63d7e5 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -18,6 +18,11 @@
 #include <linux/fs.h>
 
 #include "../../../drivers/oprofile/oprof.h"
+
+extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
+
+#ifdef CONFIG_64BIT
+
 #include "hwsampler.h"
 
 #define DEFAULT_INTERVAL	4096
@@ -37,8 +42,6 @@ static int hwsampler_running;	/* start_mutex must be held to change */
 
 static struct oprofile_operations timer_ops;
 
-extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
-
 static int oprofile_hwsampler_start(void)
 {
 	int retval;
@@ -172,14 +175,22 @@ static void oprofile_hwsampler_exit(void)
 	hwsampler_shutdown();
 }
 
+#endif /* CONFIG_64BIT */
+
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	ops->backtrace = s390_backtrace;
 
+#ifdef CONFIG_64BIT
 	return oprofile_hwsampler_init(ops);
+#else
+	return -ENODEV;
+#endif
 }
 
 void oprofile_arch_exit(void)
 {
+#ifdef CONFIG_64BIT
 	oprofile_hwsampler_exit();
+#endif
 }
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 379d859..459f2cb 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3982,8 +3982,10 @@ out_err:
 }
 
 static struct ccw_driver dasd_eckd_driver = {
-	.name	     = "dasd-eckd",
-	.owner	     = THIS_MODULE,
+	.driver = {
+		.name	= "dasd-eckd",
+		.owner	= THIS_MODULE,
+	},
 	.ids	     = dasd_eckd_ids,
 	.probe	     = dasd_eckd_probe,
 	.remove      = dasd_generic_remove,
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index be89b3a..4b71b11 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -65,8 +65,10 @@ dasd_fba_set_online(struct ccw_device *cdev)
 }
 
 static struct ccw_driver dasd_fba_driver = {
-	.name        = "dasd-fba",
-	.owner       = THIS_MODULE,
+	.driver = {
+		.name	= "dasd-fba",
+		.owner	= THIS_MODULE,
+	},
 	.ids         = dasd_fba_ids,
 	.probe       = dasd_fba_probe,
 	.remove      = dasd_generic_remove,
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 3fb4335..694464c 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -764,8 +764,10 @@ static struct ccw_device_id raw3215_id[] = {
 };
 
 static struct ccw_driver raw3215_ccw_driver = {
-	.name		= "3215",
-	.owner		= THIS_MODULE,
+	.driver = {
+		.name	= "3215",
+		.owner	= THIS_MODULE,
+	},
 	.ids		= raw3215_id,
 	.probe		= &raw3215_probe,
 	.remove		= &raw3215_remove,
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 96ba2fd..4c02376 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -1388,8 +1388,10 @@ static struct ccw_device_id raw3270_id[] = {
 };
 
 static struct ccw_driver raw3270_ccw_driver = {
-	.name		= "3270",
-	.owner		= THIS_MODULE,
+	.driver = {
+		.name	= "3270",
+		.owner	= THIS_MODULE,
+	},
 	.ids		= raw3270_id,
 	.probe		= &raw3270_probe,
 	.remove		= &raw3270_remove,
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index c265111..9eff2df 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -1320,8 +1320,10 @@ tape_34xx_online(struct ccw_device *cdev)
 }
 
 static struct ccw_driver tape_34xx_driver = {
-	.name = "tape_34xx",
-	.owner = THIS_MODULE,
+	.driver = {
+		.name = "tape_34xx",
+		.owner = THIS_MODULE,
+	},
 	.ids = tape_34xx_ids,
 	.probe = tape_generic_probe,
 	.remove = tape_generic_remove,
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index de2e99e..b98dcbd 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -1761,8 +1761,10 @@ tape_3590_online(struct ccw_device *cdev)
 }
 
 static struct ccw_driver tape_3590_driver = {
-	.name = "tape_3590",
-	.owner = THIS_MODULE,
+	.driver = {
+		.name = "tape_3590",
+		.owner = THIS_MODULE,
+	},
 	.ids = tape_3590_ids,
 	.probe = tape_generic_probe,
 	.remove = tape_generic_remove,
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index caef175..f6b00c3 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -64,8 +64,10 @@ static int ur_set_offline(struct ccw_device *cdev);
 static int ur_pm_suspend(struct ccw_device *cdev);
 
 static struct ccw_driver ur_driver = {
-	.name		= "vmur",
-	.owner		= THIS_MODULE,
+	.driver = {
+		.name	= "vmur",
+		.owner	= THIS_MODULE,
+	},
 	.ids		= ur_ids,
 	.probe		= ur_probe,
 	.remove		= ur_remove,
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 2864581..5c56741 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -428,7 +428,7 @@ ccwgroup_online_store (struct device *dev, struct device_attribute *attr, const
 	gdev = to_ccwgroupdev(dev);
 	gdrv = to_ccwgroupdrv(dev->driver);
 
-	if (!try_module_get(gdrv->owner))
+	if (!try_module_get(gdrv->driver.owner))
 		return -EINVAL;
 
 	ret = strict_strtoul(buf, 0, &value);
@@ -442,7 +442,7 @@ ccwgroup_online_store (struct device *dev, struct device_attribute *attr, const
 	else
 		ret = -EINVAL;
 out:
-	module_put(gdrv->owner);
+	module_put(gdrv->driver.owner);
 	return (ret == 0) ? count : ret;
 }
 
@@ -616,8 +616,6 @@ int ccwgroup_driver_register(struct ccwgroup_driver *cdriver)
 {
 	/* register our new driver with the core */
 	cdriver->driver.bus = &ccwgroup_bus_type;
-	cdriver->driver.name = cdriver->name;
-	cdriver->driver.owner = cdriver->owner;
 
 	return driver_register(&cdriver->driver);
 }
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index e50b121..df14c51 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -127,7 +127,7 @@ static int ccw_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return ret;
 }
 
-struct bus_type ccw_bus_type;
+static struct bus_type ccw_bus_type;
 
 static void io_subchannel_irq(struct subchannel *);
 static int io_subchannel_probe(struct subchannel *);
@@ -547,7 +547,7 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 	if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
 		return -EAGAIN;
 
-	if (cdev->drv && !try_module_get(cdev->drv->owner)) {
+	if (cdev->drv && !try_module_get(cdev->drv->driver.owner)) {
 		atomic_set(&cdev->private->onoff, 0);
 		return -EINVAL;
 	}
@@ -573,7 +573,7 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 	}
 out:
 	if (cdev->drv)
-		module_put(cdev->drv->owner);
+		module_put(cdev->drv->driver.owner);
 	atomic_set(&cdev->private->onoff, 0);
 	return (ret < 0) ? ret : count;
 }
@@ -1970,7 +1970,7 @@ static const struct dev_pm_ops ccw_pm_ops = {
 	.restore = ccw_device_pm_restore,
 };
 
-struct bus_type ccw_bus_type = {
+static struct bus_type ccw_bus_type = {
 	.name   = "ccw",
 	.match  = ccw_bus_match,
 	.uevent = ccw_uevent,
@@ -1993,8 +1993,6 @@ int ccw_driver_register(struct ccw_driver *cdriver)
 	struct device_driver *drv = &cdriver->driver;
 
 	drv->bus = &ccw_bus_type;
-	drv->name = cdriver->name;
-	drv->owner = cdriver->owner;
 
 	return driver_register(drv);
 }
@@ -2112,5 +2110,4 @@ EXPORT_SYMBOL(ccw_device_set_offline);
 EXPORT_SYMBOL(ccw_driver_register);
 EXPORT_SYMBOL(ccw_driver_unregister);
 EXPORT_SYMBOL(get_ccwdev_by_busid);
-EXPORT_SYMBOL(ccw_bus_type);
 EXPORT_SYMBOL_GPL(ccw_device_get_subchannel_id);
diff --git a/drivers/s390/cio/device.h b/drivers/s390/cio/device.h
index 379de2d..7e297c7 100644
--- a/drivers/s390/cio/device.h
+++ b/drivers/s390/cio/device.h
@@ -133,7 +133,6 @@ void ccw_device_set_notoper(struct ccw_device *cdev);
 /* qdio needs this. */
 void ccw_device_set_timeout(struct ccw_device *, int);
 extern struct subchannel_id ccw_device_get_subchannel_id(struct ccw_device *);
-extern struct bus_type ccw_bus_type;
 
 /* Channel measurement facility related */
 void retry_set_schib(struct ccw_device *cdev);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 5640c89..479c665 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1508,7 +1508,8 @@ int do_QDIO(struct ccw_device *cdev, unsigned int callflags,
 
 	if (irq_ptr->state != QDIO_IRQ_STATE_ACTIVE)
 		return -EBUSY;
-
+	if (!count)
+		return 0;
 	if (callflags & QDIO_FLAG_SYNC_INPUT)
 		return handle_inbound(irq_ptr->input_qs[q_nr],
 				      callflags, bufnr, count);
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index ce3a5c1..9feb62f 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -264,8 +264,10 @@ static struct device *claw_root_dev;
 /* ccwgroup table  */
 
 static struct ccwgroup_driver claw_group_driver = {
-        .owner       = THIS_MODULE,
-        .name        = "claw",
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "claw",
+	},
         .max_slaves  = 2,
         .driver_id   = 0xC3D3C1E6,
         .probe       = claw_probe,
@@ -282,8 +284,10 @@ static struct ccw_device_id claw_ids[] = {
 MODULE_DEVICE_TABLE(ccw, claw_ids);
 
 static struct ccw_driver claw_ccw_driver = {
-	.owner	= THIS_MODULE,
-	.name	= "claw",
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "claw",
+	},
 	.ids	= claw_ids,
 	.probe	= ccwgroup_probe_ccwdev,
 	.remove	= ccwgroup_remove_ccwdev,
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 4c28459..c189296 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1764,16 +1764,20 @@ static struct ccw_device_id ctcm_ids[] = {
 MODULE_DEVICE_TABLE(ccw, ctcm_ids);
 
 static struct ccw_driver ctcm_ccw_driver = {
-	.owner	= THIS_MODULE,
-	.name	= "ctcm",
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "ctcm",
+	},
 	.ids	= ctcm_ids,
 	.probe	= ccwgroup_probe_ccwdev,
 	.remove	= ccwgroup_remove_ccwdev,
 };
 
 static struct ccwgroup_driver ctcm_group_driver = {
-	.owner       = THIS_MODULE,
-	.name        = CTC_DRIVER_NAME,
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= CTC_DRIVER_NAME,
+	},
 	.max_slaves  = 2,
 	.driver_id   = 0xC3E3C3D4,	/* CTCM */
 	.probe       = ctcm_probe_device,
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 30b2a82..7fbc4ad 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -2396,8 +2396,10 @@ static struct ccw_device_id lcs_ids[] = {
 MODULE_DEVICE_TABLE(ccw, lcs_ids);
 
 static struct ccw_driver lcs_ccw_driver = {
-	.owner	= THIS_MODULE,
-	.name	= "lcs",
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "lcs",
+	},
 	.ids	= lcs_ids,
 	.probe	= ccwgroup_probe_ccwdev,
 	.remove	= ccwgroup_remove_ccwdev,
@@ -2407,8 +2409,10 @@ static struct ccw_driver lcs_ccw_driver = {
  * LCS ccwgroup driver registration
  */
 static struct ccwgroup_driver lcs_group_driver = {
-	.owner       = THIS_MODULE,
-	.name        = "lcs",
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "lcs",
+	},
 	.max_slaves  = 2,
 	.driver_id   = 0xD3C3E2,
 	.probe       = lcs_probe_device,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 25eef304..10a3a3b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3902,7 +3902,9 @@ static struct ccw_device_id qeth_ids[] = {
 MODULE_DEVICE_TABLE(ccw, qeth_ids);
 
 static struct ccw_driver qeth_ccw_driver = {
-	.name = "qeth",
+	.driver = {
+		.name = "qeth",
+	},
 	.ids = qeth_ids,
 	.probe = ccwgroup_probe_ccwdev,
 	.remove = ccwgroup_remove_ccwdev,
@@ -4428,8 +4430,10 @@ static int qeth_core_restore(struct ccwgroup_device *gdev)
 }
 
 static struct ccwgroup_driver qeth_core_ccwgroup_driver = {
-	.owner = THIS_MODULE,
-	.name = "qeth",
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "qeth",
+	},
 	.driver_id = 0xD8C5E3C8,
 	.probe = qeth_core_probe_device,
 	.remove = qeth_core_remove_device,
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index 4f7852d..e8b7cee 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -251,8 +251,10 @@ static void zfcp_ccw_shutdown(struct ccw_device *cdev)
 }
 
 struct ccw_driver zfcp_ccw_driver = {
-	.owner       = THIS_MODULE,
-	.name        = "zfcp",
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "zfcp",
+	},
 	.ids         = zfcp_ccw_device_id,
 	.probe       = zfcp_ccw_probe,
 	.remove      = zfcp_ccw_remove,
