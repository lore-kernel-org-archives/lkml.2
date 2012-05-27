Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2E0BCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:02:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2E0BBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:01:13 -0400
Message-Id: <20120527002621.841426410@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:27:05 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 52/55] isci: fix oem parameter validation on single controller skus
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

Reported-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/isci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -454,7 +454,7 @@ static int __devinit isci_pci_probe(stru
 	if (!orom)
 		orom = isci_request_oprom(pdev);
 
-	for (i = 0; orom && i < ARRAY_SIZE(orom->ctrl); i++) {
+	for (i = 0; orom && i < num_controllers(pdev); i++) {
 		if (sci_oem_parameters_validate(&orom->ctrl[i])) {
 			dev_warn(&pdev->dev,
 				 "[%d]: invalid oem parameters detected, falling back to firmware\n", i);


