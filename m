Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2J2Nlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:41:47 -0400
Received: from zmc.proxad.net ([212.27.53.206]:41618 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab2J2Nlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:41:46 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH 1/3 v3] x86: ce4100: implement pm_poweroff
Date: Mon, 29 Oct 2012 14:40:18 +0100
Message-Id: <1351518020-25556-2-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351518020-25556-1-git-send-email-ffainelli@freebox.fr>
References: <1351251054-19892-1-git-send-email-ffainelli@freebox.fr>
 <1351518020-25556-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CE4100 platform is currently missing a proper pm_poweroff implementation
leading to poweroff making the CPU spin forever and the CE4100 platform does
not enter a low-power mode where the external Power Management Unit can
properly power off the system. Power off on this platform is implemented pretty
much like reboot, by writing to the SoC built-in 8051 microcontroller mapped at
I/O port 0xcf9, the value 0x4.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 arch/x86/platform/ce4100/ce4100.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

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
-- 
1.7.10.4

