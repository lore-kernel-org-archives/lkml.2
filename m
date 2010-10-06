Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0JFSGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab0JFSGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/8] arm: trivial changes to make headers more generic
Date: Wed,  6 Oct 2010 20:06:14 +0200
Message-Id: <1286388380-20646-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ln5dksEEtaDlHD9Cvl51oHuwrFsP0Bzz9ZaYXSNK0cd
 2b0YhCsBlLJJTne7iwFXztcs4M+VRYEATgkUaEadZ4bolz7r71
 IyR6t9NtnOE+vjWBdBWuE7Zpzb9yMsy7vtjf+KsmbQdZmB4lEh
 pwphMGebD48lZneq/V/PzmdEQmrQll+1/2IN03xBYcY5FDK2jD
 HvmWzbjfIrHaFv2fCJy0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of header files differ from the asm-generic
version only in whitespace, comments or other minor
things. Make them identical to the generic version
as a preparation to actually using the implementation
from include/asm-generic.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/param.h    |   19 +++++++++++--------
 arch/arm/include/asm/parport.h  |   19 ++++++++++++++++---
 arch/arm/include/asm/serial.h   |    9 ++++++++-
 arch/arm/include/asm/socket.h   |   12 +++++++-----
 arch/arm/include/asm/sockios.h  |    2 +-
 arch/arm/include/asm/termbits.h |   11 ++++++-----
 arch/arm/include/asm/timex.h    |   12 ++++++++++--
 arch/arm/include/asm/types.h    |   29 ++++++++++++++++++++---------
 8 files changed, 79 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/param.h b/arch/arm/include/asm/param.h
index 8b24bf9..eaca062 100644
--- a/arch/arm/include/asm/param.h
+++ b/arch/arm/include/asm/param.h
@@ -10,22 +10,25 @@
 #ifndef __ASM_PARAM_H
 #define __ASM_PARAM_H
 
+
 #ifdef __KERNEL__
 # define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-# define USER_HZ	100		/* User interfaces are in "ticks" */
-# define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
-#else
-# define HZ		100
+# define USER_HZ	100		/* some user interfaces are */
+# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
+#endif
+
+#ifndef HZ
+#define HZ 100
 #endif
 
+#ifndef EXEC_PAGESIZE
 #define EXEC_PAGESIZE	4096
+#endif
 
 #ifndef NOGROUP
-#define NOGROUP         (-1)
+#define NOGROUP		(-1)
 #endif
 
-/* max length of hostname */
-#define MAXHOSTNAMELEN  64
+#define MAXHOSTNAMELEN	64	/* max length of hostname */
 
 #endif
-
diff --git a/arch/arm/include/asm/parport.h b/arch/arm/include/asm/parport.h
index 26e94b0..b4c19a8 100644
--- a/arch/arm/include/asm/parport.h
+++ b/arch/arm/include/asm/parport.h
@@ -9,10 +9,23 @@
 #ifndef __ASMARM_PARPORT_H
 #define __ASMARM_PARPORT_H
 
-static int __devinit parport_pc_find_isa_ports (int autoirq, int autodma);
-static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
+/*
+ * An ISA bus may have i8255 parallel ports at well-known
+ * locations in the I/O space, which are scanned by
+ * parport_pc_find_isa_ports.
+ *
+ * Without ISA support, the driver will only attach
+ * to devices on the PCI bus.
+ */
+
+static int __devinit parport_pc_find_isa_ports(int autoirq, int autodma);
+static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
 {
-	return parport_pc_find_isa_ports (autoirq, autodma);
+#ifdef CONFIG_ISA
+	return parport_pc_find_isa_ports(autoirq, autodma);
+#else
+	return 0;
+#endif
 }
 
 #endif /* !(_ASMARM_PARPORT_H) */
diff --git a/arch/arm/include/asm/serial.h b/arch/arm/include/asm/serial.h
index ebb0490..560f625 100644
--- a/arch/arm/include/asm/serial.h
+++ b/arch/arm/include/asm/serial.h
@@ -14,6 +14,13 @@
 #ifndef __ASM_SERIAL_H
 #define __ASM_SERIAL_H
 
-#define BASE_BAUD	(1843200 / 16)
+/*
+ * This should not be an architecture specific #define, oh well.
+ *
+ * Traditionally, it just describes i8250 and related serial ports
+ * that have this clock rate.
+ */
+
+#define BASE_BAUD (1843200 / 16)
 
 #endif
diff --git a/arch/arm/include/asm/socket.h b/arch/arm/include/asm/socket.h
index 90ffd04..5a0fbcc 100644
--- a/arch/arm/include/asm/socket.h
+++ b/arch/arm/include/asm/socket.h
@@ -23,25 +23,28 @@
 #define SO_LINGER	13
 #define SO_BSDCOMPAT	14
 /* To add :#define SO_REUSEPORT 15 */
+
+#ifndef SO_PASSCRED /* powerpc only differs in these */
 #define SO_PASSCRED	16
 #define SO_PEERCRED	17
 #define SO_RCVLOWAT	18
 #define SO_SNDLOWAT	19
 #define SO_RCVTIMEO	20
 #define SO_SNDTIMEO	21
+#endif
 
 /* Security levels - as per NRL IPv6 - don't actually do anything */
 #define SO_SECURITY_AUTHENTICATION		22
 #define SO_SECURITY_ENCRYPTION_TRANSPORT	23
 #define SO_SECURITY_ENCRYPTION_NETWORK		24
 
-#define SO_BINDTODEVICE 25
+#define SO_BINDTODEVICE	25
 
 /* Socket filtering */
-#define SO_ATTACH_FILTER        26
-#define SO_DETACH_FILTER        27
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
 
-#define SO_PEERNAME             28
+#define SO_PEERNAME		28
 #define SO_TIMESTAMP		29
 #define SCM_TIMESTAMP		SO_TIMESTAMP
 
@@ -61,5 +64,4 @@
 #define SO_DOMAIN		39
 
 #define SO_RXQ_OVFL             40
-
 #endif /* _ASM_SOCKET_H */
diff --git a/arch/arm/include/asm/sockios.h b/arch/arm/include/asm/sockios.h
index a2588a2..42b3d72 100644
--- a/arch/arm/include/asm/sockios.h
+++ b/arch/arm/include/asm/sockios.h
@@ -2,7 +2,7 @@
 #define __ARCH_ARM_SOCKIOS_H
 
 /* Socket-level I/O control calls. */
-#define FIOSETOWN 	0x8901
+#define FIOSETOWN	0x8901
 #define SIOCSPGRP	0x8902
 #define FIOGETOWN	0x8903
 #define SIOCGPGRP	0x8904
diff --git a/arch/arm/include/asm/termbits.h b/arch/arm/include/asm/termbits.h
index 704135d..b2e61b9 100644
--- a/arch/arm/include/asm/termbits.h
+++ b/arch/arm/include/asm/termbits.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_ARM_TERMBITS_H
 #define __ASM_ARM_TERMBITS_H
 
+#include <linux/posix_types.h>
+
 typedef unsigned char	cc_t;
 typedef unsigned int	speed_t;
 typedef unsigned int	tcflag_t;
@@ -37,7 +39,6 @@ struct ktermios {
 	speed_t c_ospeed;		/* output speed */
 };
 
-
 /* c_cc characters */
 #define VINTR 0
 #define VQUIT 1
@@ -155,11 +156,11 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000		/* input baud rate */
-#define CMSPAR    010000000000		/* mark or space (stick) parity */
-#define CRTSCTS	  020000000000		/* flow control */
+#define CIBAUD	  002003600000	/* input baud rate */
+#define CMSPAR	  010000000000	/* mark or space (stick) parity */
+#define CRTSCTS	  020000000000	/* flow control */
 
-#define IBSHIFT	   16
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
 
 /* c_lflag bits */
 #define ISIG	0000001
diff --git a/arch/arm/include/asm/timex.h b/arch/arm/include/asm/timex.h
index 3be8de3..55a01f1 100644
--- a/arch/arm/include/asm/timex.h
+++ b/arch/arm/include/asm/timex.h
@@ -15,10 +15,18 @@
 #include <mach/timex.h>
 
 typedef unsigned long cycles_t;
-
-static inline cycles_t get_cycles (void)
+#ifndef get_cycles
+static inline cycles_t get_cycles(void)
 {
 	return 0;
 }
+#endif
+
+/*
+ * Architectures are encouraged to implement read_current_timer
+ * and define this in order to avoid the expensive delay loop
+ * calibration during boot.
+ */
+#undef ARCH_HAS_READ_CURRENT_TIMER
 
 #endif
diff --git a/arch/arm/include/asm/types.h b/arch/arm/include/asm/types.h
index 345df01..b7389db 100644
--- a/arch/arm/include/asm/types.h
+++ b/arch/arm/include/asm/types.h
@@ -1,6 +1,9 @@
 #ifndef __ASM_ARM_TYPES_H
 #define __ASM_ARM_TYPES_H
-
+/*
+ * int-ll64 is used practically everywhere now,
+ * so use it as a reasonable default.
+ */
 #include <asm-generic/int-ll64.h>
 
 #ifndef __ASSEMBLY__
@@ -13,19 +16,27 @@ typedef unsigned short umode_t;
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
-#define BITS_PER_LONG 32
-
 #ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
+/*
+ * DMA addresses may be very different from physical addresses
+ * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
+ * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
+ * physical addresses.
+ * This default defines dma_addr_t to have the same size as
+ * phys_addr_t, which is the most common way.
+ * Do not define the dma64_addr_t type, which never really
+ * worked.
+ */
+#ifndef dma_addr_t
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+typedef u64 dma_addr_t;
+#else
 typedef u32 dma_addr_t;
-typedef u32 dma64_addr_t;
+#endif /* CONFIG_PHYS_ADDR_T_64BIT */
+#endif /* dma_addr_t */
 
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
 
 #endif
-
-- 
1.7.1

