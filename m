Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1AFLTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:19:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41773 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1AFLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X6rMEvVtF5y6frNQSKW02GHT72XKvZjvN4H8Vu7CbBm1x+ZJOM28y+VyKbG1vWN4u+
         CHYwJprXLj4odBPIOoOn2Jabh0FPo4rm1sGoRRSlTV2YMI2jdb332sJAkvFpHSudNJMP
         kzom2GaKF+W/TXDNm3YVb/jVp18k7pKYBiV04=
Subject: Re: Hit BUG_ON in dma-mapping.c:425
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Hong XU <hong.xu@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
In-Reply-To: <4D259B9C.6060409@atmel.com>
References: <4D24A108.2080609@atmel.com>
	 <20110105165551.GE8638@n2100.arm.linux.org.uk> <4D259B9C.6060409@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 13:19:29 +0200
Message-ID: <1294312769.2219.7.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 11:38 +0100, Nicolas Ferre wrote:
> (I include MTD mailing-list now)
> 
> Le 05/01/2011 17:55, Russell King - ARM Linux :
> > On Wed, Jan 05, 2011 at 05:49:12PM +0100, Nicolas Ferre wrote:
> >> Hi,
> >>
> >> While running mtd_stresstest on a dataflash (atmel_spi 
> >> + mtd_dataflash drivers) I hit the BUG_ON directive that 
> >> is at the beginning of ___dma_single_cpu_to_dev() function.
> >> This function is called from the SPI driver that do a 
> >> dma_map_single() before DMA operations on the buffer 
> >> transmitted from upper layers.
> >>
> >> It seems that this address is above "high_memory" limit because 
> >> it is allocated by vmalloc (in mtd_stresstest.c:285)...
> > 
> > Well, its telling you is that you're not allowed to DMA to vmalloc
> > addresses.  Whether that's the fault of the map driver or not is a
> > question for mtd folk.
> 
> So you mean that those vmalloc calls should be changed to kmalloc in
> MTD like this:
> 
> --- a/drivers/mtd/tests/mtd_stresstest.c
> +++ b/drivers/mtd/tests/mtd_stresstest.c
> @@ -26,7 +26,6 @@
>  #include <linux/mtd/mtd.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> -#include <linux/vmalloc.h>
>  
>  #define PRINT_PREF KERN_INFO "mtd_stresstest: "
>  
> @@ -281,8 +280,8 @@ static int __init mtd_stresstest_init(void)
>         bufsize = mtd->erasesize * 2;
>  
>         err = -ENOMEM;
> -       readbuf = vmalloc(bufsize);
> -       writebuf = vmalloc(bufsize);
> +       readbuf = kmalloc(bufsize, GFP_KERNEL);
> +       writebuf = kmalloc(bufsize, GFP_KERNEL);
>         offsets = kmalloc(ebcnt * sizeof(int), GFP_KERNEL);
>         if (!readbuf || !writebuf || !offsets) {
>                 printk(PRINT_PREF "error: cannot allocate memory\n");
> @@ -313,8 +312,8 @@ static int __init mtd_stresstest_init(void)
>  out:
>         kfree(offsets);
>         kfree(bbt);
> -       vfree(writebuf);
> -       vfree(readbuf);
> +       kfree(writebuf);
> +       kfree(readbuf);
>         put_mtd_device(mtd);
>         if (err)
>                 printk(PRINT_PREF "error %d occurred\n", err);
> 
> 
> I also discovered the same issue while trying to write with "dd"
> on /dev/mtdblockx
> 
> Same vmalloc'ed memory seems to be used in mtdblock_writesect():
> mtdblk->cache_data = vmalloc(mtdblk->mbd.mtd->erasesize);
> 
> I know that using "dd" on a block device is not the common case but it
> should work instead of not being able to transmit buffer with DMA...
> So what it implies to switch this to kmalloc? Is it regression-free to
> do this?

Unfortunatelly not. These are about allocating eraseblock-sized buffers,
which may be as large as 512KiB, and kmalloc can easily fail, this is
why vmalloc is used.

What you should do instead is to change the code and make it use smaller
kmalloc-ed buffers instead, in a loop. Or use an array of pointers, each
pointing to smaller buffers, and teach mtd to understand them. Then we
could reuse this infrastructure in UBI and UBIFS and JFFS2 as well.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

