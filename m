Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2ARLDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:03:24 -0500
Received: from mail91.extendcp.co.uk ([79.170.40.91]:34600 "EHLO
	mail91.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2ARLDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:03:23 -0500
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 06:03:23 EST
From: "Simon J. Rowe" <srowe@mose.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/1] libata: blacklist NCQ on WDC WD740ADFD-00NLR4
Date: Wed, 18 Jan 2012 10:38:30 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.33.7-desktopPAE-2mnb; KDE/4.4.5; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201181038.30271.srowe@mose.org.uk>
X-Authenticated-As: srowe@mose.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing intermittent issues on my desktop (running 2.6.38.7) recently

Jan 16 20:54:08 gilraen kernel: ata5.00: exception Emask 0x10 SAct 0x807f SErr 
0x400100 action 0x6 frozen
Jan 16 20:54:08 gilraen kernel: ata5.00: irq_stat 0x08000000, interface fatal 
error
Jan 16 20:54:08 gilraen kernel: ata5: SError: { UnrecovData Handshk }
Jan 16 20:54:08 gilraen kernel: ata5.00: failed command: WRITE FPDMA QUEUED
Jan 16 20:54:08 gilraen kernel: ata5.00: cmd 
61/d8:00:ef:13:d8/00:00:00:00:00/40 tag 0 ncq 110592 out
Jan 16 20:54:08 gilraen kernel:         res 
40/00:20:97:13:d8/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Jan 16 20:54:08 gilraen kernel: ata5.00: status: { DRDY }

The disk is a WD Raptor WD740 which I noticed has NCQ blacklisted. The exact 
model isn't present in the blacklist so I added it (patch below). The errors 
then came out slightly differently

Jan 16 21:17:08 gilraen kernel: ata5.00: exception Emask 0x10 SAct 0x0 SErr 
0x400100 action 0x6 frozen
Jan 16 21:17:08 gilraen kernel: ata5.00: irq_stat 0x08000000, interface fatal 
error
Jan 16 21:17:08 gilraen kernel: ata5: SError: { UnrecovData Handshk }
Jan 16 21:17:08 gilraen kernel: ata5.00: failed command: WRITE DMA EXT
Jan 16 21:17:08 gilraen kernel: ata5.00: cmd 
35/00:68:6f:5d:9a/00:01:00:00:00/e0 tag 0 dma 184320 out
Jan 16 21:17:08 gilraen kernel:         res 
50/00:00:66:5d:9a/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
Jan 16 21:17:08 gilraen kernel: ata5.00: status: { DRDY }
Jan 16 21:17:08 gilraen kernel: ata5: hard resetting link
Jan 16 21:17:08 gilraen kernel: ata5: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
Jan 16 21:17:08 gilraen kernel: ata5.00: configured for UDMA/133
Jan 16 21:17:08 gilraen kernel: ata5: EH complete

Googling revealed that this is often caused by faulty cabling. I moved the 
power and SATA cables and the problem has now gone but I think the disk should 
still be added to the blacklist,

Thanks
		Simon


>From 5df7fe5040b02281617965f99931a9a8ef30b9cb Mon Sep 17 00:00:00 2001
From: Simon J. Rowe <srowe@mose.org.uk>
Date: Wed, 18 Jan 2012 10:14:02 +0000
Subject: [PATCH 1/1] libata: blacklist NCQ on WDC WD740ADFD-00NLR4

Add another Western Digital WD740 model to the blacklist.

Signed-off-by: Simon J. Rowe <srowe@mose.org.uk>
---
 drivers/ata/libata-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 76c3c15..1d06f37 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4077,6 +4077,7 @@ static const struct ata_blacklist_entry 
ata_device_blacklist [] = {
 	/* NCQ is slow */
 	{ "WDC WD740ADFD-00",	NULL,		ATA_HORKAGE_NONCQ },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
+	{ "WDC WD740ADFD-00NLR4", NULL,		ATA_HORKAGE_NONCQ, },
 	/* http://thread.gmane.org/gmane.linux.ide/14907 */
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
-- 
1.7.2.5

