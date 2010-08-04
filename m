Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab0HDG7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:59:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58302 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab0HDG7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kfS54pkzLx5DgiSIyE3N4W9HIA0v9B930hI29olOpxYSVH4tvLY2nVMH43/AnkE157
         nwD9EtkDJcLdueGSP6T5lMbWVhBe08digpjSYlpOQJozDKqgBSApHlAITjwbY3UyPTZD
         f17smLBxweOKpHU16yZ+9UJyRhB102f65YfiE=
MIME-Version: 1.0
In-Reply-To: <AANLkTinzvwP74oNaS+mWRnostnGrZZ-iY2SsjMzo=CW4@mail.gmail.com>
References: <1280850203-5532-1-git-send-email-segooon@gmail.com>
	<AANLkTinzvwP74oNaS+mWRnostnGrZZ-iY2SsjMzo=CW4@mail.gmail.com>
Date: Wed, 4 Aug 2010 08:59:31 +0200
Message-ID: <AANLkTi=y0Ka9+jKFCvS0_Pbku=bTrsyU3LMCSOX2VwLs@mail.gmail.com>
Subject: Re: [PATCH 06/11] rt2x00: do not use PCI resources before 
	pci_enable_device()
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Alban Browaeys <prahal@yahoo.com>, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 6:14 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On Tue, Aug 3, 2010 at 5:43 PM, Kulikov Vasiliy <segooon@gmail.com> wrote:
>> IRQ and resource[] may not have correct values until
>> after PCI hotplug setup occurs at pci_enable_device() time.
>>
>> The semantic match that finds this problem is as follows:
>>
>> // <smpl>
>> @@
>> identifier x;
>> identifier request ~= "pci_request.*|pci_resource.*";
>> @@
>>
>> (
>> * x->irq
>> |
>> * x->resource
>> |
>> * request(x, ...)
>> )
>>  ...
>> *pci_enable_device(x)
>> // </smpl>
>>
>> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>
> Good catch.
>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

>> ---
>>  drivers/net/wireless/rt2x00/rt2x00pci.c |   21 ++++++++++-----------
>>  1 files changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
>> index 19b262e..63c2cc4 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
>> @@ -240,16 +240,16 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>>        struct rt2x00_dev *rt2x00dev;
>>        int retval;
>>
>> -       retval = pci_request_regions(pci_dev, pci_name(pci_dev));
>> +       retval = pci_enable_device(pci_dev);
>>        if (retval) {
>> -               ERROR_PROBE("PCI request regions failed.\n");
>> +               ERROR_PROBE("Enable device failed.\n");
>>                return retval;
>>        }
>>
>> -       retval = pci_enable_device(pci_dev);
>> +       retval = pci_request_regions(pci_dev, pci_name(pci_dev));
>>        if (retval) {
>> -               ERROR_PROBE("Enable device failed.\n");
>> -               goto exit_release_regions;
>> +               ERROR_PROBE("PCI request regions failed.\n");
>> +               goto exit_disable_device;
>>        }
>>
>>        pci_set_master(pci_dev);
>> @@ -260,14 +260,14 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>>        if (dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
>>                ERROR_PROBE("PCI DMA not supported.\n");
>>                retval = -EIO;
>> -               goto exit_disable_device;
>> +               goto exit_release_regions;
>>        }
>>
>>        hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
>>        if (!hw) {
>>                ERROR_PROBE("Failed to allocate hardware.\n");
>>                retval = -ENOMEM;
>> -               goto exit_disable_device;
>> +               goto exit_release_regions;
>>        }
>>
>>        pci_set_drvdata(pci_dev, hw);
>> @@ -300,13 +300,12 @@ exit_free_reg:
>>  exit_free_device:
>>        ieee80211_free_hw(hw);
>>
>> -exit_disable_device:
>> -       if (retval != -EBUSY)
>> -               pci_disable_device(pci_dev);
>> -
>>  exit_release_regions:
>>        pci_release_regions(pci_dev);
>>
>> +exit_disable_device:
>> +       pci_disable_device(pci_dev);
>> +
>>        pci_set_drvdata(pci_dev, NULL);
>>
>>        return retval;
>> --
>> 1.7.0.4
>>
>>
>
