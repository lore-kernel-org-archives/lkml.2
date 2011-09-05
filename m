Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1IEPLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:11:36 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59509 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1IEPLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <2722845.TegCUU4bu0@wuerfel>
References: <4E582577.2060805@zytor.com>
	<3634139.5BAXH7nXYb@wuerfel>
	<CAMe9rOrU0wcrRxPoTRcmVRd+2hDwjCta_73Ji-MMiRRXR-3ndw@mail.gmail.com>
	<2722845.TegCUU4bu0@wuerfel>
Date: Mon, 5 Sep 2011 08:11:32 -0700
Message-ID: <CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: multipart/mixed; boundary=0016e64b98966193ba04ac3320eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64b98966193ba04ac3320eb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 5, 2011 at 12:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 04 September 2011 15:13:18 H.J. Lu wrote:
>> On Sun, Sep 4, 2011 at 2:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Sunday 04 September 2011 14:25:53 H.J. Lu wrote:
>> >> >> >> #define __NR_x32_recvfrom
>> >> >> >> #define __NR_x32_sendmsg
>> >> >> >> #define __NR_x32_recvmsg
>> >> >> >> #define __NR_x32_recvmmsg
>> >> >> >> #define __NR_x32_sendmmsg
>> >> >> >
>> >> >> > These today use the MSG_CMSG_COMPAT flag to distinguish native a=
nd compat
>> >> >> > calls. Do you plan to have another flag here to handle cmsg time=
 values?
>> >> >>
>> >> >> I am using x86-32 calls for them.
>> >> >
>> >> > But isn't that broken? These all pass u64 or time_t values at some =
point.
>> >> >
>> >>
>> >> time_t isn't a problem since time_t/timeval/timespec are identical fo=
r
>> >> x32 and x86-64. =A0As for u64, I added NATIVE_LONG_TYPE, which is
>> >> defined as long long for x32, =A0and use it instead of long in types =
for
>> >> 64bit system calls.
>> >
>> > Sorry, I misread you as saying you use the compat syscalls for these.
>> > If you use the native 64 bit syscalls, you have the opposite problem:
>> > Some network protocols (e.g. netlink or rxrpc) use other data structur=
es
>> > that require conversion, e.g. 'long' members that x32 will get wrong.
>>
>> For those, I use x86-32 calls.
>
> So to ask again, what do you plan to do about SCM_TIMESTAMP*?
>

I added MSG_CMSG_COMPAT64 and new compat system calls with
64bit timespec/val to support it.  See the enclosed patch.

BTW, I also added

compat_sys_preadv64(unsigned long fd, const struct compat_iovec __user *vec=
,
         unsigned long vlen, loff_t pos)
compat_sys_pwritev64(unsigned long fd, const struct compat_iovec __user *ve=
c,
         unsigned long vlen, loff_t pos)

to support 32bit compat_iovec * and 64bit offset.


--=20
H.J.

--0016e64b98966193ba04ac3320eb
Content-Type: text/plain; charset=US-ASCII; name="linux-cmsg-x32-1.patch"
Content-Disposition: attachment; filename="linux-cmsg-x32-1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gs7l2jxs0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc29ja2V0LmggYi9pbmNsdWRlL2xpbnV4L3NvY2tl
dC5oCmluZGV4IGQwZTc3ZjYuLjg2ZWNmMjcgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc29j
a2V0LmgKKysrIGIvaW5jbHVkZS9saW51eC9zb2NrZXQuaApAQCAtMjcyLDggKzI3MiwxMCBAQCBz
dHJ1Y3QgdWNyZWQgewogCQkJCQkgICBkZXNjcmlwdG9yIHJlY2VpdmVkIHRocm91Z2gKIAkJCQkJ
ICAgU0NNX1JJR0hUUyAqLwogI2lmIGRlZmluZWQoQ09ORklHX0NPTVBBVCkKKyNkZWZpbmUgTVNH
X0NNU0dfQ09NUEFUNjQgMHgyMDAwMDAwMAkvKiBUaGlzIG1lc3NhZ2UgbmVlZHMgNjQgYml0IHRp
bWVzdGFtcCAqLwogI2RlZmluZSBNU0dfQ01TR19DT01QQVQJMHg4MDAwMDAwMAkvKiBUaGlzIG1l
c3NhZ2UgbmVlZHMgMzIgYml0IGZpeHVwcyAqLwogI2Vsc2UKKyNkZWZpbmUgTVNHX0NNU0dfQ09N
UEFUNjQJMAkvKiBXZSBuZXZlciBoYXZlIDY0IGJpdCB0aW1lc3RhbXAgKi8KICNkZWZpbmUgTVNH
X0NNU0dfQ09NUEFUCTAJCS8qIFdlIG5ldmVyIGhhdmUgMzIgYml0IGZpeHVwcyAqLwogI2VuZGlm
CiAKZGlmZiAtLWdpdCBhL25ldC9jb21wYXQuYyBiL25ldC9jb21wYXQuYwppbmRleCBjNTc4ZDkz
Li41NTViOTUxIDEwMDY0NAotLS0gYS9uZXQvY29tcGF0LmMKKysrIGIvbmV0L2NvbXBhdC5jCkBA
IC0yMjksMjQgKzIyOSwyNiBAQCBpbnQgcHV0X2Ntc2dfY29tcGF0KHN0cnVjdCBtc2doZHIgKmtt
c2csIGludCBsZXZlbCwgaW50IHR5cGUsIGludCBsZW4sIHZvaWQgKmRhdAogCQlyZXR1cm4gMDsg
LyogWFhYOiByZXR1cm4gZXJyb3I/IGNoZWNrIHNwZWMuICovCiAJfQogCi0JaWYgKGxldmVsID09
IFNPTF9TT0NLRVQgJiYgdHlwZSA9PSBTQ01fVElNRVNUQU1QKSB7Ci0JCXN0cnVjdCB0aW1ldmFs
ICp0diA9IChzdHJ1Y3QgdGltZXZhbCAqKWRhdGE7Ci0JCWN0di50dl9zZWMgPSB0di0+dHZfc2Vj
OwotCQljdHYudHZfdXNlYyA9IHR2LT50dl91c2VjOwotCQlkYXRhID0gJmN0djsKLQkJbGVuID0g
c2l6ZW9mKGN0dik7Ci0JfQotCWlmIChsZXZlbCA9PSBTT0xfU09DS0VUICYmCi0JICAgICh0eXBl
ID09IFNDTV9USU1FU1RBTVBOUyB8fCB0eXBlID09IFNDTV9USU1FU1RBTVBJTkcpKSB7Ci0JCWlu
dCBjb3VudCA9IHR5cGUgPT0gU0NNX1RJTUVTVEFNUE5TID8gMSA6IDM7Ci0JCWludCBpOwotCQlz
dHJ1Y3QgdGltZXNwZWMgKnRzID0gKHN0cnVjdCB0aW1lc3BlYyAqKWRhdGE7Ci0JCWZvciAoaSA9
IDA7IGkgPCBjb3VudDsgaSsrKSB7Ci0JCQljdHNbaV0udHZfc2VjID0gdHNbaV0udHZfc2VjOwot
CQkJY3RzW2ldLnR2X25zZWMgPSB0c1tpXS50dl9uc2VjOworCWlmICgoTVNHX0NNU0dfQ09NUEFU
NjQgJiBrbXNnLT5tc2dfZmxhZ3MpID09IDApIHsKKwkJaWYgKGxldmVsID09IFNPTF9TT0NLRVQg
JiYgdHlwZSA9PSBTQ01fVElNRVNUQU1QKSB7CisJCQlzdHJ1Y3QgdGltZXZhbCAqdHYgPSAoc3Ry
dWN0IHRpbWV2YWwgKilkYXRhOworCQkJY3R2LnR2X3NlYyA9IHR2LT50dl9zZWM7CisJCQljdHYu
dHZfdXNlYyA9IHR2LT50dl91c2VjOworCQkJZGF0YSA9ICZjdHY7CisJCQlsZW4gPSBzaXplb2Yo
Y3R2KTsKKwkJfQorCQlpZiAobGV2ZWwgPT0gU09MX1NPQ0tFVCAmJgorCQkgICAgKHR5cGUgPT0g
U0NNX1RJTUVTVEFNUE5TIHx8IHR5cGUgPT0gU0NNX1RJTUVTVEFNUElORykpIHsKKwkJCWludCBj
b3VudCA9IHR5cGUgPT0gU0NNX1RJTUVTVEFNUE5TID8gMSA6IDM7CisJCQlpbnQgaTsKKwkJCXN0
cnVjdCB0aW1lc3BlYyAqdHMgPSAoc3RydWN0IHRpbWVzcGVjICopZGF0YTsKKwkJCWZvciAoaSA9
IDA7IGkgPCBjb3VudDsgaSsrKSB7CisJCQkJY3RzW2ldLnR2X3NlYyA9IHRzW2ldLnR2X3NlYzsK
KwkJCQljdHNbaV0udHZfbnNlYyA9IHRzW2ldLnR2X25zZWM7CisJCQl9CisJCQlkYXRhID0gJmN0
czsKKwkJCWxlbiA9IHNpemVvZihjdHNbMF0pICogY291bnQ7CiAJCX0KLQkJZGF0YSA9ICZjdHM7
Ci0JCWxlbiA9IHNpemVvZihjdHNbMF0pICogY291bnQ7CiAJfQogCiAJY21sZW4gPSBDTVNHX0NP
TVBBVF9MRU4obGVuKTsKQEAgLTc4MSw2ICs3ODMsNTIgQEAgYXNtbGlua2FnZSBsb25nIGNvbXBh
dF9zeXNfcmVjdm1tc2coaW50IGZkLCBzdHJ1Y3QgY29tcGF0X21tc2doZHIgX191c2VyICptbXNn
LAogCXJldHVybiBkYXRhZ3JhbXM7CiB9CiAKK2FzbWxpbmthZ2UgbG9uZyBjb21wYXRfc3lzX3Nl
bmRtc2c2NChpbnQgZmQsIHN0cnVjdCBjb21wYXRfbXNnaGRyIF9fdXNlciAqbXNnLAorCQkJCSAg
ICAgdW5zaWduZWQgZmxhZ3MpCit7CisJcmV0dXJuIHN5c19zZW5kbXNnKGZkLCAoc3RydWN0IG1z
Z2hkciBfX3VzZXIgKiltc2csCisJCQkgICBmbGFncyB8IE1TR19DTVNHX0NPTVBBVCB8IE1TR19D
TVNHX0NPTVBBVDY0KTsKK30KKworYXNtbGlua2FnZSBsb25nIGNvbXBhdF9zeXNfc2VuZG1tc2c2
NChpbnQgZmQsIHN0cnVjdCBjb21wYXRfbW1zZ2hkciBfX3VzZXIgKm1tc2csCisJCQkJICAgICAg
dW5zaWduZWQgdmxlbiwgdW5zaWduZWQgaW50IGZsYWdzKQoreworCXJldHVybiBfX3N5c19zZW5k
bW1zZyhmZCwgKHN0cnVjdCBtbXNnaGRyIF9fdXNlciAqKW1tc2csIHZsZW4sCisJCQkgICAgICBm
bGFncyB8IE1TR19DTVNHX0NPTVBBVCB8IE1TR19DTVNHX0NPTVBBVDY0KTsKK30KKworYXNtbGlu
a2FnZSBsb25nIGNvbXBhdF9zeXNfcmVjdm1zZzY0KGludCBmZCwgc3RydWN0IGNvbXBhdF9tc2do
ZHIgX191c2VyICptc2csCisJCQkJICAgICB1bnNpZ25lZCBpbnQgZmxhZ3MpCit7CisJcmV0dXJu
IHN5c19yZWN2bXNnKGZkLCAoc3RydWN0IG1zZ2hkciBfX3VzZXIgKiltc2csCisJCQkgICBmbGFn
cyB8IE1TR19DTVNHX0NPTVBBVCB8IE1TR19DTVNHX0NPTVBBVDY0KTsKK30KKworYXNtbGlua2Fn
ZSBsb25nIGNvbXBhdF9zeXNfcmVjdjY0KGludCBmZCwgdm9pZCBfX3VzZXIgKmJ1Ziwgc2l6ZV90
IGxlbiwKKwkJCQkgIHVuc2lnbmVkIGZsYWdzKQoreworCXJldHVybiBzeXNfcmVjdihmZCwgYnVm
LCBsZW4sCisJCQlmbGFncyB8IE1TR19DTVNHX0NPTVBBVCB8IE1TR19DTVNHX0NPTVBBVDY0KTsK
K30KKworYXNtbGlua2FnZSBsb25nIGNvbXBhdF9zeXNfcmVjdmZyb202NChpbnQgZmQsIHZvaWQg
X191c2VyICpidWYsIHNpemVfdCBsZW4sCisJCQkJICAgICAgdW5zaWduZWQgZmxhZ3MsIHN0cnVj
dCBzb2NrYWRkciBfX3VzZXIgKmFkZHIsCisJCQkJICAgICAgaW50IF9fdXNlciAqYWRkcmxlbikK
K3sKKwlyZXR1cm4gc3lzX3JlY3Zmcm9tKGZkLCBidWYsIGxlbiwKKwkJCSAgICBmbGFncyB8IE1T
R19DTVNHX0NPTVBBVCB8IE1TR19DTVNHX0NPTVBBVDY0LAorCQkJICAgIGFkZHIsIGFkZHJsZW4p
OworfQorCithc21saW5rYWdlIGxvbmcgY29tcGF0X3N5c19yZWN2bW1zZzY0KGludCBmZCwgc3Ry
dWN0IGNvbXBhdF9tbXNnaGRyIF9fdXNlciAqbW1zZywKKwkJCQkgICAgICB1bnNpZ25lZCB2bGVu
LCB1bnNpZ25lZCBpbnQgZmxhZ3MsCisJCQkJICAgICAgc3RydWN0IHRpbWVzcGVjIF9fdXNlciAq
dGltZW91dCkKK3sKKwlyZXR1cm4gX19zeXNfcmVjdm1tc2coZmQsIChzdHJ1Y3QgbW1zZ2hkciBf
X3VzZXIgKiltbXNnLCB2bGVuLAorCQkJICAgICAgZmxhZ3MgfCBNU0dfQ01TR19DT01QQVQgfCBN
U0dfQ01TR19DT01QQVQ2NCwKKwkJCSAgICAgIHRpbWVvdXQpOworfQorCiBhc21saW5rYWdlIGxv
bmcgY29tcGF0X3N5c19zb2NrZXRjYWxsKGludCBjYWxsLCB1MzIgX191c2VyICphcmdzKQogewog
CWludCByZXQ7CmRpZmYgLS1naXQgYS9uZXQvc29ja2V0LmMgYi9uZXQvc29ja2V0LmMKaW5kZXgg
MjRhNzc0MC4uZmFlNTQ3MiAxMDA2NDQKLS0tIGEvbmV0L3NvY2tldC5jCisrKyBiL25ldC9zb2Nr
ZXQuYwpAQCAtMjEzMyw3ICsyMTMzLDcgQEAgc3RhdGljIGludCBfX3N5c19yZWN2bXNnKHN0cnVj
dCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgX191c2VyICptc2csCiAJdG90YWxfbGVuID0g
ZXJyOwogCiAJY21zZ19wdHIgPSAodW5zaWduZWQgbG9uZyltc2dfc3lzLT5tc2dfY29udHJvbDsK
LQltc2dfc3lzLT5tc2dfZmxhZ3MgPSBmbGFncyAmIChNU0dfQ01TR19DTE9FWEVDfE1TR19DTVNH
X0NPTVBBVCk7CisJbXNnX3N5cy0+bXNnX2ZsYWdzID0gZmxhZ3MgJiAoTVNHX0NNU0dfQ0xPRVhF
Q3xNU0dfQ01TR19DT01QQVR8TVNHX0NNU0dfQ09NUEFUNjQpOwogCiAJaWYgKHNvY2stPmZpbGUt
PmZfZmxhZ3MgJiBPX05PTkJMT0NLKQogCQlmbGFncyB8PSBNU0dfRE9OVFdBSVQ7Cg==
--0016e64b98966193ba04ac3320eb--
