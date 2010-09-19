Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0ISH2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:28:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48790 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751103Ab0ISH2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:28:35 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19JGCgntAxJ4Jcr2gSr/3r7ZyG1arkWOPnh5XkrVp
	Y8IVNLyIazANyX
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/12] viafb: add a mapping of supported output devices
Date: Sun, 19 Sep 2010 07:39:55 +0000
Message-Id: <a20caff43626418b91187e476905ebc7cd974701.1284879533.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: add a mapping of supported output devices

This patch maps supported output devices to IGP versions. This list may
contain errors as most of it is derived of the driver source but it should
be correct enough to provide a good help. The devices are exported via a
proc entry in the same format as those showing the output devices per IGA.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/via/viafbdev.c |   48 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index ce6f13a..17f228a 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -56,6 +56,31 @@ static int viafb_pan_display(struct fb_var_screeninfo *var,
 
 static struct fb_ops viafb_ops;
 
+/* supported output devices on each IGP
+ * only CX700, VX800, VX855 were documented
+ * VIA_CRT should be everywhere
+ * VIA_6C can be onle pre-CX700 (probably only on CLE266) as 6C is used for PLL
+ * source selection on CX700 and later
+ * K400 seems to support VIA_96, VIA_DVP1, VIA_LVDS{1,2} as in viamode.c
+ */
+static const u32 supported_odev_map[] = {
+	[UNICHROME_CLE266]	= VIA_CRT | VIA_6C | VIA_93,
+	[UNICHROME_K400]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_K800]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_PM800]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_CN700]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+				| VIA_LVDS2,
+	[UNICHROME_CX700]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_CN750]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_K8M890]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_P4M890]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_P4M900]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_VX800]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+	[UNICHROME_VX855]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
+};
 
 static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
 {
@@ -1433,6 +1458,26 @@ static const struct file_operations viafb_vt1636_proc_fops = {
 
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
+static int viafb_sup_odev_proc_show(struct seq_file *m, void *v)
+{
+	via_odev_to_seq(m, supported_odev_map[
+		viaparinfo->shared->chip_info.gfx_chip_name]);
+	return 0;
+}
+
+static int viafb_sup_odev_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_sup_odev_proc_show, NULL);
+}
+
+static const struct file_operations viafb_sup_odev_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_sup_odev_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static ssize_t odev_update(const char __user *buffer, size_t count, u32 *odev)
 {
 	char buf[64], *ptr = buf;
@@ -1561,6 +1606,8 @@ static void viafb_init_proc(struct viafb_shared *shared)
 		}
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
+		proc_create("supported_output_devices", 0, viafb_entry,
+			&viafb_sup_odev_proc_fops);
 		iga1_entry = proc_mkdir("iga1", viafb_entry);
 		shared->iga1_proc_entry = iga1_entry;
 		proc_create("output_devices", 0, iga1_entry,
@@ -1585,6 +1632,7 @@ static void viafb_remove_proc(struct viafb_shared *shared)
 	remove_proc_entry("iga2", viafb_entry);
 	remove_proc_entry("output_devices", iga1_entry);
 	remove_proc_entry("iga1", viafb_entry);
+	remove_proc_entry("supported_output_devices", viafb_entry);
 
 #ifdef CONFIG_FB_VIA_DIRECT_PROCFS
 	remove_proc_entry("dvp0", viafb_entry);/* parent dir */
-- 
1.6.3.2

