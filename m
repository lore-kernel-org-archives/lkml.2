Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1AFAbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:17 -0500
Received: from kroah.org ([198.145.64.141]:35993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab1AFAbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:14 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.815478991@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Chris Ball <cjb@laptop.org>
Subject: [117/152] mmc: at91_mci: fix multiblock SDIO transfers
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/arm/mach-at91/include/mach/at91_mci.h |    2 ++
 drivers/mmc/host/at91_mci.c                |   13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-at91/include/mach/at91_mci.h
+++ b/arch/arm/mach-at91/include/mach/at91_mci.h
@@ -74,6 +74,8 @@
 #define			AT91_MCI_TRTYP_BLOCK	(0 << 19)
 #define			AT91_MCI_TRTYP_MULTIPLE	(1 << 19)
 #define			AT91_MCI_TRTYP_STREAM	(2 << 19)
+#define			AT91_MCI_TRTYP_SDIO_BYTE	(4 << 19)
+#define			AT91_MCI_TRTYP_SDIO_BLOCK	(5 << 19)
 
 #define AT91_MCI_BLKR		0x18		/* Block Register */
 #define		AT91_MCI_BLKR_BCNT(n)	((0xffff & (n)) << 0)	/* Block count */
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -69,6 +69,7 @@
 #include <linux/highmem.h>
 
 #include <linux/mmc/host.h>
+#include <linux/mmc/sdio.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -493,10 +494,14 @@ static void at91_mci_send_command(struct
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


