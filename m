Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127Ab1ETQU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:20:56 -0400
Received: from the.earth.li ([46.43.34.31]:45532 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934520Ab1ETQUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:20:55 -0400
Date: Fri, 20 May 2011 09:20:54 -0700
From: Jonathan McDowell <noodles@earth.li>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup pc87413 watchdog driver to use
 request_muxed_region for SuperIO area
Message-ID: <20110520162054.GI28362@earth.li>
References: <20110414190238.GI4835@earth.li>
 <20110430182512.GK4835@earth.li>
 <20110520122129.GT17887@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520122129.GT17887@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 02:21:29PM +0200, Wim Van Sebroeck wrote:
> Hi Jonathan,
> 
> > > @@ -528,7 +511,8 @@ static int __init pc87413_init(void)
> > >  	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
> > >  							WDT_INDEX_IO_PORT);
> > >  
> > > -	/* request_region(io, 2, "pc87413"); */
> > > +	if (!request_muxed_region(io, 2, MODNAME))
> > > +		return -EBUSY;
> > >  
> > >  	ret = register_reboot_notifier(&pc87413_notifier);
> > >  	if (ret != 0) {
> > > @@ -541,12 +525,32 @@ static int __init pc87413_init(void)
> > >  		printk(KERN_ERR PFX
> > >  			"cannot register miscdev on minor=%d (err=%d)\n",
> > >  			WATCHDOG_MINOR, ret);
> > > -		unregister_reboot_notifier(&pc87413_notifier);
> > > -		return ret;
> > > +		goto reboot_unreg;
> > >  	}
> > >  	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
> > > +
> > > +	pc87413_select_wdt_out();
> > > +	pc87413_enable_swc();
> > > +	pc87413_get_swc_base_addr();
> > > +
> > > +	if (!request_region(swc_base_addr, 0x20, MODNAME)) {
> > > +		printk(KERN_ERR PFX
> > > +			"cannot request SWC region at 0x%x\n", swc_base_addr);
> > > +		ret = -EBUSY;
> > > +		goto misc_unreg;
> > > +	}
> > > +
> > >  	pc87413_enable();
> > > +
> > > +	release_region(io, 2);
> > >  	return 0;
> > > +
> > > +misc_unreg:
> > > +	misc_deregister(&pc87413_miscdev);
> > > +reboot_unreg:
> > > +	unregister_reboot_notifier(&pc87413_notifier);
> > > +	release_region(io, 2);
> > > +	return ret;
> > >  }
> > >  
> > >  /**
> > > @@ -569,7 +573,7 @@ static void __exit pc87413_exit(void)
> > >  
> > >  	misc_deregister(&pc87413_miscdev);
> > >  	unregister_reboot_notifier(&pc87413_notifier);
> > > -	/* release_region(io, 2); */
> > > +	release_region(swc_base_addr, 0x20);
> > >  
> > >  	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
> > >  }

> I don't think this is the correct way to do this. You do the
> request_muxed_region only at init and exit of the module.

I do a single request_muxed_region in the init function, and release it
at the end of the init function. It's only necessary to hold the LPC
region while the WDT functionality is enabled and the base address for
the SWC block is retrieved.

After that point all access is via the SWC region, so there's no need to
call request_muxed_region. The call in the exit function releases the
SWC block. We're not holding the LPC region for the entire duration of
the driver being loaded.

J.

-- 
  Hail Eris. All hail Discordia.   |  .''`.  Debian GNU/Linux Developer
              Fnord?               | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
