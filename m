Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1AXNHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:07:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:57867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1AXNHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:07:31 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Thermal kernel events API to userspace - Was: Re: thermal: Avoid CONFIG_NET compile dependency
Date: Mon, 24 Jan 2011 14:07:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-8.99.14.138eeaa-desktop; KDE/4.5.95; x86_64; ; )
Cc: jdelvare@novell.com, "Zhang, Rui" <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-perf-users@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com> <D6D887BA8C9DFF48B5233887EF046541094488B86F@bgsmsx502.gar.corp.intel.com> <201101241135.23576.trenn@suse.de>
In-Reply-To: <201101241135.23576.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241407.28376.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder whether netlink is the way to go for thermal
events at all.
Sending an udev event would already contain the sysfs
path to the thermal device. A variable which thermal event
got thrown could get added and userspace can read out the rest
easily from sysfs files. But I expect udev is not intended
for such general events?

There is a lot talking about perf events...
perf events are/were for debugging as they get exported
through /sys/kernel/debug.
Recently people came up with the idea to add a perf event API
for MCE (Machine Check Exceptions) events which clearly is nothing
for debugging, but productive applications want to catch
and process them.
So either MCEs should better get a kind of netlink/ioctl or
whatever (not depending on debugging) interface to userspace
or thermal events might also fit as perf events.

This should get discussed by a broader audience, adding some
people to CC.

    Thomas


On Monday, January 24, 2011 11:35:23 AM Thomas Renninger wrote:
> Hi,
> 
> On Monday, January 24, 2011 05:39:26 AM R, Durgadoss wrote:
> > Hi Rui,
> > 
> ...
> > This refers to the patch that you acknowledged.
> > So, you are not missing any patch in the middle.
> > 
> > Also, the thermal_aux0 and _aux1, we can use the final format specified by you.
> > enum events {
> >  	THERMAL_CRITICAL,
> >  	/* user defined thermal events */
> >  	THERMAL_USER_AUX0,
> >  	THERMAL_USER_AUX1,
> >  	THERMAL_DEV_FAULT,
> >  };
> Something else...
> I've now seen your HW specific core/pkg temp threshold support.
> I didn't look at it that closely, but if you introduce generic
> thermal netlink events in the thermal driver those should match
> all kind of possible thermal events, not only the once introduced
> by the driver you added.
> 
> For example it would be great to get the ACPI specific thermal
> events which are currently exported as ACPI driven ones:
> drivers/acpi/thermal.c:acpi_thermal_notify()
> integrated there as well. So there should also be events like:
> >  	THERMAL_CRITICAL,
> >  	/* user defined thermal events */
> >  	THERMAL_USER_AUX0,
> >  	THERMAL_USER_AUX1,
> >  	THERMAL_DEV_FAULT,
> THERMAL_PASSIVE
> THERMAL_ACTIVE
> THERMAL_HOT
> 
> At some point of time we should be able
> to get rid of the ACPI specific thermal events at all?
> There seem to be nothing like a kind of
> "available netlink events and their format" API in Documentation.
> Each driver seem to do this and document it itself.
> But as it is an interface to userspace, these thermal netlink events
> should get documented in:
> Documentation/thermal
> 
> Currently you only export one of the above 4 thermal events as a
> number via netlink, right?
> Are there any userspace programs you have in mind which should make
> use of it?
> 
> Some data which should get exported as well:
>    - The temperature if available
>    - The number of the thermal zone, e.g. if 0, userspace can look
>      up sysfs for further info in:
>      /sys/devices/virtual/thermal/thermal_zone0/*
>    - The trip point affected if any, e.g. if 0, userspace can look it up
>      in sysfs for further info:
>      /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_{temp,type}
>    - more?
> 
> Ehh, this core and package thermal driver you added threshold support,
> does this somehow register as a thermal driver?
> I can see that it registers for hwmon: hwmon_device_register(&pdev->dev);
> But is it somehow connected to thermal_sys.c other than that it just
> throws your newly introduced thermal_netlink_events?
> This driver should first register as a thermal driver, export
> trip points to:
> /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_{temp,type}
> e.g.
> cat trip_point_0_type
> critical
> cat trip_point_1_type
> user_aux0
> 
> The thermal_netlink_events could then only be declared for
> thermal_sys.c scope, so that other drivers cannot misuse them
> and the netlink event can then get triggered by the driver through
> thermal driver callbacks.
> 
> Rui: What do you think?
> This implementation looks much too static, could you help to better
> adjust it to the generic thermal driver needs, you know this stuff best.
> 
> This is merged already. I wonder whether we still could get a thermal
> event netlink API for 2.6.38 which is more robust so that userspace does
> not need to differ its version with the next kernel.
> Maybe it's best to remove the thermal netlink parts again for now.
> 
> 
>      Thomas
