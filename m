Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0JDKqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:46:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61612 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0JDKqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:46:06 -0400
Message-ID: <4CA9B004.3020103@ru.mvista.com>
Date: Mon, 04 Oct 2010 14:44:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Rahul Ruikar <rahul.ruikar@gmail.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
References: <1286113750-2607-1-git-send-email-rahul.ruikar@gmail.com>
In-Reply-To: <1286113750-2607-1-git-send-email-rahul.ruikar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-10-2010 17:49, Rahul Ruikar wrote:

> - call device_unregister() only when device_register() is sucess.

    s/is sucess/succeeds/

> - call put_device() when device_register() fails.

> Signed-off-by: Rahul Ruikar<rahul.ruikar@gmail.com>
> ---
>   drivers/usb/gadget/langwell_udc.c |   18 ++++++++++++++----
>   drivers/usb/gadget/langwell_udc.h |    4 +++-
>   2 files changed, 17 insertions(+), 5 deletions(-)

> diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
> index c2d2a20..2b5ae16 100644
> --- a/drivers/usb/gadget/langwell_udc.c
> +++ b/drivers/usb/gadget/langwell_udc.c
> @@ -2952,8 +2952,13 @@ static void langwell_udc_remove(struct pci_dev *pdev)
>   	INFO(dev, "unbind\n");
>   	DBG(dev, "<--- %s()\n", __func__);
>
> -	device_unregister(&dev->gadget.dev);
> -	device_remove_file(&pdev->dev,&dev_attr_langwell_udc);
> +	if (dev->dev_reg_status == 2)
> +		device_unregister(&dev->gadget.dev);
> +	else if (dev->dev_reg_status == 1)
> +		put_device(&dev->gadget.dev);
> +
> +	if (dev->dev_create_file)
> +		device_remove_file(&pdev->dev,&dev_attr_langwell_udc);
>
>   #ifndef	OTG_TRANSCEIVER
>   	pci_set_drvdata(pdev, NULL);
> @@ -3190,12 +3195,17 @@ static int langwell_udc_probe(struct pci_dev *pdev,
>   	the_controller = dev;
>
>   	retval = device_register(&dev->gadget.dev);
> -	if (retval)
> +	if (retval) {
> +		dev_reg_status = 1;

    Did you mean 'dev->dev_reg_status'?

>   		goto error;
> +	}
> +	dev_reg_status = 2;

    Same question.

>
>   	retval = device_create_file(&pdev->dev,&dev_attr_langwell_udc);
> -	if (retval)
> +	if (retval) {
> +		dev_create_file = 1;

    Did you mean 'dev->dev_create_file'?

WBR, Sergei
