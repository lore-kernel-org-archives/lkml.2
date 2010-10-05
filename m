Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0JEODx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:03:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29495 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0JEODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:03:51 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] DMI: log system, BIOS, and board information
Date: Tue, 5 Oct 2010 08:02:46 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100930164905.13154.33194.stgit@bob.kio> <20101005024529.GA20805@helgaas.com> <20101004195406.96d71305.akpm@linux-foundation.org>
In-Reply-To: <20101004195406.96d71305.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010050802.49055.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 04, 2010 08:54:06 pm Andrew Morton wrote:
> On Mon, 4 Oct 2010 20:45:29 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Mon, Oct 04, 2010 at 04:19:26PM -0700, Andrew Morton wrote:
> > > On Thu, 30 Sep 2010 10:49:05 -0600
> > > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > 
> > > > 
> > > > Put basic system information in the dmesg log.  There are lots of dmesg
> > > > logs on the web, and it would be useful if they contained this information
> > > > for debugging platform problems.
> > > > 
> > > > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > > ---
> > > > 
> > > >  drivers/firmware/dmi_scan.c |   35 ++++++++++++++++++++++++++++++++++-
> > > >  1 files changed, 34 insertions(+), 1 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > > > index b3d22d6..d625e53 100644
> > > > --- a/drivers/firmware/dmi_scan.c
> > > > +++ b/drivers/firmware/dmi_scan.c
> > > > @@ -2,6 +2,7 @@
> > > >  #include <linux/string.h>
> > > >  #include <linux/init.h>
> > > >  #include <linux/module.h>
> > > > +#include <linux/ctype.h>
> > > >  #include <linux/dmi.h>
> > > >  #include <linux/efi.h>
> > > >  #include <linux/bootmem.h>
> > > > @@ -361,6 +362,36 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
> > > >  	}
> > > >  }
> > > >  
> > > > +static const char * __init dmi_printable_system_info(int field)
> > > > +{
> > > > +	const char *info, *p;
> > > > +
> > > > +	info = dmi_get_system_info(field);
> > > > +	if (!info)
> > > > +		return NULL;
> > > > +
> > > > +	for (p = info; *p; p++)
> > > > +		if (!isprint(*p))
> > > > +			return "<...>";
> > > > +
> > > > +	return info;
> > > > +}
> > > 
> > > So if the string contains any non-printable character, we suppress the
> > > whole string.
> > > 
> > > Is that the best thing to do?  Would it be better to present the
> > > oddball character as \xNN or such?
> > 
> > I would definitely prefer to do that, but that would mean allocating
> > memory, and this happens so early that it looked like it would be
> > more trouble than it's worth.  I'm not saying I couldn't be convinced,
> > though.
> 
> Well, one could print the data one char at a time.  If we're running
> early in boot with a single CPU up then that wouldn't make too big a
> mess.
> 
> Is there some upper bound to the length of a DMI string?  If so, use a
> static initdata buffer dimensioned to 4x that?

Yeah, good ideas.  I'll push on that a little bit more.

Bjorn
