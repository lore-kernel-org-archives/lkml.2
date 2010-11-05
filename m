Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0KENv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:51:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61031 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0KENv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M9nK6/kolTakhcWsPGnw40crSh0R4BfjsGoIIOTkm5CeLaGZUA1bS0O7sAIWxIqy59
         fDAsqcszaRH+ZnNHQdeacZnBmzneAgOKyNvYeSbZqyoDxBol5AIWkDO6vtmaDjVVqAA3
         Fe33d1AMqbCya7tRO94/EpOKMFXYGnItnb5lc=
Date: Fri, 5 Nov 2010 15:51:18 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, sergey.senozhatsky@gmail.com
Subject: Re: [PATCH] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101105135117.GA27712@swordfish.minsk.epam.com>
References: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/04/10 21:18), Don Zickus wrote:
>  void touch_nmi_watchdog(void)
>  {
> +	/*
> +	 * Using __raw here because some code paths have
> +	 * preemption enabled.  If preemption is enabled
> +	 * then interrupts should be enabled too, in which
> +	 * case we shouldn't have to worry about the watchdog
> +	 * going off.
> +	 */
> +	__raw_get_cpu_var(watchdog_nmi_touch) =3D true;
> +
> +	touch_softlockup_watchdog();
> +}
> +EXPORT_SYMBOL(touch_nmi_watchdog);
> +
> +void touch_all_nmi_watchdogs(void)
> +{
>  	if (watchdog_enabled) {
>  		unsigned cpu;
> =20
> @@ -151,7 +166,7 @@ void touch_nmi_watchdog(void)
>  	}
>  	touch_softlockup_watchdog();
>  }
> -EXPORT_SYMBOL(touch_nmi_watchdog);
> +EXPORT_SYMBOL(touch_all_nmi_watchdogs);
> =20

Hello,
Seems like no one is actually calling touch_all_nmi_watchdogs, as for now.=
=20
Right?


Minor nit

	touch_all_nmi_watchdogs:
	...
	for_each_present_cpu(cpu) {
		if (per_cpu(watchdog_nmi_touch, cpu) !=3D true)
			per_cpu(watchdog_nmi_touch, cpu) =3D true;
	}


which is, I belive, could be simplified to=20
	for_each_present_cpu(cpu) {
		per_cpu(watchdog_nmi_touch, cpu) =3D true;
	}



	Sergey

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzUC9UACgkQfKHnntdSXjRNrgQAnXsPnaY27dGQRs3IVgwGMj9O
z7O948PSy2VwtYCzcZmG3mma/B67odNx6FS6BWZrCj1MbKE+qmc32mZvx2UuGtf+
pVL5uorUkxhLhCVFHpJar4FDS1qPQZPsBpTkJJ7Wp3WLdwBAvHQ786AYpR8NarPs
d7pNqLRaLIB6pIOKi0c=
=aB3A
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
