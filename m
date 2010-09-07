Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0IGUsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:48:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17762 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0IGUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:48:09 -0400
Date: Tue, 7 Sep 2010 13:46:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: david.cross@cypress.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, device modules fixes
Message-Id: <20100907134644.751ddc7e.randy.dunlap@oracle.com>
In-Reply-To: <1283888414.7250.24.camel@odc-laptop>
References: <1283888414.7250.24.camel@odc-laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 12:40:14 -0700 David Cross wrote:

> This patch makes minor fixes to the device module for locking issues,
> as well as some changes for the HAL/Kconfig changes made in a separate
> patch. Please let me know if there are issues or concerns with this
> patch.
> Thanks,
> David
> 
> Signed-off-by: David Cross <david.cross@cypress.com>
> 
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/device/cyasdevice.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/device/cyasdevice.c	2010-09-07 11:32:36.000000000 -0700
> @@ -48,6 +48,8 @@ typedef struct cyasdevice {
>  		cy_as_device_handle			dev_handle;
>  		/* Handle to the HAL */
>  		cy_as_hal_device_tag			hal_tag;
> +		spinlock_t	  common_lock;
> +		unsigned long flags;
>  } cyasdevice ;

No space before the ';'.  (in many many places & in other patches)


>  
>  /* global ptr to astoria device */
> @@ -81,13 +83,19 @@ static void cyasdevice_deinit(cyasdevice
>  
>  	if (cy_as_dev->hal_tag) {
>  
> - #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
> -		if (stop_o_m_a_p_kernel(dev_handle_name,
> +	#ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL

It's better _not_ to indent the #ifdef and #endif lines.
Indenting them obscures them, and that's not good.


> +		if (cy_as_hal_omap_pnand_stop(dev_handle_name,
>  			cy_as_dev->hal_tag) != 0)
>  			cy_as_hal_print_message("<1>_cy_as_device: stopping "
> -				"OMAP kernel HAL failed\n");
> +				"OMAP PNAND HAL failed\n");
> +	#endif
>  
> - #endif
> +	#ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_CRAM_HAL
> +		if (cy_as_hal_omap_cram_stop(dev_handle_name,
> +			cy_as_dev->hal_tag) != 0)
> +			cy_as_hal_print_message("<1>_cy_as_device: stopping "
> +				"OMAP CRAM HAL failed\n");
> +	#endif
>  	}
>  	cy_as_hal_print_message("<1>_cy_as_device:HAL layer stopped\n") ;
>  
> @@ -126,6 +134,28 @@ static void cy_misc_callback(cy_as_devic
>  	}
>  }
>  
> +void cy_as_acquire_common_lock()
> +{
> +	/*printk("%s: lock address is 0x%x, is_locked=0x%x\n", __func__,
> +		&cy_as_device_controller->common_lock,
> +		spin_is_locked(&cy_as_device_controller->common_lock));*/
> +	spin_lock_irqsave(&cy_as_device_controller->common_lock,
> +		cy_as_device_controller->flags);/*
> +		printk("%s: -- is_locked=0x%x\n", __func__,
> +		spin_is_locked(&cy_as_device_controller->common_lock));*/

The printk line should not be indented.

> +}
> +EXPORT_SYMBOL(cy_as_acquire_common_lock);
> +
> +void cy_as_release_common_lock()
> +{
> +	/*printk("%s: lock address is 0x%x, is_locked=0x%x\n", __func__,
> +		&cy_as_device_controller->common_lock,
> +		spin_is_locked(&cy_as_device_controller->common_lock));*/
> +	spin_unlock_irqrestore(&cy_as_device_controller->common_lock,
> +	cy_as_device_controller->flags);

The line above should be indented more than the line above it.

> +}
> +EXPORT_SYMBOL(cy_as_release_common_lock);
> +
>  /* reset astoria and reinit all regs */
>   #define PNAND_REG_CFG_INIT_VAL 0x0000
>  void  hal_reset(cy_as_hal_device_tag tag)



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
