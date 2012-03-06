Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2CFGJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:09:55 -0500
Received: from mail.southpole.se ([193.12.106.18]:44881 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2CFGJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:09:54 -0500
Message-ID: <1331014165.19557.171.camel@satguru>
Subject: Re: [PATCH] OpenRISC: Handle r0 with care
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Tue, 06 Mar 2012 07:09:25 +0100
In-Reply-To: <1330981627-16121-1-git-send-email-richard@nod.at>
References: <1330981627-16121-1-git-send-email-richard@nod.at>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kvGU27kwIsoCv6RUpXnC"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 14191-08346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-kvGU27kwIsoCv6RUpXnC
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Mon, 2012-03-05 at 22:07 +0100, Richard Weinberger wrote:
> Depending on the OpenRISC implementation a rough task may able
> to change r0 and corrupt other taks.
> Handle this case by setting r0 to zero on each entry point.
> Also ensure that r0 is really zero before jumping into _start.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
>=20

Given the difficulty that was expressed on IRC to understand that this
was a real problem, I think a longer explanation is in order here.  In
particular, the "hardware" people should be able to read this and get a
feeling for the implications of having a writable r0.

> diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
> index d5f9c35..7c9c4f6 100644
> --- a/arch/openrisc/kernel/entry.S
> +++ b/arch/openrisc/kernel/entry.S
> @@ -130,6 +130,7 @@ handler:							;\
>  #define UNHANDLED_EXCEPTION(handler,vector)			\
>  	.global	handler						;\
>  handler:							;\
> +	l.andi	r0,r0,0						;\
>  	/* r1, EPCR, ESR already saved */			;\
>  	l.sw    PT_GPR2(r1),r2					;\
>  	l.sw    PT_GPR3(r1),r3					;\
> @@ -185,8 +186,8 @@ handler:							;\
>  /* ---[ 0x100: RESET exception ]----------------------------------------=
- */

If you're clearing r0 in EXCEPTION_HANDLE in head.S, then you probably
don't need to clear it again here... this should be in the same
execution path, I think.

> =20
>  EXCEPTION_ENTRY(_tng_kernel_start)
> +	l.andi r0,r0,0
>  	l.jal	_start
> -	 l.andi r0,r0,0
> =20

No, that was already correct.  The delay slot (indented one space for
clarity) is executed before the jump instruction.

>  /* ---[ 0x200: BUS exception ]------------------------------------------=
- */
> =20
> @@ -976,6 +977,7 @@ ENTRY(_kernel_thread_helper)
> =20
>  	.align 0x400
>  ENTRY(_switch)
> +	l.andi	r0,r0,0
>  	/* We don't store SR as _switch only gets called in a context where
>  	 * the SR will be the same going in and coming out... */
> =20

I'm scratching my head a bit on this one... why do we need to clear r0
here?

> diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
> index c75018d..c439324 100644
> --- a/arch/openrisc/kernel/head.S
> +++ b/arch/openrisc/kernel/head.S
> @@ -152,6 +152,7 @@
>   */
> =20
>  #define EXCEPTION_HANDLE(handler)				\
> +	l.andi	r0,r0,0						;\
>  	EXCEPTION_T_STORE_GPR30					;\
>  	l.mfspr r30,r0,SPR_ESR_BASE				;\
>  	l.andi  r30,r30,SPR_SR_SM				;\

Doing the same thing to UNHANDLED_EXCEPTION in head.S seems to me like
the right to do... it's moot, as it's unhandled, but it would be nice to
have that path be 'correct', too.

Thanks,
Jonas


--=-kvGU27kwIsoCv6RUpXnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9VqhUACgkQ70gcjN2673PGdACghej8xiNayPBuT3k+46YHeZRi
E9AAoKv8jt6UZwwCec+lhAlqGXAUUB68
=dBiP
-----END PGP SIGNATURE-----

--=-kvGU27kwIsoCv6RUpXnC--

