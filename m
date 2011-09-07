Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1IGQro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:47:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:24151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1IGQrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45870149"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: alan@linux.intel.com, sameo@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, feng.tang@intel.com,
        jacob.jun.pan@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/3] x86, mrst: Some drivers need to known when an SCU is available
Date: Wed,  7 Sep 2011 16:06:51 +0300
Message-Id: <618af614e18f9a6a13de09834805f5ef18773b33.1315399396.git.mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1315399396.git.mika.westerberg@linux.intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
In-Reply-To: <cover.1315399396.git.mika.westerberg@linux.intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Add a notifier so that drivers can hook into SCU availability in order to
take actions post initialisation when/if the SCU becomes available.

In the ideal world we wouldn't need this and we could avoid any init
dependancies of this form, but in practice we can't do it for some cases.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 arch/x86/include/asm/intel_scu_ipc.h |   22 ++++++++++++++++++++++
 arch/x86/platform/mrst/mrst.c        |    7 +++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/intel_scu_ipc.h b/arch/x86/include/asm/intel_scu_ipc.h
index 29f6679..4420993 100644
--- a/arch/x86/include/asm/intel_scu_ipc.h
+++ b/arch/x86/include/asm/intel_scu_ipc.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_INTEL_SCU_IPC_H_
 #define  _ASM_X86_INTEL_SCU_IPC_H_
 
+#include <linux/notifier.h>
+
 #define IPCMSG_VRTC	0xFA	 /* Set vRTC device */
 
 /* Command id associated with message IPCMSG_VRTC */
@@ -44,4 +46,24 @@ int intel_scu_ipc_i2c_cntrl(u32 addr, u32 *data);
 /* Update FW version */
 int intel_scu_ipc_fw_update(u8 *buffer, u32 length);
 
+extern struct blocking_notifier_head intel_scu_notifier;
+
+static inline void intel_scu_notifier_add(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&intel_scu_notifier, nb);
+}
+
+static inline void intel_scu_notifier_remove(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&intel_scu_notifier, nb);
+}
+
+static inline int intel_scu_notifier_post(unsigned long v, void *p)
+{
+	return blocking_notifier_call_chain(&intel_scu_notifier, v, p);
+}
+
+#define		SCU_AVAILABLE		1
+#define		SCU_DOWN		2
+
 #endif
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 745db49..97138a3 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -578,6 +579,9 @@ static void __init intel_scu_i2c_device_register(int bus,
 	i2c_devs[i2c_next_dev++] = new_dev;
 }
 
+BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
+EXPORT_SYMBOL_GPL(intel_scu_notifier);
+
 /* Called by IPC driver */
 void intel_scu_devices_create(void)
 {
@@ -602,6 +606,7 @@ void intel_scu_devices_create(void)
 		} else
 			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
 	}
+	intel_scu_notifier_post(SCU_AVAILABLE, 0L);
 }
 EXPORT_SYMBOL_GPL(intel_scu_devices_create);
 
@@ -610,6 +615,8 @@ void intel_scu_devices_destroy(void)
 {
 	int i;
 
+	intel_scu_notifier_post(SCU_DOWN, 0L);
+
 	for (i = 0; i < ipc_next_dev; i++)
 		platform_device_del(ipc_devs[i]);
 }
-- 
1.7.5.4

