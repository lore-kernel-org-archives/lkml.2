Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab0FQWO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:14:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36672 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0FQWOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:14:25 -0400
Date: Thu, 17 Jun 2010 15:13:18 -0700
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Jiri Kosina <jkosina@suse.cz>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20100617221318.GC24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX cannot
be inappropriately controlled by the BIOS on Intel CPUs.  If NX actually
needs to be disabled, "noexec=off" can be used.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/head_32.S |   19 +++++++++++++++++++
 arch/x86/kernel/head_64.S |   18 ++++++++++++++++++
 arch/x86/mm/setup_nx.c    |    2 +-
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..111e434 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -309,6 +309,25 @@ ENTRY(startup_32_smp)
 	subl $0x80000001, %eax
 	cmpl $(0x8000ffff-0x80000001), %eax
 	ja 6f
+
+	/* Is this "GenuineIntel"? */
+	movl $0x0, %eax
+	cpuid
+	cmpl $0x756e6547, %ebx
+	jnz 5f
+	cmpl $0x49656e69, %edx
+	jnz 5f
+	cmpl $0x6c65746e, %ecx
+	jnz 5f
+
+	/* Clear MSR_IA32_MISC_ENABLE_XD_DISABLE if set */
+	movl $MSR_IA32_MISC_ENABLE, %ecx
+	rdmsr
+	btrl $2, %edx
+	jnc 5f
+	wrmsr
+
+5:
 	mov $0x80000001, %eax
 	cpuid
 	/* Execute Disable bit supported? */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3d1e6f1..e918e40 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -175,6 +175,24 @@ ENTRY(secondary_startup_64)
 	jmp	*%rax
 1:
 
+	/* Is this "GenuineIntel"? */
+	movl $0x0, %eax
+	cpuid
+	cmpl $0x756e6547, %ebx
+	jnz 5f
+	cmpl $0x49656e69, %edx
+	jnz 5f
+	cmpl $0x6c65746e, %ecx
+	jnz 5f
+
+	/* Clear MSR_IA32_MISC_ENABLE_XD_DISABLE if set */
+	movl $MSR_IA32_MISC_ENABLE, %ecx
+	rdmsr
+	btrl $2, %edx
+	jnc 5f
+	wrmsr
+
+5:
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index a3250aa..410531d 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -41,7 +41,7 @@ void __init x86_report_nx(void)
 {
 	if (!cpu_has_nx) {
 		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
-		       "missing in CPU or disabled in BIOS!\n");
+		       "missing in CPU!\n");
 	} else {
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 		if (disable_nx) {
-- 
1.7.1

-- 
Kees Cook
Ubuntu Security Team
