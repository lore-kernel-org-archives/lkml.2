Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab2JSLxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:53:16 -0400
Received: from zmc.proxad.net ([212.27.53.206]:53919 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab2JSLxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:53:14 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: bigeasy@linutronix.de
Cc: linux-kernel@vger.kernel.org, x86@vger.kernel.org, mbizon@freebox.fr,
        Florian Fainelli <ffainelli@freebox.fr>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/3] x86: ce4100: implement pm_poweroff
Date: Fri, 19 Oct 2012 13:51:54 +0200
Message-Id: <1350647516-4842-2-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
References: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CE4100 platform is currently missing a proper pm_poweroff implementation
leading to poweroff making the CPU spin forever and the CE4100 platform does
not enter a low-power mode where the external Power Management Unit can
properly power off the system. Power off on this platform is implemented pretty
much like reboot, by writing to the SoC built-in 8051 microcontroller mapped at
I/O port 0xcf9, the value 0x4.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 arch/x86/platform/ce4100/ce4100.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 4c61b52..74f8774 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -27,6 +27,11 @@ static int ce4100_i8042_detect(void)
 	return 0;
 }
 
+static void ce4100_power_off(void)
+{
+	outb(0x4, 0xcf9);
+}
+
 #ifdef CONFIG_SERIAL_8250
 
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
@@ -143,4 +148,6 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.pci.init_irq = sdv_pci_init;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
 #endif
+
+	pm_power_off = ce4100_power_off;
 }
-- 
1.7.9.5

