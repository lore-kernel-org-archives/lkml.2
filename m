Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1AYMTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:19:13 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:2009 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1AYMTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:19:12 -0500
Date: Tue, 25 Jan 2011 13:18:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pascal VITOUX <pascal@substantiel.fr>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH RFC] dmi-scan: Use little-endian for the first 3 fields
  of  the UUID.
Message-ID: <20110125131859.0a405eef@endymion.delvare>
In-Reply-To: <20110120180314.0bb74d65@destiny.ordissimo>
References: <20110119185411.49668f81@destiny.ordissimo>
	<20110119213936.06400e49@endymion.delvare>
	<20110120180314.0bb74d65@destiny.ordissimo>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anisse,

Sorry for the late reply.

On Thu, 20 Jan 2011 18:03:14 +0100, Anisse Astier wrote:
> Hi Jean,
> 
> Thank you for taking the time to answer and review,
> 
> On Wed, 19 Jan 2011 21:39:36 +0100, Jean Delvare <khali@linux-fr.org> wrote :
> > (...) The UUID seems like a reasonable thing to use for any
> > inventory application, as a mean to uniquely identify machines. Using
> > it for licensing purpose also makes sense (whether you you like
> > proprietary software or not is irrelevant.)
> Glad we agree, that's what we use it for.

I would suggest application authors using the UUID for licensing
purposes to consider the two forms of the UUID as equivalent. That is,
get the UUID from dmidecode or the kernel or HAL or whatever, byte-swap
it, and have the license checking code test both variants and succeed if
either works. This will by far lead to the best user experience.

For inventory purposes, the problem is more complex, but it would
probably make sense to add some code to detect duplicate entries. The
likeliness that a given company has two systems with UUIDs being the
byte-swapped counterpart of each other is very, very small, so this
case could be detected and reported (or silently worked around.)

> > This is a desperate case anyway, there simply is no clean solution to
> > this problem. Whoever suggested the addition of this note in the SMBIOS
> > 2.6 specification should be banned permanently from ever contributing
> > to any technical document.
> What do you suggest we do ?
> 
> Something needs to be done about that. You already have a problem if
> you're relying on DMI UUIDs. An example of an app  using HAL(obsolete, I
> know): Old versions of HAL would call dmidecode to provide the fetch the
> DMI UUID. But if you upgrade to a more recent version, it will get the
> information directly from kernel. And now you have it, a different UUID
> for the same hardware.
> 
> 
> Now, I can see three different "solutions" to bring kernel and dmidecode
> on par :
>  (1) we keep the current kernel behavior and next dmidecode version changes
>      its default. It will break applications relying on dmidecode.

I don't really want to do this. While I now believe that changing the
decoding based on SMBIOS version in dmidecode 2.10 was a mistake, it
happened too long ago to change it now. If anything, I'll add an option
to force the decoding either way, but I won't change the default again.

The worst case I've seen with dmidecode 2.10 (which is what you want to
implement in the kernel) was during a BIOS update of one of my
machines. The board manufacturer switched from SMBIOS 2.5 to SMBIOS 2.6
as part of the BIOS update, presumably so that they could report new
CPU models properly. But they did NOT change the order of the UUID
bytes. As a result, dmidecode 2.10 reported a different UUID before and
after the BIOS update. While you can claim this is the board
manufacturer's fault, the issue still exists for the user in the end.

>  (2) we keep dmidecode default and change kernel behavior. It will break
>      applications relying on kernel DMI UUID.

The only advantage with this option compared to #1 is that at least we
comply with the SMBIOS specification.

>  (3) we add a new kernel sysfs file that provides the UUID with the
>      SMBIOS 2.6 behavior. Current breakage is patchable in apps by
>      switching them to the new file.

This avoids changing an existing interface. But I'm not sure if it
actually solves your problem with HAL, as presumably HAL will still use
the original product_uuid attribute, with no chance for a fix as, as I
understand it, HAL is no longer developed.

So it may be preferable to change the default to what dmidecode 2.10
does (i.e. option #2), and introduce a new file (e.g.
product_uuid_rfc4122) implementing the original behavior, so that
application have the option to switch to this file if they want to
preserve compatibility (I call this option #4).

This will add some confusion to have two uuid attributes, but hopefully
we can live with this.

I have no strong opinion between options #2 and #4. Anyway, as I said
before, the damage is already done by the SMBIOS specification folks.
They managed to confuse OS developers and board makers alike. Whatever
we do can't solve it completely.

> > > (...)
> > > @@ -400,9 +412,29 @@ static int __init dmi_present(const char __iomem *p)
> > >  		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
> > >  			(buf[9] << 8) | buf[8];
> > >  
> > > +		/* SMBIOS version */
> > > +		dmi_ver = (*(u8 *)(p - 0x10 + 0x06) << 8) +
> > > +			*(u8 *)(p - 0x10 + 0x07);
> > 
> > You can't do that, sorry. Only the 15 bytes of the _DMI_ entry point
> > have been iomap'd, the 16 bytes of the _SM_ entry point (which may not
> > even exist!) have not. I suspect you'll have to rework the loop in
> > dmi_scan_machine() and the way it calls dmi_present() quite a bit.
> Indeed, I didn't notice that.
> 
> I think the loop is safe, because we ioremap 64k of data. Only the
> first call to dmi_present seems to be risky. (just FYI, code worked in
> our tests)

I am not familiar with memcpy_fromio(), but I can only guess that it is
there for a reason. Maybe it worked in your test but would break on
another architecture. I can see that the implementation of
memcpy_fromio is arch-specific.

> > > (...)
> > > +		printk(KERN_INFO "SMBIOS version %d.%d.\n", dmi_ver >> 8,
> > > +		       dmi_ver & 0xFF);
> > > +
> > >  		/*
> > >  		 * DMI version 0.0 means that the real version is taken from
> > > -		 * the SMBIOS version, which we don't know at this point.
> > > +		 * the SMBIOS version.
> > 
> > Changing the comment without changing the code that follows it makes no
> > sense.
> Indeed, the comment didn't make sense without changes, but the following
> code (and previous printf) either.
> 
> Does this look better (removing previous printf):
>                 /*
>                  * DMI version 0.0 means that the real version is taken from
>                  * the SMBIOS version.
>                  */
>                 if (buf[14] != 0)
>                         printk(KERN_INFO "DMI %d.%d present.\n",
>                                buf[14] >> 4, buf[14] & 0xF);
>                 else
>                         printk(KERN_INFO "DMI %d.%d(SMBIOS) present.\n", dmi_ver >> 8,
>                        dmi_ver & 0xFF);

Something like this, yes. Except that you don't have to make a
different string for both cases, this doesn't add any value and wastes
memory. Also, the version from the _SM_ entry point should be preferred
over the _DMI_ version when both are available, as the _SM_ one has
more room for the version (which doesn't matter today, but will later
if we ever reach SMBIOS specification 2.16.) Lastly, I see no reason to
not set dmi_ver from the _DMI_ entry point if the _SM_ entry point
isn't available.

-- 
Jean Delvare
