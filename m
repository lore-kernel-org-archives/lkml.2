Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2EHW3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:29:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2EHW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:29:19 -0400
Date: Tue, 8 May 2012 15:29:08 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-c4845474a01f699966272536e8416222e3f2d2cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-20-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-20-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: flattened rm hierachy
Git-Commit-ID: c4845474a01f699966272536e8416222e3f2d2cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:29:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4845474a01f699966272536e8416222e3f2d2cb
Gitweb:     http://git.kernel.org/tip/c4845474a01f699966272536e8416222e3f2d2cb
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:42 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:45 -0700

x86, realmode: flattened rm hierachy

Simplified hierarchy under rm directory to a flat
directory because it is not anymore really justified
to have own directory for wakeup code. It only adds
more complexity.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-20-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/sleep.c                   |    2 +-
 arch/x86/realmode/rm/Makefile                  |   20 +++++++++-----
 arch/x86/realmode/rm/bioscall.S                |    1 +
 arch/x86/realmode/rm/copy.S                    |    1 +
 arch/x86/realmode/rm/regs.c                    |    1 +
 arch/x86/realmode/rm/video-bios.c              |    1 +
 arch/x86/realmode/rm/video-mode.c              |    1 +
 arch/x86/realmode/rm/video-vesa.c              |    1 +
 arch/x86/realmode/rm/video-vga.c               |    1 +
 arch/x86/realmode/rm/{wakeup => }/wakemain.c   |    0
 arch/x86/realmode/rm/{wakeup => }/wakeup.h     |    0
 arch/x86/realmode/rm/wakeup/.gitignore         |    3 --
 arch/x86/realmode/rm/wakeup/Makefile           |   33 ------------------------
 arch/x86/realmode/rm/wakeup/bioscall.S         |    1 -
 arch/x86/realmode/rm/wakeup/copy.S             |    1 -
 arch/x86/realmode/rm/wakeup/regs.c             |    1 -
 arch/x86/realmode/rm/wakeup/video-bios.c       |    1 -
 arch/x86/realmode/rm/wakeup/video-mode.c       |    1 -
 arch/x86/realmode/rm/wakeup/video-vesa.c       |    1 -
 arch/x86/realmode/rm/wakeup/video-vga.c        |    1 -
 arch/x86/realmode/rm/{wakeup => }/wakeup_asm.S |    2 +-
 21 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 6ca3f54..95bf99d 100644
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
diff --git a/arch/x86/realmode/rm/wakeup/wakemain.c b/arch/x86/realmode/rm/wakemain.c
similarity index 100%
rename from arch/x86/realmode/rm/wakeup/wakemain.c
rename to arch/x86/realmode/rm/wakemain.c
diff --git a/arch/x86/realmode/rm/wakeup/wakeup.h b/arch/x86/realmode/rm/wakeup.h
similarity index 100%
rename from arch/x86/realmode/rm/wakeup/wakeup.h
rename to arch/x86/realmode/rm/wakeup.h
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
diff --git a/arch/x86/realmode/rm/wakeup/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
similarity index 99%
rename from arch/x86/realmode/rm/wakeup/wakeup_asm.S
rename to arch/x86/realmode/rm/wakeup_asm.S
index f81c1cd..8a57c5a 100644
--- a/arch/x86/realmode/rm/wakeup/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -7,7 +7,7 @@
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
 #include <asm/processor-flags.h>
-#include "../realmode.h"
+#include "realmode.h"
 #include "wakeup.h"
 
 	.code16
