Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0IHL5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:57:35 -0400
Received: from grsecurity.net ([173.10.160.233]:48894 "EHLO grsecurity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0IHL5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:57:30 -0400
Date: Wed, 8 Sep 2010 07:57:28 -0400
From: Brad Spengler <spender@grsecurity.net>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Message-ID: <20100908115728.GB11762@grsecurity.net>
References: <20100827220258.GF4703@outflux.net> <20100830005648.431B7400D9@magilla.sf.frob.com> <20100830032331.GA22773@openwall.com> <20100830100616.78971400D9@magilla.sf.frob.com> <20100908023417.8B055401AF@magilla.sf.frob.com> <20100908023549.BFFA8401AF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I still don't think this addresses the whole problem.  Without question,
the rlimit / 4 check is bogus.  If nobody agrees with the intent of that=20
check, then it should be removed, but I think the better solution is to=20
fix the check so that it matches its original intent: let the initial=20
stack setup be up to 1/Xth of the min(rlimit, TASK_SIZE dependent upon=20
personality), which allows space for additional stack setup in the ELF=20
loader and then further growth once the process is live.  If that=20
amount is overstepped, then the exec will return an error to the calling=20
process instead of being terminated.

It might be useful to consult with the people who introduced/approved=20
the check in the first place, as they seemed to have reasons for=20
implementing it.

-Brad

On Tue, Sep 07, 2010 at 07:35:49PM -0700, Roland McGrath wrote:
> The CONFIG_STACK_GROWSDOWN variant of setup_arg_pages() does not
> check the size of the argument/environment area on the stack.
> When it is unworkably large, shift_arg_pages() hits its BUG_ON.
> This is exploitable with a very large RLIMIT_STACK limit, to
> create a crash pretty easily.
>=20
> Check that the initial stack is not too large to make it possible
> to map in any executable.  We're not checking that the actual
> executable (or intepreter, for binfmt_elf) will fit.  So those
> mappings might clobber part of the initial stack mapping.  But
> that is just userland lossage that userland made happen, not a
> kernel problem.
>=20
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  fs/exec.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/exec.c b/fs/exec.c
> index 2d94552..1b63237 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -594,6 +594,11 @@ int setup_arg_pages(struct linux_binprm *bprm,
>  #else
>  	stack_top =3D arch_align_stack(stack_top);
>  	stack_top =3D PAGE_ALIGN(stack_top);
> +
> +	if (unlikely(stack_top < mmap_min_addr) ||
> +	    unlikely(vma->vm_end - vma->vm_start >=3D stack_top - mmap_min_addr=
))
> +		return -ENOMEM;
> +
>  	stack_shift =3D vma->vm_end - stack_top;
> =20
>  	bprm->p -=3D stack_shift;

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkyHeigACgkQmHm2SUJF1GpAPQCfZKNkZcKbZ3onJv7gCdZz3FK1
PjcAn0+ogi/2OI5EZeDVBF2KSw+vAU9d
=+7ID
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
