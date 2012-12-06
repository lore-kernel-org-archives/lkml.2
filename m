Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2LFWrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:47:20 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:42812 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2LFWrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:47:17 -0500
Date: Thu, 6 Dec 2012 15:47:09 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH] TPM: Wait for TPM_ACCESS tpmRegValidSts to go high at startup
Message-ID: <20121206224709.GC25069@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TIS specification (pg 47) says the valid bit must be set, but
the TPM will not set it until it has completed its internal startup.

The driver checks that the valid bit is set during request_locality,
but it issues a TPM_ACCESS_REQUEST_USE without validating the
valid bit is set.

Some TPMs will ignore the TPM_ACCESS_REQUEST_USE, until valid is
set which causes the request_locality to timeout, which breaks the
driver attach.

Wait one timeout unit for valid to assert. If valid does not assert
then assume -ENODEV.

Seen on embedded with a:
1.2 TPM (device-id 0x3204, rev-id 64)

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_tis.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

Note: This does not change the requirement of the driver,
request_locality already will bail if valid is not set. All this does
is wait for valid to be set before attempting to write any TPM
registers.

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 23c6562..2bc3aab 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -99,6 +99,22 @@ static inline int is_itpm(struct pnp_dev *dev)
 }
 #endif
 
+/* Before we attempt to access the TPM we must see that the valid bit is set.
+ * The specification says that this bit is 0 at reset and remains 0 until the
+ * 'TPM has gone through its self test and initialization and has established
+ * correct values in the other bits.' */
+static int wait_startup(struct tpm_chip *chip, int l)
+{
+	unsigned long stop = jiffies + chip->vendor.timeout_a;
+	do {
+		if (ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
+		    TPM_ACCESS_VALID)
+			return 0;
+		msleep(TPM_TIMEOUT);
+	} while (time_before(jiffies, stop));
+	return -1;
+}
+
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
@@ -529,6 +545,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 
+	if (wait_startup(chip, 0) != 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	if (request_locality(chip, 0) != 0) {
 		rc = -ENODEV;
 		goto out_err;
-- 
1.7.5.4

