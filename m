Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0J3OhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:37:05 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:40584 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0J3OhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:37:03 -0400
Message-ID: <4CCC2D11.7090109@web.de>
Date: Sat, 30 Oct 2010 16:34:57 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: kvm: fix information leak to userland
References: <1288447871-7715-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1288447871-7715-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE46FB154DC145DF8A04926C2"
X-Provags-ID: V01U2FsdGVkX1++WBn87bqKXJ20pGHgrrPIDC+jf9cq14jDhC6F
	JMtGTqLmJorWjgSW/3egHAokawwbM1lvl3wgGEV9IDNdV2b505
	hHUEzCIyM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE46FB154DC145DF8A04926C2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 30.10.2010 16:11, Vasiliy Kulikov wrote:
> Structure kvm_ppc_pvinfo is copied to userland with pad field
> unitialized.  Structure kvm_clock_data is copied to userland with
> flags and pad fields unitialized.  It leads to leaking of contents
> of kernel stack memory.

This description only partially matches your patch, please fix.

>=20
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I cannot compile this driver, so it is not tested at all.

Why? It should be compilable (provided you have a x86 toolchain).

>=20
>  As it is not compilable, I've missed and typed wrong var name in v1, s=
orry.
>=20
>  arch/x86/kvm/x86.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0818f6..261f3d0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2896,6 +2896,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_GET_DEBUGREGS: {
>  		struct kvm_debugregs dbgregs;
> =20
> +		memset(&dbgregs, 0, sizeof(dbgregs));
>  		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> =20
>  		r =3D -EFAULT;
> @@ -3481,11 +3482,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		struct kvm_clock_data user_ns;
>  		u64 now_ns;
> =20
> +		memset(&user_ns, 0, sizeof(user_ns));
>  		local_irq_disable();
>  		now_ns =3D get_kernel_ns();
>  		user_ns.clock =3D kvm->arch.kvmclock_offset + now_ns;
>  		local_irq_enable();
> -		user_ns.flags =3D 0;
> =20
>  		r =3D -EFAULT;
>  		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))

I would rather clear the padding/reserved fields (in both cases). No
need to double-initialize properly set fields.

There are more interfaces in KVM for obtaining data from the kernel via
padded structures. Did you check them all (kvm_vcpu_events come to my min=
d)?

Nevertheless, looks like a worthwhile hardening of the KVM interfaces.

Thanks,
Jan


--------------enigE46FB154DC145DF8A04926C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzMLRQACgkQitSsb3rl5xTSeQCfT9X2QF3u+91mMr54HQRvvIZM
TWsAoKgc0mHqtc9gooX3aB2AxFmymSFs
=qQMV
-----END PGP SIGNATURE-----

--------------enigE46FB154DC145DF8A04926C2--
