Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2E1Dx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:53:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51895 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465Ab2E1D3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:09 -0400
Message-Id: <20120528031207.161109910@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [ 031/117] isci: fix oem parameter validation on single controller skus
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit fc25f79af321c01a739150ba2c09435cf977a63d upstream.

OEM parameters [1] are parsed from the platform option-rom / efi
driver.  By default the driver was validating the parameters for the
dual-controller case, but in single-controller case only the first set
of parameters may be valid.

Limit the validation to the number of actual controllers detected
otherwise the driver may fail to parse the valid parameters leading to
driver-load or runtime failures.

[1] the platform specific set of phy address, configuration,and analog
    tuning values

[stable v3.0+]
Reported-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/isci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/drivers/scsi/isci/init.c
+++ linux/drivers/scsi/isci/init.c
@@ -465,7 +465,7 @@
 	if (!orom)
 		orom = isci_request_oprom(pdev);
 
-	for (i = 0; orom && i < ARRAY_SIZE(orom->ctrl); i++) {
+	for (i = 0; orom && i < num_controllers(pdev); i++) {
 		if (sci_oem_parameters_validate(&orom->ctrl[i])) {
 			dev_warn(&pdev->dev,
 				 "[%d]: invalid oem parameters detected, falling back to firmware\n", i);


