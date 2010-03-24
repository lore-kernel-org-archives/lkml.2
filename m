Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0CXMyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:54:33 -0400
Received: from bamako.nerim.net ([62.4.17.28]:57493 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab0CXMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:54:31 -0400
Date: Wed, 24 Mar 2010 13:54:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: properly acquire I/O regions while 
 probing
Message-ID: <20100324135429.0aa174e9@hyperion.delvare>
In-Reply-To: <20100324093437.GF6368@salidar.me.mortis.eu>
References: <1269353535-23134-1-git-send-email-me@mortis.eu>
	<20100324102942.215ee413@hyperion.delvare>
	<20100324093437.GF6368@salidar.me.mortis.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 10:34:37 +0100, Giel van Schijndel wrote:
> hwmon: f71882fg: acquire I/O regions while we're working with them
> 
> Acquire the I/O region for the Super I/O chip while we're working on it.
> 
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> ---
>  drivers/hwmon/f71882fg.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index ca34e5c..537841e 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -2178,6 +2178,13 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>  	int err = -ENODEV;
>  	u16 devid;
>  
> +	/* Don't step on other drivers' I/O space by accident */
> +	if (!request_region(sioaddr, 2, DRVNAME)) {
> +		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
> +				(int)sioaddr);
> +		return -EBUSY;
> +	}
> +
>  	superio_enter(sioaddr);
>  
>  	devid = superio_inw(sioaddr, SIO_REG_MANID);
> @@ -2232,6 +2239,7 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>  		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
>  exit:
>  	superio_exit(sioaddr);
> +	release_region(sioaddr, 2);
>  	return err;
>  }
>  

Applied, thanks.

-- 
Jean Delvare
