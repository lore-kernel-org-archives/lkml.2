Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0KIVQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:16:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52988 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0KIVQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <4CD8F884.30409@monstr.eu>
References: <20101014161724.18966.42340.stgit@localhost6.localdomain6>
 <4CD7FB27.9030804@monstr.eu> <ec622bb7-57d1-4aa2-80f1-65fa4b3fa7eb@VA3EHSMHS033.ehs.local>
 <AANLkTinMoqqMKeEFiD=xHwa5DS+5qY6xN2r236SZQEba@mail.gmail.com> <4CD8F884.30409@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Nov 2010 14:16:30 -0700
X-Google-Sender-Auth: ioGMJ2skzl2saWQyfd5wBhvCAxI
Message-ID: <AANLkTimGwW-v1VQyOM3fmE-6wNf7g64W1YNALh2kd=54@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
To: monstr@monstr.eu
Cc: John Linn <John.Linn@xilinx.com>, spi-devel-general@lists.sourceforge.net,
        richard.rojfors@mocean-labs.com, linux-kernel@vger.kernel.org,
        dbrownell@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 12:30 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi, [cc: David Brownell]
>
> Grant Likely wrote:
>> On Mon, Nov 8, 2010 at 9:34 AM, John Linn <John.Linn@xilinx.com> wrote:
>>>> -----Original Message-----
>>>> From: Michal Simek [mailto:monstr@monstr.eu]
>>>> Sent: Monday, November 08, 2010 6:29 AM
>>>> To: grant.likely@secretlab.ca
>>>> Cc: spi-devel-general@lists.sourceforge.net; richard.rojfors@mocean-labs.com; John Linn; linux-
>>>> kernel@vger.kernel.org
>>>> Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
>>>>
>>>> Hi Grant,
>>>>
>>>> Grant Likely wrote:
>>>>> Since of_platform_bus_type has been merged with the platform_bus_type,
>>>>> a single platform driver can now support both use cases.  This patch
>>>>> series merges the two halves of the xilinx_spi device driver.
>>>>>
>>>>> Compile tested only.  I haven't booted this yet.
>>>> I have tested it on sp605 and works well. Have you added that patches
>>>> to your repository? Or are they somewhere else? Who is responsible for?
>>>>
>>>> I would like to also discuss one change which is related mmc_spi kernel driver.
>>>> Let me describe the problem. Microblaze can use dma in all addresses
>>>> that's why dma_mask is setup to 0xffffffff in of_platform_device_create.
>>>> Xilinx spi driver doesn't support dma but mmc_spi driver is checking dma_mask in parent device
>>>> which is xilinx spi driver.
>>>>
>>>> Here is the corresponding the part of code (Expect dma_mask=zero for no dma operations).
>>>> mmc_spi.c:~1395
>>>>       if (spi->master->dev.parent->dma_mask) {
>>>>               struct device   *dev = spi->master->dev.parent;
>>>>
>>>>               host->dma_dev = dev;
>>>>
>>>>
>>>> Based on this one our customer came with the following solution to setup
>>>> dma_mask in xilinx_spi to zero and then mmc_spi doesn't setup dma operation.
>>>>
>>>> I think that this is nice solution but I would like to be sure that I didn't miss anything.
>>>> After that i will create proper patch with description.
>>> Seems reasonable to me.
>>
>> Hmmm, that actually is not sane.  Ideally, drivers should never be
>> mucking with the dma mask.  It is supposed to only be set by the code
>> actually registering the device.  The mmc code should not be looking
>> at the parent's dma mask to determine if DMA is available; the spi bus
>> drivers should be explicitly stating whether or not it supports DMA.
>> The mmc_spi code is doing the wrong thing here.
>
> I have no problem to fix mmc_spi driver but what is the standard way how to detect
> DMA capability for this case? This part of code is in mmc_spi from the beginning that's why I am
> wondering that none complain about.
>
> David?
>
> Sorry I don't have HW where I can test it. :-(

Nobody will have *all* the hardware required to test it.  The solution
is actually really hard because it requires auditing all of the spi
bus drivers, figuring out which ones of them support dma, and then
publishing that information in a way readable by the spi_device
drivers.  For the time being, you're solution is probably the most
reasonable.

g.
