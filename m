Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2KMUju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:39:50 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2KMUjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:39:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "Zheng, Lv" <lv.zheng@intel.com>
Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node objects
Date: Tue, 13 Nov 2012 21:44:09 +0100
Message-ID: <2586712.Jsv1H95qXQ@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC0694@ORSMSX101.amr.corp.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <20121113071208.GF31759@intel.com> <94F2FBAB4432B54E8AACC7DFDE6C92E346BC0694@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 04:34:07 PM Moore, Robert wrote:
> > I suppose we can just do acpi_get_current_resources() and play with 
> > the buffer returned by it.  That won't be nice, but still better than 
> > what we have.
> 
> A couple of the reasons we created the ACPICA resource manager was to:
> 1) Simplify host access to the various resource fields, especially packed flags.
> 2) Avoid alignment issues, especially on machines that don't support misaligned transfers.

That's fine.

> If there are issues with the current resource manager, we can discuss them.
> But I would hope that you really don't want to be fussing around with the raw
> data coming back from the AML.

No, I don't. :-)

I'd like to be able to do more things with struct acpi_resource objects.

Pretty much the output of acpi_get_current_resources() is what I'm
interested in, but there doesn't seem to be any convenient way to access
things in the return buffer from the outside of ACPICA now.

> It is not pretty and we have gone to some lengths to make the entire
> conversion table-driven to minimize bugs and simplify maintenance.

OK

So what I would like to have, in general terms, is something like
acpi_walk_resources() split into three parts:

 (1) One that processes the _CRS output and creates a list of
     struct acpi_resource objects for us to play with.  I suppose
     it's OK if that's just a buffer filled with resource objects,
     but a linked list might be more convenient.

 (2) One that allows us to access (read/write) resources in the
     list returned by (1).  We don't need to open code walking
     the list and I probably wouldn't event want to do that.  What
     we need is to be able to walk the same list for a number of
     times and possibly to modify values in the resource objects
     if there are conflicts.

 (3) One allowing us to free the list returned by (1) if not needed
     any more.

And it would be great if we could take the list returned by (1),
modify the resources in it and feed it back to _SRS (after conversion
back to the format that _SRS understands).

Thanks,
Rafael


> > -----Original Message-----
> > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > Sent: Monday, November 12, 2012 11:12 PM
> > To: Rafael J. Wysocki
> > Cc: mathias.nyman@linux.intel.com; linux-acpi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; lenb@kernel.org; Wysocki, Rafael J;
> > broonie@opensource.wolfsonmicro.com; grant.likely@secretlab.ca;
> > linus.walleij@linaro.org; khali@linux-fr.org; Bjorn Helgaas; Moore, Robert
> > Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
> > objects
> > 
> > On Mon, Nov 12, 2012 at 10:03:56PM +0100, Rafael J. Wysocki wrote:
> > > > > +static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
> > > > > +					 void *context)
> > > > > +{
> > > > > +	struct list_head *list = context;
> > > > > +	struct acpi_resource_list_entry *entry;
> > > > > +
> > > > > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > > > > +	if (!entry)
> > > > > +		return AE_NO_MEMORY;
> > > > > +
> > > > > +	entry->resource = *res;
> > > >
> > > > This does not work well with all resource types - specifically those
> > > > that contain pointers, like acpi_resource_gpio and
> > acpi_resource_source.
> > >
> > > Good point.
> > >
> > > Well, this pretty much means we can't copy those things.
> > 
> > Yeah. I only noticed this yesterday when I tested the GPIO translation in
> > a custom driver (since it uses the acpi_resource_gpio).
> > 
> > > > The memory for the resources gets freed once acpi_walk_resources() is
> > done.
> > >
> > > I know that.
> > >
> > > Having to evaluate _CRS and creating a buffer, converting the output
> > > into ACPI resources and so on every time we need to look into the
> > > device's current resources is totally inefficient.  We _need_ to cache
> > the _CRS output.
> > 
> > I agree and besides having adev->resources is much easier to use than
> > calling acpi_walk_resources() everytime.
> > 
> > > Now, because of the pointers in certain types of resources, we can't
> > > make copies of the resource objects used by acpi_walk_resources()
> > > which makes that function totally unuseful to us.
> > >
> > > I suppose we can just do acpi_get_current_resources() and play with
> > > the buffer returned by it.  That won't be nice, but still better than
> > > what we have.
> > 
> > I don't know any better option.
> > 
> > Thanks.
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
