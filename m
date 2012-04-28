Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2D1UqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 16:46:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36741 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2D1Upw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 16:45:52 -0400
From: Alexander Tarasikov <alexander.tarasikov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Alexander Tarasikov <alexander.tarasikov@gmail.com>
Subject: [PATCH] drivers:gpu:vga_switcheroo: Work around dramatic power drain in laptops
Date: Sun, 29 Apr 2012 00:45:28 +0400
Message-Id: <1335645928-30993-2-git-send-email-alexander.tarasikov@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335645928-30993-1-git-send-email-alexander.tarasikov@gmail.com>
References: <1335645928-30993-1-git-send-email-alexander.tarasikov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Many laptop computers with switchable graphics that have an ATI
	Radeon graphics card ignore ACPI state for the discrete VGA
	and enable it on resume in spite of it being disabled by
	vga_switcheroo.

	That causes an extra power drain of around 10-15W and overheating after
	a suspend-resume cycle. A userspace-based workaround involving
	enabling and disabling the discrete card via debugfs has a major
	drawback - it causes long (around one minute) lockups because VGA BIOS
	is confused by the enable request.

	This patch adds an experimental module parameter that causes
	vga_switcheroo to disable all inactive VGA cards after a resume
	to save power and avoid lockups/GPU freezes. This has been tested
	on a Sony VAIO laptop with Intel HD3000 and Ati Radeon 6630M GPU.

Signed-off-by: Alexander Tarasikov <alexander.tarasikov@gmail.com>
---
 drivers/gpu/vga/vga_switcheroo.c |   71 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 58434e8..21b8e2c 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -490,3 +490,74 @@ err:
 }
 EXPORT_SYMBOL(vga_switcheroo_process_delayed_switch);
 
+#ifdef CONFIG_PM_SLEEP
+#include <linux/suspend.h>
+
+static int resume_powercut;
+module_param_named(resume_powercut, resume_powercut, int, 0400);
+MODULE_PARM_DESC(resume_powercut,
+	"Forcibly disable power to inactive VGA cards on resume."
+	" This is a workaround for laptops with ATI Radeon cards"
+	" which ignore ACPI state and cause extra 10W of power consumption");
+
+static int vga_switcheroo_notify(struct notifier_block *nb,
+	unsigned long mode, void *_unused)
+{
+	int i;
+
+	switch (mode) {
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		break;
+	default:
+		return 0;
+	}
+
+	mutex_lock(&vgasr_mutex);
+
+	if (!vgasr_priv.active) {
+		pr_info("vga_witcheroo: not active, ignoring notification\n");
+		goto out;
+	}
+
+	pr_debug("vga_switcheroo: disabling unused VGAs\n");
+	for (i = 0; i < VGA_SWITCHEROO_MAX_CLIENTS; i++) {
+		if (vgasr_priv.clients[i].active)
+			continue;
+		pr_info("vga_switcheroo: disabling VGA %d at resume\n", i);
+		vga_switchoff(&vgasr_priv.clients[i]);
+	}
+
+out:
+	mutex_unlock(&vgasr_mutex);
+
+	return 0;
+}
+
+static struct notifier_block vga_switcheroo_notifier_block = {
+	.notifier_call = vga_switcheroo_notify,
+};
+
+static int __init vga_switcheroo_pm_hack_init(void)
+{
+	int ret;
+
+	if (!resume_powercut)
+		return 0;
+
+	ret = register_pm_notifier(&vga_switcheroo_notifier_block);
+	if (ret)
+		pr_err("%s: failed to register pm notifier\n", __func__);
+
+	return ret;
+}
+
+static void __exit vga_switcheroo_pm_hack_exit(void)
+{
+	if (resume_powercut)
+		unregister_pm_notifier(&vga_switcheroo_notifier_block);
+}
+
+late_initcall(vga_switcheroo_pm_hack_init);
+module_exit(vga_switcheroo_pm_hack_exit);
+#endif
-- 
1.7.10

