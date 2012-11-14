Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006Ab2KNJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:28:16 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:43154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab2KNJ2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:28:13 -0500
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
Date: Wed, 14 Nov 2012 10:32:33 +0100
Message-ID: <4910900.pJ82TKumIi@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5571446.V5xhWp9giY@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <94F2FBAB4432B54E8AACC7DFDE6C92E346BC08EB@ORSMSX101.amr.corp.intel.com> <5571446.V5xhWp9giY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2012 10:18:46 AM Rafael J. Wysocki wrote:
> On Wednesday, November 14, 2012 02:23:51 AM Moore, Robert wrote:
> > Rafael,
> > 
> > I sounds like with a few changes, we can enhance this mechanism to
> > be more useful to you and others. Some comments below. I need to look
> > at the code in question a bit more, but I see no insurmountable issues.
> 
> Great, thanks!
>  
> 
> > > -----Original Message-----
> > > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > > Sent: Tuesday, November 13, 2012 2:57 PM
> > > To: Moore, Robert
> > > Cc: Mika Westerberg; mathias.nyman@linux.intel.com; linux-
> > > acpi@vger.kernel.org; linux-kernel@vger.kernel.org; lenb@kernel.org;
> > > Wysocki, Rafael J; broonie@opensource.wolfsonmicro.com;
> > > grant.likely@secretlab.ca; linus.walleij@linaro.org; khali@linux-fr.org;
> > > Bjorn Helgaas; Zheng, Lv
> > > Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
> > > objects
> > > 
> > > On Tuesday, November 13, 2012 10:06:03 PM Moore, Robert wrote:
> > > > I may not quite understand what you are asking for, but I will try.
> > > > It seems like we already have much of what you want/need, so maybe I'm
> > > > missing something.
> > > 
> > > I think all of the necessary pieces are there.
> > > 
> > > > > So what I would like to have, in general terms, is something like
> > > > > acpi_walk_resources() split into three parts:
> > > > >
> > > > >  (1) One that processes the _CRS output and creates a list of
> > > > >      struct acpi_resource objects for us to play with.  I suppose
> > > > >      it's OK if that's just a buffer filled with resource objects,
> > > > >      but a linked list might be more convenient.
> > > > >
> > > >
> > > > This sounds like AcpiGetCurrentResources. It executes _CRS and formats
> > > > the data into acpi_resource objects.
> > > 
> > > Yes, it does.  However, it is not completely clear to me if/how the caller
> > > is supposed to prepare the buffer object pointed to by the second arg.
> > > 
> > > If the buffer is initialized by AcpiGetCurrentResources, then that's what
> > > I need for (1).
> > 
> > 
> > It looks to me that at least AcpiGetCurrentResources does not actually ever
> > allocate a buffer for the resource template, it expects the caller to
> > eventually provide one of at least the size of the returned resource template.
> > 
> > This is really quite a bit out-of-date as far as the memory allocation model.
> > It should also support the option to just allocate the buffer of the appropriate
> > size before returning it to the caller.
> 
> Yes, that would be really useful.
> 
> Ideally, I'd like to be able to pass a pointer to an uninitialized buffer
> structure to it (or to a wrapper around it) and get a buffer full of
> struct acpi_resource objects (if _CRS returns any) back from it. :-)

Of course, I can add such a wrapper in the Linux-specific code just fine.


> > > > >  (2) One that allows us to access (read/write) resources in the
> > > > >      list returned by (1).  We don't need to open code walking
> > > > >      the list and I probably wouldn't event want to do that.  What
> > > > >      we need is to be able to walk the same list for a number of
> > > > >      times and possibly to modify values in the resource objects
> > > > >      if there are conflicts.
> > > >
> > > > This sounds like AcpiWalkResources. I suppose a possible issue is that
> > > > currently, AcpiWalkResources actually invokes the _CRS, _PRS, or _AEI
> > > > method on behalf of the caller.
> > > 
> > > Yes, that exactly is the problem.
> > > 
> > > > It might make more sense to allow the caller to pass in the resource
> > > > buffer returned from a call to _CRS, etc.
> > > 
> > > Yes! :-)
> > 
> > 
> > I'll take a closer look at this tomorrow.
> 
> Cool, thanks!
> 
> 
> > > > >  (3) One allowing us to free the list returned by (1) if not needed
> > > > >      any more.
> > > > >
> > > >
> > > > AcpiGetCurrentResources: Currently, everything is returned in a single
> > > > buffer to minimize the number of allocations. A buffer you can free
> > > > when you are done with it.
> > > 
> > > I suppose I should use ACPI_FREE(buffer.pointer) for that, but isn't it
> > > for the ACPICA's internal use only?
> > > 
> > > Besides, I would prefer to be able to pass just "buffer" for freeing,
> > > without having to touch its internals.  No big deal, but it would be
> > > nicer. :-)
> > 
> > 
> > The ACPI_BUFFER type is in fact a public type that is meant to return both the
> > buffer and the (actual) length. You will find many instances of
> > ACPI_FREE(buffer.pointer) within existing linux code, since it also used for
> > objects returned by control method execution/object evaluation.
> 
> Well, I suppose I only wanted to say that acpi_free_buffer(buffer) would look
> a bit more straightforward than ACPI_FREE(buffer.pointer). :-)

And I can define acpi_free_buffer() in the Linux-specific code too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
