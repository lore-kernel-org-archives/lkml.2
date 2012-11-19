Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2KSRk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:40:57 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:53344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab2KSRk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:40:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI / platform: Initialize ACPI handles of platform devices in advance
Date: Mon, 19 Nov 2012 18:45:22 +0100
Message-ID: <12675091.beenkZth4X@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1855340.enMgVW1AIC@vostro.rjw.lan>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <20121119162334.GA1653@kroah.com> <1855340.enMgVW1AIC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 19, 2012 06:32:06 PM Rafael J. Wysocki wrote:
> On Monday, November 19, 2012 08:23:34 AM Greg Kroah-Hartman wrote:
> > On Sun, Nov 18, 2012 at 10:13:59PM +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > The current platform device creation and registration code in
> > > acpi_create_platform_device() is quite convoluted.  This function
> > > takes an ACPI device node as an argument and eventually calls
> > > platform_device_register_resndata() to create and register a
> > > platform device object on the basis of the information contained
> > > in that code.  However, it doesn't associate the new platform
> > > device with the ACPI node directly, but instead it relies on
> > > acpi_platform_notify(), called from within device_add(), to find
> > > that ACPI node again with the help of acpi_platform_find_device()
> > > and acpi_platform_match() and then attach the new platform device
> > > to it.  This causes an additional ACPI namespace walk to happen and
> > > is clearly suboptimal.
> > > 
> > > Use the observation that it is now possible to initialize the ACPI
> > > handle of a device before calling device_add() for it to make this
> > > code more straightforward.  Namely, add a new field to struct
> > > platform_device_info allowing us to pass the ACPI handle of interest
> > > to platform_device_register_full(), which will then use it to
> > > initialize the new device's ACPI handle before registering it.
> > > This will cause acpi_platform_notify() to use the ACPI handle from
> > > the device structure directly instead of using the .find_device()
> > > routine provided by the device's bus type.  In consequence,
> > > acpi_platform_bus, acpi_platform_find_device(), and
> > > acpi_platform_match() are not necessary any more, so remove them.
> > 
> > Why can't you use the platform_data * that is already in struct device
> > for this, instead of adding an acpi-specific field to the
> > platform_device structure?
> 
> Hmm, I kind of don't understand the question. :-)
> 
> Yes, we have acpi_handle in struct device (it actually is being added by a
> patch you've acked) and we use it.  The whole point here is to streamline
> of the initalization of that field.
> 
> > If not that, surely there is another field in struct device that you
> > could use that is free for this type of device?
> 
> Yes, there is one and as I said above. :-)
> 
> I'd be happy to use the struct device's field directly, but
> platform_device_register_full() allocates memory for the struct device in
> question, so that field actually doesn't exist yet when it is called.
> 
> > >  struct platform_device_info {
> > >  		struct device *parent;
> > > +		void *acpi_handle;
> > 
> > Oh, and if I do accept this, I want a "real" structure pointer here
> > please, not a void * "handle".  That way is a slippery slope to the
> > Windows kernel programming style :)
> 
> This is (void *), because the field being initialized is (void *).  That field,
> in turn, is (void *), because ACPICA defines it that way.  I thought about
> wrapping that in some more meaningless data type, but I did't find a way

s/meaningless/meaningful/

(/me hides)


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
