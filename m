Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0IZQpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 12:45:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39764 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab0IZQpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 12:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RVoStCDvGfDel/T10Oj84EBmV6F0IAjQ9kvTwM4aYgcaJGitpFzQM11ExqHoEy7tQT
         mugbpdapamesKxda/sZDWpmLIp54MX9lTeGQGma846h0HpgbOHjhTxaiIeqZSY7+11Ro
         X9I0cmyZGjvLlp0FxKXO//0UTiIdWh+By7mn8=
MIME-Version: 1.0
In-Reply-To: <1285519293-6764-1-git-send-email-rahul.ruikar@gmail.com>
References: <1285519293-6764-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sun, 26 Sep 2010 22:15:18 +0530
Message-ID: <AANLkTinYUyHJxO-AY8YYaRHu9nuPdyw4aqYJWKOqrCXv@mail.gmail.com>
Subject: Re: [PATCH] pcmcia: vrc4173_cardu: Fix error path for
 pci_release_regions and pci_disable_device
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Rahul Ruikar <rahul.ruikar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

somethings missed...  i will resend this patch.

- Rahul Ruikar





On 26 September 2010 22:11, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> - pci_release_regions called during return error path.
> - pci_disable_device called for cases where earlier it was enabled.
> - code duplication avoided/reduced by adding resource release at goto statements.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/pcmcia/vrc4173_cardu.c |   56 +++++++++++++++++++++++++++-------------
>  1 files changed, 38 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
> index 9b3c158..5f43a72 100644
> --- a/drivers/pcmcia/vrc4173_cardu.c
> +++ b/drivers/pcmcia/vrc4173_cardu.c
> @@ -474,43 +474,63 @@ static int __devinit vrc4173_cardu_probe(struct pci_dev *dev,
>                return err;
>
>        start = pci_resource_start(dev, 0);
> -       if (start == 0)
> -               return -ENODEV;
> +       if (start == 0) {
> +               ret = -ENODEV;
> +               goto disable;
> +       }
>
>        len = pci_resource_len(dev, 0);
> -       if (len == 0)
> -               return -ENODEV;
> +       if (len == 0) {
> +               ret = -ENODEV;
> +               goto disable;
> +       }
>
> -       if (((flags = pci_resource_flags(dev, 0)) & IORESOURCE_MEM) == 0)
> -               return -EBUSY;
> +       flags = pci_resource_flags(dev, 0);
> +       if ((flags & IORESOURCE_MEM) == 0) {
> +               ret = -EBUSY;
> +               goto disable;
> +       }
>
> -       if ((err = pci_request_regions(dev, socket->name)) < 0)
> -               return err;
> +       err = pci_request_regions(dev, socket->name);
> +       if (err < 0) {
> +               ret = err;
> +               goto disable;
> +       }
>
>        socket->base = ioremap(start, len);
> -       if (socket->base == NULL)
> -               return -ENODEV;
> +       if (socket->base == NULL) {
> +               ret = -ENODEV;
> +               goto release;
> +       }
>
>        socket->dev = dev;
>
>        socket->pcmcia_socket = pcmcia_register_socket(slot, &cardu_operations, 1);
>        if (socket->pcmcia_socket == NULL) {
> -               iounmap(socket->base);
> -               socket->base = NULL;
> -               return -ENOMEM;
> +               ret =  -ENOMEM;
> +               goto unmap;
>        }
>
>        if (request_irq(dev->irq, cardu_interrupt, IRQF_SHARED, socket->name, socket) < 0) {
> -               pcmcia_unregister_socket(socket->pcmcia_socket);
> -               socket->pcmcia_socket = NULL;
> -               iounmap(socket->base);
> -               socket->base = NULL;
> -               return -EBUSY;
> +               ret = -EBUSY;
> +               goto unregister;
>        }
>
>        printk(KERN_INFO "%s at %#08lx, IRQ %d\n", socket->name, start, dev->irq);
>
>        return 0;
> +
> +unregister:
> +       pcmcia_unregister_socket(socket->pcmcia_socket);
> +       socket->pcmcia_socket = NULL;
> +unmap:
> +       iounmap(socket->base);
> +       socket->base = NULL;
> +release:
> +       pci_release_regions(dev);
> +disable:
> +       pci_disable_device(dev);
> +       return ret;
>  }
>
>  static int __devinit vrc4173_cardu_setup(char *options)
> --
> 1.7.2.3
>
>
