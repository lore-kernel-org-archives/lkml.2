Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2FLWB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:01:26 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:43172 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2FLWBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:01:25 -0400
Date: Tue, 12 Jun 2012 19:01:00 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: james.l.morris@oracle.com
Cc: linux-kernel@vger.kernel.org, tpmdd@selhorst.net, key@linux.vnet.ibm.com,
        mail@srajiv.net, gaowanlong@cn.fujitsu.com, andi.shyti@gmail.com
Subject: [PULL] TPM: maintainers' update and small fixes
Message-ID: <20120612220100.GA8230@localhost.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061222-2194-0000-0000-00000221C590
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 66dd07b88a1c9d446f32253da606b87324fa620e:

  Merge commit 'v3.5-rc2' into next (2012-06-10 22:52:10 +1000)

are available in the git repository at:

  git://github.com/srajiv/tpm.git for-james

Andi Shyti (1):
      tpm: check the chip reference before using it

Rajiv Andrade (2):
      MAINTAINERS: TPM maintainers' contacts update
      TPM: chip disabled state erronously being reported as error

Wanlong Gao (1):
      TPM: fix memleak when register hardware fails

 MAINTAINERS                     |    7 ++++---
 drivers/char/tpm/tpm.c          |   27 ++++++++++++++++++++-------
 drivers/char/tpm/tpm_infineon.c |    6 +++---
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14bc707..58f5a7f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6835,10 +6835,11 @@ F:	include/linux/shmem_fs.h
 F:	mm/shmem.c
 
 TPM DEVICE DRIVER
-M:	Debora Velarde <debora@linux.vnet.ibm.com>
-M:	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
+M:	Kent Yoder <key@linux.vnet.ibm.com>
+M:	Rajiv Andrade <mail@srajiv.net>
 W:	http://tpmdd.sourceforge.net
-M:	Marcel Selhorst <m.selhorst@sirrix.com>
+M:	Marcel Selhorst <tpmdd@selhorst.net>
+M:	Sirrix AG <tpmdd@sirrix.com>
 W:	http://www.sirrix.com
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..d39b1f6 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -827,10 +827,10 @@ EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 int tpm_do_selftest(struct tpm_chip *chip)
 {
 	int rc;
-	u8 digest[TPM_DIGEST_SIZE];
 	unsigned int loops;
 	unsigned int delay_msec = 1000;
 	unsigned long duration;
+	struct tpm_cmd_t cmd;
 
 	duration = tpm_calc_ordinal_duration(chip,
 	                                     TPM_ORD_CONTINUE_SELFTEST);
@@ -845,7 +845,15 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		return rc;
 
 	do {
-		rc = __tpm_pcr_read(chip, 0, digest);
+		/* Attempt to read a PCR value */
+		cmd.header.in = pcrread_header;
+		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
+		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+
+		if (rc < TPM_HEADER_SIZE)
+			return -EFAULT;
+
+		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
@@ -1322,6 +1330,9 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 void tpm_dev_vendor_release(struct tpm_chip *chip)
 {
+	if (!chip)
+		return;
+
 	if (chip->vendor.release)
 		chip->vendor.release(chip->dev);
 
@@ -1339,6 +1350,9 @@ void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
+	if (!chip)
+		return;
+
 	tpm_dev_vendor_release(chip);
 
 	chip->release(dev);
@@ -1405,15 +1419,12 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 			"unable to misc_register %s, minor %d\n",
 			chip->vendor.miscdev.name,
 			chip->vendor.miscdev.minor);
-		put_device(chip->dev);
-		return NULL;
+		goto put_device;
 	}
 
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
 		misc_deregister(&chip->vendor.miscdev);
-		put_device(chip->dev);
-
-		return NULL;
+		goto put_device;
 	}
 
 	chip->bios_dir = tpm_bios_log_setup(devname);
@@ -1425,6 +1436,8 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 
 	return chip;
 
+put_device:
+	put_device(chip->dev);
 out_free:
 	kfree(chip);
 	kfree(devname);
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index 76da32e..3251a44 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -4,8 +4,8 @@
  * SLD 9630 TT 1.1 and SLB 9635 TT 1.2 Trusted Platform Module
  * Specifications at www.trustedcomputinggroup.org
  *
- * Copyright (C) 2005, Marcel Selhorst <m.selhorst@sirrix.com>
- * Sirrix AG - security technologies, http://www.sirrix.com and
+ * Copyright (C) 2005, Marcel Selhorst <tpmdd@selhorst.net>
+ * Sirrix AG - security technologies <tpmdd@sirrix.com> and
  * Applied Data Security Group, Ruhr-University Bochum, Germany
  * Project-Homepage: http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
  *
@@ -671,7 +671,7 @@ static void __exit cleanup_inf(void)
 module_init(init_inf);
 module_exit(cleanup_inf);
 
-MODULE_AUTHOR("Marcel Selhorst <m.selhorst@sirrix.com>");
+MODULE_AUTHOR("Marcel Selhorst <tpmdd@sirrix.com>");
 MODULE_DESCRIPTION("Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2");
 MODULE_VERSION("1.9.2");
 MODULE_LICENSE("GPL");

