Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2ESAcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:32:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52029 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab2ESAcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:32:08 -0400
Date: Fri, 18 May 2012 17:32:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk
Subject: Re: [PATCH] staging: comedi: cleanup all the comedi_driver 'detach'
 functions
Message-ID: <20120519003204.GA1210@kroah.com>
References: <201205171711.14968.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205171711.14968.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 05:11:14PM -0700, H Hartley Sweeten wrote:
> 1. Change the return type from int to void
> 
> All the detach functions, except for the comedi usb drivers, simply
> return success (0). Plus, the return code is never checked in the
> comedi core.
> 
> The comedi usb drivers do return error codes but the conditions can
> never happen.
> 
> The first check is:
> 
> 	if (!dev)
> 		return -EFAULT;
> 
> This checks that the passed comedi_device pointer is valid. The detach
> function itself is called using this pointer so it MUST always be valid
> or there is a bug in the core:
> 
> 	if (dev->driver)
> 		dev->driver->detach(dev);
> 
> And the second check:
> 
> 	usb = dev->private;
> 	if (!usb)
> 		return -EFAULT;
> 
> The dev->private pointer is setup in the attach function to point to the
> probed usb device. This value could be NULL if the attach fails. But,
> since the comedi core is going to unload the driver anyway and does not
> check for errors there is no gain by returning one.
> 
> After removing these checks from the comedi usb drivers the detach
> functions required a bit of cleanup.
> 
> 2. Remove all the printk noise in the detach functions
> 
> All of the printk output is really just noise. The user did a rmmod to
> unload the driver, we really don't need to tell them about it.
> 
> Also, some of the messages are output using:
> 
> 	dev_dbg(dev->hw_dev, ...
> or
> 	dev_info(dev->hw_dev, ...
> 
> Unfortunately the hw_dev value is only used by drivers that are doing
> DMA. For most drivers this variable is going to be NULL so the output
> is not going to work as expected.

Sorry about that, I probably caused a lot of that.  As no one ever
complained, odds are no one is using those drivers :)

> 
> 3. Refactor a couple static 'free_resource' functions into the detach
>    functions.
> 
> The 'free_resource' function is only being called by the detach and it
> makes more sense to just absorb the code.
> 
> 4. Remove a couple unnecessary braces for single statements.
> 
> 5. Remove unnecessary comments.
> 
> Most of the comedi drivers appear to be based on the comedi skel driver
> and have the comments from that driver included. These comments make
> sense in the skel driver for reference but they don't need to be in any
> of the actual drivers.
> 
> 6. Remove all the extra whitespace.
> 
> It's not needed to make the functions any more readable.
> 
> 7. Remove the now unused 'attached_successfully' variable in the
>    cb_pcimdda driver.
> 
> This variable was only used to conditionally output some driver noise
> during the detach. Since all the printk's have been removed this
> variable is no longer necessary.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Mori Hess <fmhess@users.sourceforge.net>
> 
> ---
> 
> This is a pretty large patch but it's mostly line removal. I can break
> it up if necessary.

Not a problem this time, I've taken it as-is, as I need to close the
merge window in a few minutes...

thanks,

greg k-h
