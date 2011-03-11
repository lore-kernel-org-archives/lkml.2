Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1CKPWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:22:55 -0500
Received: from www.tglx.de ([62.245.132.106]:56356 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab1CKPWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:22:54 -0500
Date: Fri, 11 Mar 2011 16:22:47 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, sodaville@linutronix.de
Subject: [PATCH] x86/ce4100: set pci ops via callback instead of module init
Message-ID: <20110311152247.GA14273@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting those on subsys initcall will break any x86 platform except
ce4100 which could lead to complains from users.
To avoid those complains, I move to pci.init like others which use the
same kind of quirk.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/ce4100.h     |    6 ++++++
 arch/x86/pci/ce4100.c             |    5 ++---
 arch/x86/platform/ce4100/ce4100.c |    9 +++++++++
 3 files changed, 17 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/ce4100.h

diff --git a/arch/x86/include/asm/ce4100.h b/arch/x86/include/asm/ce4100.h
new file mode 100644
index 0000000..64db052
--- /dev/null
+++ b/arch/x86/include/asm/ce4100.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_CE4100_H_
+#define _ASM_CE4100_H_
+
+void ce4100_init_pci_ops(void);
+
+#endif
diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index c63c6d3..8117f72 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 
+#include <asm/ce4100.h>
 #include <asm/pci_x86.h>
 
 struct sim_reg {
@@ -306,10 +307,8 @@ struct pci_raw_ops ce4100_pci_conf = {
 	.write = ce4100_conf_write,
 };
 
-static int __init ce4100_pci_init(void)
+void __init ce4100_init_pci_ops(void)
 {
 	init_sim_regs();
 	raw_pci_ops = &ce4100_pci_conf;
-	return 0;
 }
-subsys_initcall(ce4100_pci_init);
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 68c0dbc..93b4e3c 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -15,6 +15,7 @@
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
 
+#include <asm/ce4100.h>
 #include <asm/prom.h>
 #include <asm/setup.h>
 #include <asm/i8259.h>
@@ -125,6 +126,13 @@ static void __cpuinit sdv_pci_init(void)
 }
 #endif
 
+static int __cpuinit ce4100_pci_init(void)
+{
+	ce4100_init_pci_ops();
+	pci_legacy_init();
+	return 0;
+}
+
 /*
  * CE4100 specific x86_init function overrides and early setup
  * calls.
@@ -136,6 +144,7 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.pci.init = ce4100_pci_init;
 
 #ifdef CONFIG_X86_IO_APIC
 	x86_init.pci.init_irq = sdv_pci_init;
-- 
1.7.4

