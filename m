Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2K1Wly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:41:54 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:44749 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2K1Wlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:41:51 -0500
Message-ID: <1354142007.26955.352.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via
 .sys_notify
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Date: Wed, 28 Nov 2012 15:33:27 -0700
In-Reply-To: <12655874.tBYV6dRMny@vostro.rjw.lan>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
	 <5550104.xSe1fX9Ich@vostro.rjw.lan>
	 <1354137803.26955.325.camel@misato.fc.hp.com>
	 <12655874.tBYV6dRMny@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > I think it has some challenge as well.  We bind an ACPI driver with
> > > > > > device_register(), which calls device_add()-> kobject_add().  So, all
> > > > > > non-present ACPI device objects will show up in sysfs, unless we can
> > > > > > change the core.  This will change user interface.  There can be quite
> > > > > > many non-present devices in ACPI namespace depending on FW
> > > > > > implementation.
> > > > > 
> > > > > If additional devices appear in sysfs, that's not a problem.  If there
> > > > > were fewer of them, that would be a real one. :-)
> > > > 
> > > > I see.  I guess this means that once we expose all non-present devices
> > > > in sysfs, we cannot go back to the current way.  So, we need to be very
> > > > careful.  Anyway, this model requires separate handling for static ACPI
> > > > [1] and dynamic ACPI [2], which may make the state model complicated.
> > > > 
> > > > 1. Static ACPI - No creation / deletion of acpi_device at hot-plug.
> > > > 2. Dynamic ACPI - Create acpi_device at hot-add, delete at hot-remove.
> > > 
> > > Sure.  The complication here is that we'll need to handle the removal of
> > > a bunch of struct acpi_device objects when a whole table goes away.
> > > 
> > > However, first, we don't seem to handle table unloading now.  At least
> > > acpi_unload_parent_table() is not called from anywhere as far as I can
> > > say.  Second, we'll need to handle the removal of struct acpi_device objects
> > > _anyway_ on table unload, this way or another.
> > 
> > AML is the one that requests loading/unloading of SSDT for dynamic ACPI.
> > In hot-add, _Lxx method executes AML_LOAD_OP or AML_LOAD_TABLE_OP to
> > load SSDT and then sends a notification to the OS.  In hot-remove, _EJ0
> > method executes AML_UNLOAD_OP to unload SSDT.  Of course, ACPICA does
> > the actual work on behalf of AML.  But this is not visible to ACPI core
> > or drivers, unless it checks ACPI namespace to see if any device objects
> > disappeared after _EJ0.
> 
> Oh, we have a handler for that event, but we don't really use it. :-)
> 
> And I wonder what happens to the struct acpi_device objects associated with
> the ACPI handles in the table being unloaded?

If we use an ACPI handle that does not associate with a device object,
ACPICA returns AE_NOT_FOUND or AE_NOT_EXIST.  But, we should remove
acpi_device that does not have its associated ACPI object.  Currently,
we create acpi_device on hot-add and remove it on hot-remove, so it is
OK.  But if we start creating acpi_device objects for non-present
devices, we need to worry about if acpi_device objects indeed have their
associated ACPI objects.  That's the complication I mentioned above.

Thanks,
-Toshi

