Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1A1VLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:11:47 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:53176 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1A1VLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:11:45 -0500
Message-ID: <4D433088.10308@web.de>
Date: Fri, 28 Jan 2011 22:09:28 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH] release kvmclock page on reset
References: <1296244086-15081-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244086-15081-1-git-send-email-glommer@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D1EF8F726F013C89D7559C7"
X-Provags-ID: V01U2FsdGVkX18kOaB7W1RjyFTH1s0u8/znFByTLUHQxXB7xa64
	y68yoHNia/JorfSgYVtiKcZcGnQO86pqLDzjXPF0x5BQuJnopf
	v6zO/A2To=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D1EF8F726F013C89D7559C7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2011-01-28 20:48, Glauber Costa wrote:
> Up to know, we were relying on guest cooperation to turn off kvmclock.
> I just realized that even though this is fine and nice, a more robust
> method is to (also) turn it off on vcpu_reset on the hypervisor side.
> This will protect us against reboots, and we don't expect the guest
> to reset its cpu during normal operation anyway.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> ---
>  arch/x86/kvm/x86.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bcc0efc..38b55b3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5878,6 +5878,11 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	vcpu->arch.apf.msr_val =3D 0;
> =20
> +	if (vcpu->arch.time_page) {
> +		kvm_release_page_dirty(vcpu->arch.time_page);
> +		vcpu->arch.time_page =3D NULL;
> +	}
> +

kvm_arch_vcpu_reset is only called on vcpu setup and when it receives a
sipi (provided in-kernel irqchip is in use). If you want this page to be
consistently reset on guest reboot, you have to trigger this from user
space. But I thought we are doing this already in qemu, don't we?

Jan


--------------enig7D1EF8F726F013C89D7559C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk1DMIsACgkQitSsb3rl5xQtsgCgtpMpcOqcIVKssje4OjOelUke
JTIAn1wA36+vtDrSOCFRwgz72Ic7jJlA
=EFkO
-----END PGP SIGNATURE-----

--------------enig7D1EF8F726F013C89D7559C7--
