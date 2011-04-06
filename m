Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1DFV1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:27:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59132 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab1DFV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:27:37 -0400
Date: Wed, 6 Apr 2011 17:27:33 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110406212733.GB2596@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
 <1301378637.2402.671.camel@pasglop>
 <20110329142519.GA3527@mgebm.net>
 <1301433165.2402.689.camel@pasglop>
 <20110330183656.GA2564@mgebm.net>
 <1301551476.2407.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <1301551476.2407.61.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Mar 2011, Benjamin Herrenschmidt wrote:

> On Wed, 2011-03-30 at 14:36 -0400, Eric B Munson wrote:
> > On Wed, 30 Mar 2011, Benjamin Herrenschmidt wrote:
> >=20
> > > On Tue, 2011-03-29 at 10:25 -0400, Eric B Munson wrote:
> > > > Here I made the assumption that the hardware would never remove mor=
e events in
> > > > a speculative roll back than it had added.  This is not a situation=
 I
> > > > encoutered in my limited testing, so I didn't think underflow was p=
ossible.  I
> > > > will send out a V2 using the signed 32 bit delta and remeber to CC =
stable
> > > > this time.=20
> > >=20
> > > I'm not thinking about underflow but rollover... or that isn't possib=
le
> > > with those counters ? IE. They don't wrap back to 0 after hitting
> > > ffffffff ?
> > >=20
> >=20
> > They do roll over to 0 after ffffffff, but I thought that case was alre=
ady
> > covered by the perf_event_interrupt.  Are you concerned that we will re=
set a
> > counter and speculative roll back will underflow that counter?
>=20
> No, but take this part of the patch:
>=20
> > --- a/arch/powerpc/kernel/perf_event.c
> > +++ b/arch/powerpc/kernel/perf_event.c
> > @@ -416,6 +416,15 @@ static void power_pmu_read(struct perf_event *even=
t)
> >  		prev =3D local64_read(&event->hw.prev_count);
> >  		barrier();
> >  		val =3D read_pmc(event->hw.idx);
> > +		/*
> > +		 * POWER7 can roll back counter values, if the new value is
> > +		 * smaller than the previous value it will cause the delta
> > +		 * and the counter to have bogus values.  If this is the
> > +		 * case skip updating anything until the counter grows again.
> > +		 * This can lead to a small lack of precision in the counters.
> > +		 */
> > +		if (val < prev)
> > +			return;
> >  	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) !=3D prev);
>=20
> Doesn't that mean that power_pmu_read() can only ever increase the value =
of
> the perf_event and so will essentially -stop- once the counter rolls over=
 ?
>=20
> Similar comments every where you do this type of comparison.
>=20
> Cheers,
> Ben.

Sorry for the nag, but am I missing something about the way the register and
the previous values are reset in the overflow interrupt handler?

Thanks,
Eric

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNnNrFAAoJEH65iIruGRnNDSgIANiVEWRw2KhUErflFUPV0Gs4
w8+7Bz1xPAdiPprxe7DbYn9GxEyvJ23kCmnCxetFrixX1+o0SPT0iyVip4GRfWHw
oLDXuRCuqrOjctugNIfJM+CFAxlOtzooKjedXjlRsTCW+BMv7CvjahQR0+ecpunh
0462K+CUTJh42ZBbJaRiomiWWMveRvInXpKYVarHaOO6OfqYl7p21UvFomTUyu8Z
NTk0X38TG4KEfpghr3aIHKwYFCBE53bRE54A3LnQijq0P1CxHWEQgpRulHwRZZwz
r4uPrs23gBuMeh5I/lToWGRv1G+QW4TVh5wqGkHR85XussvYA4Bpm29WpR8cX5Y=
=X0/4
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
