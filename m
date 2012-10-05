Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2JEXKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 19:10:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62973 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2JEXKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 19:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <1595267.JDdDB2dfnM@vostro.rjw.lan>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<1938257.EXdpWtCqiy@vostro.rjw.lan>
	<CAE9FiQXZqBE6BmQ5v-vDq2E5vmyU5QRNrjjYRYONQu6jiHGD6w@mail.gmail.com>
	<1595267.JDdDB2dfnM@vostro.rjw.lan>
Date: Fri, 5 Oct 2012 16:10:43 -0700
X-Google-Sender-Auth: 44wywy_LSxWpyW9ofebwZAHh4po
Message-ID: <CAE9FiQXraKirjQgRad2t87SmxsonDupkpE2BM6Ktx8yUdCPPiQ@mail.gmail.com>
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

On Fri, Oct 5, 2012 at 4:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 04 of October 2012 15:46:39 Yinghai Lu wrote:
>> > Your patches seem to affect all devices in the ACPI namespace added after
>> > boot, though, not only host bridges.
>>
>> yes, but it still should be safe.
>
> I'm not really sure of that (what about undock/dock, for exmaple?) and it's
> damn ugly.

only one acpi_driver has .start , that is acpi_pci_root_driver.

should be clean than with .add/start pair.

>
>> > And the problem seems to be that the scanning of the ACPI namespace and
>> > configuring the host bridge are kind of independent operations now.  What
>> > we should do, actually, seems to be something like this:
>> >
>> > (1) Configure the host bridge when discovered (i.e. do what the current
>> >     acpi_pci_root_add() does.
>> > (2) Parse the ACPI namespace under the host bridge (without binding ACPI
>> >     drivers to the struct acpi_device objects created in the process,
>> >     because they are known to correspond to PCI devices).
>> > (3) Run pci_bus_add_devices() for the bridge.
>> >
>> > in one routine.
>>
>> problem is still there. if 1 still has acpi_pci_root_add and pci_acpi_scan_root
>
> OK, so why don't we do (2) in acpi_pci_root_add(), before pci_acpi_scan_root()
> is called?
>
>> that scan pci devices. what is need is we need to bind 1 and 3 together.

some one already walk the acpi space, and during that it create
acpi_device for pci_root
and then attach driver for that, aka acpi_pci_root_add is executing.

Now you want to walking the acpi acpi space to create children devices
before device_add really done for that pci root
acpi device. ?

is that some kind of nesting?

>
> I don't understand now.  You said previously that we need the ACPI namespace
> below the bridge to be scanned before (3), so why do you want to do (3) before
> (2) now?

purpose is calling pci_bus_add_devices in pci_acpi_scan_root.

Yinghai
