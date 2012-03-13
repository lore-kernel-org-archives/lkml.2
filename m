Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030210Ab2CMJrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:47:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48524 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302Ab2CMJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:46:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="169647446"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2 3/3] simple_open: Automatically convert to simple_open()
Date: Tue, 13 Mar 2012 02:46:28 -0700
Message-Id: <1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
References: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many users of debugfs copy the implementation of default_open()
when they want to support a custom read/write function op. This
leads to a proliferation of the default_open() implementation
across the entire tree. Now that the common implementation has
been consolidated into libfs we can replace all the users of this
function with simple_open().

This replacement was done with the following semantic patch:

<smpl>
@ open @
identifier open_f != simple_open;
identifier i, f;
@@
-int open_f(struct inode *i, struct file *f)
-{
(
-if (i->i_private)
-f->private_data = i->i_private;
|
-f->private_data = i->i_private;
)
-return 0;
-}

@ has_open depends on open @
identifier fops;
identifier open.open_f;
@@
struct file_operations fops = {
...
-.open = open_f,
+.open = simple_open,
...
};
</smpl>

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/mach-msm/smd_debug.c                   |    8 +----
 arch/arm/plat-mxc/audmux-v2.c                   |    8 +----
 arch/x86/kernel/kdebugfs.c                      |    9 +----
 drivers/acpi/ec_sys.c                           |    8 +----
 drivers/base/regmap/regmap-debugfs.c            |   12 ++-----
 drivers/bluetooth/btmrvl_debugfs.c              |   26 ++++++--------
 drivers/char/virtio_console.c                   |    8 +----
 drivers/dma/coh901318.c                         |    9 +----
 drivers/gpu/drm/i915/i915_debugfs.c             |   14 ++------
 drivers/hid/hid-picolcd.c                       |   22 ++----------
 drivers/hid/hid-wiimote-debug.c                 |    8 +----
 drivers/idle/i7300_idle.c                       |    8 +----
 drivers/iommu/omap-iommu-debug.c                |   10 ++----
 drivers/mfd/aat2870-core.c                      |    9 +----
 drivers/mfd/ab3100-core.c                       |    8 +----
 drivers/misc/ibmasm/ibmasmfs.c                  |    8 +----
 drivers/mtd/ubi/debug.c                         |   10 +-----
 drivers/net/caif/caif_spi.c                     |   10 ++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   12 +------
 drivers/net/wimax/i2400m/debugfs.c              |   15 ++------
 drivers/net/wireless/ath/ath5k/debug.c          |   23 +++++-------
 drivers/net/wireless/ath/ath6kl/debug.c         |   44 ++++++++++-------------
 drivers/net/wireless/ath/ath9k/debug.c          |   37 +++++++++----------
 drivers/net/wireless/ath/ath9k/dfs_debug.c      |    9 +----
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |   26 ++++++--------
 drivers/net/wireless/ath/ath9k/rc.c             |    8 +----
 drivers/net/wireless/ath/carl9170/debug.c       |    7 +---
 drivers/net/wireless/b43/debugfs.c              |    8 +----
 drivers/net/wireless/b43legacy/debugfs.c        |    8 +----
 drivers/net/wireless/iwlegacy/3945-rs.c         |    8 +----
 drivers/net/wireless/iwlegacy/4965-rs.c         |   12 ++-----
 drivers/net/wireless/iwlegacy/debug.c           |   12 ++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   11 ++----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   12 ++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c   |   12 ++-----
 drivers/net/wireless/iwmc3200wifi/debugfs.c     |   14 +++-----
 drivers/net/wireless/iwmc3200wifi/sdio.c        |    9 +----
 drivers/net/wireless/libertas/debugfs.c         |    8 +----
 drivers/net/wireless/mwifiex/debugfs.c          |   18 ++--------
 drivers/net/wireless/wl1251/debugfs.c           |   10 ++----
 drivers/net/wireless/wl12xx/debugfs.c           |   34 ++++++++----------
 drivers/oprofile/oprofilefs.c                   |   14 ++------
 drivers/remoteproc/remoteproc_debugfs.c         |   13 ++-----
 drivers/scsi/lpfc/lpfc_debugfs.c                |    9 +----
 drivers/spi/spi-dw.c                            |    8 +----
 drivers/tty/serial/mfd.c                        |    9 ++---
 drivers/tty/serial/pch_uart.c                   |    8 ++---
 drivers/usb/core/inode.c                        |   10 +-----
 drivers/usb/host/ehci-dbg.c                     |    9 +----
 drivers/uwb/uwb-debug.c                         |    9 +----
 fs/debugfs/file.c                               |   14 ++------
 fs/dlm/debug_fs.c                               |   12 +------
 fs/pstore/inode.c                               |    8 +----
 kernel/trace/blktrace.c                         |   18 ++--------
 net/mac80211/debugfs.c                          |   16 +++------
 net/wireless/debugfs.c                          |    8 +----
 sound/soc/soc-core.c                            |    8 +----
 sound/soc/soc-dapm.c                            |   16 ++-------
 58 files changed, 167 insertions(+), 574 deletions(-)

diff --git a/arch/arm/mach-msm/smd_debug.c b/arch/arm/mach-msm/smd_debug.c
index 0c56a5a..c56df9e 100644
--- a/arch/arm/mach-msm/smd_debug.c
+++ b/arch/arm/mach-msm/smd_debug.c
@@ -203,15 +203,9 @@ static ssize_t debug_read(struct file *file, char __user *buf,
 	return simple_read_from_buffer(buf, count, ppos, debug_buffer, bsize);
 }
 
-static int debug_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static const struct file_operations debug_ops = {
 	.read = debug_read,
-	.open = debug_open,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/arch/arm/plat-mxc/audmux-v2.c b/arch/arm/plat-mxc/audmux-v2.c
index 0e51fc3..5caff94 100644
--- a/arch/arm/plat-mxc/audmux-v2.c
+++ b/arch/arm/plat-mxc/audmux-v2.c
@@ -33,12 +33,6 @@ static void __iomem *audmux_base;
 #ifdef CONFIG_DEBUG_FS
 static struct dentry *audmux_debugfs_root;
 
-static int audmux_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 /* There is an annoying discontinuity in the SSI numbering with regard
  * to the Linux number of the devices */
 static const char *audmux_port_string(int port)
@@ -135,7 +129,7 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations audmux_debugfs_fops = {
-	.open = audmux_open_file,
+	.open = simple_open,
 	.read = audmux_read_file,
 	.llseek = default_llseek,
 };
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 90fcf62..1d5d31e 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -68,16 +68,9 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
 	return count;
 }
 
-static int setup_data_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations fops_setup_data = {
 	.read		= setup_data_read,
-	.open		= setup_data_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index b258cab..7586544 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -27,12 +27,6 @@ MODULE_PARM_DESC(write_support, "Dangerous, reboot and removal of battery may "
 
 static struct dentry *acpi_ec_debugfs_dir;
 
-static int acpi_ec_open_io(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 static ssize_t acpi_ec_read_io(struct file *f, char __user *buf,
 			       size_t count, loff_t *off)
 {
@@ -95,7 +89,7 @@ static ssize_t acpi_ec_write_io(struct file *f, const char __user *buf,
 
 static const struct file_operations acpi_ec_io_ops = {
 	.owner = THIS_MODULE,
-	.open  = acpi_ec_open_io,
+	.open  = simple_open,
 	.read  = acpi_ec_read_io,
 	.write = acpi_ec_write_io,
 	.llseek = default_llseek,
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 372f81a..4e9bc84 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -26,12 +26,6 @@ static size_t regmap_calc_reg_len(int max_val, char *buf, size_t buf_size)
 	return strlen(buf);
 }
 
-static int regmap_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t regmap_name_read_file(struct file *file,
 				     char __user *user_buf, size_t count,
 				     loff_t *ppos)
@@ -56,7 +50,7 @@ static ssize_t regmap_name_read_file(struct file *file,
 }
 
 static const struct file_operations regmap_name_fops = {
-	.open = regmap_open_file,
+	.open = simple_open,
 	.read = regmap_name_read_file,
 	.llseek = default_llseek,
 };
@@ -173,7 +167,7 @@ static ssize_t regmap_map_write_file(struct file *file,
 #endif
 
 static const struct file_operations regmap_map_fops = {
-	.open = regmap_open_file,
+	.open = simple_open,
 	.read = regmap_map_read_file,
 	.write = regmap_map_write_file,
 	.llseek = default_llseek,
@@ -242,7 +236,7 @@ out:
 }
 
 static const struct file_operations regmap_access_fops = {
-	.open = regmap_open_file,
+	.open = simple_open,
 	.read = regmap_access_read_file,
 	.llseek = default_llseek,
 };
diff --git a/drivers/bluetooth/btmrvl_debugfs.c b/drivers/bluetooth/btmrvl_debugfs.c
index 3497347..72e43a2 100644
--- a/drivers/bluetooth/btmrvl_debugfs.c
+++ b/drivers/bluetooth/btmrvl_debugfs.c
@@ -45,12 +45,6 @@ struct btmrvl_debugfs_data {
 	struct dentry *txdnldready;
 };
 
-static int btmrvl_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t btmrvl_hscfgcmd_write(struct file *file,
 			const char __user *ubuf, size_t count, loff_t *ppos)
 {
@@ -93,7 +87,7 @@ static ssize_t btmrvl_hscfgcmd_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_hscfgcmd_fops = {
 	.read	= btmrvl_hscfgcmd_read,
 	.write	= btmrvl_hscfgcmd_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -134,7 +128,7 @@ static ssize_t btmrvl_psmode_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_psmode_fops = {
 	.read	= btmrvl_psmode_read,
 	.write	= btmrvl_psmode_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -180,7 +174,7 @@ static ssize_t btmrvl_pscmd_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_pscmd_fops = {
 	.read = btmrvl_pscmd_read,
 	.write = btmrvl_pscmd_write,
-	.open = btmrvl_open_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -221,7 +215,7 @@ static ssize_t btmrvl_gpiogap_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_gpiogap_fops = {
 	.read	= btmrvl_gpiogap_read,
 	.write	= btmrvl_gpiogap_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -265,7 +259,7 @@ static ssize_t btmrvl_hscmd_read(struct file *file, char __user *userbuf,
 static const struct file_operations btmrvl_hscmd_fops = {
 	.read	= btmrvl_hscmd_read,
 	.write	= btmrvl_hscmd_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -305,7 +299,7 @@ static ssize_t btmrvl_hsmode_read(struct file *file, char __user * userbuf,
 static const struct file_operations btmrvl_hsmode_fops = {
 	.read	= btmrvl_hsmode_read,
 	.write	= btmrvl_hsmode_write,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -323,7 +317,7 @@ static ssize_t btmrvl_curpsmode_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations btmrvl_curpsmode_fops = {
 	.read	= btmrvl_curpsmode_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -341,7 +335,7 @@ static ssize_t btmrvl_psstate_read(struct file *file, char __user * userbuf,
 
 static const struct file_operations btmrvl_psstate_fops = {
 	.read	= btmrvl_psstate_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -359,7 +353,7 @@ static ssize_t btmrvl_hsstate_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations btmrvl_hsstate_fops = {
 	.read	= btmrvl_hsstate_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
@@ -378,7 +372,7 @@ static ssize_t btmrvl_txdnldready_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations btmrvl_txdnldready_fops = {
 	.read	= btmrvl_txdnldready_read,
-	.open	= btmrvl_open_generic,
+	.open	= simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index b58b561..ddf86b6 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1038,12 +1038,6 @@ static struct attribute_group port_attribute_group = {
 	.attrs = port_sysfs_entries,
 };
 
-static int debugfs_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t debugfs_read(struct file *filp, char __user *ubuf,
 			    size_t count, loff_t *offp)
 {
@@ -1087,7 +1081,7 @@ static ssize_t debugfs_read(struct file *filp, char __user *ubuf,
 
 static const struct file_operations port_debugfs_ops = {
 	.owner = THIS_MODULE,
-	.open  = debugfs_open,
+	.open  = simple_open,
 	.read  = debugfs_read,
 };
 
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index d65a718..a63badc 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -104,13 +104,6 @@ static void coh901318_list_print(struct coh901318_chan *cohc,
 static struct coh901318_base *debugfs_dma_base;
 static struct dentry *dma_dentry;
 
-static int coh901318_debugfs_open(struct inode *inode, struct file *file)
-{
-
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int coh901318_debugfs_read(struct file *file, char __user *buf,
 				  size_t count, loff_t *f_pos)
 {
@@ -158,7 +151,7 @@ static int coh901318_debugfs_read(struct file *file, char __user *buf,
 
 static const struct file_operations coh901318_debugfs_status_operations = {
 	.owner		= THIS_MODULE,
-	.open		= coh901318_debugfs_open,
+	.open		= simple_open,
 	.read		= coh901318_debugfs_read,
 	.llseek		= default_llseek,
 };
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index fdb7cce..b505b70 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1502,14 +1502,6 @@ static int i915_ppgtt_info(struct seq_file *m, void *data)
 	return 0;
 }
 
-static int
-i915_debugfs_common_open(struct inode *inode,
-			 struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t
 i915_wedged_read(struct file *filp,
 		 char __user *ubuf,
@@ -1560,7 +1552,7 @@ i915_wedged_write(struct file *filp,
 
 static const struct file_operations i915_wedged_fops = {
 	.owner = THIS_MODULE,
-	.open = i915_debugfs_common_open,
+	.open = simple_open,
 	.read = i915_wedged_read,
 	.write = i915_wedged_write,
 	.llseek = default_llseek,
@@ -1622,7 +1614,7 @@ i915_max_freq_write(struct file *filp,
 
 static const struct file_operations i915_max_freq_fops = {
 	.owner = THIS_MODULE,
-	.open = i915_debugfs_common_open,
+	.open = simple_open,
 	.read = i915_max_freq_read,
 	.write = i915_max_freq_write,
 	.llseek = default_llseek,
@@ -1693,7 +1685,7 @@ i915_cache_sharing_write(struct file *filp,
 
 static const struct file_operations i915_cache_sharing_fops = {
 	.owner = THIS_MODULE,
-	.open = i915_debugfs_common_open,
+	.open = simple_open,
 	.read = i915_cache_sharing_read,
 	.write = i915_cache_sharing_write,
 	.llseek = default_llseek,
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 12f9777..07c6507 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1522,15 +1522,6 @@ static const struct file_operations picolcd_debug_reset_fops = {
 	.release  = single_release,
 };
 
-/*
- * The "eeprom" file
- */
-static int picolcd_debug_eeprom_open(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 static ssize_t picolcd_debug_eeprom_read(struct file *f, char __user *u,
 		size_t s, loff_t *off)
 {
@@ -1618,21 +1609,12 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
  */
 static const struct file_operations picolcd_debug_eeprom_fops = {
 	.owner    = THIS_MODULE,
-	.open     = picolcd_debug_eeprom_open,
+	.open     = simple_open,
 	.read     = picolcd_debug_eeprom_read,
 	.write    = picolcd_debug_eeprom_write,
 	.llseek   = generic_file_llseek,
 };
 
-/*
- * The "flash" file
- */
-static int picolcd_debug_flash_open(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 /* record a flash address to buf (bounds check to be done by caller) */
 static int _picolcd_flash_setaddr(struct picolcd_data *data, u8 *buf, long off)
 {
@@ -1817,7 +1799,7 @@ static ssize_t picolcd_debug_flash_write(struct file *f, const char __user *u,
  */
 static const struct file_operations picolcd_debug_flash_fops = {
 	.owner    = THIS_MODULE,
-	.open     = picolcd_debug_flash_open,
+	.open     = simple_open,
 	.read     = picolcd_debug_flash_read,
 	.write    = picolcd_debug_flash_write,
 	.llseek   = generic_file_llseek,
diff --git a/drivers/hid/hid-wiimote-debug.c b/drivers/hid/hid-wiimote-debug.c
index 17dabc1..eec3291 100644
--- a/drivers/hid/hid-wiimote-debug.c
+++ b/drivers/hid/hid-wiimote-debug.c
@@ -23,12 +23,6 @@ struct wiimote_debug {
 	struct dentry *drm;
 };
 
-static int wiidebug_eeprom_open(struct inode *i, struct file *f)
-{
-	f->private_data = i->i_private;
-	return 0;
-}
-
 static ssize_t wiidebug_eeprom_read(struct file *f, char __user *u, size_t s,
 								loff_t *off)
 {
@@ -83,7 +77,7 @@ static ssize_t wiidebug_eeprom_read(struct file *f, char __user *u, size_t s,
 
 static const struct file_operations wiidebug_eeprom_fops = {
 	.owner = THIS_MODULE,
-	.open = wiidebug_eeprom_open,
+	.open = simple_open,
 	.read = wiidebug_eeprom_read,
 	.llseek = generic_file_llseek,
 };
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index c976285..fa080eb 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -516,12 +516,6 @@ static struct notifier_block i7300_idle_nb = {
 
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
-int stats_open_generic(struct inode *inode, struct file *fp)
-{
-	fp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t stats_read_ul(struct file *fp, char __user *ubuf, size_t count,
 				loff_t *off)
 {
@@ -534,7 +528,7 @@ static ssize_t stats_read_ul(struct file *fp, char __user *ubuf, size_t count,
 }
 
 static const struct file_operations idle_fops = {
-	.open	= stats_open_generic,
+	.open	= simple_open,
 	.read	= stats_read_ul,
 	.llseek = default_llseek,
 };
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index 103dbd9..f55fc5d 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -323,15 +323,9 @@ err_out:
 	return count;
 }
 
-static int debug_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUG_FOPS(name)						\
 	static const struct file_operations debug_##name##_fops = {	\
-		.open = debug_open_generic,				\
+		.open = simple_open,					\
 		.read = debug_read_##name,				\
 		.write = debug_write_##name,				\
 		.llseek = generic_file_llseek,				\
@@ -339,7 +333,7 @@ static int debug_open_generic(struct inode *inode, struct file *file)
 
 #define DEBUG_FOPS_RO(name)						\
 	static const struct file_operations debug_##name##_fops = {	\
-		.open = debug_open_generic,				\
+		.open = simple_open,					\
 		.read = debug_read_##name,				\
 		.llseek = generic_file_llseek,				\
 	};
diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 3aa36eb..44a3fdb 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -262,13 +262,6 @@ static ssize_t aat2870_dump_reg(struct aat2870_data *aat2870, char *buf)
 	return count;
 }
 
-static int aat2870_reg_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t aat2870_reg_read_file(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
@@ -330,7 +323,7 @@ static ssize_t aat2870_reg_write_file(struct file *file,
 }
 
 static const struct file_operations aat2870_reg_fops = {
-	.open = aat2870_reg_open_file,
+	.open = simple_open,
 	.read = aat2870_reg_read_file,
 	.write = aat2870_reg_write_file,
 };
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 60107ee..1efad20 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -483,12 +483,6 @@ struct ab3100_get_set_reg_priv {
 	bool mode;
 };
 
-static int ab3100_get_set_reg_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t ab3100_get_set_reg(struct file *file,
 				  const char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -583,7 +577,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 }
 
 static const struct file_operations ab3100_get_set_reg_fops = {
-	.open = ab3100_get_set_reg_open_file,
+	.open = simple_open,
 	.write = ab3100_get_set_reg,
 	.llseek = noop_llseek,
 };
diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index 1c034b8..6673e57 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -500,12 +500,6 @@ static ssize_t r_heartbeat_file_write(struct file *file, const char __user *buf,
 	return 1;
 }
 
-static int remote_settings_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int remote_settings_file_close(struct inode *inode, struct file *file)
 {
 	return 0;
@@ -600,7 +594,7 @@ static const struct file_operations r_heartbeat_fops = {
 };
 
 static const struct file_operations remote_settings_fops = {
-	.open =		remote_settings_file_open,
+	.open =		simple_open,
 	.release =	remote_settings_file_close,
 	.read =		remote_settings_file_read,
 	.write =	remote_settings_file_write,
diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index e2cdebf..61af9bb 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -386,19 +386,11 @@ out:
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 /* File operations for all UBI debugfs files */
 static const struct file_operations dfs_fops = {
 	.read   = dfs_file_read,
 	.write  = dfs_file_write,
-	.open   = default_open,
+	.open	= simple_open,
 	.llseek = no_llseek,
 	.owner  = THIS_MODULE,
 };
diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index 96391c3..b71ce9b 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -127,12 +127,6 @@ static inline void dev_debugfs_rem(struct cfspi *cfspi)
 	debugfs_remove(cfspi->dbgfs_dir);
 }
 
-static int dbgfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t dbgfs_state(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -243,13 +237,13 @@ static ssize_t dbgfs_frame(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations dbgfs_state_fops = {
-	.open = dbgfs_open,
+	.open = simple_open,
 	.read = dbgfs_state,
 	.owner = THIS_MODULE
 };
 
 static const struct file_operations dbgfs_frame_fops = {
-	.open = dbgfs_open,
+	.open = simple_open,
 	.read = dbgfs_frame,
 	.owner = THIS_MODULE
 };
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 1d88942..b999838 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1995,16 +1995,6 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.flash_device      = set_flash,
 };
 
-/*
- * debugfs support
- */
-
-static int mem_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t mem_read(struct file *file, char __user *buf, size_t count,
 			loff_t *ppos)
 {
@@ -2048,7 +2038,7 @@ static ssize_t mem_read(struct file *file, char __user *buf, size_t count,
 
 static const struct file_operations mem_debugfs_fops = {
 	.owner   = THIS_MODULE,
-	.open    = mem_open,
+	.open    = simple_open,
 	.read    = mem_read,
 	.llseek  = default_llseek,
 };
diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 129ba36..4b66ab1 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -53,17 +53,6 @@ struct dentry *debugfs_create_netdev_queue_stopped(
 				   &fops_netdev_queue_stopped);
 }
 
-
-/*
- * inode->i_private has the @data argument to debugfs_create_file()
- */
-static
-int i2400m_stats_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 /*
  * We don't allow partial reads of this file, as then the reader would
  * get weirdly confused data as it is updated.
@@ -117,7 +106,7 @@ ssize_t i2400m_rx_stats_write(struct file *filp, const char __user *buffer,
 static
 const struct file_operations i2400m_rx_stats_fops = {
 	.owner =	THIS_MODULE,
-	.open =		i2400m_stats_open,
+	.open =		simple_open,
 	.read =		i2400m_rx_stats_read,
 	.write =	i2400m_rx_stats_write,
 	.llseek =	default_llseek,
@@ -170,7 +159,7 @@ ssize_t i2400m_tx_stats_write(struct file *filp, const char __user *buffer,
 static
 const struct file_operations i2400m_tx_stats_fops = {
 	.owner =	THIS_MODULE,
-	.open =		i2400m_stats_open,
+	.open =		simple_open,
 	.read =		i2400m_tx_stats_read,
 	.write =	i2400m_tx_stats_write,
 	.llseek =	default_llseek,
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 8c5ce8b..e5e8f45 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -71,13 +71,6 @@ static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
 
 
-static int ath5k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-
 /* debugfs: registers */
 
 struct reg {
@@ -265,7 +258,7 @@ static ssize_t write_file_beacon(struct file *file,
 static const struct file_operations fops_beacon = {
 	.read = read_file_beacon,
 	.write = write_file_beacon,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -285,7 +278,7 @@ static ssize_t write_file_reset(struct file *file,
 
 static const struct file_operations fops_reset = {
 	.write = write_file_reset,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = noop_llseek,
 };
@@ -365,7 +358,7 @@ static ssize_t write_file_debug(struct file *file,
 static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -477,7 +470,7 @@ static ssize_t write_file_antenna(struct file *file,
 static const struct file_operations fops_antenna = {
 	.read = read_file_antenna,
 	.write = write_file_antenna,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -532,7 +525,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_misc = {
 	.read = read_file_misc,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 };
 
@@ -647,7 +640,7 @@ static ssize_t write_file_frameerrors(struct file *file,
 static const struct file_operations fops_frameerrors = {
 	.read = read_file_frameerrors,
 	.write = write_file_frameerrors,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -810,7 +803,7 @@ static ssize_t write_file_ani(struct file *file,
 static const struct file_operations fops_ani = {
 	.read = read_file_ani,
 	.write = write_file_ani,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -881,7 +874,7 @@ static ssize_t write_file_queue(struct file *file,
 static const struct file_operations fops_queue = {
 	.read = read_file_queue,
 	.write = write_file_queue,
-	.open = ath5k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index d832058..5f1dacb 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -217,12 +217,6 @@ void dump_cred_dist_stats(struct htc_target *target)
 		   target->credit_info->cur_free_credits);
 }
 
-static int ath6kl_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 void ath6kl_debug_war(struct ath6kl *ar, enum ath6kl_war war)
 {
 	switch (war) {
@@ -263,7 +257,7 @@ static ssize_t read_file_war_stats(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_war_stats = {
 	.read = read_file_war_stats,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -376,7 +370,7 @@ static ssize_t ath6kl_fwlog_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations fops_fwlog = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_fwlog_read,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -415,7 +409,7 @@ static ssize_t ath6kl_fwlog_mask_write(struct file *file,
 }
 
 static const struct file_operations fops_fwlog_mask = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_fwlog_mask_read,
 	.write = ath6kl_fwlog_mask_write,
 	.owner = THIS_MODULE,
@@ -561,7 +555,7 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_tgt_stats = {
 	.read = read_file_tgt_stats,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -626,7 +620,7 @@ static ssize_t read_file_credit_dist_stats(struct file *file,
 
 static const struct file_operations fops_credit_dist_stats = {
 	.read = read_file_credit_dist_stats,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -725,7 +719,7 @@ static ssize_t ath6kl_endpoint_stats_write(struct file *file,
 }
 
 static const struct file_operations fops_endpoint_stats = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_endpoint_stats_read,
 	.write = ath6kl_endpoint_stats_write,
 	.owner = THIS_MODULE,
@@ -806,7 +800,7 @@ static ssize_t ath6kl_regread_write(struct file *file,
 static const struct file_operations fops_diag_reg_read = {
 	.read = ath6kl_regread_read,
 	.write = ath6kl_regread_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -937,7 +931,7 @@ static ssize_t ath6kl_lrssi_roam_read(struct file *file,
 static const struct file_operations fops_lrssi_roam_threshold = {
 	.read = ath6kl_lrssi_roam_read,
 	.write = ath6kl_lrssi_roam_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -999,7 +993,7 @@ static ssize_t ath6kl_regwrite_write(struct file *file,
 static const struct file_operations fops_diag_reg_write = {
 	.read = ath6kl_regwrite_read,
 	.write = ath6kl_regwrite_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1104,7 +1098,7 @@ static ssize_t ath6kl_roam_table_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_roam_table = {
 	.read = ath6kl_roam_table_read,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1142,7 +1136,7 @@ static ssize_t ath6kl_force_roam_write(struct file *file,
 
 static const struct file_operations fops_force_roam = {
 	.write = ath6kl_force_roam_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1182,7 +1176,7 @@ static ssize_t ath6kl_roam_mode_write(struct file *file,
 
 static const struct file_operations fops_roam_mode = {
 	.write = ath6kl_roam_mode_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1224,7 +1218,7 @@ static ssize_t ath6kl_keepalive_write(struct file *file,
 }
 
 static const struct file_operations fops_keepalive = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_keepalive_read,
 	.write = ath6kl_keepalive_write,
 	.owner = THIS_MODULE,
@@ -1269,7 +1263,7 @@ static ssize_t ath6kl_disconnect_timeout_write(struct file *file,
 }
 
 static const struct file_operations fops_disconnect_timeout = {
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.read = ath6kl_disconnect_timeout_read,
 	.write = ath6kl_disconnect_timeout_write,
 	.owner = THIS_MODULE,
@@ -1450,7 +1444,7 @@ static ssize_t ath6kl_create_qos_write(struct file *file,
 
 static const struct file_operations fops_create_qos = {
 	.write = ath6kl_create_qos_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1498,7 +1492,7 @@ static ssize_t ath6kl_delete_qos_write(struct file *file,
 
 static const struct file_operations fops_delete_qos = {
 	.write = ath6kl_delete_qos_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1531,7 +1525,7 @@ static ssize_t ath6kl_bgscan_int_write(struct file *file,
 
 static const struct file_operations fops_bgscan_int = {
 	.write = ath6kl_bgscan_int_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1584,7 +1578,7 @@ static ssize_t ath6kl_listen_int_read(struct file *file,
 static const struct file_operations fops_listen_int = {
 	.read = ath6kl_listen_int_read,
 	.write = ath6kl_listen_int_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1644,7 +1638,7 @@ static ssize_t ath6kl_power_params_write(struct file *file,
 
 static const struct file_operations fops_power_params = {
 	.write = ath6kl_power_params_write,
-	.open = ath6kl_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 228c181..5d6ecd4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -26,11 +26,6 @@
 #define REG_READ_D(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
-static int ath9k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static ssize_t ath9k_debugfs_read_buf(struct file *file, char __user *user_buf,
 				      size_t count, loff_t *ppos)
@@ -83,7 +78,7 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -129,7 +124,7 @@ static ssize_t write_file_tx_chainmask(struct file *file, const char __user *use
 static const struct file_operations fops_tx_chainmask = {
 	.read = read_file_tx_chainmask,
 	.write = write_file_tx_chainmask,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -172,7 +167,7 @@ static ssize_t write_file_rx_chainmask(struct file *file, const char __user *use
 static const struct file_operations fops_rx_chainmask = {
 	.read = read_file_rx_chainmask,
 	.write = write_file_rx_chainmask,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -223,7 +218,7 @@ static ssize_t write_file_disable_ani(struct file *file,
 static const struct file_operations fops_disable_ani = {
 	.read = read_file_disable_ani,
 	.write = write_file_disable_ani,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -324,7 +319,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_dma = {
 	.read = read_file_dma,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -446,7 +441,7 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_interrupt = {
 	.read = read_file_interrupt,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -850,28 +845,28 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 
 static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
 static const struct file_operations fops_stations = {
 	.read = read_file_stations,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
 static const struct file_operations fops_misc = {
 	.read = read_file_misc,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
 static const struct file_operations fops_reset = {
 	.read = read_file_reset,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1042,7 +1037,7 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 
 static const struct file_operations fops_recv = {
 	.read = read_file_recv,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1081,7 +1076,7 @@ static ssize_t write_file_regidx(struct file *file, const char __user *user_buf,
 static const struct file_operations fops_regidx = {
 	.read = read_file_regidx,
 	.write = write_file_regidx,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1128,7 +1123,7 @@ static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
 static const struct file_operations fops_regval = {
 	.read = read_file_regval,
 	.write = write_file_regval,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1217,7 +1212,7 @@ static ssize_t read_file_dump_nfcal(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_dump_nfcal = {
 	.read = read_file_dump_nfcal,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1245,7 +1240,7 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_base_eeprom = {
 	.read = read_file_base_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1273,7 +1268,7 @@ static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_modal_eeprom = {
 	.read = read_file_modal_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 106d031..4364c10 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -60,16 +60,9 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	return retval;
 }
 
-static int ath9k_dfs_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations fops_dfs_stats = {
 	.read = read_file_dfs,
-	.open = ath9k_dfs_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index d3ff33c..3035deb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -16,12 +16,6 @@
 
 #include "htc.h"
 
-static int ath9k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t read_file_tgt_int_stats(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
@@ -75,7 +69,7 @@ static ssize_t read_file_tgt_int_stats(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_tgt_int_stats = {
 	.read = read_file_tgt_int_stats,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -145,7 +139,7 @@ static ssize_t read_file_tgt_tx_stats(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_tgt_tx_stats = {
 	.read = read_file_tgt_tx_stats,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -191,7 +185,7 @@ static ssize_t read_file_tgt_rx_stats(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_tgt_rx_stats = {
 	.read = read_file_tgt_rx_stats,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -243,7 +237,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_xmit = {
 	.read = read_file_xmit,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -364,7 +358,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_recv = {
 	.read = read_file_recv,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -399,7 +393,7 @@ static ssize_t read_file_slot(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_slot = {
 	.read = read_file_slot,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -446,7 +440,7 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_queue = {
 	.read = read_file_queue,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -487,7 +481,7 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 static const struct file_operations fops_debug = {
 	.read = read_file_debug,
 	.write = write_file_debug,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -636,7 +630,7 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_base_eeprom = {
 	.read = read_file_base_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -917,7 +911,7 @@ static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_modal_eeprom = {
 	.read = read_file_modal_eeprom,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index b8c6c38..70b78d3 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1480,12 +1480,6 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 
-static int ath9k_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
@@ -1553,7 +1547,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_rcstat = {
 	.read = read_file_rcstat,
-	.open = ath9k_debugfs_open,
+	.open = simple_open,
 	.owner = THIS_MODULE
 };
 
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 3c16422..93fe600 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -48,11 +48,6 @@
 #define ADD(buf, off, max, fmt, args...)				\
 	off += snprintf(&buf[off], max - off, fmt, ##args);
 
-static int carl9170_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 struct carl9170_debugfs_fops {
 	unsigned int read_bufsize;
@@ -178,7 +173,7 @@ static const struct carl9170_debugfs_fops carl_debugfs_##name ##_ops = {\
 	.attr = _attr,							\
 	.req_dev_state = _dstate,					\
 	.fops = {							\
-		.open	= carl9170_debugfs_open,			\
+		.open	= simple_open,					\
 		.read	= carl9170_debugfs_read,			\
 		.write	= carl9170_debugfs_write,			\
 		.owner	= THIS_MODULE					\
diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/b43/debugfs.c
index e751fde..e807bd9 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -500,12 +500,6 @@ out:
 
 #undef fappend
 
-static int b43_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
@@ -624,7 +618,7 @@ out_unlock:
 		.read	= _read,				\
 		.write	= _write,				\
 		.fops	= {					\
-			.open	= b43_debugfs_open,		\
+			.open	= simple_open,			\
 			.read	= b43_debugfs_read,		\
 			.write	= b43_debugfs_write,		\
 			.llseek = generic_file_llseek,		\
diff --git a/drivers/net/wireless/b43legacy/debugfs.c b/drivers/net/wireless/b43legacy/debugfs.c
index 5e28ad0..1965edb 100644
--- a/drivers/net/wireless/b43legacy/debugfs.c
+++ b/drivers/net/wireless/b43legacy/debugfs.c
@@ -197,12 +197,6 @@ static int restart_write_file(struct b43legacy_wldev *dev, const char *buf, size
 
 #undef fappend
 
-static int b43legacy_debugfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
@@ -331,7 +325,7 @@ out_unlock:
 		.read	= _read,				\
 		.write	= _write,				\
 		.fops	= {					\
-			.open	= b43legacy_debugfs_open,		\
+			.open	= simple_open,				\
 			.read	= b43legacy_debugfs_read,		\
 			.write	= b43legacy_debugfs_write,		\
 			.llseek = generic_file_llseek,			\
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 70bee1a..4b10157 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -821,12 +821,6 @@ out:
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int
-il3945_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static ssize_t
 il3945_sta_dbgfs_stats_table_read(struct file *file, char __user *user_buf,
@@ -862,7 +856,7 @@ il3945_sta_dbgfs_stats_table_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il3945_sta_dbgfs_stats_table_read,
-	.open = il3945_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index d7e2856..11ab124 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2518,12 +2518,6 @@ il4965_rs_free_sta(void *il_r, struct ieee80211_sta *sta, void *il_sta)
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int
-il4965_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static void
 il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta, u32 * rate_n_flags, int idx)
@@ -2695,7 +2689,7 @@ il4965_rs_sta_dbgfs_scale_table_read(struct file *file, char __user *user_buf,
 static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = il4965_rs_sta_dbgfs_scale_table_write,
 	.read = il4965_rs_sta_dbgfs_scale_table_read,
-	.open = il4965_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -2740,7 +2734,7 @@ il4965_rs_sta_dbgfs_stats_table_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il4965_rs_sta_dbgfs_stats_table_read,
-	.open = il4965_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -2768,7 +2762,7 @@ il4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = il4965_rs_sta_dbgfs_rate_scale_data_read,
-	.open = il4965_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 2298491..eff2650 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -160,18 +160,12 @@ static ssize_t il_dbgfs_##name##_write(struct file *file,              \
 					const char __user *user_buf,    \
 					size_t count, loff_t *ppos);
 
-static int
-il_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 #define DEBUGFS_READ_FILE_OPS(name)				\
 	DEBUGFS_READ_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
-	.open = il_dbgfs_open_file_generic,			\
+	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
 };
 
@@ -179,7 +173,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	DEBUGFS_WRITE_FUNC(name);				\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
-	.open = il_dbgfs_open_file_generic,			\
+	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
 };
 
@@ -189,7 +183,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
 	.read = il_dbgfs_##name##_read,				\
-	.open = il_dbgfs_open_file_generic,			\
+	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a7d6713..b4f279a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -3087,11 +3087,6 @@ static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 			     u32 *rate_n_flags, int index)
 {
@@ -3230,7 +3225,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.write = rs_sta_dbgfs_scale_table_write,
 	.read = rs_sta_dbgfs_scale_table_read,
-	.open = open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
@@ -3273,7 +3268,7 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
-	.open = open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -3299,7 +3294,7 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = rs_sta_dbgfs_rate_scale_data_read,
-	.open = open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ad74138e..a5fd98a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -85,17 +85,11 @@ static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
 					size_t count, loff_t *ppos);
 
 
-static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_READ_FILE_OPS(name)                                     \
 	DEBUGFS_READ_FUNC(name);                                        \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,                       		\
-	.open = iwl_dbgfs_open_file_generic,                    	\
+	.open = simple_opesimple_open,                    		\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -103,7 +97,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
-	.open = iwl_dbgfs_open_file_generic,                    	\
+	.open = simple_open,                    			\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -114,7 +108,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.read = iwl_dbgfs_##name##_read,                                \
-	.open = iwl_dbgfs_open_file_generic,                            \
+	.open = simple_open,                            		\
 	.llseek = generic_file_llseek,					\
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 9f8b239..26eacd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1916,17 +1916,11 @@ static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
 					size_t count, loff_t *ppos);
 
 
-static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_READ_FILE_OPS(name)					\
 	DEBUGFS_READ_FUNC(name);					\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -1934,7 +1928,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -1944,7 +1938,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = iwl_dbgfs_##name##_write,				\
 	.read = iwl_dbgfs_##name##_read,				\
-	.open = iwl_dbgfs_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index 87eef57..b6199d1 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -99,12 +99,6 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_iwm_dbg_modules,
 			iwm_debugfs_u32_read, iwm_debugfs_dbg_modules_write,
 			"%llu\n");
 
-static int iwm_generic_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 
 static ssize_t iwm_debugfs_txq_read(struct file *filp, char __user *buffer,
 				   size_t count, loff_t *ppos)
@@ -401,28 +395,28 @@ out:
 
 static const struct file_operations iwm_debugfs_txq_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_txq_read,
 	.llseek =	default_llseek,
 };
 
 static const struct file_operations iwm_debugfs_tx_credit_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_tx_credit_read,
 	.llseek =	default_llseek,
 };
 
 static const struct file_operations iwm_debugfs_rx_ticket_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_rx_ticket_read,
 	.llseek =	default_llseek,
 };
 
 static const struct file_operations iwm_debugfs_fw_err_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_generic_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_fw_err_read,
 	.llseek =	default_llseek,
 };
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index 764b40d..0042f20 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -264,13 +264,6 @@ static int if_sdio_send_chunk(struct iwm_priv *iwm, u8 *buf, int count)
 	return ret;
 }
 
-/* debugfs hooks */
-static int iwm_debugfs_sdio_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t iwm_debugfs_sdio_read(struct file *filp, char __user *buffer,
 				     size_t count, loff_t *ppos)
 {
@@ -363,7 +356,7 @@ err:
 
 static const struct file_operations iwm_debugfs_sdio_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_debugfs_sdio_open,
+	.open =		simple_open,
 	.read =		iwm_debugfs_sdio_read,
 	.llseek =	default_llseek,
 };
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index c192671..118062c 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -21,12 +21,6 @@ static char *szStates[] = {
 static void lbs_debug_init(struct lbs_private *priv);
 #endif
 
-static int open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t write_file_dummy(struct file *file, const char __user *buf,
                                 size_t count, loff_t *ppos)
 {
@@ -962,7 +956,7 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 
 static const struct file_operations lbs_debug_fops = {
 	.owner = THIS_MODULE,
-	.open = open_file_generic,
+	.open = simple_open,
 	.write = lbs_debugfs_write,
 	.read = lbs_debugfs_read,
 	.llseek = default_llseek,
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index d26a78b..1a84507 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -140,18 +140,6 @@ static struct mwifiex_debug_data items[] = {
 static int num_of_items = ARRAY_SIZE(items);
 
 /*
- * Generic proc file open handler.
- *
- * This function is called every time a file is accessed for read or write.
- */
-static int
-mwifiex_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-/*
  * Proc info file read handler.
  *
  * This function is called when the 'info' file is opened for reading.
@@ -676,19 +664,19 @@ done:
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
 	.write = mwifiex_##name##_write,                                \
-	.open = mwifiex_open_generic,                                   \
+	.open = simple_open,                                            \
 };
 
 #define MWIFIEX_DFS_FILE_READ_OPS(name)                                 \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
-	.open = mwifiex_open_generic,                                   \
+	.open = simple_open,                                            \
 };
 
 #define MWIFIEX_DFS_FILE_WRITE_OPS(name)                                \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.write = mwifiex_##name##_write,                                \
-	.open = mwifiex_open_generic,                                   \
+	.open = simple_open,                                            \
 };
 
 
diff --git a/drivers/net/wireless/wl1251/debugfs.c b/drivers/net/wireless/wl1251/debugfs.c
index 6c27400..80a911c 100644
--- a/drivers/net/wireless/wl1251/debugfs.c
+++ b/drivers/net/wireless/wl1251/debugfs.c
@@ -117,12 +117,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1251_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, 20, "%u");
 
 DEBUGFS_FWSTATS_FILE(rx, out_of_mem, 20, "%u");
@@ -235,7 +229,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
-	.open = wl1251_open_file_generic,
+	.open = simple_open,
 	.llseek = generic_file_llseek,
 };
 
@@ -257,7 +251,7 @@ static ssize_t tx_queue_status_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations tx_queue_status_ops = {
 	.read = tx_queue_status_read,
-	.open = wl1251_open_file_generic,
+	.open = simple_open,
 	.llseek = generic_file_llseek,
 };
 
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index e1cf727..0c7547c 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -126,12 +126,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1271_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, "%u");
 
 DEBUGFS_FWSTATS_FILE(rx, out_of_mem, "%u");
@@ -243,7 +237,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -289,7 +283,7 @@ static ssize_t gpio_power_write(struct file *file,
 static const struct file_operations gpio_power_ops = {
 	.read = gpio_power_read,
 	.write = gpio_power_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -308,7 +302,7 @@ static ssize_t start_recovery_write(struct file *file,
 
 static const struct file_operations start_recovery_ops = {
 	.write = start_recovery_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -372,7 +366,7 @@ out:
 static const struct file_operations dynamic_ps_timeout_ops = {
 	.read = dynamic_ps_timeout_read,
 	.write = dynamic_ps_timeout_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -441,7 +435,7 @@ out:
 static const struct file_operations forced_ps_ops = {
 	.read = forced_ps_read,
 	.write = forced_ps_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -483,7 +477,7 @@ static ssize_t split_scan_timeout_write(struct file *file,
 static const struct file_operations split_scan_timeout_ops = {
 	.read = split_scan_timeout_read,
 	.write = split_scan_timeout_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -566,7 +560,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations driver_state_ops = {
 	.read = driver_state_read,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -675,7 +669,7 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 
 static const struct file_operations vifs_state_ops = {
 	.read = vifs_state_read,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -733,7 +727,7 @@ static ssize_t dtim_interval_write(struct file *file,
 static const struct file_operations dtim_interval_ops = {
 	.read = dtim_interval_read,
 	.write = dtim_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -791,7 +785,7 @@ static ssize_t suspend_dtim_interval_write(struct file *file,
 static const struct file_operations suspend_dtim_interval_ops = {
 	.read = suspend_dtim_interval_read,
 	.write = suspend_dtim_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -849,7 +843,7 @@ static ssize_t beacon_interval_write(struct file *file,
 static const struct file_operations beacon_interval_ops = {
 	.read = beacon_interval_read,
 	.write = beacon_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -904,7 +898,7 @@ static ssize_t rx_streaming_interval_read(struct file *file,
 static const struct file_operations rx_streaming_interval_ops = {
 	.read = rx_streaming_interval_read,
 	.write = rx_streaming_interval_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -959,7 +953,7 @@ static ssize_t rx_streaming_always_read(struct file *file,
 static const struct file_operations rx_streaming_always_ops = {
 	.read = rx_streaming_always_read,
 	.write = rx_streaming_always_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -1003,7 +997,7 @@ out:
 
 static const struct file_operations beacon_filtering_ops = {
 	.write = beacon_filtering_write,
-	.open = wl1271_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index ee8fd03..849357c 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -117,25 +117,17 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
 }
 
 
-static int default_open(struct inode *inode, struct file *filp)
-{
-	if (inode->i_private)
-		filp->private_data = inode->i_private;
-	return 0;
-}
-
-
 static const struct file_operations ulong_fops = {
 	.read		= ulong_read_file,
 	.write		= ulong_write_file,
-	.open		= default_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
 
 static const struct file_operations ulong_ro_fops = {
 	.read		= ulong_read_file,
-	.open		= default_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
@@ -187,7 +179,7 @@ static ssize_t atomic_read_file(struct file *file, char __user *buf, size_t coun
 
 static const struct file_operations atomic_ro_fops = {
 	.read		= atomic_read_file,
-	.open		= default_open,
+	.open		= simple_open,
 	.llseek		= default_llseek,
 };
 
diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 70277a5..85d31a6 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -50,16 +50,9 @@ static ssize_t rproc_trace_read(struct file *filp, char __user *userbuf,
 	return simple_read_from_buffer(userbuf, count, ppos, trace->va, len);
 }
 
-static int rproc_open_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations trace_rproc_ops = {
 	.read = rproc_trace_read,
-	.open = rproc_open_generic,
+	.open = simple_open,
 	.llseek	= generic_file_llseek,
 };
 
@@ -94,7 +87,7 @@ static ssize_t rproc_state_read(struct file *filp, char __user *userbuf,
 
 static const struct file_operations rproc_state_ops = {
 	.read = rproc_state_read,
-	.open = rproc_open_generic,
+	.open = simple_open,
 	.llseek	= generic_file_llseek,
 };
 
@@ -114,7 +107,7 @@ static ssize_t rproc_name_read(struct file *filp, char __user *userbuf,
 
 static const struct file_operations rproc_name_ops = {
 	.read = rproc_name_read,
-	.open = rproc_open_generic,
+	.open = simple_open,
 	.llseek	= generic_file_llseek,
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 22e17be..34f7cf7 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -997,13 +997,6 @@ lpfc_debugfs_dumpDataDif_write(struct file *file, const char __user *buf,
 	return nbytes;
 }
 
-static int
-lpfc_debugfs_dif_err_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t
 lpfc_debugfs_dif_err_read(struct file *file, char __user *buf,
 	size_t nbytes, loff_t *ppos)
@@ -3521,7 +3514,7 @@ static const struct file_operations lpfc_debugfs_op_dumpDif = {
 #undef lpfc_debugfs_op_dif_err
 static const struct file_operations lpfc_debugfs_op_dif_err = {
 	.owner =	THIS_MODULE,
-	.open =		lpfc_debugfs_dif_err_open,
+	.open =		simple_open,
 	.llseek =	lpfc_debugfs_lseek,
 	.read =		lpfc_debugfs_dif_err_read,
 	.write =	lpfc_debugfs_dif_err_write,
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 082458d..d1a495f 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -63,12 +63,6 @@ struct chip_data {
 };
 
 #ifdef CONFIG_DEBUG_FS
-static int spi_show_regs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define SPI_REGS_BUFSIZE	1024
 static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -128,7 +122,7 @@ static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
 
 static const struct file_operations mrst_spi_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= spi_show_regs_open,
+	.open		= simple_open,
 	.read		= spi_show_regs,
 	.llseek		= default_llseek,
 };
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index a9234ba..c4b50af 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -127,11 +127,6 @@ static inline void serial_out(struct uart_hsu_port *up, int offset, int value)
 
 #define HSU_REGS_BUFSIZE	1024
 
-static int hsu_show_regs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
 
 static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -231,14 +226,14 @@ static ssize_t dma_show_regs(struct file *file, char __user *user_buf,
 
 static const struct file_operations port_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= hsu_show_regs_open,
+	.open		= simple_open,
 	.read		= port_show_regs,
 	.llseek		= default_llseek,
 };
 
 static const struct file_operations dma_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= hsu_show_regs_open,
+	.open		= simple_open,
 	.read		= dma_show_regs,
 	.llseek		= default_llseek,
 };
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index aa4d07b..4a248a1 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -300,11 +300,7 @@ static const int trigger_level_1[4] = { 1, 1, 1, 1 };
 #ifdef CONFIG_DEBUG_FS
 
 #define PCH_REGS_BUFSIZE	1024
-static int pch_show_regs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
+
 
 static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -358,7 +354,7 @@ static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 
 static const struct file_operations port_regs_ops = {
 	.owner		= THIS_MODULE,
-	.open		= pch_show_regs_open,
+	.open		= simple_open,
 	.read		= port_show_regs,
 	.llseek		= default_llseek,
 };
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 06c175a..ca8c77d 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -429,18 +429,10 @@ static loff_t default_file_lseek (struct file *file, loff_t offset, int orig)
 	return retval;
 }
 
-static int default_open (struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static const struct file_operations default_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	default_file_lseek,
 };
 
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index fd9109d..680e1a3 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -352,7 +352,6 @@ static int debug_async_open(struct inode *, struct file *);
 static int debug_periodic_open(struct inode *, struct file *);
 static int debug_registers_open(struct inode *, struct file *);
 static int debug_async_open(struct inode *, struct file *);
-static int debug_lpm_open(struct inode *, struct file *);
 static ssize_t debug_lpm_read(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos);
 static ssize_t debug_lpm_write(struct file *file, const char __user *buffer,
@@ -385,7 +384,7 @@ static const struct file_operations debug_registers_fops = {
 };
 static const struct file_operations debug_lpm_fops = {
 	.owner		= THIS_MODULE,
-	.open		= debug_lpm_open,
+	.open		= simple_open,
 	.read		= debug_lpm_read,
 	.write		= debug_lpm_write,
 	.release	= debug_lpm_close,
@@ -970,12 +969,6 @@ static int debug_registers_open(struct inode *inode, struct file *file)
 	return file->private_data ? 0 : -ENOMEM;
 }
 
-static int debug_lpm_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int debug_lpm_close(struct inode *inode, struct file *file)
 {
 	return 0;
diff --git a/drivers/uwb/uwb-debug.c b/drivers/uwb/uwb-debug.c
index 2eecec0..6ec45be 100644
--- a/drivers/uwb/uwb-debug.c
+++ b/drivers/uwb/uwb-debug.c
@@ -159,13 +159,6 @@ static int cmd_ie_rm(struct uwb_rc *rc, struct uwb_dbg_cmd_ie *ie_to_rm)
 	return uwb_rc_ie_rm(rc, ie_to_rm->data[0]);
 }
 
-static int command_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t command_write(struct file *file, const char __user *buf,
 			 size_t len, loff_t *off)
 {
@@ -206,7 +199,7 @@ static ssize_t command_write(struct file *file, const char __user *buf,
 }
 
 static const struct file_operations command_fops = {
-	.open   = command_open,
+	.open	= simple_open,
 	.write  = command_write,
 	.read   = NULL,
 	.llseek = no_llseek,
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index ef023ee..6644968 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -33,18 +33,10 @@ static ssize_t default_write_file(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
 const struct file_operations debugfs_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	noop_llseek,
 };
 
@@ -447,7 +439,7 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 static const struct file_operations fops_bool = {
 	.read =		read_file_bool,
 	.write =	write_file_bool,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	default_llseek,
 };
 
@@ -492,7 +484,7 @@ static ssize_t read_file_blob(struct file *file, char __user *user_buf,
 
 static const struct file_operations fops_blob = {
 	.read =		read_file_blob,
-	.open =		default_open,
+	.open =		simple_open,
 	.llseek =	default_llseek,
 };
 
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 3dca2b3..3d44eda 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -606,16 +606,6 @@ static const struct file_operations format3_fops = {
 	.release = seq_release
 };
 
-/*
- * dump lkb's on the ls_waiters list
- */
-
-static int waiters_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t waiters_read(struct file *file, char __user *userbuf,
 			    size_t count, loff_t *ppos)
 {
@@ -644,7 +634,7 @@ static ssize_t waiters_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations waiters_fops = {
 	.owner   = THIS_MODULE,
-	.open    = waiters_open,
+	.open    = simple_open,
 	.read    = waiters_read,
 	.llseek  = default_llseek,
 };
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index f37c32b..8ae5a03 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -52,12 +52,6 @@ struct pstore_private {
 	char	data[];
 };
 
-static int pstore_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 						size_t count, loff_t *ppos)
 {
@@ -67,7 +61,7 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 }
 
 static const struct file_operations pstore_file_operations = {
-	.open	= pstore_file_open,
+	.open	= simple_open,
 	.read	= pstore_file_read,
 	.llseek	= default_llseek,
 };
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index cdea7b5..c0bd030 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -311,13 +311,6 @@ int blk_trace_remove(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_trace_remove);
 
-static int blk_dropped_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 				size_t count, loff_t *ppos)
 {
@@ -331,18 +324,11 @@ static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 
 static const struct file_operations blk_dropped_fops = {
 	.owner =	THIS_MODULE,
-	.open =		blk_dropped_open,
+	.open =		simple_open,
 	.read =		blk_dropped_read,
 	.llseek =	default_llseek,
 };
 
-static int blk_msg_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-
-	return 0;
-}
-
 static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 				size_t count, loff_t *ppos)
 {
@@ -371,7 +357,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 
 static const struct file_operations blk_msg_fops = {
 	.owner =	THIS_MODULE,
-	.open =		blk_msg_open,
+	.open =		simple_open,
 	.write =	blk_msg_write,
 	.llseek =	noop_llseek,
 };
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 483e96e..1537e95 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -15,12 +15,6 @@
 #include "rate.h"
 #include "debugfs.h"
 
-int mac80211_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_FORMAT_BUFFER_SIZE 100
 
 int mac80211_format_buffer(char __user *userbuf, size_t count,
@@ -50,7 +44,7 @@ static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 #define DEBUGFS_READONLY_FILE_OPS(name)			\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -93,7 +87,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 
 static const struct file_operations reset_ops = {
 	.write = reset_write,
-	.open = mac80211_open_file_generic,
+	.open = simple_open,
 	.llseek = noop_llseek,
 };
 
@@ -128,7 +122,7 @@ static ssize_t uapsd_queues_write(struct file *file,
 static const struct file_operations uapsd_queues_ops = {
 	.read = uapsd_queues_read,
 	.write = uapsd_queues_write,
-	.open = mac80211_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -172,7 +166,7 @@ static ssize_t uapsd_max_sp_len_write(struct file *file,
 static const struct file_operations uapsd_max_sp_len_ops = {
 	.read = uapsd_max_sp_len_read,
 	.write = uapsd_max_sp_len_write,
-	.open = mac80211_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
@@ -333,7 +327,7 @@ static ssize_t stats_ ##name## _read(struct file *file,			\
 									\
 static const struct file_operations stats_ ##name## _ops = {		\
 	.read = stats_ ##name## _read,					\
-	.open = mac80211_open_file_generic,				\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 39765bc..7077ac3 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -13,12 +13,6 @@
 #include "core.h"
 #include "debugfs.h"
 
-static int cfg80211_open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 #define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -102,7 +96,7 @@ static ssize_t ht40allow_map_read(struct file *file,
 
 static const struct file_operations ht40allow_map_ops = {
 	.read = ht40allow_map_read,
-	.open = cfg80211_open_file_generic,
+	.open = simple_open,
 	.llseek = default_llseek,
 };
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 1bdc67e..d30c0929 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -201,12 +201,6 @@ static ssize_t pmdown_time_set(struct device *dev,
 static DEVICE_ATTR(pmdown_time, 0644, pmdown_time_show, pmdown_time_set);
 
 #ifdef CONFIG_DEBUG_FS
-static int codec_reg_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t codec_reg_read_file(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -264,7 +258,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 }
 
 static const struct file_operations codec_reg_fops = {
-	.open = codec_reg_open_file,
+	.open = simple_open,
 	.read = codec_reg_read_file,
 	.write = codec_reg_write_file,
 	.llseek = default_llseek,
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 91e4b69..1bc7290 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1544,12 +1544,6 @@ static int dapm_power_widgets(struct snd_soc_dapm_context *dapm, int event)
 }
 
 #ifdef CONFIG_DEBUG_FS
-static int dapm_widget_power_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t dapm_widget_power_read_file(struct file *file,
 					   char __user *user_buf,
 					   size_t count, loff_t *ppos)
@@ -1612,17 +1606,11 @@ static ssize_t dapm_widget_power_read_file(struct file *file,
 }
 
 static const struct file_operations dapm_widget_power_fops = {
-	.open = dapm_widget_power_open_file,
+	.open = simple_open,
 	.read = dapm_widget_power_read_file,
 	.llseek = default_llseek,
 };
 
-static int dapm_bias_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t dapm_bias_read_file(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1653,7 +1641,7 @@ static ssize_t dapm_bias_read_file(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations dapm_bias_fops = {
-	.open = dapm_bias_open_file,
+	.open = simple_open,
 	.read = dapm_bias_read_file,
 	.llseek = default_llseek,
 };
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

