Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0E0QZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:25:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36387 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0E0QZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:25:17 -0400
Date: Thu, 27 May 2010 18:25:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
       platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/11] drivers/platform/x86: Eliminate a NULL pointer
 dereference
In-Reply-To: <201005270921.43049.dmitry.torokhov@gmail.com>
Message-ID: <Pine.LNX.4.64.1005271824510.5422@ask.diku.dk>
References: <Pine.LNX.4.64.1005271436460.5422@ask.diku.dk>
 <201005270921.43049.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Dmitry Torokhov wrote:

> On Thursday 27 May 2010 05:37:00 am Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Give different error messages if device_enum is NULL or if its type field
> > has the wrong value.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @r exists@
> > expression E,E1;
> > identifier f;
> > statement S1,S2,S3;
> > @@
> > 
> > if ((E == NULL && ...) || ...)
> > {
> >   ... when != if (...) S1 else S2
> >       when != E = E1
> > * E->f
> >   ... when any
> >   return ...;
> > }
> > else S3
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> > This may be too much clutter for little benefit.  Other, perhaps less
> > informative solutions are possible.
> 
> Verbosity should be OK but I think that mixing pr_xxx() and naked printks
> in the same patch is not very nice.

Oops, sorry about that.  I will change it.

julia


> >  drivers/platform/x86/sony-laptop.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/sony-laptop.c
> > b/drivers/platform/x86/sony-laptop.c index 1387c5f..9db8d2b 100644
> > --- a/drivers/platform/x86/sony-laptop.c
> > +++ b/drivers/platform/x86/sony-laptop.c
> > @@ -1196,8 +1196,12 @@ static void sony_nc_rfkill_setup(struct acpi_device
> > *device) }
> > 
> >  	device_enum = (union acpi_object *) buffer.pointer;
> > -	if (!device_enum || device_enum->type != ACPI_TYPE_BUFFER) {
> > -		printk(KERN_ERR "Invalid SN06 return object 0x%.2x\n",
> > +	if (!device_enum) {
> > +		pr_err("Invalid SN06 return object\n");
> > +		goto out_no_enum;
> > +	}
> > +	if (device_enum->type != ACPI_TYPE_BUFFER) {
> > +		printk(KERN_ERR "Invalid SN06 return object type 0x%.2x\n",
> >  				device_enum->type);
> >  		goto out_no_enum;
> >  	}
> 
> Thanks.
> 
> -- 
> Dmitry
> 
