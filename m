Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0JDKwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:52:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46552 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0JDKwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mcGZaHS/pt5JibqpsqKu8f3429Wp7kAfTdN+NPE+4KuVkYVTGmrWg+md7hOcAD0O58
         7psjAZR4qRJq2z6PfQGenQ79CABGf94+yE9IUF/DJBK2cw/+Ks+MGw3oqZiTLn0O53E8
         pUcMR9TEVObRgSNYsM05Bpl/2H+aQrRCLxWk0=
MIME-Version: 1.0
In-Reply-To: <4CA9B004.3020103@ru.mvista.com>
References: <1286113750-2607-1-git-send-email-rahul.ruikar@gmail.com> <4CA9B004.3020103@ru.mvista.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Mon, 4 Oct 2010 16:22:00 +0530
Message-ID: <AANLkTinAzyTon90H0HOMg1zAcQrHHS6xhVCHi9baN_7B@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will resubmit this patch alongwith other patches.

Thanks
- Rahul Ruikar





On 4 October 2010 16:14, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 03-10-2010 17:49, Rahul Ruikar wrote:
>
>> - call device_unregister() only when device_register() is sucess.
>
>   s/is sucess/succeeds/
>
>> - call put_device() when device_register() fails.
>
>> Signed-off-by: Rahul Ruikar<rahul.ruikar@gmail.com>
>> ---
>>  drivers/usb/gadget/langwell_udc.c |   18 ++++++++++++++----
>>  drivers/usb/gadget/langwell_udc.h |    4 +++-
>>  2 files changed, 17 insertions(+), 5 deletions(-)
>
>> diff --git a/drivers/usb/gadget/langwell_udc.c
>> b/drivers/usb/gadget/langwell_udc.c
>> index c2d2a20..2b5ae16 100644
>> --- a/drivers/usb/gadget/langwell_udc.c
>> +++ b/drivers/usb/gadget/langwell_udc.c
>> @@ -2952,8 +2952,13 @@ static void langwell_udc_remove(struct pci_dev
>> *pdev)
>>        INFO(dev, "unbind\n");
>>        DBG(dev, "<--- %s()\n", __func__);
>>
>> -       device_unregister(&dev->gadget.dev);
>> -       device_remove_file(&pdev->dev,&dev_attr_langwell_udc);
>> +       if (dev->dev_reg_status == 2)
>> +               device_unregister(&dev->gadget.dev);
>> +       else if (dev->dev_reg_status == 1)
>> +               put_device(&dev->gadget.dev);
>> +
>> +       if (dev->dev_create_file)
>> +               device_remove_file(&pdev->dev,&dev_attr_langwell_udc);
>>
>>  #ifndef       OTG_TRANSCEIVER
>>        pci_set_drvdata(pdev, NULL);
>> @@ -3190,12 +3195,17 @@ static int langwell_udc_probe(struct pci_dev
>> *pdev,
>>        the_controller = dev;
>>
>>        retval = device_register(&dev->gadget.dev);
>> -       if (retval)
>> +       if (retval) {
>> +               dev_reg_status = 1;
>
>   Did you mean 'dev->dev_reg_status'?
>
>>                goto error;
>> +       }
>> +       dev_reg_status = 2;
>
>   Same question.
>
>>
>>        retval = device_create_file(&pdev->dev,&dev_attr_langwell_udc);
>> -       if (retval)
>> +       if (retval) {
>> +               dev_create_file = 1;
>
>   Did you mean 'dev->dev_create_file'?
>
> WBR, Sergei
>
