Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2BGV2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:28:38 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:37895 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab2BGV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:28:35 -0500
Message-ID: <4F319774.4080603@web.de>
Date: Tue, 07 Feb 2012 22:28:20 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Eric B Munson <emunson@mgebm.net>, avi@redhat.com, mingo@redhat.com,
        hpa@zytor.com, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V11] Add ioctl for KVMCLOCK_GUEST_STOPPED
References: <1328024132-7687-1-git-send-email-emunson@mgebm.net> <1328024132-7687-4-git-send-email-emunson@mgebm.net> <20120207185903.GB19800@amt.cnet>
In-Reply-To: <20120207185903.GB19800@amt.cnet>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD8EA5235E726063E496216FD"
X-Provags-ID: V02:K0:Qp/7I42Nh5wQ0HCOo5w527DPni3iB3WXnx2A1brhenw
 izBnPaUkWgZONzKYHFiWp+F3HpkXB5Q49FwgBV9kJGZpYQX1wy
 HAZ85UQ4a1fUj5trFKWOe7PuBe0N6cr3DPr4EatEqkxBGBmfzB
 3TZssU9Sh3sRD5LKGarLSBX70iQ/fckHcHvD62wN2cY33O2E2B
 FJzRPJnCLvZQx6MWGKCSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD8EA5235E726063E496216FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-02-07 19:59, Marcelo Tosatti wrote:
> On Tue, Jan 31, 2012 at 10:35:31AM -0500, Eric B Munson wrote:
>> Now that we have a flag that will tell the guest it was suspended, cre=
ate an
>> interface for that communication using a KVM ioctl.
>>
>> Signed-off-by: Eric B Munson <emunson@mgebm.net>
>>
>> Cc: mingo@redhat.com
>> Cc: hpa@zytor.com
>> Cc: ryanh@linux.vnet.ibm.com
>> Cc: aliguori@us.ibm.com
>> Cc: mtosatti@redhat.com
>> Cc: kvm@vger.kernel.org
>> Cc: linux-arch@vger.kernel.org
>> Cc: x86@kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>> Changes from V10:
>>  Return the ioctl to per vcpu instead of per vm
>> Changes from V9:
>>  Use kvm_for_each_vcpu to iterate online vcpu's
>> Changes from V8:
>>  Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu
>> Changes from V7:
>>  Define KVM_CAP_GUEST_PAUSED and support check
>>  Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED
>> Changes from V4:
>>  Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
>>  Add new ioctl description to api.txt
>>
>>  Documentation/virtual/kvm/api.txt |   13 +++++++++++++
>>  arch/x86/kvm/x86.c                |   21 +++++++++++++++++++++
>>  include/linux/kvm.h               |    3 +++
>>  3 files changed, 37 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual=
/kvm/api.txt
>> index e1d94bf..1931e5c 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -1491,6 +1491,19 @@ following algorithm:
>>  Some guests configure the LINT1 NMI input to cause a panic, aiding in=

>>  debugging.
>> =20
>> +4.65 KVMCLOCK_GUEST_PAUSED
>> +
>> +Capability: KVM_CAP_GUEST_PAUSED
>> +Architechtures: Any that implement pvclocks (currently x86 only)
>=20
> typo: Architectures.
>=20
>=20
>> +Type: vcpu ioctl
>> +Parameters: None
>> +Returns: 0 on success, -1 on error
>> +
>> +This signals to the host kernel that the specified guest is being pau=
sed by
>> +userspace.  The host will set a flag in the pvclock structure that is=
 checked
>> +from the soft lockup watchdog.  This ioctl can be called during pause=
 or
>> +unpause.
>> +
>>  5. The kvm_run structure
>> =20
>>  Application code obtains a pointer to the kvm_run structure by
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 14d6cad..c9cabba 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2056,6 +2056,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
>>  	case KVM_CAP_XSAVE:
>>  	case KVM_CAP_ASYNC_PF:
>> +	case KVM_CAP_GUEST_PAUSED:
>>  	case KVM_CAP_GET_TSC_KHZ:
>>  		r =3D 1;
>>  		break;
>> @@ -2503,6 +2504,22 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct k=
vm_vcpu *vcpu,
>>  	return r;
>>  }
>> =20
>> +/*
>> + * kvm_set_guest_paused() indicates to the guest kernel that it has b=
een
>> + * stopped by the hypervisor.  This function will be called from the =
host only.
>> + * EINVAL is returned when the host attempts to set the flag for a gu=
est that
>> + * does not support pv clocks.
>> + */
>> +static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
>> +{
>> +	struct pvclock_vcpu_time_info *src =3D &vcpu->arch.hv_clock;
>> +	if (!vcpu->arch.time_page)
>> +		return -EINVAL;
>> +	src->flags |=3D PVCLOCK_GUEST_STOPPED;
>> +	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
>> +	return 0;
>> +}
>=20
> It should also call kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu), so
> that the hv_clock is written to guest memory as soon as possible.
>=20
> Please fix the comments and rebase as soon as possible, it is annoying =

> that this feature is taking so long to be integrated.

In addition:

- Avi asked for a KVM_XXX_ naming pattern of the IOCTL, to align it
  with all the rest.
- He even suggested KVM_CLOCK_CTRL, thus an extensible interface for
  passing flags via kvmclock on a per-vpcu basis.
- As this is now supposed to be per-vcpu, constants should be called
  XXX_VCPU_STOPPED and no longer refer to "guest".

Thanks,
Jan



--------------enigD8EA5235E726063E496216FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8xl3YACgkQitSsb3rl5xQ7gQCgj3mzymA+Hv4QfXuiVPiIiWTX
ImIAoMHtQuqEUBf/NvzAyyWUH6lJ2xSy
=LAK6
-----END PGP SIGNATURE-----

--------------enigD8EA5235E726063E496216FD--
