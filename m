Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2GFWkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:40:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2GFWj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:39:58 -0400
Date: Sat, 7 Jul 2012 08:39:49 +1000
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Infinite looping in omap2430.c USB driver
Message-ID: <20120707083949.2cf91eeb@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yR=1B6Ogzk8zow3DNyGpywg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yR=1B6Ogzk8zow3DNyGpywg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hello `./scripts/get_maintainer.pl -f drivers/usb/musb/omap2430.c`

omap2430_musb_set_vbus in omap2430.c contains:

			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {

				cpu_relax();

				if (time_after(jiffies, timeout)) {
					dev_err(musb->controller,
					"configured as A device timeout");
					ret =3D -EINVAL;
					break;
				}
			}

having set
	unsigned long timeout =3D jiffies + msecs_to_jiffies(1000);

so it can busy-loop for up to 1 second.  Probably not ideal, but if it works
I wouldn't complain.

The
	if (int_usb & MUSB_INTR_SESSREQ) {
branch of musb_stage0_irq() called from musb_interrupt (from
generic_interrupt) calls this:

	if (musb->int_usb)
		retval |=3D musb_stage0_irq(musb, musb->int_usb,
				devctl, power);

so the busy loop can happen in an interrupt handler (not a threaded interru=
pt
handler), which is probably less ideal.

However this can be called with interrupt disabled, as happens at least
during resume when resume_irqs() calls:

		raw_spin_lock_irqsave(&desc->lock, flags);
		__enable_irq(desc, irq, true);
		raw_spin_unlock_irqrestore(&desc->lock, flags);

and an interrupt is found to be IRQS_PENDING.

In this case interrupts are disabled so 'jiffies' never changes so this loop
can continue forever.

This happens on my (GTA04) phone fairly regularly - between 1 in 10 and 1 in
30 resumes. The musb-hdrc interrupt is pending and reports

[ 4957.624176] musb-hdrc musb-hdrc: ** IRQ peripheral usb0040 tx0000 rx0000

'usb0040' is MUSB_INTR_SESSREQ.  I think this is triggered by detecting a
voltage change on the USB ID pin - is that right?  A short-to-earth would be
a request to switch to host mode, which is why it tries to enable VBUS.
Maybe there is some electrical noise which is being picked up?

In any case I get the interrupt despite nothing being plugged in, and the 0=
x80
bit of MUSB_DEVCTL never gets cleared.

I've added a simple loop counter which aborts the loop after 1000 loops -
this takes about 5 seconds, but includes some printks which probably slow it
down.

In 2 out of 2 cases, subsequent messages show that the hsmmc driver for the
uSD card that holds my root filesystem is messed up.  It seems to be waiting
for a request that is never going to complete.
So maybe the hsmmc is causing the noise that triggers the musb issue.

I can send a patch which add a loop count if you like, but I suspect you can
come up with a much better approach.

Thanks,
NeilBrown

--Sig_/yR=1B6Ogzk8zow3DNyGpywg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/dpNTnsnt1WYoG5AQIrPhAAlRtFq4/z2NXrHOPKZ/CP+g8M2BAgtz9D
pND5j4NTw7DPuq3q0XV/PANfME7X+Szyv/g1wz0kVgg9iDiCgzpHydTTIv+XVPcS
saq011IrhwV6YwEWh/faY4n6A/5sBJOj6vzDRHRTOUrWNXkd2BxROe1lsWPoS9ib
8Bj2dZjO3uggWbb+AUj+VoRpuqZMJ1rpzwNY4bLyPebPOT2pzNeby7o+q1NKzPnP
gHR4eZGvyToJW8w9dXix9iJM9kogQGJO7MnD7cRGyL3kVzM4/ODNmWSKQhy5Pe+2
b9DmAbD0Vf/4mI1WpGwJNG2MQtw28kUJxT2+Jy8UgBNb16gwPR+NsbdfGp5Oxhqd
ZIE0mlNb6FCu4jz3qEsc2hYK4xf+hyvosBV/pZISZGjSr2IFYoPf2JLin91XetjV
WxHG5Up12quwRMZ4OBoz4r8ipA6IrX51s+3xlObncZAugEtSxGpI9f1zHbhJKALo
Mmpzdd0/9CojZcXgcZSo+aGMC8/+yrr2qXjdhubB6TvJwkr8N4UzhuEY4/GWQj6W
NApLO0YNkqDhSxzAvzNdugHiFMXLXpVZdzlxtZ95FgOZGvuYyeMccxTy/8OcUOBx
B2Al6z+6bHH0AxT04zRFfzsUOUoBKCjb012vjmlIlViz1L/y7pbsQNGlFErVfxzR
ILkXYi+Q2zk=
=9FWw
-----END PGP SIGNATURE-----

--Sig_/yR=1B6Ogzk8zow3DNyGpywg--
