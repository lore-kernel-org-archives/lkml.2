Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0JBHqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:46:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61221 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0JBHql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TXFkW6rTg+6EFrPsZZJvUgRXCQJlQlBsHdA4k7KEXifzaolhUXeSM2eIWWszHXUhOR
         G5NYW4N+KPM+OFzfVC3bwRW7W1FkZ1UjLOPTI9qM18kO+r9cKWl286mYPgI8Pks6NRIq
         0N8l1WnBLi5i9/rQRvU/OWrSj5iJ7i8T73KdU=
MIME-Version: 1.0
In-Reply-To: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com>
References: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com>
Date: Sat, 2 Oct 2010 15:45:50 +0800
Message-ID: <AANLkTi=8LGCVqchpQrB+31FRqK04+3xLFCuak0S1FHpK@mail.gmail.com>
Subject: Re: [PATCH] usb: core: endpoint: Fix error path
From: Ming Lei <tom.leiming@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/2 Rahul Ruikar <rahul.ruikar@gmail.com>:
> In function usb_create_ep_devs()
> call put_device() when device_register() fails.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/core/endpoint.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
> index 3788e73..cab126d 100644
> --- a/drivers/usb/core/endpoint.c
> +++ b/drivers/usb/core/endpoint.c
> @@ -195,8 +195,10 @@ int usb_create_ep_devs(struct device *parent,
>        device_enable_async_suspend(&ep_dev->dev);
>
>        retval = device_register(&ep_dev->dev);
> -       if (retval)
> +       if (retval) {
> +               put_device(&ep_dev->dev);
>                goto error_register;
> +       }
>
>        endpoint->ep_dev = ep_dev;
>        return retval;
> --

You should replace kfree(ep_dev) with put_device(&ep_dev->dev),
otherwise double free will be triggered.

So you need to revise the patch...

-- 
Lei Ming
