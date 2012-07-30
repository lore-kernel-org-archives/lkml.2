Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2G3ARH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 20:17:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab2G3ARF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 20:17:05 -0400
Date: Mon, 30 Jul 2012 10:16:50 +1000
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120730101650.6c3e09a2@notabene.brown>
In-Reply-To: <20120709083233.GY1122@atomide.com>
References: <20120707083949.2cf91eeb@notabene.brown>
	<20120709083233.GY1122@atomide.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H1XTguaZp8B+EHlTNTMFUuo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H1XTguaZp8B+EHlTNTMFUuo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Felipe,
 have you had a chance to look at this problem in omap2430_mbus_set_vbus ye=
t?
Are you the person responsible?

thanks,
NeilBrown


On Mon, 9 Jul 2012 01:32:33 -0700 Tony Lindgren <tony@atomide.com> wrote:

> * NeilBrown <neilb@suse.de> [120706 15:44]:
> >=20
> > Hello `./scripts/get_maintainer.pl -f drivers/usb/musb/omap2430.c`
> >=20
> > omap2430_musb_set_vbus in omap2430.c contains:
> >=20
> > 			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
> >=20
> > 				cpu_relax();
> >=20
> > 				if (time_after(jiffies, timeout)) {
> > 					dev_err(musb->controller,
> > 					"configured as A device timeout");
> > 					ret =3D -EINVAL;
> > 					break;
> > 				}
> > 			}
> >=20
> > having set
> > 	unsigned long timeout =3D jiffies + msecs_to_jiffies(1000);
> >=20
> > so it can busy-loop for up to 1 second.  Probably not ideal, but if it =
works
> > I wouldn't complain.
> >=20
> > The
> > 	if (int_usb & MUSB_INTR_SESSREQ) {
> > branch of musb_stage0_irq() called from musb_interrupt (from
> > generic_interrupt) calls this:
> >=20
> > 	if (musb->int_usb)
> > 		retval |=3D musb_stage0_irq(musb, musb->int_usb,
> > 				devctl, power);
> >=20
> > so the busy loop can happen in an interrupt handler (not a threaded int=
errupt
> > handler), which is probably less ideal.
> >=20
> > However this can be called with interrupt disabled, as happens at least
> > during resume when resume_irqs() calls:
> >=20
> > 		raw_spin_lock_irqsave(&desc->lock, flags);
> > 		__enable_irq(desc, irq, true);
> > 		raw_spin_unlock_irqrestore(&desc->lock, flags);
> >=20
> > and an interrupt is found to be IRQS_PENDING.
> >=20
> > In this case interrupts are disabled so 'jiffies' never changes so this=
 loop
> > can continue forever.
> >=20
> > This happens on my (GTA04) phone fairly regularly - between 1 in 10 and=
 1 in
> > 30 resumes. The musb-hdrc interrupt is pending and reports
> >=20
> > [ 4957.624176] musb-hdrc musb-hdrc: ** IRQ peripheral usb0040 tx0000 rx=
0000
> >=20
> > 'usb0040' is MUSB_INTR_SESSREQ.  I think this is triggered by detecting=
 a
> > voltage change on the USB ID pin - is that right?  A short-to-earth wou=
ld be
> > a request to switch to host mode, which is why it tries to enable VBUS.
> > Maybe there is some electrical noise which is being picked up?
>=20
> I guess that could happen if the transceiver pins are floating during sus=
pend?
> =20
> > In any case I get the interrupt despite nothing being plugged in, and t=
he 0x80
> > bit of MUSB_DEVCTL never gets cleared.
>=20
> As far as I remember, musb tries to be smart about changing to host mode,
> and tries to do the session and vbus detection on it's own.. AFAIK, there=
's
> nothing you can do until musb is done and detects the VBUS is not rising =
and
> gives up. There are all kind of interrupt flag combinations trying to deal
> with that mess, maybe you need to add yet another one?
> =20
> > I've added a simple loop counter which aborts the loop after 1000 loops=
 -
> > this takes about 5 seconds, but includes some printks which probably sl=
ow it
> > down.
> >=20
> > In 2 out of 2 cases, subsequent messages show that the hsmmc driver for=
 the
> > uSD card that holds my root filesystem is messed up.  It seems to be wa=
iting
> > for a request that is never going to complete.
> > So maybe the hsmmc is causing the noise that triggers the musb issue.
> >=20
> > I can send a patch which add a loop count if you like, but I suspect yo=
u can
> > come up with a much better approach.
>=20
> Sounds like that loop should be fixed.
>=20
> Regards,
>=20
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/H1XTguaZp8B+EHlTNTMFUuo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBXScjnsnt1WYoG5AQJ4JxAAp+RcXP+h2l1mPeIdRycGB2fZDs6O/TWJ
U+VqnKp0g1o9H2LD1+au90tWObSndh/9TIl4oBRQPkMxSu8Rtidke0J+cguio38o
TO8sNCzqijU9DL3lO+syMfgRwWYZ38PSMZno6Qzwho4Nl20IFohIJCbN6gS+hjWO
m7LxYTvfoJKnxS+EXA/y10tvAUupY3e9V9rHE/ZwC0ypOnJFShl0NAC9dKmRgeAo
FIR3eK2qsNU602mX24VhIwqxoLwzTUVYsZ88dZZu0rYwohPH7Bn0089Xw1LRwC2e
Oqyc3zKmnAWVdJs70OH8O7tQUJvAiwgAbpFBH6jMFfP2Qjq7FbpS3nVdyYeGLwz6
whl8KbLXvkzazLbRUy2Mk7+exdFYpsQYgghvo6u4xV0HHXu1NFe08GU/Z+iY4g+l
2/2P2ILNfPKii/5E1areX/cvHOKec26xr6mFV9FMeUWPQOrYhA1wi4h76uZiWcqL
53NnXGT6AulYEImcCbUZfOOBHRZAqKL3qwTe2tvB6kJJIV8A2syZzFzTWN/dGDR1
vg84Y8rc4PNpYP+IcuFFbxXN7+OygpnNJWsLtLMwD94hIAiUl3osinuAEvIDIOU9
L0ETZbDDQh9/z/yvb2MSIM4yOBSCfe2yQcFOPV7+cpSukNDAzerMSkRa4u/JfsgY
pzTgrOQHVqY=
=JUK7
-----END PGP SIGNATURE-----

--Sig_/H1XTguaZp8B+EHlTNTMFUuo--
