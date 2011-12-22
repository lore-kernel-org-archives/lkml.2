Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1LVHFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:05:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1LVHFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:05:34 -0500
Date: Thu, 22 Dec 2011 18:05:17 +1100
From: NeilBrown <neilb@suse.de>
To: Brian Swetland <swetland@google.com>
Cc: david@lang.hm, Tim Bird <tim.bird@am.sony.com>, Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222180517.20bce47d@notabene.brown>
In-Reply-To: <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
References: <4EF264C3.6000104@am.sony.com>
	<20111221231956.GB23859@suse.de>
	<4EF27B85.9080801@am.sony.com>
	<20111222122026.3a0fae36@notabene.brown>
	<alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
	<CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pa/uL3aP/jXHBR6Dqh5V/Cc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pa/uL3aP/jXHBR6Dqh5V/Cc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Dec 2011 21:06:02 -0800 Brian Swetland <swetland@google.com> wro=
te:

> On Wed, Dec 21, 2011 at 8:52 PM,  <david@lang.hm> wrote:
> > On Thu, 22 Dec 2011, NeilBrown wrote:
> >>
> >> You would defined 'read' and 'write' much like you currently do to cre=
ate
> >> a list of
> >> datagrams in a circular buffer and replace the ioctls by more standard
> >> interfaces:
> >>
> >> LOGGER_GET_LOG_BUG_SIZE would use 'stat' and the st_blocks field
> >> LOGGER_GET_LOG_LEN would use 'stat' and the st_size field
> >> LOGGER_GET_NEXT_ENTRY_LEN could use the FIONREAD ioctl
> >> LOGGER_FLUSH_LOG could use ftruncate
> >>
> >> The result would be much the same amount of code, but an interface whi=
ch
> >> has
> >> fewer details hard-coded and is generally more versatile and accessibl=
e.
> >
> > That sounds better than what has been done in android, but it is still =
_far_
> > more limited than doing something that could be replaced by a fairly
> > standard syslog daemon.
>=20
> We're really not interested in adding another daemon to the platform
> -- the logging system we have has served us well, is integrated with
> our existing development tools, and we're definitely interested in
> improving it, but throwing it out and replacing it with a userspace
> solution is not interesting to us right now.
>=20
> Brian

Possibly it would be useful to be clear what we all *are* really interested
in, because I suspect there is a lot of variety.

You appear to be interested in providing a great platform for a phone, in
minimising unnecessary churn in that platform, and in having the freedom to
optimise various aspects however you see fit.  You appear to have little
problem with maintaining some components out-of-mainline. This is all
perfectly valid and very much in the spirit of "freedom" that binds us
together.

Others want to be able to run a main-line kernel underneath the Android
user-space - and that is perfectly reasonable as well.

I don't much care about either of those, but I want "Linux" to be "high
quality" (according to my own personal standards of course) which means
keeping bad stuff out (though you could argue that the horse has well and
truly bolted there) and including good and useful stuff in.  And I think
Android has something to offer on both sides there :-)


Weighing all that up, I don't think it is useful to set our goal on "getting
Android to use a mainline kernel" - that isn't going to happen.
Rather we should focus primarily on "making it *possible* to run android
user-space on mainline".

That could involve two things
1/ Making sure the interfaces that Android uses are abstracted at a suitable
  level so that when running a mainline kernel you can just slip in an
  alternate shared library with compatible functionality.
2/ Adding functionality to Linux so that it is possible to provide the
  functionality that Android needs.

Android should not *have* to use the interface that the "mainline
community" decides is preferred, but nor should mainline be required to
include the drivers that Android wants to use.  History shows us that isn't
going to happen.

But if there was a fairly low-level API that Android used, then those in the
community could who want Android on a mainline kernel could work to impleme=
nt
that API with whatever mixture of user-space and kernel-space that achieves
consensus.
Android could of course change to use the community version eventually if
they found that was a good thing, or could keep using their own.

So: bringing this back to the android logger...
  What I would like to see is a low-level API which is used to access loggi=
ng
  for which alternate implementations could be written.  Ideally this would
  be embodied in a single .so, but we have the source so that doesn't need =
to
  be a barrier.
  Then we could argue to our heart's content about how best to implement th=
at
  API - Journal and nsyslogd and rsyslogd could all implement it in differe=
nt
  ways and we could be one step closer to running Android on a mainline
  kernel, but the Android developers don't need to be involved (but can if
  they want to of course).

  I would be important that the API is specified clearly - neither under
  specified nor over-specified. That means that the Android implementation
  would need to explicitly forbid anything that isn't explicit permitted.
  This is because most testing will happen on the Android platform so it's
  actual behaviour will become the defacto standard.

  Could that be a possible way forward?

NeilBrown


--Sig_/pa/uL3aP/jXHBR6Dqh5V/Cc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvLWrTnsnt1WYoG5AQJ0qQ//exS53IVjH6roGJ0eWJlZAG4UBoWK8B3c
gcDBvL7JQ/OpKR3UZRrG3jeAzsaiCQEtr3eaO8+xf5fmNEF82vat+O8j9AhrUYYw
ZnGiM5B2Mn8TOm8wTJgkzCb4ZwnxeRfK3C2MU36OE78dhS+lo2Zonf5YIvELK3Jh
YdO8rWIB77yMMnWWZWTSGgONg2KAR8glv3vv4V3jkfZ5sMbzDn0d3LHUGvppGqQc
GQ12D3m5eGAYYINUGFoCEPLxgnx5o8FhkzoTnL4E5cDneaW2U1GeBdxD0e5Bu2bs
cqITUV5mEMY5kkyQR39YI3Vr3I7YtFx8E5mWQSX0/yGzWmfb5TiLXs3LCBVq2fQC
TLiDBuhUi2X42itwZdyrHCR6xQnlFYfNjQ1Ai1va7UY6RD5ja0L8l342NbW1ZV26
CTNbK4A24FK//Iioo2cMBlMiXix3BrP/7hfweLUjHVoHOo+vTLaLb5itgLnVnp9C
Yr2AboucANx8A3nf3sobhgMgYBgHAQtulQbQWLROPY+u2rwVNUKsMu1Cs3mWVKOU
8GMPW0WgYE/Sqn62Y2jqjSXzMLXfBY1Xa8OMUR9OzYFZ5+xfvTTYfqKiyvC6gT6r
pLRkRV1FZcBVN9xmhideU0sBR7L0qJO5P68rSdPQCdMkt/Zg0uDRBEUrLfbpBVXZ
XT7mo+9ynjg=
=oN0X
-----END PGP SIGNATURE-----

--Sig_/pa/uL3aP/jXHBR6Dqh5V/Cc--
