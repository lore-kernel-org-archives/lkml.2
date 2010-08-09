Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0HITwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:52:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44082 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0HITwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ncUc9JL23PKdDr6k0szYDQmE2oFGMr3DwI+Jnfz/Lngmsfz3Er7Y6UI8yl0QTjp5Re
         wY+lO5Q0RxNudeaF3KJWjknYQ4XQg7YBBrBT/485ILK+QY+iVh88vEI/Jc96i5GwqFF7
         Tp4kV1gzce9jai+4SV5J1ceVUpyY8lvQKmXTo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        David Woodhouse <David.Woodhouse@intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/18 v2] staging: spectra: call disable_pci_device() if pci_probe() failed
Date: Mon,  9 Aug 2010 23:52:06 +0400
Message-Id: <1281383528-14558-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/spectra/lld_nand.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/spectra/lld_nand.c b/drivers/staging/spectra/lld_nand.c
index 13c3ad2..0d647a8 100644
--- a/drivers/staging/spectra/lld_nand.c
+++ b/drivers/staging/spectra/lld_nand.c
@@ -2411,13 +2411,15 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	csr_base = pci_resource_start(dev, 0);
 	if (!csr_base) {
 		printk(KERN_ERR "Spectra: pci_resource_start failed!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto failed_req_csr;
 	}
 
 	csr_len = pci_resource_len(dev, 0);
 	if (!csr_len) {
 		printk(KERN_ERR "Spectra: pci_resource_len failed!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto failed_req_csr;
 	}
 
 	ret = pci_request_regions(dev, SPECTRA_NAND_NAME);
@@ -2464,6 +2466,7 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 failed_remap_csr:
 	pci_release_regions(dev);
 failed_req_csr:
+	pci_disable_device(dev);
 
 	return ret;
 }
-- 
1.7.0.4

