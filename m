Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1BNMc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:32:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49341 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1BNMcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DJy5sxDI9ayb5TrRU9mw6cFSuVxx2x2PerSR+9j0/bLwO3rE/uKZwelLRYcuxHHequ
         3KSuvyj1BCeM5sDr/DseRkQ4+aFWzg/7rOK/CwewX8J1Hosx+QHuR5U56/7B3nPXaP4i
         R59ow0MGsSQgacJFegoqPKq0yvt7vnDLN9fqo=
Date: Mon, 14 Feb 2011 14:32:44 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH] x86: fix section mismatch in reference from
 native_play_dead
Message-ID: <20110214123244.GA4586@swordfish.minsk.epam.com>
References: <20110203131333.GA4161@swordfish.minsk.epam.com>
 <20110214122550.GA15860@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20110214122550.GA15860@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (02/14/11 13:25), Ingo Molnar wrote:
> * Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
>=20
> > Fix=20
> >=20
> > WARNING: arch/x86/kernel/built-in.o(.text+0x19cde): Section mismatch in=
 reference from=20
> > the function native_play_dead() to the function .cpuinit.text:mwait_usa=
ble()
> > The function native_play_dead() references the function __cpuinit mwait=
_usable().
> >=20
> >=20
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >=20
> > ---
> >=20
> >  arch/x86/kernel/smpboot.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index 0cbe8c0..0b8c6c9 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -1467,7 +1467,7 @@ static inline void hlt_play_dead(void)
> >  	}
> >  }
> > =20
> > -void native_play_dead(void)
> > +void __cpuinit native_play_dead(void)
> >  {
> >  	play_dead_common();
> >  	tboot_shutdown(TB_SHUTDOWN_WFS);
>=20
> I think the right fix is Boris's fix below. Agreed?
>=20
[..]
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 6e6e755..4564c8e 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -32,6 +32,6 @@ extern void arch_unregister_cpu(int);
> =20
>  DECLARE_PER_CPU(int, cpu_state);
> =20
> -int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
> +int mwait_usable(const struct cpuinfo_x86 *);
> =20
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index e764fc0..3c189e9 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -506,7 +506,7 @@ static void poll_idle(void)
>  #define MWAIT_ECX_EXTENDED_INFO		0x01
>  #define MWAIT_EDX_C1			0xf0
> =20
> -int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
> +int mwait_usable(const struct cpuinfo_x86 *c)
>  {
>  	u32 eax, ebx, ecx, edx;
> =20
>=20

`int mwait_usable(..)' is called from `void __cpuinit select_idle_routine(.=
=2E.)'

I think we still have section mismatch in this case. Is it correct?


	Sergey

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1ZIOwACgkQfKHnntdSXjTPywP/UCVIH77UiAdSBLogBZoLCJwJ
+u6mplcyiC/CpLt2MEr8xowv1fq5M5LMe+Wi//GUklbNZzaqDSnsP2oGlCf0oa+7
sAq79ZLSSxg7utJK5u9IK9JRCxcVGBBxKdBoJhlbxipficLfeM1REeb8n8WtQUZY
KWJkAribHnxGs6N+zUg=
=4WpY
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
