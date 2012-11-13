Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2KMWwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:52:22 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab2KMWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:52:20 -0500
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
Date: Tue, 13 Nov 2012 23:56:40 +0100
Message-ID: <1957831.MvUm7YPtfp@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC083A@ORSMSX101.amr.corp.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <2586712.Jsv1H95qXQ@vostro.rjw.lan> <94F2FBAB4432B54E8AACC7DFDE6C92E346BC083A@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 10:06:03 PM Moore, Robert wrote:
> I may not quite understand what you are asking for, but I will try.
> It seems like we already have much of what you want/need, so maybe
> I'm missing something.

I think all of the necessary pieces are there.

> > So what I would like to have, in general terms, is something like
> > acpi_walk_resources() split into three parts:
> > 
> >  (1) One that processes the _CRS output and creates a list of
> >      struct acpi_resource objects for us to play with.  I suppose
> >      it's OK if that's just a buffer filled with resource objects,
> >      but a linked list might be more convenient.
> > 
> 
> This sounds like AcpiGetCurrentResources. It executes _CRS and formats
> the data into acpi_resource objects.

Yes, it does.  However, it is not completely clear to me if/how the caller is
supposed to prepare the buffer object pointed to by the second arg.

If the buffer is initialized by AcpiGetCurrentResources, then that's what
I need for (1).

> >  (2) One that allows us to access (read/write) resources in the
> >      list returned by (1).  We don't need to open code walking
> >      the list and I probably wouldn't event want to do that.  What
> >      we need is to be able to walk the same list for a number of
> >      times and possibly to modify values in the resource objects
> >      if there are conflicts.
> 
> This sounds like AcpiWalkResources. I suppose a possible issue is that
> currently, AcpiWalkResources actually invokes the _CRS, _PRS, or _AEI
> method on behalf of the caller.

Yes, that exactly is the problem.

> It might make more sense to allow the caller to pass in the resource buffer
> returned from a call to _CRS, etc.

Yes! :-)

> > 
> >  (3) One allowing us to free the list returned by (1) if not needed
> >      any more.
> > 
> 
> AcpiGetCurrentResources: Currently, everything is returned in a single buffer
> to minimize the number of allocations. A buffer you can free when you are
> done with it.

I suppose I should use ACPI_FREE(buffer.pointer) for that, but isn't it for the
ACPICA's internal use only?

Besides, I would prefer to be able to pass just "buffer" for freeing, without
having to touch its internals.  No big deal, but it would be nicer. :-) 

> I think I saw where you mentioned that you cannot copy this buffer because
> of internal pointers to other areas of the buffer. Yes. However, we can build
> linked lists all day if you really want them :-)

I really won't care if I can pass a resource buffer to a "walker" routine. :-)

> > And it would be great if we could take the list returned by (1), modify
> > the resources in it and feed it back to _SRS (after conversion back to the
> > format that _SRS understands).
> > 
> 
> AcpiSetCurrentResources.
> 
> The AML debugger already has a command that illustrates the use of the
> various resource interfaces, see dbcmds.c

I will.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
