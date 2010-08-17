Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0HQJY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:24:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48905 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab0HQJY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PrLJ2BNdJvSxaON2MHk/ulSwAkn/DRR0zuewdp31AjaJ85YFEzACn4eCIq+R5xcG97
         MPLRMMzkLguv+2wkiD+cyvnfLHWGDV6y+bpjQKoLA6MMyHqcwjDPPe0XorpSk27et7ZL
         gWA6FmVJ2ls0s8Fj7O3Y0noqw1GEY/+MKd82Q=
Date: Tue, 17 Aug 2010 12:24:07 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817092407.GB12022@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/17/10 17:05), Yong Zhang wrote:
> >> Why not use __raw_get_cpu_var() instead?
> >> You know adding preempt protection in touch_softlockup_watchdog()
> >> just suppress the warning. Am I missing something?
> >>
> >
> > Sorry, my low level understanding of the __raw_get_cpu_var isn't very s=
trong.
> > I assume it uses current_thread_info()->cpu in some cases (right?) or
> > percpu_from_op.
>=20
> The difference is __raw_get_cpu_var() is using raw_smp_processor_id().
>=20
> >
> >
> > Should it be
> > acpi_os_stall
> > =A0 =A0 =A0 =A0preepmt_disable
> > =A0 =A0 =A0 =A0touch_nmi_watchdog
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0touch_softlockup_watchdog
> > =A0 =A0 =A0 =A0preempt_enable
>=20
> Actually I don't think this is helpful for the whole function. Because
> if acpi_os_stall()
> migrate(I don't know if it could) to another CPU just before
> preepmt_disable(), we'll
> be on the wrong way. Adding preempt protection is just smoothing the warn=
ing.
>

OK. Suppose (I don't know if it could) migration has happen=20

acpi_os_stall
	__migration__
	touch_nmi_watchdog

How calling raw_smp_processor_id() (which is current_thread_info()->cpu)
vs. preepmt_disable - smp_processor_id() will give us different CPUs?
=20
> So I prefer using __raw_get_cpu_var() as what we have been done before.
>=20

Hm...

26e09c6eee14f4827b55137ba0eedc4e77cd50ab

 static void __touch_watchdog(void)
 {
-       int this_cpu =3D raw_smp_processor_id();
+       int this_cpu =3D smp_processor_id();


	Sergey

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxqVTcACgkQfKHnntdSXjR6mwP+NpjyeRRIl8fc+qcvwRXSouwz
kOdWultVL12Y4kTMEnIUz2JWMGVNjQBszlPSJ7vnZ3WNtiIK5IiurukhBNHBnCxF
u6e3LdZny10nXClPYE2ICzJDHpKc9Wl8otFmABr4c2kPjKmg9repuij3S8szEvEV
s62671dlnYazEqTwA8s=
=Si8t
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
