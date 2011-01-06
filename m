Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1AFAbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:20 -0500
Received: from kroah.org ([198.145.64.141]:36001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1AFAbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:16 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.897088222@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Chris Ball <cjb@laptop.org>
Subject: [118/152] mmc: atmel-mci: fix multiblock SDIO transfers
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/mmc/host/atmel-mci.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
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


