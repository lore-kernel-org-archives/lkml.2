Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1C2OZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:25:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56143 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1C2OZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:25:23 -0400
Date: Tue, 29 Mar 2011 10:25:19 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110329142519.GA3527@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
 <1301378637.2402.671.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1301378637.2402.671.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Mar 2011, Benjamin Herrenschmidt wrote:

> On Fri, 2011-03-25 at 09:28 -0400, Eric B Munson wrote:
> > It is possible on POWER7 for some perf events to have values decrease. =
 This
> > causes a problem with the way the kernel counters are updated.  Deltas =
are
> > computed and then stored in a 64 bit value while the registers are 32 b=
its
> > wide so if new value is smaller than previous value, the delta is a very
> > large positive value.  As a work around this patch skips updating the k=
ernel
> > counter in when the new value is smaller than the previous.  This can l=
ead to
> > a lack of precision in the coutner values, but from my testing the valu=
e is
> > typcially fewer than 10 samples at a time.
>=20
> Unfortunately the patch isn't 100% correct I believe:
>=20
> I think you don't deal with the rollover of the counters. The new value
> could be smaller than the previous one simply because the counter just
> rolled over.
>=20
> In cases like this:
>=20
> > @@ -449,8 +458,10 @@ static void freeze_limited_counters(struct cpu_hw_=
events *cpuhw,
> >  		val =3D (event->hw.idx =3D=3D 5) ? pmc5 : pmc6;
> >  		prev =3D local64_read(&event->hw.prev_count);
> >  		event->hw.idx =3D 0;
> > -		delta =3D (val - prev) & 0xfffffffful;
> > -		local64_add(delta, &event->count);
> > +		if (val >=3D prev) {
> > +			delta =3D (val - prev) & 0xfffffffful;
> > +			local64_add(delta, &event->count);
> > +		}
> >  	}
> >  }
>=20
> I wonder if it isn't easier to just define delta to be a s32, get rid
> of the mask and test if delta is positive, something like:
>=20
> 		delta =3D  val - prev;
> 		if (delta > 0)
> 			local64_add(delta, &event->count);
>=20
> Wouldn't that be simpler ? Or do I miss a reason why it wouldn't work ?

Here I made the assumption that the hardware would never remove more events=
 in
a speculative roll back than it had added.  This is not a situation I
encoutered in my limited testing, so I didn't think underflow was possible.=
  I
will send out a V2 using the signed 32 bit delta and remeber to CC stable
this time.

Eric

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNkevPAAoJEH65iIruGRnNTq8H/3dJcVhIDcO9F9P4GQE5Ll5s
zzYr/QHIfnCKWYcDCqKMDwbQbOFzqRmWNNpliESDKDZBCB5TaoehsmW3/G75xHoP
MEWWm/Yqb93UreIEioy8SiUqTXd0c4ppthnFAl5dD9Q/eKVfGNHCbEYGYJdXb4KS
FGlejn4OVeYOyEv8xum109PNf2XKn3FrSsO0ISpufJ3Wcqx5k7OAPqkkRNU+9Eo0
qCm1ilNXmFF2hLUDS+sdK83ra0CdKor8VsEGGaqIZgncyAZLklZPU2Qkt8hkYvG1
Cbtj0bW+W6YlvU/S1tH7N/Isgd++5Ljfvu2Lwwe8KjiEjsLw9Eo1jYFSQpdR30E=
=gssM
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
