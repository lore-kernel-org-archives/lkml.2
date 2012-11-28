Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2K1UkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:40:08 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35792 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2K1UkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:40:05 -0500
Message-ID: <1354134699.26955.290.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via
 .sys_notify
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Date: Wed, 28 Nov 2012 13:31:39 -0700
In-Reply-To: <4411201.YLQBH7zWSI@vostro.rjw.lan>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
	 <6997894.YrZx7D73oL@vostro.rjw.lan>
	 <1354121683.26955.243.camel@misato.fc.hp.com>
	 <4411201.YLQBH7zWSI@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 19:28 +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 28, 2012 09:54:43 AM Toshi Kani wrote:
> > > > > > > By using acpi_install_notify_handler(), each driver needs to walk
> > > > > > > through the entire ACPI namespace to find its associated ACPI devices
> > > > > > > and call it to register one by one.  I think this is more work for
> > > > > > > non-ACPI drivers than defining acpi_driver.
> > > > > > 
> > > > > > I'm not really sure what you mean.  The drivers in question already know
> > > > > > what the relevant ACPI device nodes are (because they need them anyway
> > > > > > for other purposes), so they don't need to look for them specifically and
> > > > > > acpi_install_notify_handler() doesn't do any namespace walking.  So what
> > > > > > you said above simply doesn't make sense from this viewpoint.
> > > > > 
> > > > > Yes, if drivers already know the relevant ACPI devices, then walking the
> > > > > ACPI namespace is not necessary.  I was referring the case like
> > > > > processor_driver.c, acpi_memhotplug.c, and container.c in my statement. 
> > > > 
> > > > BTW, when an ACPI device is marked as non-present, which is the case
> > > > before hot-add, we do not create an acpi_device object and therefore do
> > > > not bind it with a driver.  This is why these drivers walk the ACPI
> > > > namespace and install their notify handlers regardless of device status.
> > > 
> > > So maybe we should create struct acpi_device objects in that case too?
> > 
> > I think it has some challenge as well.  We bind an ACPI driver with
> > device_register(), which calls device_add()-> kobject_add().  So, all
> > non-present ACPI device objects will show up in sysfs, unless we can
> > change the core.  This will change user interface.  There can be quite
> > many non-present devices in ACPI namespace depending on FW
> > implementation.
> 
> If additional devices appear in sysfs, that's not a problem.  If there
> were fewer of them, that would be a real one. :-)

I see.  I guess this means that once we expose all non-present devices
in sysfs, we cannot go back to the current way.  So, we need to be very
careful.  Anyway, this model requires separate handling for static ACPI
[1] and dynamic ACPI [2], which may make the state model complicated.

1. Static ACPI - No creation / deletion of acpi_device at hot-plug.
2. Dynamic ACPI - Create acpi_device at hot-add, delete at hot-remove.


Thanks,
-Toshi

[1] ACPI namespace is static and contains the maximum possible config. 
[2] ACPI namespace is dynamic. SSDT is loaded at hot-add, and unloaded
at hot-remove.


