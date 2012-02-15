Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2BOPhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:37:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2BOPg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:36:56 -0500
Message-ID: <4F3BD0E9.5070305@corscience.de>
Date: Wed, 15 Feb 2012 16:36:09 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120213 Thunderbird/10.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, zbr@ioremap.net
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix w1_bq27000
References: <20111230004947.11559.81184.stgit@notabene.brown> <20111230005849.11559.79397.stgit@notabene.brown>
In-Reply-To: <20111230005849.11559.79397.stgit@notabene.brown>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:y2ddRr/8pXd4u/7TCaCZhxxTgQDJN/wBxTfNKjVe+Kg
 DW2S/SaI0g+utOofuWN9Qb1fwj7ymKT3ADu4IpuxdltZJNq9YF
 9KDXcNPwEzOS0Y6yy+yRlo37IOTazA4ggRstVK94b7MW3yX0cq
 dq96HPg3K6IUI3yI5QiDVLGsnbwPI+IWZXkj5J6UzmGqXNJaEk
 VL5/a6dBL7rFKeAE27cZVaah2VSS4+PULCPMp0Ueve76G877sl
 CSy82tXgmEBq56T+z9oRFgqqiiZooVPNWllzY8Rh9w+GWFt9p4
 4AnNOwmOeuuaOoZUJQ6s7HClWfoE9qD6q7s5EjlzAOJDRb/Ss/
 j287Zr6ndUxm+8meV+Nw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Neil,

On 30.12.2011 01:58, NeilBrown wrote:
> w1_bq27000 adds a bq27000-battery platform device but does not provide
> platform data for it. This causes the bq27x00 driver to dereference a NULL
> pointer.
> So provide the appropriate platform data.  This requires modifying
> w1_bq27000_read so that it find the w1 device as the parent of the bq device.
> 
> Also there is no point exporting w1_bq27000_read as nothing else uses it
> or could use it.  So make it static.
> 
> Finally, as there is no way to track how many batteries have been found, and
> we will probably only find one, use an id number of '-1' to assert that this
> is a unique instance.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
> 
>  drivers/w1/slaves/w1_bq27000.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
> index 8f4c91f..8f10fd2 100644
> --- a/drivers/w1/slaves/w1_bq27000.c
> +++ b/drivers/w1/slaves/w1_bq27000.c
> @@ -15,6 +15,7 @@
>  #include <linux/types.h>
>  #include <linux/platform_device.h>
>  #include <linux/mutex.h>
> +#include <linux/power/bq27x00_battery.h>
>  
>  #include "../w1.h"
>  #include "../w1_int.h"
> @@ -39,10 +40,10 @@ void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
>  }
>  EXPORT_SYMBOL(w1_bq27000_write);
>  
> -int w1_bq27000_read(struct device *dev, u8 reg)
> +static int w1_bq27000_read(struct device *dev, unsigned int reg)
>  {
>  	u8 val;
> -	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
> +	struct w1_slave *sl = container_of(dev->parent, struct w1_slave, dev);
>  
>  	if (!dev)
>  		return 0;
> @@ -52,19 +53,25 @@ int w1_bq27000_read(struct device *dev, u8 reg)
>  
>  	return val;
>  }
> -EXPORT_SYMBOL(w1_bq27000_read);
> +
> +static struct bq27000_platform_data bq27000_battery_info = {
> +	.read   = w1_bq27000_read,
> +	.name   = "bq27000-battery",
> +};
>  
>  static int w1_bq27000_add_slave(struct w1_slave *sl)
>  {
>  	int ret;
> -	int id = 1;
>  	struct platform_device *pdev;
>  
> -	pdev = platform_device_alloc("bq27000-battery", id);
> +	pdev = platform_device_alloc("bq27000-battery", -1);
>  	if (!pdev) {
>  		ret = -ENOMEM;
>  		return ret;
>  	}
> +	ret = platform_device_add_data(pdev,
> +				       &bq27000_battery_info,
> +				       sizeof(bq27000_battery_info));
>  	pdev->dev.parent = &sl->dev;
>  
>  	ret = platform_device_add(pdev);
> 
> 

Tested-by: Thomas Weber <weber@corscience.de>

Thanks for the patch, now the platform data of the bq27000 are found.

before:

omap_hdq omap_hdq.0: OMAP HDQ Hardware Rev 0.5. Driver in Interrupt mode
w1_master_driver w1_bus_master1: Family 1 for 01.000000000000.3d is not
registered.
bq27000-battery bq27000-battery.1: no platform_data supplied
bq27000-battery: probe of bq27000-battery.1 failed with error -22

after:

omap_hdq omap_hdq.0: OMAP HDQ Hardware Rev 0.5. Driver in Interrupt mode
w1_master_driver w1_bus_master1: Family 1 for 01.000000000000.3d is not
registered.
bq27000-battery bq27000-battery: support ver. 1.2.0 enabled

Regards,
Thomas
