Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0GZKmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:42:51 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2572 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0GZKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:42:50 -0400
X-IronPort-AV: E=Sophos;i="4.55,261,1278288000"; 
   d="scan'208";a="1064106"
Date: Mon, 26 Jul 2010 11:43:36 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sheng Yang <sheng@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (xen
 tree related)
In-Reply-To: <20100726152908.951a95b7.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1007261132180.22235@kaball-desktop>
References: <20100726152908.951a95b7.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (i386 defconfig)
> failed like this:
> 
> arch/x86/built-in.o: In function `init_hypervisor_platform':
> (.init.text+0x3ca4): undefined reference to `x86_hyper_xen_hvm'
> arch/x86/built-in.o: In function `init_hypervisor_platform':
> (.init.text+0x3cad): undefined reference to `x86_hyper_xen_hvm'
> 
> Caused by commit bee6ab53e652a414af20392899879b58cd80d033 ("x86: early PV
> on HVM features initialization").
> 
> I reverted commit 4b9100d12d15c0eaf23d9edc86228e1bdf452dc2 ("Merge branch
> 'upstream/pvhvm' into upstream/xen") for today (since there were
> dependencies on the above commit).

The problem is that x86_hyper_xen_hvm is in arch/x86/xen/enlighten.c,
that is compiled only when CONFIG_XEN is enabled.
The appended patch fixes the issue moving x86_hyper_xen_hvm to
arch/x86/kernel/cpu/xen.c that is always compiled.

An shorter alternative solution would be just to ifdef CONFIG_XEN
x86_hyper_xen_hvm in arch/x86/kernel/cpu/hypervisor.c. 


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 5e3a351..25d2e82 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -15,6 +15,7 @@ CFLAGS_common.o		:= $(nostackp)
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
+obj-y			+= xen.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/xen.c b/arch/x86/kernel/cpu/xen.c
new file mode 100644
index 0000000..b879de5
--- /dev/null
+++ b/arch/x86/kernel/cpu/xen.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2010, Citrix Systems
+ * Author : Stefano Stabellini <stefano.stabellini@eu.citrix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <asm/x86_init.h>
+#include <asm/hypervisor.h>
+#include <asm/processor.h>
+#include <xen/xen.h>
+
+uint32_t xen_cpuid_base(void)
+{
+	uint32_t base, eax, ebx, ecx, edx;
+	char signature[13];
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		cpuid(base, &eax, &ebx, &ecx, &edx);
+		*(uint32_t *)(signature + 0) = ebx;
+		*(uint32_t *)(signature + 4) = ecx;
+		*(uint32_t *)(signature + 8) = edx;
+		signature[12] = 0;
+
+		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
+			return base;
+	}
+
+	return 0;
+}
+
+static void __init __xen_hvm_guest_init(void)
+{
+	xen_hvm_guest_init();
+}
+
+static bool __init xen_hvm_platform(void)
+{
+	if (xen_pv_domain())
+		return false;
+
+	if (!xen_cpuid_base())
+		return false;
+
+	return true;
+}
+
+const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
+	.name			= "Xen HVM",
+	.detect			= xen_hvm_platform,
+	.init_platform		= __xen_hvm_guest_init,
+};
+EXPORT_SYMBOL(x86_hyper_xen_hvm);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75b479a..06f954d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1205,25 +1205,6 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
-static uint32_t xen_cpuid_base(void)
-{
-	uint32_t base, eax, ebx, ecx, edx;
-	char signature[13];
-
-	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
-		cpuid(base, &eax, &ebx, &ecx, &edx);
-		*(uint32_t *)(signature + 0) = ebx;
-		*(uint32_t *)(signature + 4) = ecx;
-		*(uint32_t *)(signature + 8) = edx;
-		signature[12] = 0;
-
-		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
-			return base;
-	}
-
-	return 0;
-}
-
 static int init_hvm_pv_info(int *major, int *minor)
 {
 	uint32_t eax, ebx, ecx, edx, pages, msr, base;
@@ -1300,7 +1281,7 @@ static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
 	.notifier_call	= xen_hvm_cpu_notify,
 };
 
-static void __init xen_hvm_guest_init(void)
+void __init xen_hvm_guest_init(void)
 {
 	int r;
 	int major, minor;
@@ -1320,21 +1301,3 @@ static void __init xen_hvm_guest_init(void)
 	xen_hvm_init_time_ops();
 	xen_hvm_init_mmu_ops();
 }
-
-static bool __init xen_hvm_platform(void)
-{
-	if (xen_pv_domain())
-		return false;
-
-	if (!xen_cpuid_base())
-		return false;
-
-	return true;
-}
-
-const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
-	.name			= "Xen HVM",
-	.detect			= xen_hvm_platform,
-	.init_platform		= xen_hvm_guest_init,
-};
-EXPORT_SYMBOL(x86_hyper_xen_hvm);
diff --git a/include/xen/xen.h b/include/xen/xen.h
index a164024..dfc2784 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -9,9 +9,12 @@ enum xen_domain_type {
 
 #ifdef CONFIG_XEN
 extern enum xen_domain_type xen_domain_type;
+extern void __init xen_hvm_guest_init(void);
 #else
 #define xen_domain_type		XEN_NATIVE
+#define xen_hvm_guest_init() do { } while (0)
 #endif
+extern uint32_t xen_cpuid_base(void);
 
 #define xen_domain()		(xen_domain_type != XEN_NATIVE)
 #define xen_pv_domain()		(xen_domain() &&			\

