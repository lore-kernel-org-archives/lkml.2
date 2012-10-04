Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2JDWB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:01:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62166 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2JDWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <15022838.BvGHsiOjXu@vostro.rjw.lan>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<16287303.8DVGGcjq5E@vostro.rjw.lan>
	<CAE9FiQU=h8mchDHCQ31U-UpPhqmFiO_H5yX2uonsyOh3tK9DYA@mail.gmail.com>
	<15022838.BvGHsiOjXu@vostro.rjw.lan>
Date: Thu, 4 Oct 2012 15:01:21 -0700
X-Google-Sender-Auth: tFAiLnADNKTBJeqNmi8GUZtkI2g
Message-ID: <CAE9FiQXDBaiwckKsUi4k34=O1GnkTOJf+mG33cKHDp8RGqrsnA@mail.gmail.com>
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

On Thu, Oct 4, 2012 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 04 of October 2012 14:31:46 Yinghai Lu wrote:
>> On Thu, Oct 4, 2012 at 2:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>
>> >> At last we could remove all acpi_bus_start workaround.
>> >
>> > Do I understand correctly that you just want to prevent acpi_pci_root_driver
>> > from binding to the host bridge's struct acpi_device created while we're
>> > walking the ACPI namespace?
>>
>> yes, during hot add path.
>
> Why exactly do you want to prevent that from happening?
>

during adding pci root bus hotplug, Bjorn found some unsafe searching
that caused by pci_bus_add_devices.
pci devices are created during pci scan root, but until very late
acpi_pci_root_start call pci_bus_add_devices.

To fill the gap, we need to move pci_bus_add_devices to acpi_pci_root_add
at first.

but after we move that there, pci device will be added to device tree, and it
will try to bind with acpi devices that should be under acpi pci root,
but are not
created yet. because device_add for acpi_device for acpi pci root is done yet.
it still calling the .add in the acpi_driver aka acpi_pci_root_add.

So I want to hold the driver attach for pci root acpi devices, and
later attach it
until pci devices created.

booting path, all acpi devices get created, and attach driver for them
one by one.
