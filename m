Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab1D0Pew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:34:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39161 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab1D0Pev convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:3>);
	Wed, 27 Apr 2011 11:34:51 -0400
Message-Id: <4DB85404020000780003E6D7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:36:04 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] allow placing exception table in .rodata (and do so on
	 x86)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is since the table is really a set of pointers, i.e. misplaced in
.text.

Quite likely other architectures would want to follow.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/sections.h   |    2 +-
 arch/x86/kernel/vmlinux.lds.S     |    5 +++--
 arch/x86/mm/init_64.c             |    6 +++---
 include/asm-generic/vmlinux.lds.h |    5 +++++
 4 files changed, 12 insertions(+), 6 deletions(-)

--- 2.6.39-rc5/arch/x86/include/asm/sections.h
+++ 2.6.39-rc5-extable-in-rodata/arch/x86/include/asm/sections.h
@@ -5,7 +5,7 @@
 #include <asm/uaccess.h>
 
 extern char __brk_base[], __brk_limit[];
-extern struct exception_table_entry __stop___ex_table[];
+extern const char __stop_notes[];
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 extern char __end_rodata_hpage_align[];
--- 2.6.39-rc5/arch/x86/kernel/vmlinux.lds.S
+++ 2.6.39-rc5-extable-in-rodata/arch/x86/kernel/vmlinux.lds.S
@@ -20,6 +20,8 @@
 #define LOAD_OFFSET __START_KERNEL_map
 #endif
 
+#define EXCEPTION_TABLE_RO EXCEPTION_TABLE(16)
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
@@ -114,8 +116,7 @@ SECTIONS
 	} :text = 0x9090
 
 	NOTES :text :note
-
-	EXCEPTION_TABLE(16) :text = 0x9090
+	text_continues : {} :text /* switch back to regular text... */
 
 #if defined(CONFIG_DEBUG_RODATA)
 	/* .text should occupy whole number of pages */
--- 2.6.39-rc5/arch/x86/mm/init_64.c
+++ 2.6.39-rc5-extable-in-rodata/arch/x86/mm/init_64.c
@@ -741,7 +741,7 @@ int kernel_set_to_readonly;
 void set_kernel_text_rw(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = PFN_ALIGN(__stop___ex_table);
+	unsigned long end = PFN_ALIGN(_etext);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -760,7 +760,7 @@ void set_kernel_text_rw(void)
 void set_kernel_text_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = PFN_ALIGN(__stop___ex_table);
+	unsigned long end = PFN_ALIGN(_etext);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -780,7 +780,7 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
-	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
+	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop_notes);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
 
--- 2.6.39-rc5/include/asm-generic/vmlinux.lds.h
+++ 2.6.39-rc5-extable-in-rodata/include/asm-generic/vmlinux.lds.h
@@ -226,6 +226,7 @@
 		*(.rodata1)						\
 	}								\
 									\
+	EXCEPTION_TABLE_RO						\
 	BUG_TABLE							\
 									\
 	JUMP_TABLE							\
@@ -459,6 +460,10 @@
 		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
 	}
 
+#ifndef EXCEPTION_TABLE_RO
+#define EXCEPTION_TABLE_RO
+#endif
+
 /*
  * Init task
  */



