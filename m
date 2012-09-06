Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2IFHvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:51:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2IFHvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:51:45 -0400
Date: Thu, 6 Sep 2012 17:51:28 +1000
From: NeilBrown <neilb@suse.de>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit <b-cousson@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
Message-ID: <20120906175128.35fa076a@notabene.brown>
In-Reply-To: <CAMQu2gyKJhhPnmx4pwLptV3FGw_ZssyB_eXDS6upB6ncwxG2cg@mail.gmail.com>
References: <20120825214459.7333a376@notabene.brown>
	<CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
	<20120827085312.75957354@notabene.brown>
	<CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
	<CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
	<20120906130510.32b0b877@notabene.brown>
	<CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
	<20120906170245.10e97bdd@notabene.brown>
	<CAMQu2gyKJhhPnmx4pwLptV3FGw_ZssyB_eXDS6upB6ncwxG2cg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E5LMJXnWXyrczguh_R38OnV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E5LMJXnWXyrczguh_R38OnV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Sep 2012 12:57:46 +0530 "Shilimkar, Santosh"
<santosh.shilimkar@ti.com> wrote:

> On Thu, Sep 6, 2012 at 12:32 PM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 6 Sep 2012 11:18:09 +0530 "Shilimkar, Santosh"
> > <santosh.shilimkar@ti.com> wrote:
> >
> >> On Thu, Sep 6, 2012 at 8:35 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Mon, 3 Sep 2012 22:59:06 -0700 "Shilimkar, Santosh"
> >> > <santosh.shilimkar@ti.com> wrote:
> >
> >> >> After thinking bit more on this, the problem seems to be coming
> >> >> mainly because the gpio device is runtime suspended bit early than
> >> >> it should be. Similar issue seen with i2c driver as well. The i2c i=
ssue
> >> >> was discussed with Rafael at LPC last week. The idea is to move
> >> >> the pm_runtime_enable/disable() calls entirely up to the
> >> >> _late/_early stage of device suspend/resume.
> >> >> Will update this thread once I have further update.
> >> >
> >> > This won't be late enough.  IRQCHIP_MASK_ON_SUSPEND takes effect aft=
er all
> >> > the _late callbacks have been called.
> >> > I, too, spoke to Rafael about this in San Diego.  He seemed to agree=
 with me
> >> > that the interrupt needs to be masked in the ->suspend callback.  an=
y later
> >> > is too late.
> >> >
> >> Thanks for information about your discussion. Will wait for the patch =
then.
> >>
> >> Regards
> >> santosh
> >
> > I already sent a patch - that is what started this thread :-)
> >
> > I include it below.
> > You said "The patch doesn't seems to be correct" but didn't expand on w=
hy.
> > Do you still think it is not correct?  I wouldn't be surprised if there=
 is
> > some case that it doesn't handle quite right, but it seems right to me.
> >
> Sorry I though you were talking about moving the "Checking wakeup interru=
pts"
> bit early as discussed on the follow up of alternate suggested patch to m=
ake
> use of  IRQCHIP_MASK_ON_SUSPEND.
>=20
> I think we need to fix the issue seen with ' IRQCHIP_MASK_ON_SUSPEND'
> patch. That is at least the expected way to manage suspend and wakeup
> irq masks for a IRQCHIP.

That is what I thought at first too.  But when talking to Rafael he said th=
at
IRQCHIP_MASK_ON_SUSPEND was intended mainly for clock interrupts.  For other
less fundamental interrupts, doing the mask/unmask in suspend/resume
callbacks is sufficient and simpler... and actually works.

IRQCHIP_MASK_ON_SUSPEND is currently used by precisely two drivers:

   arch/arm/mach-omap2/omap-wakeupgen.c
and=20
   drivers/mfd/pm8xxx-irq.c

which suggests that it isn't widely used and quite possibly doesn't actually
work in general.
The pm8xxx-irq doesn't seem to do runtime pm, so maybe it manages to work f=
or
that reason.
The omap-wakeupgen code is beyond my current understanding, but it seems li=
ke
it might be the sort of special case that IRQCHIP_MASK_ON_SUSPEND is intend=
ed
for...

Maybe we need to start a new thread and pester Rafael or Thomas Gleixner
to either explain what is intended for this case, or to fix=20
IRQCHIP_MASK_ON_SUSPEND so that it can be used in general.

NeilBrown

--Sig_/E5LMJXnWXyrczguh_R38OnV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEhWADnsnt1WYoG5AQKszBAAkSZK76g+iHjPJlNPgKSThdYLbCGDTKT7
5ahMhoBk/uS7bpQHeMHEiHEPDedfBQwE1YVc+fc9W7Vrp3rklzWuuriDHnDExiWd
164onPl5Ti7qukjwFgUtF99a3+K6qpOf9egRGZLicNtTyyo5rMNLGAE2V5grPewJ
Krmy7ibeN1TXc5dPwO/Ghkxuf8cO/LgH/UI+3MssuVGyWCC5bkjAdE+krbrIxIhB
2Fo8kidENMFF2G/JOYilUWUoOS/NEXrUSUHcWBGDJrpGok5jiQpqVLU5+VXy5xMI
Q0W3u9cTk9NXLPSqveUU1QqOOjkWUfR3jKSQKYWFAdAFYL4YbMgh/2pnrkmH5y+2
h93PGGRMVrxQUSUmz5Cp+kgZXm6wSVeNyABT129bYu7Vua6TPJLW9aqu2yWsDmaN
lOJSqWrwrmEvr27PcAU5mWtL8xtoZ42NGayqEOxzj4JgPQVFTJn3nQZTRyWkmzBx
E3yOghtob7G2Z4CFQ9PZI6WVIuQUuuuo+si1kSY9ccJKDUa1enLJiIcXDDcQ/dMG
M1bMQpwWZ7Ot6x6XJlOXVXToK9AKd8Az4GpGkvSSJkqbr7BvhwBG+dgDIdaOyROu
Am5dXfN/1jMeb/O+sU4x6AcaDGWzT0C7t/cAzhrguHlzDrZgAvKU5Qyf19S71Esm
Yu0cpn6UXNY=
=2sOx
-----END PGP SIGNATURE-----

--Sig_/E5LMJXnWXyrczguh_R38OnV--
