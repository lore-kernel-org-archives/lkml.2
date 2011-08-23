Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1HWJNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:13:05 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57874 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894Ab1HWJND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:13:03 -0400
Date: Tue, 23 Aug 2011 12:12:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, torvalds@linux-foundation.org,
        mporter@ti.com, Kevin Hilman <khilman@ti.com>,
        "Govindraj.R" <govindraj.raja@ti.com>
Subject: Re: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
Message-ID: <20110823091257.GE1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
 <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
 <4E4D4A5F.202@linutronix.de>
 <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
 <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
 <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 22, 2011 at 11:10:21PM -0600, Paul Walmsley wrote:
>=20
> Convert the omap-serial hardirq handler to a threaded IRQ handler. Withou=
t=20
> this patch, OMAP boards which use the on-board OMAP UARTs and the=20
> omap-serial driver will not boot to userspace after commit=20
> f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set IRQF_ONESHOT i=
f=20
> no primary handler is specified").  Enabling CONFIG_DEBUG_SHIRQ reveals=
=20
> 'IRQ handler type mismatch' errors:
>=20
> IRQ handler type mismatch for IRQ 74
> current handler: serial idle
> [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c009c900>] (__setup_irq+0=
x42c/0x464)
> [<c009c900>] (__setup_irq+0x42c/0x464) from [<c009ca08>] (request_threade=
d_irq+0xd0/0x148)
> [<c009ca08>] (request_threaded_irq+0xd0/0x148) from [<c029d398>] (serial_=
omap_startup+0x30/0x2dc)
> [<c029d398>] (serial_omap_startup+0x30/0x2dc) from [<c0295a38>] (uart_sta=
rtup+0x5c/0x1ac)
>=20
> (etc.)
>=20
> It turns out that the omap-serial code used one threaded IRQ
> handler[1][2] and one non-threaded IRQ handler[3] that shared the same
> IRQ.  During the 3.1-rc series, a patch was merged[4] that caused
> IRQF_ONESHOT to be set on the threaded handler, but the non-threaded
> handler did not have IRQF_ONESHOT set.  Since interrupt handlers
> that share the same IRQ must also share the presence or absence of
> IRQF_ONESHOT[5], this new commit caused a mismatch that prevented the
> non-threaded IRQ from registering.
>=20
> Fix by converting the non-threaded IRQ handler in omap-serial.c to a
> threaded IRQ handler.  Ideally we would not have to make this type of
> change during the -rc series, but the commit that caused this behavior
> was itself merged between v3.1-rc2 and v3.1-rc3.  In the long term, it
> would be good to get rid of the shared IRQ handler hack in
> arch/arm/mach-omap2/serial.c.
>=20
> This change has been boot-tested on OMAP3530 BeagleBoard and
> OMAP4430ES2 PandaBoard, and static suspend has been lightly tested on
> the BeagleBoard.
>=20
> Pantelis Antoniou <pantelis.antoniou@gmail.com> originally reported
> the boot failure.
>=20
> 1. arch/arm/mach-omap2/serial.c line 550, as of Linux v3.1-rc3.  http://g=
it.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dblob;f=3Darc=
h/arm/mach-omap2/serial.c;h=3D466fc722fa0f39f03b8d93cf84e4dae4f57fd029;hb=
=3Dfcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c#l550
>=20
> 2. arch/arm/mach-omap2/serial.c line 563, as of Linux v3.1-rc3.  http://g=
it.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dblob;f=3Darc=
h/arm/mach-omap2/serial.c;h=3D466fc722fa0f39f03b8d93cf84e4dae4f57fd029;hb=
=3Dfcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c#l563
>=20
> 3. drivers/tty/serial/omap-serial.c line 464, as of Linux v3.1-rc3.  http=
://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dblob;f=
=3Ddrivers/tty/serial/omap-serial.c;h=3Dc37df8d0fa2819261dffccc5bc4d0180b95=
31f49;hb=3Dfcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c#l464
>=20
> 4. Commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set
>    IRQF_ONESHOT if no primary handler is specified")
>=20
> 5. Gleixner, Thomas. _[patch 2/5] genirq: Allow shared oneshot
>    interrupts_.  http://lkml.org/lkml/2011/2/23/511
>=20
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/omap-serial.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index c37df8d..e83a769 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -461,8 +461,8 @@ static int serial_omap_startup(struct uart_port *port)
>  	/*
>  	 * Allocate the IRQ
>  	 */
> -	retval =3D request_irq(up->port.irq, serial_omap_irq, up->port.irqflags,
> -				up->name, up);
> +	retval =3D request_threaded_irq(up->port.irq, NULL, serial_omap_irq,
> +				      up->port.irqflags, up->name, up);

if you're not running on a slow bus, you should use top half to check if
IRQs are really from this device.

--=20
balbi

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU28ZAAoJEAv8Txj19kN1rkEH/iUvextOJdIXajoe2tRiz0TX
EOKKh6gcYHRh8zS9f0gI/xxEhECYMX8GJS3+u4kZDn8wRtBQ1R6oTDmxaFP/ut/+
bpD1v6BgorIrJQxcM6RPfPAMU51J+q2mR9JnYcn7r13801BPt4GwpQYKm1tRz56P
6rXitFWmIWeOhIr5UzlI5cvIYCa9Rv6Xw4Ra+xTkVUf0FyC3+9+1FN4xm96l858g
kC6WqVkg8kox9Ye3lL75ffuw4zv9Ezg4G+T6kAtoL5UtVpAO5lWskC5lw5lCZDsw
RS8gDfPNtmL3dJdm3H6RXcQmVCGewLodMVF5fTJ5Lf3dYaqwvR5zvm8Ux5uQ82Q=
=9R/R
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--
