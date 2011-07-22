Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1GVTcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:32:14 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:46557 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166Ab1GVTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:32:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOrOKU5tgwKe/2dsb2JhbABGDadKeIh8Ars+DoMWgxsEo08
Date: Fri, 22 Jul 2011 21:32:11 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
	framework
Message-ID: <20110722193211.GL31767@infomag.iguana.be>
References: <1310392522-9949-1-git-send-email-wim@iguana.be> <4E1B8089.90103@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1B8089.90103@metafoo.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

> On 07/11/2011 04:19 PM, Wim Van Sebroeck wrote:
> > [...]
> > +
> > +
> > +static int watchdog_release(struct inode *inode, struct file *file)
> > +{
> > +	int err;
> > +
> > +	/* stop the watchdog */
> > +	err = wdd->ops->stop(wdd);
> Does it really make sense to allow stop() to fail? Will this ever happen, and
> if yes do we gain anything by sending a additional ping?

It buys user-space extra time to recover if necessary.

> > [...]
> > +
> > +int watchdog_dev_unregister(struct watchdog_device *watchdog)
> > +{
> > +	/* Check that a watchdog device was registered in the past */
> > +	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
> > +		return -ENODEV;
> > +
> > +	/* We can only unregister the watchdog device that was registered */
> > +	if (watchdog != wdd) {
> > +		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
> > +			watchdog->info->identity);
> > +		return -ENODEV;
> > +	}
> > +
> > +	/* Unregister the miscdevice */
> > +	misc_deregister(&watchdog_miscdev);
> > +	wdd = NULL;
> > +	clear_bit(0, &watchdog_dev_busy);
> > +	return 0;
> > +}
> 
> What happens if the watchdog gets unregistered if the device is still opened?
> Even though if you'd check wdd for not being NULL in the file callbacks there
> is still a chance for races if the devices is unregistered at the same time as
> the callback is running. You'd either need a big lock to protect from having a
> file callback and unregister running concurrently or add ref-counting to the
> watchdog_device, the later best done by embedding a struct device and using the
> device driver model.

You cannot unload the watchdog-drivers module if /dev/watchdog is still open.
So if the watchdog_unregister function is in the exit function of the module
then we are safe. But I think you have a point if that is not the case.
Solution would be to return an error when the watchdog_unregister_device routine
is called and the WDOG_DEV_OPEN bit is set. Will create an extra patch for that.

> > [...]
> >  
> > +struct watchdog_ops;
> > +struct watchdog_device;
> > +
> > +/* The watchdog-devices operations */
> > +struct watchdog_ops {
> > +	struct module *owner;
> > +	/* mandatory operations */
> > +	int (*start)(struct watchdog_device *);
> > +	int (*stop)(struct watchdog_device *);
> > +	/* optional operations */
> > +	int (*ping)(struct watchdog_device *);
> > +};
> > +
> > +/* The structure that defines a watchdog device */
> > +struct watchdog_device {
> > +	const struct watchdog_info *info;
> > +	const struct watchdog_ops *ops;
> > +	void *priv;
> 
> You should provide getter/setter methods for priv, so that when the watchdog
> API is changed to make use of the device driver model it becomes easier to get
> rid of the priv field and use dev_{get,set}_drvdata instead.

Added.

> > +	unsigned long status;
> > +/* Bit numbers for status flags */
> > +#define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
> > +};
> 
> Kernel-doc style documentation for the structs would be nice.

Added.

Kind regards,
Wim.

