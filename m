Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1A2I5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:57:04 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:59172 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1A2I5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:57:02 -0500
Message-ID: <4D43D658.7080605@web.de>
Date: Sat, 29 Jan 2011 09:56:56 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH] release kvmclock page on reset
References: <1296244086-15081-1-git-send-email-glommer@redhat.com>	 <4D433088.10308@web.de> <1296266847.3591.41.camel@mothafucka.localdomain>
In-Reply-To: <1296266847.3591.41.camel@mothafucka.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFC56573D8C99F116402EC9FF"
X-Provags-ID: V01U2FsdGVkX18yHR0GqBmqFSzMlPgZ3WK0efFBofNFB9ilKMkB
	DQFKu1ppNnMmvwCwsLD67kxt4WRGDHPLoi1hK4F5AfARiaw2M5
	fduYq83as=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFC56573D8C99F116402EC9FF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2011-01-29 03:07, Glauber Costa wrote:
> On Fri, 2011-01-28 at 22:09 +0100, Jan Kiszka wrote:
>> On 2011-01-28 20:48, Glauber Costa wrote:
>>> Up to know, we were relying on guest cooperation to turn off kvmclock=
=2E
>>> I just realized that even though this is fine and nice, a more robust=

>>> method is to (also) turn it off on vcpu_reset on the hypervisor side.=

>>> This will protect us against reboots, and we don't expect the guest
>>> to reset its cpu during normal operation anyway.
>>>
>>> Signed-off-by: Glauber Costa <glommer@redhat.com>
>>> ---
>>>  arch/x86/kvm/x86.c |    5 +++++
>>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index bcc0efc..38b55b3 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -5878,6 +5878,11 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)=

>>>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>  	vcpu->arch.apf.msr_val =3D 0;
>>> =20
>>> +	if (vcpu->arch.time_page) {
>>> +		kvm_release_page_dirty(vcpu->arch.time_page);
>>> +		vcpu->arch.time_page =3D NULL;
>>> +	}
>>> +
>>
>> kvm_arch_vcpu_reset is only called on vcpu setup and when it receives =
a
>> sipi (provided in-kernel irqchip is in use). If you want this page to =
be
>> consistently reset on guest reboot, you have to trigger this from user=

>> space. But I thought we are doing this already in qemu, don't we?
>=20
> Humm, you might as well be right regarding reboots.
> But in the end, it doesn't affect correctness here. If we're resetting
> the vcpu, we should not let that kind of data live.
>=20

Right, just checked that we reset other states like nmi_pending or
async_pf here as well. So doing the same for the time_page looks
appropriate.

But I think you should encapsulate the pattern above in a function and
substitute other occurrences at this chance. Also, the changelog should
clarify in which cases the code matters.

Jan


--------------enigFC56573D8C99F116402EC9FF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk1D1lwACgkQitSsb3rl5xS2oQCfaU7MAY6IUOPR7XLa6qyiw0lI
/hEAoL099J7L0FJQeUwmydxTXGCY+sOL
=YWMh
-----END PGP SIGNATURE-----

--------------enigFC56573D8C99F116402EC9FF--
