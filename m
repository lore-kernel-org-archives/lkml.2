Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab2J3M0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:26:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2J3MZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:25:58 -0400
Date: Tue, 30 Oct 2012 05:25:45 -0700
From: tip-bot for Florian Fainelli <ffainelli@freebox.fr>
Message-ID: <tip-f49f4ab95c301dbccad0efe85296d908b8ae7ad4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bigeasy@linutronix.de, tglx@linutronix.de, ffainelli@freebox.fr
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de, ffainelli@freebox.fr
In-Reply-To: <1351518020-25556-2-git-send-email-ffainelli@freebox.fr>
References: <1351518020-25556-2-git-send-email-ffainelli@freebox.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ce4100: Fix pm_poweroff
Git-Commit-ID: f49f4ab95c301dbccad0efe85296d908b8ae7ad4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:25:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f49f4ab95c301dbccad0efe85296d908b8ae7ad4
Gitweb:     http://git.kernel.org/tip/f49f4ab95c301dbccad0efe85296d908b8ae7ad4
Author:     Florian Fainelli <ffainelli@freebox.fr>
AuthorDate: Mon, 29 Oct 2012 14:40:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:16:46 +0100

x86/ce4100: Fix pm_poweroff

The CE4100 platform is currently missing a proper pm_poweroff
implementation leading to poweroff making the CPU spin forever
and the CE4100 platform does not enter a low-power mode where
the external Power Management Unit can properly power off the
system. Power off on this platform is implemented pretty much
like reboot, by writing to the SoC built-in 8051 microcontroller
mapped at I/O port 0xcf9, the value 0x4.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: rui.zhang@intel.com
Cc: alan@linux.intel.com
Link: http://lkml.kernel.org/r/1351518020-25556-2-git-send-email-ffainelli@freebox.fr
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/ce4100/ce4100.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 4c61b52..5de16e3 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -27,6 +27,18 @@ static int ce4100_i8042_detect(void)
 	return 0;
 }
 
+/*
+ * The CE4100 platform has an internal 8051 Microcontroller which is
+ * responsible for signaling to the external Power Management Unit the
+ * intention to reset, reboot or power off the system. This 8051 device has
+ * its command register mapped at I/O port 0xcf9 and the value 0x4 is used
+ * to power off the system.
+ */
+static void ce4100_power_off(void)
+{
+	outb(0x4, 0xcf9);
+}
+
 #ifdef CONFIG_SERIAL_8250
 
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
@@ -143,4 +155,6 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.pci.init_irq = sdv_pci_init;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
 #endif
+
+	pm_power_off = ce4100_power_off;
 }
