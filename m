Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2KMWGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:06:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:60948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab2KMWGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:06:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="168001262"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
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
Subject: RE: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
 objects
Thread-Topic: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
 objects
Thread-Index: AQHNwRiioOP9jIS+5UWx2cJd20NobJfn4E6AgAAVKMCAAM23gP//j3Mw
Date: Tue, 13 Nov 2012 22:06:03 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC083A@ORSMSX101.amr.corp.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121113071208.GF31759@intel.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E346BC0694@ORSMSX101.amr.corp.intel.com>
 <2586712.Jsv1H95qXQ@vostro.rjw.lan>
In-Reply-To: <2586712.Jsv1H95qXQ@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qADM6LvC018139

I may not quite understand what you are asking for, but I will try. It seems like we already have much of what you want/need, so maybe I'm missing something.



> So what I would like to have, in general terms, is something like
> acpi_walk_resources() split into three parts:
> 
>  (1) One that processes the _CRS output and creates a list of
>      struct acpi_resource objects for us to play with.  I suppose
>      it's OK if that's just a buffer filled with resource objects,
>      but a linked list might be more convenient.
> 

This sounds like AcpiGetCurrentResources. It executes _CRS and formats the data into acpi_resource objects.



>  (2) One that allows us to access (read/write) resources in the
>      list returned by (1).  We don't need to open code walking
>      the list and I probably wouldn't event want to do that.  What
>      we need is to be able to walk the same list for a number of
>      times and possibly to modify values in the resource objects
>      if there are conflicts.

This sounds like AcpiWalkResources. I suppose a possible issue is that currently, AcpiWalkResources actually invokes the _CRS, _PRS, or _AEI method on behalf of the caller. It might make more sense to allow the caller to pass in the resource buffer returned from a call to _CRS, etc.


> 
>  (3) One allowing us to free the list returned by (1) if not needed
>      any more.
> 

AcpiGetCurrentResources: Currently, everything is returned in a single buffer to minimize the number of allocations. A buffer you can free when you are done with it.

I think I saw where you mentioned that you cannot copy this buffer because of internal pointers to other areas of the buffer. Yes. However, we can build linked lists all day if you really want them :-)


> And it would be great if we could take the list returned by (1), modify
> the resources in it and feed it back to _SRS (after conversion back to the
> format that _SRS understands).
> 

AcpiSetCurrentResources.

The AML debugger already has a command that illustrates the use of the various resource interfaces, see dbcmds.c

> Thanks,
> Rafael

Bob





> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Tuesday, November 13, 2012 12:44 PM
> To: Moore, Robert
> Cc: Mika Westerberg; mathias.nyman@linux.intel.com; linux-
> acpi@vger.kernel.org; linux-kernel@vger.kernel.org; lenb@kernel.org;
> Wysocki, Rafael J; broonie@opensource.wolfsonmicro.com;
> grant.likely@secretlab.ca; linus.walleij@linaro.org; khali@linux-fr.org;
> Bjorn Helgaas; Zheng, Lv
> Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
> objects
> 
> On Tuesday, November 13, 2012 04:34:07 PM Moore, Robert wrote:
> > > I suppose we can just do acpi_get_current_resources() and play with
> > > the buffer returned by it.  That won't be nice, but still better
> > > than what we have.
> >
> > A couple of the reasons we created the ACPICA resource manager was to:
> > 1) Simplify host access to the various resource fields, especially
> packed flags.
> > 2) Avoid alignment issues, especially on machines that don't support
> misaligned transfers.
> 
> That's fine.
> 
> > If there are issues with the current resource manager, we can discuss
> them.
> > But I would hope that you really don't want to be fussing around with
> > the raw data coming back from the AML.
> 
> No, I don't. :-)
> 
> I'd like to be able to do more things with struct acpi_resource objects.
> 
> Pretty much the output of acpi_get_current_resources() is what I'm
> interested in, but there doesn't seem to be any convenient way to access
> things in the return buffer from the outside of ACPICA now.
> 
> > It is not pretty and we have gone to some lengths to make the entire
> > conversion table-driven to minimize bugs and simplify maintenance.
> 
> OK
> 
> So what I would like to have, in general terms, is something like
> acpi_walk_resources() split into three parts:
> 
>  (1) One that processes the _CRS output and creates a list of
>      struct acpi_resource objects for us to play with.  I suppose
>      it's OK if that's just a buffer filled with resource objects,
>      but a linked list might be more convenient.
> 
>  (2) One that allows us to access (read/write) resources in the
>      list returned by (1).  We don't need to open code walking
>      the list and I probably wouldn't event want to do that.  What
>      we need is to be able to walk the same list for a number of
>      times and possibly to modify values in the resource objects
>      if there are conflicts.
> 
>  (3) One allowing us to free the list returned by (1) if not needed
>      any more.
> 
> And it would be great if we could take the list returned by (1), modify
> the resources in it and feed it back to _SRS (after conversion back to the
> format that _SRS understands).
> 
> Thanks,
> Rafael
> 
> 
> > > -----Original Message-----
> > > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > > Sent: Monday, November 12, 2012 11:12 PM
> > > To: Rafael J. Wysocki
> > > Cc: mathias.nyman@linux.intel.com; linux-acpi@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; lenb@kernel.org; Wysocki, Rafael J;
> > > broonie@opensource.wolfsonmicro.com; grant.likely@secretlab.ca;
> > > linus.walleij@linaro.org; khali@linux-fr.org; Bjorn Helgaas; Moore,
> > > Robert
> > > Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device
> > > node objects
> > >
> > > On Mon, Nov 12, 2012 at 10:03:56PM +0100, Rafael J. Wysocki wrote:
> > > > > > +static acpi_status acpi_bus_add_resource(struct acpi_resource
> *res,
> > > > > > +					 void *context)
> > > > > > +{
> > > > > > +	struct list_head *list = context;
> > > > > > +	struct acpi_resource_list_entry *entry;
> > > > > > +
> > > > > > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > > > > > +	if (!entry)
> > > > > > +		return AE_NO_MEMORY;
> > > > > > +
> > > > > > +	entry->resource = *res;
> > > > >
> > > > > This does not work well with all resource types - specifically
> > > > > those that contain pointers, like acpi_resource_gpio and
> > > acpi_resource_source.
> > > >
> > > > Good point.
> > > >
> > > > Well, this pretty much means we can't copy those things.
> > >
> > > Yeah. I only noticed this yesterday when I tested the GPIO
> > > translation in a custom driver (since it uses the acpi_resource_gpio).
> > >
> > > > > The memory for the resources gets freed once
> > > > > acpi_walk_resources() is
> > > done.
> > > >
> > > > I know that.
> > > >
> > > > Having to evaluate _CRS and creating a buffer, converting the
> > > > output into ACPI resources and so on every time we need to look
> > > > into the device's current resources is totally inefficient.  We
> > > > _need_ to cache
> > > the _CRS output.
> > >
> > > I agree and besides having adev->resources is much easier to use
> > > than calling acpi_walk_resources() everytime.
> > >
> > > > Now, because of the pointers in certain types of resources, we
> > > > can't make copies of the resource objects used by
> > > > acpi_walk_resources() which makes that function totally unuseful to
> us.
> > > >
> > > > I suppose we can just do acpi_get_current_resources() and play
> > > > with the buffer returned by it.  That won't be nice, but still
> > > > better than what we have.
> > >
> > > I don't know any better option.
> > >
> > > Thanks.
> >
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
