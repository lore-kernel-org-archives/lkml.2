Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1CNJds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:33:48 -0400
Received: from www.tglx.de ([62.245.132.106]:58098 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab1CNJdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:33:47 -0400
Date: Mon, 14 Mar 2011 10:33:40 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, sodaville@linutronix.de
Subject: [PATCH v2 current] x86/ce4100: set pci ops via callback instead of module init
Message-ID: <20110314093340.GA21026@www.tglx.de>
References: <20110311152247.GA14273@www.tglx.de> <alpine.LFD.2.00.1103111747460.2787@localhost6.localdomain6> <20110312210856.GA16480@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110312210856.GA16480@www.tglx.de>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting those on subsys initcall will break any x86 platform except
ce4100 which could lead to complains from users.
To avoid I move to pci.init like others which use the same kind of
quirk.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

This is against v2.6.38-rc8. The PCI file joined the kernel in
v2.6.38-rc1.

 arch/x86/include/asm/ce4100.h     |    6 ++++++
 arch/x86/pci/ce4100.c             |    6 +++---
 arch/x86/platform/ce4100/ce4100.c |    2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/ce4100.h

diff --git a/arch/x86/include/asm/ce4100.h b/arch/x86/include/asm/ce4100.h
new file mode 100644
index 0000000..e656ad8
--- /dev/null
+++ b/arch/x86/include/asm/ce4100.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_CE4100_H_
+#define _ASM_CE4100_H_
+
+int ce4100_pci_init(void);
+
+#endif
diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index 85b68ef..1ec2841 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 
+#include <asm/ce4100.h>
 #include <asm/pci_x86.h>
 
 struct sim_reg {
@@ -306,10 +307,9 @@ struct pci_raw_ops ce4100_pci_conf = {
 	.write = ce4100_conf_write,
 };
 
-static int __init ce4100_pci_init(void)
+int __init ce4100_pci_init(void)
 {
 	init_sim_regs();
 	raw_pci_ops = &ce4100_pci_conf;
-	return 0;
+	return pci_legacy_init();
 }
-subsys_initcall(ce4100_pci_init);
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index d2c0d51..cd6f184 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -15,6 +15,7 @@
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
 
+#include <asm/ce4100.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 
@@ -129,4 +130,5 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
+	x86_init.pci.init = ce4100_pci_init;
 }
-- 
1.7.4

