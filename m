Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0IJQY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:24:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab0IJQY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:24:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/17] Blackfin: Split the BF532 BFIN_*_FIO_FLAG() functions
	to their own header
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 10 Sep 2010 17:24:17 +0100
Message-ID: <20100910162417.20817.23180.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100910162407.20817.34359.stgit@warthog.procyon.org.uk>
References: <20100910162407.20817.34359.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the BF532 machine type BFIN_*_FIO_FLAG() functions to their own header
file to avoid circular #include problems as these functions require IRQ flag
handling, which requires asm/blackfin.h, which otherwise requires the header
file that defines these functions.

For good measure, also get rid of the inclusion of asm/blackfin.h from
mach/cdefBF532.h (which is circular) and defBF532.h (which is included by
asm/blackfin.h before including this header).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/blackfin/mach-bf533/boards/blackstamp.c      |    1 
 arch/blackfin/mach-bf533/boards/ip0x.c            |    1 
 arch/blackfin/mach-bf533/boards/stamp.c           |    1 
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h |   47 ------------------
 arch/blackfin/mach-bf533/include/mach/fio_flag.h  |   55 +++++++++++++++++++++
 5 files changed, 58 insertions(+), 47 deletions(-)
 create mode 100644 arch/blackfin/mach-bf533/include/mach/fio_flag.h

diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c b/arch/blackfin/mach-bf533/boards/blackstamp.c
index 842b4fa..84a06f6 100644
--- a/arch/blackfin/mach-bf533/boards/blackstamp.c
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -25,6 +25,7 @@
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
 #include <asm/dpmc.h>
+#include <mach/fio_flag.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
diff --git a/arch/blackfin/mach-bf533/boards/ip0x.c b/arch/blackfin/mach-bf533/boards/ip0x.c
index 7349970..b8474ca 100644
--- a/arch/blackfin/mach-bf533/boards/ip0x.c
+++ b/arch/blackfin/mach-bf533/boards/ip0x.c
@@ -22,6 +22,7 @@
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
+#include <mach/fio_flag.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index c457eaa..29c219e 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -24,6 +24,7 @@
 #include <asm/reboot.h>
 #include <asm/portmux.h>
 #include <asm/dpmc.h>
+#include <mach/fio_flag.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
diff --git a/arch/blackfin/mach-bf533/include/mach/cdefBF532.h b/arch/blackfin/mach-bf533/include/mach/cdefBF532.h
index 8edad6d..401e524 100644
--- a/arch/blackfin/mach-bf533/include/mach/cdefBF532.h
+++ b/arch/blackfin/mach-bf533/include/mach/cdefBF532.h
@@ -7,11 +7,6 @@
 #ifndef _CDEF_BF532_H
 #define _CDEF_BF532_H
 
-#include <asm/blackfin.h>
-
-/*include all Core registers and bit definitions*/
-#include "defBF532.h"
-
 /*include core specific register pointer definitions*/
 #include <asm/cdef_LPBlackfin.h>
 
@@ -655,46 +650,4 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-#if ANOMALY_05000311
-#define BFIN_WRITE_FIO_FLAG(name) \
-static inline void bfin_write_FIO_FLAG_##name(unsigned short val) \
-{ \
-	unsigned long flags; \
-	local_irq_save_hw(flags); \
-	bfin_write16(FIO_FLAG_##name, val); \
-	bfin_read_CHIPID(); \
-	local_irq_restore_hw(flags); \
-}
-BFIN_WRITE_FIO_FLAG(D)
-BFIN_WRITE_FIO_FLAG(C)
-BFIN_WRITE_FIO_FLAG(S)
-BFIN_WRITE_FIO_FLAG(T)
-
-#define BFIN_READ_FIO_FLAG(name) \
-static inline u16 bfin_read_FIO_FLAG_##name(void) \
-{ \
-	unsigned long flags; \
-	u16 ret; \
-	local_irq_save_hw(flags); \
-	ret = bfin_read16(FIO_FLAG_##name); \
-	bfin_read_CHIPID(); \
-	local_irq_restore_hw(flags); \
-	return ret; \
-}
-BFIN_READ_FIO_FLAG(D)
-BFIN_READ_FIO_FLAG(C)
-BFIN_READ_FIO_FLAG(S)
-BFIN_READ_FIO_FLAG(T)
-
-#else
-#define bfin_write_FIO_FLAG_D(val)           bfin_write16(FIO_FLAG_D, val)
-#define bfin_write_FIO_FLAG_C(val)           bfin_write16(FIO_FLAG_C, val)
-#define bfin_write_FIO_FLAG_S(val)           bfin_write16(FIO_FLAG_S, val)
-#define bfin_write_FIO_FLAG_T(val)           bfin_write16(FIO_FLAG_T, val)
-#define bfin_read_FIO_FLAG_T()               bfin_read16(FIO_FLAG_T)
-#define bfin_read_FIO_FLAG_C()               bfin_read16(FIO_FLAG_C)
-#define bfin_read_FIO_FLAG_S()               bfin_read16(FIO_FLAG_S)
-#define bfin_read_FIO_FLAG_D()               bfin_read16(FIO_FLAG_D)
-#endif
-
 #endif				/* _CDEF_BF532_H */
diff --git a/arch/blackfin/mach-bf533/include/mach/fio_flag.h b/arch/blackfin/mach-bf533/include/mach/fio_flag.h
new file mode 100644
index 0000000..b81905a
--- /dev/null
+++ b/arch/blackfin/mach-bf533/include/mach/fio_flag.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright 2005-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _MACH_FIO_FLAG_H
+#define _MACH_FIO_FLAG_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+#if ANOMALY_05000311
+#define BFIN_WRITE_FIO_FLAG(name) \
+static inline void bfin_write_FIO_FLAG_##name(unsigned short val) \
+{ \
+	unsigned long flags; \
+	local_irq_save_hw(flags); \
+	bfin_write16(FIO_FLAG_##name, val); \
+	bfin_read_CHIPID(); \
+	local_irq_restore_hw(flags); \
+}
+BFIN_WRITE_FIO_FLAG(D)
+BFIN_WRITE_FIO_FLAG(C)
+BFIN_WRITE_FIO_FLAG(S)
+BFIN_WRITE_FIO_FLAG(T)
+
+#define BFIN_READ_FIO_FLAG(name) \
+static inline u16 bfin_read_FIO_FLAG_##name(void) \
+{ \
+	unsigned long flags; \
+	u16 ret; \
+	local_irq_save_hw(flags); \
+	ret = bfin_read16(FIO_FLAG_##name); \
+	bfin_read_CHIPID(); \
+	local_irq_restore_hw(flags); \
+	return ret; \
+}
+BFIN_READ_FIO_FLAG(D)
+BFIN_READ_FIO_FLAG(C)
+BFIN_READ_FIO_FLAG(S)
+BFIN_READ_FIO_FLAG(T)
+
+#else
+#define bfin_write_FIO_FLAG_D(val)           bfin_write16(FIO_FLAG_D, val)
+#define bfin_write_FIO_FLAG_C(val)           bfin_write16(FIO_FLAG_C, val)
+#define bfin_write_FIO_FLAG_S(val)           bfin_write16(FIO_FLAG_S, val)
+#define bfin_write_FIO_FLAG_T(val)           bfin_write16(FIO_FLAG_T, val)
+#define bfin_read_FIO_FLAG_T()               bfin_read16(FIO_FLAG_T)
+#define bfin_read_FIO_FLAG_C()               bfin_read16(FIO_FLAG_C)
+#define bfin_read_FIO_FLAG_S()               bfin_read16(FIO_FLAG_S)
+#define bfin_read_FIO_FLAG_D()               bfin_read16(FIO_FLAG_D)
+#endif
+
+#endif /* _MACH_FIO_FLAG_H */

