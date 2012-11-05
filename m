Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab2KEQzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:55:07 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61342 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2KEQzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:55:04 -0500
MIME-Version: 1.0
In-Reply-To: <4052192.ry8JrGTr6H@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121103201310.GQ16648@intel.com> <1535917.BaYBBNgGy0@vostro.rjw.lan> <4052192.ry8JrGTr6H@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Nov 2012 09:54:42 -0700
Message-ID: <CAErSpo6gfL+QFoWK+8ahYAj+vnp4OCn4B=-vALGbU_LnsyT8oQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, November 03, 2012 09:59:28 PM Rafael J. Wysocki wrote:
>> On Saturday, November 03, 2012 10:13:10 PM Mika Westerberg wrote:
>> > On Sat, Nov 03, 2012 at 01:42:02PM -0600, Bjorn Helgaas wrote:
>> > > On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
>> > > <mika.westerberg@linux.intel.com> wrote:
>> > > > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
>> > > > configure the SPI slave devices behind the SPI controller. This patch adds
>> > > > support for this to the SPI core.
> [...]
>> > And if the ACPI core parses the _CRS, how does it pass all the resources to
>> > the drivers?
>>
>> Pretty much the same way the $subject patch does.
>>
>> Instead of parsing the entire subtree below an SPI controller and trying
>> acpi_spi_add_device() for each device node in there, it could call
>> acpi_spi_add_device() whenever it finds a device of type
>> ACPI_RESOURCE_TYPE_SERIAL_BUS/ACPI_RESOURCE_SERIAL_TYPE_SPI.
>> The only problem is how to pass "master" to it.
>>
>> So Bjorn, do you have any idea how we could pass the "master" pointer from the
>> ACPI core to acpi_spi_add_device() in a sensible way?
>>
>> An alternative might be to store the information obtained from _CRS in
>> struct acpi_device objects created by the ACPI core while parsing the
>> namespace.  We do that already for things like _PRW, so we might as well do it
>> for _CRS.  Then, the SPI core could just walk the subtree of the device hierarchy
>> below the SPI controller's acpi_device to extract that information.
>> Maybe that's the way to go?
>
> The general idea is to move the _CRS parsing routine from acpi_platform.c
> to scan.c and make it attach resource objects to struct acpi_device.
>
> I'm thinking about adding a list head to struct acpi_device pointing to a
> list of entries like:
>
> struct resource_list_entry {
>         struct list_head node;
>         struct resource *resources;
>         unsigned int count;
> };
>
> where "resources" is an array of resources (e.g. interrupts) in the given
> entry and count is the size of that array.
>
> That list would contain common resources like ACPI_RESOURCE_TYPE_FIXED_MEMORY32,
> ACPI_RESOURCE_TYPE_IRQ, ACPI_RESOURCE_TYPE_ADDRESS32, ACPI_RESOURCE_TYPE_EXTENDED_IRQ.

This is exactly what PNPACPI already does.  For every Device node in
the namespace, pnpacpi/rsparser.c parses _CRS and builds a list of
struct resources that correspond to it.  If you put this functionality
in acpi/scan.c, should we get rid of PNPACPI?

Bjorn
