Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2GEIJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:09:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2GEIJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:09:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 RESEND] mm: cma: add a simple kernel module as the helper to test CMA
Date: Thu, 5 Jul 2012 08:09:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Barry Song <Barry.Song@csr.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, workgroup.linux@csr.com,
        mina86@mina86.com, Barry Song <Baohua.Song@csr.com>
References: <1341469459-29558-1-git-send-email-Barry.Song@csr.com>
In-Reply-To: <1341469459-29558-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207050809.15834.arnd@arndb.de>
X-Provags-ID: V02:K0:5cjBqW5MlHp4pzizg1IeEor5OgR7tul6U0znm1Y3VK6
 1cFg2rhO15Se7H8ru1ltMLvSVbnIcMK0wBVJgJUbAJj93Yp/vc
 dw9fznTPgmzG0pixw0HsQu5GOqi5J+eJueqAYU9F5zdFuTi06M
 pPT3ab+zdg2pzgBEywmjINtUhgG96RUCDJ6IukTrr9hRiCQ+M1
 sHzJl+ghA19k882w29ZJb8jRsgV4+g7WaSl0VouWlwPVDTyFPi
 tYoNX1vqYI6I2KMMznjO+CcZtXdnluGjGnrC1Eda1HMtrFjKDR
 z9TvAQGCxfKwGPuuotQVBQiL8rm9sjBlLR6skxfta99fB8ss6k
 TFH9iNLdvt01qzOS8UBQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012, Barry Song wrote:
> From: Barry Song <Baohua.Song@csr.com>
> 
> Any write request to /dev/cma_test will let the module to allocate memory from
> CMA, for example:
> 
> 1st time
> $ echo 1024 > /dev/cma_test
> will require cma_test to request 1MB(1024KB)
> 2nd time
> $ echo 2048 > /dev/cma_test
> will require cma_test to request 2MB(2048KB)
> 
> Any read request to /dev/cma_test will let the module to free the 1st valid
> memory from CMA, for example:
> 
> 1st time
> $ cat /dev/cma_test
> will require cma_test to free the 1MB allocated in the first write request
> 2nd time
> $ cat /dev/cma_test
> will require cma_test to free the 2MB allocated in the second write request

I missed the earlier times this was posted and read up on it now.

> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  resend to Greg KH so that he can decide whether it should be placed at tools
>  or drivers/misc;
>  See the discussion thread:
>  [1] https://lkml.org/lkml/2012/7/3/80
>  [2] https://lkml.org/lkml/2012/7/3/224
>  [3] https://lkml.org/lkml/2012/7/4/87

I think it should be in mm/cma-test.c, along with kmemleak-test.c. It would be nice
if you could add some code that just runs at boot time (or when the module is
loaded) and allocates and frees memory using CMA.

> +static struct device *cma_dev;

Do you actually need this device? It's not connected to hardware so
it doesn't actually do DMA and we might as well pass a NULL pointer
into dma_alloc_*().

> +static const struct file_operations cma_test_fops = {
> +	.owner =    THIS_MODULE,
> +	.read  =    cma_test_read,
> +	.write =    cma_test_write,
> +};
> +
> +static struct miscdevice cma_test_misc = {
> +	.name = "cma_test",
> +	.fops = &cma_test_fops,
> +};
> +
> +static int __init cma_test_init(void)
> +{
> +	int ret = misc_register(&cma_test_misc);

A better place for this is really debugfs. The driver is not meant as a stable
kernel interface that applications can rely on, it's purely a debugging help.

Just make this

	ret = debugfs_create_file("cma-test", 0600, NULL, NULL, &cma_test_fops);



	Arnd
