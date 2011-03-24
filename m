Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1CXJO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:14:58 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:22680 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CXJO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:14:56 -0400
X-Greylist: delayed 3381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 05:14:56 EDT
Message-ID: <4D8AFE45.8050609@atmel.com>
Date: Thu, 24 Mar 2011 16:18:13 +0800
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, dedekind1@gmail.com
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Hong XU <hong.xu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-mtd <linux-mtd@lists.infradead.org>
Subject: Re: Hit BUG_ON in dma-mapping.c:425 (RFC)
References: <4D24A108.2080609@atmel.com>
In-Reply-To: <4D24A108.2080609@atmel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2011 12:49 AM, Nicolas Ferre :
> Hi,
> 
> While running mtd_stresstest on a dataflash (atmel_spi 
> + mtd_dataflash drivers) I hit the BUG_ON directive that 
> is at the beginning of ___dma_single_cpu_to_dev() function.
> This function is called from the SPI driver that do a 
> dma_map_single() before DMA operations on the buffer 
> transmitted from upper layers.
> 
> It seems that this address is above "high_memory" limit because 
> it is allocated by vmalloc (in mtd_stresstest.c:285)...
> 
> The question is: where the bug is relying? Is there a 
> configuration that I must modify in AT91 Linux to be able 
> to modify this behavior or is this an error in the use of 
> dma_map_single() in the atmel_spi.c driver?
> 
> After searching the web, it seems it is quite common after 
> 2.6.34 kernels... But I cannot figure out what is the issue.
> 
> Here is the Oops output:
> root@at91sam9m10g45ek:~# insmod ../n/mtd_stresstest.ko dev=3
> 
> =================================================
> mtd_stresstest: MTD device: 3
> mtd_stresstest: MTD device size 4325376, eraseblock size 528, page size 528, count of eraseblocks 8192, pages per eraseblock 1, OOB size 0
> mtd_stresstest: doing operations
> mtd_stresstest: 0 operations done
> kernel BUG at /home/nferre/workspace/linux/linux-2.6-arm/arch/arm/mm/dma-mapping.c:425!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c31bc000
> [00000000] *pgd=732b1031, *pte=00000000, *ppte=00000000
> Internal error: Oops: 817 [#1]
> last sysfs file: /sys/devices/platform/atmel-ehci/usb1/1-2/1-2:1.0/host0/target0:0:0/0:0:0:0/block/sda/size
> Modules linked in: mtd_stresstest(+)
> CPU: 0    Not tainted  (2.6.37+ #2)
> PC is at __bug+0x1c/0x28
> LR is at __bug+0x18/0x28
> pc : [<c0030374>]    lr : [<c0030370>]    psr: 20000093
> sp : c3b09df8  ip : 00000200  fp : 00601c00
> r10: c4886000  r9 : 00001807  r8 : 74886000
> r7 : c38d37a0  r6 : c39660e8  r5 : c3b09ebc  r4 : c3b09e98
> r3 : 00000000  r2 : c3b09dec  r1 : c02ef2c1  r0 : 0000005e
> Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 0005317f  Table: 731bc000  DAC: 00000015
> Process insmod (pid: 1649, stack limit = 0xc3b08270)
> Stack: (0xc3b09df8 to 0xc3b0a000)
> 9de0:                                                       ffffffff c0032b1c
> 9e00: c3b09e98 c01817c4 c3966000 c3b09e3c 00000000 c38d37a0 c3966000 c018070c
> 9e20: 60000013 c3b09e3c 00000000 c018076c c3b09ebc c0180914 c38d37a0 00000000
> 9e40: c3b09e40 c3b09e40 c3979e00 00000420 c3b09f2c 00000210 00601c00 c0179ba8
> 9e60: 00100100 00318e70 c38d37a0 c3979e24 00000000 c3979e00 00000000 00000004
> 9e80: 73979e00 ffffffff 00000000 00000000 c3b09eb4 c3b09ebc c4886000 00000000
> 9ea0: 00000210 ffffffff ffffffff 00000000 00000000 c3b09ebc c3b09e90 c3b09e90
> 9ec0: c3b09eb4 c38d37a0 00000000 c0180ab8 c3b09e3c 00000000 ffffff8d 00000000
> 9ee0: 00000000 00000000 00000000 00000000 00000000 00001807 00000000 0000601c
> 9f00: 00318e70 00000420 00001808 bf0034b0 00000420 c3b09f2c c4886000 00000001
> 9f20: 00000000 00000000 00000000 00000000 0000002e bf0005fc bf003000 00012008
> 9f40: 00000000 c002cfa8 c3b08000 00000000 00012008 c002740c c035ecf4 00000001
> 9f60: bf0005fc 00000000 00012008 bf0005fc 00000000 00012008 00011d23 c002cfa8
> 9f80: 00000000 c0062dec 00012018 00011d23 00012008 00000000 00012008 00020000
> 9fa0: 00000080 c002ce00 00000000 00012008 00012018 00011d23 00012008 00000001
> 9fc0: 00000000 00012008 00020000 00000080 bec09efb bec09ef4 00012018 00012008
> 9fe0: 00000003 bec09c94 00008d77 401c0054 60000010 00012018 657a6973 69657700
> [<c0030374>] (__bug+0x1c/0x28) from [<c0032b1c>] (___dma_single_cpu_to_dev+0x34/0x5c)
> [<c0032b1c>] (___dma_single_cpu_to_dev+0x34/0x5c) from [<c01817c4>] (atmel_spi_transfer+0xc8/0x1c4)
> [<c01817c4>] (atmel_spi_transfer+0xc8/0x1c4) from [<c018070c>] (__spi_async+0x94/0xa0)
> [<c018070c>] (__spi_async+0x94/0xa0) from [<c018076c>] (spi_async_locked+0x14/0x2c)
> [<c018076c>] (spi_async_locked+0x14/0x2c) from [<c0180914>] (__spi_sync+0x5c/0x9c)
> [<c0180914>] (__spi_sync+0x5c/0x9c) from [<c0179ba8>] (dataflash_write+0x180/0x1fc)
> [<c0179ba8>] (dataflash_write+0x180/0x1fc) from [<bf0034b0>] (mtd_stresstest_init+0x4b0/0x604 [mtd_stresstest])
> [<bf0034b0>] (mtd_stresstest_init+0x4b0/0x604 [mtd_stresstest]) from [<c002740c>] (do_one_initcall+0xcc/0x1a8)
> [<c002740c>] (do_one_initcall+0xcc/0x1a8) from [<c0062dec>] (sys_init_module+0x90/0x1a4)
> [<c0062dec>] (sys_init_module+0x90/0x1a4) from [<c002ce00>] (ret_fast_syscall+0x0/0x2c)
> Code: e59f0010 e1a01003 eb0916de e3a03000 (e5833000)
> ---[ end trace 0f2f3786a6a31f57 ]---
> Segmentation fault
> 
> This append on 2.6.37 kernel.

I come back on this issue with a little patch. It figures out where is located the page address if it appends to be in high memory (allocated by vmalloc()).

What do you think about it:

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -647,6 +647,22 @@ static void atmel_spi_next_message(struct spi_master *master)
 	atmel_spi_next_xfer(master, msg);
 }
 
+static void *adjust_buffer_location(struct device *dev, void *buf)
+{
+	if (likely(buf < high_memory)) {
+		return buf;
+	} else {
+		struct page *pg;
+
+		pg = vmalloc_to_page(buf);
+		if (pg == 0) {
+			dev_err(dev, "failed to vmalloc_to_page\n");
+			return NULL;
+		}
+		return page_address(pg) + ((size_t)buf & ~PAGE_MASK);
+	}
+}
+
 /*
  * For DMA, tx_buf/tx_dma have the same relationship as rx_buf/rx_dma:
  *  - The buffer is either valid for CPU access, else NULL
@@ -658,23 +674,24 @@ static int
 atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
 {
 	struct device	*dev = &as->pdev->dev;
+	void 		*ptr;
 
 	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
 	if (xfer->tx_buf) {
-		/* tx_buf is a const void* where we need a void * for the dma
-		 * mapping */
-		void *nonconst_tx = (void *)xfer->tx_buf;
-
-		xfer->tx_dma = dma_map_single(dev,
-				nonconst_tx, xfer->len,
-				DMA_TO_DEVICE);
+		ptr = adjust_buffer_location(dev, (void *)xfer->tx_buf);
+		if (ptr)
+			xfer->tx_dma = dma_map_single(dev,
+					ptr, xfer->len,
+					DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, xfer->tx_dma))
 			return -ENOMEM;
 	}
 	if (xfer->rx_buf) {
-		xfer->rx_dma = dma_map_single(dev,
-				xfer->rx_buf, xfer->len,
-				DMA_FROM_DEVICE);
+		ptr = adjust_buffer_location(dev, xfer->rx_buf);
+		if (ptr)
+			xfer->rx_dma = dma_map_single(dev,
+					ptr, xfer->len,
+					DMA_FROM_DEVICE);
 		if (dma_mapping_error(dev, xfer->rx_dma)) {
 			if (xfer->tx_buf)
 				dma_unmap_single(dev,diff --git a/arch/arm/mach-at91/board-

