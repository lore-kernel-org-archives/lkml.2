Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0HQRBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:01:25 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4027 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510Ab0HQRBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:01:24 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4C6AC037.7070205@broadcom.com>
Date: Tue, 17 Aug 2010 10:00:39 -0700
From: "Brian Norris" <norris@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Michael Guntsche" <mike@it-loops.com>
cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brian Norris" <norris@broadcom.com>
Subject: Re: [BUG] Nand support broken with v2.6.36-rc1
References: <20100817113644.GA31317@gibson.comsick.at>
In-Reply-To: <20100817113644.GA31317@gibson.comsick.at>
X-WSS-ID: 60741FD237O64684144-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 01:52 AM, Michael Guntsche wrote:
 > The only thing that might be special with the nand driver that is being
 > used is that a different oob layout is being used.
 >
 > static struct nand_ecclayout rbppc_nand_oob_16 = {
 >    .eccbytes = 6,
 >    .eccpos = { 8, 9, 10, 13, 14, 15 },
 >    .oobavail = 9,
 >    .oobfree = { { 0, 4 }, { 6, 2 }, { 11, 2 }, { 4, 1 } }
 > };

On 08/17/2010 04:36 AM, Michael Guntsche wrote:
> I added this to the nand driver itself.
>
> static uint8_t scan_ff_pattern[] = { 0xff, 0xff };
> static struct nand_bbt_descr rbppc_nand_smallpage = {
>    .options = NAND_BBT_SCAN2NDPAGE,
>    .offs = NAND_SMALL_BADBLOCK_POS,
>    .len = 1,
>    .pattern = scan_ff_pattern
> };
>
> and the driver is working again. But shouldn't this be supported by the stock level code as well?

Why yes, it should! Somebody (probably me) goofed. Your nand_ecclayout 
is conflicting with the kernel's choice of bad block position. Recent 
changes must have affected which position is chosen automatically by the 
kernel.

One of the following two cases is likely the problem:
(1) Your chip is supposed to use offset 0, not 5, for the BBM (i.e., 
NAND_LARGE_BADBLOCK_POS, not NAND_SMALL_BADBLOCK_POS), and so your 
ecclayout should not be leaving byte 0 in the "oobfree" array (a design 
flaw since you first began using this chip)
(2) I made the commit that you mentioned 
(c7b28e25cb9beb943aead770ff14551b55fa8c79) too restrictive in allowing 
chips to use NAND_SMALL_BADBLOCK_POS.

Option 2 is likely the case, and in fact, I realized a stupid mistake I 
made in refactoring the detection here.

I have been studying data from hundreds of flash chips to find where the 
factory-determined markers should be stored. Unfortunately, I can't 
cover all of them, and so your Hynix chip is likely one that was 
overlooked. Could you send the full NAND ID string (8 bytes, not just 
the manufacturer and chip ID), an exact part number for the flash, and a 
datasheet? Any one of those could help (the datasheet being the most 
important), but whatever you can provide is helpful. More data on your 
chip would allow me to determine the problem for sure; I will send a 
patch ASAP once I get your information.

Sorry for the trouble!

On another note, it may be intelligent to have the kernel-specific 
systems check for such a conflict between bad-block markers and ECC 
layout. If a position needed by the bad-block marker is listed in 
"oobfree" or "eccpos" then we have a problem. Sound like a good idea 
anybody? If so, what would be the best approach:
* print an error and quit detection
* try to modify the ecclayout, bbm info or both
* try to modify, and fall-back to error message and quit if necessary

Thanks,
Brian

