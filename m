Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2KZVcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:32:36 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29172 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2KZVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:32:35 -0500
Message-ID: <1353965049.26955.159.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via
 .sys_notify
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Date: Mon, 26 Nov 2012 14:24:09 -0700
In-Reply-To: <1353964194.26955.153.camel@misato.fc.hp.com>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
	 <9351429.9B119055GG@vostro.rjw.lan>
	 <1353956799.26955.130.camel@misato.fc.hp.com>
	 <1893337.Wdi2FRlPFR@vostro.rjw.lan>
	 <1353964194.26955.153.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 14:09 -0700, Toshi Kani wrote:
> On Mon, 2012-11-26 at 21:44 +0100, Rafael J. Wysocki wrote:
> > On Monday, November 26, 2012 12:06:39 PM Toshi Kani wrote:
> > > On Sat, 2012-11-24 at 23:37 +0100, Rafael J. Wysocki wrote:
> > > > On Saturday, November 24, 2012 11:01:56 PM Rafael J. Wysocki wrote:
> > > > > On Thursday, November 08, 2012 01:23:44 PM Toshi Kani wrote:
> > > > > > Added a new .sys_notify interface, which allows ACPI drivers to
> > > > > > register their system-level (ex. hotplug) notify handlers through
> > > > > > their acpi_driver table.  This removes redundant ACPI namespace
> > > > > > walks from ACPI drivers for faster booting.
> > > > > > 
> > > > > > The global notify handler acpi_bus_notify() is called for all
> > > > > > system-level ACPI notifications, which then calls an appropriate
> > > > > > driver's handler if any.  ACPI drivers no longer need to register
> > > > > > or unregister driver's handler to each ACPI device object.  It also
> > > > > > supports dynamic ACPI namespace with LoadTable & Unload opcode
> > > > > > without any modification in ACPI drivers.
> > > > > > 
> > > > > > Added a common system notify handler acpi_bus_sys_notify(), which
> > > > > > allows ACPI drivers to set it to .sys_notify when this function is
> > > > > > fully implemented.
> > > > > 
> > > > > I don't really understand this.
> > > > > 
> > > > > > It removes functional conflict between driver's
> > > > > > notify handler and the global notify handler acpi_bus_notify().
> > > > > > 
> > > > > > Note that the changes maintain backward compatibility for ACPI
> > > > > > drivers.  Any drivers registered their hotplug handler through the
> > > > > > existing interfaces, such as acpi_install_notify_handler() and
> > > > > > register_acpi_bus_notifier(), will continue to work as before.
> > > > > 
> > > > > I really wouldn't like to add new callbacks to struct acpi_device_ops, because
> > > > > I'd like that whole thing to go away entirely eventually, along with struct
> > > > > acpi_driver.
> > > > > 
> > > > > Moreover, in this particular case, it really is not useful to have to define
> > > > > a struct acpi_driver so that one can register for receiving system
> > > > > notifications from ACPI.  It would be really nice if non-ACPI drivers, such
> > > > > as PCI or platform, could do that too.
> > > > 
> > > > Which they do by using acpi_install_notify_handler() directly.
> > > 
> > > By using acpi_install_notify_handler(), each driver needs to walk
> > > through the entire ACPI namespace to find its associated ACPI devices
> > > and call it to register one by one.  I think this is more work for
> > > non-ACPI drivers than defining acpi_driver.
> > 
> > I'm not really sure what you mean.  The drivers in question already know
> > what the relevant ACPI device nodes are (because they need them anyway
> > for other purposes), so they don't need to look for them specifically and
> > acpi_install_notify_handler() doesn't do any namespace walking.  So what
> > you said above simply doesn't make sense from this viewpoint.
> 
> Yes, if drivers already know the relevant ACPI devices, then walking the
> ACPI namespace is not necessary.  I was referring the case like
> processor_driver.c, acpi_memhotplug.c, and container.c in my statement. 

BTW, when an ACPI device is marked as non-present, which is the case
before hot-add, we do not create an acpi_device object and therefore do
not bind it with a driver.  This is why these drivers walk the ACPI
namespace and install their notify handlers regardless of device status.

Thanks,
-Toshi 







