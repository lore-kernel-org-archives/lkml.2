Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2ATSAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:00:01 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36854 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2ATSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:00:00 -0500
Message-Id: <20120120175931.685896848@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 Jan 2012 12:58:50 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: stefanb@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, Stefan Berger <stefan@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] tpm_tis: Clean up after module_param cleanup
References: <20120120175848.310554335@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_tis_itpm_bool_fix.diff
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012017-3352-0000-0000-00000210EE1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 90ab5ee94171b3e28de6bb42ee30b527014e0be7 changed the
itpm module parameter from int to bool. Some other changes
need to be done to clean up after this change.

Signed-off-by: Stefan Berger <stefan@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
 drivers/char/tpm/tpm_tis.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -367,7 +367,7 @@ static int probe_itpm(struct tpm_chip *c
 		0x00, 0x00, 0x00, 0xf1
 	};
 	size_t len = sizeof(cmd_getticks);
-	int rem_itpm = itpm;
+	bool rem_itpm = itpm;
 	u16 vendor = ioread16(chip->vendor.iobase + TPM_DID_VID(0));
 
 	/* probe only iTPMS */
@@ -510,7 +510,7 @@ static int tpm_tis_init(struct device *d
 			resource_size_t len, unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
-	int rc, i, irq_s, irq_e;
+	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
@@ -540,11 +540,12 @@ static int tpm_tis_init(struct device *d
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

