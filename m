Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2ISNli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:41:38 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:48520 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab2ISNlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:41:36 -0400
Date: Wed, 19 Sep 2012 16:36:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <felipe.balbi@nokia.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, sricharan <r.sricharan@ti.com>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Message-ID: <20120919133648.GB6106@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <20120916203850.GI4521@atomide.com>
 <20120917212506.GB11762@atomide.com>
 <201209191335.48051.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <201209191335.48051.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 01:35:47PM +0000, Arnd Bergmann wrote:
> On Monday 17 September 2012, Tony Lindgren wrote:
> > * Tony Lindgren <tony@atomide.com> [120916 13:39]:
> > > * Arnd Bergmann <arnd@arndb.de> [120915 13:15]:
> > > > On Saturday 15 September 2012, Tony Lindgren wrote:
> > > > > With my patches, this is now all omap1 specific and
> > > > > moved to arch/arm/mach-omap1/include/mach/hardware.h.
> > > > > It's probably easiest to just update this patch on
> > > > > top of the hardware.h changes I've done.
> > > >=20
> > > > Yes, sounds good. Do you want to send a patch for that
> > > > and let me drop this one then?
> > >=20
> > > Yes I can pick this one and update it against one of my
> > > branches to avoid merge conflicts.
> >=20
> > This applies against mach-omap1/include/mach/hardware.h
> > with some fuzz so no issues there.
> >=20
> > But I think we should not apply it as these are physical
> > addresses, not virtual addresses for omap1.
>=20
> Right, I misread what is actually going on here because the
> only driver I looked at treated the address as a virtual
> address pointer.
>=20
> > We have IOMEM already in use for omap_read/write because of:
> >=20
> > #define OMAP1_IO_ADDRESS(pa)    IOMEM((pa) - OMAP1_IO_OFFSET)
> >=20
> > I think the right solution is to eventually get rid of
> > omap_read/write for omap1 also and replace them with ioremap
> > + readl/writel.
>=20
> Agreed.
>=20
> > Or am I missing something?
>=20
> I did not see any new warnings for omap1, but I did see this
> on omap2plus_defconfig:
>=20
> drivers/watchdog/omap_wdt.c: In function 'omap_wdt_ioctl':
> drivers/watchdog/omap_wdt.c:222:4: error: passing argument 1 of '__raw_re=
adw' makes pointer from integer without a cast [-Werror]
> arch/arm/include/asm/io.h:71:90: note: expected 'const volatile void *' b=
ut argument is of type 'unsigned int'
>=20
> It seems I misinterpreted this, and it's actually a bug in the watchdog
> driver that should be fixed using this patch instead (and backport it
> to stable)
>=20
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index fceec4f..7b45802 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -218,9 +218,11 @@ static long omap_wdt_ioctl(struct file *file, unsign=
ed int cmd,
>  	case WDIOC_GETSTATUS:
>  		return put_user(0, (int __user *)arg);
>  	case WDIOC_GETBOOTSTATUS:
> +#ifdef CONFIG_ARCH_OMAP1
>  		if (cpu_is_omap16xx())
> -			return put_user(__raw_readw(ARM_SYSST),
> +			return put_user(omap_readw(ARM_SYSST),
>  					(int __user *)arg);
> +#endif

indeed... my bad. I agree this should be changed by something better
though.

cheers

--=20
balbi

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWcpvAAoJEIaOsuA1yqRETQAP/1w8qN8qUECv8fygAZBsrYwV
9+9lGNEMlACLEo9IDjSLPh8pA5jnlmpXsQ8bgUsSf+i7jTwvfR2Ez5tAMvoFMynX
0LPja3SLEdvjFknCBjytcq29aafAVjUTR/0/txevOUdnnp9Ek9HGZi7DekCT0Hfk
PdtOWFXPv/pUEbmoQ8KP28TShOPYMCIwk1AFKq/OyTtfJRkKO+DdhXx47tXvQVLu
qJYi4+qoPyHjLYFoLXAx2NAf/eMQaqPw3VTRZlpaL0v3+Dmse4KVJZVEKjR/Kiwd
i9RZKge3Pae555ER8OI1A1jfzN+AkHxMG/vNPVbLNtORI4beGu8ELBOqxeO59Van
A1lTwg9sJHdMnkNsiLOgJZh305wHkP/+yI5nRruMRgMLVsMKQEkxvKLTaNIjpaAZ
StAQ1XgVBBzj3+GkaXKv2VwOnZn0ruf7T5jEs27dGAMOraHvpvalt7Tq8jLZEze2
omeAGE1nB4jmQxWxBlCGMlGRX1SX0Nk6h+nbMKkW5Wvw3tAEJ52CsRW6CHKLd472
T86i7/d5aDbRM+hQHcztnUXe1hsZQbs1WrOLHHrctIRxiMq0gJmZNKngwh8tecRA
yykhgSvx9PP1QSROJ1jrbuvbFgJZLzNKtq1xnZUWoajXJEDdXPDEVvdl6ysqLs3f
NSutWZ4HpQ+PZRrMJHtE
=rs58
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
