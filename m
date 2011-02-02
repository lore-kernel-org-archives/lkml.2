Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1BBAwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:52:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:55991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1BBAo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622611"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: yauhen.kharuzhy@promwad.com, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, cjb@laptop.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [110/139] mmc: at91_mci: fix multiblock SDIO transfers
Message-Id: <20110202004508.DF4323E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>

commit a2255ff45143001fecbc5e5a4b58fcb999d393ae upstream.

The AT91 MCI has special SDIO transfer types: SDIO block and SDIO byte
transfers, but at91_mci driver doesn't use them and handles all SDIO
transfers as ordinary MMC block transfers. This causes problems for
multiple-block SDIO transfers (in particular for 256-bytes blocks).

Fix this situation by checking the opcode for SDIO CMD53 and setting
the transfer type in the AT91_MCI_CMDR register properly.

This patch was tested with libertas SDIO driver: problem with TX
timeouts on big packets was eliminated.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/arm/mach-at91/include/mach/at91_mci.h |    2 ++
 drivers/mmc/host/at91_mci.c                |   13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/arch/arm/mach-at91/include/mach/at91_mci.h
===================================================================
--- linux-2.6.35.y.orig/arch/arm/mach-at91/include/mach/at91_mci.h
+++ linux-2.6.35.y/arch/arm/mach-at91/include/mach/at91_mci.h
@@ -74,6 +74,8 @@
 #define			AT91_MCI_TRTYP_BLOCK	(0 << 19)
 #define			AT91_MCI_TRTYP_MULTIPLE	(1 << 19)
 #define			AT91_MCI_TRTYP_STREAM	(2 << 19)
+#define			AT91_MCI_TRTYP_SDIO_BYTE	(4 << 19)
+#define			AT91_MCI_TRTYP_SDIO_BLOCK	(5 << 19)
 
 #define AT91_MCI_BLKR		0x18		/* Block Register */
 #define		AT91_MCI_BLKR_BCNT(n)	((0xffff & (n)) << 0)	/* Block count */
Index: linux-2.6.35.y/drivers/mmc/host/at91_mci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/host/at91_mci.c
+++ linux-2.6.35.y/drivers/mmc/host/at91_mci.c
@@ -68,6 +68,7 @@
 #include <linux/gfp.h>
 
 #include <linux/mmc/host.h>
+#include <linux/mmc/sdio.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -492,10 +493,14 @@ static void at91_mci_send_command(struct
 		else if (data->flags & MMC_DATA_WRITE)
 			cmdr |= AT91_MCI_TRCMD_START;
 
-		if (data->flags & MMC_DATA_STREAM)
-			cmdr |= AT91_MCI_TRTYP_STREAM;
-		if (data->blocks > 1)
-			cmdr |= AT91_MCI_TRTYP_MULTIPLE;
+		if (cmd->opcode == SD_IO_RW_EXTENDED) {
+			cmdr |= AT91_MCI_TRTYP_SDIO_BLOCK;
+		} else {
+			if (data->flags & MMC_DATA_STREAM)
+				cmdr |= AT91_MCI_TRTYP_STREAM;
+			if (data->blocks > 1)
+				cmdr |= AT91_MCI_TRTYP_MULTIPLE;
+		}
 	}
 	else {
 		block_length = 0;
