Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab0JOTSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:18:06 -0400
Received: from kroah.org ([198.145.64.141]:47447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab0JOTSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:18:02 -0400
Date: Fri, 15 Oct 2010 12:09:13 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: m00150988@huawei.com, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        zihan@huawei.com, Lin Lei <Lin.Lei@huawei.com>,
        Franko Fang <huananhu@huawei.com>, wangyeqi@huawei.com
Subject: Re: [PATCH] fix oops in usbserial_cleanup function;
Message-ID: <20101015190913.GA8098@kroah.com>
References: <fadccdfb103f0.103f0fadccdfb@huawei.com>
 <Pine.LNX.4.44L0.1010151009050.1603-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1010151009050.1603-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:15:34AM -0400, Alan Stern wrote:
> On Fri, 15 Oct 2010 m00150988@huawei.com wrote:
> 
> > From:ma rui <m00150988@huawei.com>
> > 1. I find this bug on OpenSUSE 11.3 which kernel version is 2.6.34, but the latest kernel version 2.6.36-rc7 aslo have this bug. This patch is based on
> > the kernel of 2.6.36-rc7
> > 2. bug report:
> >    a. Install huawei datacard dashboard on OpenSUSE 11.3
> >    b. Plug in huawei datacard into OpenSUSE 11.3 which kernel version is 2.6.36-rc7
> >    c. After the dashboard has detected the device, I pull out the usb datacard
> >    d. Close dashboard,then kernel panic will happen in usbserial_clean function
> > 
> > Yes, the datacard exit without close the port. 
> > 
> > But after the dashboard connect internet with hauwei datacard, then Hibernate/resume, the bug will happen too.
> > Do you have any other good idea to resolve this bug,or please apply my patch,thanks. :)
> > 
> > 
> > Signed-off-by: ma rui <m00150988@huawei.com>
> > 
> > 
> > diff -uprN -X linux-2.6.36-rc7_orig/Documentation/dontdiff linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c
> > --- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c	2010-10-06 16:39:52.000000000 -0400
> > +++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c	2010-10-15 01:57:36.000000000 -0400
> > @@ -328,6 +328,16 @@ static void serial_cleanup(struct tty_st
> >  	/* The console is magical.  Do not hang up the console hardware
> >  	 * or there will be tears.
> >  	 */
> > +	if (NULL == port)
> > +		return;
> > +	mutex_lock(&port->serial->disc_mutex);
> > +	if (port->serial->disconnected) {
> > +		return_serial(port->serial);
> > +		mutex_unlock(&port->serial->disc_mutex);
> > +		return;
> > +	}
> > +	mutex_unlock(&port->serial->disc_mutex);
> > +
> >  	if (port->port.console)
> >  		return;
> 
> This patch is clearly wrong, since it skips some of the actions that 
> should be taken by serial_cleanup even if the port is already 
> disconnected.
> 
> Besides, the main point of the patch is to avoid problems when 
> port = tty->driver_data turns out to be NULL.  But the only place where 
> tty->driver_data is set to NULL is further below in this same function!  
> So the problems should never arise.
> 
> If they do arise, it indicates there's a bug somewhere else.  That 
> other bug can't be fixed by changing this function.

Yeah, I agree.

Ma, what is the full oops message that you are seeing here when you
remove the device?  And does userspace still have the device open at
that time?  I'm guessing so as it sounds like the oops happens when the
port is then closed.  I can't duplicate that problem here.

thanks,

greg k-h
