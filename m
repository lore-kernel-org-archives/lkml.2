Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946241Ab2JDVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:25:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946213Ab2JDVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:25:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Don Morris <don.morris@hp.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [ 49/52] isci: fix isci_pci_probe() generates warning on efi failure path
Date: Thu,  4 Oct 2012 14:21:40 -0700
Message-Id: <20121004210641.546443990@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/isci/init.c       |    1 -
 drivers/scsi/isci/probe_roms.c |    1 -
 2 files changed, 2 deletions(-)

--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -481,7 +481,6 @@ static int __devinit isci_pci_probe(stru
 						orom->hdr.version)) {
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


