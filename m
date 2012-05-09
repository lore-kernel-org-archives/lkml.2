Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab2EIJCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:02:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40592 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900Ab2EIJCB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:2>);
	Wed, 9 May 2012 05:02:01 -0400
Message-Id: <4FAA4BBE020000780008270E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 09:49:34 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Michal Marek" <mmarek@suse.cz>
Cc: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5, resend] kbuild: move some .pci_fixup_* sections
 into .init
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM.

While generally section mismatch checking is being turned on by this
patch for all of .pci_fixup_*, for .pci_fixup_header it is being
suppressed for the moment as it caused way too much fallout.
Theoretically all respective handlers must get their __init/__devinit
removed, as this gets processed from a non-__init, non-__devinit
function.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 include/asm-generic/vmlinux.lds.h |   45 ++++++++++++++++++++------------------
 scripts/mod/modpost.c             |   11 +++++----
 2 files changed, 31 insertions(+), 25 deletions(-)

--- 3.4-rc6/include/asm-generic/vmlinux.lds.h
+++ 3.4-rc6-pci-fixup-sections/include/asm-generic/vmlinux.lds.h
@@ -98,6 +98,19 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#define PCI_FIXUPS(what)				\
+	VMLINUX_SYMBOL(__start_pci_fixups_##what) = .;	\
+	*(.pci_fixup_##what)				\
+	VMLINUX_SYMBOL(__end_pci_fixups_##what) = .;
+
+#ifdef CONFIG_PM
+#define PCI_FIXUPS_PM_KEEP PCI_FIXUPS
+#define PCI_FIXUPS_PM_DISCARD(what)
+#else
+#define PCI_FIXUPS_PM_KEEP(what)
+#define PCI_FIXUPS_PM_DISCARD PCI_FIXUPS
+#endif
+
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 #define MCOUNT_REC()	. = ALIGN(8);				\
 			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
@@ -234,27 +247,12 @@
 									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
-		*(.pci_fixup_early)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_header) = .;		\
-		*(.pci_fixup_header)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_header) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_final) = .;		\
-		*(.pci_fixup_final)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_final) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_enable) = .;		\
-		*(.pci_fixup_enable)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_enable) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
-		*(.pci_fixup_resume)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = .;	\
-		*(.pci_fixup_resume_early)				\
-		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = .;	\
-		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
-		*(.pci_fixup_suspend)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
+		PCI_FIXUPS(early)					\
+		PCI_FIXUPS(header)					\
+		PCI_FIXUPS(enable)					\
+		PCI_FIXUPS_PM_KEEP(resume)				\
+		PCI_FIXUPS_PM_KEEP(resume_early)			\
+		PCI_FIXUPS_PM_KEEP(suspend)				\
 	}								\
 									\
 	/* Built-in firmware blobs */					\
@@ -486,6 +484,11 @@
 	CPU_DISCARD(init.data)						\
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
+	. = ALIGN(16);							\
+	PCI_FIXUPS(final)						\
+	PCI_FIXUPS_PM_DISCARD(resume)					\
+	PCI_FIXUPS_PM_DISCARD(resume_early)				\
+	PCI_FIXUPS_PM_DISCARD(suspend)					\
 	*(.init.rodata)							\
 	MCOUNT_REC()							\
 	FTRACE_EVENTS()							\
--- 3.4-rc6/scripts/mod/modpost.c
+++ 3.4-rc6-pci-fixup-sections/scripts/mod/modpost.c
@@ -853,7 +853,8 @@ static void check_section(const char *mo
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup$", ".init.rodata$", \
 	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \
-	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
+	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$", \
+	".pci_fixup_final$", ".pci_fixup_suspend*", ".pci_fixup_resume*"
 #define ALL_EXIT_DATA_SECTIONS \
 	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
 
@@ -870,11 +871,13 @@ static void check_section(const char *mo
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
-#define DATA_SECTIONS ".data$", ".data.rel$"
+#define DATA_SECTIONS ".data$", ".data.rel$", ".pci_fixup$", \
+	".pci_fixup_early$", ".pci_fixup_enable$"/*, ".pci_fixup_header$"*/
 #define TEXT_SECTIONS ".text$"
 
-#define INIT_SECTIONS      ".init.*"
-#define DEV_INIT_SECTIONS  ".devinit.*"
+#define INIT_SECTIONS      ".init.*", ".pci_fixup_final$"
+#define DEV_INIT_SECTIONS  ".devinit.*", \
+	".pci_fixup_suspend*", ".pci_fixup_resume*"
 #define CPU_INIT_SECTIONS  ".cpuinit.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"
 


