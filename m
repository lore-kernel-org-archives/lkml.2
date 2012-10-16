Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2JPJnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:43:32 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:10103 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2JPJnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:43:31 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.793
From: Lars Poeschel <poeschel@lemonage.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 1/4] mfd: add viperboard driver
Date: Tue, 16 Oct 2012 11:43:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de> <507D1D7A.4040205@metafoo.de>
In-Reply-To: <507D1D7A.4040205@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210161143.19619.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012 at 10:40:26, Lars-Peter Clausen wrote:
> On 10/12/2012 04:34 PM, Lars Poeschel wrote:
> > [...]
> > +static void vprbrd_dev_release(struct device *dev)
> > +{
> > +	return;
> 
> A empty release callback is usually a good indicator that something is
> wrong. The release callback will be called once the last reference to the
> device has been called, so the memory associated with the device should not
> be freed before the release callback has been called, otherwise the memory
> might be accessed after it has been freed...
> 
> > +}
> > +
> > +static void vprbrd_free(struct vprbrd *dev)
> > +{
> > +	usb_put_dev(dev->usb_dev);
> > +	kfree(dev);
> 
> ..., so this kfree should be moved from here to the release callback.

Thank you for catching that one!
 
> Btw. I'm wondering why is the extra platform device required? Can't you not
> just use the usb device as the parent device for the mfd cells?

This is what I first did, but this does not work. You can read about my first 
thoughts why this is not working here: (To sum it up: The device is housed in 
an usb_device, not a platform_device and This usb_device has no mfd_cell 
member.)

https://lkml.org/lkml/2012/9/28/327

As I got a bit more deeper I also noticed, that mfd_add_devices (obviously) 
adds the devices "as childs" to the parent device. mfd_remove_devices then 
removes ALL "child" devices from the parent, not only those added by 
mfd_add_devices before. This does not work in the case of the usb parent 
device, because it has other childs that the usb layer added before (some 
endpoints and stuff). So I had to construct an "empty" (in sense of childs) 
mock platform_device between the usb and mfd.
