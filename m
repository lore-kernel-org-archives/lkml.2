Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2GBIpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:45:52 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:40189 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2GBIpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:45:47 -0400
Message-ID: <4FF15FAB.9050905@mev.co.uk>
Date: Mon, 2 Jul 2012 09:45:31 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/2] staging/comedi/drivers: free allocated priv and
 release resources if comedi_alloc_subdevices
References: <1341159624-23968-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1341159624-23968-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-01 17:20, Devendra Naga wrote:
> as comedi_alloc_subdevices may fail, we leak out the memory allocated by alloc_private,
> and also the I/O regions we requested.
>
> free out the private data pointer of the driver, and release the I/O regions
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>   drivers/staging/comedi/drivers/fl512.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
> index 52e6d14..1c372d1 100644
> --- a/drivers/staging/comedi/drivers/fl512.c
> +++ b/drivers/staging/comedi/drivers/fl512.c
> @@ -135,8 +135,11 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>   #endif
>
>   	ret = comedi_alloc_subdevices(dev, 2);
> -	if (ret)
> +	if (ret) {
> +		kfree(dev->private);
> +		release_region(iobase, FL512_SIZE);
>   		return ret;
> +	}
>
>   	/*
>   	 * this if the definitions of the supdevices, 2 have been defined
>

As mentioned in my comment for your PATCH 1/2, this is unneccessary.  In 
fact it will resuly in dev->private being freed twice and the I/O region 
being released twice due to clean-up in the comedi core when 
fl512_attach() returns an error, which will also call fl512_detach() 
during the clean-up.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


