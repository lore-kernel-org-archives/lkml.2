Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1BAM7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:59:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34664 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BAM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:59:33 -0500
Date: Tue, 1 Feb 2011 12:59:21 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Pavel Machek <pma@sysgo.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, cko@sysgo.com,
        linux@dominikbrodowski.net, eric.miao@marvell.com
Subject: Re: pcmcia vs. MECR on pxa25x/sa1111
Message-ID: <20110201125921.GA7984@flint.arm.linux.org.uk>
References: <20110201120303.GA30464@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201120303.GA30464@pma.sysgo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:03:03PM +0100, Pavel Machek wrote:
> 
> After 2.6.34 changes, __pxa2xx_drv_pcmcia_probe() was replaced by
> sa1111_pcmcia_add(). That unfortunately means that configure_sockets()
> is not called, leading to MECR not being set properly, leading to
> strange crashes.
> 
> Tested on pxa255+sa1111, I do not have lubbock board nearby. Perhaps
> cleaner solution exists?
> 
> Signed-off-by: Pavel Machek <pma@sysgo.com>
> 
> 
> --- a/drivers/pcmcia/pxa2xx_base.c
> +++ b/drivers/pcmcia/pxa2xx_base.c
> @@ -204,10 +204,10 @@ pxa2xx_pcmcia_frequency_change(struct soc_pcmcia_socket *skt,
>  }
>  #endif
>  
> -static void pxa2xx_configure_sockets(struct device *dev)
> +void pxa2xx_configure_sockets(struct device *dev)
>  {
>  	struct pcmcia_low_level *ops = dev->platform_data;
>  
>  	/*
>  	 * We have at least one socket, so set MECR:CIT
>  	 * (Card Is There)
> diff --git a/drivers/pcmcia/pxa2xx_lubbock.c b/drivers/pcmcia/pxa2xx_lubbock.c
> --- a/drivers/pcmcia/pxa2xx_lubbock.c
> +++ b/drivers/pcmcia/pxa2xx_lubbock.c
> @@ -209,6 +209,8 @@ static struct pcmcia_low_level lubbock_pcmcia_ops = {
>  
>  #include "pxa2xx_base.h"
>  
> +extern void pxa2xx_configure_sockets(struct device *dev);
> +

Please put function prototypes in header files.

>  int pcmcia_lubbock_init(struct sa1111_dev *sadev)
>  {
>  	int ret = -ENODEV;
> @@ -228,6 +230,7 @@ int pcmcia_lubbock_init(struct sa1111_dev *sadev)
>  		pxa2xx_drv_pcmcia_ops(&lubbock_pcmcia_ops);
>  		ret = sa1111_pcmcia_add(sadev, &lubbock_pcmcia_ops,
>  				pxa2xx_drv_pcmcia_add_one);
> +		pxa2xx_configure_sockets(&(sadev->dev));

Additional parens not required.

While making this a visible function, it may also make sense to
change it from taking a struct device pointer to taking the
struct pcmcia_low_level pointer which is really what its after.

Lastly the ordering of pxa2xx_configure_sockets() is wrong - doing
setup after adding sockets is racy.  That's probably something which
should fixed in the pxa2xx code too.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
