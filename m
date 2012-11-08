Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2KHSFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:05:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab2KHSFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121107095842.GY24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo44pWUJmRAP6eR9T+2WvO5hJPFOC=Nn-WPXDtCY0v0EDw@mail.gmail.com>
 <1996776.cC14CHafyR@vostro.rjw.lan> <2584820.Vd5p0uzRAK@vostro.rjw.lan> <20121107095842.GY24532@intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 8 Nov 2012 18:05:23 +0000
X-Google-Sender-Auth: ZgnZGZDu5kORO11oIzKzxx8SznA
Message-ID: <CACxGe6sUXWLZVBpD1we_ZAXA7wvMg72DQpyCw5f+E8c5_ox++w@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 9:58 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Nov 06, 2012 at 11:36:08PM +0100, Rafael J. Wysocki wrote:
>> >
>> > OK, but then we need to pass the information obtained from _CRS
>> > (presumably after some adjustments through _SRS) to drivers, or rather to
>> > things like the SPI core, I2C core etc. so that they can create device
>> > objects for drivers to bind to and quite frankly I don't see why not to use
>> > ACPI resources for that.
>>
>> Nevertheless, the routines for parsing those resources should belong
>> to the ACPI core, mostly to avoid code duplication.
>
> Rafael,
>
> So is the idea now that the ACPI core parses the resources and passes them
> forward via struct acpi_device? I'm just wondering how to proceed with
> these I2C and SPI enumeration patches.

>From my experience with device tree, that seems the wrong way around.
Device Tree used to have a separate "of_device" which is analogous to
an acpi_device. The problem was always that of_devices never fit into
the view that Linux has of the system. That would mean having both an
of_device and and spi_device in completely separate parts of the
driver model tree to support an spi device. Same for platform, i2c and
onewire and others. Blech.

So, yes I agree that ACPI core should have the tools for parsing the
resources, but it makes sense for those functions to be helpers that
the spi core acpi support and the i2c core acpi support use to
populate the native spi_device and i2c_client structures. Plus
individual drivers can call the same functions if (and only if) the
needed resources cannot fit into the bus type's native format.

We really could also use more common code between bus types for
storing various kinds of resources, but that's a separate issue and
doesn't affect this discussion.

g.
