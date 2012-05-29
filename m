Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2E2J7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:59:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32993 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2E2J6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <1659482.3g1Zl6FDuM@flexo>
References: <1338206223-26781-1-git-send-email-devendra.aaru@gmail.com>
	<1659482.3g1Zl6FDuM@flexo>
Date: Tue, 29 May 2012 15:28:51 +0530
Message-ID: <CAHdPZaPWM3MfyARfwOm2KkKPPvm4dEfncF47N2xASyp27HdzsA@mail.gmail.com>
Subject: Re: [PATCH] r6040: disable pci device if the subsequent calls (after
 pci_enable_device) fails
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Florian,

On Tue, May 29, 2012 at 2:50 PM, Florian Fainelli <florian@openwrt.org> wrote:
> On Monday 28 May 2012 17:27:03 Devendra Naga wrote:
>> the calls after the pci_enable_device may fail, and will error out with out
>> disabling it. disable the device at error paths.
>
> Looks good, thanks Devendra!
>
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>
> Acked-by: Florian Fainelli <florian@openwrt.org>
>
>> ---
>>  drivers/net/ethernet/rdc/r6040.c |   10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/rdc/r6040.c
> b/drivers/net/ethernet/rdc/r6040.c
>> index 4de7364..8f5079a 100644
>> --- a/drivers/net/ethernet/rdc/r6040.c
>> +++ b/drivers/net/ethernet/rdc/r6040.c
>> @@ -1096,20 +1096,20 @@ static int __devinit r6040_init_one(struct pci_dev
> *pdev,
>>       if (err) {
>>               dev_err(&pdev->dev, "32-bit PCI DMA addresses"
>>                               "not supported by the card\n");
>> -             goto err_out;
>> +             goto err_out_disable_dev;
>>       }
>>       err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
>>       if (err) {
>>               dev_err(&pdev->dev, "32-bit PCI DMA addresses"
>>                               "not supported by the card\n");
>> -             goto err_out;
>> +             goto err_out_disable_dev;
>>       }
>>
>>       /* IO Size check */
>>       if (pci_resource_len(pdev, bar) < io_size) {
>>               dev_err(&pdev->dev, "Insufficient PCI resources, aborting\n");
>>               err = -EIO;
>> -             goto err_out;
>> +             goto err_out_disable_dev;
>>       }
>>
>>       pci_set_master(pdev);
>> @@ -1117,7 +1117,7 @@ static int __devinit r6040_init_one(struct pci_dev
> *pdev,
>>       dev = alloc_etherdev(sizeof(struct r6040_private));
>>       if (!dev) {
>>               err = -ENOMEM;
>> -             goto err_out;
>> +             goto err_out_disable_dev;
>>       }
>>       SET_NETDEV_DEV(dev, &pdev->dev);
>>       lp = netdev_priv(dev);
>> @@ -1238,6 +1238,8 @@ err_out_free_res:
>>       pci_release_regions(pdev);
>>  err_out_free_dev:
>>       free_netdev(dev);
>> +err_out_disable_dev:
>> +     pci_disable_device(dev);
>>  err_out:
>>       return err;
>>  }
>> --
>> 1.7.9.5
>>

Thanks for the Ack.
I found one more problem. Its when mdiobus_alloc fails in
r6040_init_one, we need to do call to the netif_napi_del and set the
NULL to pci_set_drvdata, at  err_out_unmap.

Thanks,
Devendra.
