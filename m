Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1HDUZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:25:42 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:21681 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604Ab1HDUZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:25:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJr+Ok5R8j0b/2dsb2JhbAA6CadpeIFAAQEFJxMcIxAIA0YUJQMhLodTwUsOgxeDHQSjYQ
Date: Thu, 4 Aug 2011 22:25:33 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
	framework
Message-ID: <20110804202533.GV4227@infomag.iguana.be>
References: <1310392522-9949-1-git-send-email-wim@iguana.be> <4E1B8089.90103@metafoo.de> <20110722193211.GL31767@infomag.iguana.be> <4E2B987E.6070107@metafoo.de> <20110727202450.GB4227@infomag.iguana.be> <4E327C50.2010103@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E327C50.2010103@metafoo.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

> >>>>> +int watchdog_dev_unregister(struct watchdog_device *watchdog)
> >>>>> +{
> >>>>> +	/* Check that a watchdog device was registered in the past */
> >>>>> +	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
> >>>>> +		return -ENODEV;
> >>>>> +
> >>>>> +	/* We can only unregister the watchdog device that was registered */
> >>>>> +	if (watchdog != wdd) {
> >>>>> +		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
> >>>>> +			watchdog->info->identity);
> >>>>> +		return -ENODEV;
> >>>>> +	}
> >>>>> +
> >>>>> +	/* Unregister the miscdevice */
> >>>>> +	misc_deregister(&watchdog_miscdev);
> >>>>> +	wdd = NULL;
> >>>>> +	clear_bit(0, &watchdog_dev_busy);
> >>>>> +	return 0;
> >>>>> +}
> >>>>
> >>>> What happens if the watchdog gets unregistered if the device is still opened?
> >>>> Even though if you'd check wdd for not being NULL in the file callbacks there
> >>>> is still a chance for races if the devices is unregistered at the same time as
> >>>> the callback is running. You'd either need a big lock to protect from having a
> >>>> file callback and unregister running concurrently or add ref-counting to the
> >>>> watchdog_device, the later best done by embedding a struct device and using the
> >>>> device driver model.
> >>>
> >>> You cannot unload the watchdog-drivers module if /dev/watchdog is still open.
> >>> So if the watchdog_unregister function is in the exit function of the module
> >>> then we are safe. But I think you have a point if that is not the case.
> >>> Solution would be to return an error when the watchdog_unregister_device routine
> >>> is called and the WDOG_DEV_OPEN bit is set. Will create an extra patch for that.
> >>>
> >>
> >> The problem is, that this doesn't fit nicely into the linux device driver
> >> model, because it doesn't allow the removal of a device to fail. So you'll
> >> still end of with undefined behavior.
> > 
> > It's not an issue now. But we will indeed have to tackle it, when we start using
> > the device driver model.
> > 
> 
> Well, the framework itself might not be using the device driver model yet, but
> drivers using the framework do. For example for a driver using a platform
> device there would be no correct solution for handling an error from
> watchdog_unregister in the drivers remove callback.

That is correct. we have nothing for handling the error. So I didn't introduce
a fix for it neither. What I wanted to tell was:
* a driver now registers a miscdevice in its init function and deregisters it
during the exit function. You cannot unload the module as long as the miscdevice
for the watchdog is open.
* a driver that uses the core will register the watchdog device during init and
will only unregister it during exit. Because we prevent the driver of being
unloaded (via try_module_get and module_put), you cannot unload the module as
long as /dev/watchdog is open. So the unregister will not take place.

So in it's current form, we still have no issue.

Kind regards,
Wim.


