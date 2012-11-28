Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab2K1Vuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:50:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35495 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab2K1Vue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:50:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via .sys_notify
Date: Wed, 28 Nov 2012 22:55:18 +0100
Message-ID: <12655874.tBYV6dRMny@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1354137803.26955.325.camel@misato.fc.hp.com>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com> <5550104.xSe1fX9Ich@vostro.rjw.lan> <1354137803.26955.325.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 02:23:23 PM Toshi Kani wrote:
> On Wed, 2012-11-28 at 22:09 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, November 28, 2012 01:31:39 PM Toshi Kani wrote:
> > > On Wed, 2012-11-28 at 19:28 +0100, Rafael J. Wysocki wrote:
> > > > On Wednesday, November 28, 2012 09:54:43 AM Toshi Kani wrote:
> > > > > > > > > > By using acpi_install_notify_handler(), each driver needs to walk
> > > > > > > > > > through the entire ACPI namespace to find its associated ACPI devices
> > > > > > > > > > and call it to register one by one.  I think this is more work for
> > > > > > > > > > non-ACPI drivers than defining acpi_driver.
> > > > > > > > > 
> > > > > > > > > I'm not really sure what you mean.  The drivers in question already know
> > > > > > > > > what the relevant ACPI device nodes are (because they need them anyway
> > > > > > > > > for other purposes), so they don't need to look for them specifically and
> > > > > > > > > acpi_install_notify_handler() doesn't do any namespace walking.  So what
> > > > > > > > > you said above simply doesn't make sense from this viewpoint.
> > > > > > > > 
> > > > > > > > Yes, if drivers already know the relevant ACPI devices, then walking the
> > > > > > > > ACPI namespace is not necessary.  I was referring the case like
> > > > > > > > processor_driver.c, acpi_memhotplug.c, and container.c in my statement. 
> > > > > > > 
> > > > > > > BTW, when an ACPI device is marked as non-present, which is the case
> > > > > > > before hot-add, we do not create an acpi_device object and therefore do
> > > > > > > not bind it with a driver.  This is why these drivers walk the ACPI
> > > > > > > namespace and install their notify handlers regardless of device status.
> > > > > > 
> > > > > > So maybe we should create struct acpi_device objects in that case too?
> > > > > 
> > > > > I think it has some challenge as well.  We bind an ACPI driver with
> > > > > device_register(), which calls device_add()-> kobject_add().  So, all
> > > > > non-present ACPI device objects will show up in sysfs, unless we can
> > > > > change the core.  This will change user interface.  There can be quite
> > > > > many non-present devices in ACPI namespace depending on FW
> > > > > implementation.
> > > > 
> > > > If additional devices appear in sysfs, that's not a problem.  If there
> > > > were fewer of them, that would be a real one. :-)
> > > 
> > > I see.  I guess this means that once we expose all non-present devices
> > > in sysfs, we cannot go back to the current way.  So, we need to be very
> > > careful.  Anyway, this model requires separate handling for static ACPI
> > > [1] and dynamic ACPI [2], which may make the state model complicated.
> > > 
> > > 1. Static ACPI - No creation / deletion of acpi_device at hot-plug.
> > > 2. Dynamic ACPI - Create acpi_device at hot-add, delete at hot-remove.
> > 
> > Sure.  The complication here is that we'll need to handle the removal of
> > a bunch of struct acpi_device objects when a whole table goes away.
> > 
> > However, first, we don't seem to handle table unloading now.  At least
> > acpi_unload_parent_table() is not called from anywhere as far as I can
> > say.  Second, we'll need to handle the removal of struct acpi_device objects
> > _anyway_ on table unload, this way or another.
> 
> AML is the one that requests loading/unloading of SSDT for dynamic ACPI.
> In hot-add, _Lxx method executes AML_LOAD_OP or AML_LOAD_TABLE_OP to
> load SSDT and then sends a notification to the OS.  In hot-remove, _EJ0
> method executes AML_UNLOAD_OP to unload SSDT.  Of course, ACPICA does
> the actual work on behalf of AML.  But this is not visible to ACPI core
> or drivers, unless it checks ACPI namespace to see if any device objects
> disappeared after _EJ0.

Oh, we have a handler for that event, but we don't really use it. :-)

And I wonder what happens to the struct acpi_device objects associated with
the ACPI handles in the table being unloaded?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
