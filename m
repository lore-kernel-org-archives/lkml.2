Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2KMQeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:34:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:27505 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab2KMQeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:34:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,767,1344236400"; 
   d="scan'208";a="246398692"
From: "Moore, Robert" <robert.moore@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
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
Subject: RE: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
 objects
Thread-Topic: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
 objects
Thread-Index: AQHNwRiioOP9jIS+5UWx2cJd20NobJfn4E6AgAAVKMA=
Date: Tue, 13 Nov 2012 16:34:07 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC0694@ORSMSX101.amr.corp.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <11281928.0BBlrNprhI@vostro.rjw.lan> <20121112144621.GE31759@intel.com>
 <1935553.kFsUz07opN@vostro.rjw.lan> <20121113071208.GF31759@intel.com>
In-Reply-To: <20121113071208.GF31759@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suppose we can just do acpi_get_current_resources() and play with 
> the buffer returned by it.  That won't be nice, but still better than 
> what we have.

A couple of the reasons we created the ACPICA resource manager was to:
1) Simplify host access to the various resource fields, especially packed flags.
2) Avoid alignment issues, especially on machines that don't support misaligned transfers.

If there are issues with the current resource manager, we can discuss them. But I would hope that you really don't want to be fussing around with the raw data coming back from the AML. It is not pretty and we have gone to some lengths to make the entire conversion table-driven to minimize bugs and simplify maintenance.

Bob


> -----Original Message-----
> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: Monday, November 12, 2012 11:12 PM
> To: Rafael J. Wysocki
> Cc: mathias.nyman@linux.intel.com; linux-acpi@vger.kernel.org; linux-
> kernel@vger.kernel.org; lenb@kernel.org; Wysocki, Rafael J;
> broonie@opensource.wolfsonmicro.com; grant.likely@secretlab.ca;
> linus.walleij@linaro.org; khali@linux-fr.org; Bjorn Helgaas; Moore, Robert
> Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
> objects
> 
> On Mon, Nov 12, 2012 at 10:03:56PM +0100, Rafael J. Wysocki wrote:
> > > > +static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
> > > > +					 void *context)
> > > > +{
> > > > +	struct list_head *list = context;
> > > > +	struct acpi_resource_list_entry *entry;
> > > > +
> > > > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > > > +	if (!entry)
> > > > +		return AE_NO_MEMORY;
> > > > +
> > > > +	entry->resource = *res;
> > >
> > > This does not work well with all resource types - specifically those
> > > that contain pointers, like acpi_resource_gpio and
> acpi_resource_source.
> >
> > Good point.
> >
> > Well, this pretty much means we can't copy those things.
> 
> Yeah. I only noticed this yesterday when I tested the GPIO translation in
> a custom driver (since it uses the acpi_resource_gpio).
> 
> > > The memory for the resources gets freed once acpi_walk_resources() is
> done.
> >
> > I know that.
> >
> > Having to evaluate _CRS and creating a buffer, converting the output
> > into ACPI resources and so on every time we need to look into the
> > device's current resources is totally inefficient.  We _need_ to cache
> the _CRS output.
> 
> I agree and besides having adev->resources is much easier to use than
> calling acpi_walk_resources() everytime.
> 
> > Now, because of the pointers in certain types of resources, we can't
> > make copies of the resource objects used by acpi_walk_resources()
> > which makes that function totally unuseful to us.
> >
> > I suppose we can just do acpi_get_current_resources() and play with
> > the buffer returned by it.  That won't be nice, but still better than
> > what we have.
> 
> I don't know any better option.
> 
> Thanks.
