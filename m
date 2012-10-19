Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2JSLx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:53:27 -0400
Received: from zmc.proxad.net ([212.27.53.206]:53956 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686Ab2JSLxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:53:19 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: bigeasy@linutronix.de
Cc: linux-kernel@vger.kernel.org, x86@vger.kernel.org, mbizon@freebox.fr,
        Florian Fainelli <ffainelli@freebox.fr>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 3/3] x86: ce4100: fixup PCI configuration register access for devices without interrupts
Date: Fri, 19 Oct 2012 13:51:56 +0200
Message-Id: <1350647516-4842-4-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
References: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

Some CE4100 devices such as the:
- DFX module (01:0b.7)
- entertainment encryption device (01:10.0)
- multimedia controller (01:12.0)

do not have a device interrupt at all. This patch fixes the PCI controller
code to declare the missing PCI configuration register space, as well as a
fixup method for forcing the interrupt pin to be 0 for these devices. This is
required to ensure that pci drivers matching on these devices will be able to
call honor the various PCI subsystem calls touching the configuration space.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 arch/x86/pci/ce4100.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

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
-- 
1.7.9.5

