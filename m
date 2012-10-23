Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2JWQ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:26:50 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:41140 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab2JWQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:26:49 -0400
Date: Tue, 23 Oct 2012 11:26:41 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Message-ID: <20121023162641.GG20593@beefymiracle.amer.corp.natinst.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
 <201210231450.11540.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201210231450.11540.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 11:26:36 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 11:26:37 AM,
	Serialize complete at 10/23/2012 11:26:37 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YkJPYEFdoxh/AXLE"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_05:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YkJPYEFdoxh/AXLE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Arnd-

Thanks for the review/suggestions.

On Tue, Oct 23, 2012 at 02:50:11PM +0000, Arnd Bergmann wrote:
> On Monday 22 October 2012, Josh Cartwright wrote:
> > Shifting them up into the vmalloc region prevents the following warning,
> > when booting a zynq qemu target with more than 512mb of RAM:
> >=20
> >   BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space
> >=20
> > In addition, it allows for reuse of these mappings when the proper
> > drivers issue requests via ioremap().
> >=20
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
>=20
> This looks like a bug fix that should be backported to older kernels,
> so it would be good to add 'Cc: stable@vger.kernel.org' below your
> Signed-off-by.

Will-do, thanks.

> > diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach=
-zynq/include/mach/zynq_soc.h
> > index d0d3f8f..ae3b236 100644
> > --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> > @@ -15,33 +15,37 @@
> >  #ifndef __MACH_XILINX_SOC_H__
> >  #define __MACH_XILINX_SOC_H__
> > =20
> > +#include <asm/pgtable.h>
> > +
> >  #define PERIPHERAL_CLOCK_RATE		2500000
> > =20
> > -/* For now, all mappings are flat (physical =3D virtual)
> > +/* Static peripheral mappings are mapped at the top of the
> > + * vmalloc region
> >   */
> > -#define UART0_PHYS			0xE0000000
> > -#define UART0_VIRT			UART0_PHYS
> > +#define UART0_PHYS		0xE0000000
> > +#define UART0_SIZE		SZ_4K
> > +#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)
>=20
> There are plans to move the uart location into a fixed virtual
> address in the future, but it hasn't been decided yet.
> It will still need a fixed mapping though, just to a different
> address.
>=20
> > -#define TTC0_PHYS			0xF8001000
> > -#define TTC0_VIRT			TTC0_PHYS
> > +#define TTC0_PHYS		0xF8001000
> > +#define TTC0_SIZE		SZ_4K
> > +#define TTC0_VIRT		(UART0_VIRT - TTC0_SIZE)
>=20
> It's quite likely that this does not have to be a fixed mapping
> any more. Just have a look at how drivers/clocksource/dw_apb_timer_of.c
> calls of_iomap() to get the address.

Yes, this is already on my list of plans.  The in-tree TTC driver
unfortunately doesn't yet support device tree bindings.  Are you
comfortable waiting on the DT-ification of the TTC in a follow-up
patchset?

> > -#define PL310_L2CC_PHYS			0xF8F02000
> > -#define PL310_L2CC_VIRT			PL310_L2CC_PHYS
> > +#define PL310_L2CC_PHYS		0xF8F02000
> > +#define PL310_L2CC_SIZE		SZ_4K
> > +#define PL310_L2CC_VIRT		(TTC0_VIRT - PL310_L2CC_SIZE)
>=20
> This address would not need a fixed mapping by calling l2x0_of_init
> rather than l2x0_init.

Great, I'll take care of this.

> > -#define SCU_PERIPH_PHYS			0xF8F00000
> > -#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
> > +#define SCU_PERIPH_PHYS		0xF8F00000
> > +#define SCU_PERIPH_SIZE		SZ_8K
> > +#define SCU_PERIPH_VIRT		(PL310_L2CC_VIRT - SCU_PERIPH_SIZE)
>=20
> And your patch 3 already obsoletes this mapping.

I'll spin up a reordered patchset to eliminate this odd state.

Thanks again,

  Josh

--YkJPYEFdoxh/AXLE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhsVBAAoJEEef0niEbw+l8dAQAI+pO3+1g/aR1ynTkJCgsQ84
ecC4nuUG5JHi/o8vYsS2N0WUKSkwKMkk7wFxWmKrIZ79L4voYU+uaHmy0faimPrO
VGr1QzOJxLNweNgeUb8SK47/T4HImhQHmhLKkyLlGY0fVeL1Q81TI4p1b/1iQnL8
q5uFFwid5NFgS4d5yFYNgxJPQkeel6+SNeLIOX+vqlUU4Su2AuvhYg/Q0APtXSYh
pTLET9dYLqWiFaDBQfQ9sRnfRePnsKZtBmQE17C1pEPx/ey01GN+GbjHKRurdu4N
goLlAMmkwN9zFEM3qTjVyQo9MZKCoSPGMOw+zxlfUvvqtjAwHkhNAedEe5bsOK11
JFsQL9GiXuNQLBwg3LApnwpz4RMLeEFs5WjCircQD/DS+Cudcztk2KsnDjL79rTl
WcCHPUldYz64Hb8g1hG176VglQ55odsjVIwtifNEV1d4/rET5fCFTX6Szd17+XDw
6R/Akx3LRPzevpsH0DiJhzaSO+McNx5Xvm8NMtCX09/37dqaoZmfmxlBaQu563WW
vrT+wRVJ3l8NZK9ztQvpuuuYZLAedJtvW8O/Q4ikS8tcm5dTaYZiIq5wP/AxxXvI
tOhwHufcjKN4b4yYiucj3aOBSHnc8e3YWSoyJLpg6C4MpczhXbvIfkjMyGllnmAM
5d37ljLJvYmb3OP3BEr2
=1KaH
-----END PGP SIGNATURE-----

--YkJPYEFdoxh/AXLE--
