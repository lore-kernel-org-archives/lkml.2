Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab2CPMRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:17:43 -0400
Received: from thoth.sbs.de ([192.35.17.2]:18138 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761570Ab2CPMRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:17:37 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 4/4] kgdb: x86: Detach gdb if machine shuts down or reboots
Date: Fri, 16 Mar 2012 13:17:14 +0100
Message-Id: <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook into machine restart/power-off/halt handlers and call gdbstub_exit
so that a attached gdb frontend is properly informed. If kgdb is
disabled or no frontend attached, gdbstub_exit will do nothing.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kernel/reboot.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..926ac17 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/tboot.h>
 #include <linux/delay.h>
+#include <linux/kgdb.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -683,6 +684,7 @@ void native_machine_shutdown(void)
 static void __machine_emergency_restart(int emergency)
 {
 	reboot_emergency = emergency;
+	gdbstub_exit(1);
 	machine_ops.emergency_restart();
 }
 
@@ -730,6 +732,7 @@ struct machine_ops machine_ops = {
 
 void machine_power_off(void)
 {
+	gdbstub_exit(0);
 	machine_ops.power_off();
 }
 
@@ -745,17 +748,20 @@ void machine_emergency_restart(void)
 
 void machine_restart(char *cmd)
 {
+	gdbstub_exit(0);
 	machine_ops.restart(cmd);
 }
 
 void machine_halt(void)
 {
+	gdbstub_exit(0);
 	machine_ops.halt();
 }
 
 #ifdef CONFIG_KEXEC
 void machine_crash_shutdown(struct pt_regs *regs)
 {
+	gdbstub_exit(1);
 	machine_ops.crash_shutdown(regs);
 }
 #endif
-- 
1.7.3.4

