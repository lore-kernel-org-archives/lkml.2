Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab0LEXKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:10:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0LEXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:10:05 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/21] ARM: tegra: irq: Add debugfs file to show wake irqs
Date: Sun,  5 Dec 2010 15:09:01 -0800
Message-Id: <1291590548-7341-15-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/irq.c |   66 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index ced7007..8f0ddc6 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -19,10 +19,12 @@
 
 #include <linux/kernel.h>
 #include <linux/delay.h>
+#include <linux/debugfs.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/seq_file.h>
 
 #include <asm/hardware/gic.h>
 
@@ -46,6 +48,8 @@ static u32 tegra_lp0_wake_enb;
 static u32 tegra_lp0_wake_level;
 static u32 tegra_lp0_wake_level_any;
 
+static unsigned int tegra_wake_irq_count[32];
+
 /* ensures that sufficient time is passed for a register write to
  * serialize into the 32KHz domain */
 static void pmc_32kwritel(u32 val, unsigned long offs)
@@ -165,6 +169,8 @@ static void tegra_irq_handle_wake(void)
 		pr_info("Resume caused by WAKE%d, %s\n", wake,
 			desc->action->name);
 
+		tegra_wake_irq_count[wake]++;
+
 		generic_handle_irq(irq);
 	}
 }
@@ -242,3 +248,63 @@ void tegra_irq_resume(void)
 	tegra_legacy_irq_resume();
 	tegra_irq_handle_wake();
 }
+
+#ifdef CONFIG_DEBUG_FS
+static int tegra_wake_irq_debug_show(struct seq_file *s, void *data)
+{
+	int wake;
+	int irq;
+	struct irq_desc *desc;
+	const char *irq_name;
+
+	seq_printf(s, "wake  irq  count  name\n");
+	seq_printf(s, "----------------------\n");
+	for (wake = 0; wake < 32; wake++) {
+		irq = tegra_wake_to_irq(wake);
+		if (irq < 0)
+			continue;
+
+		desc = irq_to_desc(irq);
+		if (tegra_wake_irq_count[wake] == 0 && desc->action == NULL)
+			continue;
+
+		if (!(desc->status & IRQ_WAKEUP))
+			continue;
+
+		irq_name = (desc->action && desc->action->name) ?
+			desc->action->name : "???";
+
+		seq_printf(s, "%4d  %3d  %5d  %s\n",
+			wake, irq, tegra_wake_irq_count[wake], irq_name);
+	}
+	return 0;
+}
+
+static int tegra_wake_irq_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tegra_wake_irq_debug_show, NULL);
+}
+
+static const struct file_operations tegra_wake_irq_debug_fops = {
+	.open		= tegra_wake_irq_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init tegra_irq_debug_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_create_file("wake_irq", 0755, NULL, NULL,
+		&tegra_wake_irq_debug_fops);
+	if (!d) {
+		pr_info("Failed to create suspend_mode debug file\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+late_initcall(tegra_irq_debug_init);
+#endif
-- 
1.7.3.1

