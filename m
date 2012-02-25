Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2BYAxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 19:53:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58047 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab2BYAxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 19:53:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.220.7 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 16:40:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: federico.vaga@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: How to make a bus with heterogeneous devices?
Message-ID: <20120225004008.GA3973@kroah.com>
References: <20120224152051.GA23232@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224152051.GA23232@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 04:20:51PM +0100, Alessandro Rubini wrote:
> Hello Greg. 
> 
> Federico Vaga and me are working on the ZIO framework
> (ohwr.org/projects/zio) and he's currently adding the bus abstraction,
> so we can support several cards of the same type.  Under ZIO,
> different devices may have different attributes: an SPI ADC chip may
> allow to choose from two voltage references while a PCI digital-output
> device may have a device-wide clocking rate.
> 
> But the list of attributes associated to a device is only known when
> the driver is matched. In other workds, the "device" part is only
> claiming "here I am and I'm called <sth>", then the probe method of the
> <sth> driver will instantiate the device with its attributes.

That's fine, it is what happens with lots of drivers, you can do this
with the default attribute group assigned to that driver, right?

> However, the device appears in sysfs whether or not there is a driver
> for it (which we agree is correct), but the list of attributes is only
> known when the driver is matched -- because the list is known to the
> driver, not to the device.
> 
> Here are some paths we evaluated:
> 
> 1- /sys/bus/zio/devices may include place-holders, while a successful
> match and probe will create real stuff is in /sys/zio/devices/<sth>-0/
> But this would mean kobjects and you mandated us to only use devices
> instead.
> 
> 2- Like above, but falling in /sys/devices/virtual/zio/ ?
> 
> 3- Attributes may be added after match succeeds, before calling probe.
> This cam be done with a "raw" call to sysfs_create_group(); then
> groups cna be added to dev->groups so they will be removed on
> device_unregister().
> 
> 4- Attributes may be added to the device before drv->probe is called
> (or after it succeeds), using FIXMEFEDE. But .... FIXMEFEDE
> 
> 5- The real attributes may live in another device, which is a child of
> the one used within the bus abstraction.  Here the drawback is using
> an additional device and directory level for no reason.
> 
> 6- We may use a fake (almost empty) device for the match function, and
> then register the real one, with full attributes, when the match
> succeeds (so match is called again and must be worked around). This
> would work but is clearly a horrible hack.

Ick, don't do that...

> We looked at other bus abstractions, and all of them host homogeneous
> devices (they may have sub-devices, but none of them has different
> attributes).  Even the platform bus has no per-device attribute list
> instantiated by the driver.  In the cases where the attribute list is
> different for each device, the list is known to the device, before the
> match function is called.

I think you need to look at how the system bus is handled.  It just went
into 3.3-rc and allows for "different" types of devices to all be on the
same bus, with different drivers and attributes.  Let me know if how
that works does not work out for you.

thanks,

greg k-h
