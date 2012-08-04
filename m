Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2HDPlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 11:41:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35398 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333Ab2HDPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 11:41:39 -0400
Message-ID: <1344094877.4642.183.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 33/73] x86, microcode: Sanitize per-cpu microcode reloading
 interface
From: Ben Hutchings <ben@decadent.org.uk>
To: Borislav Petkov <bp@amd64.org>
Cc: Sven Joachim <svenjoac@gmx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Winchester <kjwinchester@gmail.com>
Date: Sat, 04 Aug 2012 16:41:17 +0100
In-Reply-To: <20120803122727.GA32299@aftab.osrc.amd.com>
References: <20120731044310.013763753@decadent.org.uk>
	 <20120731044316.585695559@decadent.org.uk> <87y5lw73eh.fsf@turtle.gmx.de>
	 <20120803094314.GB31792@aftab.osrc.amd.com>
	 <20120803122727.GA32299@aftab.osrc.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6JsGlsxpzwMIFzTJqTNq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6JsGlsxpzwMIFzTJqTNq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-03 at 14:27 +0200, Borislav Petkov wrote:
> On Fri, Aug 03, 2012 at 11:43:14AM +0200, Borislav Petkov wrote:
> > On Fri, Aug 03, 2012 at 11:04:06AM +0200, Sven Joachim wrote:
> > > On 2012-07-31 06:43 +0200, Ben Hutchings wrote:
> > >=20
> > > > 3.2-stable review patch.  If anyone has any objections, please let =
me know.
> > >=20
> > > Alas, this does not build if CONFIG_SMP is unset:
> > >=20
> > > ,----
> > > | arch/x86/kernel/microcode_core.c: In function 'reload_store':
> > > | arch/x86/kernel/microcode_core.c:304:19: error: 'struct cpuinfo_x86=
' has no member named 'cpu_index'
> > > `----
> >=20
> > Crap. :-(
> >=20
> > 3.2 still has this:
> >=20
> > <arch/x86/include/asm/processor.h>:
> > ...
> > #ifdef CONFIG_SMP
> >         /* number of cores as seen by the OS: */
> >         u16                     booted_cores;
> >         /* Physical processor id: */
> >         u16                     phys_proc_id;
> >         /* Core id: */
> >         u16                     cpu_core_id;
> >         /* Compute unit id */
> >         u8                      compute_unit_id;
> >         /* Index into per_cpu list: */
> >         u16                     cpu_index;
> > #endif
> >         u32                     microcode;
> > } __attribute__((__aligned__(SMP_CACHE_BYTES)));
> > ---
> >=20
> > which got removed by
> >=20
> > commit 141168c36cdee3ff23d9c7700b0edc47cb65479f
> > Author: Kevin Winchester <kjwinchester@gmail.com>
> > Date:   Tue Dec 20 20:52:22 2011 -0400
> >=20
> >     x86: Simplify code by removing a !SMP #ifdefs from 'struct cpuinfo_=
x86'
> >=20
> > Ben, you might want to backport this one too... I'll run a couple of 3.=
2
> > builds with it ontop of 3.2 to verify nothing else breaks.
>=20
> Ok, 141168c36cdee3ff23d9c7700b0edc47cb65479f doesn't apply cleanly to
> 3.2-stable, as expected. I've attached a partly backported version. Why
> partly? Well, it broke an UP build in mainline which got fixed later by
>=20
> commit 3f806e50981825fa56a7f1938f24c0680816be45
> Author: Borislav Petkov <bp@alien8.de>
> Date:   Fri Feb 3 20:18:01 2012 +0100
>=20
>     x86/mce/AMD: Fix UP build error
>    =20
>     141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs
>     from 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs
>     around code touching struct cpuinfo_x86 members but also caused
>     the following build error with Randy's randconfigs:
>    =20
>     mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_sha=
red_map'
> ---
>=20
> which reverted what the original patch removed.
>=20
> So I've taken out the parts that introduce the breakage from the
> backport.
[...]

Thanks everyone for working this out.

If you combine multiple mainline commits like this, the new commit
message should refer to all of them.  I've fixed that up this time.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-6JsGlsxpzwMIFzTJqTNq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUB1Cnee/yOyVhhEJAQpviw/+MSXKVfPC3ZhthHmTfYUmv0gUI/JEzJ81
3Z/VEDyVCM+vS2NJzmGfGdjOhjg2o+6/Rmk1+caoaKu66rF8YrRsA0oHTzilvwWf
riYxyNPdhGGvTp/pHxFBZyrq9McsozfFnoYTo12BvwziQG8ut3xB1wMMl24CzPsL
Xp3wNo+Hqdln/OnENzVLHsEPIgxrtjf5razWWRbradjnsymzOfRzsm9WK31m14oK
pMmG1mRu8x7U0xEwggLnB4BsXJTNg8IxZc98crMOueZVfY9EgsMBFzhFJwCyiJQp
xC7k2X+SZIs0P14GVfC0k4xfyC5lSrr8H4l8hfO4U9tTy+TQX5PQBHLRmcnQFrve
9i9HhjnxX/VcGNmTc3n3jxMoS3gNGmEBMuxfrz8VTH6Hj4LErHbEopCCXcv55KoG
eHhhOKNuCeqRU0MYwIWI87nutCI5qBfcR1jYpYaYkRlQbcBG4k9BVVCttppRxxb/
P6jQ1DDdgktIy6254QzLnKf1rsTIQhwyK6cGyr//+HqLe59vD0T2ha/mgWKT1cO8
MbKHB75JUwLCO5UBe7SaMMwv5Kn/UCRXG4j31Q7wzyFvDZMIbfckHdVtzEn+tD3m
u9lSziSTuBAD30VLBSHDxVCCwKOffwrBPQJA4zgJokdujFnrBKWeBfIm3jfDj0CJ
y+inGALCIoY=
=dqb9
-----END PGP SIGNATURE-----

--=-6JsGlsxpzwMIFzTJqTNq--
