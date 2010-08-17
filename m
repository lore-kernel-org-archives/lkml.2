Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab0HQSuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:50:20 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1352 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759472Ab0HQSuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:50:12 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4C6AD9C2.1070705@broadcom.com>
Date: Tue, 17 Aug 2010 11:49:38 -0700
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
In-Reply-To: <20100817174704.GA1322@gibson.comsick.at>
X-WSS-ID: 6074065D37O64825084-09-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/17/2010 10:47 AM, Michael Guntsche wrote:
> First, I am just an end user so I have no access to the datasheets etc. I
> just got the code from the board manufactrurer (2.6.27) and forward
> port it to recent kernels.

I see. No problem. We'll work with what you can do:

If you can simply find the NAND chip part number (it would be printed on 
the chip itself), that will be helpful.

Also, there are a few things you can do under a working kernel (e.g., 
2.6.35?).

First, have you ever used any of the mtdutils? In particular, running 
the command "mtdinfo -a" and sending the output is helpful if you have 
the utility installed on your board.

Second, since you are doing the forward-porting, I assume you can do a 
little bit of coding/patching. To print the whole ID string, you can add 
a simple "printk" line to the code in "drivers/mtd/nand/nand_base.c". 
For example, on the 2.6.35 kernel, you can just apply the patch below. 
Then, on boot, the ID string will print (or at least show up in "dmesg" 
or "syslog"). That info can help a little.

> The reason I am using a specific layout is because the bootloader on
> this board expects it this way. It formats it this way in the beginning
> and I cannot change that.

Well, if the new commit that broke your board is getting the block 
marker *correct* according to the factory specifications, then this 
particular problem is your setup's problem; perhaps there could be a 
workaround, like I mentioned about checking for these kind of conflicts. 
However, I'm still hypothesizing that I simply got the detection wrong, 
and so my fix will solve your problem.

Thanks,
Brian

---
  drivers/mtd/nand/nand_base.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 4a7b864..d2d1fab 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2809,8 +2809,10 @@ static struct nand_flash_dev 
*nand_get_flash_type(struct mtd_info *mtd,

  	/* Read entire ID string */

-	for (i = 0; i < 8; i++)
+	for (i = 0; i < 8; i++) {
  		id_data[i] = chip->read_byte(mtd);
+		printk(KERN_INFO "ID byte %i: %#x\n", i, id_data[i]);
+	}

  	if (id_data[0] != *maf_id || id_data[1] != dev_id) {
  		printk(KERN_INFO "%s: second ID read did not match "
-- 
1.7.0.4

