Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2JPQnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:43:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36409 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2JPQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:43:31 -0400
Date: Tue, 16 Oct 2012 09:43:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RFC 02/11 v4] gpio: Add sysfs support to block GPIO API
Message-ID: <20121016164326.GA4858@kroah.com>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
 <1350343887-7344-3-git-send-email-stigge@antcom.de>
 <20121015235720.GA3132@kroah.com>
 <507D58D9.2040607@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507D58D9.2040607@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:53:45PM +0200, Roland Stigge wrote:
> On 10/16/2012 01:57 AM, Greg KH wrote:
> > On Tue, Oct 16, 2012 at 01:31:18AM +0200, Roland Stigge wrote:
> >> +int gpio_block_export(struct gpio_block *block)
> >> +{
> >> +	int		status;
> >> +	struct device	*dev;
> >> +
> >> +	/* can't export until sysfs is available ... */
> >> +	if (!gpio_class.p) {
> >> +		pr_debug("%s: called too early!\n", __func__);
> >> +		return -ENOENT;
> >> +	}
> >> +
> >> +	mutex_lock(&sysfs_lock);
> >> +	dev = device_create(&gpio_class, NULL, MKDEV(0, 0), block,
> >> +			    block->name);
> >> +	if (!IS_ERR(dev))
> >> +		status = sysfs_create_group(&dev->kobj, &gpio_block_attr_group);
> >> +	else
> >> +		status = PTR_ERR(dev);
> >> +	mutex_unlock(&sysfs_lock);
> > 
> > You just raced with userspace telling it that the device was present,
> > yet the attributes are not there.  Don't do that, use the default class
> > attributes for the class and then the driver core will create them
> > automagically without needing to this "by hand" at all.
> 
> I guess you mean class attributes like gpio_class_attrs[] of gpio_class?

Yes.

> Aren't class attributes specific to a class only (i.e. only one
> attribute at the root for all devices)? What I needed above are
> attributes for the block itself (of which there can be several). So we
> need device attributes for each block, not class attributes here.

Yes, that is what the dev_attrs field in 'struct class' is for.

> Maybe there's some other kind of locking/atomicity available for this task?
> 
> Further, current gpio and gpiochip devices are also doing this way:
> creating the device and subsequently their attrs, even though there may
> be a better way but I'm still wondering how this would be.

Then the existing code is broken and should be fixed to use dev_attrs.
I guess it's time to audit the tree and find all places that get this
wrong...

greg k-h
