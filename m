Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2DYU6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:58:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2DYU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:58:08 -0400
Date: Thu, 26 Apr 2012 06:58:03 +1000
From: NeilBrown <neilb@suse.de>
To: anish kumar <anish198519851985@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: twl4030 power button: don't lose presses on
 resume
Message-ID: <20120426065803.59b96cb3@notabene.brown>
In-Reply-To: <1335372965.1571.15.camel@anish-Inspiron-N5050>
References: <20120425122139.512c6890@notabene.brown>
	<20120425050919.GB27843@core.coreip.homeip.net>
	<20120425152603.3d24547f@notabene.brown>
	<1335372965.1571.15.camel@anish-Inspiron-N5050>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3mj.ZNCrn8VY3eb9nzop1V5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3mj.ZNCrn8VY3eb9nzop1V5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 22:26:05 +0530 anish kumar <anish198519851985@gmail.com>
wrote:

> On Wed, 2012-04-25 at 15:26 +1000, NeilBrown wrote:
> > On Tue, 24 Apr 2012 22:09:19 -0700 Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> >=20
> > > Hi Neil,
> > >=20
> > > On Wed, Apr 25, 2012 at 12:21:39PM +1000, NeilBrown wrote:
> > > >=20
> > > > If we press and release the power button before the press interrupt=
 is
> > > > handled - as can happen on resume - we lose the press event so the
> > > > release event is ignored and we don't know what happened to cause t=
he
> > > > wakeup.
> I didn't understand this.If power button is waking up the device then
> obviously power button interrupt handler is called right?If yes then how
> can we lose the press event?Is user space not ready to take the event?
> May be I didn't understand it properly.Can you kindly explain?

Yes, the interrupt handler is running.

However the way the driver is currently written, an interrupt is not enough
to generate an "button press" event.
What happens is when the kernel-thread half of the interrupt handler finally
runs, it samples the state of the button and generates an event based on th=
at
level.  So if the button has been released again by the time the ISR runs,
then only a "button release" event is generated.

When this gets to the input layer, the input later *knows* that the button =
is
currently released so it suppresses the new "button release" event.
A "sync" event does still get through to the App, but they can come at all
sorts of time even when nothing is happening to the button, so they are best
ignored (when by themselves).

What the driver needs to do is acknowledge that just getting an interrupt
means  that something changed, and to ensure that a change gets passed up to
the input layer.

Is that clearer?

Thanks,
NeilBrown


> > >=20
> > > What kind of latency do you observe?
> >=20
> > When I have debugging enabled, hundreds of milliseconds.
> >=20
> > When I don't have debugging enabled ... it doesn't tell me, but I'm fai=
rly
> > sure it is several tens of milliseconds and the button press can be qui=
cker
> > than that.
> >=20
> > If it will help I can try to instrument the driver and get some timings.
> >=20
> > >=20
> > > >=20
> > > > So make sure that each interrupt handled does generate an event.
> > > > Because twl4030 queues interrupt events we will see two interrupts
> > > > for a press-release even if we handle the first one later.  This me=
ans
> > > > that such a sequence will be reported as two button presses.  This
> > > > is unfortunate but is better than no button presses.
> > > > Possibly we could set the PENDDIS_MASK to disable queuing of
> > > > interrupts, but that might adversely affect other interrupt sources.
> > > >
> > >=20
> > > It looks like we'd have to modify every driver to ensure consistent
> > > behavior as we do not have any guarantees on how long resume takes.
> > > Maybe this is something that input core needs to implement?
> >=20
> > Well if every driver is buggy....
> >=20
> > I don't see how this could be implemented in the input core.  And even =
if it
> > was, you'd probably need to change each driver to interact with this new
> > functionality which would be much the same work as changing them to wor=
k with
> > the current functionality....
> > But maybe I have no imagination - if you can suggest a way that the inp=
ut core
> > could support this without changing the drivers, I'm happy to try it ou=
t.
> >=20
> > Thanks,
> > NeilBrown
>=20


--Sig_/3mj.ZNCrn8VY3eb9nzop1V5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5hlWznsnt1WYoG5AQLeDw/7BDQWfOmUGXmaMI6Yj8sNhPaxnKasXsa7
KA0RdzSrZYeRpfPJ/Tyx/kqew/EJisrBtOlhHWxCT3egODAj5aQnoUVcl4uCKzET
046uCeLibUGB4m+CeT2JfF7bJ75RMQ+FX96jB8v6N8L8K1mys8EIpC/sPebpmWNh
BOXyK3haBY1yvURIabwfFrbOWOWjY7KEK7HyaaoAJ6UVD8CPamZ2vTQJR/vbATD0
5R6ijJFhysBcur86yolcJcrJk9MXb8M9MXZuV+Cr8PcnxaaP9p3WvbFrou4LRsiS
1CTJX01oZZqJ0NTpl5+MnBpcHZ76hyXyjRMtGJUmqmnRSeUtv/p9eJHXu9ChiGp3
nSpD3ZpKjeD2ynlcNVaj2kkdcMveh1C2orq5EoUDHfP21JHRV8dEm3ZiI5VW7gWD
PpMi1Mdc5YlSnPDuH9tWw8qz1tL9mBkpwYFbpsasTtYHAX3glnhaUlKGz3uYkgiU
RGOzRfY6ItzfAjjfMD+50yzNfhnlqBRciAFMFdYja/uqes0OTL0es8IA04zgVBjj
IM/ZznderacpiKmZ9uxifh+JbDEj7tT2kqGClMovz7NgQrO8SWIdMKzm0ZBeHrXC
YGzHOjLOVLLsGA/4NxF+SEa0/n7KQQ5IHKL4X7RSrzclzZr4MGAKipzW3TgMh3fK
UfOqVLxUfb8=
=ikK2
-----END PGP SIGNATURE-----

--Sig_/3mj.ZNCrn8VY3eb9nzop1V5--
