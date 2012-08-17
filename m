Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab2HQQzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:55:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46237 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab2HQQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:55:03 -0400
Date: Fri, 17 Aug 2012 09:54:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Hlavacek <tmshlvck@gmail.com>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.vasut@gmail.com
Subject: Re: [PATCHv3 1/1] [RFC] uartclk from serial_core exposed to sysfs
Message-ID: <20120817165446.GA12361@kroah.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
 <1345214637-4189-1-git-send-email-tmshlvck@gmail.com>
 <20120817150603.GA13684@kroah.com>
 <CAEB7QLBEdNArtKz9zP7R4Za54049jJqCEqhPvE6rS59j1tD0PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEB7QLBEdNArtKz9zP7R4Za54049jJqCEqhPvE6rS59j1tD0PQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 06:30:36PM +0200, Tomas Hlavacek wrote:
> Hello Greg!
> 
> On Fri, Aug 17, 2012 at 5:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> @@ -2355,6 +2373,14 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
> >>       }
> >>
> >>       /*
> >> +      * Expose uartclk in sysfs. Use driverdata of the tty device for
> >> +      * referencing the UART port.
> >> +      */
> >> +     dev_set_drvdata(tty_dev, port);
> >> +     if (device_create_file(tty_dev, &dev_attr_uartclk) < 0)
> >> +             dev_err(tty_dev, "Failed to add uartclk attr\n");
> >
> > I think you just raced with userspace in creating the file after the
> > device was announced to userspace.  Are you sure it's ok?
> >
> > If not (hint, I don't think so), please make it a default attribute of
> > the device, which will then cause the file to be created before it is
> > announced to userspace.  It will also be less code as you don't have to
> > clean it up by hand :)
> 
> Do you mean I should modify the tty_register_device() function not to
> use device_create() but it should rather do the device initialization
> on it's own.

No, not at all.

> And I should add add the attribute (via struct attribute_group) to
> struct device in between device_initialize() and device_add() calls.
> Did I get it right?

No, make this a driver attribute, that way when the device is
registered, it adds the attribute automagically to the device that is
bound to it.

Does that make sense?

greg k-h
