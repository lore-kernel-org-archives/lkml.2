Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0HQK2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:28:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40539 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0HQK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dW7MuQ8pxGj3R+j4mNH1yFBmngLvyPQPqVDIZBa/mKplLqlMLxvWC/89PtsxtX1p3T
         CqGV7ApXEozIvz/9sZUj4Nwt/zKtEn1y9iKBz3uW7D4vEv0cLe6vW1ZjTHvy2cFya6gW
         yXMbT5DqrNfu8bWwp15XKlmxC/LMfHFVvE6Gs=
Date: Tue, 17 Aug 2010 13:28:19 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817102819.GC12022@swordfish.minsk.epam.com>
References: <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/17/10 17:37), Yong Zhang wrote:
> On Tue, Aug 17, 2010 at 5:24 PM, Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com> wrote:
> > OK. Suppose (I don't know if it could) migration has happen
> >
> > acpi_os_stall
> > =A0 =A0 =A0 =A0__migration__
> > =A0 =A0 =A0 =A0touch_nmi_watchdog
> >
> > How calling raw_smp_processor_id() (which is current_thread_info()->cpu)
> > vs. preepmt_disable - smp_processor_id() will give us different CPUs?
>=20
> I don't mean you will get different CPUS(sorry for my poor english).
> I mean if the migration could happen, you want to touch_nmi_watchdog()
> on CPU A(otherwise the watchdog will shout on us), but eventually we
> touch_nmi_watchdog() on CPU B(because of migration),
> and this is not what we want.
>=20
> So preempt_disable() is redundant here.
>

Shouldn't we be for sure not preepmtible when calling __raw_get_cpu_var?

preempt_disable is reduntant here because current_thread_info()->cpu is=20
atomic and we just don't want preempt_(enable|disable) overhead?

	Sergey
=20
> >
> >> So I prefer using __raw_get_cpu_var() as what we have been done before.
> >>
> >
> > Hm...
> >
> > 26e09c6eee14f4827b55137ba0eedc4e77cd50ab
>=20
> f69bcf60c3f17aa367e16eef7bc6ab001ea6d58a
> 2508ce1845a3b256798532b2c6b7997c2dc6533b
>=20
> you can get the previous touch_*_watchdog there.
>=20
> Thanks,
> Yong
>=20

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxqZEMACgkQfKHnntdSXjRPygP/YROxTNjFZb2TSdgF+eogo8hE
Zf0uZJ+mo47eoQ3D8xM+nSp/eJrWmp0WbHkh+Q3D6pZLiSEof3d3TuRgP0N3bA/i
81KKdG/TM00Y+H8L8LB7TdMCGAcwofcnJOgiwf+HHqE1elXuqyiaoNAa2/sSgKqM
4UjC79cCCJc3/zXlX68=
=6aYA
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
