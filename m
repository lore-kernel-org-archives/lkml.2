Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1AFKin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:38:43 -0500
Received: from mail.atmel.fr ([81.80.104.162]:33346 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1AFKim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:38:42 -0500
Message-ID: <4D259B9C.6060409@atmel.com>
Date: Thu, 06 Jan 2011 11:38:20 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-mtd <linux-mtd@lists.infradead.org>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Hong XU <hong.xu@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: Hit BUG_ON in dma-mapping.c:425
References: <4D24A108.2080609@atmel.com> <20110105165551.GE8638@n2100.arm.linux.org.uk>
In-Reply-To: <20110105165551.GE8638@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I include MTD mailing-list now)

Le 05/01/2011 17:55, Russell King - ARM Linux :
> On Wed, Jan 05, 2011 at 05:49:12PM +0100, Nicolas Ferre wrote:
>> Hi,
>>
>> While running mtd_stresstest on a dataflash (atmel_spi 
>> + mtd_dataflash drivers) I hit the BUG_ON directive that 
>> is at the beginning of ___dma_single_cpu_to_dev() function.
>> This function is called from the SPI driver that do a 
>> dma_map_single() before DMA operations on the buffer 
>> transmitted from upper layers.
>>
>> It seems that this address is above "high_memory" limit because 
>> it is allocated by vmalloc (in mtd_stresstest.c:285)...
> 
> Well, its telling you is that you're not allowed to DMA to vmalloc
> addresses.  Whether that's the fault of the map driver or not is a
> question for mtd folk.

So you mean that those vmalloc calls should be changed to kmalloc in MTD like this:

--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -26,7 +26,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/vmalloc.h>
 
 #define PRINT_PREF KERN_INFO "mtd_stresstest: "
 
@@ -281,8 +280,8 @@ static int __init mtd_stresstest_init(void)
        bufsize = mtd->erasesize * 2;
 
        err = -ENOMEM;
-       readbuf = vmalloc(bufsize);
-       writebuf = vmalloc(bufsize);
+       readbuf = kmalloc(bufsize, GFP_KERNEL);
+       writebuf = kmalloc(bufsize, GFP_KERNEL);
        offsets = kmalloc(ebcnt * sizeof(int), GFP_KERNEL);
        if (!readbuf || !writebuf || !offsets) {
                printk(PRINT_PREF "error: cannot allocate memory\n");
@@ -313,8 +312,8 @@ static int __init mtd_stresstest_init(void)
 out:
        kfree(offsets);
        kfree(bbt);
-       vfree(writebuf);
-       vfree(readbuf);
+       kfree(writebuf);
+       kfree(readbuf);
        put_mtd_device(mtd);
        if (err)
                printk(PRINT_PREF "error %d occurred\n", err);


I also discovered the same issue while trying to write with "dd" on /dev/mtdblockx

Same vmalloc'ed memory seems to be used in mtdblock_writesect():
mtdblk->cache_data = vmalloc(mtdblk->mbd.mtd->erasesize);

I know that using "dd" on a block device is not the common case but it should work instead of not being able to transmit buffer with DMA... So what it implies to switch this to kmalloc? Is it regression-free to do this?

Best regards,
-- 
Nicolas Ferre
