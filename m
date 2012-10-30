Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab2J3M17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:27:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2J3M16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:27:58 -0400
Date: Tue, 30 Oct 2012 05:27:44 -0700
From: tip-bot for Maxime Bizon <mbizon@freebox.fr>
Message-ID: <tip-37aeec36220c39f1b2e7118287d951fd9cfdd6b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bigeasy@linutronix.de, tglx@linutronix.de, ffainelli@freebox.fr,
        mbizon@freebox.fr
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de, mbizon@freebox.fr,
        ffainelli@freebox.fr
In-Reply-To: <1351518020-25556-4-git-send-email-ffainelli@freebox.fr>
References: <1351518020-25556-4-git-send-email-ffainelli@freebox.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ce4100:
  Fix PCI configuration register access for devices without interrupts
Git-Commit-ID: 37aeec36220c39f1b2e7118287d951fd9cfdd6b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:27:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37aeec36220c39f1b2e7118287d951fd9cfdd6b7
Gitweb:     http://git.kernel.org/tip/37aeec36220c39f1b2e7118287d951fd9cfdd6b7
Author:     Maxime Bizon <mbizon@freebox.fr>
AuthorDate: Mon, 29 Oct 2012 14:40:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:16:47 +0100

x86/ce4100: Fix PCI configuration register access for devices without interrupts

Some CE4100 devices such as the:

 - DFX module (01:0b.7)
 - entertainment encryption device (01:10.0)
 - multimedia controller (01:12.0)

do not have a device interrupt at all.

This patch fixes the PCI controller code to declare the missing
PCI configuration register space, as well as a fixup method for
forcing the interrupt pin to be 0 for these devices. This is
required to ensure that pci drivers matching on these devices
will be able to honor the various PCI subsystem calls touching
the configuration space.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: rui.zhang@intel.com
Cc: alan@linux.intel.com
Link: http://lkml.kernel.org/r/1351518020-25556-4-git-send-email-ffainelli@freebox.fr
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/pci/ce4100.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index 41bd2a2..b914e20 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -115,6 +115,16 @@ static void sata_revid_read(struct sim_dev_reg *reg, u32 *value)
 	reg_read(reg, value);
 }
 
+static void reg_noirq_read(struct sim_dev_reg *reg, u32 *value)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	/* force interrupt pin value to 0 */
+	*value = reg->sim_reg.value & 0xfff00ff;
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
+
 static struct sim_dev_reg bus1_fixups[] = {
 	DEFINE_REG(2, 0, 0x10, (16*MB), reg_init, reg_read, reg_write)
 	DEFINE_REG(2, 0, 0x14, (256), reg_init, reg_read, reg_write)
@@ -144,6 +154,7 @@ static struct sim_dev_reg bus1_fixups[] = {
 	DEFINE_REG(11, 5, 0x10, (64*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(11, 6, 0x10, (256), reg_init, reg_read, reg_write)
 	DEFINE_REG(11, 7, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 7, 0x3c, 256, reg_init, reg_noirq_read, reg_write)
 	DEFINE_REG(12, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(12, 0, 0x14, (256), reg_init, reg_read, reg_write)
 	DEFINE_REG(12, 1, 0x10, (1024), reg_init, reg_read, reg_write)
@@ -161,8 +172,10 @@ static struct sim_dev_reg bus1_fixups[] = {
 	DEFINE_REG(16, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(16, 0, 0x14, (64*MB), reg_init, reg_read, reg_write)
 	DEFINE_REG(16, 0, 0x18, (64*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x3c, 256, reg_init, reg_noirq_read, reg_write)
 	DEFINE_REG(17, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(18, 0, 0x10, (1*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(18, 0, 0x3c, 256, reg_init, reg_noirq_read, reg_write)
 };
 
 static void __init init_sim_regs(void)
