Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1BAU20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:28:26 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:34897 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1BAU2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:28:25 -0500
Message-ID: <4D486CE6.4050601@web.de>
Date: Tue, 01 Feb 2011 21:28:22 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH v2] release kvmclock page on reset
References: <1296587800-19589-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1296587800-19589-1-git-send-email-glommer@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F61A481B64C76B076A57E61"
X-Provags-ID: V01U2FsdGVkX1/BpYstyeoo6odwG6BJ2PdLg0CLcolFElGHVLbl
	5IwmMb7t++s7VT6PmBL+S+4Y47eMmyNpxTGMbqZoIYh6pT2ioE
	MeCKLPQFY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F61A481B64C76B076A57E61
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2011-02-01 20:16, Glauber Costa wrote:
> When a vcpu is reset, kvmclock page keeps being writen to this days.
> This is wrong and inconsistent: a cpu reset should take it to its
> initial state.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/kvm/x86.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bcc0efc..c39ab4a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1453,6 +1453,14 @@ static int kvm_pv_enable_async_pf(struct kvm_vcp=
u *vcpu, u64 data)
>  	return 0;
>  }
> =20
> +static void kvmclock_reset(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.time_page) {
> +		kvm_release_page_dirty(vcpu->arch.time_page);
> +		vcpu->arch.time_page =3D NULL;
> +	}
> +}
> +
>  int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  {
>  	switch (msr) {
> @@ -1510,10 +1518,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u3=
2 msr, u64 data)
>  		break;
>  	case MSR_KVM_SYSTEM_TIME_NEW:
>  	case MSR_KVM_SYSTEM_TIME: {
> -		if (vcpu->arch.time_page) {
> -			kvm_release_page_dirty(vcpu->arch.time_page);
> -			vcpu->arch.time_page =3D NULL;
> -		}
> +		kvmclock_reset(vcpu);
> =20
>  		vcpu->arch.time =3D data;
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> @@ -5814,10 +5819,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
> =20
>  void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu->arch.time_page) {
> -		kvm_release_page_dirty(vcpu->arch.time_page);
> -		vcpu->arch.time_page =3D NULL;
> -	}
> +	kvmclock_reset(vcpu);
> =20
>  	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
>  	fx_free(vcpu);
> @@ -5878,6 +5880,8 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	vcpu->arch.apf.msr_val =3D 0;
> =20
> +	kvmclock_reset(vcpu);
> +
>  	kvm_clear_async_pf_completion_queue(vcpu);
>  	kvm_async_pf_hash_reset(vcpu);
>  	vcpu->arch.apf.halted =3D false;

Looks good.

Thanks,
Jan


--------------enig3F61A481B64C76B076A57E61
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk1IbOYACgkQitSsb3rl5xScsgCeNt64RhvEyRS36bPL6LPA65o9
YqIAoJQj+Djs73dmOCJJqEwVvaMzsW2K
=hQzJ
-----END PGP SIGNATURE-----

--------------enig3F61A481B64C76B076A57E61--
