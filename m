Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0KIJbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:31:35 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:12992 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0KIJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:31:31 -0500
Date: Tue, 9 Nov 2010 10:31:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jim Cromie <jim.cromie@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/32] drivers/hwmon/pc87360.c: Use pr_fmt and
 pr_<level>
Message-ID: <20101109103119.4cb66327@endymion.delvare>
In-Reply-To: <190459d6c56001d564155d8a73ee8e47024b6149.1287556801.git.joe@perches.com>
References: <20101020035346.GA20178@ericsson.com>
	<190459d6c56001d564155d8a73ee8e47024b6149.1287556801.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 19 Oct 2010 23:51:43 -0700, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/pc87360.c |   32 +++++++++++++-------------------
>  1 files changed, 13 insertions(+), 19 deletions(-)


The following is left in the driver:


#ifdef DEBUG
			printk(KERN_DEBUG "pc87360: Fan 1: mon=%d "
			       "ctrl=%d inv=%d\n", (confreg[0]>>2)&1,
			       (confreg[0]>>3)&1, (confreg[0]>>4)&1);
			printk(KERN_DEBUG "pc87360: Fan 2: mon=%d "
			       "ctrl=%d inv=%d\n", (confreg[0]>>5)&1,
			       (confreg[0]>>6)&1, (confreg[0]>>7)&1);
			printk(KERN_DEBUG "pc87360: Fan 3: mon=%d "
			       "ctrl=%d inv=%d\n", confreg[1]&1,
			       (confreg[1]>>1)&1, (confreg[1]>>2)&1);
#endif

Is there any reason why you didn't convert these to pr_debug()?

> 
> diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
> index 68e69a4..f8459a9 100644
> --- a/drivers/hwmon/pc87360.c
> +++ b/drivers/hwmon/pc87360.c
> @@ -33,6 +33,8 @@
>   *  the standard Super-I/O addresses is used (0x2E/0x2F or 0x4E/0x4F).
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> @@ -1031,16 +1033,15 @@ static int __init pc87360_find(int sioaddr, u8 *devid, unsigned short *addresses
>  
>  		val = superio_inb(sioaddr, ACT);
>  		if (!(val & 0x01)) {
> -			printk(KERN_INFO "pc87360: Device 0x%02x not "
> -			       "activated\n", logdev[i]);
> +			pr_info("Device 0x%02x not activated\n", logdev[i]);
>  			continue;
>  		}
>  
>  		val = (superio_inb(sioaddr, BASE) << 8)
>  		    | superio_inb(sioaddr, BASE + 1);
>  		if (!val) {
> -			printk(KERN_INFO "pc87360: Base address not set for "
> -			       "device 0x%02x\n", logdev[i]);
> +			pr_info("Base address not set for device 0x%02x\n",
> +				logdev[i]);
>  			continue;
>  		}
>  
> @@ -1071,14 +1072,11 @@ static int __init pc87360_find(int sioaddr, u8 *devid, unsigned short *addresses
>  				confreg[3] = superio_inb(sioaddr, 0x25);
>  
>  				if (confreg[2] & 0x40) {
> -					printk(KERN_INFO "pc87360: Using "
> -					       "thermistors for temperature "
> -					       "monitoring\n");
> +					pr_info("Using thermistors for temperature monitoring\n");

I know checkpatch.pl no longer complains about long lines when they
include a string, but 98 columns seems excessive to me. It would be
easy enough to spread over two lines.

>  				}
>  				if (confreg[3] & 0xE0) {
> -					printk(KERN_INFO "pc87360: VID "
> -					       "inputs routed (mode %u)\n",
> -					       confreg[3] >> 5);
> +					pr_info("VID inputs routed (mode %u)\n",
> +						confreg[3] >> 5);
>  				}
>  			}
>  		}
> @@ -1616,7 +1614,7 @@ static int __init pc87360_device_add(unsigned short address)
>  	pdev = platform_device_alloc("pc87360", address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> -		printk(KERN_ERR "pc87360: Device allocation failed\n");
> +		pr_err("Device allocation failed\n");
>  		goto exit;
>  	}
>  
> @@ -1639,15 +1637,13 @@ static int __init pc87360_device_add(unsigned short address)
>  
>  	err = platform_device_add_resources(pdev, res, res_count);
>  	if (err) {
> -		printk(KERN_ERR "pc87360: Device resources addition failed "
> -		       "(%d)\n", err);
> +		pr_err("Device resources addition failed (%d)\n", err);
>  		goto exit_device_put;
>  	}
>  
>  	err = platform_device_add(pdev);
>  	if (err) {
> -		printk(KERN_ERR "pc87360: Device addition failed (%d)\n",
> -		       err);
> +		pr_err("Device addition failed (%d)\n", err);
>  		goto exit_device_put;
>  	}
>  
> @@ -1666,8 +1662,7 @@ static int __init pc87360_init(void)
>  
>  	if (pc87360_find(0x2e, &devid, extra_isa)
>  	 && pc87360_find(0x4e, &devid, extra_isa)) {
> -		printk(KERN_WARNING "pc87360: PC8736x not detected, "
> -		       "module not inserted.\n");
> +		pr_warn("PC8736x not detected, module not inserted\n");
>  		return -ENODEV;
>  	}
>  
> @@ -1680,8 +1675,7 @@ static int __init pc87360_init(void)
>  	}
>  
>  	if (address == 0x0000) {
> -		printk(KERN_WARNING "pc87360: No active logical device, "
> -		       "module not inserted.\n");
> +		pr_warn("No active logical device, module not inserted\n");
>  		return -ENODEV;
>  	}
>  


-- 
Jean Delvare
