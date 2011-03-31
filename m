Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab1CaQPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:15:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51575 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab1CaQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:15:04 -0400
Date: Thu, 31 Mar 2011 12:14:56 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110331161456.GA4848@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
 <1301378637.2402.671.camel@pasglop>
 <20110329142519.GA3527@mgebm.net>
 <1301433165.2402.689.camel@pasglop>
 <20110330183656.GA2564@mgebm.net>
 <1301551476.2407.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1301551476.2407.61.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
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

Sorry for being so dense on this, but I think that when a counter overflows
both the register value and the previous value are reset so we should conti=
nue
seeing new event counts after the overflow interrupt handler puts the count=
er
back into a sane state.  What am I not seeing?

Eric

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNlKiAAAoJEH65iIruGRnNXC4H/jIypzBvUbj4p9smNKFIenpz
5Hoc4+i96p/zFQO25N5AP43rJ/OOzFBq2d+fQtq3S4vkmxz8VdTWXshARUfQ6i7D
pV8VgUjaLb9arR9A+kWYEV+3JECQgRAk4NYBIgbhwuSr7mzLor/ZnvKwvfmscJGo
6H3D0jWDFCjlsDJy+5G/jF4bYTdzrACy6XJ9AAY9HDfy9b3GXnqTxRIyuCdAwT+0
C6J9kOPEPPbTWhNIDygmFHHiihkBExl5VMY1lheLs4/tz1zg7Nu50/E/kA7rM1F2
EiwZm72/PeCRDBc1+r59DQFY+w7F2tp/euIF9jKe/PIkUoo1X5MpoVkJvf+aX4M=
=TgmP
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
