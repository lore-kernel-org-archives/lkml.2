Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0KHSBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:01:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48381 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0KHSBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <ec622bb7-57d1-4aa2-80f1-65fa4b3fa7eb@VA3EHSMHS033.ehs.local>
References: <20101014161724.18966.42340.stgit@localhost6.localdomain6>
 <4CD7FB27.9030804@monstr.eu> <ec622bb7-57d1-4aa2-80f1-65fa4b3fa7eb@VA3EHSMHS033.ehs.local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 8 Nov 2010 13:01:18 -0500
X-Google-Sender-Auth: ZbYoDx4HcqXZppK3dOpmS_MOJ0A
Message-ID: <AANLkTinMoqqMKeEFiD=xHwa5DS+5qY6xN2r236SZQEba@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
To: John Linn <John.Linn@xilinx.com>
Cc: monstr@monstr.eu, spi-devel-general@lists.sourceforge.net,
        richard.rojfors@mocean-labs.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 9:34 AM, John Linn <John.Linn@xilinx.com> wrote:
>> -----Original Message-----
>> From: Michal Simek [mailto:monstr@monstr.eu]
>> Sent: Monday, November 08, 2010 6:29 AM
>> To: grant.likely@secretlab.ca
>> Cc: spi-devel-general@lists.sourceforge.net; richard.rojfors@mocean-labs.com; John Linn; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
>>
>> Hi Grant,
>>
>> Grant Likely wrote:
>> > Since of_platform_bus_type has been merged with the platform_bus_type,
>> > a single platform driver can now support both use cases.  This patch
>> > series merges the two halves of the xilinx_spi device driver.
>> >
>> > Compile tested only.  I haven't booted this yet.
>>
>> I have tested it on sp605 and works well. Have you added that patches
>> to your repository? Or are they somewhere else? Who is responsible for?
>>
>> I would like to also discuss one change which is related mmc_spi kernel driver.
>> Let me describe the problem. Microblaze can use dma in all addresses
>> that's why dma_mask is setup to 0xffffffff in of_platform_device_create.
>> Xilinx spi driver doesn't support dma but mmc_spi driver is checking dma_mask in parent device
>> which is xilinx spi driver.
>>
>> Here is the corresponding the part of code (Expect dma_mask=zero for no dma operations).
>> mmc_spi.c:~1395
>>       if (spi->master->dev.parent->dma_mask) {
>>               struct device   *dev = spi->master->dev.parent;
>>
>>               host->dma_dev = dev;
>>
>>
>> Based on this one our customer came with the following solution to setup
>> dma_mask in xilinx_spi to zero and then mmc_spi doesn't setup dma operation.
>>
>> I think that this is nice solution but I would like to be sure that I didn't miss anything.
>> After that i will create proper patch with description.
>
> Seems reasonable to me.

Hmmm, that actually is not sane.  Ideally, drivers should never be
mucking with the dma mask.  It is supposed to only be set by the code
actually registering the device.  The mmc code should not be looking
at the parent's dma mask to determine if DMA is available; the spi bus
drivers should be explicitly stating whether or not it supports DMA.
The mmc_spi code is doing the wrong thing here.

That being said, until the mmc_spi code is fixed (and all the users
are fixed up so DMA still works) then this patch is probably the best
solution.  However, please note that dev->dma_mask is a pointer, so
you should actually be setting it to NULL.

g.

>
> Thanks,
> John
>
>>
>>
>> diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
>> index 7adaef6..3612e1b 100644
>> --- a/drivers/spi/xilinx_spi.c
>> +++ b/drivers/spi/xilinx_spi.c
>> @@ -519,6 +519,9 @@ static int __devinit xilinx_spi_probe(struct platform_device *dev)
>>         }
>>
>>         platform_set_drvdata(dev, master);
>> +       /* clear the dma_mask, to try to disable use of dma */
>> +       dev->dev.dma_mask = 0;
>> +
>>         return 0;
>>  }
>>
>>
>> Thanks,
>> Michal
>>
>>
>> --
>> Michal Simek, Ing. (M.Eng)
>> w: www.monstr.eu p: +42-0-721842854
>> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
>> Microblaze U-BOOT custodian
>
>
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
