Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2JDWqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:46:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50713 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2JDWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <1938257.EXdpWtCqiy@vostro.rjw.lan>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<15022838.BvGHsiOjXu@vostro.rjw.lan>
	<CAE9FiQXDBaiwckKsUi4k34=O1GnkTOJf+mG33cKHDp8RGqrsnA@mail.gmail.com>
	<1938257.EXdpWtCqiy@vostro.rjw.lan>
Date: Thu, 4 Oct 2012 15:46:39 -0700
X-Google-Sender-Auth: fhwHjEeQBQ_kw5uvjFZ5P2vPDoc
Message-ID: <CAE9FiQXZqBE6BmQ5v-vDq2E5vmyU5QRNrjjYRYONQu6jiHGD6w@mail.gmail.com>
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 3:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 04 of October 2012 15:01:21 Yinghai Lu wrote:
>> during adding pci root bus hotplug, Bjorn found some unsafe searching
>> that caused by pci_bus_add_devices.
>
> Do you have a link to a description of that problem?

Maybe bjorn could expand it more.

>
>> pci devices are created during pci scan root, but until very late
>> acpi_pci_root_start call pci_bus_add_devices.
>
> So you mean that pci_bus_add_devices() is called too late, right?

yes.

>
>> To fill the gap, we need to move pci_bus_add_devices to acpi_pci_root_add
>> at first.
>>
>> but after we move that there, pci device will be added to device tree, and it
>> will try to bind with acpi devices that should be under acpi pci root,
>> but are not
>> created yet. because device_add for acpi_device for acpi pci root is done yet.
>> it still calling the .add in the acpi_driver aka acpi_pci_root_add.
>
> Quite obviously, we haven't walked the ACPI namespace below the host bridge
> object yet at that point.

yes.

>
>> So I want to hold the driver attach for pci root acpi devices, and
>> later attach it
>> until pci devices created.
>>
>> booting path, all acpi devices get created, and attach driver for them
>> one by one.
>
> I see.
>
> Your patches seem to affect all devices in the ACPI namespace added after
> boot, though, not only host bridges.

yes, but it still should be safe.

>
> And the problem seems to be that the scanning of the ACPI namespace and
> configuring the host bridge are kind of independent operations now.  What
> we should do, actually, seems to be something like this:
>
> (1) Configure the host bridge when discovered (i.e. do what the current
>     acpi_pci_root_add() does.
> (2) Parse the ACPI namespace under the host bridge (without binding ACPI
>     drivers to the struct acpi_device objects created in the process,
>     because they are known to correspond to PCI devices).
> (3) Run pci_bus_add_devices() for the bridge.
>
> in one routine.

problem is still there. if 1 still has acpi_pci_root_add and pci_acpi_scan_root
that scan pci devices. what is need is we need to bind 1 and 3 together.

or we could move pci_scan_root_scan from acpi_pci_root_add to
acpi_pci_root_start?
