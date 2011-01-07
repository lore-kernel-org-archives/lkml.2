Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1AGDYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:24:54 -0500
Received: from mail.lixom.net ([70.86.134.90]:46910 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1AGDYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:24:53 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, James Morris <jmorris@namei.org>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] tpm: fix panic caused by "tpm: Autodetect itpm devices"
Date: Thu,  6 Jan 2011 21:24:01 -0600
Message-Id: <1294370641-6791-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.3.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 adds a check for
PNP device id to the common tpm_tis_init() function, which in some
cases (force=1) will be called without the device being a member of
a pnp_dev. Oopsing and panics ensue.

Move the test up to before the call to tpm_tis_init(), since it
just modifies a global variable anyway.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: stable@kernel.org [2.6.37+]
---
 drivers/char/tpm/tpm_tis.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c17a305..dd21df5 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -493,9 +493,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
-	if (is_itpm(to_pnp_dev(dev)))
-		itpm = 1;
-
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 
@@ -637,6 +634,9 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	else
 		interrupts = 0;
 
+	if (is_itpm(pnp_dev))
+		itpm = 1;
+
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 
-- 
1.7.3.GIT

