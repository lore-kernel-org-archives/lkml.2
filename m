Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1JJQRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:17:19 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:56282 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1JJQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:17:18 -0400
Message-ID: <4E931A7E.60800@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 13:17:02 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Stefan Berger <stefanb@linux.vnet.ibm.com>, a.miskiewicz@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] TPM suspend regression fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11101016-9254-0000-0000-000006D112B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull the change since commit e00fb3f7af111d1b3252f7d622213d2e22be65f5 in
your next branch:

   TOMOYO: Fix domain transition failure warning. (2011-09-28 11:53:15 +1000)

that is available in the git repository at:
   git://github.com/srajiv/tpm.git for-james

Stefan Berger (1):
       TPM: Refuse activation of tpm_tis driver if TPM is not working correctly

  drivers/char/tpm/tpm_tis.c |   13 +++++++++++++
  1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 3f4051a..2369e78 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -549,6 +549,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
  	u32 vendor, intfcaps, intmask;
  	int rc, i, irq_s, irq_e;
  	struct tpm_chip *chip;
+	u8 digest[TPM_DIGEST_SIZE];

  	if (!(chip = tpm_register_hardware(dev,&tpm_tis)))
  		return -ENODEV;
@@ -616,6 +617,18 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
  	/* get the timeouts before testing for irqs */
  	tpm_get_timeouts(chip);

+	/* test for correctly working TPM; refuse driver if not working
+	   to prevent suspend/resume problems */
+	rc = tpm_pcr_read(chip->dev_num, 0, digest);
+	if (rc != 0) {
+		dev_err(dev, "Could not read PCR 0. "
+			"TPM is not working correctly.\n");
+		dev_err(dev, "Was machine previously suspended without TPM "
+			"driver present?\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
  	/* INTERRUPT Setup */
  	init_waitqueue_head(&chip->vendor.read_queue);
  	init_waitqueue_head(&chip->vendor.int_queue);


