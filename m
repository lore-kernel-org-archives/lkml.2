Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab2JYV3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:29:21 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:45484 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2JYV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:29:17 -0400
Date: Thu, 25 Oct 2012 16:29:02 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v4 5/5] zynq: move static peripheral mappings
Message-ID: <20121025212902.GX20593@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200451.GF6713@beefymiracle.amer.corp.natinst.com>
 <20121025201701.GA18217@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <20121025201701.GA18217@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/25/2012 04:28:58 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/25/2012 04:28:58 PM,
	Serialize complete at 10/25/2012 04:28:58 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VvnGyWaJ9JuxX38U"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-25_04:2012-10-25,2012-10-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VvnGyWaJ9JuxX38U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 04:17:01PM -0400, Nick Bowler wrote:
> Hi Josh,
>
> On 2012-10-24 15:04 -0500, Josh Cartwright wrote:
> > Shifting them up into the vmalloc region prevents the following warning,
> > when booting a zynq qemu target with more than 512mb of RAM:
> [...]
> > -/* For now, all mappings are flat (physical =3D virtual)
> > +/* Static peripheral mappings are mapped at the top of the
> > + * vmalloc region
> >   */
> > -#define UART0_PHYS			0xE0000000
> > -#define UART0_VIRT			UART0_PHYS
> > +#define UART0_PHYS		0xE0000000
> > +#define UART0_SIZE		SZ_4K
> > +#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)
>
> Did you test this on any real hardware?  I can't get the ZC702 to work
> with the UART mapped at this address (this ends up being mapped at
> 0xFEFFF000), although I can't for the life of me figure out why the
> virtual address even matters.  Note that for the ZC702, the physical
> address of the "main" UART is 0xE0001000.

Ugh, not yet;  My testing has been on a qemu model.  I also
unfortunately neglected to mention I am carrying a qemu patch that
forces RX_EN/TX_EN of the uarts out of reset.  There is an (incomplete)
thread on qemu-devel discussing whose responsibility it really is to
enable the uarts:

   http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg03779.html

Clearly, though, if you are seeing the "Uncompressing Linux..."
messages, then the uart is enabled, so I don't think that's the problem.

> All I end up seeing is "Uncompressing Linux... done, booting the
> kernel." with no further messages.  With the UART mapped at
> 0xF0001000, all printouts make it to the console.  I tried a couple
> different virtual addresses and I'm surprised at the results, since
> the behaviour seems to vary wildly.  I saw three behaviours depending
> only on the virtual address of the static mapping; all results are 100%
> reproducible:
>
>    "Works":     all printouts make it to the console
>    "Fails":     no printouts make it to the console after decompression
>    "Truncated": the first few lines of output do not make it to the
>                 console, but after that it "Works".  The first line
> 		successfully printed is always
> 		  "Built 1 zonelists in Zone order, mobility grouping on.  Total pages:=
 260096"

Odd, I'm wondering the uart gets into a weird state, and some bits get
knocked loose at console_initcall() time, when the console driver comes
up (Assuming CONFIG_SERIAL_XILINX_PS_UART)?

> And here are the addresses I tested:
>=20
>   Address       Result
>   -----------------------
>   0xf0000000    Truncated
>   0xf0001000    Works
>   0xf0007000    Truncated
>   0xf0008000    Fails
>   0xf0009000    Fails
>   0xf000e000    Truncated
>   0xf000f000    Fails
>   0xf8000000    Truncated
>   0xf8001000    Works
>   0xfef00000    Truncated
>   0xfef01000    Works
>   0xfef08000    Fails
>   0xfef0f000    Fails
>   0xfeff0000    Fails
>   0xfeff1000    Fails
>   0xfeffe000    Fails
>   0xfefff000    Fails
>=20
> Judging by the list, the console seems to only work properly if the
> defined virtual address is Fxxx1000 and xxx is not too big...

Very odd.  Do you mind sending out your patch allowing the selection of
the secondary uart for DEBUG_LL?

Thanks,

  Josh

--VvnGyWaJ9JuxX38U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQia8eAAoJEEef0niEbw+lswAP/iEEpm66cAKdrn/p7DWUbvyX
Npcpcvc0Ljbx8XFnfZ3JYyjlBB3zvx8XvqWIg7zR71w7TT9MBpBP2YFjAQANDKIs
EIjohDQAjELfKyBKS3Foe1+oicGGqKk+QGwAYFR3PuvX7hFjWiJjn3MJBCZf/W+T
FC6eX24cO5GoVTWSevBryLX8WZjeqGB3eHoTfCxUBgoboD7GxBY5Eaak6rTKPaQS
GL2Wg74zGVZJOtlGmm+c6Km9Dn5qk7YGsgKPciSLnLRMIE9NHzPLXxDqO1UJczD/
tVjJSU6CKnAB9uWyMc1TAF1IPwbpR7QIcAlq+3mpLYXeu5Hh2MUOpB0QPMmSN3af
uYgvtssr/LcbAKHeYTbqvA2SIIXJVCSq6eXC5BkvEsnASA0ShhxAuFk60icHzBHH
opXaTPgtaH1ylVWzcPGwzimLkBJ5xiUG0V5UquJMwt/bOxCafRlNKHeSEWZB6M4U
Lgs7UFeAD8neoeB16BP636lUwbbmdOSbjz5S1r1/NTLDOpoWgNwn3lLFPdJqYkwz
WquSvojGtN9Y4ZwRWzVPJdyyXsSHkNVaY8guoaXTv87Hajrf7Y7SAVONcFo/YPWT
mmvdMvLUAx8eg1AoJntVnudniXOrPQNozArVppKQXMbQvQABcNjPKOCqd33BOH/e
sWMNKnJwzD7OYYNYVaBI
=VgGX
-----END PGP SIGNATURE-----

--VvnGyWaJ9JuxX38U--
