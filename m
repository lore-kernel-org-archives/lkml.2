Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0EMB30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:29:26 -0400
Received: from sous-sol.org ([216.99.217.87]:41384 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754843Ab0EMB3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:29:21 -0400
Date: Wed, 12 May 2010 18:28:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: greg@kroah.com, jbarnes@virtuousgeek.org, matthew@wil.cx
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: [PATCH 1/2] sysfs: add struct file* to bin_attr callbacks
Message-ID: <20100513012857.GA28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows bin_attr->read,write,mmap callbacks to check file specific data
(such as inode owner) as part of any privilege validation.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/alpha/kernel/pci-sysfs.c        |    8 ++++--
 arch/mips/txx9/generic/setup.c       |    4 +-
 arch/powerpc/sysdev/mv64x60_pci.c    |    4 +-
 arch/s390/kernel/ipl.c               |   14 ++++++-----
 drivers/acpi/system.c                |    2 +-
 drivers/base/firmware_class.c        |   11 +++++---
 drivers/firmware/dcdbas.c            |    4 +-
 drivers/firmware/dell_rbu.c          |   10 ++++----
 drivers/firmware/efivars.c           |    4 +-
 drivers/gpu/drm/drm_sysfs.c          |    5 ++-
 drivers/misc/c2port/core.c           |    4 +-
 drivers/misc/ds1682.c                |    6 +++-
 drivers/misc/eeprom/at24.c           |    6 +++-
 drivers/misc/eeprom/at25.c           |    6 +++-
 drivers/misc/eeprom/eeprom.c         |    3 +-
 drivers/misc/eeprom/max6875.c        |    2 +-
 drivers/net/netxen/netxen_nic_main.c |   11 +++++---
 drivers/net/qlcnic/qlcnic_main.c     |   12 ++++++---
 drivers/pci/hotplug/acpiphp_ibm.c    |    5 ++-
 drivers/pci/pci-sysfs.c              |   42 ++++++++++++++++++++++++---------
 drivers/pcmcia/cistpl.c              |    4 +-
 drivers/power/olpc_battery.c         |    2 +-
 drivers/rapidio/rio-sysfs.c          |    6 +++-
 drivers/rtc/rtc-cmos.c               |    6 +++-
 drivers/rtc/rtc-ds1305.c             |    6 +++-
 drivers/rtc/rtc-ds1307.c             |    6 +++-
 drivers/rtc/rtc-ds1511.c             |   10 +++++---
 drivers/rtc/rtc-ds1553.c             |    4 +-
 drivers/rtc/rtc-ds1742.c             |    4 +-
 drivers/rtc/rtc-m48t59.c             |    4 +-
 drivers/rtc/rtc-stk17ta8.c           |    4 +-
 drivers/rtc/rtc-tx4939.c             |    4 +-
 drivers/s390/cio/chp.c               |    5 ++-
 drivers/scsi/3w-sas.c                |    4 +-
 drivers/scsi/arcmsr/arcmsr_attr.c    |    9 +++++--
 drivers/scsi/ibmvscsi/ibmvfc.c       |    3 +-
 drivers/scsi/ipr.c                   |    9 +++++--
 drivers/scsi/lpfc/lpfc_attr.c        |   20 ++++++++++++----
 drivers/scsi/qla2xxx/qla_attr.c      |   32 +++++++++++++-------------
 drivers/staging/udlfb/udlfb.c        |    3 +-
 drivers/usb/core/sysfs.c             |    3 +-
 drivers/video/aty/radeon_base.c      |    4 +-
 drivers/w1/slaves/w1_ds2431.c        |    4 +-
 drivers/w1/slaves/w1_ds2433.c        |    4 +-
 drivers/w1/slaves/w1_ds2760.c        |    2 +-
 drivers/w1/w1.c                      |    4 +-
 drivers/zorro/zorro-sysfs.c          |    2 +-
 fs/sysfs/bin.c                       |   24 +++++++++----------
 include/linux/sysfs.h                |    6 ++--
 kernel/ksysfs.c                      |    3 +-
 kernel/module.c                      |    2 +-
 net/bridge/br_sysfs_br.c             |    2 +-
 52 files changed, 219 insertions(+), 149 deletions(-)

diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
index d979e7c..a5fffc8 100644
--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -53,6 +53,7 @@ static int __pci_mmap_fits(struct pci_dev *pdev, int num,
 
 /**
  * pci_mmap_resource - map a PCI resource into user memory space
+ * @filp: open sysfs file
  * @kobj: kobject for mapping
  * @attr: struct bin_attribute for the file being mapped
  * @vma: struct vm_area_struct passed into the mmap
@@ -60,7 +61,8 @@ static int __pci_mmap_fits(struct pci_dev *pdev, int num,
  *
  * Use the bus mapping routines to map a PCI resource into userspace.
  */
-static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
+static int pci_mmap_resource(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *attr,
 			     struct vm_area_struct *vma, int sparse)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
@@ -89,14 +91,14 @@ static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	return hose_mmap_page_range(pdev->sysdata, vma, mmap_type, sparse);
 }
 
-static int pci_mmap_resource_sparse(struct kobject *kobj,
+static int pci_mmap_resource_sparse(struct file *filp, struct kobject *kobj,
 				    struct bin_attribute *attr,
 				    struct vm_area_struct *vma)
 {
 	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
-static int pci_mmap_resource_dense(struct kobject *kobj,
+static int pci_mmap_resource_dense(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *attr,
 				   struct vm_area_struct *vma)
 {
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index adc6929..575d219 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -905,7 +905,7 @@ struct txx9_sramc_sysdev {
 	void __iomem *base;
 };
 
-static ssize_t txx9_sram_read(struct kobject *kobj,
+static ssize_t txx9_sram_read(struct file *filp, struct kobject *kobj,
 			      struct bin_attribute *bin_attr,
 			      char *buf, loff_t pos, size_t size)
 {
@@ -920,7 +920,7 @@ static ssize_t txx9_sram_read(struct kobject *kobj,
 	return size;
 }
 
-static ssize_t txx9_sram_write(struct kobject *kobj,
+static ssize_t txx9_sram_write(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t pos, size_t size)
 {
diff --git a/arch/powerpc/sysdev/mv64x60_pci.c b/arch/powerpc/sysdev/mv64x60_pci.c
index 1456015..198f288 100644
--- a/arch/powerpc/sysdev/mv64x60_pci.c
+++ b/arch/powerpc/sysdev/mv64x60_pci.c
@@ -24,7 +24,7 @@
 #define MV64X60_VAL_LEN_MAX		11
 #define MV64X60_PCICFG_CPCI_HOTSWAP	0x68
 
-static ssize_t mv64x60_hs_reg_read(struct kobject *kobj,
+static ssize_t mv64x60_hs_reg_read(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *attr, char *buf,
 				   loff_t off, size_t count)
 {
@@ -45,7 +45,7 @@ static ssize_t mv64x60_hs_reg_read(struct kobject *kobj,
 	return sprintf(buf, "0x%08x\n", v);
 }
 
-static ssize_t mv64x60_hs_reg_write(struct kobject *kobj,
+static ssize_t mv64x60_hs_reg_write(struct file *filp, struct kobject *kobj,
 				    struct bin_attribute *attr, char *buf,
 				    loff_t off, size_t count)
 {
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 72c8b0d..a689070 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -403,8 +403,9 @@ static ssize_t sys_ipl_device_show(struct kobject *kobj,
 static struct kobj_attribute sys_ipl_device_attr =
 	__ATTR(device, S_IRUGO, sys_ipl_device_show, NULL);
 
-static ssize_t ipl_parameter_read(struct kobject *kobj, struct bin_attribute *attr,
-				  char *buf, loff_t off, size_t count)
+static ssize_t ipl_parameter_read(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *attr, char *buf,
+				  loff_t off, size_t count)
 {
 	return memory_read_from_buffer(buf, count, &off, IPL_PARMBLOCK_START,
 					IPL_PARMBLOCK_SIZE);
@@ -419,8 +420,9 @@ static struct bin_attribute ipl_parameter_attr = {
 	.read = &ipl_parameter_read,
 };
 
-static ssize_t ipl_scp_data_read(struct kobject *kobj, struct bin_attribute *attr,
-				 char *buf, loff_t off, size_t count)
+static ssize_t ipl_scp_data_read(struct file *filp, struct kobject *kobj,
+				 struct bin_attribute *attr, char *buf,
+				 loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_START->ipl_info.fcp.scp_data_len;
 	void *scp_data = &IPL_PARMBLOCK_START->ipl_info.fcp.scp_data;
@@ -694,7 +696,7 @@ static struct kobj_attribute sys_reipl_ccw_vmparm_attr =
 
 /* FCP reipl device attributes */
 
-static ssize_t reipl_fcp_scpdata_read(struct kobject *kobj,
+static ssize_t reipl_fcp_scpdata_read(struct file *filp, struct kobject *kobj,
 				      struct bin_attribute *attr,
 				      char *buf, loff_t off, size_t count)
 {
@@ -704,7 +706,7 @@ static ssize_t reipl_fcp_scpdata_read(struct kobject *kobj,
 	return memory_read_from_buffer(buf, count, &off, scp_data, size);
 }
 
-static ssize_t reipl_fcp_scpdata_write(struct kobject *kobj,
+static ssize_t reipl_fcp_scpdata_write(struct file *filp, struct kobject *kobj,
 				       struct bin_attribute *attr,
 				       char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 4aaf249..6f7b960 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -71,7 +71,7 @@ struct acpi_table_attr {
 	struct list_head node;
 };
 
-static ssize_t acpi_table_show(struct kobject *kobj,
+static ssize_t acpi_table_show(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr, char *buf,
 			       loff_t offset, size_t count)
 {
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 985da11..ed7e3e8 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -207,8 +207,9 @@ static ssize_t firmware_loading_store(struct device *dev,
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
 static ssize_t
-firmware_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
-		   char *buffer, loff_t offset, size_t count)
+firmware_data_read(struct file *filp, struct kobject *kobj,
+		   struct bin_attribute *bin_attr, char *buffer, loff_t offset,
+		   size_t count)
 {
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
@@ -291,6 +292,7 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 
 /**
  * firmware_data_write - write method for firmware
+ * @filp: open sysfs file
  * @kobj: kobject for the device
  * @bin_attr: bin_attr structure
  * @buffer: buffer being written
@@ -301,8 +303,9 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
  *	the driver as a firmware image.
  **/
 static ssize_t
-firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
-		    char *buffer, loff_t offset, size_t count)
+firmware_data_write(struct file* filp, struct kobject *kobj,
+		    struct bin_attribute *bin_attr, char *buffer,
+		    loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index fb09bb3..aa9bc9e 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -149,7 +149,7 @@ static ssize_t smi_data_buf_size_store(struct device *dev,
 	return count;
 }
 
-static ssize_t smi_data_read(struct kobject *kobj,
+static ssize_t smi_data_read(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
@@ -162,7 +162,7 @@ static ssize_t smi_data_read(struct kobject *kobj,
 	return ret;
 }
 
-static ssize_t smi_data_write(struct kobject *kobj,
+static ssize_t smi_data_write(struct file *filp, struct kobject *kobj,
 			      struct bin_attribute *bin_attr,
 			      char *buf, loff_t pos, size_t count)
 {
diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index 3a44602..2f452f1 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -522,7 +522,7 @@ static ssize_t read_rbu_mono_data(char *buffer, loff_t pos, size_t count)
 			rbu_data.image_update_buffer, rbu_data.bios_image_size);
 }
 
-static ssize_t read_rbu_data(struct kobject *kobj,
+static ssize_t read_rbu_data(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buffer, loff_t pos, size_t count)
 {
@@ -576,7 +576,7 @@ static void callbackfn_rbu(const struct firmware *fw, void *context)
 	release_firmware(fw);
 }
 
-static ssize_t read_rbu_image_type(struct kobject *kobj,
+static ssize_t read_rbu_image_type(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t pos, size_t count)
 {
@@ -586,7 +586,7 @@ static ssize_t read_rbu_image_type(struct kobject *kobj,
 	return size;
 }
 
-static ssize_t write_rbu_image_type(struct kobject *kobj,
+static ssize_t write_rbu_image_type(struct file *filp, struct kobject *kobj,
 				    struct bin_attribute *bin_attr,
 				    char *buffer, loff_t pos, size_t count)
 {
@@ -647,7 +647,7 @@ static ssize_t write_rbu_image_type(struct kobject *kobj,
 	return rc;
 }
 
-static ssize_t read_rbu_packet_size(struct kobject *kobj,
+static ssize_t read_rbu_packet_size(struct file *filp, struct kobject *kobj,
 				    struct bin_attribute *bin_attr,
 				    char *buffer, loff_t pos, size_t count)
 {
@@ -660,7 +660,7 @@ static ssize_t read_rbu_packet_size(struct kobject *kobj,
 	return size;
 }
 
-static ssize_t write_rbu_packet_size(struct kobject *kobj,
+static ssize_t write_rbu_packet_size(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *bin_attr,
 				     char *buffer, loff_t pos, size_t count)
 {
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 81b70bd..2a62ec6 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -402,7 +402,7 @@ efivar_unregister(struct efivar_entry *var)
 }
 
 
-static ssize_t efivar_create(struct kobject *kobj,
+static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
@@ -461,7 +461,7 @@ static ssize_t efivar_create(struct kobject *kobj,
 	return count;
 }
 
-static ssize_t efivar_delete(struct kobject *kobj,
+static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 25bbd30..387166d 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -193,8 +193,9 @@ static ssize_t enabled_show(struct device *device,
 			"disabled");
 }
 
-static ssize_t edid_show(struct kobject *kobj, struct bin_attribute *attr,
-			 char *buf, loff_t off, size_t count)
+static ssize_t edid_show(struct file *filp, struct kobject *kobj,
+			 struct bin_attribute *attr, char *buf, loff_t off,
+			 size_t count)
 {
 	struct device *connector_dev = container_of(kobj, struct device, kobj);
 	struct drm_connector *connector = to_drm_connector(connector_dev);
diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index ed090e7..19fc7c1 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -707,7 +707,7 @@ static ssize_t __c2port_read_flash_data(struct c2port_device *dev,
 	return nread;
 }
 
-static ssize_t c2port_read_flash_data(struct kobject *kobj,
+static ssize_t c2port_read_flash_data(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *attr,
 				char *buffer, loff_t offset, size_t count)
 {
@@ -824,7 +824,7 @@ static ssize_t __c2port_write_flash_data(struct c2port_device *dev,
 	return nwrite;
 }
 
-static ssize_t c2port_write_flash_data(struct kobject *kobj,
+static ssize_t c2port_write_flash_data(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *attr,
 				char *buffer, loff_t offset, size_t count)
 {
diff --git a/drivers/misc/ds1682.c b/drivers/misc/ds1682.c
index 9197cfc..a513f0a 100644
--- a/drivers/misc/ds1682.c
+++ b/drivers/misc/ds1682.c
@@ -140,7 +140,8 @@ static const struct attribute_group ds1682_group = {
 /*
  * User data attribute
  */
-static ssize_t ds1682_eeprom_read(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t ds1682_eeprom_read(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *attr,
 				  char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
@@ -163,7 +164,8 @@ static ssize_t ds1682_eeprom_read(struct kobject *kobj, struct bin_attribute *at
 	return count;
 }
 
-static ssize_t ds1682_eeprom_write(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t ds1682_eeprom_write(struct file *filp, struct kobject *kobj,
+				   struct bin_attribute *attr,
 				   char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index db7d0f2..a79a62f 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -274,7 +274,8 @@ static ssize_t at24_read(struct at24_data *at24,
 	return retval;
 }
 
-static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_bin_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct at24_data *at24;
@@ -395,7 +396,8 @@ static ssize_t at24_write(struct at24_data *at24, const char *buf, loff_t off,
 	return retval;
 }
 
-static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_bin_write(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct at24_data *at24;
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index d194212..c627e41 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -126,7 +126,8 @@ at25_ee_read(
 }
 
 static ssize_t
-at25_bin_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+at25_bin_read(struct file *filp, struct kobject *kobj,
+	      struct bin_attribute *bin_attr,
 	      char *buf, loff_t off, size_t count)
 {
 	struct device		*dev;
@@ -253,7 +254,8 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
 }
 
 static ssize_t
-at25_bin_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+at25_bin_write(struct file *filp, struct kobject *kobj,
+	       struct bin_attribute *bin_attr,
 	       char *buf, loff_t off, size_t count)
 {
 	struct device		*dev;
diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index f939ebc..af57d5e 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -85,7 +85,8 @@ exit:
 	mutex_unlock(&data->update_lock);
 }
 
-static ssize_t eeprom_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+static ssize_t eeprom_read(struct file *filp, struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(container_of(kobj, struct device, kobj));
diff --git a/drivers/misc/eeprom/max6875.c b/drivers/misc/eeprom/max6875.c
index 5a6b2bc..a7e31ee 100644
--- a/drivers/misc/eeprom/max6875.c
+++ b/drivers/misc/eeprom/max6875.c
@@ -107,7 +107,7 @@ exit_up:
 	mutex_unlock(&data->update_lock);
 }
 
-static ssize_t max6875_read(struct kobject *kobj,
+static ssize_t max6875_read(struct file *filp, struct kobject *kobj,
 			    struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index ce838f7..7aa7259 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -2539,7 +2539,8 @@ netxen_sysfs_validate_crb(struct netxen_adapter *adapter,
 }
 
 static ssize_t
-netxen_sysfs_read_crb(struct kobject *kobj, struct bin_attribute *attr,
+netxen_sysfs_read_crb(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -2557,7 +2558,8 @@ netxen_sysfs_read_crb(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static ssize_t
-netxen_sysfs_write_crb(struct kobject *kobj, struct bin_attribute *attr,
+netxen_sysfs_write_crb(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -2588,7 +2590,8 @@ netxen_sysfs_validate_mem(struct netxen_adapter *adapter,
 }
 
 static ssize_t
-netxen_sysfs_read_mem(struct kobject *kobj, struct bin_attribute *attr,
+netxen_sysfs_read_mem(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -2608,7 +2611,7 @@ netxen_sysfs_read_mem(struct kobject *kobj, struct bin_attribute *attr,
 	return size;
 }
 
-static ssize_t netxen_sysfs_write_mem(struct kobject *kobj,
+static ssize_t netxen_sysfs_write_mem(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr, char *buf,
 		loff_t offset, size_t size)
 {
diff --git a/drivers/net/qlcnic/qlcnic_main.c b/drivers/net/qlcnic/qlcnic_main.c
index 234dab1..1beafe5 100644
--- a/drivers/net/qlcnic/qlcnic_main.c
+++ b/drivers/net/qlcnic/qlcnic_main.c
@@ -2400,7 +2400,8 @@ qlcnic_sysfs_validate_crb(struct qlcnic_adapter *adapter,
 }
 
 static ssize_t
-qlcnic_sysfs_read_crb(struct kobject *kobj, struct bin_attribute *attr,
+qlcnic_sysfs_read_crb(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -2418,7 +2419,8 @@ qlcnic_sysfs_read_crb(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static ssize_t
-qlcnic_sysfs_write_crb(struct kobject *kobj, struct bin_attribute *attr,
+qlcnic_sysfs_write_crb(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -2449,7 +2451,8 @@ qlcnic_sysfs_validate_mem(struct qlcnic_adapter *adapter,
 }
 
 static ssize_t
-qlcnic_sysfs_read_mem(struct kobject *kobj, struct bin_attribute *attr,
+qlcnic_sysfs_read_mem(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -2470,7 +2473,8 @@ qlcnic_sysfs_read_mem(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static ssize_t
-qlcnic_sysfs_write_mem(struct kobject *kobj, struct bin_attribute *attr,
+qlcnic_sysfs_write_mem(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t offset, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 6ecbfb2..e525263 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -108,7 +108,7 @@ static int ibm_set_attention_status(struct hotplug_slot *slot, u8 status);
 static int ibm_get_attention_status(struct hotplug_slot *slot, u8 *status);
 static void ibm_handle_events(acpi_handle handle, u32 event, void *context);
 static int ibm_get_table_from_acpi(char **bufp);
-static ssize_t ibm_read_apci_table(struct kobject *kobj,
+static ssize_t ibm_read_apci_table(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t pos, size_t size);
 static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
@@ -351,6 +351,7 @@ read_table_done:
 
 /**
  * ibm_read_apci_table - callback for the sysfs apci_table file
+ * @filp: the open sysfs file
  * @kobj: the kobject this binary attribute is a part of
  * @bin_attr: struct bin_attribute for this file
  * @buffer: the kernel space buffer to fill
@@ -364,7 +365,7 @@ read_table_done:
  * things get really tricky here...
  * our solution is to only allow reading the table in all at once.
  */
-static ssize_t ibm_read_apci_table(struct kobject *kobj,
+static ssize_t ibm_read_apci_table(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t pos, size_t size)
 {
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fad9398..ad44557 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -357,7 +357,8 @@ boot_vga_show(struct device *dev, struct device_attribute *attr, char *buf)
 struct device_attribute vga_attr = __ATTR_RO(boot_vga);
 
 static ssize_t
-pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+pci_read_config(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
@@ -430,7 +431,8 @@ pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 }
 
 static ssize_t
-pci_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+pci_write_config(struct file* filp, struct kobject *kobj,
+		 struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
@@ -487,7 +489,8 @@ pci_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 }
 
 static ssize_t
-read_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
+read_vpd_attr(struct file *filp, struct kobject *kobj,
+	      struct bin_attribute *bin_attr,
 	      char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev =
@@ -502,7 +505,8 @@ read_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
 }
 
 static ssize_t
-write_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
+write_vpd_attr(struct file *filp, struct kobject *kobj,
+	       struct bin_attribute *bin_attr,
 	       char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev =
@@ -519,6 +523,7 @@ write_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
 #ifdef HAVE_PCI_LEGACY
 /**
  * pci_read_legacy_io - read byte(s) from legacy I/O port space
+ * @filp: open sysfs file
  * @kobj: kobject corresponding to file to read from
  * @bin_attr: struct bin_attribute for this file
  * @buf: buffer to store results
@@ -529,7 +534,8 @@ write_vpd_attr(struct kobject *kobj, struct bin_attribute *bin_attr,
  * callback routine (pci_legacy_read).
  */
 static ssize_t
-pci_read_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
+pci_read_legacy_io(struct file *filp, struct kobject *kobj,
+		   struct bin_attribute *bin_attr,
 		   char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
@@ -545,6 +551,7 @@ pci_read_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 /**
  * pci_write_legacy_io - write byte(s) to legacy I/O port space
+ * @filp: open sysfs file
  * @kobj: kobject corresponding to file to read from
  * @bin_attr: struct bin_attribute for this file
  * @buf: buffer containing value to be written
@@ -555,7 +562,8 @@ pci_read_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
  * callback routine (pci_legacy_write).
  */
 static ssize_t
-pci_write_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
+pci_write_legacy_io(struct file *filp, struct kobject *kobj,
+		    struct bin_attribute *bin_attr,
 		    char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
@@ -570,6 +578,7 @@ pci_write_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 /**
  * pci_mmap_legacy_mem - map legacy PCI memory into user memory space
+ * @filp: open sysfs file
  * @kobj: kobject corresponding to device to be mapped
  * @attr: struct bin_attribute for this file
  * @vma: struct vm_area_struct passed to mmap
@@ -579,7 +588,8 @@ pci_write_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
  * memory space.
  */
 static int
-pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
+pci_mmap_legacy_mem(struct file *filp, struct kobject *kobj,
+		    struct bin_attribute *attr,
                     struct vm_area_struct *vma)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
@@ -591,6 +601,7 @@ pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
 
 /**
  * pci_mmap_legacy_io - map legacy PCI IO into user memory space
+ * @filp: open sysfs file
  * @kobj: kobject corresponding to device to be mapped
  * @attr: struct bin_attribute for this file
  * @vma: struct vm_area_struct passed to mmap
@@ -600,7 +611,8 @@ pci_mmap_legacy_mem(struct kobject *kobj, struct bin_attribute *attr,
  * memory space. Returns -ENOSYS if the operation isn't supported
  */
 static int
-pci_mmap_legacy_io(struct kobject *kobj, struct bin_attribute *attr,
+pci_mmap_legacy_io(struct file *filp, struct kobject *kobj,
+		   struct bin_attribute *attr,
 		   struct vm_area_struct *vma)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
@@ -750,14 +762,16 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static int
-pci_mmap_resource_uc(struct kobject *kobj, struct bin_attribute *attr,
+pci_mmap_resource_uc(struct file *filp, struct kobject *kobj,
+		     struct bin_attribute *attr,
 		     struct vm_area_struct *vma)
 {
 	return pci_mmap_resource(kobj, attr, vma, 0);
 }
 
 static int
-pci_mmap_resource_wc(struct kobject *kobj, struct bin_attribute *attr,
+pci_mmap_resource_wc(struct file *filp, struct kobject *kobj,
+		     struct bin_attribute *attr,
 		     struct vm_area_struct *vma)
 {
 	return pci_mmap_resource(kobj, attr, vma, 1);
@@ -861,6 +875,7 @@ void __weak pci_remove_resource_files(struct pci_dev *dev) { return; }
 
 /**
  * pci_write_rom - used to enable access to the PCI ROM display
+ * @filp: sysfs file
  * @kobj: kernel object handle
  * @bin_attr: struct bin_attribute for this file
  * @buf: user input
@@ -870,7 +885,8 @@ void __weak pci_remove_resource_files(struct pci_dev *dev) { return; }
  * writing anything except 0 enables it
  */
 static ssize_t
-pci_write_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
+pci_write_rom(struct file *filp, struct kobject *kobj,
+	      struct bin_attribute *bin_attr,
 	      char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj, struct device, kobj));
@@ -885,6 +901,7 @@ pci_write_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 /**
  * pci_read_rom - read a PCI ROM
+ * @filp: sysfs file
  * @kobj: kernel object handle
  * @bin_attr: struct bin_attribute for this file
  * @buf: where to put the data we read from the ROM
@@ -895,7 +912,8 @@ pci_write_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
  * device corresponding to @kobj.
  */
 static ssize_t
-pci_read_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
+pci_read_rom(struct file *filp, struct kobject *kobj,
+	     struct bin_attribute *bin_attr,
 	     char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj, struct device, kobj));
diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 854959c..3ec3588 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -1634,7 +1634,7 @@ static ssize_t pccard_extract_cis(struct pcmcia_socket *s, char *buf,
 }
 
 
-static ssize_t pccard_show_cis(struct kobject *kobj,
+static ssize_t pccard_show_cis(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
@@ -1665,7 +1665,7 @@ static ssize_t pccard_show_cis(struct kobject *kobj,
 }
 
 
-static ssize_t pccard_store_cis(struct kobject *kobj,
+static ssize_t pccard_store_cis(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 8fefe5a..baefcf1 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -354,7 +354,7 @@ static enum power_supply_property olpc_bat_props[] = {
 #define EEPROM_END	0x80
 #define EEPROM_SIZE	(EEPROM_END - EEPROM_START)
 
-static ssize_t olpc_bat_eeprom_read(struct kobject *kobj,
+static ssize_t olpc_bat_eeprom_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
 {
 	uint8_t ec_byte;
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index ba742e8..00b4756 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -68,7 +68,8 @@ struct device_attribute rio_dev_attrs[] = {
 };
 
 static ssize_t
-rio_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+rio_read_config(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct rio_dev *dev =
@@ -139,7 +140,8 @@ rio_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 }
 
 static ssize_t
-rio_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+rio_write_config(struct file *filp, struct kobject *kobj,
+		 struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
 {
 	struct rio_dev *dev =
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e9aa814..ece4dbd 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -519,7 +519,8 @@ static const struct rtc_class_ops cmos_rtc_ops = {
 #define NVRAM_OFFSET	(RTC_REG_D + 1)
 
 static ssize_t
-cmos_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
+cmos_nvram_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	int	retval;
@@ -547,7 +548,8 @@ cmos_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static ssize_t
-cmos_nvram_write(struct kobject *kobj, struct bin_attribute *attr,
+cmos_nvram_write(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct cmos_rtc	*cmos;
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 7836c9c..48da85e 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -542,7 +542,8 @@ static void msg_init(struct spi_message *m, struct spi_transfer *x,
 }
 
 static ssize_t
-ds1305_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
+ds1305_nvram_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct spi_device	*spi;
@@ -572,7 +573,8 @@ ds1305_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static ssize_t
-ds1305_nvram_write(struct kobject *kobj, struct bin_attribute *attr,
+ds1305_nvram_write(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct spi_device	*spi;
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index c4ec5c1..de033b7 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -556,7 +556,8 @@ static const struct rtc_class_ops ds13xx_rtc_ops = {
 #define NVRAM_SIZE	56
 
 static ssize_t
-ds1307_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
+ds1307_nvram_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct i2c_client	*client;
@@ -580,7 +581,8 @@ ds1307_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
 }
 
 static ssize_t
-ds1307_nvram_write(struct kobject *kobj, struct bin_attribute *attr,
+ds1307_nvram_write(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct i2c_client	*client;
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 06b8566..37268e9 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -423,8 +423,9 @@ static const struct rtc_class_ops ds1511_rtc_ops = {
 };
 
  static ssize_t
-ds1511_nvram_read(struct kobject *kobj, struct bin_attribute *ba,
-				char *buf, loff_t pos, size_t size)
+ds1511_nvram_read(struct file *filp, struct kobject *kobj,
+		  struct bin_attribute *ba,
+		  char *buf, loff_t pos, size_t size)
 {
 	ssize_t count;
 
@@ -452,8 +453,9 @@ ds1511_nvram_read(struct kobject *kobj, struct bin_attribute *ba,
 }
 
  static ssize_t
-ds1511_nvram_write(struct kobject *kobj, struct bin_attribute *bin_attr,
-				char *buf, loff_t pos, size_t size)
+ds1511_nvram_write(struct file *filp, struct kobject *kobj,
+		   struct bin_attribute *bin_attr,
+		   char *buf, loff_t pos, size_t size)
 {
 	ssize_t count;
 
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 244f999..ff432e2 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -252,7 +252,7 @@ static const struct rtc_class_ops ds1553_rtc_ops = {
 	.update_irq_enable	= ds1553_rtc_update_irq_enable,
 };
 
-static ssize_t ds1553_nvram_read(struct kobject *kobj,
+static ssize_t ds1553_nvram_read(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t size)
 {
@@ -267,7 +267,7 @@ static ssize_t ds1553_nvram_read(struct kobject *kobj,
 	return count;
 }
 
-static ssize_t ds1553_nvram_write(struct kobject *kobj,
+static ssize_t ds1553_nvram_write(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t pos, size_t size)
 {
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 2b4b0bc..042630c 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -128,7 +128,7 @@ static const struct rtc_class_ops ds1742_rtc_ops = {
 	.set_time	= ds1742_rtc_set_time,
 };
 
-static ssize_t ds1742_nvram_read(struct kobject *kobj,
+static ssize_t ds1742_nvram_read(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t size)
 {
@@ -143,7 +143,7 @@ static ssize_t ds1742_nvram_read(struct kobject *kobj,
 	return count;
 }
 
-static ssize_t ds1742_nvram_write(struct kobject *kobj,
+static ssize_t ds1742_nvram_write(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t pos, size_t size)
 {
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 365ff3a..be8359f 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -343,7 +343,7 @@ static const struct rtc_class_ops m48t02_rtc_ops = {
 	.set_time	= m48t59_rtc_set_time,
 };
 
-static ssize_t m48t59_nvram_read(struct kobject *kobj,
+static ssize_t m48t59_nvram_read(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t pos, size_t size)
 {
@@ -363,7 +363,7 @@ static ssize_t m48t59_nvram_read(struct kobject *kobj,
 	return cnt;
 }
 
-static ssize_t m48t59_nvram_write(struct kobject *kobj,
+static ssize_t m48t59_nvram_write(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t pos, size_t size)
 {
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 875ba09..644dde9 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -244,7 +244,7 @@ static const struct rtc_class_ops stk17ta8_rtc_ops = {
 	.alarm_irq_enable	= stk17ta8_rtc_alarm_irq_enable,
 };
 
-static ssize_t stk17ta8_nvram_read(struct kobject *kobj,
+static ssize_t stk17ta8_nvram_read(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *attr, char *buf,
 				 loff_t pos, size_t size)
 {
@@ -259,7 +259,7 @@ static ssize_t stk17ta8_nvram_read(struct kobject *kobj,
 	return count;
 }
 
-static ssize_t stk17ta8_nvram_write(struct kobject *kobj,
+static ssize_t stk17ta8_nvram_write(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *attr, char *buf,
 				  loff_t pos, size_t size)
 {
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 20bfc64..ec6313d 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -188,7 +188,7 @@ static const struct rtc_class_ops tx4939_rtc_ops = {
 	.alarm_irq_enable	= tx4939_rtc_alarm_irq_enable,
 };
 
-static ssize_t tx4939_rtc_nvram_read(struct kobject *kobj,
+static ssize_t tx4939_rtc_nvram_read(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *bin_attr,
 				     char *buf, loff_t pos, size_t size)
 {
@@ -207,7 +207,7 @@ static ssize_t tx4939_rtc_nvram_read(struct kobject *kobj,
 	return count;
 }
 
-static ssize_t tx4939_rtc_nvram_write(struct kobject *kobj,
+static ssize_t tx4939_rtc_nvram_write(struct file *filp, struct kobject *kobj,
 				      struct bin_attribute *bin_attr,
 				      char *buf, loff_t pos, size_t size)
 {
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index 1d16189..6c9fa15 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -135,7 +135,8 @@ static int s390_vary_chpid(struct chp_id chpid, int on)
 /*
  * Channel measurement related functions
  */
-static ssize_t chp_measurement_chars_read(struct kobject *kobj,
+static ssize_t chp_measurement_chars_read(struct file *filp,
+					  struct kobject *kobj,
 					  struct bin_attribute *bin_attr,
 					  char *buf, loff_t off, size_t count)
 {
@@ -182,7 +183,7 @@ static void chp_measurement_copy_block(struct cmg_entry *buf,
 	} while (reference_buf.values[0] != buf->values[0]);
 }
 
-static ssize_t chp_measurement_read(struct kobject *kobj,
+static ssize_t chp_measurement_read(struct file *filp, struct kobject *kobj,
 				    struct bin_attribute *bin_attr,
 				    char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 54c5ffb..d38000d 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -98,7 +98,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 /* Functions */
 
 /* This function returns AENs through sysfs */
-static ssize_t twl_sysfs_aen_read(struct kobject *kobj,
+static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *outbuf, loff_t offset, size_t count)
 {
@@ -129,7 +129,7 @@ static struct bin_attribute twl_sysfs_aen_read_attr = {
 };
 
 /* This function returns driver compatibility info through sysfs */
-static ssize_t twl_sysfs_compat_info(struct kobject *kobj,
+static ssize_t twl_sysfs_compat_info(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *bin_attr,
 				     char *outbuf, loff_t offset, size_t count)
 {
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 5877f29..a4e04c5 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -59,7 +59,8 @@
 
 struct device_attribute *arcmsr_host_attrs[];
 
-static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj,
+static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
+					     struct kobject *kobj,
 					     struct bin_attribute *bin,
 					     char *buf, loff_t off,
 					     size_t count)
@@ -105,7 +106,8 @@ static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj,
 	return (allxfer_len);
 }
 
-static ssize_t arcmsr_sysfs_iop_message_write(struct kobject *kobj,
+static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
+					      struct kobject *kobj,
 					      struct bin_attribute *bin,
 					      char *buf, loff_t off,
 					      size_t count)
@@ -153,7 +155,8 @@ static ssize_t arcmsr_sysfs_iop_message_write(struct kobject *kobj,
 	}
 }
 
-static ssize_t arcmsr_sysfs_iop_message_clear(struct kobject *kobj,
+static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
+					      struct kobject *kobj,
 					      struct bin_attribute *bin,
 					      char *buf, loff_t off,
 					      size_t count)
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index c2eea71..5937e86 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2919,6 +2919,7 @@ static DEVICE_ATTR(log_level, S_IRUGO | S_IWUSR,
 #ifdef CONFIG_SCSI_IBMVFC_TRACE
 /**
  * ibmvfc_read_trace - Dump the adapter trace
+ * @filp:		open sysfs file
  * @kobj:		kobject struct
  * @bin_attr:	bin_attribute struct
  * @buf:		buffer
@@ -2928,7 +2929,7 @@ static DEVICE_ATTR(log_level, S_IRUGO | S_IWUSR,
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ibmvfc_read_trace(struct kobject *kobj,
+static ssize_t ibmvfc_read_trace(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 520461b..f9df151 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3120,6 +3120,7 @@ restart:
 #ifdef CONFIG_SCSI_IPR_TRACE
 /**
  * ipr_read_trace - Dump the adapter trace
+ * @filp:		open sysfs file
  * @kobj:		kobject struct
  * @bin_attr:		bin_attribute struct
  * @buf:		buffer
@@ -3129,7 +3130,7 @@ restart:
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_read_trace(struct kobject *kobj,
+static ssize_t ipr_read_trace(struct file *filp, struct kobject *kobj,
 			      struct bin_attribute *bin_attr,
 			      char *buf, loff_t off, size_t count)
 {
@@ -3764,6 +3765,7 @@ static struct device_attribute *ipr_ioa_attrs[] = {
 #ifdef CONFIG_SCSI_IPR_DUMP
 /**
  * ipr_read_dump - Dump the adapter
+ * @filp:		open sysfs file
  * @kobj:		kobject struct
  * @bin_attr:		bin_attribute struct
  * @buf:		buffer
@@ -3773,7 +3775,7 @@ static struct device_attribute *ipr_ioa_attrs[] = {
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_read_dump(struct kobject *kobj,
+static ssize_t ipr_read_dump(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t off, size_t count)
 {
@@ -3927,6 +3929,7 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
 
 /**
  * ipr_write_dump - Setup dump state of adapter
+ * @filp:		open sysfs file
  * @kobj:		kobject struct
  * @bin_attr:		bin_attribute struct
  * @buf:		buffer
@@ -3936,7 +3939,7 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_write_dump(struct kobject *kobj,
+static ssize_t ipr_write_dump(struct file *filp, struct kobject *kobj,
 			      struct bin_attribute *bin_attr,
 			      char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 1849e33..1121dd0 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2637,6 +2637,7 @@ static DEVICE_ATTR(lpfc_stat_data_ctrl, S_IRUGO | S_IWUSR,
 
 /**
  * sysfs_drvr_stat_data_read - Read function for lpfc_drvr_stat_data attribute
+ * @filp: sysfs file
  * @kobj: Pointer to the kernel object
  * @bin_attr: Attribute object
  * @buff: Buffer pointer
@@ -2648,7 +2649,8 @@ static DEVICE_ATTR(lpfc_stat_data_ctrl, S_IRUGO | S_IWUSR,
  * applications.
  **/
 static ssize_t
-sysfs_drvr_stat_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+sysfs_drvr_stat_data_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device,
@@ -3356,6 +3358,7 @@ struct device_attribute *lpfc_vport_attrs[] = {
 
 /**
  * sysfs_ctlreg_write - Write method for writing to ctlreg
+ * @filp: open sysfs file
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be written to the adapter IOREG space.
@@ -3373,7 +3376,8 @@ struct device_attribute *lpfc_vport_attrs[] = {
  * value of count, buf contents written
  **/
 static ssize_t
-sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+sysfs_ctlreg_write(struct file *filp, struct kobject *kobj,
+		   struct bin_attribute *bin_attr,
 		   char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
@@ -3409,6 +3413,7 @@ sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 /**
  * sysfs_ctlreg_read - Read method for reading from ctlreg
+ * @filp: open sysfs file
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: if successful contains the data from the adapter IOREG space.
@@ -3425,7 +3430,8 @@ sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
  * value of count, buf contents read
  **/
 static ssize_t
-sysfs_ctlreg_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+sysfs_ctlreg_read(struct file *filp, struct kobject *kobj,
+		  struct bin_attribute *bin_attr,
 		  char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
@@ -3490,6 +3496,7 @@ sysfs_mbox_idle(struct lpfc_hba *phba)
 
 /**
  * sysfs_mbox_write - Write method for writing information via mbox
+ * @filp: open sysfs file
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be written to sysfs mbox.
@@ -3510,7 +3517,8 @@ sysfs_mbox_idle(struct lpfc_hba *phba)
  * count number of bytes transferred
  **/
 static ssize_t
-sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+sysfs_mbox_write(struct file *filp, struct kobject *kobj,
+		 struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -3565,6 +3573,7 @@ sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 /**
  * sysfs_mbox_read - Read method for reading information via mbox
+ * @filp: open sysfs file
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be read from sysfs mbox.
@@ -3587,7 +3596,8 @@ sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
  * count number of bytes transferred
  **/
 static ssize_t
-sysfs_mbox_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+sysfs_mbox_read(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1c7ef55..0037b82 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -18,7 +18,7 @@ static int qla84xx_mgmt_cmd(scsi_qla_host_t *, struct msg_echo_lb *, struct fc_b
 /* SYSFS attributes --------------------------------------------------------- */
 
 static ssize_t
-qla2x00_sysfs_read_fw_dump(struct kobject *kobj,
+qla2x00_sysfs_read_fw_dump(struct file *filp, struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
@@ -34,7 +34,7 @@ qla2x00_sysfs_read_fw_dump(struct kobject *kobj,
 }
 
 static ssize_t
-qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
+qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			    struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
@@ -88,7 +88,7 @@ static struct bin_attribute sysfs_fw_dump_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_nvram(struct kobject *kobj,
+qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
 			 struct bin_attribute *bin_attr,
 			 char *buf, loff_t off, size_t count)
 {
@@ -107,7 +107,7 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 }
 
 static ssize_t
-qla2x00_sysfs_write_nvram(struct kobject *kobj,
+qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
@@ -173,7 +173,7 @@ static struct bin_attribute sysfs_nvram_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_optrom(struct kobject *kobj,
+qla2x00_sysfs_read_optrom(struct file *filp, struct kobject *kobj,
 			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
@@ -189,7 +189,7 @@ qla2x00_sysfs_read_optrom(struct kobject *kobj,
 }
 
 static ssize_t
-qla2x00_sysfs_write_optrom(struct kobject *kobj,
+qla2x00_sysfs_write_optrom(struct file *filp, struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
@@ -220,7 +220,7 @@ static struct bin_attribute sysfs_optrom_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
+qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
@@ -377,7 +377,7 @@ static struct bin_attribute sysfs_optrom_ctl_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_vpd(struct kobject *kobj,
+qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
@@ -398,7 +398,7 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 }
 
 static ssize_t
-qla2x00_sysfs_write_vpd(struct kobject *kobj,
+qla2x00_sysfs_write_vpd(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
@@ -451,7 +451,7 @@ static struct bin_attribute sysfs_vpd_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_sfp(struct kobject *kobj,
+qla2x00_sysfs_read_sfp(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
@@ -512,7 +512,7 @@ static struct bin_attribute sysfs_sfp_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_write_reset(struct kobject *kobj,
+qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
@@ -567,7 +567,7 @@ static struct bin_attribute sysfs_reset_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_write_edc(struct kobject *kobj,
+qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
@@ -625,7 +625,7 @@ static struct bin_attribute sysfs_edc_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_write_edc_status(struct kobject *kobj,
+qla2x00_sysfs_write_edc_status(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
@@ -675,7 +675,7 @@ qla2x00_sysfs_write_edc_status(struct kobject *kobj,
 }
 
 static ssize_t
-qla2x00_sysfs_read_edc_status(struct kobject *kobj,
+qla2x00_sysfs_read_edc_status(struct file *filp, struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
@@ -705,7 +705,7 @@ static struct bin_attribute sysfs_edc_status_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_xgmac_stats(struct kobject *kobj,
+qla2x00_sysfs_read_xgmac_stats(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
@@ -757,7 +757,7 @@ static struct bin_attribute sysfs_xgmac_stats_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_dcbx_tlv(struct kobject *kobj,
+qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/staging/udlfb/udlfb.c b/drivers/staging/udlfb/udlfb.c
index a78ade0..4f1f96f 100644
--- a/drivers/staging/udlfb/udlfb.c
+++ b/drivers/staging/udlfb/udlfb.c
@@ -1063,7 +1063,8 @@ static ssize_t metrics_misc_show(struct device *fbdev,
 			atomic_read(&dev->lost_pixels) ? "yes" : "no");
 }
 
-static ssize_t edid_show(struct kobject *kobj, struct bin_attribute *a,
+static ssize_t edid_show(struct file *filp, struct kobject *kobj,
+			 struct bin_attribute *a,
 			 char *buf, loff_t off, size_t count) {
 	struct device *fbdev = container_of(kobj, struct device, kobj);
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 43c002e..f4d087c 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -646,7 +646,8 @@ const struct attribute_group *usb_device_groups[] = {
 /* Binary descriptors */
 
 static ssize_t
-read_descriptors(struct kobject *kobj, struct bin_attribute *attr,
+read_descriptors(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 6c37e8e..3c1e13e 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2099,7 +2099,7 @@ static ssize_t radeon_show_one_edid(char *buf, loff_t off, size_t count, const u
 }
 
 
-static ssize_t radeon_show_edid1(struct kobject *kobj,
+static ssize_t radeon_show_edid1(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t off, size_t count)
 {
@@ -2112,7 +2112,7 @@ static ssize_t radeon_show_edid1(struct kobject *kobj,
 }
 
 
-static ssize_t radeon_show_edid2(struct kobject *kobj,
+static ssize_t radeon_show_edid2(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/w1/slaves/w1_ds2431.c b/drivers/w1/slaves/w1_ds2431.c
index 2c6c0cf..84e2410 100644
--- a/drivers/w1/slaves/w1_ds2431.c
+++ b/drivers/w1/slaves/w1_ds2431.c
@@ -96,7 +96,7 @@ static int w1_f2d_readblock(struct w1_slave *sl, int off, int count, char *buf)
 	return -1;
 }
 
-static ssize_t w1_f2d_read_bin(struct kobject *kobj,
+static ssize_t w1_f2d_read_bin(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
@@ -202,7 +202,7 @@ retry:
 	return 0;
 }
 
-static ssize_t w1_f2d_write_bin(struct kobject *kobj,
+static ssize_t w1_f2d_write_bin(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index d2bf321..0f7b8f9 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -92,7 +92,7 @@ static int w1_f23_refresh_block(struct w1_slave *sl, struct w1_f23_data *data,
 }
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
-static ssize_t w1_f23_read_bin(struct kobject *kobj,
+static ssize_t w1_f23_read_bin(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
@@ -206,7 +206,7 @@ static int w1_f23_write(struct w1_slave *sl, int addr, int len, const u8 *data)
 	return 0;
 }
 
-static ssize_t w1_f23_write_bin(struct kobject *kobj,
+static ssize_t w1_f23_write_bin(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 6e15334..483d451 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -97,7 +97,7 @@ int w1_ds2760_recall_eeprom(struct device *dev, int addr)
 	return w1_ds2760_eeprom_cmd(dev, addr, W1_DS2760_RECALL_DATA);
 }
 
-static ssize_t w1_ds2760_read_bin(struct kobject *kobj,
+static ssize_t w1_ds2760_read_bin(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index ad5897d..2839e28 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -120,7 +120,7 @@ static struct device_attribute w1_slave_attr_id =
 
 /* Default family */
 
-static ssize_t w1_default_write(struct kobject *kobj,
+static ssize_t w1_default_write(struct file *filp, struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t off, size_t count)
 {
@@ -139,7 +139,7 @@ out_up:
 	return count;
 }
 
-static ssize_t w1_default_read(struct kobject *kobj,
+static ssize_t w1_default_read(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
diff --git a/drivers/zorro/zorro-sysfs.c b/drivers/zorro/zorro-sysfs.c
index 1d2a772..ef90040 100644
--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -49,7 +49,7 @@ static ssize_t zorro_show_resource(struct device *dev, struct device_attribute *
 
 static DEVICE_ATTR(resource, S_IRUGO, zorro_show_resource, NULL);
 
-static ssize_t zorro_read_config(struct kobject *kobj,
+static ssize_t zorro_read_config(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t off, size_t count)
 {
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index e9d2935..a58611b 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -46,9 +46,9 @@ struct bin_buffer {
 };
 
 static int
-fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
+fill_read(struct file *file, char *buffer, loff_t off, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
@@ -59,7 +59,7 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 
 	rc = -EIO;
 	if (attr->read)
-		rc = attr->read(kobj, attr, buffer, off, count);
+		rc = attr->read(file, kobj, attr, buffer, off, count);
 
 	sysfs_put_active(attr_sd);
 
@@ -70,8 +70,7 @@ static ssize_t
 read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
 	struct bin_buffer *bb = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
-	int size = dentry->d_inode->i_size;
+	int size = file->f_path.dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;
@@ -92,7 +91,7 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 
 	mutex_lock(&bb->mutex);
 
-	count = fill_read(dentry, bb->buffer, offs, count);
+	count = fill_read(file, bb->buffer, offs, count);
 	if (count < 0) {
 		mutex_unlock(&bb->mutex);
 		goto out_free;
@@ -117,9 +116,9 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 }
 
 static int
-flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
+flush_write(struct file *file, char *buffer, loff_t offset, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	int rc;
@@ -130,7 +129,7 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 
 	rc = -EIO;
 	if (attr->write)
-		rc = attr->write(kobj, attr, buffer, offset, count);
+		rc = attr->write(file, kobj, attr, buffer, offset, count);
 
 	sysfs_put_active(attr_sd);
 
@@ -141,8 +140,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 		     size_t bytes, loff_t *off)
 {
 	struct bin_buffer *bb = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
-	int size = dentry->d_inode->i_size;
+	int size = file->f_path.dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;
@@ -165,7 +163,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 
 	memcpy(bb->buffer, temp, count);
 
-	count = flush_write(dentry, bb->buffer, offs, count);
+	count = flush_write(file, bb->buffer, offs, count);
 	mutex_unlock(&bb->mutex);
 
 	if (count > 0)
@@ -363,7 +361,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	if (!attr->mmap)
 		goto out_put;
 
-	rc = attr->mmap(kobj, attr, vma);
+	rc = attr->mmap(file, kobj, attr, vma);
 	if (rc)
 		goto out_put;
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f0496b3..2a0d278 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -92,11 +92,11 @@ struct bin_attribute {
 	struct attribute	attr;
 	size_t			size;
 	void			*private;
-	ssize_t (*read)(struct kobject *, struct bin_attribute *,
+	ssize_t (*read)(struct file *, struct kobject *, struct bin_attribute *,
 			char *, loff_t, size_t);
-	ssize_t (*write)(struct kobject *, struct bin_attribute *,
+	ssize_t (*write)(struct file *,struct kobject *, struct bin_attribute *,
 			 char *, loff_t, size_t);
-	int (*mmap)(struct kobject *, struct bin_attribute *attr,
+	int (*mmap)(struct file *, struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
 };
 
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 21fe3c4..0b624e7 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -138,7 +138,8 @@ extern const void __start_notes __attribute__((weak));
 extern const void __stop_notes __attribute__((weak));
 #define	notes_size (&__stop_notes - &__start_notes)
 
-static ssize_t notes_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+static ssize_t notes_read(struct file *filp, struct kobject *kobj,
+			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
 	memcpy(buf, &__start_notes + off, count);
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..6ad9e01 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1192,7 +1192,7 @@ struct module_notes_attrs {
 	struct bin_attribute attrs[0];
 };
 
-static ssize_t module_notes_read(struct kobject *kobj,
+static ssize_t module_notes_read(struct file *filp, struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t count)
 {
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index dd321e3..486b8f3 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -659,7 +659,7 @@ static struct attribute_group bridge_group = {
  *
  * Returns the number of bytes read.
  */
-static ssize_t brforward_read(struct kobject *kobj,
+static ssize_t brforward_read(struct file *filp, struct kobject *kobj,
 			      struct bin_attribute *bin_attr,
 			      char *buf, loff_t off, size_t count)
 {
-- 
1.6.5.2

