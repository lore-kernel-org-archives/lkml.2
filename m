Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab2IJXnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:43:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab2IJXnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:43:05 -0400
Date: Tue, 11 Sep 2012 09:42:52 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: Seeking clarity on IRQCHIP_MASK_ON_SUSPEND
Message-ID: <20120911094252.0e78a8f9@notabene.brown>
In-Reply-To: <alpine.LFD.2.02.1209101215300.2724@ionos>
References: <20120910165127.37dd07f3@notabene.brown>
	<alpine.LFD.2.02.1209101215300.2724@ionos>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lyusIv1AeH1QaHHCEhUcZsx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lyusIv1AeH1QaHHCEhUcZsx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 12:28:35 +0200 (CEST) Thomas Gleixner
<tglx@linutronix.de> wrote:

> On Mon, 10 Sep 2012, NeilBrown wrote:
> >=20
> > The IRQCHIP_MASK_ON_SUSPEND flag seems to be hard to use correctly, so =
either
> > I'm understanding it wrongly, or it could be made easier to use.
> > If the first case, I'm hoping that some improvement to documentation mi=
ght
> > result.  If the second, then maybe we can fix the code.
> ...=20
> > Is anyone able to give a definitive answer on this?  Should
> > IRQCHIP_MASK_ON_SUSPEND be removed?
>=20
> The whole point of IRQCHIP_MASK_ON_SUSPEND is to deal with hardware
> designed by geniuses.
>=20
> Most SoCs have a way to mark the interrupts which serve as a wake up
> source as such. All other interrupts are magically "masked" on entry
> to suspend.
>=20
> Now there is hardware which is missing such a control, so we need to
> mask the non wakeup interrupts right before going into suspend.

Even allowing for the obvious sarcasm, I'm having a lot of trouble
understanding the nature of this 'bad' hardware.

My understand of the SoC world is that the goal is for 'suspend' to be no
different from deep runtime PM (from a hardware perspective).  So where the=
re
is a way to mark an interrupt as a wakeup source, this is used both to supp=
ort
wakeup from suspend, and to support wakeup from deep runtime-PM

When it is used to wake-from-runtime-PM, the lazy interrupt masking is
sufficient to mask it when needed - the extra wakeup isn't a big cost.
When it is used to wake-from-suspend - lazy interrupt masking can cause an
unwanted wake from suspend which is much more expensive.

So even with sane hardware that supports marking interrupts as wakeup
sources, we still need do extra explicit masking for the suspend case, and
IRQCHIP_MASK_ON_SUSPEND looks like the tool to use ... except that as
described previously it doesn't work.

>=20
> That's what IRQCHIP_MASK_ON_SUSPEND does. Not more, not less. See
> commit d209a699a0b for more ugly details.

One detail that I get from that commit is that it was 'Reviewed-by' someone
from 'codeaurora', and that name appears in the pm8xxx-irq.c driver which is
one of the two users.  However that driver can only be used if
CONFIG_MSM_SSBI, and nothing ever devices that so it all seems completely
theoretical.

>=20
> You might be looking for a different functionality. Can you explain
> what you need?

I want as particular GPIO interrupt to be masked before entering suspend.
I produced code to get the ->suspend() callback to perform this masking.
Another developer (Santosh) felt that IRQCHIP_MASK_ON_SUSPEND was the
preferred way to do this and on the surface this looks like it should be
correct.  However it doesn't work as explained previously.
I want a resolution to this difference of opinion that doesn't just sweep t=
he
issue under that carpet but provides a clear answer to this sort of issue.

My current opinion is that IRQCHIP_MASK_ON_SUSPEND should be discarded.  The
patch which introduced it says:

    Rather than working around this in the affected interrupt chip
    implementations we can solve this elegant in the core code itself.
   =20
It appears that the solution in core code, while elegant, is wrong.  It
happens too late to be generally usable.  It is easy enough to handle this
issue in the interrupt chip drivers so maybe that is the best place to hand=
le
it.

The the very least I think we need a big comment saying the
IRQCHIP_MASK_ON_SUSPEND can only be used for irqchips which can always be
programmed, even when they are suspended from an runtime-PM perspective,
and that those chips must handle masking in their 'suspend' callback.

Thank,
NeilBrown

--Sig_/lyusIv1AeH1QaHHCEhUcZsx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE56/Dnsnt1WYoG5AQLD0BAAiGhsER6uFgcff7IZH5y3hUitqpI4vnTG
5WJ8Lw2Ta3DGDwy9WGbB1zy28FiBOph7XrgqZDDKPgJlJYmq6nWA5DGrIWdFTj1i
fCl33BbdR3Fdms4QSkmXLnJBlA60mUblboXZvUY9sp4AJLvMLitwJg6lFRrnahsG
tA67OFBQt4C7OMrwcrE1or706mNG2vBCyF/Zq4eyCtPyogypP6lIIszHBvyIDEiL
SGHqGsi/TBO3SMapnqttpXQ+QCgrAa3r8AsHspvO97nNakGUaSjh1rLyRrRWCAml
f+/1FN5wJbAALHZIHR9P72rVtEtZK76bh0Gt8P7bJ3v+oV8NPmY+/lS/Lifc9Xiy
x8iKPsZnCCeHYT2u4IGT9/ZLJHiqt3vWWHEPtJvC+msT5A70aGb+UVZg7Qu8MSEK
T3EUDefva7uvSv0z/F2so2JQoMmHO5VSKOsZvqI03l+daV6YKXoahNTZ5jEEsYZx
RsAPyKiY5ANXmlBFQHP8WYxbwn3W0JrZGcFTwzuM988j6QD5b551z3gcdIq4a5HI
FSzuPonMPC0SXj59hMQ1mK0WC/eSkF8Ql9LVWkFeic+lrWoesZjxLBTJN484/E5G
7O62TF1WgGutHm1m1fmCTv3qtUl0/7DJwNEuCKEvIsiqsD8Q0SQxjyYv5Bbf9LgB
9+TZ2aBtIYg=
=YwLf
-----END PGP SIGNATURE-----

--Sig_/lyusIv1AeH1QaHHCEhUcZsx--
