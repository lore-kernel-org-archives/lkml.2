Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2KNCX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:23:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:23682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab2KNCXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:23:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="246648948"
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
Thread-Index: AQHNwRiioOP9jIS+5UWx2cJd20NobJfn4E6AgAAVKMCAAM23gP//j3MwgACVkwD//6+HIA==
Date: Wed, 14 Nov 2012 02:23:51 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E346BC08EB@ORSMSX101.amr.corp.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <2586712.Jsv1H95qXQ@vostro.rjw.lan>
 <94F2FBAB4432B54E8AACC7DFDE6C92E346BC083A@ORSMSX101.amr.corp.intel.com>
 <1957831.MvUm7YPtfp@vostro.rjw.lan>
In-Reply-To: <1957831.MvUm7YPtfp@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAE2O0Sb019282

Rafael,

I sounds like with a few changes, we can enhance this mechanism to be more useful to you and others. Some comments below. I need to look at the code in question a bit more, but I see no insurmountable issues.

Bob


> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Tuesday, November 13, 2012 2:57 PM
> To: Moore, Robert
> Cc: Mika Westerberg; mathias.nyman@linux.intel.com; linux-
> acpi@vger.kernel.org; linux-kernel@vger.kernel.org; lenb@kernel.org;
> Wysocki, Rafael J; broonie@opensource.wolfsonmicro.com;
> grant.likely@secretlab.ca; linus.walleij@linaro.org; khali@linux-fr.org;
> Bjorn Helgaas; Zheng, Lv
> Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
> objects
> 
> On Tuesday, November 13, 2012 10:06:03 PM Moore, Robert wrote:
> > I may not quite understand what you are asking for, but I will try.
> > It seems like we already have much of what you want/need, so maybe I'm
> > missing something.
> 
> I think all of the necessary pieces are there.
> 
> > > So what I would like to have, in general terms, is something like
> > > acpi_walk_resources() split into three parts:
> > >
> > >  (1) One that processes the _CRS output and creates a list of
> > >      struct acpi_resource objects for us to play with.  I suppose
> > >      it's OK if that's just a buffer filled with resource objects,
> > >      but a linked list might be more convenient.
> > >
> >
> > This sounds like AcpiGetCurrentResources. It executes _CRS and formats
> > the data into acpi_resource objects.
> 
> Yes, it does.  However, it is not completely clear to me if/how the caller
> is supposed to prepare the buffer object pointed to by the second arg.
> 
> If the buffer is initialized by AcpiGetCurrentResources, then that's what
> I need for (1).


It looks to me that at least AcpiGetCurrentResources does not actually ever allocate a buffer for the resource template, it expects the caller to eventually provide one of at least the size of the returned resource template.

This is really quite a bit out-of-date as far as the memory allocation model. It should also support the option to just allocate the buffer of the appropriate size before returning it to the caller.




> 
> > >  (2) One that allows us to access (read/write) resources in the
> > >      list returned by (1).  We don't need to open code walking
> > >      the list and I probably wouldn't event want to do that.  What
> > >      we need is to be able to walk the same list for a number of
> > >      times and possibly to modify values in the resource objects
> > >      if there are conflicts.
> >
> > This sounds like AcpiWalkResources. I suppose a possible issue is that
> > currently, AcpiWalkResources actually invokes the _CRS, _PRS, or _AEI
> > method on behalf of the caller.
> 
> Yes, that exactly is the problem.
> 
> > It might make more sense to allow the caller to pass in the resource
> > buffer returned from a call to _CRS, etc.
> 
> Yes! :-)


I'll take a closer look at this tomorrow.




> 
> > >
> > >  (3) One allowing us to free the list returned by (1) if not needed
> > >      any more.
> > >
> >
> > AcpiGetCurrentResources: Currently, everything is returned in a single
> > buffer to minimize the number of allocations. A buffer you can free
> > when you are done with it.
> 
> I suppose I should use ACPI_FREE(buffer.pointer) for that, but isn't it
> for the ACPICA's internal use only?
> 
> Besides, I would prefer to be able to pass just "buffer" for freeing,
> without having to touch its internals.  No big deal, but it would be
> nicer. :-)


The ACPI_BUFFER type is in fact a public type that is meant to return both the buffer and the (actual) length. You will find many instances of ACPI_FREE(buffer.pointer) within existing linux code, since it also used for objects returned by control method execution/object evaluation.


> 
> > I think I saw where you mentioned that you cannot copy this buffer
> > because of internal pointers to other areas of the buffer. Yes.
> > However, we can build linked lists all day if you really want them :-)
> 
> I really won't care if I can pass a resource buffer to a "walker" routine.
> :-)
> 
> > > And it would be great if we could take the list returned by (1),
> > > modify the resources in it and feed it back to _SRS (after
> > > conversion back to the format that _SRS understands).
> > >
> >
> > AcpiSetCurrentResources.
> >
> > The AML debugger already has a command that illustrates the use of the
> > various resource interfaces, see dbcmds.c
> 
> I will.
> 
> Thanks,
> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
