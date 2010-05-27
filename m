Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0E0Hyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 03:54:55 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:39322 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0E0Hyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 03:54:53 -0400
Message-ID: <4BFE2549.4000403@ge.com>
Date: Thu, 27 May 2010 08:54:49 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 16/17] drivers/staging/vme/bridges: Add missing unlocks
References: <Pine.LNX.4.64.1005261758540.23743@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005261758540.23743@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Add a spin_unlock and mutex_unlock missing on the error path.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression E1;
> @@
>
> * spin_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * spin_unlock(E1,...);
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>   

Good catch.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>


> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 0c82eb4..f38f7b7 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -900,7 +900,8 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
>  	/* Address must be 4-byte aligned */
>  	if (pci_addr & 0x3) {
>  		dev_err(dev, "RMW Address not 4-byte aligned\n");
> -		return -EINVAL;
> +		result = -EINVAL;
> +		goto out;
>  	}
>  
>  	/* Ensure RMW Disabled whilst configuring */
> @@ -921,6 +922,7 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
>  	/* Disable RMW */
>  	iowrite32(0, bridge->base + SCYC_CTL);
>  
> +out:
>  	spin_unlock(&(image->lock));
>  
>  	mutex_unlock(&(bridge->vme_rmw));
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

