Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab0HQVmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:42:50 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3534 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab0HQVmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:42:47 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4C6B024A.7040505@broadcom.com>
Date: Tue, 17 Aug 2010 14:42:34 -0700
From: "Brian Norris" <norris@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Michael Guntsche" <mike@it-loops.com>
cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Nand support broken with v2.6.36-rc1
References: <20100817113644.GA31317@gibson.comsick.at>
 <4C6AC037.7070205@broadcom.com>
 <20100817174704.GA1322@gibson.comsick.at>
 <4C6AD9C2.1070705@broadcom.com>
 <20100817200559.GA4542@gibson.comsick.at>
In-Reply-To: <20100817200559.GA4542@gibson.comsick.at>
X-WSS-ID: 6075DDC63KC80625448-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 01:05 PM, Michael Guntsche wrote:
> On 17 Aug 10 11:49, Brian Norris wrote:
>> First, have you ever used any of the mtdutils? In particular,
>> running the command "mtdinfo -a" and sending the output is helpful
>> if you have the utility installed on your board.
> hmm mtdinfo tries to open /sys/class/mtd/mtd0/dev which das not exist
> the device is working ok as block device on the other hand so let's try
> the next thing.

I'm not an expert on the workings of mtdutils, so I don't know
why your device does not have the necessary sysfs entries. Perhaps
weird hardware features or a strange, incorrect driver (I can't work
on your board specific driver for you). I suppose it's OK to ignore
this problem for the moment.

> Output booting with a patched .36-rc1
> 
> [    0.279217] rbppc_nand_probe: MikroTik RouterBOARD 600 series NAND driver, version 0.0.2
> [    0.287535] ID byte 0: 0xad
> [    0.290373] ID byte 1: 0x76
> [    0.293185] ID byte 2: 0xad
> [    0.295985] ID byte 3: 0x76
> [    0.298798] ID byte 4: 0xad
> [    0.301610] ID byte 5: 0x76
> [    0.304423] ID byte 6: 0xad
> [    0.307223] ID byte 7: 0x76
> [    0.310046] NAND device: Manufacturer ID: 0xad, Chip ID: 0x76 (Hynix NAND 64MiB 3,3V 8-bit)
> 
> Hope this helps...
> 

Honestly, that doesn't really help :) I guess the device is old
enough it does not have an extended ID. In that case, I will need
the part number to be able to diagnose for sure. Can you find the
physical chip on the board and give me whatever labeling is on it?

In place of that, though, you can just try this patch on 2.6.36-rc1.
I believe it should satisfy the intention of my previous (faulty)
commit while reverting the regression behavior. If this works OK, I
will submit it to be included in the mainline kernel.

Thanks for taking the time to debug this.

Brian

---
 drivers/mtd/nand/nand_base.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index a3c7473..a22ed7b 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2934,14 +2934,10 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 		chip->chip_shift = ffs((unsigned)(chip->chipsize >> 32)) + 32 - 1;
 
 	/* Set the bad block position */
-	if (!(busw & NAND_BUSWIDTH_16) && (*maf_id == NAND_MFR_STMICRO ||
-				(*maf_id == NAND_MFR_SAMSUNG &&
-				 mtd->writesize == 512) ||
-				*maf_id == NAND_MFR_AMD))
-		chip->badblockpos = NAND_SMALL_BADBLOCK_POS;
-	else
+	if (mtd->writesize > 512 || (busw & NAND_BUSWIDTH_16))
 		chip->badblockpos = NAND_LARGE_BADBLOCK_POS;
-
+	else
+		chip->badblockpos = NAND_SMALL_BADBLOCK_POS;
 
 	/* Get chip options, preserve non chip based options */
 	chip->options &= ~NAND_CHIPOPTIONS_MSK;
-- 
1.7.0.4

