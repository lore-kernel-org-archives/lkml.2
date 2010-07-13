Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0GMQl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:41:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756148Ab0GMQl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <4C3C8CE5.1080705@redhat.com>
References: <20100701175144.GA2116@kroah.com>
	<20100701173218.125822294@clark.site>
	<20100707124731.GJ15122@anguilla.noreply.org>
	<4C359D5A.1050906@redhat.com>
	<20100713102350.GW15122@anguilla.noreply.org>
	<4C3C68C8.4060409@redhat.com>
	<20100713141902.GB15122@anguilla.noreply.org>
	<4C3C8CE5.1080705@redhat.com>
Date: Tue, 13 Jul 2010 09:34:33 -0700
Message-ID: <AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: multipart/mixed; boundary=000e0cd53776b28f42048b4771e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd53776b28f42048b4771e9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 13, 2010 at 8:57 AM, Avi Kivity <avi@redhat.com> wrote:
> On 07/13/2010 05:19 PM, Peter Palfrader wrote:
>>
>>> So it looks like last_value was placed in a read only section. =A0Pleas=
e
>>> post your System.map somewhere.
>>>
>>
>> weasel@intrepid:~$ publish System.map
>>
>> http://asteria.noreply.org/~weasel/volatile/2010-07-13-mbm2xEdd8Q4/Syste=
m.map
>> weasel@intrepid:~$ grep -i last_value System.map
>> ffffffff81712e80 r last_value
>> ffffffff81b05240 b last_value.26163
>>
>
> "r" =3D "read only"
>
> How does it look in 'nm arch/x86/kernel/pvclock.o'?

I bet it is the same. And I have a suspicion: because the only write
access to that variable is in an asm that uses the "memory" clobber to
say it wrote to it (rather than say it writes to it directly), and
because the variable is marked 'static', gcc decides that nothing ever
writes to it in that compilation unit, and it can be made read-only.

Look at our definition for "xchg()" in
arch/x86/include/asm/cmpxchg_64.h. It boils down to

                asm volatile("xchgq %0,%1"                              \
                             : "=3Dr" (__x)                               \
                             : "m" (*__xg(ptr)), "0" (__x)              \
                             : "memory");                               \

for the 8-byte case (which is obviously what atomic64_xchg() uses).
And the _reason_ we do that thing where we use a memory _input_ and
then a clobber is that older versions of gcc did not accept the thing
we _want_ to use, namely using "+m" to say that we actually change the
memory.  So the above is "wrong", but has historical reasons - and
it's apparently never been changed.

However, the "+m" was fixed, and we use it elsewhere, so I think the
"m" plus memory clobber is now purely historical. Does a patch
something like the appended fix it? I also suspect we should look at
some other uses in this area. The atomic64_64.h file uses "=3Dm" and
"m", which looks like another legacy thing (again, "+m" historically
wasn't allowed, and then later became the 'correct' way to do things).

NOTE NOTE NOTE! This is UNTESTED and INCOMPLETE. We should do cmpxchg
too, and the 32-bit versions. I'm adding Ingo and Peter to the cc.

                     Linus

--000e0cd53776b28f42048b4771e9
Content-Type: application/octet-stream; name=diff
Content-Disposition: attachment; filename=diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbkypctl0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL2NtcHhjaGdfNjQuaCB8ICAgMTYgKysrKysrKystLS0tLS0t
LQogMSBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY21weGNoZ182NC5oIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vY21weGNoZ182NC5oCmluZGV4IDQ4NWFlNDEuLjcwYWMwYTQgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2NtcHhjaGdfNjQuaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9jbXB4Y2hnXzY0LmgKQEAgLTI2LDI2ICsyNiwyNiBAQCBleHRlcm4gdm9pZCBfX2NtcHhj
aGdfd3Jvbmdfc2l6ZSh2b2lkKTsKIAlzd2l0Y2ggKHNpemUpIHsJCQkJCQkJXAogCWNhc2UgMToJ
CQkJCQkJCVwKIAkJYXNtIHZvbGF0aWxlKCJ4Y2hnYiAlYjAsJTEiCQkJCVwKLQkJCSAgICAgOiAi
PXEiIChfX3gpCQkJCVwKLQkJCSAgICAgOiAibSIgKCpfX3hnKHB0cikpLCAiMCIgKF9feCkJCVwK
KwkJCSAgICAgOiAiPXEiIChfX3gpLCAiK20iICgqX194ZyhwdHIpKQkJXAorCQkJICAgICA6ICIw
IiAoX194KQkJCQlcCiAJCQkgICAgIDogIm1lbW9yeSIpOwkJCQlcCiAJCWJyZWFrOwkJCQkJCQlc
CiAJY2FzZSAyOgkJCQkJCQkJXAogCQlhc20gdm9sYXRpbGUoInhjaGd3ICV3MCwlMSIJCQkJXAot
CQkJICAgICA6ICI9ciIgKF9feCkJCQkJXAotCQkJICAgICA6ICJtIiAoKl9feGcocHRyKSksICIw
IiAoX194KQkJXAorCQkJICAgICA6ICI9ciIgKF9feCksICIrbSIgKCpfX3hnKHB0cikpCQlcCisJ
CQkgICAgIDogIjAiIChfX3gpCQkJCVwKIAkJCSAgICAgOiAibWVtb3J5Iik7CQkJCVwKIAkJYnJl
YWs7CQkJCQkJCVwKIAljYXNlIDQ6CQkJCQkJCQlcCiAJCWFzbSB2b2xhdGlsZSgieGNoZ2wgJWsw
LCUxIgkJCQlcCi0JCQkgICAgIDogIj1yIiAoX194KQkJCQlcCi0JCQkgICAgIDogIm0iICgqX194
ZyhwdHIpKSwgIjAiIChfX3gpCQlcCisJCQkgICAgIDogIj1yIiAoX194KSwgIittIiAoKl9feGco
cHRyKSkJCVwKKwkJCSAgICAgOiAiMCIgKF9feCkJCQkJXAogCQkJICAgICA6ICJtZW1vcnkiKTsJ
CQkJXAogCQlicmVhazsJCQkJCQkJXAogCWNhc2UgODoJCQkJCQkJCVwKIAkJYXNtIHZvbGF0aWxl
KCJ4Y2hncSAlMCwlMSIJCQkJXAotCQkJICAgICA6ICI9ciIgKF9feCkJCQkJXAotCQkJICAgICA6
ICJtIiAoKl9feGcocHRyKSksICIwIiAoX194KQkJXAorCQkJICAgICA6ICI9ciIgKF9feCksICIr
bSIgKCpfX3hnKHB0cikpCQlcCisJCQkgICAgIDogIjAiIChfX3gpCQkJCVwKIAkJCSAgICAgOiAi
bWVtb3J5Iik7CQkJCVwKIAkJYnJlYWs7CQkJCQkJCVwKIAlkZWZhdWx0OgkJCQkJCQlcCg==
--000e0cd53776b28f42048b4771e9--
