Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab2LHLo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 06:44:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33552 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab2LHLo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 06:44:57 -0500
Date: Sat, 8 Dec 2012 12:44:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aaron Williams <Aaron.Williams@cavium.com>
Cc: linux-kernel@vger.kernel.org,
        "Williams, Aaron" <Aaron.Williams@caviumnetworks.com>
Subject: Re: Incrementing module reference count
Message-ID: <20121208114453.GC11662@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Aaron Williams <Aaron.Williams@cavium.com>,
	linux-kernel@vger.kernel.org,
	"Williams, Aaron" <Aaron.Williams@caviumnetworks.com>
References: <50C2947F.5030706@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C2947F.5030706@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:14:39PM -0800, Aaron Williams wrote:
> Hi,
> 
> I have a kernel module which other modules register with in order to
> export access functions. So far I have everything working but I want
> to prevent a module that is registered with my module from unloading
> since now my module is dependent on the other module.
> 
> Is there a way I can cause the reference count of the module
> registering with my module to increase? I tried calling get_device
> with the device structure of the module that is registering but that
> does not seem to work.
> 
> For example, I have the following function:
> 
> /**
>  * Adds a mapping of a device node to a memory accessor
>  *
>  * @param[in] dev - device
>  * @param[in] macc - memory accessor
>  *
>  * @returns 0 for success or -ENOMEM
>  */
> int of_memory_accessor_register(struct device *dev,
>                 struct memory_accessor *macc)
> {
>     struct of_macc_entry *mentry;
> 
>     mentry = kmalloc(sizeof(*mentry), GFP_KERNEL);
>     if (mentry == NULL)
>         return -ENOMEM;
> 
>     mentry->dev = dev;
>     mentry->macc = macc;
> 
>     mutex_lock(&lock);
> 
>     get_device(dev);
>     list_add(&(mentry->list), &macc_list);
> 
>     mutex_unlock(&lock);
> 
>     return 0;
> }
> EXPORT_SYMBOL(of_memory_accessor_register);
> 
> Basically my module is used for things like serial EEPROMs and
> whatnot so that external modules can find the accessor functions
> based on the device tree. In my case I am updating the Vitesse
> VSC848X driver so that it can read the SFP module when it is plugged
> in using the AT24 I2C EEPROM module. I want to prevent the at24
> module from unloading while other modules in turn are using it. The
> at24 module does not export any symbols.

>From a quick code scan, at24 has this:

	static struct i2c_driver at24_driver = {
	        .driver = {
	                .name = "at24",
	                .owner = THIS_MODULE,
	        },
	        .probe = at24_probe,
	        .remove = __devexit_p(at24_remove),
	        .id_table = at24_ids,
	};

and then you could do:

	try_module_get(at24_driver.driver->owner);

from your code. AFAICT, of course.

HTH.

-- 
Regards/Gruss,
    Boris.
