Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2JNPQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:16:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825Ab2JNOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:38 -0400
Message-Id: <20121014143533.967665518@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dan.j.williams@intel.com>,
        Don Morris <don.morris@hp.com>
Subject: [ 001/147] isci: fix isci_pci_probe() generates warning on efi failure path
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 6d70a74ffd616073a68ae0974d98819bfa8e6da6 upstream.

The oem parameter image embedded in the efi variable is at an offset
from the start of the variable.  However, in the failure path we try to
free the 'orom' pointer which is only valid when the paramaters are
being read from the legacy option-rom space.

Since failure to load the oem parameters is unlikely and we keep the
memory around in the success case just defer all de-allocation to devm.

Reported-by: Don Morris <don.morris@hp.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/isci/init.c       |    1 -
 drivers/scsi/isci/probe_roms.c |    1 -
 2 files changed, 2 deletions(-)

--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -469,7 +469,6 @@ static int __devinit isci_pci_probe(stru
 		if (sci_oem_parameters_validate(&orom->ctrl[i])) {
 			dev_warn(&pdev->dev,
 				 "[%d]: invalid oem parameters detected, falling back to firmware\n", i);
-			devm_kfree(&pdev->dev, orom);
 			orom = NULL;
 			break;
 		}
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -104,7 +104,6 @@ struct isci_orom *isci_request_oprom(str
 
 	if (i >= len) {
 		dev_err(&pdev->dev, "oprom parse error\n");
-		devm_kfree(&pdev->dev, rom);
 		rom = NULL;
 	}
 	pci_unmap_biosrom(oprom);


