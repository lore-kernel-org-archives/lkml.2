Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab0G3RhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:37:15 -0400
Received: from kroah.org ([198.145.64.141]:36110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753Ab0G3Rfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:13 2010
Message-Id: <20100730173113.007295828@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ondrej Zary <linux@rainbow-software.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [114/140] PM / x86: Save/restore MISC_ENABLE register
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit 85a0e7539781dad4bfcffd98e72fa9f130f4e40d upstream.

Save/restore MISC_ENABLE register on suspend/resume.
This fixes OOPS (invalid opcode) on resume from STR on Asus P4P800-VM,
which wakes up with MWAIT disabled.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=15385

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/suspend_32.h |    2 ++
 arch/x86/include/asm/suspend_64.h |    2 ++
 arch/x86/power/cpu.c              |    4 ++++
 3 files changed, 8 insertions(+)

--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -15,6 +15,8 @@ static inline int arch_prepare_suspend(v
 struct saved_context {
 	u16 es, fs, gs, ss;
 	unsigned long cr0, cr2, cr3, cr4;
+	u64 misc_enable;
+	bool misc_enable_saved;
 	struct desc_ptr gdt;
 	struct desc_ptr idt;
 	u16 ldt;
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -27,6 +27,8 @@ struct saved_context {
 	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
+	u64 misc_enable;
+	bool misc_enable_saved;
 	unsigned long efer;
 	u16 gdt_pad;
 	u16 gdt_limit;
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -105,6 +105,8 @@ static void __save_processor_state(struc
 	ctxt->cr4 = read_cr4();
 	ctxt->cr8 = read_cr8();
 #endif
+	ctxt->misc_enable_saved = !rdmsrl_safe(MSR_IA32_MISC_ENABLE,
+					       &ctxt->misc_enable);
 }
 
 /* Needed by apm.c */
@@ -152,6 +154,8 @@ static void fix_processor_context(void)
  */
 static void __restore_processor_state(struct saved_context *ctxt)
 {
+	if (ctxt->misc_enable_saved)
+		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
 	/*
 	 * control registers
 	 */


