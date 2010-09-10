Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0IJQY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab0IJQYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:24:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/17] Blackfin: Split PLL code from mach-specific cdef headers
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 10 Sep 2010 17:24:12 +0100
Message-ID: <20100910162412.20817.59907.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100910162407.20817.34359.stgit@warthog.procyon.org.uk>
References: <20100910162407.20817.34359.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the PLL control code from the Blackfin machine-specific cdef headers so
that the irqflags functions can be renamed without incurring a header loop.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 .../mach-bf518/include/mach/cdefBF51x_base.h       |   50 --------------
 arch/blackfin/mach-bf518/include/mach/pll.h        |   63 ++++++++++++++++++
 .../mach-bf527/include/mach/cdefBF52x_base.h       |   50 --------------
 arch/blackfin/mach-bf527/include/mach/pll.h        |   63 ++++++++++++++++++
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h  |   44 -------------
 arch/blackfin/mach-bf533/include/mach/pll.h        |   57 +++++++++++++++++
 arch/blackfin/mach-bf537/include/mach/cdefBF534.h  |   44 -------------
 arch/blackfin/mach-bf537/include/mach/pll.h        |   57 +++++++++++++++++
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  |   50 --------------
 arch/blackfin/mach-bf538/include/mach/pll.h        |   63 ++++++++++++++++++
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   56 ----------------
 arch/blackfin/mach-bf548/include/mach/pll.h        |   69 ++++++++++++++++++++
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |   50 --------------
 arch/blackfin/mach-bf561/include/mach/pll.h        |   63 ++++++++++++++++++
 drivers/net/bfin_mac.c                             |    1 
 15 files changed, 436 insertions(+), 344 deletions(-)
 create mode 100644 arch/blackfin/mach-bf518/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf527/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf537/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf548/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf561/include/mach/pll.h

diff --git a/arch/blackfin/mach-bf518/include/mach/cdefBF51x_base.h b/arch/blackfin/mach-bf518/include/mach/cdefBF51x_base.h
index e548e9d..29498e5 100644
--- a/arch/blackfin/mach-bf518/include/mach/cdefBF51x_base.h
+++ b/arch/blackfin/mach-bf518/include/mach/cdefBF51x_base.h
@@ -1058,54 +1058,4 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
 #endif /* _CDEF_BF52X_H */
diff --git a/arch/blackfin/mach-bf518/include/mach/pll.h b/arch/blackfin/mach-bf518/include/mach/pll.h
new file mode 100644
index 0000000..9c19a07
--- /dev/null
+++ b/arch/blackfin/mach-bf518/include/mach/pll.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf527/include/mach/cdefBF52x_base.h b/arch/blackfin/mach-bf527/include/mach/cdefBF52x_base.h
index 12f2ad4..11fb27b 100644
--- a/arch/blackfin/mach-bf527/include/mach/cdefBF52x_base.h
+++ b/arch/blackfin/mach-bf527/include/mach/cdefBF52x_base.h
@@ -1110,54 +1110,4 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
 #endif /* _CDEF_BF52X_H */
diff --git a/arch/blackfin/mach-bf527/include/mach/pll.h b/arch/blackfin/mach-bf527/include/mach/pll.h
new file mode 100644
index 0000000..a910522
--- /dev/null
+++ b/arch/blackfin/mach-bf527/include/mach/pll.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2007-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf533/include/mach/cdefBF532.h b/arch/blackfin/mach-bf533/include/mach/cdefBF532.h
index feb2392..8edad6d 100644
--- a/arch/blackfin/mach-bf533/include/mach/cdefBF532.h
+++ b/arch/blackfin/mach-bf533/include/mach/cdefBF532.h
@@ -697,48 +697,4 @@ BFIN_READ_FIO_FLAG(T)
 #define bfin_read_FIO_FLAG_D()               bfin_read16(FIO_FLAG_D)
 #endif
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr = bfin_read32(SIC_IWR);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR, IWR_ENABLE(0));
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr = bfin_read32(SIC_IWR);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR, IWR_ENABLE(0));
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
-}
-
 #endif				/* _CDEF_BF532_H */
diff --git a/arch/blackfin/mach-bf533/include/mach/pll.h b/arch/blackfin/mach-bf533/include/mach/pll.h
new file mode 100644
index 0000000..9a0c9a2
--- /dev/null
+++ b/arch/blackfin/mach-bf533/include/mach/pll.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright 2005-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr = bfin_read32(SIC_IWR);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR, IWR_ENABLE(0));
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR, iwr);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr = bfin_read32(SIC_IWR);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR, IWR_ENABLE(0));
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR, iwr);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf537/include/mach/cdefBF534.h b/arch/blackfin/mach-bf537/include/mach/cdefBF534.h
index 91825c9..fbeb35e 100644
--- a/arch/blackfin/mach-bf537/include/mach/cdefBF534.h
+++ b/arch/blackfin/mach-bf537/include/mach/cdefBF534.h
@@ -1750,48 +1750,4 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr = bfin_read32(SIC_IWR);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR, IWR_ENABLE(0));
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr = bfin_read32(SIC_IWR);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR, IWR_ENABLE(0));
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
-}
-
 #endif				/* _CDEF_BF534_H */
diff --git a/arch/blackfin/mach-bf537/include/mach/pll.h b/arch/blackfin/mach-bf537/include/mach/pll.h
new file mode 100644
index 0000000..9a0c9a2
--- /dev/null
+++ b/arch/blackfin/mach-bf537/include/mach/pll.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright 2005-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr = bfin_read32(SIC_IWR);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR, IWR_ENABLE(0));
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR, iwr);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr = bfin_read32(SIC_IWR);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR, IWR_ENABLE(0));
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR, iwr);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
index 66aa722..085b06b 100644
--- a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
+++ b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
@@ -2027,54 +2027,4 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
 #endif
diff --git a/arch/blackfin/mach-bf538/include/mach/pll.h b/arch/blackfin/mach-bf538/include/mach/pll.h
new file mode 100644
index 0000000..0e67452
--- /dev/null
+++ b/arch/blackfin/mach-bf538/include/mach/pll.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2008-2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf548/include/mach/cdefBF54x_base.h b/arch/blackfin/mach-bf548/include/mach/cdefBF54x_base.h
index ea3ec4e..0c16067d 100644
--- a/arch/blackfin/mach-bf548/include/mach/cdefBF54x_base.h
+++ b/arch/blackfin/mach-bf548/include/mach/cdefBF54x_base.h
@@ -2648,61 +2648,5 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1, iwr2;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	iwr2 = bfin_read32(SIC_IWR2);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-	bfin_write32(SIC_IWR2, 0);
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	bfin_write32(SIC_IWR2, iwr2);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1, iwr2;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SIC_IWR0);
-	iwr1 = bfin_read32(SIC_IWR1);
-	iwr2 = bfin_read32(SIC_IWR2);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
-	bfin_write32(SIC_IWR1, 0);
-	bfin_write32(SIC_IWR2, 0);
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SIC_IWR0, iwr0);
-	bfin_write32(SIC_IWR1, iwr1);
-	bfin_write32(SIC_IWR2, iwr2);
-	local_irq_restore_hw(flags);
-}
-
 #endif /* _CDEF_BF54X_H */
 
diff --git a/arch/blackfin/mach-bf548/include/mach/pll.h b/arch/blackfin/mach-bf548/include/mach/pll.h
new file mode 100644
index 0000000..777fee6
--- /dev/null
+++ b/arch/blackfin/mach-bf548/include/mach/pll.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright 2007-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1, iwr2;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	iwr2 = bfin_read32(SIC_IWR2);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+	bfin_write32(SIC_IWR2, 0);
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	bfin_write32(SIC_IWR2, iwr2);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1, iwr2;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SIC_IWR0);
+	iwr1 = bfin_read32(SIC_IWR1);
+	iwr2 = bfin_read32(SIC_IWR2);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SIC_IWR0, IWR_ENABLE(0));
+	bfin_write32(SIC_IWR1, 0);
+	bfin_write32(SIC_IWR2, 0);
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SIC_IWR0, iwr0);
+	bfin_write32(SIC_IWR1, iwr1);
+	bfin_write32(SIC_IWR2, iwr2);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf561/include/mach/cdefBF561.h b/arch/blackfin/mach-bf561/include/mach/cdefBF561.h
index 81ecdb7..cc0416a 100644
--- a/arch/blackfin/mach-bf561/include/mach/cdefBF561.h
+++ b/arch/blackfin/mach-bf561/include/mach/cdefBF561.h
@@ -1534,54 +1534,4 @@
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
-/* Writing to PLL_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_PLL_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_PLL_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SICA_IWR0);
-	iwr1 = bfin_read32(SICA_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SICA_IWR0, IWR_ENABLE(0));
-	bfin_write32(SICA_IWR1, 0);
-
-	bfin_write16(PLL_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SICA_IWR0, iwr0);
-	bfin_write32(SICA_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
-/* Writing to VR_CTL initiates a PLL relock sequence. */
-static __inline__ void bfin_write_VR_CTL(unsigned int val)
-{
-	unsigned long flags, iwr0, iwr1;
-
-	if (val == bfin_read_VR_CTL())
-		return;
-
-	local_irq_save_hw(flags);
-	/* Enable the PLL Wakeup bit in SIC IWR */
-	iwr0 = bfin_read32(SICA_IWR0);
-	iwr1 = bfin_read32(SICA_IWR1);
-	/* Only allow PPL Wakeup) */
-	bfin_write32(SICA_IWR0, IWR_ENABLE(0));
-	bfin_write32(SICA_IWR1, 0);
-
-	bfin_write16(VR_CTL, val);
-	SSYNC();
-	asm("IDLE;");
-
-	bfin_write32(SICA_IWR0, iwr0);
-	bfin_write32(SICA_IWR1, iwr1);
-	local_irq_restore_hw(flags);
-}
-
 #endif				/* _CDEF_BF561_H */
diff --git a/arch/blackfin/mach-bf561/include/mach/pll.h b/arch/blackfin/mach-bf561/include/mach/pll.h
new file mode 100644
index 0000000..4baa44f
--- /dev/null
+++ b/arch/blackfin/mach-bf561/include/mach/pll.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright 2005-2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef _MACH_PLL_H
+#define _MACH_PLL_H
+
+#include <asm/blackfin.h>
+#include <asm/irqflags.h>
+
+/* Writing to PLL_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_PLL_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_PLL_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SICA_IWR0);
+	iwr1 = bfin_read32(SICA_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SICA_IWR0, IWR_ENABLE(0));
+	bfin_write32(SICA_IWR1, 0);
+
+	bfin_write16(PLL_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SICA_IWR0, iwr0);
+	bfin_write32(SICA_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+/* Writing to VR_CTL initiates a PLL relock sequence. */
+static __inline__ void bfin_write_VR_CTL(unsigned int val)
+{
+	unsigned long flags, iwr0, iwr1;
+
+	if (val == bfin_read_VR_CTL())
+		return;
+
+	local_irq_save_hw(flags);
+	/* Enable the PLL Wakeup bit in SIC IWR */
+	iwr0 = bfin_read32(SICA_IWR0);
+	iwr1 = bfin_read32(SICA_IWR1);
+	/* Only allow PPL Wakeup) */
+	bfin_write32(SICA_IWR0, IWR_ENABLE(0));
+	bfin_write32(SICA_IWR1, 0);
+
+	bfin_write16(VR_CTL, val);
+	SSYNC();
+	asm("IDLE;");
+
+	bfin_write32(SICA_IWR0, iwr0);
+	bfin_write32(SICA_IWR1, iwr1);
+	local_irq_restore_hw(flags);
+}
+
+#endif /* _MACH_PLL_H */
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 012613f..03d0635 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -38,6 +38,7 @@
 #include <asm/blackfin.h>
 #include <asm/cacheflush.h>
 #include <asm/portmux.h>
+#include <mach/pll.h>
 
 #include "bfin_mac.h"
 

