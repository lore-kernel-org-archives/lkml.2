Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2EHSZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:25:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:36688 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab2EHSYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:24:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637183"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH 19/23] x86, realmode: flattened rm hierachy
Date: Tue,  8 May 2012 21:22:42 +0300
Message-Id: <1336501366-28617-20-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplified hierarchy under rm directory to a flat
directory because it is not anymore really justified
to have own directory for wakeup code. It only adds
more complexity.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/kernel/acpi/sleep.c             |    2 +-
 arch/x86/realmode/rm/Makefile            |   20 ++--
 arch/x86/realmode/rm/bioscall.S          |    1 +
 arch/x86/realmode/rm/copy.S              |    1 +
 arch/x86/realmode/rm/regs.c              |    1 +
 arch/x86/realmode/rm/video-bios.c        |    1 +
 arch/x86/realmode/rm/video-mode.c        |    1 +
 arch/x86/realmode/rm/video-vesa.c        |    1 +
 arch/x86/realmode/rm/video-vga.c         |    1 +
 arch/x86/realmode/rm/wakemain.c          |   82 ++++++++++++++
 arch/x86/realmode/rm/wakeup.h            |   41 +++++++
 arch/x86/realmode/rm/wakeup/.gitignore   |    3 -
 arch/x86/realmode/rm/wakeup/Makefile     |   33 ------
 arch/x86/realmode/rm/wakeup/bioscall.S   |    1 -
 arch/x86/realmode/rm/wakeup/copy.S       |    1 -
 arch/x86/realmode/rm/wakeup/regs.c       |    1 -
 arch/x86/realmode/rm/wakeup/video-bios.c |    1 -
 arch/x86/realmode/rm/wakeup/video-mode.c |    1 -
 arch/x86/realmode/rm/wakeup/video-vesa.c |    1 -
 arch/x86/realmode/rm/wakeup/video-vga.c  |    1 -
 arch/x86/realmode/rm/wakeup/wakemain.c   |   82 --------------
 arch/x86/realmode/rm/wakeup/wakeup.h     |   41 -------
 arch/x86/realmode/rm/wakeup/wakeup_asm.S |  181 ------------------------------
 arch/x86/realmode/rm/wakeup_asm.S        |  181 ++++++++++++++++++++++++++++++
 24 files changed, 325 insertions(+), 355 deletions(-)
 create mode 100644 arch/x86/realmode/rm/bioscall.S
 create mode 100644 arch/x86/realmode/rm/copy.S
 create mode 100644 arch/x86/realmode/rm/regs.c
 create mode 100644 arch/x86/realmode/rm/video-bios.c
 create mode 100644 arch/x86/realmode/rm/video-mode.c
 create mode 100644 arch/x86/realmode/rm/video-vesa.c
 create mode 100644 arch/x86/realmode/rm/video-vga.c
 create mode 100644 arch/x86/realmode/rm/wakemain.c
 create mode 100644 arch/x86/realmode/rm/wakeup.h
 delete mode 100644 arch/x86/realmode/rm/wakeup/.gitignore
 delete mode 100644 arch/x86/realmode/rm/wakeup/Makefile
 delete mode 100644 arch/x86/realmode/rm/wakeup/bioscall.S
 delete mode 100644 arch/x86/realmode/rm/wakeup/copy.S
 delete mode 100644 arch/x86/realmode/rm/wakeup/regs.c
 delete mode 100644 arch/x86/realmode/rm/wakeup/video-bios.c
 delete mode 100644 arch/x86/realmode/rm/wakeup/video-mode.c
 delete mode 100644 arch/x86/realmode/rm/wakeup/video-vesa.c
 delete mode 100644 arch/x86/realmode/rm/wakeup/video-vga.c
 delete mode 100644 arch/x86/realmode/rm/wakeup/wakemain.c
 delete mode 100644 arch/x86/realmode/rm/wakeup/wakeup.h
 delete mode 100644 arch/x86/realmode/rm/wakeup/wakeup_asm.S
 create mode 100644 arch/x86/realmode/rm/wakeup_asm.S

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 5250475..1b8e5a0 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -16,7 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 
-#include "../../realmode/rm/wakeup/wakeup.h"
+#include "../../realmode/rm/wakeup.h"
 #include "sleep.h"
 
 unsigned long acpi_realmode_flags;
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index c2c27a4..fc8854b 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -7,21 +7,26 @@
 #
 #
 
-subdir- := wakeup
-
 always := realmode.bin
 
 realmode-y			+= header.o
 realmode-y			+= trampoline_$(BITS).o
 realmode-y			+= stack.o
 realmode-$(CONFIG_X86_32)	+= reboot_32.o
-realmode-$(CONFIG_ACPI_SLEEP)	+= wakeup/wakeup.o
+realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
+
+wakeup-objs	:= wakeup_asm.o wakemain.o video-mode.o
+wakeup-objs	+= copy.o bioscall.o regs.o
+# The link order of the video-*.o modules can matter.  In particular,
+# video-vga.o *must* be listed first, followed by video-vesa.o.
+# Hardware-specific drivers should follow in the order they should be
+# probed, and video-bios.o should typically be last.
+wakeup-objs	+= video-vga.o
+wakeup-objs	+= video-vesa.o
+wakeup-objs	+= video-bios.o
 
 targets	+= $(realmode-y)
 
-$(obj)/wakeup/wakeup.o: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/wakeup $@
-
 REALMODE_OBJS = $(addprefix $(obj)/,$(realmode-y))
 
 sed-pasyms := -n -r -e 's/^([0-9a-fA-F]+) [ABCDGRSTVW] (.+)$$/pa_\2 = \2;/p'
@@ -55,7 +60,8 @@ $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
+		   -I$(srctree)/arch/x86/boot \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
diff --git a/arch/x86/realmode/rm/bioscall.S b/arch/x86/realmode/rm/bioscall.S
new file mode 100644
index 0000000..16162d1
--- /dev/null
+++ b/arch/x86/realmode/rm/bioscall.S
@@ -0,0 +1 @@
+#include "../../boot/bioscall.S"
diff --git a/arch/x86/realmode/rm/copy.S b/arch/x86/realmode/rm/copy.S
new file mode 100644
index 0000000..b785e6f
--- /dev/null
+++ b/arch/x86/realmode/rm/copy.S
@@ -0,0 +1 @@
+#include "../../boot/copy.S"
diff --git a/arch/x86/realmode/rm/regs.c b/arch/x86/realmode/rm/regs.c
new file mode 100644
index 0000000..fbb15b9
--- /dev/null
+++ b/arch/x86/realmode/rm/regs.c
@@ -0,0 +1 @@
+#include "../../boot/regs.c"
diff --git a/arch/x86/realmode/rm/video-bios.c b/arch/x86/realmode/rm/video-bios.c
new file mode 100644
index 0000000..848b25a
--- /dev/null
+++ b/arch/x86/realmode/rm/video-bios.c
@@ -0,0 +1 @@
+#include "../../boot/video-bios.c"
diff --git a/arch/x86/realmode/rm/video-mode.c b/arch/x86/realmode/rm/video-mode.c
new file mode 100644
index 0000000..2a98b7e
--- /dev/null
+++ b/arch/x86/realmode/rm/video-mode.c
@@ -0,0 +1 @@
+#include "../../boot/video-mode.c"
diff --git a/arch/x86/realmode/rm/video-vesa.c b/arch/x86/realmode/rm/video-vesa.c
new file mode 100644
index 0000000..413eddd
--- /dev/null
+++ b/arch/x86/realmode/rm/video-vesa.c
@@ -0,0 +1 @@
+#include "../../boot/video-vesa.c"
diff --git a/arch/x86/realmode/rm/video-vga.c b/arch/x86/realmode/rm/video-vga.c
new file mode 100644
index 0000000..3085f5c
--- /dev/null
+++ b/arch/x86/realmode/rm/video-vga.c
@@ -0,0 +1 @@
+#include "../../boot/video-vga.c"
diff --git a/arch/x86/realmode/rm/wakemain.c b/arch/x86/realmode/rm/wakemain.c
new file mode 100644
index 0000000..91405d5
--- /dev/null
+++ b/arch/x86/realmode/rm/wakemain.c
@@ -0,0 +1,82 @@
+#include "wakeup.h"
+#include "boot.h"
+
+static void udelay(int loops)
+{
+	while (loops--)
+		io_delay();	/* Approximately 1 us */
+}
+
+static void beep(unsigned int hz)
+{
+	u8 enable;
+
+	if (!hz) {
+		enable = 0x00;		/* Turn off speaker */
+	} else {
+		u16 div = 1193181/hz;
+
+		outb(0xb6, 0x43);	/* Ctr 2, squarewave, load, binary */
+		io_delay();
+		outb(div, 0x42);	/* LSB of counter */
+		io_delay();
+		outb(div >> 8, 0x42);	/* MSB of counter */
+		io_delay();
+
+		enable = 0x03;		/* Turn on speaker */
+	}
+	inb(0x61);		/* Dummy read of System Control Port B */
+	io_delay();
+	outb(enable, 0x61);	/* Enable timer 2 output to speaker */
+	io_delay();
+}
+
+#define DOT_HZ		880
+#define DASH_HZ		587
+#define US_PER_DOT	125000
+
+/* Okay, this is totally silly, but it's kind of fun. */
+static void send_morse(const char *pattern)
+{
+	char s;
+
+	while ((s = *pattern++)) {
+		switch (s) {
+		case '.':
+			beep(DOT_HZ);
+			udelay(US_PER_DOT);
+			beep(0);
+			udelay(US_PER_DOT);
+			break;
+		case '-':
+			beep(DASH_HZ);
+			udelay(US_PER_DOT * 3);
+			beep(0);
+			udelay(US_PER_DOT);
+			break;
+		default:	/* Assume it's a space */
+			udelay(US_PER_DOT * 3);
+			break;
+		}
+	}
+}
+
+void main(void)
+{
+	/* Kill machine if structures are wrong */
+	if (wakeup_header.real_magic != 0x12345678)
+		while (1)
+			;
+
+	if (wakeup_header.realmode_flags & 4)
+		send_morse("...-");
+
+	if (wakeup_header.realmode_flags & 1)
+		asm volatile("lcallw   $0xc000,$3");
+
+	if (wakeup_header.realmode_flags & 2) {
+		/* Need to call BIOS */
+		probe_cards(0);
+		set_mode(wakeup_header.video_mode);
+	}
+}
diff --git a/arch/x86/realmode/rm/wakeup.h b/arch/x86/realmode/rm/wakeup.h
new file mode 100644
index 0000000..2dfaf06
--- /dev/null
+++ b/arch/x86/realmode/rm/wakeup.h
@@ -0,0 +1,41 @@
+/*
+ * Definitions for the wakeup data structure at the head of the
+ * wakeup code.
+ */
+
+#ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
+#define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+
+/* This must match data at wakeup.S */
+struct wakeup_header {
+	u16 video_mode;		/* Video mode number */
+	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
+	u16 pmode_cs;
+	u32 pmode_cr0;		/* Protected mode cr0 */
+	u32 pmode_cr3;		/* Protected mode cr3 */
+	u32 pmode_cr4;		/* Protected mode cr4 */
+	u32 pmode_efer_low;	/* Protected mode EFER */
+	u32 pmode_efer_high;
+	u64 pmode_gdt;
+	u32 pmode_misc_en_low;	/* Protected mode MISC_ENABLE */
+	u32 pmode_misc_en_high;
+	u32 pmode_behavior;	/* Wakeup routine behavior flags */
+	u32 realmode_flags;
+	u32 real_magic;
+	u32 signature;		/* To check we have correct structure */
+} __attribute__((__packed__));
+
+extern struct wakeup_header wakeup_header;
+#endif
+
+#define WAKEUP_HEADER_OFFSET	8
+#define WAKEUP_HEADER_SIGNATURE 0x51ee1111
+#define WAKEUP_END_SIGNATURE	0x65a22c82
+
+/* Wakeup behavior bits */
+#define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
+
+#endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/realmode/rm/wakeup/.gitignore b/arch/x86/realmode/rm/wakeup/.gitignore
deleted file mode 100644
index 58f1f48..0000000
--- a/arch/x86/realmode/rm/wakeup/.gitignore
+++ /dev/null
@@ -1,3 +0,0 @@
-wakeup.bin
-wakeup.elf
-wakeup.lds
diff --git a/arch/x86/realmode/rm/wakeup/Makefile b/arch/x86/realmode/rm/wakeup/Makefile
deleted file mode 100644
index 4c85332..0000000
--- a/arch/x86/realmode/rm/wakeup/Makefile
+++ /dev/null
@@ -1,33 +0,0 @@
-#
-# arch/x86/kernel/acpi/realmode/Makefile
-#
-# This file is subject to the terms and conditions of the GNU General Public
-# License.  See the file "COPYING" in the main directory of this archive
-# for more details.
-#
-
-always		:= wakeup.o
-
-wakeup-y	+= wakeup_asm.o wakemain.o video-mode.o
-wakeup-y	+= copy.o bioscall.o regs.o
-
-# The link order of the video-*.o modules can matter.  In particular,
-# video-vga.o *must* be listed first, followed by video-vesa.o.
-# Hardware-specific drivers should follow in the order they should be
-# probed, and video-bios.o should typically be last.
-wakeup-y	+= video-vga.o
-wakeup-y	+= video-vesa.o
-wakeup-y	+= video-bios.o
-
-targets		+= $(wakeup-y)
-
-WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
-
-LDFLAGS_wakeup.o := -m elf_i386 -r
-$(obj)/wakeup.o: $(WAKEUP_OBJS) FORCE
-	$(call if_changed,ld)
-
-bootsrc := $(src)/../../../boot
-
-ccflags-y += -D_WAKEUP -I$(srctree)/$(bootsrc)
-asflags-y += -D_WAKEUP -I$(srctree)/$(bootsrc)
diff --git a/arch/x86/realmode/rm/wakeup/bioscall.S b/arch/x86/realmode/rm/wakeup/bioscall.S
deleted file mode 100644
index f51eb0b..0000000
--- a/arch/x86/realmode/rm/wakeup/bioscall.S
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/bioscall.S"
diff --git a/arch/x86/realmode/rm/wakeup/copy.S b/arch/x86/realmode/rm/wakeup/copy.S
deleted file mode 100644
index dc59ebe..0000000
--- a/arch/x86/realmode/rm/wakeup/copy.S
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/copy.S"
diff --git a/arch/x86/realmode/rm/wakeup/regs.c b/arch/x86/realmode/rm/wakeup/regs.c
deleted file mode 100644
index 6206033..0000000
--- a/arch/x86/realmode/rm/wakeup/regs.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/regs.c"
diff --git a/arch/x86/realmode/rm/wakeup/video-bios.c b/arch/x86/realmode/rm/wakeup/video-bios.c
deleted file mode 100644
index 7deabc1..0000000
--- a/arch/x86/realmode/rm/wakeup/video-bios.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-bios.c"
diff --git a/arch/x86/realmode/rm/wakeup/video-mode.c b/arch/x86/realmode/rm/wakeup/video-mode.c
deleted file mode 100644
index 328ad20..0000000
--- a/arch/x86/realmode/rm/wakeup/video-mode.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-mode.c"
diff --git a/arch/x86/realmode/rm/wakeup/video-vesa.c b/arch/x86/realmode/rm/wakeup/video-vesa.c
deleted file mode 100644
index 9dbb967..0000000
--- a/arch/x86/realmode/rm/wakeup/video-vesa.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-vesa.c"
diff --git a/arch/x86/realmode/rm/wakeup/video-vga.c b/arch/x86/realmode/rm/wakeup/video-vga.c
deleted file mode 100644
index bcc8125..0000000
--- a/arch/x86/realmode/rm/wakeup/video-vga.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../boot/video-vga.c"
diff --git a/arch/x86/realmode/rm/wakeup/wakemain.c b/arch/x86/realmode/rm/wakeup/wakemain.c
deleted file mode 100644
index 91405d5..0000000
--- a/arch/x86/realmode/rm/wakeup/wakemain.c
+++ /dev/null
@@ -1,82 +0,0 @@
-#include "wakeup.h"
-#include "boot.h"
-
-static void udelay(int loops)
-{
-	while (loops--)
-		io_delay();	/* Approximately 1 us */
-}
-
-static void beep(unsigned int hz)
-{
-	u8 enable;
-
-	if (!hz) {
-		enable = 0x00;		/* Turn off speaker */
-	} else {
-		u16 div = 1193181/hz;
-
-		outb(0xb6, 0x43);	/* Ctr 2, squarewave, load, binary */
-		io_delay();
-		outb(div, 0x42);	/* LSB of counter */
-		io_delay();
-		outb(div >> 8, 0x42);	/* MSB of counter */
-		io_delay();
-
-		enable = 0x03;		/* Turn on speaker */
-	}
-	inb(0x61);		/* Dummy read of System Control Port B */
-	io_delay();
-	outb(enable, 0x61);	/* Enable timer 2 output to speaker */
-	io_delay();
-}
-
-#define DOT_HZ		880
-#define DASH_HZ		587
-#define US_PER_DOT	125000
-
-/* Okay, this is totally silly, but it's kind of fun. */
-static void send_morse(const char *pattern)
-{
-	char s;
-
-	while ((s = *pattern++)) {
-		switch (s) {
-		case '.':
-			beep(DOT_HZ);
-			udelay(US_PER_DOT);
-			beep(0);
-			udelay(US_PER_DOT);
-			break;
-		case '-':
-			beep(DASH_HZ);
-			udelay(US_PER_DOT * 3);
-			beep(0);
-			udelay(US_PER_DOT);
-			break;
-		default:	/* Assume it's a space */
-			udelay(US_PER_DOT * 3);
-			break;
-		}
-	}
-}
-
-void main(void)
-{
-	/* Kill machine if structures are wrong */
-	if (wakeup_header.real_magic != 0x12345678)
-		while (1)
-			;
-
-	if (wakeup_header.realmode_flags & 4)
-		send_morse("...-");
-
-	if (wakeup_header.realmode_flags & 1)
-		asm volatile("lcallw   $0xc000,$3");
-
-	if (wakeup_header.realmode_flags & 2) {
-		/* Need to call BIOS */
-		probe_cards(0);
-		set_mode(wakeup_header.video_mode);
-	}
-}
diff --git a/arch/x86/realmode/rm/wakeup/wakeup.h b/arch/x86/realmode/rm/wakeup/wakeup.h
deleted file mode 100644
index 2dfaf06..0000000
--- a/arch/x86/realmode/rm/wakeup/wakeup.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Definitions for the wakeup data structure at the head of the
- * wakeup code.
- */
-
-#ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
-#define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
-
-#ifndef __ASSEMBLY__
-#include <linux/types.h>
-
-/* This must match data at wakeup.S */
-struct wakeup_header {
-	u16 video_mode;		/* Video mode number */
-	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
-	u16 pmode_cs;
-	u32 pmode_cr0;		/* Protected mode cr0 */
-	u32 pmode_cr3;		/* Protected mode cr3 */
-	u32 pmode_cr4;		/* Protected mode cr4 */
-	u32 pmode_efer_low;	/* Protected mode EFER */
-	u32 pmode_efer_high;
-	u64 pmode_gdt;
-	u32 pmode_misc_en_low;	/* Protected mode MISC_ENABLE */
-	u32 pmode_misc_en_high;
-	u32 pmode_behavior;	/* Wakeup routine behavior flags */
-	u32 realmode_flags;
-	u32 real_magic;
-	u32 signature;		/* To check we have correct structure */
-} __attribute__((__packed__));
-
-extern struct wakeup_header wakeup_header;
-#endif
-
-#define WAKEUP_HEADER_OFFSET	8
-#define WAKEUP_HEADER_SIGNATURE 0x51ee1111
-#define WAKEUP_END_SIGNATURE	0x65a22c82
-
-/* Wakeup behavior bits */
-#define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
-
-#endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/realmode/rm/wakeup/wakeup_asm.S b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
deleted file mode 100644
index f81c1cd..0000000
--- a/arch/x86/realmode/rm/wakeup/wakeup_asm.S
+++ /dev/null
@@ -1,181 +0,0 @@
-/*
- * ACPI wakeup real mode startup stub
- */
-#include <linux/linkage.h>
-#include <asm/segment.h>
-#include <asm/msr-index.h>
-#include <asm/page_types.h>
-#include <asm/pgtable_types.h>
-#include <asm/processor-flags.h>
-#include "../realmode.h"
-#include "wakeup.h"
-
-	.code16
-
-/* This should match the structure in wakeup.h */
-	.section ".data", "aw"
-
-	.balign	16
-GLOBAL(wakeup_header)
-	video_mode:	.short	0	/* Video mode number */
-	pmode_entry:	.long	0
-	pmode_cs:	.short	__KERNEL_CS
-	pmode_cr0:	.long	0	/* Saved %cr0 */
-	pmode_cr3:	.long	0	/* Saved %cr3 */
-	pmode_cr4:	.long	0	/* Saved %cr4 */
-	pmode_efer:	.quad	0	/* Saved EFER */
-	pmode_gdt:	.quad	0
-	pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
-	pmode_behavior:	.long	0	/* Wakeup behavior flags */
-	realmode_flags:	.long	0
-	real_magic:	.long	0
-	signature:	.long	WAKEUP_HEADER_SIGNATURE
-END(wakeup_header)
-
-	.text
-	.code16
-
-	.balign	16
-ENTRY(wakeup_start)
-	cli
-	cld
-
-	LJMPW_RM(3f)
-3:
-	/* Apparently some dimwit BIOS programmers don't know how to
-	   program a PM to RM transition, and we might end up here with
-	   junk in the data segment descriptor registers.  The only way
-	   to repair that is to go into PM and fix it ourselves... */
-	movw	$16, %cx
-	lgdtl	%cs:wakeup_gdt
-	movl	%cr0, %eax
-	orb	$X86_CR0_PE, %al
-	movl	%eax, %cr0
-	ljmpw	$8, $2f
-2:
-	movw	%cx, %ds
-	movw	%cx, %es
-	movw	%cx, %ss
-	movw	%cx, %fs
-	movw	%cx, %gs
-
-	andb	$~X86_CR0_PE, %al
-	movl	%eax, %cr0
-	LJMPW_RM(3f)
-3:
-	/* Set up segments */
-	movw	%cs, %ax
-	movw	%ax, %ss
-	movl	$rm_stack_end, %esp
-	movw	%ax, %ds
-	movw	%ax, %es
-	movw	%ax, %fs
-	movw	%ax, %gs
-
-	lidtl	wakeup_idt
-
-	/* Clear the EFLAGS */
-	pushl	$0
-	popfl
-
-	/* Check header signature... */
-	movl	signature, %eax
-	cmpl	$WAKEUP_HEADER_SIGNATURE, %eax
-	jne	bogus_real_magic
-
-	/* Check we really have everything... */
-	movl	end_signature, %eax
-	cmpl	$WAKEUP_END_SIGNATURE, %eax
-	jne	bogus_real_magic
-
-	/* Call the C code */
-	calll	main
-
-	/* Restore MISC_ENABLE before entering protected mode, in case
-	   BIOS decided to clear XD_DISABLE during S3. */
-	movl	pmode_behavior, %eax
-	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
-	jnc	1f
-
-	movl	pmode_misc_en, %eax
-	movl	pmode_misc_en + 4, %edx
-	movl	$MSR_IA32_MISC_ENABLE, %ecx
-	wrmsr
-1:
-
-	/* Do any other stuff... */
-
-#ifndef CONFIG_64BIT
-	/* This could also be done in C code... */
-	movl	pmode_cr3, %eax
-	movl	%eax, %cr3
-
-	movl	pmode_cr4, %ecx
-	jecxz	1f
-	movl	%ecx, %cr4
-1:
-	movl	pmode_efer, %eax
-	movl	pmode_efer + 4, %edx
-	movl	%eax, %ecx
-	orl	%edx, %ecx
-	jz	1f
-	movl	$MSR_EFER, %ecx
-	wrmsr
-1:
-
-	lgdtl	pmode_gdt
-
-	/* This really couldn't... */
-	movl	pmode_entry, %eax
-	movl	pmode_cr0, %ecx
-	movl	%ecx, %cr0
-	ljmpl	$__KERNEL_CS, $pa_startup_32
-	/* -> jmp *%eax in trampoline_32.S */
-#else
-	jmp	trampoline_data
-#endif
-
-bogus_real_magic:
-1:
-	hlt
-	jmp	1b
-
-	.section ".rodata","a"
-
-	/*
-	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
-	 * that is, with limits set to 4 GB.  At least the Lenovo
-	 * Thinkpad X61 is known to need this for the video BIOS
-	 * initialization quirk to work; this is likely to also
-	 * be the case for other laptops or integrated video devices.
-	 */
-
-	.balign	16
-GLOBAL(wakeup_gdt)
-	.word	3*8-1		/* Self-descriptor */
-	.long	pa_wakeup_gdt
-	.word	0
-
-	.word	0xffff		/* 16-bit code segment @ real_mode_base */
-	.long	0x9b000000 + pa_real_mode_base
-	.word	0x008f		/* big real mode */
-
-	.word	0xffff		/* 16-bit data segment @ real_mode_base */
-	.long	0x93000000 + pa_real_mode_base
-	.word	0x008f		/* big real mode */
-END(wakeup_gdt)
-
-	.section ".rodata","a"
-	.balign	8
-
-	/* This is the standard real-mode IDT */
-	.balign	16
-GLOBAL(wakeup_idt)
-	.word	0xffff		/* limit */
-	.long	0		/* address */
-	.word	0
-END(wakeup_idt)
-
-	.section ".signature","a"
-end_signature:
-	.long	WAKEUP_END_SIGNATURE
diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
new file mode 100644
index 0000000..8a57c5a
--- /dev/null
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -0,0 +1,181 @@
+/*
+ * ACPI wakeup real mode startup stub
+ */
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/msr-index.h>
+#include <asm/page_types.h>
+#include <asm/pgtable_types.h>
+#include <asm/processor-flags.h>
+#include "realmode.h"
+#include "wakeup.h"
+
+	.code16
+
+/* This should match the structure in wakeup.h */
+	.section ".data", "aw"
+
+	.balign	16
+GLOBAL(wakeup_header)
+	video_mode:	.short	0	/* Video mode number */
+	pmode_entry:	.long	0
+	pmode_cs:	.short	__KERNEL_CS
+	pmode_cr0:	.long	0	/* Saved %cr0 */
+	pmode_cr3:	.long	0	/* Saved %cr3 */
+	pmode_cr4:	.long	0	/* Saved %cr4 */
+	pmode_efer:	.quad	0	/* Saved EFER */
+	pmode_gdt:	.quad	0
+	pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
+	pmode_behavior:	.long	0	/* Wakeup behavior flags */
+	realmode_flags:	.long	0
+	real_magic:	.long	0
+	signature:	.long	WAKEUP_HEADER_SIGNATURE
+END(wakeup_header)
+
+	.text
+	.code16
+
+	.balign	16
+ENTRY(wakeup_start)
+	cli
+	cld
+
+	LJMPW_RM(3f)
+3:
+	/* Apparently some dimwit BIOS programmers don't know how to
+	   program a PM to RM transition, and we might end up here with
+	   junk in the data segment descriptor registers.  The only way
+	   to repair that is to go into PM and fix it ourselves... */
+	movw	$16, %cx
+	lgdtl	%cs:wakeup_gdt
+	movl	%cr0, %eax
+	orb	$X86_CR0_PE, %al
+	movl	%eax, %cr0
+	ljmpw	$8, $2f
+2:
+	movw	%cx, %ds
+	movw	%cx, %es
+	movw	%cx, %ss
+	movw	%cx, %fs
+	movw	%cx, %gs
+
+	andb	$~X86_CR0_PE, %al
+	movl	%eax, %cr0
+	LJMPW_RM(3f)
+3:
+	/* Set up segments */
+	movw	%cs, %ax
+	movw	%ax, %ss
+	movl	$rm_stack_end, %esp
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %fs
+	movw	%ax, %gs
+
+	lidtl	wakeup_idt
+
+	/* Clear the EFLAGS */
+	pushl	$0
+	popfl
+
+	/* Check header signature... */
+	movl	signature, %eax
+	cmpl	$WAKEUP_HEADER_SIGNATURE, %eax
+	jne	bogus_real_magic
+
+	/* Check we really have everything... */
+	movl	end_signature, %eax
+	cmpl	$WAKEUP_END_SIGNATURE, %eax
+	jne	bogus_real_magic
+
+	/* Call the C code */
+	calll	main
+
+	/* Restore MISC_ENABLE before entering protected mode, in case
+	   BIOS decided to clear XD_DISABLE during S3. */
+	movl	pmode_behavior, %eax
+	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
+	jnc	1f
+
+	movl	pmode_misc_en, %eax
+	movl	pmode_misc_en + 4, %edx
+	movl	$MSR_IA32_MISC_ENABLE, %ecx
+	wrmsr
+1:
+
+	/* Do any other stuff... */
+
+#ifndef CONFIG_64BIT
+	/* This could also be done in C code... */
+	movl	pmode_cr3, %eax
+	movl	%eax, %cr3
+
+	movl	pmode_cr4, %ecx
+	jecxz	1f
+	movl	%ecx, %cr4
+1:
+	movl	pmode_efer, %eax
+	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
+	movl	$MSR_EFER, %ecx
+	wrmsr
+1:
+
+	lgdtl	pmode_gdt
+
+	/* This really couldn't... */
+	movl	pmode_entry, %eax
+	movl	pmode_cr0, %ecx
+	movl	%ecx, %cr0
+	ljmpl	$__KERNEL_CS, $pa_startup_32
+	/* -> jmp *%eax in trampoline_32.S */
+#else
+	jmp	trampoline_data
+#endif
+
+bogus_real_magic:
+1:
+	hlt
+	jmp	1b
+
+	.section ".rodata","a"
+
+	/*
+	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
+	 * that is, with limits set to 4 GB.  At least the Lenovo
+	 * Thinkpad X61 is known to need this for the video BIOS
+	 * initialization quirk to work; this is likely to also
+	 * be the case for other laptops or integrated video devices.
+	 */
+
+	.balign	16
+GLOBAL(wakeup_gdt)
+	.word	3*8-1		/* Self-descriptor */
+	.long	pa_wakeup_gdt
+	.word	0
+
+	.word	0xffff		/* 16-bit code segment @ real_mode_base */
+	.long	0x9b000000 + pa_real_mode_base
+	.word	0x008f		/* big real mode */
+
+	.word	0xffff		/* 16-bit data segment @ real_mode_base */
+	.long	0x93000000 + pa_real_mode_base
+	.word	0x008f		/* big real mode */
+END(wakeup_gdt)
+
+	.section ".rodata","a"
+	.balign	8
+
+	/* This is the standard real-mode IDT */
+	.balign	16
+GLOBAL(wakeup_idt)
+	.word	0xffff		/* limit */
+	.long	0		/* address */
+	.word	0
+END(wakeup_idt)
+
+	.section ".signature","a"
+end_signature:
+	.long	WAKEUP_END_SIGNATURE
-- 
1.7.9.5

