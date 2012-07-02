Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab2GBIk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:40:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:40170 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab2GBIk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:40:56 -0400
Message-ID: <4FF15E92.3040503@mev.co.uk>
Date: Mon, 2 Jul 2012 09:40:50 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging/comedi/drivers: release allocated I/O region
 if alloc_private fails
References: <1341149798-12695-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1341149798-12695-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-01 14:36, Devendra Naga wrote:
> if alloc_private fail, we wont' release the I/O region,
> which was request_region 'ed.
>
> release the allocated I/O region if alloc_private fails.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>   drivers/staging/comedi/drivers/fl512.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
> index d1da809..52e6d14 100644
> --- a/drivers/staging/comedi/drivers/fl512.c
> +++ b/drivers/staging/comedi/drivers/fl512.c
> @@ -125,8 +125,10 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>   	}
>   	dev->iobase = iobase;
>   	dev->board_name = "fl512";
> -	if (alloc_private(dev, sizeof(struct fl512_private)) < 0)
> +	if (alloc_private(dev, sizeof(struct fl512_private)) < 0) {
> +		release_region(iobase, FL512_SIZE);
>   		return -ENOMEM;
> +	}
>
>   #if DEBUG
>   	printk(KERN_DEBUG "malloc ok\n");

No.  The I/O region will be deallocated in fl512_detach() because 
dev->iobase has been set non-zero.  fl512_detach() will be called by the 
comedi core if fl512_attach() returns an error.  This is an unusual 
aspect of the comedi drivers.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
