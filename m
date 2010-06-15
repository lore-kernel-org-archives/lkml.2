Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0FOJdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:33:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53784 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0FOJdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:33:47 -0400
Date: Tue, 15 Jun 2010 10:33:43 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org,
       Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] khubd -- switch USB product/manufacturer/serial
 handling to RCU
Message-ID: <20100615093343.GY12061@shadowen.org>
References: <1276514141-23725-1-git-send-email-apw@canonical.com>
 <20100614162919.GA13932@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614162919.GA13932@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:29:19AM -0700, Greg KH wrote:
> On Mon, Jun 14, 2010 at 12:15:41PM +0100, Andy Whitcroft wrote:
> > With the introduction of wireless USB hubs the product, manufacturer,
> > and serial number are now mutable.
> 
> Changable by whom?  The device itself?  This has always been the case,
> although it is usually very rare for a device to do this.
> 
> > This necessitates new locking in the gconsumers of these values
> > including the sysfs read routines in order to prevent use-after-free
> > acces to these values.
> 
> Who would access them after they go away?

I think you have miss-understood what this is trying to say.  This is
trying to state the current state of play.  I am trying to say that
previous commits which introduced wireless hubs made these string
fungible and fungible while the device is present and registered in sysfs.
Those commits necessarily added the locking to the sysfs files to ensure
safe reading of these values.

> > These extra locks create significant lock contention leading to
> > increased boot times (0.3s for an example Atom based system).
> 
> Who is doing all of the deauthorization at boot time that this would
> ever matter at all?
> > Move update of these values to RCU based locking.
> 
> Ick.  What has changed that necessitates this?  You discuss a variety of
> different things in this bug report:
> 
> > BugLink: http://bugs.launchpad.net/bugs/510937
> 
> Which would have been nice to dicuss with the people on these lists.  I
> really don't think this is the correct fix, as a normal boot path
> shouldn't be having non-authorized usb devices, right?  And from that
> bug, once the machine is up and running, there is no contention here,
> right?

It is not that these values are changing at all, indeed they are not.
It is that because they could, should the device be of a type which can
authorise/deauthorise at any time, that these strings may come and go
at any time and thus sysfs read accesses now already are locked against
these changes.

The contention that is triggered on boot is triggered by udev probing
in parallel across the usb hubs.  The lock used to protect these string
values is the device lock and is held for some time during hub probes and
prevents udev from reading these strings during that time.  This lead to
significant spin times for udev and lead to a .3s to .5s increase in device
initialisation, approximatly 10% of the overal device initialisation time
of 4s.  This was a significant boot performance regression for us.

In the first instance we confirmed that it was the lock on those string
by simply removing the locking, which was not required at all in the
static hub case.  But we need some protection here for the wireless case.
It seemed appropriate as these are read-mostly values and changed very
rarely (if at all) to switch these over to RCU locking rather than
introduce a new lock for them.

They key concern here is to split the locking between the device lock
and the string locking to prevent these needless boot stalls.  I am not
wedded to any particular solution.

-apw
