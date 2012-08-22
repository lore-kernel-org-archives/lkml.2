Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab2HVVwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:52:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57661 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2HVVv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:51:59 -0400
Date: Wed, 22 Aug 2012 16:52:16 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@linux.vnet.ibm.com,
        xiaoyan.zhang@intel.com, jj@chaosbits.net, key@linux.vnet.ibm.com,
        peter.huewe@infineon.com
Subject: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Message-ID: <20120822215216.GC13519@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082221-1780-0000-0000-000008A4B251
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00167617; UDB=6.00037972; UTC=2012-08-22
 21:51:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi James,

The following changes since commit 51b743fe87d7fb3dba7a2ff4a1fe23bb65dc2245:

  Merge tag 'v3.6-rc2' into next (2012-08-17 20:42:30 +1000)

are available in the git repository at:

  git://github.com/shpedoikal/linux.git v3.6-rc2-tpmdd

New stuff since my last pull request are Jesper's error checking of the
acpi_os_map_memory call, Ashley's vTPM driver for PPC64, my enabling the
vTPM driver when IMA is selected on PPC64 and Xiaoyan's addition of
Physical Presence Interface.

Thanks,
Kent

Ashley Lai (3):
      drivers/char/tpm: Add new device driver to support IBM vTPM
      PPC64: Add support for instantiating SML from Open Firmware
      drivers/char/tpm: Add securityfs support for event log

Jesper Juhl (1):
      tpm: Do not dereference NULL pointer if acpi_os_map_memory() fails.

Kent Yoder (6):
      tpm: modularize event log collection
      tpm: Move tpm_get_random api into the TPM device driver
      hw_random: add support for the TPM chip as a hardware RNG source
      tpm: fix double write race and tpm_release free issue
      tpm: compile out unused code in the PNP and PM cases
      ima: enable the IBM vTPM as the default TPM in the PPC64 case

Peter Huewe (1):
      char/tpm: Add new driver for Infineon I2C TIS TPM

Xiaoyan Zhang (2):
      Documentation: sysfs for Physical Presence Interface
      driver: add PPI support in tpm driver

 Documentation/ABI/testing/sysfs-driver-ppi      |   70 +++
 arch/powerpc/kernel/prom_init.c                 |   62 ++
 drivers/char/hw_random/Kconfig                  |   13 +
 drivers/char/hw_random/Makefile                 |    1 +
 drivers/char/hw_random/tpm-rng.c                |   50 ++
 drivers/char/tpm/Kconfig                        |   19 +
 drivers/char/tpm/Makefile                       |    8 +
 drivers/char/tpm/tpm.c                          |   70 ++-
 drivers/char/tpm/tpm.h                          |   35 +-
 drivers/char/tpm/tpm_acpi.c                     |  109 ++++
 drivers/char/tpm/{tpm_bios.c => tpm_eventlog.c} |  147 +-----
 drivers/char/tpm/tpm_eventlog.h                 |   86 +++
 drivers/char/tpm/tpm_i2c_infineon.c             |  695 +++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.c                  |  749 +++++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.h                  |   77 +++
 drivers/char/tpm/tpm_of.c                       |   73 +++
 drivers/char/tpm/tpm_ppi.c                      |  460 ++++++++++++++
 drivers/char/tpm/tpm_tis.c                      |    3 +-
 include/linux/tpm.h                             |    4 +
 security/integrity/ima/Kconfig                  |    1 +
 security/keys/trusted.c                         |   54 +--
 21 files changed, 2586 insertions(+), 200 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi
 create mode 100644 drivers/char/hw_random/tpm-rng.c
 create mode 100644 drivers/char/tpm/tpm_acpi.c
 rename drivers/char/tpm/{tpm_bios.c => tpm_eventlog.c} (75%)
 create mode 100644 drivers/char/tpm/tpm_eventlog.h
 create mode 100644 drivers/char/tpm/tpm_i2c_infineon.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.h
 create mode 100644 drivers/char/tpm/tpm_of.c
 create mode 100644 drivers/char/tpm/tpm_ppi.c

diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
new file mode 100644
index 0000000..97a003e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -0,0 +1,70 @@
+What:		/sys/devices/pnp0/<bus-num>/ppi/
+Date:		August 2012
+Kernel Version:	3.6
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This folder includes the attributes related with PPI (Physical
+		Presence Interface). Only if TPM is supported by BIOS, this
+		folder makes sence. The folder path can be got by command
+		'find /sys/ -name 'pcrs''. For the detail information of PPI,
+		please refer to the PPI specification from
+		http://www.trustedcomputinggroup.org/
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/version
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the version of the PPI supported by the
+		platform.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/request
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the request for an operation to be
+		executed in the pre-OS environment. It is the only input from
+		the OS to the pre-OS environment. The request should be an
+		integer value range from 1 to 160, and 0 means no request.
+		This file can be read and written.
+
+What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the response to the most recent operation
+		request it acted upon. The format is "<request> <response num>
+		: <response description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the platform-specific action that should
+		take place in order to transition to the BIOS for execution of
+		a requested operation. The format is "<action num>: <action
+		description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the requests defined by TCG, i.e. requests from 1 to 22.
+		The format is "<request> <status num>: <status description>".
+		This attribute is only supported by PPI version 1.2+.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the verdor specific requests, i.e. requests from 128 to
+		255. The format is same with tcg_operations. This attribute
+		is also only supported by PPI version 1.2+.
+		This file is readonly.
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 0794a30..e144498 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1624,6 +1624,63 @@ static void __init prom_instantiate_rtas(void)
 
 #ifdef CONFIG_PPC64
 /*
+ * Allocate room for and instantiate Stored Measurement Log (SML)
+ */
+static void __init prom_instantiate_sml(void)
+{
+	phandle ibmvtpm_node;
+	ihandle ibmvtpm_inst;
+	u32 entry = 0, size = 0;
+	u64 base;
+
+	prom_debug("prom_instantiate_sml: start...\n");
+
+	ibmvtpm_node = call_prom("finddevice", 1, 1, ADDR("/ibm,vtpm"));
+	prom_debug("ibmvtpm_node: %x\n", ibmvtpm_node);
+	if (!PHANDLE_VALID(ibmvtpm_node))
+		return;
+
+	ibmvtpm_inst = call_prom("open", 1, 1, ADDR("/ibm,vtpm"));
+	if (!IHANDLE_VALID(ibmvtpm_inst)) {
+		prom_printf("opening vtpm package failed (%x)\n", ibmvtpm_inst);
+		return;
+	}
+
+	if (call_prom_ret("call-method", 2, 2, &size,
+			  ADDR("sml-get-handover-size"),
+			  ibmvtpm_inst) != 0 || size == 0) {
+		prom_printf("SML get handover size failed\n");
+		return;
+	}
+
+	base = alloc_down(size, PAGE_SIZE, 0);
+	if (base == 0)
+		prom_panic("Could not allocate memory for sml\n");
+
+	prom_printf("instantiating sml at 0x%x...", base);
+
+	if (call_prom_ret("call-method", 4, 2, &entry,
+			  ADDR("sml-handover"),
+			  ibmvtpm_inst, size, base) != 0 || entry == 0) {
+		prom_printf("SML handover failed\n");
+		return;
+	}
+	prom_printf(" done\n");
+
+	reserve_mem(base, size);
+
+	prom_setprop(ibmvtpm_node, "/ibm,vtpm", "linux,sml-base",
+		     &base, sizeof(base));
+	prom_setprop(ibmvtpm_node, "/ibm,vtpm", "linux,sml-size",
+		     &size, sizeof(size));
+
+	prom_debug("sml base     = 0x%x\n", base);
+	prom_debug("sml size     = 0x%x\n", (long)size);
+
+	prom_debug("prom_instantiate_sml: end...\n");
+}
+
+/*
  * Allocate room for and initialize TCE tables
  */
 static void __init prom_initialize_tce_table(void)
@@ -2916,6 +2973,11 @@ unsigned long __init prom_init(unsigned long r3, unsigned long r4,
 		prom_instantiate_opal();
 #endif
 
+#ifdef CONFIG_PPC64
+	/* instantiate sml */
+	prom_instantiate_sml();
+#endif
+
 	/*
 	 * On non-powermacs, put all CPUs in spin-loops.
 	 *
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 7c0d391..fbd9b2b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -289,3 +289,16 @@ config HW_RANDOM_EXYNOS
 	  module will be called exynos-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_TPM
+	tristate "TPM HW Random Number Generator support"
+	depends on HW_RANDOM && TCG_TPM
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator in the Trusted Platform Module
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tpm-rng.
+
+	  If unsure, say Y.
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 39a757c..1fd7eec 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
 obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
+obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
new file mode 100644
index 0000000..d6d4482
--- /dev/null
+++ b/drivers/char/hw_random/tpm-rng.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2012 Kent Yoder IBM Corporation
+ *
+ * HWRNG interfaces to pull RNG data from a TPM
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/hw_random.h>
+#include <linux/tpm.h>
+
+#define MODULE_NAME "tpm-rng"
+
+static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	return tpm_get_random(TPM_ANY_NUM, data, max);
+}
+
+static struct hwrng tpm_rng = {
+	.name = MODULE_NAME,
+	.read = tpm_rng_read,
+};
+
+static int __init rng_init(void)
+{
+	return hwrng_register(&tpm_rng);
+}
+module_init(rng_init);
+
+static void __exit rng_exit(void)
+{
+	hwrng_unregister(&tpm_rng);
+}
+module_exit(rng_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Kent Yoder <key@linux.vnet.ibm.com>");
+MODULE_DESCRIPTION("RNG driver for TPM devices");
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index a048199..915875e 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -33,6 +33,17 @@ config TCG_TIS
 	  from within Linux.  To compile this driver as a module, choose
 	  M here; the module will be called tpm_tis.
 
+config TCG_TIS_I2C_INFINEON
+	tristate "TPM Interface Specification 1.2 Interface (I2C - Infineon)"
+	depends on I2C
+	---help---
+	  If you have a TPM security chip that is compliant with the
+	  TCG TIS 1.2 TPM specification and Infineon's I2C Protocol Stack
+	  Specification 0.20 say Yes and it will be accessible from within
+	  Linux.
+	  To compile this driver as a module, choose M here; the module
+	  will be called tpm_tis_i2c_infineon.
+
 config TCG_NSC
 	tristate "National Semiconductor TPM Interface"
 	depends on X86
@@ -62,4 +73,12 @@ config TCG_INFINEON
 	  Further information on this driver and the supported hardware
 	  can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
 
+config TCG_IBMVTPM
+	tristate "IBM VTPM Interface"
+	depends on PPC64
+	---help---
+	  If you have IBM virtual TPM (VTPM) support say Yes and it
+	  will be accessible from within Linux.  To compile this driver
+	  as a module, choose M here; the module will be called tpm_ibmvtpm.
+
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index ea3a1e0..5b3fc8b 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -4,8 +4,16 @@
 obj-$(CONFIG_TCG_TPM) += tpm.o
 ifdef CONFIG_ACPI
 	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
+	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o tpm_ppi.o
+else
+ifdef CONFIG_TCG_IBMVTPM
+	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
+	tpm_bios-objs += tpm_eventlog.o tpm_of.o
+endif
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
+obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o
 obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
 obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
 obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
+obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 817f0ee..39526c0 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -30,12 +30,7 @@
 #include <linux/freezer.h>
 
 #include "tpm.h"
-
-enum tpm_const {
-	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 4096,
-	TPM_NUM_DEVICES = 256,
-};
+#include "tpm_eventlog.h"
 
 enum tpm_duration {
 	TPM_SHORT = 0,
@@ -482,6 +477,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 #define TPM_INTERNAL_RESULT_SIZE 200
 #define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
 #define TPM_ORD_GET_CAP cpu_to_be32(101)
+#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
 
 static const struct tpm_input_header tpm_getcap_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
@@ -1175,7 +1171,7 @@ int tpm_release(struct inode *inode, struct file *file)
 	flush_work_sync(&chip->work);
 	file->private_data = NULL;
 	atomic_set(&chip->data_pending, 0);
-	kfree(chip->data_buffer);
+	kzfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
 	return 0;
@@ -1227,7 +1223,6 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
 	ret_size = atomic_read(&chip->data_pending);
-	atomic_set(&chip->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
 		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
@@ -1242,6 +1237,8 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 		mutex_unlock(&chip->buffer_mutex);
 	}
 
+	atomic_set(&chip->data_pending, 0);
+
 	return ret_size;
 }
 EXPORT_SYMBOL_GPL(tpm_read);
@@ -1326,6 +1323,58 @@ int tpm_pm_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
+#define TPM_GETRANDOM_RESULT_SIZE	18
+static struct tpm_input_header tpm_getrandom_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(14),
+	.ordinal = TPM_ORD_GET_RANDOM
+};
+
+/**
+ * tpm_get_random() - Get random bytes from the tpm's RNG
+ * @chip_num: A specific chip number for the request or TPM_ANY_NUM
+ * @out: destination buffer for the random bytes
+ * @max: the max number of bytes to write to @out
+ *
+ * Returns < 0 on error and the number of bytes read on success
+ */
+int tpm_get_random(u32 chip_num, u8 *out, size_t max)
+{
+	struct tpm_chip *chip;
+	struct tpm_cmd_t tpm_cmd;
+	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
+	int err, total = 0, retries = 5;
+	u8 *dest = out;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
+		return -EINVAL;
+
+	do {
+		tpm_cmd.header.in = tpm_getrandom_header;
+		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
+
+		err = transmit_cmd(chip, &tpm_cmd,
+				   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
+				   "attempting get random");
+		if (err)
+			break;
+
+		recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
+		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
+
+		dest += recd;
+		total += recd;
+		num_bytes -= recd;
+	} while (retries-- && total < max);
+
+	return total ? total : -EIO;
+}
+EXPORT_SYMBOL_GPL(tpm_get_random);
+
 /* In case vendor provided release function, call it too.*/
 
 void tpm_dev_vendor_release(struct tpm_chip *chip)
@@ -1427,6 +1476,11 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 		goto put_device;
 	}
 
+	if (sys_add_ppi(&dev->kobj)) {
+		misc_deregister(&chip->vendor.miscdev);
+		goto put_device;
+	}
+
 	chip->bios_dir = tpm_bios_log_setup(devname);
 
 	/* Make chip available */
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 917f727..02c266a 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -28,6 +28,12 @@
 #include <linux/io.h>
 #include <linux/tpm.h>
 
+enum tpm_const {
+	TPM_MINOR = 224,	/* officially assigned */
+	TPM_BUFSIZE = 4096,
+	TPM_NUM_DEVICES = 256,
+};
+
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
 };
@@ -94,6 +100,7 @@ struct tpm_vendor_specific {
 	bool timeout_adjusted;
 	unsigned long duration[3]; /* jiffies */
 	bool duration_adjusted;
+	void *data;
 
 	wait_queue_head_t read_queue;
 	wait_queue_head_t int_queue;
@@ -269,6 +276,21 @@ struct tpm_pcrextend_in {
 	u8	hash[TPM_DIGEST_SIZE];
 }__attribute__((packed));
 
+/* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
+ * bytes, but 128 is still a relatively large number of random bytes and
+ * anything much bigger causes users of struct tpm_cmd_t to start getting
+ * compiler warnings about stack frame size. */
+#define TPM_MAX_RNG_DATA	128
+
+struct tpm_getrandom_out {
+	__be32 rng_data_len;
+	u8     rng_data[TPM_MAX_RNG_DATA];
+}__attribute__((packed));
+
+struct tpm_getrandom_in {
+	__be32 num_bytes;
+}__attribute__((packed));
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -277,6 +299,8 @@ typedef union {
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_pcrextend_in pcrextend_in;
+	struct	tpm_getrandom_in getrandom_in;
+	struct	tpm_getrandom_out getrandom_out;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
@@ -303,15 +327,12 @@ extern int tpm_pm_suspend(struct device *);
 extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *);
+
 #ifdef CONFIG_ACPI
-extern struct dentry ** tpm_bios_log_setup(char *);
-extern void tpm_bios_log_teardown(struct dentry **);
+extern ssize_t sys_add_ppi(struct kobject *parent);
 #else
-static inline struct dentry ** tpm_bios_log_setup(char *name)
-{
-	return NULL;
-}
-static inline void tpm_bios_log_teardown(struct dentry **dir)
+static inline ssize_t sys_add_ppi(struct kobject *parent)
 {
+	return 0;
 }
 #endif
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
new file mode 100644
index 0000000..fe3fa94
--- /dev/null
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -0,0 +1,109 @@
+/*
+ * Copyright (C) 2005 IBM Corporation
+ *
+ * Authors:
+ *	Seiji Munetoh <munetoh@jp.ibm.com>
+ *	Stefan Berger <stefanb@us.ibm.com>
+ *	Reiner Sailer <sailer@watson.ibm.com>
+ *	Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * Access to the eventlog extended by the TCG BIOS of PC platform
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <acpi/acpi.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+struct acpi_tcpa {
+	struct acpi_table_header hdr;
+	u16 platform_class;
+	union {
+		struct client_hdr {
+			u32 log_max_len __attribute__ ((packed));
+			u64 log_start_addr __attribute__ ((packed));
+		} client;
+		struct server_hdr {
+			u16 reserved;
+			u64 log_max_len __attribute__ ((packed));
+			u64 log_start_addr __attribute__ ((packed));
+		} server;
+	};
+};
+
+/* read binary bios log */
+int read_log(struct tpm_bios_log *log)
+{
+	struct acpi_tcpa *buff;
+	acpi_status status;
+	struct acpi_table_header *virt;
+	u64 len, start;
+
+	if (log->bios_event_log != NULL) {
+		printk(KERN_ERR
+		       "%s: ERROR - Eventlog already initialized\n",
+		       __func__);
+		return -EFAULT;
+	}
+
+	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
+	status = acpi_get_table(ACPI_SIG_TCPA, 1,
+				(struct acpi_table_header **)&buff);
+
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
+		       __func__);
+		return -EIO;
+	}
+
+	switch(buff->platform_class) {
+	case BIOS_SERVER:
+		len = buff->server.log_max_len;
+		start = buff->server.log_start_addr;
+		break;
+	case BIOS_CLIENT:
+	default:
+		len = buff->client.log_max_len;
+		start = buff->client.log_start_addr;
+		break;
+	}
+	if (!len) {
+		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n", __func__);
+		return -EIO;
+	}
+
+	/* malloc EventLog space */
+	log->bios_event_log = kmalloc(len, GFP_KERNEL);
+	if (!log->bios_event_log) {
+		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	log->bios_event_log_end = log->bios_event_log + len;
+
+	virt = acpi_os_map_memory(start, len);
+	if (!virt) {
+		kfree(log->bios_event_log);
+		printk("%s: ERROR - Unable to map memory\n", __func__);
+		return -EIO;
+	}
+
+	memcpy(log->bios_event_log, virt, len);
+
+	acpi_os_unmap_memory(virt, len);
+	return 0;
+}
diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_eventlog.c
similarity index 75%
rename from drivers/char/tpm/tpm_bios.c
rename to drivers/char/tpm/tpm_eventlog.c
index 0636520..84ddc55 100644
--- a/drivers/char/tpm/tpm_bios.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (C) 2005 IBM Corporation
+ * Copyright (C) 2005, 2012 IBM Corporation
  *
  * Authors:
+ *	Kent Yoder <key@linux.vnet.ibm.com>
  *	Seiji Munetoh <munetoh@jp.ibm.com>
  *	Stefan Berger <stefanb@us.ibm.com>
  *	Reiner Sailer <sailer@watson.ibm.com>
@@ -9,7 +10,7 @@
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
- * Access to the eventlog extended by the TCG BIOS of PC platform
+ * Access to the eventlog created by a system's firmware / BIOS
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -23,67 +24,10 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <acpi/acpi.h>
-#include "tpm.h"
-
-#define TCG_EVENT_NAME_LEN_MAX	255
-#define MAX_TEXT_EVENT		1000	/* Max event string length */
-#define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
-
-enum bios_platform_class {
-	BIOS_CLIENT = 0x00,
-	BIOS_SERVER = 0x01,
-};
-
-struct tpm_bios_log {
-	void *bios_event_log;
-	void *bios_event_log_end;
-};
-
-struct acpi_tcpa {
-	struct acpi_table_header hdr;
-	u16 platform_class;
-	union {
-		struct client_hdr {
-			u32 log_max_len __attribute__ ((packed));
-			u64 log_start_addr __attribute__ ((packed));
-		} client;
-		struct server_hdr {
-			u16 reserved;
-			u64 log_max_len __attribute__ ((packed));
-			u64 log_start_addr __attribute__ ((packed));
-		} server;
-	};
-};
 
-struct tcpa_event {
-	u32 pcr_index;
-	u32 event_type;
-	u8 pcr_value[20];	/* SHA1 */
-	u32 event_size;
-	u8 event_data[0];
-};
+#include "tpm.h"
+#include "tpm_eventlog.h"
 
-enum tcpa_event_types {
-	PREBOOT = 0,
-	POST_CODE,
-	UNUSED,
-	NO_ACTION,
-	SEPARATOR,
-	ACTION,
-	EVENT_TAG,
-	SCRTM_CONTENTS,
-	SCRTM_VERSION,
-	CPU_MICROCODE,
-	PLATFORM_CONFIG_FLAGS,
-	TABLE_OF_DEVICES,
-	COMPACT_HASH,
-	IPL,
-	IPL_PARTITION_DATA,
-	NONHOST_CODE,
-	NONHOST_CONFIG,
-	NONHOST_INFO,
-};
 
 static const char* tcpa_event_type_strings[] = {
 	"PREBOOT",
@@ -106,28 +50,6 @@ static const char* tcpa_event_type_strings[] = {
 	"Non-Host Info"
 };
 
-struct tcpa_pc_event {
-	u32 event_id;
-	u32 event_size;
-	u8 event_data[0];
-};
-
-enum tcpa_pc_event_ids {
-	SMBIOS = 1,
-	BIS_CERT,
-	POST_BIOS_ROM,
-	ESCD,
-	CMOS,
-	NVRAM,
-	OPTION_ROM_EXEC,
-	OPTION_ROM_CONFIG,
-	OPTION_ROM_MICROCODE = 10,
-	S_CRTM_VERSION,
-	S_CRTM_CONTENTS,
-	POST_CONTENTS,
-	HOST_TABLE_OF_DEVICES,
-};
-
 static const char* tcpa_pc_event_id_strings[] = {
 	"",
 	"SMBIOS",
@@ -358,65 +280,6 @@ static const struct seq_operations tpm_binary_b_measurments_seqops = {
 	.show = tpm_binary_bios_measurements_show,
 };
 
-/* read binary bios log */
-static int read_log(struct tpm_bios_log *log)
-{
-	struct acpi_tcpa *buff;
-	acpi_status status;
-	struct acpi_table_header *virt;
-	u64 len, start;
-
-	if (log->bios_event_log != NULL) {
-		printk(KERN_ERR
-		       "%s: ERROR - Eventlog already initialized\n",
-		       __func__);
-		return -EFAULT;
-	}
-
-	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
-	status = acpi_get_table(ACPI_SIG_TCPA, 1,
-				(struct acpi_table_header **)&buff);
-
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
-		       __func__);
-		return -EIO;
-	}
-
-	switch(buff->platform_class) {
-	case BIOS_SERVER:
-		len = buff->server.log_max_len;
-		start = buff->server.log_start_addr;
-		break;
-	case BIOS_CLIENT:
-	default:
-		len = buff->client.log_max_len;
-		start = buff->client.log_start_addr;
-		break;
-	}
-	if (!len) {
-		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n", __func__);
-		return -EIO;
-	}
-
-	/* malloc EventLog space */
-	log->bios_event_log = kmalloc(len, GFP_KERNEL);
-	if (!log->bios_event_log) {
-		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	log->bios_event_log_end = log->bios_event_log + len;
-
-	virt = acpi_os_map_memory(start, len);
-
-	memcpy(log->bios_event_log, virt, len);
-
-	acpi_os_unmap_memory(virt, len);
-	return 0;
-}
-
 static int tpm_ascii_bios_measurements_open(struct inode *inode,
 					    struct file *file)
 {
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
new file mode 100644
index 0000000..e7da086
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -0,0 +1,86 @@
+
+#ifndef __TPM_EVENTLOG_H__
+#define __TPM_EVENTLOG_H__
+
+#define TCG_EVENT_NAME_LEN_MAX	255
+#define MAX_TEXT_EVENT		1000	/* Max event string length */
+#define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
+
+enum bios_platform_class {
+	BIOS_CLIENT = 0x00,
+	BIOS_SERVER = 0x01,
+};
+
+struct tpm_bios_log {
+	void *bios_event_log;
+	void *bios_event_log_end;
+};
+
+struct tcpa_event {
+	u32 pcr_index;
+	u32 event_type;
+	u8 pcr_value[20];	/* SHA1 */
+	u32 event_size;
+	u8 event_data[0];
+};
+
+enum tcpa_event_types {
+	PREBOOT = 0,
+	POST_CODE,
+	UNUSED,
+	NO_ACTION,
+	SEPARATOR,
+	ACTION,
+	EVENT_TAG,
+	SCRTM_CONTENTS,
+	SCRTM_VERSION,
+	CPU_MICROCODE,
+	PLATFORM_CONFIG_FLAGS,
+	TABLE_OF_DEVICES,
+	COMPACT_HASH,
+	IPL,
+	IPL_PARTITION_DATA,
+	NONHOST_CODE,
+	NONHOST_CONFIG,
+	NONHOST_INFO,
+};
+
+struct tcpa_pc_event {
+	u32 event_id;
+	u32 event_size;
+	u8 event_data[0];
+};
+
+enum tcpa_pc_event_ids {
+	SMBIOS = 1,
+	BIS_CERT,
+	POST_BIOS_ROM,
+	ESCD,
+	CMOS,
+	NVRAM,
+	OPTION_ROM_EXEC,
+	OPTION_ROM_CONFIG,
+	OPTION_ROM_MICROCODE = 10,
+	S_CRTM_VERSION,
+	S_CRTM_CONTENTS,
+	POST_CONTENTS,
+	HOST_TABLE_OF_DEVICES,
+};
+
+int read_log(struct tpm_bios_log *log);
+
+#if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
+	defined(CONFIG_ACPI)
+extern struct dentry **tpm_bios_log_setup(char *);
+extern void tpm_bios_log_teardown(struct dentry **);
+#else
+static inline struct dentry **tpm_bios_log_setup(char *name)
+{
+	return NULL;
+}
+static inline void tpm_bios_log_teardown(struct dentry **dir)
+{
+}
+#endif
+
+#endif
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
new file mode 100644
index 0000000..5a831ae
--- /dev/null
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -0,0 +1,695 @@
+/*
+ * Copyright (C) 2012 Infineon Technologies
+ *
+ * Authors:
+ * Peter Huewe <peter.huewe@infineon.com>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This device driver implements the TPM interface as defined in
+ * the TCG TPM Interface Spec version 1.2, revision 1.0 and the
+ * Infineon I2C Protocol Stack Specification v0.20.
+ *
+ * It is based on the original tpm_tis device driver from Leendert van
+ * Dorn and Kyleen Hall.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ *
+ */
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/wait.h>
+#include "tpm.h"
+
+/* max. buffer size supported by our TPM */
+#define TPM_BUFSIZE 1260
+
+/* max. number of iterations after I2C NAK */
+#define MAX_COUNT 3
+
+#define SLEEP_DURATION_LOW 55
+#define SLEEP_DURATION_HI 65
+
+/* max. number of iterations after I2C NAK for 'long' commands
+ * we need this especially for sending TPM_READY, since the cleanup after the
+ * transtion to the ready state may take some time, but it is unpredictable
+ * how long it will take.
+ */
+#define MAX_COUNT_LONG 50
+
+#define SLEEP_DURATION_LONG_LOW 200
+#define SLEEP_DURATION_LONG_HI 220
+
+/* After sending TPM_READY to 'reset' the TPM we have to sleep even longer */
+#define SLEEP_DURATION_RESET_LOW 2400
+#define SLEEP_DURATION_RESET_HI 2600
+
+/* we want to use usleep_range instead of msleep for the 5ms TPM_TIMEOUT */
+#define TPM_TIMEOUT_US_LOW (TPM_TIMEOUT * 1000)
+#define TPM_TIMEOUT_US_HI  (TPM_TIMEOUT_US_LOW + 2000)
+
+/* expected value for DIDVID register */
+#define TPM_TIS_I2C_DID_VID 0x000b15d1L
+
+/* Structure to store I2C TPM specific stuff */
+struct tpm_inf_dev {
+	struct i2c_client *client;
+	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
+	struct tpm_chip *chip;
+};
+
+static struct tpm_inf_dev tpm_dev;
+static struct i2c_driver tpm_tis_i2c_driver;
+
+/*
+ * iic_tpm_read() - read from TPM register
+ * @addr: register address to read from
+ * @buffer: provided by caller
+ * @len: number of bytes to read
+ *
+ * Read len bytes from TPM register and put them into
+ * buffer (little-endian format, i.e. first byte is put into buffer[0]).
+ *
+ * NOTE: TPM is big-endian for multi-byte values. Multi-byte
+ * values have to be swapped.
+ *
+ * NOTE: We can't unfortunately use the combined read/write functions
+ * provided by the i2c core as the TPM currently does not support the
+ * repeated start condition and due to it's special requirements.
+ * The i2c_smbus* functions do not work for this chip.
+ *
+ * Return -EIO on error, 0 on success.
+ */
+static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
+{
+
+	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, 1, &addr };
+	struct i2c_msg msg2 = { tpm_dev.client->addr, I2C_M_RD, len, buffer };
+
+	int rc;
+	int count;
+
+	/* Lock the adapter for the duration of the whole sequence. */
+	if (!tpm_dev.client->adapter->algo->master_xfer)
+		return -EOPNOTSUPP;
+	i2c_lock_adapter(tpm_dev.client->adapter);
+
+	for (count = 0; count < MAX_COUNT; count++) {
+		rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
+		if (rc > 0)
+			break;	/* break here to skip sleep */
+
+		usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+	}
+
+	if (rc <= 0)
+		goto out;
+
+	/* After the TPM has successfully received the register address it needs
+	 * some time, thus we're sleeping here again, before retrieving the data
+	 */
+	for (count = 0; count < MAX_COUNT; count++) {
+		usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+		rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
+		if (rc > 0)
+			break;
+
+	}
+
+out:
+	i2c_unlock_adapter(tpm_dev.client->adapter);
+	if (rc <= 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
+				 unsigned int sleep_low,
+				 unsigned int sleep_hi, u8 max_count)
+{
+	int rc = -EIO;
+	int count;
+
+	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, len + 1, tpm_dev.buf };
+
+	if (len > TPM_BUFSIZE)
+		return -EINVAL;
+
+	if (!tpm_dev.client->adapter->algo->master_xfer)
+		return -EOPNOTSUPP;
+	i2c_lock_adapter(tpm_dev.client->adapter);
+
+	/* prepend the 'register address' to the buffer */
+	tpm_dev.buf[0] = addr;
+	memcpy(&(tpm_dev.buf[1]), buffer, len);
+
+	/*
+	 * NOTE: We have to use these special mechanisms here and unfortunately
+	 * cannot rely on the standard behavior of i2c_transfer.
+	 */
+	for (count = 0; count < max_count; count++) {
+		rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
+		if (rc > 0)
+			break;
+
+		usleep_range(sleep_low, sleep_hi);
+	}
+
+	i2c_unlock_adapter(tpm_dev.client->adapter);
+	if (rc <= 0)
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * iic_tpm_write() - write to TPM register
+ * @addr: register address to write to
+ * @buffer: containing data to be written
+ * @len: number of bytes to write
+ *
+ * Write len bytes from provided buffer to TPM register (little
+ * endian format, i.e. buffer[0] is written as first byte).
+ *
+ * NOTE: TPM is big-endian for multi-byte values. Multi-byte
+ * values have to be swapped.
+ *
+ * NOTE: use this function instead of the iic_tpm_write_generic function.
+ *
+ * Return -EIO on error, 0 on success
+ */
+static int iic_tpm_write(u8 addr, u8 *buffer, size_t len)
+{
+	return iic_tpm_write_generic(addr, buffer, len, SLEEP_DURATION_LOW,
+				     SLEEP_DURATION_HI, MAX_COUNT);
+}
+
+/*
+ * This function is needed especially for the cleanup situation after
+ * sending TPM_READY
+ * */
+static int iic_tpm_write_long(u8 addr, u8 *buffer, size_t len)
+{
+	return iic_tpm_write_generic(addr, buffer, len, SLEEP_DURATION_LONG_LOW,
+				     SLEEP_DURATION_LONG_HI, MAX_COUNT_LONG);
+}
+
+enum tis_access {
+	TPM_ACCESS_VALID = 0x80,
+	TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
+	TPM_ACCESS_REQUEST_PENDING = 0x04,
+	TPM_ACCESS_REQUEST_USE = 0x02,
+};
+
+enum tis_status {
+	TPM_STS_VALID = 0x80,
+	TPM_STS_COMMAND_READY = 0x40,
+	TPM_STS_GO = 0x20,
+	TPM_STS_DATA_AVAIL = 0x10,
+	TPM_STS_DATA_EXPECT = 0x08,
+};
+
+enum tis_defaults {
+	TIS_SHORT_TIMEOUT = 750,	/* ms */
+	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
+};
+
+#define	TPM_ACCESS(l)			(0x0000 | ((l) << 4))
+#define	TPM_STS(l)			(0x0001 | ((l) << 4))
+#define	TPM_DATA_FIFO(l)		(0x0005 | ((l) << 4))
+#define	TPM_DID_VID(l)			(0x0006 | ((l) << 4))
+
+static int check_locality(struct tpm_chip *chip, int loc)
+{
+	u8 buf;
+	int rc;
+
+	rc = iic_tpm_read(TPM_ACCESS(loc), &buf, 1);
+	if (rc < 0)
+		return rc;
+
+	if ((buf & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
+		chip->vendor.locality = loc;
+		return loc;
+	}
+
+	return -EIO;
+}
+
+/* implementation similar to tpm_tis */
+static void release_locality(struct tpm_chip *chip, int loc, int force)
+{
+	u8 buf;
+	if (iic_tpm_read(TPM_ACCESS(loc), &buf, 1) < 0)
+		return;
+
+	if (force || (buf & (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
+	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) {
+		buf = TPM_ACCESS_ACTIVE_LOCALITY;
+		iic_tpm_write(TPM_ACCESS(loc), &buf, 1);
+	}
+}
+
+static int request_locality(struct tpm_chip *chip, int loc)
+{
+	unsigned long stop;
+	u8 buf = TPM_ACCESS_REQUEST_USE;
+
+	if (check_locality(chip, loc) >= 0)
+		return loc;
+
+	iic_tpm_write(TPM_ACCESS(loc), &buf, 1);
+
+	/* wait for burstcount */
+	stop = jiffies + chip->vendor.timeout_a;
+	do {
+		if (check_locality(chip, loc) >= 0)
+			return loc;
+		usleep_range(TPM_TIMEOUT_US_LOW, TPM_TIMEOUT_US_HI);
+	} while (time_before(jiffies, stop));
+
+	return -ETIME;
+}
+
+static u8 tpm_tis_i2c_status(struct tpm_chip *chip)
+{
+	/* NOTE: since I2C read may fail, return 0 in this case --> time-out */
+	u8 buf;
+	if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
+		return 0;
+	else
+		return buf;
+}
+
+static void tpm_tis_i2c_ready(struct tpm_chip *chip)
+{
+	/* this causes the current command to be aborted */
+	u8 buf = TPM_STS_COMMAND_READY;
+	iic_tpm_write_long(TPM_STS(chip->vendor.locality), &buf, 1);
+}
+
+static ssize_t get_burstcount(struct tpm_chip *chip)
+{
+	unsigned long stop;
+	ssize_t burstcnt;
+	u8 buf[3];
+
+	/* wait for burstcount */
+	/* which timeout value, spec has 2 answers (c & d) */
+	stop = jiffies + chip->vendor.timeout_d;
+	do {
+		/* Note: STS is little endian */
+		if (iic_tpm_read(TPM_STS(chip->vendor.locality)+1, buf, 3) < 0)
+			burstcnt = 0;
+		else
+			burstcnt = (buf[2] << 16) + (buf[1] << 8) + buf[0];
+
+		if (burstcnt)
+			return burstcnt;
+
+		usleep_range(TPM_TIMEOUT_US_LOW, TPM_TIMEOUT_US_HI);
+	} while (time_before(jiffies, stop));
+	return -EBUSY;
+}
+
+static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
+			 int *status)
+{
+	unsigned long stop;
+
+	/* check current status */
+	*status = tpm_tis_i2c_status(chip);
+	if ((*status & mask) == mask)
+		return 0;
+
+	stop = jiffies + timeout;
+	do {
+		/* since we just checked the status, give the TPM some time */
+		usleep_range(TPM_TIMEOUT_US_LOW, TPM_TIMEOUT_US_HI);
+		*status = tpm_tis_i2c_status(chip);
+		if ((*status & mask) == mask)
+			return 0;
+
+	} while (time_before(jiffies, stop));
+
+	return -ETIME;
+}
+
+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	size_t size = 0;
+	ssize_t burstcnt;
+	u8 retries = 0;
+	int rc;
+
+	while (size < count) {
+		burstcnt = get_burstcount(chip);
+
+		/* burstcnt < 0 = TPM is busy */
+		if (burstcnt < 0)
+			return burstcnt;
+
+		/* limit received data to max. left */
+		if (burstcnt > (count - size))
+			burstcnt = count - size;
+
+		rc = iic_tpm_read(TPM_DATA_FIFO(chip->vendor.locality),
+				  &(buf[size]), burstcnt);
+		if (rc == 0)
+			size += burstcnt;
+		else if (rc < 0)
+			retries++;
+
+		/* avoid endless loop in case of broken HW */
+		if (retries > MAX_COUNT_LONG)
+			return -EIO;
+
+	}
+	return size;
+}
+
+static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	int size = 0;
+	int expected, status;
+
+	if (count < TPM_HEADER_SIZE) {
+		size = -EIO;
+		goto out;
+	}
+
+	/* read first 10 bytes, including tag, paramsize, and result */
+	size = recv_data(chip, buf, TPM_HEADER_SIZE);
+	if (size < TPM_HEADER_SIZE) {
+		dev_err(chip->dev, "Unable to read header\n");
+		goto out;
+	}
+
+	expected = be32_to_cpu(*(__be32 *)(buf + 2));
+	if ((size_t) expected > count) {
+		size = -EIO;
+		goto out;
+	}
+
+	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
+			  expected - TPM_HEADER_SIZE);
+	if (size < expected) {
+		dev_err(chip->dev, "Unable to read remainder of result\n");
+		size = -ETIME;
+		goto out;
+	}
+
+	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
+	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
+		dev_err(chip->dev, "Error left over data\n");
+		size = -EIO;
+		goto out;
+	}
+
+out:
+	tpm_tis_i2c_ready(chip);
+	/* The TPM needs some time to clean up here,
+	 * so we sleep rather than keeping the bus busy
+	 */
+	usleep_range(SLEEP_DURATION_RESET_LOW, SLEEP_DURATION_RESET_HI);
+	release_locality(chip, chip->vendor.locality, 0);
+	return size;
+}
+
+static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc, status;
+	ssize_t burstcnt;
+	size_t count = 0;
+	u8 retries = 0;
+	u8 sts = TPM_STS_GO;
+
+	if (len > TPM_BUFSIZE)
+		return -E2BIG;	/* command is too long for our tpm, sorry */
+
+	if (request_locality(chip, 0) < 0)
+		return -EBUSY;
+
+	status = tpm_tis_i2c_status(chip);
+	if ((status & TPM_STS_COMMAND_READY) == 0) {
+		tpm_tis_i2c_ready(chip);
+		if (wait_for_stat
+		    (chip, TPM_STS_COMMAND_READY,
+		     chip->vendor.timeout_b, &status) < 0) {
+			rc = -ETIME;
+			goto out_err;
+		}
+	}
+
+	while (count < len - 1) {
+		burstcnt = get_burstcount(chip);
+
+		/* burstcnt < 0 = TPM is busy */
+		if (burstcnt < 0)
+			return burstcnt;
+
+		if (burstcnt > (len - 1 - count))
+			burstcnt = len - 1 - count;
+
+		rc = iic_tpm_write(TPM_DATA_FIFO(chip->vendor.locality),
+				   &(buf[count]), burstcnt);
+		if (rc == 0)
+			count += burstcnt;
+		else if (rc < 0)
+			retries++;
+
+		/* avoid endless loop in case of broken HW */
+		if (retries > MAX_COUNT_LONG) {
+			rc = -EIO;
+			goto out_err;
+		}
+
+		wait_for_stat(chip, TPM_STS_VALID,
+			      chip->vendor.timeout_c, &status);
+
+		if ((status & TPM_STS_DATA_EXPECT) == 0) {
+			rc = -EIO;
+			goto out_err;
+		}
+
+	}
+
+	/* write last byte */
+	iic_tpm_write(TPM_DATA_FIFO(chip->vendor.locality), &(buf[count]), 1);
+	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
+	if ((status & TPM_STS_DATA_EXPECT) != 0) {
+		rc = -EIO;
+		goto out_err;
+	}
+
+	/* go and do it */
+	iic_tpm_write(TPM_STS(chip->vendor.locality), &sts, 1);
+
+	return len;
+out_err:
+	tpm_tis_i2c_ready(chip);
+	/* The TPM needs some time to clean up here,
+	 * so we sleep rather than keeping the bus busy
+	 */
+	usleep_range(SLEEP_DURATION_RESET_LOW, SLEEP_DURATION_RESET_HI);
+	release_locality(chip, chip->vendor.locality, 0);
+	return rc;
+}
+
+static const struct file_operations tis_ops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpm_open,
+	.read = tpm_read,
+	.write = tpm_write,
+	.release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
+
+static struct attribute *tis_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr,
+	NULL,
+};
+
+static struct attribute_group tis_attr_grp = {
+	.attrs = tis_attrs
+};
+
+static struct tpm_vendor_specific tpm_tis_i2c = {
+	.status = tpm_tis_i2c_status,
+	.recv = tpm_tis_i2c_recv,
+	.send = tpm_tis_i2c_send,
+	.cancel = tpm_tis_i2c_ready,
+	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+	.req_canceled = TPM_STS_COMMAND_READY,
+	.attr_group = &tis_attr_grp,
+	.miscdev.fops = &tis_ops,
+};
+
+static int __devinit tpm_tis_i2c_init(struct device *dev)
+{
+	u32 vendor;
+	int rc = 0;
+	struct tpm_chip *chip;
+
+	chip = tpm_register_hardware(dev, &tpm_tis_i2c);
+	if (!chip) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	/* Disable interrupts */
+	chip->vendor.irq = 0;
+
+	/* Default timeouts */
+	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+
+	if (request_locality(chip, 0) != 0) {
+		rc = -ENODEV;
+		goto out_vendor;
+	}
+
+	/* read four bytes from DID_VID register */
+	if (iic_tpm_read(TPM_DID_VID(0), (u8 *)&vendor, 4) < 0) {
+		rc = -EIO;
+		goto out_release;
+	}
+
+	/* create DID_VID register value, after swapping to little-endian */
+	vendor = be32_to_cpu((__be32) vendor);
+
+	if (vendor != TPM_TIS_I2C_DID_VID) {
+		rc = -ENODEV;
+		goto out_release;
+	}
+
+	dev_info(dev, "1.2 TPM (device-id 0x%X)\n", vendor >> 16);
+
+	INIT_LIST_HEAD(&chip->vendor.list);
+	tpm_dev.chip = chip;
+
+	tpm_get_timeouts(chip);
+	tpm_do_selftest(chip);
+
+	return 0;
+
+out_release:
+	release_locality(chip, chip->vendor.locality, 1);
+
+out_vendor:
+	/* close file handles */
+	tpm_dev_vendor_release(chip);
+
+	/* remove hardware */
+	tpm_remove_hardware(chip->dev);
+
+	/* reset these pointers, otherwise we oops */
+	chip->dev->release = NULL;
+	chip->release = NULL;
+	tpm_dev.client = NULL;
+	dev_set_drvdata(chip->dev, chip);
+out_err:
+	return rc;
+}
+
+static const struct i2c_device_id tpm_tis_i2c_table[] = {
+	{"tpm_i2c_infineon", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, tpm_tis_i2c_table);
+static SIMPLE_DEV_PM_OPS(tpm_tis_i2c_ops, tpm_pm_suspend, tpm_pm_resume);
+
+static int __devinit tpm_tis_i2c_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
+{
+	int rc;
+	if (tpm_dev.client != NULL)
+		return -EBUSY;	/* We only support one client */
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+			"no algorithms associated to the i2c bus\n");
+		return -ENODEV;
+	}
+
+	client->driver = &tpm_tis_i2c_driver;
+	tpm_dev.client = client;
+	rc = tpm_tis_i2c_init(&client->dev);
+	if (rc != 0) {
+		client->driver = NULL;
+		tpm_dev.client = NULL;
+		rc = -ENODEV;
+	}
+	return rc;
+}
+
+static int __devexit tpm_tis_i2c_remove(struct i2c_client *client)
+{
+	struct tpm_chip *chip = tpm_dev.chip;
+	release_locality(chip, chip->vendor.locality, 1);
+
+	/* close file handles */
+	tpm_dev_vendor_release(chip);
+
+	/* remove hardware */
+	tpm_remove_hardware(chip->dev);
+
+	/* reset these pointers, otherwise we oops */
+	chip->dev->release = NULL;
+	chip->release = NULL;
+	tpm_dev.client = NULL;
+	dev_set_drvdata(chip->dev, chip);
+
+	return 0;
+}
+
+static struct i2c_driver tpm_tis_i2c_driver = {
+
+	.id_table = tpm_tis_i2c_table,
+	.probe = tpm_tis_i2c_probe,
+	.remove = tpm_tis_i2c_remove,
+	.driver = {
+		   .name = "tpm_i2c_infineon",
+		   .owner = THIS_MODULE,
+		   .pm = &tpm_tis_i2c_ops,
+		   },
+};
+
+module_i2c_driver(tpm_tis_i2c_driver);
+MODULE_AUTHOR("Peter Huewe <peter.huewe@infineon.com>");
+MODULE_DESCRIPTION("TPM TIS I2C Infineon Driver");
+MODULE_VERSION("2.1.5");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
new file mode 100644
index 0000000..efc4ab3
--- /dev/null
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -0,0 +1,749 @@
+/*
+ * Copyright (C) 2012 IBM Corporation
+ *
+ * Author: Ashley Lai <adlai@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/slab.h>
+#include <asm/vio.h>
+#include <asm/irq.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <asm/prom.h>
+
+#include "tpm.h"
+#include "tpm_ibmvtpm.h"
+
+static const char tpm_ibmvtpm_driver_name[] = "tpm_ibmvtpm";
+
+static struct vio_device_id tpm_ibmvtpm_device_table[] __devinitdata = {
+	{ "IBM,vtpm", "IBM,vtpm"},
+	{ "", "" }
+};
+MODULE_DEVICE_TABLE(vio, tpm_ibmvtpm_device_table);
+
+DECLARE_WAIT_QUEUE_HEAD(wq);
+
+/**
+ * ibmvtpm_send_crq - Send a CRQ request
+ * @vdev:	vio device struct
+ * @w1:		first word
+ * @w2:		second word
+ *
+ * Return value:
+ *	0 -Sucess
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
+{
+	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, w1, w2);
+}
+
+/**
+ * ibmvtpm_get_data - Retrieve ibm vtpm data
+ * @dev:	device struct
+ *
+ * Return value:
+ *	vtpm device struct
+ */
+static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	if (chip)
+		return (struct ibmvtpm_dev *)chip->vendor.data;
+	return NULL;
+}
+
+/**
+ * tpm_ibmvtpm_recv - Receive data after send
+ * @chip:	tpm chip struct
+ * @buf:	buffer to read
+ * count:	size of buffer
+ *
+ * Return value:
+ *	Number of bytes read
+ */
+static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct ibmvtpm_dev *ibmvtpm;
+	u16 len;
+
+	ibmvtpm = (struct ibmvtpm_dev *)chip->vendor.data;
+
+	if (!ibmvtpm->rtce_buf) {
+		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
+		return 0;
+	}
+
+	wait_event_interruptible(wq, ibmvtpm->crq_res.len != 0);
+
+	if (count < ibmvtpm->crq_res.len) {
+		dev_err(ibmvtpm->dev,
+			"Invalid size in recv: count=%ld, crq_size=%d\n",
+			count, ibmvtpm->crq_res.len);
+		return -EIO;
+	}
+
+	spin_lock(&ibmvtpm->rtce_lock);
+	memcpy((void *)buf, (void *)ibmvtpm->rtce_buf, ibmvtpm->crq_res.len);
+	memset(ibmvtpm->rtce_buf, 0, ibmvtpm->crq_res.len);
+	ibmvtpm->crq_res.valid = 0;
+	ibmvtpm->crq_res.msg = 0;
+	len = ibmvtpm->crq_res.len;
+	ibmvtpm->crq_res.len = 0;
+	spin_unlock(&ibmvtpm->rtce_lock);
+	return len;
+}
+
+/**
+ * tpm_ibmvtpm_send - Send tpm request
+ * @chip:	tpm chip struct
+ * @buf:	buffer contains data to send
+ * count:	size of buffer
+ *
+ * Return value:
+ *	Number of bytes sent
+ */
+static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct ibmvtpm_dev *ibmvtpm;
+	struct ibmvtpm_crq crq;
+	u64 *word = (u64 *) &crq;
+	int rc;
+
+	ibmvtpm = (struct ibmvtpm_dev *)chip->vendor.data;
+
+	if (!ibmvtpm->rtce_buf) {
+		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
+		return 0;
+	}
+
+	if (count > ibmvtpm->rtce_size) {
+		dev_err(ibmvtpm->dev,
+			"Invalid size in send: count=%ld, rtce_size=%d\n",
+			count, ibmvtpm->rtce_size);
+		return -EIO;
+	}
+
+	spin_lock(&ibmvtpm->rtce_lock);
+	memcpy((void *)ibmvtpm->rtce_buf, (void *)buf, count);
+	crq.valid = (u8)IBMVTPM_VALID_CMD;
+	crq.msg = (u8)VTPM_TPM_COMMAND;
+	crq.len = (u16)count;
+	crq.data = ibmvtpm->rtce_dma_handle;
+
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev, word[0], word[1]);
+	if (rc != H_SUCCESS) {
+		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
+		rc = 0;
+	} else
+		rc = count;
+
+	spin_unlock(&ibmvtpm->rtce_lock);
+	return rc;
+}
+
+static void tpm_ibmvtpm_cancel(struct tpm_chip *chip)
+{
+	return;
+}
+
+static u8 tpm_ibmvtpm_status(struct tpm_chip *chip)
+{
+	return 0;
+}
+
+/**
+ * ibmvtpm_crq_get_rtce_size - Send a CRQ request to get rtce size
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return value:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
+{
+	struct ibmvtpm_crq crq;
+	u64 *buf = (u64 *) &crq;
+	int rc;
+
+	crq.valid = (u8)IBMVTPM_VALID_CMD;
+	crq.msg = (u8)VTPM_GET_RTCE_BUFFER_SIZE;
+
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev, buf[0], buf[1]);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"ibmvtpm_crq_get_rtce_size failed rc=%d\n", rc);
+
+	return rc;
+}
+
+/**
+ * ibmvtpm_crq_get_version - Send a CRQ request to get vtpm version
+ *			   - Note that this is vtpm version and not tpm version
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return value:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
+{
+	struct ibmvtpm_crq crq;
+	u64 *buf = (u64 *) &crq;
+	int rc;
+
+	crq.valid = (u8)IBMVTPM_VALID_CMD;
+	crq.msg = (u8)VTPM_GET_VERSION;
+
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev, buf[0], buf[1]);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"ibmvtpm_crq_get_version failed rc=%d\n", rc);
+
+	return rc;
+}
+
+/**
+ * ibmvtpm_crq_send_init_complete - Send a CRQ initialize complete message
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return value:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
+{
+	int rc;
+
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_COMP_CMD, 0);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"ibmvtpm_crq_send_init_complete failed rc=%d\n", rc);
+
+	return rc;
+}
+
+/**
+ * ibmvtpm_crq_send_init - Send a CRQ initialize message
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return value:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
+{
+	int rc;
+
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_CMD, 0);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"ibmvtpm_crq_send_init failed rc=%d\n", rc);
+
+	return rc;
+}
+
+/**
+ * tpm_ibmvtpm_remove - ibm vtpm remove entry point
+ * @vdev:	vio device struct
+ *
+ * Return value:
+ *	0
+ */
+static int __devexit tpm_ibmvtpm_remove(struct vio_dev *vdev)
+{
+	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(&vdev->dev);
+	int rc = 0;
+
+	free_irq(vdev->irq, ibmvtpm);
+	tasklet_kill(&ibmvtpm->tasklet);
+
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+
+	dma_unmap_single(ibmvtpm->dev, ibmvtpm->crq_dma_handle,
+			 CRQ_RES_BUF_SIZE, DMA_BIDIRECTIONAL);
+	free_page((unsigned long)ibmvtpm->crq_queue.crq_addr);
+
+	if (ibmvtpm->rtce_buf) {
+		dma_unmap_single(ibmvtpm->dev, ibmvtpm->rtce_dma_handle,
+				 ibmvtpm->rtce_size, DMA_BIDIRECTIONAL);
+		kfree(ibmvtpm->rtce_buf);
+	}
+
+	tpm_remove_hardware(ibmvtpm->dev);
+
+	kfree(ibmvtpm);
+
+	return 0;
+}
+
+/**
+ * tpm_ibmvtpm_get_desired_dma - Get DMA size needed by this driver
+ * @vdev:	vio device struct
+ *
+ * Return value:
+ *	Number of bytes the driver needs to DMA map
+ */
+static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
+{
+	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(&vdev->dev);
+	return CRQ_RES_BUF_SIZE + ibmvtpm->rtce_size;
+}
+
+/**
+ * tpm_ibmvtpm_suspend - Suspend
+ * @dev:	device struct
+ *
+ * Return value:
+ *	0
+ */
+static int tpm_ibmvtpm_suspend(struct device *dev)
+{
+	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
+	struct ibmvtpm_crq crq;
+	u64 *buf = (u64 *) &crq;
+	int rc = 0;
+
+	crq.valid = (u8)IBMVTPM_VALID_CMD;
+	crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
+
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev, buf[0], buf[1]);
+	if (rc != H_SUCCESS)
+		dev_err(ibmvtpm->dev,
+			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
+
+	return rc;
+}
+
+/**
+ * ibmvtpm_reset_crq - Reset CRQ
+ * @ibmvtpm:	ibm vtpm struct
+ *
+ * Return value:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
+{
+	int rc = 0;
+
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_FREE_CRQ,
+					ibmvtpm->vdev->unit_address);
+	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+
+	memset(ibmvtpm->crq_queue.crq_addr, 0, CRQ_RES_BUF_SIZE);
+	ibmvtpm->crq_queue.index = 0;
+
+	return plpar_hcall_norets(H_REG_CRQ, ibmvtpm->vdev->unit_address,
+				  ibmvtpm->crq_dma_handle, CRQ_RES_BUF_SIZE);
+}
+
+/**
+ * tpm_ibmvtpm_resume - Resume from suspend
+ * @dev:	device struct
+ *
+ * Return value:
+ *	0
+ */
+static int tpm_ibmvtpm_resume(struct device *dev)
+{
+	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
+	unsigned long flags;
+	int rc = 0;
+
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_ENABLE_CRQ,
+					ibmvtpm->vdev->unit_address);
+	} while (rc == H_IN_PROGRESS || rc == H_BUSY || H_IS_LONG_BUSY(rc));
+
+	if (rc) {
+		dev_err(dev, "Error enabling ibmvtpm rc=%d\n", rc);
+		return rc;
+	}
+
+	spin_lock_irqsave(&ibmvtpm->lock, flags);
+	vio_disable_interrupts(ibmvtpm->vdev);
+	tasklet_schedule(&ibmvtpm->tasklet);
+	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
+
+	rc = ibmvtpm_crq_send_init(ibmvtpm);
+	if (rc)
+		dev_err(dev, "Error send_init rc=%d\n", rc);
+
+	return rc;
+}
+
+static const struct file_operations ibmvtpm_ops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpm_open,
+	.read = tpm_read,
+	.write = tpm_write,
+	.release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
+		   NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
+
+static struct attribute *ibmvtpm_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr, NULL,
+};
+
+static struct attribute_group ibmvtpm_attr_grp = { .attrs = ibmvtpm_attrs };
+
+static const struct tpm_vendor_specific tpm_ibmvtpm = {
+	.recv = tpm_ibmvtpm_recv,
+	.send = tpm_ibmvtpm_send,
+	.cancel = tpm_ibmvtpm_cancel,
+	.status = tpm_ibmvtpm_status,
+	.req_complete_mask = 0,
+	.req_complete_val = 0,
+	.req_canceled = 0,
+	.attr_group = &ibmvtpm_attr_grp,
+	.miscdev = { .fops = &ibmvtpm_ops, },
+};
+
+static const struct dev_pm_ops tpm_ibmvtpm_pm_ops = {
+	.suspend = tpm_ibmvtpm_suspend,
+	.resume = tpm_ibmvtpm_resume,
+};
+
+/**
+ * ibmvtpm_crq_get_next - Get next responded crq
+ * @ibmvtpm	vtpm device struct
+ *
+ * Return value:
+ *	vtpm crq pointer
+ */
+static struct ibmvtpm_crq *ibmvtpm_crq_get_next(struct ibmvtpm_dev *ibmvtpm)
+{
+	struct ibmvtpm_crq_queue *crq_q = &ibmvtpm->crq_queue;
+	struct ibmvtpm_crq *crq = &crq_q->crq_addr[crq_q->index];
+
+	if (crq->valid & VTPM_MSG_RES) {
+		if (++crq_q->index == crq_q->num_entry)
+			crq_q->index = 0;
+		rmb();
+	} else
+		crq = NULL;
+	return crq;
+}
+
+/**
+ * ibmvtpm_crq_process - Process responded crq
+ * @crq		crq to be processed
+ * @ibmvtpm	vtpm device struct
+ *
+ * Return value:
+ *	Nothing
+ */
+static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
+				struct ibmvtpm_dev *ibmvtpm)
+{
+	int rc = 0;
+
+	switch (crq->valid) {
+	case VALID_INIT_CRQ:
+		switch (crq->msg) {
+		case INIT_CRQ_RES:
+			dev_info(ibmvtpm->dev, "CRQ initialized\n");
+			rc = ibmvtpm_crq_send_init_complete(ibmvtpm);
+			if (rc)
+				dev_err(ibmvtpm->dev, "Unable to send CRQ init complete rc=%d\n", rc);
+			return;
+		case INIT_CRQ_COMP_RES:
+			dev_info(ibmvtpm->dev,
+				 "CRQ initialization completed\n");
+			return;
+		default:
+			dev_err(ibmvtpm->dev, "Unknown crq message type: %d\n", crq->msg);
+			return;
+		}
+		return;
+	case IBMVTPM_VALID_CMD:
+		switch (crq->msg) {
+		case VTPM_GET_RTCE_BUFFER_SIZE_RES:
+			if (crq->len <= 0) {
+				dev_err(ibmvtpm->dev, "Invalid rtce size\n");
+				return;
+			}
+			ibmvtpm->rtce_size = crq->len;
+			ibmvtpm->rtce_buf = kmalloc(ibmvtpm->rtce_size,
+						    GFP_KERNEL);
+			if (!ibmvtpm->rtce_buf) {
+				dev_err(ibmvtpm->dev, "Failed to allocate memory for rtce buffer\n");
+				return;
+			}
+
+			ibmvtpm->rtce_dma_handle = dma_map_single(ibmvtpm->dev,
+				ibmvtpm->rtce_buf, ibmvtpm->rtce_size,
+				DMA_BIDIRECTIONAL);
+
+			if (dma_mapping_error(ibmvtpm->dev,
+					      ibmvtpm->rtce_dma_handle)) {
+				kfree(ibmvtpm->rtce_buf);
+				ibmvtpm->rtce_buf = NULL;
+				dev_err(ibmvtpm->dev, "Failed to dma map rtce buffer\n");
+			}
+
+			return;
+		case VTPM_GET_VERSION_RES:
+			ibmvtpm->vtpm_version = crq->data;
+			return;
+		case VTPM_TPM_COMMAND_RES:
+			ibmvtpm->crq_res.valid = crq->valid;
+			ibmvtpm->crq_res.msg = crq->msg;
+			ibmvtpm->crq_res.len = crq->len;
+			ibmvtpm->crq_res.data = crq->data;
+			wake_up_interruptible(&wq);
+			return;
+		default:
+			return;
+		}
+	}
+	return;
+}
+
+/**
+ * ibmvtpm_interrupt -	Interrupt handler
+ * @irq:		irq number to handle
+ * @vtpm_instance:	vtpm that received interrupt
+ *
+ * Returns:
+ *	IRQ_HANDLED
+ **/
+static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
+{
+	struct ibmvtpm_dev *ibmvtpm = (struct ibmvtpm_dev *) vtpm_instance;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ibmvtpm->lock, flags);
+	vio_disable_interrupts(ibmvtpm->vdev);
+	tasklet_schedule(&ibmvtpm->tasklet);
+	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * ibmvtpm_tasklet - Interrupt handler tasklet
+ * @data:	ibm vtpm device struct
+ *
+ * Returns:
+ *	Nothing
+ **/
+static void ibmvtpm_tasklet(void *data)
+{
+	struct ibmvtpm_dev *ibmvtpm = data;
+	struct ibmvtpm_crq *crq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ibmvtpm->lock, flags);
+	while ((crq = ibmvtpm_crq_get_next(ibmvtpm)) != NULL) {
+		ibmvtpm_crq_process(crq, ibmvtpm);
+		crq->valid = 0;
+		wmb();
+	}
+
+	vio_enable_interrupts(ibmvtpm->vdev);
+	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
+}
+
+/**
+ * tpm_ibmvtpm_probe - ibm vtpm initialize entry point
+ * @vio_dev:	vio device struct
+ * @id:		vio device id struct
+ *
+ * Return value:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int __devinit tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
+				   const struct vio_device_id *id)
+{
+	struct ibmvtpm_dev *ibmvtpm;
+	struct device *dev = &vio_dev->dev;
+	struct ibmvtpm_crq_queue *crq_q;
+	struct tpm_chip *chip;
+	int rc = -ENOMEM, rc1;
+
+	chip = tpm_register_hardware(dev, &tpm_ibmvtpm);
+	if (!chip) {
+		dev_err(dev, "tpm_register_hardware failed\n");
+		return -ENODEV;
+	}
+
+	ibmvtpm = kzalloc(sizeof(struct ibmvtpm_dev), GFP_KERNEL);
+	if (!ibmvtpm) {
+		dev_err(dev, "kzalloc for ibmvtpm failed\n");
+		goto cleanup;
+	}
+
+	crq_q = &ibmvtpm->crq_queue;
+	crq_q->crq_addr = (struct ibmvtpm_crq *)get_zeroed_page(GFP_KERNEL);
+	if (!crq_q->crq_addr) {
+		dev_err(dev, "Unable to allocate memory for crq_addr\n");
+		goto cleanup;
+	}
+
+	crq_q->num_entry = CRQ_RES_BUF_SIZE / sizeof(*crq_q->crq_addr);
+	ibmvtpm->crq_dma_handle = dma_map_single(dev, crq_q->crq_addr,
+						 CRQ_RES_BUF_SIZE,
+						 DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(dev, ibmvtpm->crq_dma_handle)) {
+		dev_err(dev, "dma mapping failed\n");
+		goto cleanup;
+	}
+
+	rc = plpar_hcall_norets(H_REG_CRQ, vio_dev->unit_address,
+				ibmvtpm->crq_dma_handle, CRQ_RES_BUF_SIZE);
+	if (rc == H_RESOURCE)
+		rc = ibmvtpm_reset_crq(ibmvtpm);
+
+	if (rc) {
+		dev_err(dev, "Unable to register CRQ rc=%d\n", rc);
+		goto reg_crq_cleanup;
+	}
+
+	tasklet_init(&ibmvtpm->tasklet, (void *)ibmvtpm_tasklet,
+		     (unsigned long)ibmvtpm);
+
+	rc = request_irq(vio_dev->irq, ibmvtpm_interrupt, 0,
+			 tpm_ibmvtpm_driver_name, ibmvtpm);
+	if (rc) {
+		dev_err(dev, "Error %d register irq 0x%x\n", rc, vio_dev->irq);
+		goto init_irq_cleanup;
+	}
+
+	rc = vio_enable_interrupts(vio_dev);
+	if (rc) {
+		dev_err(dev, "Error %d enabling interrupts\n", rc);
+		goto init_irq_cleanup;
+	}
+
+	crq_q->index = 0;
+
+	ibmvtpm->dev = dev;
+	ibmvtpm->vdev = vio_dev;
+	chip->vendor.data = (void *)ibmvtpm;
+
+	spin_lock_init(&ibmvtpm->lock);
+	spin_lock_init(&ibmvtpm->rtce_lock);
+
+	rc = ibmvtpm_crq_send_init(ibmvtpm);
+	if (rc)
+		goto init_irq_cleanup;
+
+	rc = ibmvtpm_crq_get_version(ibmvtpm);
+	if (rc)
+		goto init_irq_cleanup;
+
+	rc = ibmvtpm_crq_get_rtce_size(ibmvtpm);
+	if (rc)
+		goto init_irq_cleanup;
+
+	return rc;
+init_irq_cleanup:
+	tasklet_kill(&ibmvtpm->tasklet);
+	do {
+		rc1 = plpar_hcall_norets(H_FREE_CRQ, vio_dev->unit_address);
+	} while (rc1 == H_BUSY || H_IS_LONG_BUSY(rc1));
+reg_crq_cleanup:
+	dma_unmap_single(dev, ibmvtpm->crq_dma_handle, CRQ_RES_BUF_SIZE,
+			 DMA_BIDIRECTIONAL);
+cleanup:
+	if (ibmvtpm) {
+		if (crq_q->crq_addr)
+			free_page((unsigned long)crq_q->crq_addr);
+		kfree(ibmvtpm);
+	}
+
+	tpm_remove_hardware(dev);
+
+	return rc;
+}
+
+static struct vio_driver ibmvtpm_driver = {
+	.id_table	 = tpm_ibmvtpm_device_table,
+	.probe		 = tpm_ibmvtpm_probe,
+	.remove		 = tpm_ibmvtpm_remove,
+	.get_desired_dma = tpm_ibmvtpm_get_desired_dma,
+	.name		 = tpm_ibmvtpm_driver_name,
+	.pm		 = &tpm_ibmvtpm_pm_ops,
+};
+
+/**
+ * ibmvtpm_module_init - Initialize ibm vtpm module
+ *
+ * Return value:
+ *	0 -Success
+ *	Non-zero - Failure
+ */
+static int __init ibmvtpm_module_init(void)
+{
+	return vio_register_driver(&ibmvtpm_driver);
+}
+
+/**
+ * ibmvtpm_module_exit - Teardown ibm vtpm module
+ *
+ * Return value:
+ *	Nothing
+ */
+static void __exit ibmvtpm_module_exit(void)
+{
+	vio_unregister_driver(&ibmvtpm_driver);
+}
+
+module_init(ibmvtpm_module_init);
+module_exit(ibmvtpm_module_exit);
+
+MODULE_AUTHOR("adlai@us.ibm.com");
+MODULE_DESCRIPTION("IBM vTPM Driver");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
new file mode 100644
index 0000000..4296eb4
--- /dev/null
+++ b/drivers/char/tpm/tpm_ibmvtpm.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2012 IBM Corporation
+ *
+ * Author: Ashley Lai <adlai@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+
+#ifndef __TPM_IBMVTPM_H__
+#define __TPM_IBMVTPM_H__
+
+/* vTPM Message Format 1 */
+struct ibmvtpm_crq {
+	u8 valid;
+	u8 msg;
+	u16 len;
+	u32 data;
+	u64 reserved;
+} __attribute__((packed, aligned(8)));
+
+struct ibmvtpm_crq_queue {
+	struct ibmvtpm_crq *crq_addr;
+	u32 index;
+	u32 num_entry;
+};
+
+struct ibmvtpm_dev {
+	struct device *dev;
+	struct vio_dev *vdev;
+	struct ibmvtpm_crq_queue crq_queue;
+	dma_addr_t crq_dma_handle;
+	spinlock_t lock;
+	struct tasklet_struct tasklet;
+	u32 rtce_size;
+	void __iomem *rtce_buf;
+	dma_addr_t rtce_dma_handle;
+	spinlock_t rtce_lock;
+	struct ibmvtpm_crq crq_res;
+	u32 vtpm_version;
+};
+
+#define CRQ_RES_BUF_SIZE	PAGE_SIZE
+
+/* Initialize CRQ */
+#define INIT_CRQ_CMD		0xC001000000000000LL /* Init cmd */
+#define INIT_CRQ_COMP_CMD	0xC002000000000000LL /* Init complete cmd */
+#define INIT_CRQ_RES		0x01	/* Init respond */
+#define INIT_CRQ_COMP_RES	0x02	/* Init complete respond */
+#define VALID_INIT_CRQ		0xC0	/* Valid command for init crq */
+
+/* vTPM CRQ response is the message type | 0x80 */
+#define VTPM_MSG_RES		0x80
+#define IBMVTPM_VALID_CMD	0x80
+
+/* vTPM CRQ message types */
+#define VTPM_GET_VERSION			0x01
+#define VTPM_GET_VERSION_RES			(0x01 | VTPM_MSG_RES)
+
+#define VTPM_TPM_COMMAND			0x02
+#define VTPM_TPM_COMMAND_RES			(0x02 | VTPM_MSG_RES)
+
+#define VTPM_GET_RTCE_BUFFER_SIZE		0x03
+#define VTPM_GET_RTCE_BUFFER_SIZE_RES		(0x03 | VTPM_MSG_RES)
+
+#define VTPM_PREPARE_TO_SUSPEND			0x04
+#define VTPM_PREPARE_TO_SUSPEND_RES		(0x04 | VTPM_MSG_RES)
+
+#endif
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
new file mode 100644
index 0000000..98ba2bd
--- /dev/null
+++ b/drivers/char/tpm/tpm_of.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2012 IBM Corporation
+ *
+ * Author: Ashley Lai <adlai@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * Read the event log created by the firmware on PPC64
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/of.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+int read_log(struct tpm_bios_log *log)
+{
+	struct device_node *np;
+	const u32 *sizep;
+	const __be64 *basep;
+
+	if (log->bios_event_log != NULL) {
+		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
+		return -EFAULT;
+	}
+
+	np = of_find_node_by_name(NULL, "ibm,vtpm");
+	if (!np) {
+		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
+		return -ENODEV;
+	}
+
+	sizep = of_get_property(np, "linux,sml-size", NULL);
+	if (sizep == NULL) {
+		pr_err("%s: ERROR - SML size not found\n", __func__);
+		goto cleanup_eio;
+	}
+	if (*sizep == 0) {
+		pr_err("%s: ERROR - event log area empty\n", __func__);
+		goto cleanup_eio;
+	}
+
+	basep = of_get_property(np, "linux,sml-base", NULL);
+	if (basep == NULL) {
+		pr_err(KERN_ERR "%s: ERROR - SML not found\n", __func__);
+		goto cleanup_eio;
+	}
+
+	of_node_put(np);
+	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
+	if (!log->bios_event_log) {
+		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
+		       __func__);
+		return -ENOMEM;
+	}
+
+	log->bios_event_log_end = log->bios_event_log + *sizep;
+
+	memcpy(log->bios_event_log, __va(be64_to_cpup(basep)), *sizep);
+
+	return 0;
+
+cleanup_eio:
+	of_node_put(np);
+	return -EIO;
+}
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
new file mode 100644
index 0000000..440fa1c
--- /dev/null
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -0,0 +1,460 @@
+#include <linux/acpi.h>
+#include <acpi/acpi_drivers.h>
+#include "tpm.h"
+
+static const u8 tpm_ppi_uuid[] = {
+	0xA6, 0xFA, 0xDD, 0x3D,
+	0x1B, 0x36,
+	0xB4, 0x4E,
+	0xA4, 0x24,
+	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
+};
+static char *tpm_device_name = "TPM";
+
+#define TPM_PPI_REVISION_ID	1
+#define TPM_PPI_FN_VERSION	1
+#define TPM_PPI_FN_SUBREQ	2
+#define TPM_PPI_FN_GETREQ	3
+#define TPM_PPI_FN_GETACT	4
+#define TPM_PPI_FN_GETRSP	5
+#define TPM_PPI_FN_SUBREQ2	7
+#define TPM_PPI_FN_GETOPR	8
+#define PPI_TPM_REQ_MAX		22
+#define PPI_VS_REQ_START	128
+#define PPI_VS_REQ_END		255
+#define PPI_VERSION_LEN		3
+
+static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
+				void **return_value)
+{
+	acpi_status status;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	if (strstr(buffer.pointer, context) != NULL) {
+		*return_value = handle;
+		kfree(buffer.pointer);
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static inline void ppi_assign_params(union acpi_object params[4],
+				     u64 function_num)
+{
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = sizeof(tpm_ppi_uuid);
+	params[0].buffer.pointer = (char *)tpm_ppi_uuid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = TPM_PPI_REVISION_ID;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = function_num;
+	params[3].type = ACPI_TYPE_PACKAGE;
+	params[3].package.count = 0;
+	params[3].package.elements = NULL;
+}
+
+ssize_t tpm_show_ppi_version(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *obj;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					 ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	obj = (union acpi_object *)output.pointer;
+	status = scnprintf(buf, PAGE_SIZE, "%s\n", obj->string.pointer);
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_show_ppi_request(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *ret_obj;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_GETREQ);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	/*
+	 * output.pointer should be of package type, including two integers.
+	 * The first is function return code, 0 means success and 1 means
+	 * error. The second is pending TPM operation requested by the OS, 0
+	 * means none and >0 means operation value.
+	 */
+	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
+	if (ret_obj->type == ACPI_TYPE_INTEGER) {
+		if (ret_obj->integer.value) {
+			status = -EFAULT;
+			goto cleanup;
+		}
+		ret_obj++;
+		if (ret_obj->type == ACPI_TYPE_INTEGER)
+			status = scnprintf(buf, PAGE_SIZE, "%llu\n",
+					   ret_obj->integer.value);
+		else
+			status = -EINVAL;
+	} else {
+		status = -EINVAL;
+	}
+cleanup:
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_store_ppi_request(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	char version[PPI_VERSION_LEN + 1];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object obj;
+	u32 req;
+	u64 ret;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	/*
+	 * the function to submit TPM operation request to pre-os environment
+	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
+	 * version 1.1
+	 */
+	if (strcmp(version, "1.1") == -1)
+		params[2].integer.value = TPM_PPI_FN_SUBREQ;
+	else
+		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
+	/*
+	 * PPI spec defines params[3].type as ACPI_TYPE_PACKAGE. Some BIOS
+	 * accept buffer/string/integer type, but some BIOS accept buffer/
+	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
+	 * for compatibility, and use package type since 1.2 according to spec.
+	 */
+	if (strcmp(version, "1.2") == -1) {
+		params[3].type = ACPI_TYPE_BUFFER;
+		params[3].buffer.length = sizeof(req);
+		sscanf(buf, "%d", &req);
+		params[3].buffer.pointer = (char *)&req;
+	} else {
+		params[3].package.count = 1;
+		obj.type = ACPI_TYPE_INTEGER;
+		sscanf(buf, "%llu", &obj.integer.value);
+		params[3].package.elements = &obj;
+	}
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_INTEGER);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	ret = ((union acpi_object *)output.pointer)->integer.value;
+	if (ret == 0)
+		status = (acpi_status)count;
+	else if (ret == 1)
+		status = -EPERM;
+	else
+		status = -EFAULT;
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_show_ppi_transition_action(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	char version[PPI_VERSION_LEN + 1];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	u32 ret;
+	char *info[] = {
+		"None",
+		"Shutdown",
+		"Reboot",
+		"OS Vendor-specific",
+		"Error",
+	};
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	/*
+	 * PPI spec defines params[3].type as empty package, but some platforms
+	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
+	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
+	 */
+	if (strcmp(version, "1.2") == -1) {
+		params[3].type = ACPI_TYPE_BUFFER;
+		params[3].buffer.length =  0;
+		params[3].buffer.pointer = NULL;
+	}
+	params[2].integer.value = TPM_PPI_FN_GETACT;
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_INTEGER);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	ret = ((union acpi_object *)output.pointer)->integer.value;
+	if (ret < ARRAY_SIZE(info) - 1)
+		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret, info[ret]);
+	else
+		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret,
+				   info[ARRAY_SIZE(info)-1]);
+	kfree(output.pointer);
+	return status;
+}
+
+ssize_t tpm_show_ppi_response(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object *ret_obj;
+	u64 req;
+
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_GETRSP);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+	/*
+	 * parameter output.pointer should be of package type, including
+	 * 3 integers. The first means function return code, the second means
+	 * most recent TPM operation request, and the last means response to
+	 * the most recent TPM operation request. Only if the first is 0, and
+	 * the second integer is not 0, the response makes sense.
+	 */
+	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
+	if (ret_obj->type != ACPI_TYPE_INTEGER) {
+		status = -EINVAL;
+		goto cleanup;
+	}
+	if (ret_obj->integer.value) {
+		status = -EFAULT;
+		goto cleanup;
+	}
+	ret_obj++;
+	if (ret_obj->type != ACPI_TYPE_INTEGER) {
+		status = -EINVAL;
+		goto cleanup;
+	}
+	if (ret_obj->integer.value) {
+		req = ret_obj->integer.value;
+		ret_obj++;
+		if (ret_obj->type != ACPI_TYPE_INTEGER) {
+			status = -EINVAL;
+			goto cleanup;
+		}
+		if (ret_obj->integer.value == 0)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0: Success");
+		else if (ret_obj->integer.value == 0xFFFFFFF0)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0xFFFFFFF0: User Abort");
+		else if (ret_obj->integer.value == 0xFFFFFFF1)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
+					   "0xFFFFFFF1: BIOS Failure");
+		else if (ret_obj->integer.value >= 1 &&
+			 ret_obj->integer.value <= 0x00000FFF)
+			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
+					   req, ret_obj->integer.value,
+					   "Corresponding TPM error");
+		else
+			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
+					   req, ret_obj->integer.value,
+					   "Error");
+	} else {
+		status = scnprintf(buf, PAGE_SIZE, "%llu: %s\n",
+				   ret_obj->integer.value, "No Recent Request");
+	}
+cleanup:
+	kfree(output.pointer);
+	return status;
+}
+
+static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
+{
+	char *str = buf;
+	char version[PPI_VERSION_LEN];
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object params[4];
+	union acpi_object obj;
+	int i;
+	u32 ret;
+	char *info[] = {
+		"Not implemented",
+		"BIOS only",
+		"Blocked for OS by BIOS",
+		"User required",
+		"User not required",
+	};
+	input.count = 4;
+	ppi_assign_params(params, TPM_PPI_FN_VERSION);
+	input.pointer = params;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX, ppi_callback, NULL,
+				     tpm_device_name, &handle);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
+					 ACPI_TYPE_STRING);
+	if (ACPI_FAILURE(status))
+		return -ENOMEM;
+
+	strncpy(version,
+		((union acpi_object *)output.pointer)->string.pointer,
+		PPI_VERSION_LEN);
+	kfree(output.pointer);
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+	if (strcmp(version, "1.2") == -1)
+		return -EPERM;
+
+	params[2].integer.value = TPM_PPI_FN_GETOPR;
+	params[3].package.count = 1;
+	obj.type = ACPI_TYPE_INTEGER;
+	params[3].package.elements = &obj;
+	for (i = start; i <= end; i++) {
+		obj.integer.value = i;
+		status = acpi_evaluate_object_typed(handle, "_DSM",
+			 &input, &output, ACPI_TYPE_INTEGER);
+		if (ACPI_FAILURE(status))
+			return -ENOMEM;
+
+		ret = ((union acpi_object *)output.pointer)->integer.value;
+		if (ret > 0 && ret < ARRAY_SIZE(info))
+			str += scnprintf(str, PAGE_SIZE, "%d %d: %s\n",
+					 i, ret, info[ret]);
+		kfree(output.pointer);
+		output.length = ACPI_ALLOCATE_BUFFER;
+		output.pointer = NULL;
+	}
+	return str - buf;
+}
+
+ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return show_ppi_operations(buf, 0, PPI_TPM_REQ_MAX);
+}
+
+ssize_t tpm_show_ppi_vs_operations(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return show_ppi_operations(buf, PPI_VS_REQ_START, PPI_VS_REQ_END);
+}
+
+static DEVICE_ATTR(version, S_IRUGO, tpm_show_ppi_version, NULL);
+static DEVICE_ATTR(request, S_IRUGO | S_IWUSR | S_IWGRP,
+		   tpm_show_ppi_request, tpm_store_ppi_request);
+static DEVICE_ATTR(transition_action, S_IRUGO,
+		   tpm_show_ppi_transition_action, NULL);
+static DEVICE_ATTR(response, S_IRUGO, tpm_show_ppi_response, NULL);
+static DEVICE_ATTR(tcg_operations, S_IRUGO, tpm_show_ppi_tcg_operations, NULL);
+static DEVICE_ATTR(vs_operations, S_IRUGO, tpm_show_ppi_vs_operations, NULL);
+
+static struct attribute *ppi_attrs[] = {
+	&dev_attr_version.attr,
+	&dev_attr_request.attr,
+	&dev_attr_transition_action.attr,
+	&dev_attr_response.attr,
+	&dev_attr_tcg_operations.attr,
+	&dev_attr_vs_operations.attr, NULL,
+};
+static struct attribute_group ppi_attr_grp = {
+	.attrs = ppi_attrs
+};
+
+ssize_t sys_add_ppi(struct kobject *parent)
+{
+	struct kobject *ppi;
+	ppi = kobject_create_and_add("ppi", parent);
+	if (sysfs_create_group(ppi, &ppi_attr_grp))
+		return -EFAULT;
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(sys_add_ppi);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c4be351..6bdf267 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -705,6 +705,7 @@ out_err:
 	return rc;
 }
 
+#if defined(CONFIG_PNP) || defined(CONFIG_PM_SLEEP)
 static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 {
 	u32 intmask;
@@ -725,7 +726,7 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 	iowrite32(intmask,
 		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
 }
-
+#endif
 
 #ifdef CONFIG_PNP
 static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index fdc718a..fcb627f 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -32,6 +32,7 @@
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
+extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
 #else
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
@@ -42,5 +43,8 @@ static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
 	return -ENODEV;
 }
+static inline int tpm_get_random(u32 chip_num, u8 *data, size_t max) {
+	return -ENODEV;
+}
 #endif
 #endif
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b9c1219..809ccf1 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -11,6 +11,7 @@ config IMA
 	select CRYPTO_SHA1
 	select TCG_TPM if HAS_IOMEM && !UML
 	select TCG_TIS if TCG_TPM && X86
+	select TCG_IBMVTPM if TCG_TPM && PPC64
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 2d5d041..3f163d0 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -369,38 +369,6 @@ static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
 }
 
 /*
- * get a random value from TPM
- */
-static int tpm_get_random(struct tpm_buf *tb, unsigned char *buf, uint32_t len)
-{
-	int ret;
-
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_COMMAND);
-	store32(tb, TPM_GETRANDOM_SIZE);
-	store32(tb, TPM_ORD_GETRANDOM);
-	store32(tb, len);
-	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, sizeof tb->data);
-	if (!ret)
-		memcpy(buf, tb->data + TPM_GETRANDOM_SIZE, len);
-	return ret;
-}
-
-static int my_get_random(unsigned char *buf, int len)
-{
-	struct tpm_buf *tb;
-	int ret;
-
-	tb = kmalloc(sizeof *tb, GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
-	ret = tpm_get_random(tb, buf, len);
-
-	kfree(tb);
-	return ret;
-}
-
-/*
  * Lock a trusted key, by extending a selected PCR.
  *
  * Prevents a trusted key that is sealed to PCRs from being accessed.
@@ -413,8 +381,8 @@ static int pcrlock(const int pcrnum)
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	ret = my_get_random(hash, SHA1_DIGEST_SIZE);
-	if (ret < 0)
+	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
+	if (ret != SHA1_DIGEST_SIZE)
 		return ret;
 	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;
 }
@@ -429,8 +397,8 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	unsigned char ononce[TPM_NONCE_SIZE];
 	int ret;
 
-	ret = tpm_get_random(tb, ononce, TPM_NONCE_SIZE);
-	if (ret < 0)
+	ret = tpm_get_random(TPM_ANY_NUM, ononce, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE)
 		return ret;
 
 	INIT_BUF(tb);
@@ -524,8 +492,8 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 	if (ret < 0)
 		goto out;
 
-	ret = tpm_get_random(tb, td->nonceodd, TPM_NONCE_SIZE);
-	if (ret < 0)
+	ret = tpm_get_random(TPM_ANY_NUM, td->nonceodd, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE)
 		goto out;
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(datalen);
@@ -634,8 +602,8 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	keyhndl = htonl(SRKHANDLE);
-	ret = tpm_get_random(tb, nonceodd, TPM_NONCE_SIZE);
-	if (ret < 0) {
+	ret = tpm_get_random(TPM_ANY_NUM, nonceodd, TPM_NONCE_SIZE);
+	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
 		return ret;
 	}
@@ -935,6 +903,7 @@ static int trusted_instantiate(struct key *key, const void *data,
 	char *datablob;
 	int ret = 0;
 	int key_cmd;
+	size_t key_len;
 
 	if (datalen <= 0 || datalen > 32767 || !data)
 		return -EINVAL;
@@ -974,8 +943,9 @@ static int trusted_instantiate(struct key *key, const void *data,
 			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
 		break;
 	case Opt_new:
-		ret = my_get_random(payload->key, payload->key_len);
-		if (ret < 0) {
+		key_len = payload->key_len;
+		ret = tpm_get_random(TPM_ANY_NUM, payload->key, key_len);
+		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
 			goto out;
 		}

