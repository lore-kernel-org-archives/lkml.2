Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0INW1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:27:13 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:55087 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0INW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:27:10 -0400
Message-ID: <4C8FF690.7030107@web.de>
Date: Wed, 15 Sep 2010 00:26:24 +0200
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
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C8F3FF3.9080803@redhat.com> <4C8F5125.5060505@siemens.com> <4C8FCDE2.3000202@redhat.com>
In-Reply-To: <4C8FCDE2.3000202@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDA715A7F192B515ED7F7B7FB"
X-Provags-ID: V01U2FsdGVkX1/F3o3SrEIucOPwpLox24j6hXYXlisS131MIfyT
	T6kev44o8F4FfOLyw4UCnNpPWJgmByDvdKiwUYErj62DbY2wpL
	1B9+YS+jA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDA715A7F192B515ED7F7B7FB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.09.2010 21:32, Zachary Amsden wrote:
> On 09/14/2010 12:40 AM, Jan Kiszka wrote:
>> Am 14.09.2010 11:27, Avi Kivity wrote:
>>  =20
>>>    On 09/14/2010 11:10 AM, Jan Kiszka wrote:
>>>    =20
>>>> Am 20.08.2010 10:07, Zachary Amsden wrote:
>>>>      =20
>>>>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>>>>> running.  This causes us to require resynchronization.  Since
>>>>> we can't tell when this may potentially happen, we assume the
>>>>> worst by forcing re-compensation for it at every point the VCPU
>>>>> task is descheduled.
>>>>>
>>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>>> ---
>>>>>    arch/x86/kvm/x86.c |    2 +-
>>>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>> index 7fc4a55..52b6c21 100644
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -1866,7 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
>>>>> *vcpu, int cpu)
>>>>>        }
>>>>>
>>>>>        kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>>> -    if (unlikely(vcpu->cpu !=3D cpu)) {
>>>>> +    if (unlikely(vcpu->cpu !=3D cpu) || check_tsc_unstable()) {
>>>>>            /* Make sure TSC doesn't go backwards */
>>>>>            s64 tsc_delta =3D !vcpu->arch.last_host_tsc ? 0 :
>>>>>                    native_read_tsc() - vcpu->arch.last_host_tsc;
>>>>>         =20
>>>> For yet unknown reason, this commit breaks Linux guests here if they=

>>>> are
>>>> started with only a single VCPU. They hang during boot, obviously no=

>>>> longer receiving interrupts.
>>>>
>>>> I'm using kvm-kmod against a 2.6.34 host kernel, so this may be a si=
de
>>>> effect of the wrapping, though I cannot imagine how.
>>>>
>>>> Anyone any ideas?
>>>>
>>>>
>>>>       =20
>>> Most likely, time went backwards, and some 'future - past' calculatio=
n
>>> resulted in a negative sleep value which was then interpreted as
>>> unsigned and resulted in a 2342525634 year sleep.
>>>     =20
>> Looks like that's the case on first glance at the apic state.
>>   =20
>=20
> This compensation effectively nulls the delta between current and last =
TSC:
>=20
>         if (unlikely(vcpu->cpu !=3D cpu) || check_tsc_unstable()) {
>                 /* Make sure TSC doesn't go backwards */
>                 s64 tsc_delta =3D !vcpu->arch.last_host_tsc ? 0 :
>                                 native_read_tsc() -
> vcpu->arch.last_host_tsc;
>                 if (tsc_delta < 0)
>                         mark_tsc_unstable("KVM discovered backwards TSC=
");
>                 if (check_tsc_unstable())
>                         kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta=
);
>                 kvm_migrate_timers(vcpu);
>                 vcpu->cpu =3D cpu;
>=20
> If TSC has advanced quite a bit due to a TSC jump during sleep(*), it
> will adjust the offset backwards to compensate; similarly, if it has
> gone backwards, it will advance the offset.
>=20
> In neither case should the visible TSC go backwards, assuming
> last_host_tsc is recorded properly, and so kvmclock should be similarly=

> unaffected.
>=20
> Perhaps the guest is more intelligent than we hope, and is comparing tw=
o
> different clocks: kvmclock or TSC with the rate of PIT interrupts.  Thi=
s
> could result in negative arithmetic begin interpreted as unsigned.  Are=

> you using PIT interrupt reinjection on this guest or passing
> -no-kvm-pit-reinjection?
>=20
>>  =20
>>> Does your guest use kvmclock, tsc, or some other time source?
>>>     =20
>> A kernel that has kvmclock support even hangs in SMP mode. The others
>> pick hpet or acpi_pm. TSC is considered unstable.
>>   =20
>=20
> SMP mode here has always and will always be unreliable.  Are you runnin=
g
> on an Intel or AMD CPU?  The origin of this code comes from a workaroun=
d
> for (*) in vendor-specific code, and perhaps it is inappropriate for bo=
th.

I'm on a fairly new Intel i7 (M 620). And I accidentally rebooted my box
a few hours ago. Well, the issue is gone now...

So I looked into the system logs and found this:

[18446744053.434939] PM: resume of devices complete after 4379.595 msecs
[18446744053.457133] PM: Finishing wakeup.
[18446744053.457135] Restarting tasks ...
[    0.000999] Marking TSC unstable due to KVM discovered backwards TSC
[270103.974668] done.

=46rom that point on the box was on hpet, including the time I did the
failing tests this morning. The kvm-kmod version loaded at this point
was based on kvm.git df549cfc.

But my /proc/cpuinfo claims "constant_tsc", and Linux is generally happy
with using it as clock source. Does this tell you anything?

Jan


--------------enigDA715A7F192B515ED7F7B7FB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkyP9pQACgkQitSsb3rl5xRG+ACfUIa2thAKuyalk9xij88ZDfD5
oy4An1YpuE5tAuk2Bpmijx06jToPU+Zl
=mGET
-----END PGP SIGNATURE-----

--------------enigDA715A7F192B515ED7F7B7FB--
