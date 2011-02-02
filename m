Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1BBAua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:50:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:58722 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1BBApG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505251"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, cjb@laptop.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [111/139] mmc: atmel-mci: fix multiblock SDIO transfers
Message-Id: <20110202004509.E9D753E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 2f1d791882d21a4002a719fb016a1ac21c8bd6b7 upstream.

Based on report made by Yauhen in:
"MMC: Fix multiblock SDIO transfers in AT91 MCI" patch,
I report those changes to the brother driver: atmel-mci.

So, this patch sets SDIO transfer types: SDIO block and SDIO byte
transfers instead of using ordinary MMC block transfers.
It is checking opcode for SDIO CMD53 and setting transfer
type in MCI_CMDR register properly.

Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mmc/host/atmel-mci.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/drivers/mmc/host/atmel-mci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/host/atmel-mci.c
+++ linux-2.6.35.y/drivers/mmc/host/atmel-mci.c
@@ -26,6 +26,7 @@
 #include <linux/stat.h>
 
 #include <linux/mmc/host.h>
+#include <linux/mmc/sdio.h>
 
 #include <mach/atmel-mci.h>
 #include <linux/atmel-mci.h>
@@ -532,12 +533,17 @@ static u32 atmci_prepare_command(struct 
 	data = cmd->data;
 	if (data) {
 		cmdr |= MCI_CMDR_START_XFER;
-		if (data->flags & MMC_DATA_STREAM)
-			cmdr |= MCI_CMDR_STREAM;
-		else if (data->blocks > 1)
-			cmdr |= MCI_CMDR_MULTI_BLOCK;
-		else
-			cmdr |= MCI_CMDR_BLOCK;
+
+		if (cmd->opcode == SD_IO_RW_EXTENDED) {
+			cmdr |= MCI_CMDR_SDIO_BLOCK;
+		} else {
+			if (data->flags & MMC_DATA_STREAM)
+				cmdr |= MCI_CMDR_STREAM;
+			else if (data->blocks > 1)
+				cmdr |= MCI_CMDR_MULTI_BLOCK;
+			else
+				cmdr |= MCI_CMDR_BLOCK;
+		}
 
 		if (data->flags & MMC_DATA_READ)
 			cmdr |= MCI_CMDR_TRDIR_READ;
