Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2K1SgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:36:12 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35344 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2K1SgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:36:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Wen Congyang <wencongyang@gmail.com>, isimatu.yasuaki@jp.fujitsu.com,
        lenb@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 3/3] acpi_memhotplug: Allow eject to proceed on rebind scenario
Date: Wed, 28 Nov 2012 19:40:54 +0100
Message-ID: <9212118.3s2xH6uJDI@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1354118473.26955.208.camel@misato.fc.hp.com>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com> <2804331.4p7pU4ARvy@vostro.rjw.lan> <1354118473.26955.208.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 09:01:13 AM Toshi Kani wrote:
> On Wed, 2012-11-28 at 00:41 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 27, 2012 03:03:47 PM Toshi Kani wrote:
> > > On Tue, 2012-11-27 at 19:32 +0100, Vasilis Liaskovitis wrote:
> > > > On Mon, Nov 26, 2012 at 05:19:01PM -0700, Toshi Kani wrote:
> > > > > > >> Consider the following sequence of operations for a hotplugged memory
> > > > > > >> device:
> > > > > > >>
> > > > > > >> 1. echo "PNP0C80:XX" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind
> > > > > > >> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> > > > > > >>
> > > > > > >> If we don't offline/remove the memory, we have no chance to do it in
> > > > > > >> step 2. After
> > > > > > >> step2, the memory is used by the kernel, but we have powered off it. It
> > > > > > >> is very
> > > > > > >> dangerous.
> > > > > > > 
> > > > > > > How does power-off happen after unbind? acpi_eject_store checks for existing
> > > > > > > driver before taking any action:
> > > > > > > 
> > > > > > > #ifndef FORCE_EJECT
> > > > > > > 	if (acpi_device->driver == NULL) {
> > > > > > > 		ret = -ENODEV;
> > > > > > > 		goto err;
> > > > > > > 	}
> > > > > > > #endif
> > > > > > > 
> > > > > > > FORCE_EJECT is not defined afaict, so the function returns without scheduling
> > > > > > > acpi_bus_hot_remove_device. Is there another code path that calls power-off?
> > > > > > 
> > > > > > Consider the following case:
> > > > > > 
> > > > > > We hotremove the memory device by SCI and unbind it from the driver at the same time:
> > > > > > 
> > > > > > CPUa                                                  CPUb
> > > > > > acpi_memory_device_notify()
> > > > > >                                        unbind it from the driver
> > > > > >     acpi_bus_hot_remove_device()
> > > > > 
> > > > > Can we make acpi_bus_remove() to fail if a given acpi_device is not
> > > > > bound with a driver?  If so, can we make the unbind operation to perform
> > > > > unbind only?
> > > > 
> > > > acpi_bus_remove_device could check if the driver is present, and return -ENODEV
> > > > if it's not present (dev->driver == NULL).
> > > > 
> > > > But there can still be a race between an eject and an unbind operation happening
> > > > simultaneously. This seems like a general problem to me i.e. not specific to an
> > > > acpi memory device. How do we ensure an eject does not race with a driver unbind
> > > > for other acpi devices?
> > > > 
> > > > Is there a per-device lock in acpi-core or device-core that can prevent this from
> > > > happening? Driver core does a device_lock(dev) on all operations, but this is
> > > > probably not grabbed on SCI-initiated acpi ejects.
> > > 
> > > Since driver_unbind() calls device_lock(dev->parent) before calling
> > > device_release_driver(), I am wondering if we can call
> > > device_lock(dev->dev->parent) at the beginning of acpi_bus_remove()
> > > (i.e. before calling pre_remove) and fails if dev->driver is NULL.  The
> > > parent lock is otherwise released after device_release_driver() is done.
> > 
> > I would be careful.  You may introduce some subtle locking-related issues
> > this way.
> 
> Right.  This requires careful inspection and testing.  As far as the
> locking is concerned, I am not keen on using fine grained locking for
> hot-plug.  It is much simpler and solid if we serialize such operations.
> 
> > Besides, there may be an alternative approach to all this.  For example,
> > what if we don't remove struct device objects on eject?  The ACPI handles
> > associated with them don't go away in that case after all, do they?
> 
> Umm...  Sorry, I am not getting your point.  The issue is that we need
> to be able to fail a request when memory range cannot be off-lined.
> Otherwise, we end up ejecting online memory range.

Yes, this is the major one.  The minor issue, however, is a race condition
between unbinding a driver from a device and removing the device if I
understand it correctly.  Which will go away automatically if the device is
not removed in the first place.  Or so I would think. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
