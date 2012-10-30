Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab2J3M1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:27:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41330 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2J3M07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:26:59 -0400
Date: Tue, 30 Oct 2012 05:26:45 -0700
From: tip-bot for Maxime Bizon <mbizon@freebox.fr>
Message-ID: <tip-d7959916026aaae60e1878ae33c7503b2cc4471d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bigeasy@linutronix.de, tglx@linutronix.de, ffainelli@freebox.fr,
        mbizon@freebox.fr
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de, mbizon@freebox.fr,
        ffainelli@freebox.fr
In-Reply-To: <1351518020-25556-3-git-send-email-ffainelli@freebox.fr>
References: <1351518020-25556-3-git-send-email-ffainelli@freebox.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ce4100:
  Fix reboot by forcing the reboot method to be KBD
Git-Commit-ID: d7959916026aaae60e1878ae33c7503b2cc4471d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:26:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7959916026aaae60e1878ae33c7503b2cc4471d
Gitweb:     http://git.kernel.org/tip/d7959916026aaae60e1878ae33c7503b2cc4471d
Author:     Maxime Bizon <mbizon@freebox.fr>
AuthorDate: Mon, 29 Oct 2012 14:40:19 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:16:46 +0100

x86/ce4100: Fix reboot by forcing the reboot method to be KBD

The default reboot is via ACPI for this platform, and the CEFDK
bootloader actually supports this, but will issue a system power
off instead of a real reboot. Setting the reboot method to be
KBD instead of ACPI ensures proper system reboot.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Cc: rui.zhang@intel.com
Cc: alan@linux.intel.com
Link: http://lkml.kernel.org/r/1351518020-25556-3-git-send-email-ffainelli@freebox.fr
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/ce4100/ce4100.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 5de16e3..92525cb 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -21,6 +21,7 @@
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/io_apic.h>
+#include <asm/emergency-restart.h>
 
 static int ce4100_i8042_detect(void)
 {
@@ -151,6 +152,15 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.pci.init = ce4100_pci_init;
 
+	/*
+	 * By default, the reboot method is ACPI which is supported by the
+	 * CE4100 bootloader CEFDK using FADT.ResetReg Address and ResetValue
+	 * the bootloader will however issue a system power off instead of
+	 * reboot. By using BOOT_KBD we ensure proper system reboot as
+	 * expected.
+	 */
+	reboot_type = BOOT_KBD;
+
 #ifdef CONFIG_X86_IO_APIC
 	x86_init.pci.init_irq = sdv_pci_init;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
