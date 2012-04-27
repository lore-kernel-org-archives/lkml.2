Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab2D0MZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:25:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40735 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab2D0MZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:25:00 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Aneesh V <aneesh@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 7/7] memory: emif: add debugfs entries for emif
Date: Fri, 27 Apr 2012 17:54:09 +0530
Message-ID: <1335529449-28046-8-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
References: <y>
 <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh V <aneesh@ti.com>

Add debug entries for:
	1. calculated registers per frequency
	2. last polled value of MR4(temperature level
	   of LPDDR2 memory)

Signed-off-by: Aneesh V <aneesh@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Benoit Cousson <b-cousson@ti.com>
[santosh.shilimkar@ti.com: Moved to drivers/memory from drivers/misc]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Greg KH <greg@kroah.com>
---
 drivers/memory/emif.c |  138 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 138 insertions(+), 0 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 3dfffbb..33a4396 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/list.h>
@@ -47,6 +48,7 @@
  *				frequency change (i.e. corresponding to the
  *				frequency in effect at the moment)
  * @plat_data:			Pointer to saved platform data.
+ * @debugfs_root:		dentry to the root folder for EMIF in debugfs
  */
 struct emif_data {
 	u8				duplicate;
@@ -60,6 +62,7 @@ struct emif_data {
 	struct emif_regs		*regs_cache[EMIF_MAX_NUM_FREQUENCIES];
 	struct emif_regs		*curr_regs;
 	struct emif_platform_data	*plat_data;
+	struct dentry			*debugfs_root;
 };
 
 static struct emif_data *emif1;
@@ -68,6 +71,130 @@ static unsigned long	irq_state;
 static u32		t_ck; /* DDR clock period in ps */
 static LIST_HEAD(device_list);
 
+static void do_emif_regdump_show(struct seq_file *s, struct emif_data *emif,
+	struct emif_regs *regs)
+{
+	u32 type = emif->plat_data->device_info->type;
+	u32 ip_rev = emif->plat_data->ip_rev;
+
+	seq_printf(s, "EMIF register cache dump for %dMHz\n",
+		regs->freq/1000000);
+
+	seq_printf(s, "ref_ctrl_shdw\t: 0x%08x\n", regs->ref_ctrl_shdw);
+	seq_printf(s, "sdram_tim1_shdw\t: 0x%08x\n", regs->sdram_tim1_shdw);
+	seq_printf(s, "sdram_tim2_shdw\t: 0x%08x\n", regs->sdram_tim2_shdw);
+	seq_printf(s, "sdram_tim3_shdw\t: 0x%08x\n", regs->sdram_tim3_shdw);
+
+	if (ip_rev == EMIF_4D) {
+		seq_printf(s, "read_idle_ctrl_shdw_normal\t: 0x%08x\n",
+			regs->read_idle_ctrl_shdw_normal);
+		seq_printf(s, "read_idle_ctrl_shdw_volt_ramp\t: 0x%08x\n",
+			regs->read_idle_ctrl_shdw_volt_ramp);
+	} else if (ip_rev == EMIF_4D5) {
+		seq_printf(s, "dll_calib_ctrl_shdw_normal\t: 0x%08x\n",
+			regs->dll_calib_ctrl_shdw_normal);
+		seq_printf(s, "dll_calib_ctrl_shdw_volt_ramp\t: 0x%08x\n",
+			regs->dll_calib_ctrl_shdw_volt_ramp);
+	}
+
+	if (type == DDR_TYPE_LPDDR2_S2 || type == DDR_TYPE_LPDDR2_S4) {
+		seq_printf(s, "ref_ctrl_shdw_derated\t: 0x%08x\n",
+			regs->ref_ctrl_shdw_derated);
+		seq_printf(s, "sdram_tim1_shdw_derated\t: 0x%08x\n",
+			regs->sdram_tim1_shdw_derated);
+		seq_printf(s, "sdram_tim3_shdw_derated\t: 0x%08x\n",
+			regs->sdram_tim3_shdw_derated);
+	}
+}
+
+static int emif_regdump_show(struct seq_file *s, void *unused)
+{
+	struct emif_data	*emif	= s->private;
+	struct emif_regs	**regs_cache;
+	int			i;
+
+	if (emif->duplicate)
+		regs_cache = emif1->regs_cache;
+	else
+		regs_cache = emif->regs_cache;
+
+	for (i = 0; i < EMIF_MAX_NUM_FREQUENCIES && regs_cache[i]; i++) {
+		do_emif_regdump_show(s, emif, regs_cache[i]);
+		seq_printf(s, "\n");
+	}
+
+	return 0;
+}
+
+static int emif_regdump_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, emif_regdump_show, inode->i_private);
+}
+
+static const struct file_operations emif_regdump_fops = {
+	.open			= emif_regdump_open,
+	.read			= seq_read,
+	.release		= single_release,
+};
+
+static int emif_mr4_show(struct seq_file *s, void *unused)
+{
+	struct emif_data *emif = s->private;
+
+	seq_printf(s, "MR4=%d\n", emif->temperature_level);
+	return 0;
+}
+
+static int emif_mr4_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, emif_mr4_show, inode->i_private);
+}
+
+static const struct file_operations emif_mr4_fops = {
+	.open			= emif_mr4_open,
+	.read			= seq_read,
+	.release		= single_release,
+};
+
+static int __init_or_module emif_debugfs_init(struct emif_data *emif)
+{
+	struct dentry	*dentry;
+	int		ret;
+
+	dentry = debugfs_create_dir(dev_name(emif->dev), NULL);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto err0;
+	}
+	emif->debugfs_root = dentry;
+
+	dentry = debugfs_create_file("regcache_dump", S_IRUGO,
+			emif->debugfs_root, emif, &emif_regdump_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto err1;
+	}
+
+	dentry = debugfs_create_file("mr4", S_IRUGO,
+			emif->debugfs_root, emif, &emif_mr4_fops);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
+		goto err1;
+	}
+
+	return 0;
+err1:
+	debugfs_remove_recursive(emif->debugfs_root);
+err0:
+	return ret;
+}
+
+static void __exit emif_debugfs_exit(struct emif_data *emif)
+{
+	debugfs_remove_recursive(emif->debugfs_root);
+	emif->debugfs_root = NULL;
+}
+
 /*
  * Calculate the period of DDR clock from frequency value
  */
@@ -1175,6 +1302,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	}
 
 	emif_onetime_settings(emif);
+	emif_debugfs_init(emif);
 	disable_and_clear_all_interrupts(emif);
 	setup_interrupts(emif, irq);
 
@@ -1198,6 +1326,15 @@ error:
 	return -ENODEV;
 }
 
+static int __exit emif_remove(struct platform_device *pdev)
+{
+	struct emif_data *emif = platform_get_drvdata(pdev);
+
+	emif_debugfs_exit(emif);
+
+	return 0;
+}
+
 static void emif_shutdown(struct platform_device *pdev)
 {
 	struct emif_data	*emif = platform_get_drvdata(pdev);
@@ -1508,6 +1645,7 @@ static void __attribute__((unused)) freq_post_notify_handling(void)
 }
 
 static struct platform_driver emif_driver = {
+	.remove		= __exit_p(emif_remove),
 	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
-- 
1.7.5.4

