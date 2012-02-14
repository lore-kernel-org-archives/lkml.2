Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab2BNTCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:02:14 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:46453 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2BNTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:02:10 -0500
Date: Tue, 14 Feb 2012 17:01:09 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PULL] TPM: Smarter iTPM probing
Message-ID: <20120214190109.GJ9160@hardened-box.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021419-2194-0000-0000-000000F9E60A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull into your next branch the following changes since 
commit 4040153087478993cbf0809f444400a3c808074c:

  security: trim security.h (2012-02-14 10:45:42 +1100)

that are available in the git repository at:
  git://github.com/srajiv/tpm.git for-james

Stefan Berger (2):
      tpm_tis: Only probe iTPMs
      tpm_tis: Clean up after module_param cleanup

Tim Gardner (1):
      TPM: Zero buffer whole after copying to userspace

 drivers/char/tpm/tpm.c     |    3 ++-
 drivers/char/tpm/tpm.h     |    2 ++
 drivers/char/tpm/tpm_tis.c |   17 ++++++++++-------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 32362cf..ad7c732 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1221,12 +1221,13 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 	ret_size = atomic_read(&chip->data_pending);
 	atomic_set(&chip->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
+		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
 			ret_size = size;
 
 		mutex_lock(&chip->buffer_mutex);
 		rc = copy_to_user(buf, chip->data_buffer, ret_size);
-		memset(chip->data_buffer, 0, ret_size);
+		memset(chip->data_buffer, 0, orig_ret_size);
 		if (rc)
 			ret_size = -EFAULT;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0105471..b1c5280 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -99,6 +99,8 @@ struct tpm_vendor_specific {
 	wait_queue_head_t int_queue;
 };
 
+#define TPM_VID_INTEL    0x8086
+
 struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a174862..1250e33 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -367,7 +367,12 @@ static int probe_itpm(struct tpm_chip *chip)
 		0x00, 0x00, 0x00, 0xf1
 	};
 	size_t len = sizeof(cmd_getticks);
-	int rem_itpm = itpm;
+	bool rem_itpm = itpm;
+	u16 vendor = ioread16(chip->vendor.iobase + TPM_DID_VID(0));
+
+	/* probe only iTPMS */
+	if (vendor != TPM_VID_INTEL)
+		return 0;
 
 	itpm = 0;
 
@@ -390,9 +395,6 @@ static int probe_itpm(struct tpm_chip *chip)
 out:
 	itpm = rem_itpm;
 	tpm_tis_ready(chip);
-	/* some TPMs need a break here otherwise they will not work
-	 * correctly on the immediately subsequent command */
-	msleep(chip->vendor.timeout_b);
 	release_locality(chip, chip->vendor.locality, 0);
 
 	return rc;
@@ -508,7 +510,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 			resource_size_t len, unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
-	int rc, i, irq_s, irq_e;
+	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
@@ -538,11 +540,12 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	if (!itpm) {
-		itpm = probe_itpm(chip);
-		if (itpm < 0) {
+		probe = probe_itpm(chip);
+		if (probe < 0) {
 			rc = -ENODEV;
 			goto out_err;
 		}
+		itpm = (probe == 0) ? 0 : 1;
 	}
 
 	if (itpm)

