Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab1FWSat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:30:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab1FWRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:14 -0400
Date: Thu, 23 Jun 2011 13:22:06 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, lm-sensors@lm-sensors.org,
        linux-i2c@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, rtc-linux@googlegroups.com,
        evel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-watchdog@vger.kernel.org
Cc: grant.likely@secretlab.ca, dz@debian.org, rpurdie@rpsys.net,
        eric.piel@tremplin-utc.net, abelay@mit.edu, johnpol@2ka.mipt.ru,
        Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172206.27602.34306.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 00/35]: System Firmware and SMBIOS Support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMI, or the Desktop Management Interface, provides access to OEM and hardware
specific details about the x86 or ia64 system the kernel is currently runnig
on.  DMI has been deprecated since 2003, which was the last update of the DMI
Specification.

The System Management BIOS, or SMBIOS, supercedes DMI -- the SMBIOS tables
include the possibility of a _DMI_ entry and tables.  However, in the
Linux kernel we do not access any of the DMI data and only access SMBIOS data.

Currently, the kernel uses dmi_* functions (as defined in
drivers/firmware/dmi_scan.c) to access the data.  The functions allow kernel
subsystems and modules to set specific options based on the platform and BIOS
version.

The dmi_* functions in the kernel fail in several ways.  First, as
mentioned the dmi_* functions are really accessing SMBIOS data.  The existing
code queries for the _SMB_ entry and determines data access after that.  The
existing dmi_* functions create an array of x86 and ia64 specific entries
which are defined as part of x86 and ia64 specific udev entries, and allows
drivers and subsystems to make platform specific decisions.  In addition to
the arch specific code, the dmi_* code creates a list of "devices" to which
makes updating very difficult and does not easily scale.

Another key issue with the existing code is that several drivers do their
own search through the SMBIOS, for example, see drivers/pci/hotplug/cpqphp*.c.

Two months (or so) ago I proposed a patch which was based on a simple request
from a colleague --  create a sysfs file that would export the SMBIOS version.
This simple request was not something that was easy to do given the layout of
the existing DMI code.  The request resulted in having to create a new smbios
class within the kernel, and essentially doing a separate search through
memory.

This new patchset reworks the existing DMI code into two separate layers.  It is
based off of the feedback I received previously when discussing the SMBIOS
version patch on LKML.

The first layer is the System Firmware Interface, which is based upon Alan
Cox's suggestion of a common platform driver (unfortunately, platform driver
is already defined and used within the kernel).  This is meant to be an
arch independent subsystem in the kernel for all arches.  It is a common
interface which provides access to specific system values in the kernel such
as the Chassis Manufacturer, the BIOS developer, or the BIOS date.  The
System Firmware Interface, or sysfw allows for easy updating by simply adding
fields to an array in include/linux/mod_devicetable.h.
Standard simple searching functions, sysfw_lookup() and sysfw_callback()
are provided to the kernel and modules.  sysfw_callback() is similar to
dmi_check_system() but the new function allows for exact matching which some
drivers required.

The second layer introduced in this patchset is the SMBIOS sysfw driver.  This
driver (obviously) registers with the interface and also provides it's own
interface.  The reason for the separate interface is that specific drivers
have their own need to search the SMBIOS for OEM or platform specific
information (see, for example, drivers/watchdog/hpwdt.c, or
drivers/pci/pci-label.c).  This new driver provides a function, smbios_walk()
which allows individual drivers or subsystems to traverse the SMBIOS table
looking for OEM or platform specific data.  The new SMBIOS driver can be
easily updated by adding SMBIOS structure information to the smbios_struct
union in include/linux/smbios.h.

These changes are targeted for at least 3.2.

A git tree with these changes has been set up here:

git://git.kernel.org/pub/scm/linux/kernel/git/prarit/smbios.git

with the latest changes in the smbios-3.0-rc4 branch.

P.
