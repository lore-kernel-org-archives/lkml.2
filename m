Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0I2Deq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:34:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61664 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab0I2Dep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QzP41WgkY0hGiFnBytZj7W/LRyQnbylI/Yf+QWvVOhZuYg7N4+Ym/cAk3lC93Bnp8n
         /dFvGRHyuqLg6j4gePT/j3VmSAxUZ1bLpPHEdl3kRIpJYFvFIK76qwJ9Ne2ZEUfvE778
         nBMo8lDucrcaUPTT0OhRfZ3xZFU63SFjs2+xQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLPw+2QqPzLZ7X0BfRsfvqz1eh2Ay7P4t_Na+2@mail.gmail.com>
References: <1285519830-6826-1-git-send-email-rahul.ruikar@gmail.com> <AANLkTinLPw+2QqPzLZ7X0BfRsfvqz1eh2Ay7P4t_Na+2@mail.gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Wed, 29 Sep 2010 09:04:22 +0530
Message-ID: <AANLkTim2zK1Sp77B5bXUaGzeKyYLt7242yfcO=BWGjnc@mail.gmail.com>
Subject: Re: [RESEND] pcmcia: vrc4173_cardu: Fix error path for
 pci_release_regions and pci_disable_device
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Rahul Ruikar <rahul.ruikar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anyone to review / accept ???
I could not find any particular maintainer for this patch through
"./scripts/get_maintainer.pl" except these 2 lists.

Regards,
Rahul Ruikar



On 26 September 2010 22:41, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> patchwork link not showing latest changes of RESEND patch. hence
> attaching in mail
> https://patchwork.kernel.org/patch/210152/
>
> - Rahul Ruikar
>
>
>
>
>
> On 26 September 2010 22:20, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
>> - pci_release_regions called during return error path.
>> - pci_disable_device called for cases where earlier it was enabled.
>> - code duplication avoided/reduced by adding resource release at goto statements.
>>
>> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
>> ---
>>  drivers/pcmcia/vrc4173_cardu.c |   58 +++++++++++++++++++++++++++-------------
>>  1 files changed, 39 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
>> index 9b3c158..c6d36b3 100644
>> --- a/drivers/pcmcia/vrc4173_cardu.c
>> +++ b/drivers/pcmcia/vrc4173_cardu.c
>> @@ -461,7 +461,7 @@ static int __devinit vrc4173_cardu_probe(struct pci_dev *dev,
>>  {
>>        vrc4173_socket_t *socket;
>>        unsigned long start, len, flags;
>> -       int slot, err;
>> +       int slot, err, ret;
>>
>>        slot = vrc4173_cardu_slots++;
>>        socket = &cardu_sockets[slot];
>> @@ -474,43 +474,63 @@ static int __devinit vrc4173_cardu_probe(struct pci_dev *dev,
>>                return err;
>>
>>        start = pci_resource_start(dev, 0);
>> -       if (start == 0)
>> -               return -ENODEV;
>> +       if (start == 0) {
>> +               ret = -ENODEV;
>> +               goto disable;
>> +       }
>>
>>        len = pci_resource_len(dev, 0);
>> -       if (len == 0)
>> -               return -ENODEV;
>> +       if (len == 0) {
>> +               ret = -ENODEV;
>> +               goto disable;
>> +       }
>>
>> -       if (((flags = pci_resource_flags(dev, 0)) & IORESOURCE_MEM) == 0)
>> -               return -EBUSY;
>> +       flags = pci_resource_flags(dev, 0);
>> +       if ((flags & IORESOURCE_MEM) == 0) {
>> +               ret = -EBUSY;
>> +               goto disable;
>> +       }
>>
>> -       if ((err = pci_request_regions(dev, socket->name)) < 0)
>> -               return err;
>> +       err = pci_request_regions(dev, socket->name);
>> +       if (err < 0) {
>> +               ret = err;
>> +               goto disable;
>> +       }
>>
>>        socket->base = ioremap(start, len);
>> -       if (socket->base == NULL)
>> -               return -ENODEV;
>> +       if (socket->base == NULL) {
>> +               ret = -ENODEV;
>> +               goto release;
>> +       }
>>
>>        socket->dev = dev;
>>
>>        socket->pcmcia_socket = pcmcia_register_socket(slot, &cardu_operations, 1);
>>        if (socket->pcmcia_socket == NULL) {
>> -               iounmap(socket->base);
>> -               socket->base = NULL;
>> -               return -ENOMEM;
>> +               ret =  -ENOMEM;
>> +               goto unmap;
>>        }
>>
>>        if (request_irq(dev->irq, cardu_interrupt, IRQF_SHARED, socket->name, socket) < 0) {
>> -               pcmcia_unregister_socket(socket->pcmcia_socket);
>> -               socket->pcmcia_socket = NULL;
>> -               iounmap(socket->base);
>> -               socket->base = NULL;
>> -               return -EBUSY;
>> +               ret = -EBUSY;
>> +               goto unregister;
>>        }
>>
>>        printk(KERN_INFO "%s at %#08lx, IRQ %d\n", socket->name, start, dev->irq);
>>
>>        return 0;
>> +
>> +unregister:
>> +       pcmcia_unregister_socket(socket->pcmcia_socket);
>> +       socket->pcmcia_socket = NULL;
>> +unmap:
>> +       iounmap(socket->base);
>> +       socket->base = NULL;
>> +release:
>> +       pci_release_regions(dev);
>> +disable:
>> +       pci_disable_device(dev);
>> +       return ret;
>>  }
>>
>>  static int __devinit vrc4173_cardu_setup(char *options)
>> --
>> 1.7.2.3
>>
>>
>
