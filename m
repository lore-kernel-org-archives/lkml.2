Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1HZK7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:59:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45493 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1HZK7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:59:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86, mrst: Some drivers need to known when an SCU is available
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:54:22 +0100
Message-ID: <20110826105400.23622.82800.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

 arch/x86/include/asm/intel_scu_ipc.h |   24 +++++++++++++++++++++++-
 arch/x86/platform/mrst/mrst.c        |    7 +++++++
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/intel_scu_ipc.h b/arch/x86/include/asm/intel_scu_ipc.h
index 29f6679..c08d94e 100644
--- a/arch/x86/include/asm/intel_scu_ipc.h
+++ b/arch/x86/include/asm/intel_scu_ipc.h
@@ -1,7 +1,9 @@
 #ifndef _ASM_X86_INTEL_SCU_IPC_H_
 #define  _ASM_X86_INTEL_SCU_IPC_H_
 
-#define IPCMSG_VRTC	0xFA	 /* Set vRTC device */
+#include <linux/notifier.h>
+
+#define IPCMSG_VRTC		0xFA	 /* Set vRTC device */
 
 /* Command id associated with message IPCMSG_VRTC */
 #define IPC_CMD_VRTC_SETTIME      1 /* Set time */
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
index 554403f..49de866 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 
 #include <asm/setup.h>
 #include <asm/mpspec_def.h>
@@ -558,6 +559,9 @@ static void __init intel_scu_i2c_device_register(int bus,
 	i2c_devs[i2c_next_dev++] = new_dev;
 }
 
+BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
+EXPORT_SYMBOL_GPL(intel_scu_notifier);
+
 /* Called by IPC driver */
 void intel_scu_devices_create(void)
 {
@@ -582,6 +586,7 @@ void intel_scu_devices_create(void)
 		} else
 			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
 	}
+	intel_scu_notifier_post(SCU_AVAILABLE, 0L);
 }
 EXPORT_SYMBOL_GPL(intel_scu_devices_create);
 
@@ -590,6 +595,8 @@ void intel_scu_devices_destroy(void)
 {
 	int i;
 
+	intel_scu_notifier_post(SCU_DOWN, 0L);
+
 	for (i = 0; i < ipc_next_dev; i++)
 		platform_device_del(ipc_devs[i]);
 }

