Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1IVQJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:09:53 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:37572 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1IVQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:09:52 -0400
Message-ID: <4E7B5DC4.50703@linux.vnet.ibm.com>
Date: Thu, 22 Sep 2011 13:09:40 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: James Morris <jmorris@namei.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>,
        jwboyer@redhat.com, axel.lin@gmail.com, geert@linux-m68k.org
Subject: [GIT PULL]  TPM fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11092216-9254-0000-0000-0000069DA6CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull the changes since commit 73beac95e91327b3dd903a62e3e569192267afe3:

  TPM: TCG_ATMEL should depend on HAS_IOPORT (2011-09-22 12:35:45 -0300)

that are available in the git repository at:
  git://github.com/srajiv/tpm.git for-james

Axel Lin (1):
      TPM: tpm_nsc: Fix a double free of pdev in cleanup_nsc

Geert Uytterhoeven (1):
      TPM: TCG_ATMEL should depend on HAS_IOPORT

Peter Huewe (2):
      TPM: Call tpm_transmit with correct size
      TPM: Zero buffer after copying to userspace

 drivers/char/tpm/Kconfig   |    1 +
 drivers/char/tpm/tpm.c     |    9 ++++++++-
 drivers/char/tpm/tpm_nsc.c |    2 --
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f6595ab..fa567f1 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -43,6 +43,7 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
+	depends on PPC64 || HAS_IOPORT
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index e53af76..361a1df 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -383,6 +383,9 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
@@ -1105,6 +1108,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 {
 	struct tpm_chip *chip = file->private_data;
 	ssize_t ret_size;
+	int rc;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
@@ -1115,8 +1119,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 			ret_size = size;
 
 		mutex_lock(&chip->buffer_mutex);
-		if (copy_to_user(buf, chip->data_buffer, ret_size))
+		rc = copy_to_user(buf, chip->data_buffer, ret_size);
+		memset(chip->data_buffer, 0, ret_size);
+		if (rc)
 			ret_size = -EFAULT;
+
 		mutex_unlock(&chip->buffer_mutex);
 	}
 
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 82facc9..4d24648 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -396,8 +396,6 @@ static void __exit cleanup_nsc(void)
 	if (pdev) {
 		tpm_nsc_remove(&pdev->dev);
 		platform_device_unregister(pdev);
-		kfree(pdev);
-		pdev = NULL;
 	}
 
 	platform_driver_unregister(&nsc_drv);


