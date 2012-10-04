Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2JDWd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:33:27 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2JDWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:33:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Date: Fri, 05 Oct 2012 00:36:52 +0200
Message-ID: <1938257.EXdpWtCqiy@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.4.6-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQXDBaiwckKsUi4k34=O1GnkTOJf+mG33cKHDp8RGqrsnA@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com> <15022838.BvGHsiOjXu@vostro.rjw.lan> <CAE9FiQXDBaiwckKsUi4k34=O1GnkTOJf+mG33cKHDp8RGqrsnA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 of October 2012 15:01:21 Yinghai Lu wrote:
> On Thu, Oct 4, 2012 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday 04 of October 2012 14:31:46 Yinghai Lu wrote:
> >> On Thu, Oct 4, 2012 at 2:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >>
> >> >> At last we could remove all acpi_bus_start workaround.
> >> >
> >> > Do I understand correctly that you just want to prevent acpi_pci_root_driver
> >> > from binding to the host bridge's struct acpi_device created while we're
> >> > walking the ACPI namespace?
> >>
> >> yes, during hot add path.
> >
> > Why exactly do you want to prevent that from happening?
> >
> 
> during adding pci root bus hotplug, Bjorn found some unsafe searching
> that caused by pci_bus_add_devices.

Do you have a link to a description of that problem?

> pci devices are created during pci scan root, but until very late
> acpi_pci_root_start call pci_bus_add_devices.

So you mean that pci_bus_add_devices() is called too late, right?

> To fill the gap, we need to move pci_bus_add_devices to acpi_pci_root_add
> at first.
> 
> but after we move that there, pci device will be added to device tree, and it
> will try to bind with acpi devices that should be under acpi pci root,
> but are not
> created yet. because device_add for acpi_device for acpi pci root is done yet.
> it still calling the .add in the acpi_driver aka acpi_pci_root_add.

Quite obviously, we haven't walked the ACPI namespace below the host bridge
object yet at that point.

> So I want to hold the driver attach for pci root acpi devices, and
> later attach it
> until pci devices created.
> 
> booting path, all acpi devices get created, and attach driver for them
> one by one.

I see.

Your patches seem to affect all devices in the ACPI namespace added after
boot, though, not only host bridges.

And the problem seems to be that the scanning of the ACPI namespace and
configuring the host bridge are kind of independent operations now.  What
we should do, actually, seems to be something like this:

(1) Configure the host bridge when discovered (i.e. do what the current
    acpi_pci_root_add() does.
(2) Parse the ACPI namespace under the host bridge (without binding ACPI
    drivers to the struct acpi_device objects created in the process,
    because they are known to correspond to PCI devices).
(3) Run pci_bus_add_devices() for the bridge.

in one routine.

What do you think?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
