Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab2ECSRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:17:53 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:59882 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2ECSRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:17:52 -0400
Date: Thu, 3 May 2012 14:10:54 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: jmorris@namei.org
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org, tpmdd@selhorst.net
Subject: [PULL] TPM: MAINTAINERS contacts update and error report fix
Message-ID: <20120503171054.GA6165@localhost.br.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050318-8936-0000-0000-000006A675E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

The following changes since commit 08162e6a23d476544adfe1164afe9ea8b34ab859:

  Yama: remove an unused variable (2012-04-23 17:20:22 +1000)

are available in the git repository at:
  git://github.com/srajiv/tpm.git for-james

The first as the subject implies is just a contacts update, and the second
makes the driver avoid to mistakenly report the disabled and deactivated TPM
states as an error.

Marcel Selhorst (1):
      MAINTAINERS: TPM maintainers' contacts update

Rajiv Andrade (1):
      TPM: chip disabled state erronously being reported as error

 MAINTAINERS                     |    4 ++--
 drivers/char/tpm/tpm.c          |   13 +++++++++++--
 drivers/char/tpm/tpm_infineon.c |    6 +++---
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f31aa0c..731440f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6746,10 +6746,10 @@ F:	include/linux/shmem_fs.h
 F:	mm/shmem.c
 
 TPM DEVICE DRIVER
-M:	Debora Velarde <debora@linux.vnet.ibm.com>
 M:	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
 W:	http://tpmdd.sourceforge.net
-M:	Marcel Selhorst <m.selhorst@sirrix.com>
+M:	Marcel Selhorst <tpmdd@selhorst.net>
+M:	Sirrix AG <tpmdd@sirrix.com>
 W:	http://www.sirrix.com
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..9511abd 100644
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
@@ -845,7 +845,16 @@ int tpm_do_selftest(struct tpm_chip *chip)
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
+		else
+			rc = be32_to_cpu(cmd.header.out.return_code);
+
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
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






