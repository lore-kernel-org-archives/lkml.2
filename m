Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0IOIJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:09:37 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:32872 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0IOIJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:09:34 -0400
Message-ID: <4C907F3D.6070709@web.de>
Date: Wed, 15 Sep 2010 10:09:33 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C904685.9090402@redhat.com>
In-Reply-To: <4C904685.9090402@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3ACE94EA057E4158AE309F2D"
X-Provags-ID: V01U2FsdGVkX1/0JflGA+cj4IulF4IAccPzqwb0IVReKbdzQl7q
	dLoN9wa2RLNpfszI6I6ngnBdniPAJWZ8kDLZNR9R8iEn7BRhKJ
	pVBIElJlA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3ACE94EA057E4158AE309F2D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 15.09.2010 06:07, Zachary Amsden wrote:
> On 09/13/2010 11:10 PM, Jan Kiszka wrote:
>> Am 20.08.2010 10:07, Zachary Amsden wrote:
>>  =20
>>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>>> running.  This causes us to require resynchronization.  Since
>>> we can't tell when this may potentially happen, we assume the
>>> worst by forcing re-compensation for it at every point the VCPU
>>> task is descheduled.
>>>
>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>> ---
>>>   arch/x86/kvm/x86.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 7fc4a55..52b6c21 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1866,7 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu,
>>> int cpu)
>>>       }
>>>
>>>       kvm_x86_ops->vcpu_load(vcpu, cpu);
>>> -    if (unlikely(vcpu->cpu !=3D cpu)) {
>>> +    if (unlikely(vcpu->cpu !=3D cpu) || check_tsc_unstable()) {
>>>           /* Make sure TSC doesn't go backwards */
>>>           s64 tsc_delta =3D !vcpu->arch.last_host_tsc ? 0 :
>>>                   native_read_tsc() - vcpu->arch.last_host_tsc;
>>>     =20
>> For yet unknown reason, this commit breaks Linux guests here if they a=
re
>> started with only a single VCPU. They hang during boot, obviously no
>> longer receiving interrupts.
>>
>> I'm using kvm-kmod against a 2.6.34 host kernel, so this may be a side=

>> effect of the wrapping, though I cannot imagine how.
>>
>> Anyone any ideas?
>>   =20
>=20
> Question: how did you come to the knowledge that this is the commit
> which breaks things?  I'm assuming you bisected, in which case a
> transition from stable -> unstable would have only happened once.

Right.

>  This
> also means the PM suspend event which you observed only happened once,
> so obviously if you bisected successfully, there is a bug which doesn't=

> involved the PM transition or the stable -> unstable transition.

Right, see my other posting.

>=20
> Your host TSC must have desynchronized during the PM transition, and
> this change compensates the TSC on an unstable host to effectively show=

> run time, not real time.  Perhaps the lack of catchup code (to catch
> back up to real time) is triggering the bug.

I'm still unsure if KVM is right in declaring the TSC unstable. It looks
like Linux is less picky here - are the requirements different?

>=20
> In any case, I'll proceed with the forcing of unstable TSC and HPET
> clocksource and see what happens.

I tried that before, but it did not trigger the issue that kvm-clock
guests no longer boot properly. This only happens if the TSC is marked
unstable.

Jan


--------------enig3ACE94EA057E4158AE309F2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkyQfz0ACgkQitSsb3rl5xTdIwCffyz3exBKC+w9SQBwijzFWpAa
pBIAoOmYzhlwtLWWZH9Jme0ghDFvBePK
=0dGL
-----END PGP SIGNATURE-----

--------------enig3ACE94EA057E4158AE309F2D--
