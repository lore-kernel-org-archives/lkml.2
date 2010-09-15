Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0IOFfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:35:02 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:36414 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0IOFfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:35:00 -0400
Message-ID: <4C905AFC.5020706@web.de>
Date: Wed, 15 Sep 2010 07:34:52 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C8F3FF3.9080803@redhat.com> <4C8F5125.5060505@siemens.com> <4C8FCDE2.3000202@redhat.com> <4C8FF690.7030107@web.de> <4C9007F2.9020205@redhat.com>
In-Reply-To: <4C9007F2.9020205@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig53E7EE7FC02266A6AE853080"
X-Provags-ID: V01U2FsdGVkX1/5wtk1g8hdRljrpEovZXWFCCj2Vc+nOX22JGaL
	EyeccQain6DNR0Og1w3gubLjQhRPzvq+W2aAw/vKOlQzparoHu
	od09C+wIM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig53E7EE7FC02266A6AE853080
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 15.09.2010 01:40, Zachary Amsden wrote:
> On 09/14/2010 12:26 PM, Jan Kiszka wrote:
>> Am 14.09.2010 21:32, Zachary Amsden wrote:
>>  =20
>>> On 09/14/2010 12:40 AM, Jan Kiszka wrote:
>>>    =20
>>>> Am 14.09.2010 11:27, Avi Kivity wrote:
>>>>
>>>>      =20
>>>>>     On 09/14/2010 11:10 AM, Jan Kiszka wrote:
>>>>>
>>>>>        =20
>>>>>> Am 20.08.2010 10:07, Zachary Amsden wrote:
>>>>>>
>>>>>>          =20
>>>>>>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>>>>>>> running.  This causes us to require resynchronization.  Since
>>>>>>> we can't tell when this may potentially happen, we assume the
>>>>>>> worst by forcing re-compensation for it at every point the VCPU
>>>>>>> task is descheduled.
>>>>>>>
>>>>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>>>>> ---
>>>>>>>     arch/x86/kvm/x86.c |    2 +-
>>>>>>>     1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>>> index 7fc4a55..52b6c21 100644
>>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>>> @@ -1866,7 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
>>>>>>> *vcpu, int cpu)
>>>>>>>         }
>>>>>>>
>>>>>>>         kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>>>>> -    if (unlikely(vcpu->cpu !=3D cpu)) {
>>>>>>> +    if (unlikely(vcpu->cpu !=3D cpu) || check_tsc_unstable()) {
>>>>>>>             /* Make sure TSC doesn't go backwards */
>>>>>>>             s64 tsc_delta =3D !vcpu->arch.last_host_tsc ? 0 :
>>>>>>>                     native_read_tsc() - vcpu->arch.last_host_tsc;=

>>>>>>>
>>>>>>>             =20
>>>>>> For yet unknown reason, this commit breaks Linux guests here if th=
ey
>>>>>> are
>>>>>> started with only a single VCPU. They hang during boot, obviously =
no
>>>>>> longer receiving interrupts.
>>>>>>
>>>>>> I'm using kvm-kmod against a 2.6.34 host kernel, so this may be a
>>>>>> side
>>>>>> effect of the wrapping, though I cannot imagine how.
>>>>>>
>>>>>> Anyone any ideas?
>>>>>>
>>>>>>
>>>>>>
>>>>>>           =20
>>>>> Most likely, time went backwards, and some 'future - past' calculat=
ion
>>>>> resulted in a negative sleep value which was then interpreted as
>>>>> unsigned and resulted in a 2342525634 year sleep.
>>>>>
>>>>>         =20
>>>> Looks like that's the case on first glance at the apic state.
>>>>
>>>>       =20
>>> This compensation effectively nulls the delta between current and
>>> last TSC:
>>>
>>>          if (unlikely(vcpu->cpu !=3D cpu) || check_tsc_unstable()) {
>>>                  /* Make sure TSC doesn't go backwards */
>>>                  s64 tsc_delta =3D !vcpu->arch.last_host_tsc ? 0 :
>>>                                  native_read_tsc() -
>>> vcpu->arch.last_host_tsc;
>>>                  if (tsc_delta<  0)
>>>                          mark_tsc_unstable("KVM discovered backwards
>>> TSC");
>>>                  if (check_tsc_unstable())
>>>                          kvm_x86_ops->adjust_tsc_offset(vcpu,
>>> -tsc_delta);
>>>                  kvm_migrate_timers(vcpu);
>>>                  vcpu->cpu =3D cpu;
>>>
>>> If TSC has advanced quite a bit due to a TSC jump during sleep(*), it=

>>> will adjust the offset backwards to compensate; similarly, if it has
>>> gone backwards, it will advance the offset.
>>>
>>> In neither case should the visible TSC go backwards, assuming
>>> last_host_tsc is recorded properly, and so kvmclock should be similar=
ly
>>> unaffected.
>>>
>>> Perhaps the guest is more intelligent than we hope, and is comparing =
two
>>> different clocks: kvmclock or TSC with the rate of PIT interrupts.  T=
his
>>> could result in negative arithmetic begin interpreted as unsigned.  A=
re
>>> you using PIT interrupt reinjection on this guest or passing
>>> -no-kvm-pit-reinjection?
>>>
>>>    =20
>>>>
>>>>      =20
>>>>> Does your guest use kvmclock, tsc, or some other time source?
>>>>>
>>>>>         =20
>>>> A kernel that has kvmclock support even hangs in SMP mode. The other=
s
>>>> pick hpet or acpi_pm. TSC is considered unstable.
>>>>
>>>>       =20
>>> SMP mode here has always and will always be unreliable.  Are you runn=
ing
>>> on an Intel or AMD CPU?  The origin of this code comes from a workaro=
und
>>> for (*) in vendor-specific code, and perhaps it is inappropriate for
>>> both.
>>>     =20
>> I'm on a fairly new Intel i7 (M 620). And I accidentally rebooted my b=
ox
>> a few hours ago. Well, the issue is gone now...
>>
>> So I looked into the system logs and found this:
>>
>> [18446744053.434939] PM: resume of devices complete after 4379.595 mse=
cs
>> [18446744053.457133] PM: Finishing wakeup.
>> [18446744053.457135] Restarting tasks ...
>> [    0.000999] Marking TSC unstable due to KVM discovered backwards TS=
C
>> [270103.974668] done.
>>
>>  From that point on the box was on hpet, including the time I did the
>> failing tests this morning. The kvm-kmod version loaded at this point
>> was based on kvm.git df549cfc.
>>
>> But my /proc/cpuinfo claims "constant_tsc", and Linux is generally hap=
py
>> with using it as clock source. Does this tell you anything?
>>   =20
>=20
> Yes, quite a bit.
>=20
> It's possible that marking the TSC unstable with an actively running VM=

> causes a boundary condition that I had not accounted for.  It's also
> possible that the clocksource switch triggered some bad behavior.

Suspend/resume (to RAM) is indeed triggering the tsc switch by KVM here.
This should be the first issue as the kernel itself has no problems with
recovering from suspend/resume /wrt tsc.

The next one is what happened to the guest running at that point. It was
a SUSE 11.3 32-bit image, using kvm-clock. After resume and host-side
clock switch it lost its timer ticks, likely due to some breakage of
kvm-clock.

And finally, I'm now in the original failure state again in which every
newly started Linux guest with kvm-clock support also suffers from stuck
timers. Linux kernel that lack kvm-clock run fine, e.g. on hpet
clocksource. Maybe this is just another symptom of what also cause the
second problem.

>=20
> This suggests two debugging techniques: I can manually switch the
> clocksource, and I can also load a module which does nothing other than=

> mark the TSC unstable.  Failing that, we can investigate PM suspend /
> resume for possible issues.
>=20
> I'll try this on my Intel boxes to see what happens.

Do you think kvm-kmod could contribute to this? As I said, I'm on a 34
kernel, namely SUSE's 2.6.34.4-0.1-desktop. Any feature missing in that
kernel latest KVM depends for proper tsc/kvm-clock handling? If you have
any concerns, I could try to run kvm.git natively later on.

Jan


--------------enig53E7EE7FC02266A6AE853080
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkyQWwEACgkQitSsb3rl5xQuFwCdHmZuX+cZD/kKVzKpEBInaMkr
bDwAoK1CB1Sozvl7eMQfXntDhFjS9y88
=EE5q
-----END PGP SIGNATURE-----

--------------enig53E7EE7FC02266A6AE853080--
