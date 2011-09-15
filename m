Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1IOI3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:29:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:7817 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1IOI3g convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:3:1>);
	Thu, 15 Sep 2011 04:29:36 -0400
Message-Id: <4E71D38E02000078000563A1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Sep 2011 09:29:34 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86-64: don't apply destructive erratum
	 workaround on unaffected CPUs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erratum 93 applies to AMD K8 CPUs only, and its workaround (forcing
the upper 32 bits of %rip to all get set under certain conditions) is
actually getting in the way of analyzing page faults occurring during
EFI physical mode runtime calls (in particular the page table walk
shown is completely unrelated to the actual fault). This is because
typically EFI runtime code lives in the space between 2G and 4G, which
- modulo the above manipulation - is likely to overlap with the kernel
or modules area.

While even for the other errata workarounds their taking effect could
be limited to just the affected CPUs, none of them appears to be
destructive, and they're generally getting called only outside of
performance critical paths, so they're being left untouched.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/fault.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- 3.1-rc6/arch/x86/mm/fault.c
+++ 3.1-rc6-x86_64-amd-erratum93/arch/x86/mm/fault.c
@@ -420,12 +420,14 @@ static noinline __kprobes int vmalloc_fa
 	return 0;
 }
 
+#ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
 KERN_ERR 
 "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
 "******* Working around it, but it may cause SEGVs or burn power.\n"
 "******* Please consider a BIOS update.\n"
 "******* Disabling USB legacy in the BIOS may also help.\n";
+#endif
 
 /*
  * No vm86 mode in 64-bit mode:
@@ -505,7 +507,11 @@ bad:
  */
 static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && defined(CONFIG_CPU_SUP_AMD)
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD
+	    || boot_cpu_data.x86 != 0xf)
+		return 0;
+
 	if (address != regs->ip)
 		return 0;
 



