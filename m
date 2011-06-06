Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab1FFQCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:02:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49659 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab1FFQCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cqc53SDuzkeCp90ixM242RwjR9g2gvRuDpSGSQAycrpOvxLqTSFcoG6y9OHzfo0lEi
         j0nDGwzHeETiEvRt0AyTLksv73siO5Gsin9w41Azrx8/gllAgxrbbuOmHksegzfcpGnq
         /mlSGCOFnpzd/TpAS0Y0N0tV6H+wBLn9KrEZY=
MIME-Version: 1.0
In-Reply-To: <4DE10B4D.50501@gmail.com>
References: <4DE0B9D8.3020405@gmail.com>
	<4DE10B4D.50501@gmail.com>
Date: Tue, 7 Jun 2011 00:02:44 +0800
Message-ID: <BANLkTimbZ75=XeaNrZQJD0OihEmMMt_5tQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] ramoops: use module parameters instead of platform
 data if not available
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        stevie.trujillo@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 10:48 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> Use generic module parameters instead of platform data, if platform
> data are not available. This limitation has been introduced with
> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
> ---
> ChangeLog
> v2: fixed tab/space problem
>
> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
> index 1a9f5f6..bf5f9f6 100644
> --- a/drivers/char/ramoops.c
> +++ b/drivers/char/ramoops.c
> @@ -26,6 +26,7 @@
>  #include <linux/io.h>
>  #include <linux/ioport.h>
>  #include <linux/platform_device.h>
> +#include <linux/slab.h>
>  #include <linux/ramoops.h>
>
>  #define RAMOOPS_KERNMSG_HDR "===="
> @@ -56,6 +57,9 @@ static struct ramoops_context {
>        int max_count;
>  } oops_cxt;
>
> +static struct platform_device *dummy;
> +static struct ramoops_platform_data *dummy_data;
> +
>  static void ramoops_do_dump(struct kmsg_dumper *dumper,
>                enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
>                const char *s2, unsigned long l2)
> @@ -106,27 +110,22 @@ static int __init ramoops_probe(struct platform_device *pdev)
>        struct ramoops_context *cxt = &oops_cxt;
>        int err = -EINVAL;
>
> -       if (pdata) {
> -               mem_size = pdata->mem_size;
> -               mem_address = pdata->mem_address;
> -       }
> -
> -       if (!mem_size) {
> +       if (!pdata->mem_size) {
>                printk(KERN_ERR "ramoops: invalid size specification");
>                goto fail3;
>        }
>
> -       rounddown_pow_of_two(mem_size);
> +       rounddown_pow_of_two(pdata->mem_size);
>
> -       if (mem_size < RECORD_SIZE) {
> +       if (pdata->mem_size < RECORD_SIZE) {
>                printk(KERN_ERR "ramoops: size too small");
>                goto fail3;
>        }
>
> -       cxt->max_count = mem_size / RECORD_SIZE;
> +       cxt->max_count = pdata->mem_size / RECORD_SIZE;
>        cxt->count = 0;
> -       cxt->size = mem_size;
> -       cxt->phys_addr = mem_address;
> +       cxt->size = pdata->mem_size;
> +       cxt->phys_addr = pdata->mem_address;
>
>        if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
>                printk(KERN_ERR "ramoops: request mem region failed");
> @@ -179,12 +178,35 @@ static struct platform_driver ramoops_driver = {
>
>  static int __init ramoops_init(void)
>  {
> -       return platform_driver_probe(&ramoops_driver, ramoops_probe);
> +       int ret;
> +       ret = platform_driver_probe(&ramoops_driver, ramoops_probe);
> +       if (ret == -ENODEV)
> +       {


Wrong coding style...

> +               /*
> +                * if we didn't find a platform device, we use module parameters
> +                * building platform data on the fly.
> +                */
> +               dummy_data = (struct ramoops_platform_data *)
> +                    kzalloc(sizeof(struct ramoops_platform_data), GFP_KERNEL);

Please check the return value of kzalloc(), and, you don't need to
cast it.

> +               dummy_data->mem_size = mem_size;
> +               dummy_data->mem_address = mem_address;
> +               dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
> +                       NULL, 0, dummy_data,
> +                       sizeof(struct ramoops_platform_data));
> +
> +               if (IS_ERR(dummy))
> +                       ret = PTR_ERR(dummy);
> +               else
> +                       ret = 0;
> +       }
> +
> +       return ret;
>  }
>
>  static void __exit ramoops_exit(void)
>  {
>        platform_driver_unregister(&ramoops_driver);
> +       kfree(dummy_data);
>  }
>
>  module_init(ramoops_init);
>
>
