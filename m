Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750Ab1ETMVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:21:35 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:52123 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935420Ab1ETMVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:21:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJVc1k1R8tSW/2dsb2JhbACmG3jEHw6GCwSXPIdM
Date: Fri, 20 May 2011 14:21:29 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup pc87413 watchdog driver to use
	request_muxed_region for SuperIO area
Message-ID: <20110520122129.GT17887@infomag.iguana.be>
References: <20110414190238.GI4835@earth.li> <20110430182512.GK4835@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430182512.GK4835@earth.li>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

> > @@ -528,7 +511,8 @@ static int __init pc87413_init(void)
> >  	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
> >  							WDT_INDEX_IO_PORT);
> >  
> > -	/* request_region(io, 2, "pc87413"); */
> > +	if (!request_muxed_region(io, 2, MODNAME))
> > +		return -EBUSY;
> >  
> >  	ret = register_reboot_notifier(&pc87413_notifier);
> >  	if (ret != 0) {
> > @@ -541,12 +525,32 @@ static int __init pc87413_init(void)
> >  		printk(KERN_ERR PFX
> >  			"cannot register miscdev on minor=%d (err=%d)\n",
> >  			WATCHDOG_MINOR, ret);
> > -		unregister_reboot_notifier(&pc87413_notifier);
> > -		return ret;
> > +		goto reboot_unreg;
> >  	}
> >  	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
> > +
> > +	pc87413_select_wdt_out();
> > +	pc87413_enable_swc();
> > +	pc87413_get_swc_base_addr();
> > +
> > +	if (!request_region(swc_base_addr, 0x20, MODNAME)) {
> > +		printk(KERN_ERR PFX
> > +			"cannot request SWC region at 0x%x\n", swc_base_addr);
> > +		ret = -EBUSY;
> > +		goto misc_unreg;
> > +	}
> > +
> >  	pc87413_enable();
> > +
> > +	release_region(io, 2);
> >  	return 0;
> > +
> > +misc_unreg:
> > +	misc_deregister(&pc87413_miscdev);
> > +reboot_unreg:
> > +	unregister_reboot_notifier(&pc87413_notifier);
> > +	release_region(io, 2);
> > +	return ret;
> >  }
> >  
> >  /**
> > @@ -569,7 +573,7 @@ static void __exit pc87413_exit(void)
> >  
> >  	misc_deregister(&pc87413_miscdev);
> >  	unregister_reboot_notifier(&pc87413_notifier);
> > -	/* release_region(io, 2); */
> > +	release_region(swc_base_addr, 0x20);
> >  
> >  	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
> >  }

I don't think this is the correct way to do this. You do the request_muxed_region only at init and exit of the module.
This means that other functions can't access the I/O controller as long as the module is loaded.
You should only use it when accessing the LPC...

Kind regards,
Wim.

