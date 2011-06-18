Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1FROng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 10:43:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab1FROnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 10:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p4obWsu1a+EuxeN77QyBT+qYXJhp6FgzZa+XQfHunLpFd7KSFWdcIfYztjw0iY69aS
         p7MnR7kbz/G7yPqj7L2k4wOPrdSsu6hVvPZ2nJsN3To4l2+XKfEWUUg4GAMzbFl3lx8F
         U+8Q1QdXRVEetN0tbMLoywN1wWpihZVAhkBtE=
MIME-Version: 1.0
In-Reply-To: <20110618150356.1b9e31cb@farn.lan>
References: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
	<20110618133957.378b5266@farn.lan>
	<BANLkTikT3qoZhTrd0uF-JNehNhTCRjF6kw@mail.gmail.com>
	<BANLkTinf8X1AUEHteMnU3MMBEPEO1WNtzA@mail.gmail.com>
	<20110618150356.1b9e31cb@farn.lan>
Date: Sat, 18 Jun 2011 16:43:34 +0200
Message-ID: <BANLkTikpPzt3B6osydhd6BhiXUHAJsC3oA@mail.gmail.com>
Subject: Re: Lock up when faking MMIO read[bwl] on some machines [WAS: Faking
 MMIO ops? Fooling a driver]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pekka Paalanen <pq@iki.fi>, David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: multipart/mixed; boundary=bcaec543084cd738f404a5fd86c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec543084cd738f404a5fd86c0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

W dniu 18 czerwca 2011 14:03 u=C5=BCytkownik Pekka Paalanen <pq@iki.fi> nap=
isa=C5=82:
> Maybe the driver is doing a 16-bit wide access, and happens to
> store something else in the other 16/48 bits of RAX?

OK, attached is updated version of my patch. I think we can get some
clue from dmesgs with this patch applied.


My system (working):
[   74.472502] mmiotrace: ZAJEC: overwriting 0x27 with 0xFFFF
[   74.472511] mmiotrace: [ZAJEC] opcode is 0x8B
[   74.472515] mmiotrace: [ZAJEC] prf info: shorted:1; enlarged:0, rexr:0, =
rex:0
[   74.472517] mmiotrace: [ZAJEC] register is 0x0
[   74.472520] mmiotrace: [ZAJEC] overwritting 2-byte value 0x0514 with 0xF=
FFF
[   74.472523] mmiotrace: [ZAJEC] overwritting resulted in 0xFFFF

[   74.487081] mmiotrace: ZAJEC: overwriting 0x20 with 0xFFFF
[   74.487086] mmiotrace: [ZAJEC] opcode is 0x8B
[   74.487089] mmiotrace: [ZAJEC] prf info: shorted:1; enlarged:0, rexr:0, =
rex:0
[   74.487092] mmiotrace: [ZAJEC] register is 0x0
[   74.487095] mmiotrace: [ZAJEC] overwritting 2-byte value 0x427E with 0xF=
FFF
[   74.487097] mmiotrace: [ZAJEC] overwritting resulted in 0xFFFF


MacBook (with real overwritting commenet out!):
[  228.248715] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
[  228.254227] mmiotrace: [ZAJEC] opcode is 0xB70F
[  228.259784] mmiotrace: [ZAJEC] prf info: shorted:0; enlarged:0, rexr:0, =
rex:0
[  228.265399] mmiotrace: [ZAJEC] register is 0x0
[  228.270955] mmiotrace: [ZAJEC] overwritting 4-byte value 0x00000000
with 0xFFFF
[  228.276597] mmiotrace: [ZAJEC] overwritting resulted in 0x00000000

[  228.284284] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
[  228.289818] mmiotrace: [ZAJEC] opcode is 0xB70F
[  228.295250] mmiotrace: [ZAJEC] prf info: shorted:0; enlarged:0, rexr:0, =
rex:0
[  228.300838] mmiotrace: [ZAJEC] register is 0x0
[  228.306339] mmiotrace: [ZAJEC] overwritting 4-byte value 0x00000000
with 0xFFFF
[  228.311905] mmiotrace: [ZAJEC] overwritting resulted in 0x00000000


It's 2-byte vs. 4-byte. I suspect this can be the source of our
problem. Writing u16 0xFFFF value as u32 write.

--=20
Rafa=C5=82

--bcaec543084cd738f404a5fd86c0
Content-Type: application/octet-stream; name="mmio.debugging.patch"
Content-Disposition: attachment; filename="mmio.debugging.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gp2odnb50

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL21taW8tbW9kLmMgYi9hcmNoL3g4Ni9tbS9tbWlvLW1v
ZC5jCmluZGV4IDNhZGZmN2QuLmQ1YWM3ZGEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L21tL21taW8t
bW9kLmMKKysrIGIvYXJjaC94ODYvbW0vbW1pby1tb2QuYwpAQCAtMjA2LDYgKzIwNiwxMiBAQCBz
dGF0aWMgdm9pZCBwcmUoc3RydWN0IGttbWlvX3Byb2JlICpwLCBzdHJ1Y3QgcHRfcmVncyAqcmVn
cywKIAlwdXRfY3B1X3ZhcihwZl9yZWFzb24pOwogfQogCisjZGVmaW5lIE1NSU9fQkFTRQkJCTB4
ZmFhZmMwMDAKKyNkZWZpbmUgQjQzX01NSU9fUEhZX0NPTlRST0wJCTB4M0ZDCisjZGVmaW5lIEI0
M19NTUlPX1BIWV9EQVRBCQkweDNGRQorCitzdGF0aWMgdTE2IGJyb2FkY29tX3BoeV9hZGRyOwor
CiBzdGF0aWMgdm9pZCBwb3N0KHN0cnVjdCBrbW1pb19wcm9iZSAqcCwgdW5zaWduZWQgbG9uZyBj
b25kaXRpb24sCiAJCQkJCQkJc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCiB7CkBAIC0yMTksNiArMjI1
LDE5IEBAIHN0YXRpYyB2b2lkIHBvc3Qoc3RydWN0IGttbWlvX3Byb2JlICpwLCB1bnNpZ25lZCBs
b25nIGNvbmRpdGlvbiwKIAkJQlVHKCk7CiAJfQogCisJaWYgKG15X3JlYXNvbi0+dHlwZSA9PSBS
RUdfUkVBRCAmJiBteV90cmFjZS0+cGh5cyA9PSBNTUlPX0JBU0UgKyBCNDNfTU1JT19QSFlfREFU
QSkgeworCQkvL3ByX2luZm8oIlpBSkVDOiByZWFkIFBIWSAweCVYXG4iLCBicm9hZGNvbV9waHlf
YWRkcik7CisJCXN3aXRjaCAoYnJvYWRjb21fcGh5X2FkZHIpeworCQljYXNlIDB4MjA6CisJCWNh
c2UgMHgyMjoKKwkJY2FzZSAweDI3OgorCQljYXNlIDB4ODEwOgorCQkJcHJfaW5mbygiWkFKRUM6
IG92ZXJ3cml0aW5nIDB4JVggd2l0aCAweEZGRkZcbiIsIGJyb2FkY29tX3BoeV9hZGRyKTsKKwkJ
CXNldF9pbnNfcmVnX3ZhbChteV9yZWFzb24tPmlwLCByZWdzLCAweEZGRkYpOworCQkJYnJlYWs7
CisJCX0KKwl9CisKIAlzd2l0Y2ggKG15X3JlYXNvbi0+dHlwZSkgewogCWNhc2UgUkVHX1JFQUQ6
CiAJCW15X3RyYWNlLT52YWx1ZSA9IGdldF9pbnNfcmVnX3ZhbChteV9yZWFzb24tPmlwLCByZWdz
KTsKQEAgLTIyNyw2ICsyNDYsMTEgQEAgc3RhdGljIHZvaWQgcG9zdChzdHJ1Y3Qga21taW9fcHJv
YmUgKnAsIHVuc2lnbmVkIGxvbmcgY29uZGl0aW9uLAogCQlicmVhazsKIAl9CiAKKwlpZiAobXlf
cmVhc29uLT50eXBlID09IFJFR19XUklURSAmJiBteV90cmFjZS0+cGh5cyA9PSBNTUlPX0JBU0Ug
KyBCNDNfTU1JT19QSFlfQ09OVFJPTCkgeworCQlicm9hZGNvbV9waHlfYWRkciA9IG15X3RyYWNl
LT52YWx1ZTsKKwkJLy9wcl9pbmZvKCJaQUpFQzogc2V0dGluZyBQSFkgYWRkciB0byAweCVYXG4i
LCBicm9hZGNvbV9waHlfYWRkcik7CisJfQorCiAJbW1pb190cmFjZV9ydyhteV90cmFjZSk7CiAJ
cHV0X2NwdV92YXIoY3B1X3RyYWNlKTsKIAlwdXRfY3B1X3ZhcihwZl9yZWFzb24pOwpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvbW0vcGZfaW4uYyBiL2FyY2gveDg2L21tL3BmX2luLmMKaW5kZXggOWYw
NjE0ZC4uODUxOWY2OSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbW0vcGZfaW4uYworKysgYi9hcmNo
L3g4Ni9tbS9wZl9pbi5jCkBAIC00NjEsNiArNDYxLDc1IEBAIGVycjoKIAlyZXR1cm4gMDsKIH0K
IAordm9pZCBzZXRfaW5zX3JlZ192YWwodW5zaWduZWQgbG9uZyBpbnNfYWRkciwgc3RydWN0IHB0
X3JlZ3MgKnJlZ3MsIHUzMiB2YWwpCit7CisJdW5zaWduZWQgaW50IG9wY29kZTsKKwlpbnQgcmVn
OworCXVuc2lnbmVkIGNoYXIgKnA7CisJc3RydWN0IHByZWZpeF9iaXRzIHByZjsKKwlpbnQgaTsK
KworCXAgPSAodW5zaWduZWQgY2hhciAqKWluc19hZGRyOworCXAgKz0gc2tpcF9wcmVmaXgocCwg
JnByZik7CisJcCArPSBnZXRfb3Bjb2RlKHAsICZvcGNvZGUpOworCWZvciAoaSA9IDA7IGkgPCBB
UlJBWV9TSVpFKHJlZ19yb3ApOyBpKyspCisJCWlmIChyZWdfcm9wW2ldID09IG9wY29kZSkKKwkJ
CWdvdG8gZG9fd29yazsKKworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHJlZ193b3ApOyBp
KyspCisJCWlmIChyZWdfd29wW2ldID09IG9wY29kZSkKKwkJCWdvdG8gZG9fd29yazsKKworCXBy
aW50ayhLRVJOX0VSUiAibW1pb3RyYWNlOiBOb3QgYSByZWdpc3RlciBpbnN0cnVjdGlvbiwgb3Bj
b2RlICIKKwkJCQkJCQkiMHglMDJ4XG4iLCBvcGNvZGUpOworCXJldHVybjsKKworZG9fd29yazoK
KwlwcmludGsoS0VSTl9JTkZPICJtbWlvdHJhY2U6IFtaQUpFQ10gb3Bjb2RlIGlzIDB4JVhcbiIs
IG9wY29kZSk7CisJcHJpbnRrKEtFUk5fSU5GTyAibW1pb3RyYWNlOiBbWkFKRUNdIHByZiBpbmZv
OiBzaG9ydGVkOiVkOyBlbmxhcmdlZDolZCwgcmV4cjolZCwgcmV4OiVkXG4iLCBwcmYuc2hvcnRl
ZCwgcHJmLmVubGFyZ2VkLCBwcmYucmV4ciwgcHJmLnJleCk7CisJLyogZm9yIFNUT1MsIHNvdXJj
ZSByZWdpc3RlciBpcyBmaXhlZCAqLworCWlmIChvcGNvZGUgPT0gMHhBQSB8fCBvcGNvZGUgPT0g
MHhBQikgeworCQlyZWcgPSBhcmdfQVg7CisJfSBlbHNlIHsKKwkJdW5zaWduZWQgY2hhciBtb2Rf
cm0gPSAqcDsKKwkJcmVnID0gKChtb2Rfcm0gPj4gMykgJiAweDcpIHwgKHByZi5yZXhyIDw8IDMp
OworCX0KKwlwcmludGsoS0VSTl9JTkZPICJtbWlvdHJhY2U6IFtaQUpFQ10gcmVnaXN0ZXIgaXMg
MHglWFxuIiwgcmVnKTsKKwlzd2l0Y2ggKGdldF9pbnNfcmVnX3dpZHRoKGluc19hZGRyKSkgewor
CWNhc2UgMToKKwkJcHJpbnRrKEtFUk5fRVJSICJtbWlvdHJhY2U6IFtaQUpFQ10gdW5zdXBwb3J0
ZWQgd2lkdGggMVxuIik7CisJCWJyZWFrOworCWNhc2UgMjoKKwkJeworCQl1bnNpZ25lZCBzaG9y
dCAqenB0ciA9ICh1bnNpZ25lZCBzaG9ydCAqKWdldF9yZWdfdzMyKHJlZywgcmVncyk7CisJCXBy
aW50ayhLRVJOX0lORk8gIm1taW90cmFjZTogW1pBSkVDXSBvdmVyd3JpdHRpbmcgMi1ieXRlIHZh
bHVlIDB4JTA0WCB3aXRoIDB4JVhcbiIsICooenB0ciksIHZhbCk7CisJCSooenB0cikgPSB2YWw7
CisJCXByaW50ayhLRVJOX0lORk8gIm1taW90cmFjZTogW1pBSkVDXSBvdmVyd3JpdHRpbmcgcmVz
dWx0ZWQgaW4gMHglMDRYXG4iLCAqKHpwdHIpKTsKKwkJfQorCQlicmVhazsKKwljYXNlIDQ6CisJ
CXsKKwkJdW5zaWduZWQgaW50ICp6cHRyID0gKHVuc2lnbmVkIGludCAqKWdldF9yZWdfdzMyKHJl
ZywgcmVncyk7CisJCXByaW50ayhLRVJOX0lORk8gIm1taW90cmFjZTogW1pBSkVDXSBvdmVyd3Jp
dHRpbmcgNC1ieXRlIHZhbHVlIDB4JTA4WCB3aXRoIDB4JVhcbiIsICooenB0ciksIHZhbCk7CisJ
CSooenB0cikgPSB2YWw7CisJCXByaW50ayhLRVJOX0lORk8gIm1taW90cmFjZTogW1pBSkVDXSBv
dmVyd3JpdHRpbmcgcmVzdWx0ZWQgaW4gMHglMDhYXG4iLCAqKHpwdHIpKTsKKwkJfQorCQlicmVh
azsKKyNpZmRlZiBfX2FtZDY0X18KKwljYXNlIDg6CisJCXsKKwkJdW5zaWduZWQgbG9uZyAqenB0
ciA9ICh1bnNpZ25lZCBsb25nICopZ2V0X3JlZ193MzIocmVnLCByZWdzKTsKKwkJcHJpbnRrKEtF
Uk5fSU5GTyAibW1pb3RyYWNlOiBbWkFKRUNdIG92ZXJ3cml0dGluZyA4LWJ5dGUgdmFsdWUgMHgl
MDE2WCB3aXRoIDB4JVhcbiIsICooenB0ciksIHZhbCk7CisJCSooenB0cikgPSB2YWw7CisJCXBy
aW50ayhLRVJOX0lORk8gIm1taW90cmFjZTogW1pBSkVDXSBvdmVyd3JpdHRpbmcgcmVzdWx0ZWQg
aW4gMHglMDE2bFhcbiIsICooenB0cikpOworCQl9CisJCWJyZWFrOworI2VuZGlmCisJZGVmYXVs
dDoKKwkJcHJpbnRrKEtFUk5fRVJSICJtbWlvdHJhY2U6IFtaQUpFQ10gRXJyb3Igd2lkdGgjICVk
XG4iLCByZWcpOworCX0KK30KKwogdW5zaWduZWQgbG9uZyBnZXRfaW5zX2ltbV92YWwodW5zaWdu
ZWQgbG9uZyBpbnNfYWRkcikKIHsKIAl1bnNpZ25lZCBpbnQgb3Bjb2RlOwpkaWZmIC0tZ2l0IGEv
YXJjaC94ODYvbW0vcGZfaW4uaCBiL2FyY2gveDg2L21tL3BmX2luLmgKaW5kZXggZTA1MzQxYS4u
OTBiNDNmZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbW0vcGZfaW4uaAorKysgYi9hcmNoL3g4Ni9t
bS9wZl9pbi5oCkBAIC0zNCw2ICszNCw3IEBAIGVudW0gcmVhc29uX3R5cGUgewogZW51bSByZWFz
b25fdHlwZSBnZXRfaW5zX3R5cGUodW5zaWduZWQgbG9uZyBpbnNfYWRkcik7CiB1bnNpZ25lZCBp
bnQgZ2V0X2luc19tZW1fd2lkdGgodW5zaWduZWQgbG9uZyBpbnNfYWRkcik7CiB1bnNpZ25lZCBs
b25nIGdldF9pbnNfcmVnX3ZhbCh1bnNpZ25lZCBsb25nIGluc19hZGRyLCBzdHJ1Y3QgcHRfcmVn
cyAqcmVncyk7Cit2b2lkIHNldF9pbnNfcmVnX3ZhbCh1bnNpZ25lZCBsb25nIGluc19hZGRyLCBz
dHJ1Y3QgcHRfcmVncyAqcmVncywgdTMyIHZhbCk7CiB1bnNpZ25lZCBsb25nIGdldF9pbnNfaW1t
X3ZhbCh1bnNpZ25lZCBsb25nIGluc19hZGRyKTsKIAogI2VuZGlmIC8qIF9fUEZfSF8gKi8K
--bcaec543084cd738f404a5fd86c0--
