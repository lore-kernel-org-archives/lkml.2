Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1DBGXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:44 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:59936 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1DBGXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:33 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        xen-devel@lists.xensource.com
Subject: [PATCH 09/18] cpuidle: replace xen access to x86 pm_idle and
 default_idle
Date: Sat, 02 Apr 2011 02:22:51 -0400
Message-id: <e2f656a28f548ed19c829563e5168ce48026570b.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

When a Xen Dom0 kernel boots on a hypervisor, it gets access
to the raw-hardware ACPI tables.  While it parses the idle tables
for the hypervisor's beneift, it uses HLT for its own idle.

Rather than have xen scribble on pm_idle and access default_idle,
have it simply disable_cpuidle() so acpi_idle will not load and
architecture default HLT will be used.

cc: xen-devel@lists.xensource.com
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/xen/setup.c      |    3 ++-
 drivers/cpuidle/cpuidle.c |    4 ++++
 include/linux/cpuidle.h   |    2 ++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index a8a66a5..aa02cce 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/pm.h>
 #include <linux/memblock.h>
+#include <linux/cpuidle.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -354,7 +355,7 @@ void __init xen_arch_setup(void)
 #ifdef CONFIG_X86_32
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
-	pm_idle = default_idle;
+	disable_cpuidle();
 	boot_option_idle_override = IDLE_HALT;
 
 	fiddle_vdso();
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index faae2c3..041df0b 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -34,6 +34,10 @@ int cpuidle_disabled(void)
 {
 	return off;
 }
+void disable_cpuidle(void)
+{
+	off = 1;
+}
 
 #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
 static void cpuidle_kick_cpus(void)
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 36719ea..b89f67d 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -122,6 +122,7 @@ struct cpuidle_driver {
 };
 
 #ifdef CONFIG_CPU_IDLE
+extern void disable_cpuidle(void);
 
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 struct cpuidle_driver *cpuidle_get_driver(void);
@@ -135,6 +136,7 @@ extern int cpuidle_enable_device(struct cpuidle_device *dev);
 extern void cpuidle_disable_device(struct cpuidle_device *dev);
 
 #else
+static inline void disable_cpuidle(void) { }
 
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
-- 
1.7.5.rc0

