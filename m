Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2K0WMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:12:17 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5109 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2K0WMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:12:14 -0500
Message-ID: <1354053827.26955.196.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH v3 3/3] acpi_memhotplug: Allow eject to proceed on
 rebind scenario
From: Toshi Kani <toshi.kani@hp.com>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Wen Congyang <wencongyang@gmail.com>,
        linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        rjw@sisk.pl, lenb@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 27 Nov 2012 15:03:47 -0700
In-Reply-To: <20121127183245.GA4674@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
	 <1353693037-21704-4-git-send-email-vasilis.liaskovitis@profitbricks.com>
	 <50B0F3DF.4000802@gmail.com>
	 <20121126083634.GA4574@dhcp-192-168-178-175.profitbricks.localdomain>
	 <50B3323E.7020907@cn.fujitsu.com>
	 <1353975541.26955.182.camel@misato.fc.hp.com>
	 <20121127183245.GA4674@dhcp-192-168-178-175.profitbricks.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 19:32 +0100, Vasilis Liaskovitis wrote:
> On Mon, Nov 26, 2012 at 05:19:01PM -0700, Toshi Kani wrote:
> > > >> Consider the following sequence of operations for a hotplugged memory
> > > >> device:
> > > >>
> > > >> 1. echo "PNP0C80:XX" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind
> > > >> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> > > >>
> > > >> If we don't offline/remove the memory, we have no chance to do it in
> > > >> step 2. After
> > > >> step2, the memory is used by the kernel, but we have powered off it. It
> > > >> is very
> > > >> dangerous.
> > > > 
> > > > How does power-off happen after unbind? acpi_eject_store checks for existing
> > > > driver before taking any action:
> > > > 
> > > > #ifndef FORCE_EJECT
> > > > 	if (acpi_device->driver == NULL) {
> > > > 		ret = -ENODEV;
> > > > 		goto err;
> > > > 	}
> > > > #endif
> > > > 
> > > > FORCE_EJECT is not defined afaict, so the function returns without scheduling
> > > > acpi_bus_hot_remove_device. Is there another code path that calls power-off?
> > > 
> > > Consider the following case:
> > > 
> > > We hotremove the memory device by SCI and unbind it from the driver at the same time:
> > > 
> > > CPUa                                                  CPUb
> > > acpi_memory_device_notify()
> > >                                        unbind it from the driver
> > >     acpi_bus_hot_remove_device()
> > 
> > Can we make acpi_bus_remove() to fail if a given acpi_device is not
> > bound with a driver?  If so, can we make the unbind operation to perform
> > unbind only?
> 
> acpi_bus_remove_device could check if the driver is present, and return -ENODEV
> if it's not present (dev->driver == NULL).
> 
> But there can still be a race between an eject and an unbind operation happening
> simultaneously. This seems like a general problem to me i.e. not specific to an
> acpi memory device. How do we ensure an eject does not race with a driver unbind
> for other acpi devices?
> 
> Is there a per-device lock in acpi-core or device-core that can prevent this from
> happening? Driver core does a device_lock(dev) on all operations, but this is
> probably not grabbed on SCI-initiated acpi ejects.

Since driver_unbind() calls device_lock(dev->parent) before calling
device_release_driver(), I am wondering if we can call
device_lock(dev->dev->parent) at the beginning of acpi_bus_remove()
(i.e. before calling pre_remove) and fails if dev->driver is NULL.  The
parent lock is otherwise released after device_release_driver() is done.

Thanks,
-Toshi

