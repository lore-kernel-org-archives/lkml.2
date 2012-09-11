Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2IKItP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:49:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45834 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2IKItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:49:11 -0400
Date: Tue, 11 Sep 2012 11:48:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/20] Staging: ipack: Switch to 8MHz operation before
 reading ID.
Message-ID: <20120911084818.GP19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-8-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347267118-9580-8-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:51:46AM +0200, Samuel Iglesias Gonsálvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> Reading the ID space at 8 MHz is always supported.  Most carriers will
> boot up in 8MHz mode.  Still, play it safe and ensure we are operating at
> 8Mhz.
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/ipack.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
> index 4f3c945..95f56b8 100644
> --- a/drivers/staging/ipack/ipack.c
> +++ b/drivers/staging/ipack/ipack.c
> @@ -376,6 +376,9 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
>  	dev_set_name(&dev->dev,
>  		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
>  
> +	if (bus->ops->set_clockrate(dev, 8))
> +		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
> +
>  	ret = ipack_device_read_id(dev);
>  	if (ret < 0) {
>  		dev_err(&dev->dev, "error reading device id section.\n");
> @@ -384,9 +387,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
>  	}
>  
>  	/* if the device supports 32 MHz operation, use it. */
> -	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
> -	if (ret < 0)
> -		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> +	if (dev->speed_32mhz) {
> +		ret = bus->ops->set_clockrate(dev, 32);
> +		if (ret < 0)
> +			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> +	}

Ah.  Well done.  That's what I suggested earlier.  I think you
should get rid of the ->speed_8mhz all together.

regards,
dan carpenter

