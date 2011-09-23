Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1IWAU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:20:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:46686 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab1IWAUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:20:25 -0400
Date: Fri, 23 Sep 2011 10:20:16 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [GIT] TPM bug fixes
Message-ID: <alpine.LRH.2.00.1109231018460.14290@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these TPM fixes.

(sfr has been pulling from this tree since last week).

The following changes since commit d93dc5c4478c1fd5de85a3e8aece9aad7bbae044:
  Linus Torvalds (1):
        Linux 3.1-rc7

are available in the git repository at:

  git://git.selinuxproject.org/~jmorris/linux-security for-linus

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
index caf8012..9ca5c02 100644
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
@@ -1102,6 +1105,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 {
 	struct tpm_chip *chip = file->private_data;
 	ssize_t ret_size;
+	int rc;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
@@ -1112,8 +1116,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
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

