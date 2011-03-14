Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1CNOQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:16:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab1CNOQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:16:41 -0400
Date: Mon, 14 Mar 2011 14:16:03 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <20110314093340.GA21026@www.tglx.de>
References: <20110314093340.GA21026@www.tglx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: ce4100: Set pci ops via callback instead of module init
Message-ID: <tip-03150171dcf9492a96f57cbb2aef088bafcfcd2e@git.kernel.org>
Git-Commit-ID: 03150171dcf9492a96f57cbb2aef088bafcfcd2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Mar 2011 14:16:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03150171dcf9492a96f57cbb2aef088bafcfcd2e
Gitweb:     http://git.kernel.org/tip/03150171dcf9492a96f57cbb2aef088bafcfcd2e
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Mon, 14 Mar 2011 10:33:40 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Mar 2011 15:13:23 +0100

x86: ce4100: Set pci ops via callback instead of module init

Setting the pci ops on subsys initcall unconditionally will break
multi platform kernels on anything except ce4100.

Use x86_init.pci.init ops to call this only on real ce4100 platforms.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: sodaville@linutronix.de
LKML-Reference: <20110314093340.GA21026@www.tglx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/ce4100.h     |    6 ++++++
 arch/x86/pci/ce4100.c             |    7 ++++---
 arch/x86/platform/ce4100/ce4100.c |    2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

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
index 85b68ef..9260b3e 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 
+#include <asm/ce4100.h>
 #include <asm/pci_x86.h>
 
 struct sim_reg {
@@ -306,10 +307,10 @@ struct pci_raw_ops ce4100_pci_conf = {
 	.write = ce4100_conf_write,
 };
 
-static int __init ce4100_pci_init(void)
+int __init ce4100_pci_init(void)
 {
 	init_sim_regs();
 	raw_pci_ops = &ce4100_pci_conf;
-	return 0;
+	/* Indicate caller that it should invoke pci_legacy_init() */
+	return 1;
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
