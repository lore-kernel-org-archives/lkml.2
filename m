Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1HCTpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:45:15 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59192 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1HCTos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:44:48 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, xen-devel@lists.xensource.com
Subject: [PATCH 3/5] cpuidle: replace xen access to x86 pm_idle and default_idle
Date: Wed, 03 Aug 2011 15:44:06 -0400
Message-id: <0c70c6b12c37ececbfa9b7734495835514f273a4.1312400543.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312400648-17636-1-git-send-email-lenb@kernel.org>
References: <1312400648-17636-1-git-send-email-lenb@kernel.org>
In-reply-to: <8e24ed2af46a5d008d85bfeb128d25efc394a3fd.1312400543.git.len.brown@intel.com>
References: <8e24ed2af46a5d008d85bfeb128d25efc394a3fd.1312400543.git.len.brown@intel.com>
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
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/xen/setup.c      |    3 ++-
 drivers/cpuidle/cpuidle.c |    4 ++++
 include/linux/cpuidle.h   |    2 ++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 60aeeb5..a9627e2 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/pm.h>
 #include <linux/memblock.h>
+#include <linux/cpuidle.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -426,7 +427,7 @@ void __init xen_arch_setup(void)
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
1.7.6.396.ge0613

