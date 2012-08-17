Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2HQTB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:01:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60393 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab2HQTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:01:18 -0400
Date: Fri, 17 Aug 2012 12:01:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Tomas Hlavacek <tmshlvck@gmail.com>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] [RFC] uartclk from serial_core exposed to sysfs
Message-ID: <20120817190114.GA31011@kroah.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
 <CAEB7QLBEdNArtKz9zP7R4Za54049jJqCEqhPvE6rS59j1tD0PQ@mail.gmail.com>
 <20120817165446.GA12361@kroah.com>
 <201208172044.14868.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208172044.14868.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 08:44:14PM +0200, Marek Vasut wrote:
> Dear Greg KH,
> 
> > On Fri, Aug 17, 2012 at 06:30:36PM +0200, Tomas Hlavacek wrote:
> > > Hello Greg!
> > > 
> > > On Fri, Aug 17, 2012 at 5:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >> @@ -2355,6 +2373,14 @@ int uart_add_one_port(struct uart_driver *drv,
> > > >> struct uart_port *uport)
> > > >> 
> > > >>       }
> > > >>       
> > > >>       /*
> > > >> 
> > > >> +      * Expose uartclk in sysfs. Use driverdata of the tty device for
> > > >> +      * referencing the UART port.
> > > >> +      */
> > > >> +     dev_set_drvdata(tty_dev, port);
> > > >> +     if (device_create_file(tty_dev, &dev_attr_uartclk) < 0)
> > > >> +             dev_err(tty_dev, "Failed to add uartclk attr\n");
> > > > 
> > > > I think you just raced with userspace in creating the file after the
> > > > device was announced to userspace.  Are you sure it's ok?
> > > > 
> > > > If not (hint, I don't think so), please make it a default attribute of
> > > > the device, which will then cause the file to be created before it is
> > > > announced to userspace.  It will also be less code as you don't have to
> > > > clean it up by hand :)
> > > 
> > > Do you mean I should modify the tty_register_device() function not to
> > > use device_create() but it should rather do the device initialization
> > > on it's own.
> > 
> > No, not at all.
> > 
> > > And I should add add the attribute (via struct attribute_group) to
> > > struct device in between device_initialize() and device_add() calls.
> > > Did I get it right?
> > 
> > No, make this a driver attribute, that way when the device is
> > registered, it adds the attribute automagically to the device that is
> > bound to it.
> 
> (hint, DEVICE_ATTR), right ?

No, that's just a macro that creates the structure for the attribute.
You need to take that structure and tie it to the driver itself, using
the struct device_driver->groups; field.

greg k-h
