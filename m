Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2KZTPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:15:06 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:3155 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2KZTPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:15:04 -0500
Message-ID: <1353956799.26955.130.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via
 .sys_notify
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Date: Mon, 26 Nov 2012 12:06:39 -0700
In-Reply-To: <9351429.9B119055GG@vostro.rjw.lan>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
	 <1352406227-32629-2-git-send-email-toshi.kani@hp.com>
	 <1534747.XBnkTFzSlv@vostro.rjw.lan> <9351429.9B119055GG@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-24 at 23:37 +0100, Rafael J. Wysocki wrote:
> On Saturday, November 24, 2012 11:01:56 PM Rafael J. Wysocki wrote:
> > On Thursday, November 08, 2012 01:23:44 PM Toshi Kani wrote:
> > > Added a new .sys_notify interface, which allows ACPI drivers to
> > > register their system-level (ex. hotplug) notify handlers through
> > > their acpi_driver table.  This removes redundant ACPI namespace
> > > walks from ACPI drivers for faster booting.
> > > 
> > > The global notify handler acpi_bus_notify() is called for all
> > > system-level ACPI notifications, which then calls an appropriate
> > > driver's handler if any.  ACPI drivers no longer need to register
> > > or unregister driver's handler to each ACPI device object.  It also
> > > supports dynamic ACPI namespace with LoadTable & Unload opcode
> > > without any modification in ACPI drivers.
> > > 
> > > Added a common system notify handler acpi_bus_sys_notify(), which
> > > allows ACPI drivers to set it to .sys_notify when this function is
> > > fully implemented.
> > 
> > I don't really understand this.
> > 
> > > It removes functional conflict between driver's
> > > notify handler and the global notify handler acpi_bus_notify().
> > > 
> > > Note that the changes maintain backward compatibility for ACPI
> > > drivers.  Any drivers registered their hotplug handler through the
> > > existing interfaces, such as acpi_install_notify_handler() and
> > > register_acpi_bus_notifier(), will continue to work as before.
> > 
> > I really wouldn't like to add new callbacks to struct acpi_device_ops, because
> > I'd like that whole thing to go away entirely eventually, along with struct
> > acpi_driver.
> > 
> > Moreover, in this particular case, it really is not useful to have to define
> > a struct acpi_driver so that one can register for receiving system
> > notifications from ACPI.  It would be really nice if non-ACPI drivers, such
> > as PCI or platform, could do that too.
> 
> Which they do by using acpi_install_notify_handler() directly.

By using acpi_install_notify_handler(), each driver needs to walk
through the entire ACPI namespace to find its associated ACPI devices
and call it to register one by one.  I think this is more work for
non-ACPI drivers than defining acpi_driver.  Furthermore, this approach
will impose some major issues below.  (NOTE: Hot-plug implementation
varies in platforms/virtual machines.  These are examples from our IA64
platforms supported by other OS, but I hope Linux would support similar
capability in future.) 

a) Node Hot-plug
When a new node is added, the FW may extend the ACPI namespace by
loading SSDT for the new node.  Therefore, if we rely on drivers to call
acpi_install_notify_handler(), we need to make the drivers to walk the
namespace again to call it for new devices.  Similarly, the drivers need
to call acpi_remove_notify_handler() when a node is removed. 

b) Memory hot-plug
The FW may slice up the memory range with multiple memory device objects
so that logical hot-add/removal can be performed in finer granularity
for better resource balancing.  For example, a system with 4TB memory
sliced up with 1GB memory device objects will have (4 * 1024) memory
device objects in ACPI namespace.  If each driver walks ACPI namespace,
it can lead noticeable delay in such environment.  The number of objects
can easily go up when supporting more finer granularity or more amount
of memory.


> > Besides, acpi_os_execute_deferred() is always run on CPU0, because of some
> > SMI-related peculiarity, which is not very efficient as far as the events
> > handling is concerned, but we can improve the situation a bit by queing the
> > execution of the registered handlers in a different workqueue.  Maybe it's
> > worth considering if we're going to change this code anyway?

In my experience, serializing hot-plug operations within an OS instance
is not typically an issue, and makes it much easier for testing and
diagnosing an issue.


> Well, perhaps we really don't need to change it after all?  Maybe we can just
> switch everyone to using acpi_install_notify_handler() and then we can just
> drop that code entirely?

I am concerned with the approach of each driver calling
acpi_install_notify_handler() directly, as described above.


Thanks,
-Toshi



