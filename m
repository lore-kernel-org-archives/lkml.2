Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab2HBO51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:57:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56690 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2HBO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:57:26 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 2 Aug 2012 07:57:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the error handling in probe
Message-ID: <20120802145727.GA19676@roeck-us.net>
References: <1343813788-19165-1-git-send-email-shubhrajyoti@ti.com>
 <20120801150713.GB15630@roeck-us.net>
 <501A5151.4040207@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501A5151.4040207@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 03:37:13PM +0530, Shubhrajyoti wrote:
> On Wednesday 01 August 2012 08:37 PM, Guenter Roeck wrote:
> > On Wed, Aug 01, 2012 at 03:06:28PM +0530, Shubhrajyoti D wrote:
> >> The kfree() is taken care of by the spi core (spi_master_release() function)
> >> that is called once the last reference to the underlying struct device has
> >> been released. So the driver need not call kfree.
> >>
> >> Also the put was missed in some of the error handling fix the same.
> >> There by fixing the missing device_put in some of the error paths.
> >>
> >> Cc: Guenter Roeck <linux@roeck-us.net>
> > Reported-by: may be better here.
> My bad. I should have done.
> >
> >> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > Acked-by: Guenter Roeck <linux@roeck-us.net>
> thanks.
> > I suspect that "spi_master_put(master);" may also be missing in
> > omap2_mcspi_remove(), but we'll need someone to confirm that.
> Looks unlikely.
> 
> spi_master_put does a 
> ...
>   if (master)
>                 put_device(&master->dev);
> ...
> 
> In remove I call 
> 
> spi_unregister_master
> ...
> */
> void spi_unregister_master(struct spi_master *master)
> {
>         int dummy;
> [...]
> 
>         dummy = device_for_each_child(&master->dev, NULL, __unregister);
>         device_unregister(&master->dev);
> }
> 
> and 
> 
> void device_unregister(struct device *dev)
> {
>     [..]
>         device_del(dev);
>         put_device(dev);
> }
> 
> Hope my understanding is correct.
> 
I think it is; I checked the refcount. spi_register_master increases
refcount from 1 to 3, and spi_unregister_master decreases it from 3 to 0.

Now, if _my_ understanding is correct, that means the data structure allocated
with spi_alloc_master, and specifically the device private data structure
(struct omap2_mcspi in your case), is freed with spi_unregister_master().
If so, it must not be accessed after the call to spi_unregister_master().
However, many drivers do access this data after the call to
spi_unregister_master(). spi-tegra.c is a good example, but there are many
others. Does that mean that those drivers access freed memory ?

Also, some other drivers do call spi_master_put() after spi_unregister_master(),
with no matching spi_master_get() (eg spi-topcliff-pch.c). Does that mean that
those drivers call spi_master_put() on free memory ?

Thanks,
Guenter
