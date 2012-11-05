Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2KEK1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:27:13 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab2KEK1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:27:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Mon, 05 Nov 2012 11:31:19 +0100
Message-ID: <4052192.ry8JrGTr6H@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1535917.BaYBBNgGy0@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <20121103201310.GQ16648@intel.com> <1535917.BaYBBNgGy0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 03, 2012 09:59:28 PM Rafael J. Wysocki wrote:
> On Saturday, November 03, 2012 10:13:10 PM Mika Westerberg wrote:
> > On Sat, Nov 03, 2012 at 01:42:02PM -0600, Bjorn Helgaas wrote:
> > > On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
> > > <mika.westerberg@linux.intel.com> wrote:
> > > > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> > > > configure the SPI slave devices behind the SPI controller. This patch adds
> > > > support for this to the SPI core.
[...]
> > And if the ACPI core parses the _CRS, how does it pass all the resources to
> > the drivers?
> 
> Pretty much the same way the $subject patch does.
> 
> Instead of parsing the entire subtree below an SPI controller and trying
> acpi_spi_add_device() for each device node in there, it could call
> acpi_spi_add_device() whenever it finds a device of type
> ACPI_RESOURCE_TYPE_SERIAL_BUS/ACPI_RESOURCE_SERIAL_TYPE_SPI.
> The only problem is how to pass "master" to it.
> 
> So Bjorn, do you have any idea how we could pass the "master" pointer from the
> ACPI core to acpi_spi_add_device() in a sensible way?
> 
> An alternative might be to store the information obtained from _CRS in
> struct acpi_device objects created by the ACPI core while parsing the
> namespace.  We do that already for things like _PRW, so we might as well do it
> for _CRS.  Then, the SPI core could just walk the subtree of the device hierarchy
> below the SPI controller's acpi_device to extract that information.
> Maybe that's the way to go?

The general idea is to move the _CRS parsing routine from acpi_platform.c
to scan.c and make it attach resource objects to struct acpi_device.

I'm thinking about adding a list head to struct acpi_device pointing to a
list of entries like:

struct resource_list_entry {
	struct list_head node;
	struct resource *resources;
	unsigned int count;
};

where "resources" is an array of resources (e.g. interrupts) in the given
entry and count is the size of that array.

That list would contain common resources like ACPI_RESOURCE_TYPE_FIXED_MEMORY32,
ACPI_RESOURCE_TYPE_IRQ, ACPI_RESOURCE_TYPE_ADDRESS32, ACPI_RESOURCE_TYPE_EXTENDED_IRQ.
I think adding it would allow us to make acpi_create_platform_device(),
acpi_spi_add_resources() and acpi_i2c_add_resources() more straightforward (and
remove some code duplication between the last two routines).

In addition to that, I'd add an entry containing serial bus information, if
applicable, for the given struct acpi_device, something like:

union acpi_resource_serial_bus {
	struct acpi_resource_common_serialbus;
	struct acpi_resource_spi_serialbus;
	struct acpi_resource_i2c_serialbus;
	struct acpi_resource_uart_serialbus;
};

struct acpi_device {
	...
	union acpi_resource_serial_bus *serial;
	...
};

Then, things like acpi_spi_add_resources() and acpi_i2c_add_resources() would
be able to use struct acpi_device objects directly without running any AML.

That could be done on top of the current series and I'm going to prepare a patch
for that in the next few days if I find some time between the LCE sessions.

Thanks,
Rafael


--- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
