Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1CVMdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:33:37 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42607 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab1CVMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:33:34 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V4 4/5] cpuidle: driver for xen
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Tue, 22 Mar 2011 18:03:28 +0530
Message-ID: <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a default cpuidle driver for xen.
Earlier pm_idle was flipped to default_idle. Maybe there
is a better way to ensure default_idle is called
without using this cpuidle driver.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 arch/x86/xen/setup.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index a8a66a5..4fce4cd 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -9,6 +9,8 @@
 #include <linux/mm.h>
 #include <linux/pm.h>
 #include <linux/memblock.h>
+#include <linux/cpuidle.h>
+#include <linux/slab.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -321,6 +323,44 @@ void __cpuinit xen_enable_syscall(void)
 #endif /* CONFIG_X86_64 */
 }
 
+static struct cpuidle_driver xen_idle_driver = {
+	.name = "xen_idle",
+	.owner = THIS_MODULE,
+	.priority = 1,
+};
+
+extern struct cpuidle_state state_default_state;
+
+static int setup_cpuidle(int cpu)
+{
+	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
+					GFP_KERNEL);
+	int count = CPUIDLE_DRIVER_STATE_START;
+	dev->cpu = cpu;
+	dev->drv = &xen_idle_driver;
+
+	dev->states[count] = state_default_idle;
+	count++;
+
+	dev->state_count = count;
+
+	if (cpuidle_register_device(dev))
+		return -EIO;
+	return 0;
+}
+
+static int xen_idle_init(void)
+{
+	int retval, i;
+	retval = cpuidle_register_driver(&xen_idle_driver);
+
+	for_each_online_cpu(i) {
+		setup_cpuidle(i);
+	}
+
+	return 0;
+}
+
 void __init xen_arch_setup(void)
 {
 	xen_panic_handler_init();
@@ -354,7 +394,7 @@ void __init xen_arch_setup(void)
 #ifdef CONFIG_X86_32
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
-	pm_idle = default_idle;
+	xen_idle_init();
 	boot_option_idle_override = IDLE_HALT;
 
 	fiddle_vdso();

