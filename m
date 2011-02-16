Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1BPUtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:49:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1BPUtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:49:11 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin2xfDBk5n5ch=EYNauyPZEBq2SozQM6by6EY+G@mail.gmail.com>
References: <20110216150943.b4969ddf.sfr@canb.auug.org.au> <AANLkTin2xfDBk5n5ch=EYNauyPZEBq2SozQM6by6EY+G@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Feb 2011 13:48:50 -0700
X-Google-Sender-Auth: 6UirvE17uEen2aTJ31qOrqFZwlA
Message-ID: <AANLkTikFgV52v6syO4f9GNFTYsRP0xSt=Yk5TbiCuFZd@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 spi-current tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 9:41 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Feb 15, 2011 at 9:09 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Grant,
>>
>> Today's linux-next merge of the devicetree tree got a conflict in
>> drivers/spi/pxa2xx_spi_pci.c between commit
>> 0f3e1d27a7e3f98d996d707d649128e229b65deb ("spi/pxa2xx pci: fix the
>> release - remove race") from the spi-current tree and commit
>> c9e358dfc4a8cb2227172ef77908c2e0ee17bcb9 ("driver-core: remove
>> conditionals around devicetree pointers") from the devicetree tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary.
>
> Heh, seeing as those are *both* my trees, I'll take care of merging
> appropriately to sort this out.  :-)

I've just asked Linus to pull the spi-current branch.  When 2.6.38-rc6
is released I'll merge it into the devicetree branch which will take
care of the merge conflict.

g.

>
> g.
>
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc drivers/spi/pxa2xx_spi_pci.c
>> index 19752b0,b6589bb..0000000
>> --- a/drivers/spi/pxa2xx_spi_pci.c
>> +++ b/drivers/spi/pxa2xx_spi_pci.c
>> @@@ -75,24 -84,25 +75,22 @@@ static int __devinit ce4100_spi_probe(s
>>                return ret;
>>        }
>>
>>  +      pdev = platform_device_alloc("pxa2xx-spi", dev->devfn);
>>        spi_info = kzalloc(sizeof(*spi_info), GFP_KERNEL);
>>  -      if (!spi_info) {
>>  +      if (!pdev || !spi_info ) {
>>                ret = -ENOMEM;
>>  -              goto err_kz;
>>  +              goto err_nomem;
>>        }
>>  -      ssp = &spi_info->ssp;
>>  -      pdev = &spi_info->spi_pdev;
>>  -      spi_pdata =  &spi_info->spi_pdata;
>>  +      memset(&spi_pdata, 0, sizeof(spi_pdata));
>>  +      spi_pdata.num_chipselect = dev->devfn;
>>
>>  -      pdev->name = "pxa2xx-spi";
>>  -      pdev->id = dev->devfn;
>>  -      pdev->dev.parent = &dev->dev;
>>  -      pdev->dev.platform_data = &spi_info->spi_pdata;
>>  +      ret = platform_device_add_data(pdev, &spi_pdata, sizeof(spi_pdata));
>>  +      if (ret)
>>  +              goto err_nomem;
>>
>>  +      pdev->dev.parent = &dev->dev;
>> - #ifdef CONFIG_OF
>>        pdev->dev.of_node = dev->dev.of_node;
>> - #endif
>>  -      pdev->dev.release = plat_dev_release;
>>  -
>>  -      spi_pdata->num_chipselect = dev->devfn;
>>  -
>>  +      ssp = &spi_info->ssp;
>>        ssp->phys_base = pci_resource_start(dev, 0);
>>        ssp->mmio_base = ioremap(phys_beg, phys_len);
>>        if (!ssp->mmio_base) {
>>
>
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
