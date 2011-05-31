Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab1EaRXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:23:06 -0400
Received: from bohort.kerlabs.com ([90.80.97.101]:41681 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1EaRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:23:04 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 13:23:04 EDT
Date: Tue, 31 May 2011 19:17:43 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 03/10] x86-64: Give vvars their own page
Message-ID: <20110531171743.GC22918@hawkmoon.kerlabs.com>
Mail-Followup-To: Andy Lutomirski <luto@MIT.EDU>,
	Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Jan Beulich <JBeulich@novell.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	Mikael Pettersson <mikpe@it.uu.se>,
	Andi Kleen <andi@firstfloor.org>
References: <cover.1306851090.git.luto@mit.edu> <efce8d02493c030177895a8e65134aad3e774815.1306851090.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18040-1306862174-0001-2"
Content-Disposition: inline
In-Reply-To: <efce8d02493c030177895a8e65134aad3e774815.1306851090.git.luto@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18040-1306862174-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31/05/11 10:14 -0400, Andy Lutomirski wrote:
> Move vvars out of the vsyscall page into their own page and mark it
> NX.
>=20
> Without this patch, an attacker who can force a daemon to call some
> fixed address could wait until the time contains, say, 0xCD80, and
> then execute the current time.
>=20
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/include/asm/fixmap.h        |    1 +
>  arch/x86/include/asm/pgtable_types.h |    2 ++
>  arch/x86/include/asm/vvar.h          |   22 ++++++++++------------
>  arch/x86/kernel/vmlinux.lds.S        |   27 ++++++++++++++++-----------
>  arch/x86/kernel/vsyscall_64.c        |    5 +++++
>  5 files changed, 34 insertions(+), 23 deletions(-)
>=20

[...]

> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 89aed99..3d89a00 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -161,12 +161,6 @@ SECTIONS
> =20
>  #define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
>  #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
> -#define EMIT_VVAR(x, offset) .vsyscall_var_ ## x	\
> -	ADDR(.vsyscall_0) + offset		 	\
> -	: AT(VLOAD(.vsyscall_var_ ## x)) {     		\
> -		*(.vsyscall_var_ ## x)			\
> -	}						\
> -	x =3D VVIRT(.vsyscall_var_ ## x);
> =20
>  	. =3D ALIGN(4096);
>  	__vsyscall_0 =3D .;
> @@ -192,17 +186,28 @@ SECTIONS
>  		*(.vsyscall_3)
>  	}
> =20
> -#define __VVAR_KERNEL_LDS
> -#include <asm/vvar.h>
> -#undef __VVAR_KERNEL_LDS
> -
> -	. =3D __vsyscall_0 + PAGE_SIZE;
> +	. =3D ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
> =20
>  #undef VSYSCALL_ADDR
>  #undef VLOAD_OFFSET
>  #undef VLOAD
>  #undef VVIRT_OFFSET
>  #undef VVIRT
> +
> +	__vvar_page =3D .;
> +
> +#define EMIT_VVAR(name, offset) .vvar_ ## name		\
> +	(__vvar_page + offset) :			\
> +	 AT(ADDR(.vvar_ ## name) - LOAD_OFFSET) {	\
> +		*(.vvar_ ## x)				\
                            ^
Maybe s/x/name/ ? -----------|

Thanks,

Louis

> +	} :data
> +
> +#define __VVAR_KERNEL_LDS
> +#include <asm/vvar.h>
> +#undef __VVAR_KERNEL_LDS
> +
> +       . =3D ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
> +
>  #undef EMIT_VVAR
> =20
>  #endif /* CONFIG_X86_64 */
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 3e68218..3cf1cef 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -284,9 +284,14 @@ void __init map_vsyscall(void)
>  {
>  	extern char __vsyscall_0;
>  	unsigned long physaddr_page0 =3D __pa_symbol(&__vsyscall_0);
> +	extern char __vvar_page;
> +	unsigned long physaddr_vvar_page =3D __pa_symbol(&__vvar_page);
> =20
>  	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
>  	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
> +	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
> +	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=3D
> +		     (unsigned long)VVAR_ADDRESS);
>  }
> =20
>  static int __init vsyscall_init(void)
> --=20
> 1.7.5.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-18040-1306862174-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk3lIrcACgkQVKcRuvQ9Q1RmPwCfdSycZ7aGHhJn9e6GZwrhrvVH
yFkAniACzqHT9jzZhQHeHtDM2i4BEq28
=W6wE
-----END PGP SIGNATURE-----

--=_bohort-18040-1306862174-0001-2--
