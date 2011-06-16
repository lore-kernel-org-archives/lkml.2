Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161036Ab1FPVxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:53:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51512 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161023Ab1FPVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QkfZZhP1vm0Bbp7JckHWN2tXt90GvG8QjRN1+y0RBcn77rzoW+8CdzVaiqIsPmbBy9
         2/BK3MQyW6r/UqHxzc2CKJhdduyo5yM594+9S3RiT06w1KVHDllExLpYIwt5SIVG7QUI
         fxfIHaxmBYHpvqiSRvhCTKSD2cSbw7I4bBeXo=
MIME-Version: 1.0
In-Reply-To: <BANLkTikLU_f6PYX-vdRSJN5WsKSkQsYH3g@mail.gmail.com>
References: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com>
	<BANLkTinUxRGkXeOtBSKi51n3Q_rZEp1gUg@mail.gmail.com>
	<4DFA4672.5080307@lwfinger.net>
	<BANLkTi=-wXnXNJY3R+3Q+KSaJhtxHgrhZw@mail.gmail.com>
	<20110616223456.5cfdec2b@farn.lan>
	<BANLkTikLU_f6PYX-vdRSJN5WsKSkQsYH3g@mail.gmail.com>
Date: Thu, 16 Jun 2011 23:53:18 +0200
Message-ID: <BANLkTi=V4Ys5uT9TrG5NjJ3JuqBVGTshsw@mail.gmail.com>
Subject: Re: Faking MMIO ops? Fooling a driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec520e52109e18f04a5db4c0f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec520e52109e18f04a5db4c0f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

W dniu 16 czerwca 2011 23:47 u=C5=BCytkownik Rafa=C5=82 Mi=C5=82ecki
<zajec5@gmail.com> napisa=C5=82:
> W dniu 16 czerwca 2011 21:34 u=C5=BCytkownik Pekka Paalanen <pq@iki.fi> n=
apisa=C5=82:
>> On Thu, 16 Jun 2011 21:19:04 +0200
>> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
>>
>>> W dniu 16 czerwca 2011 20:07 u=C5=BCytkownik Larry Finger
>>> <Larry.Finger@lwfinger.net> napisa=C5=82:
>>> > On 06/16/2011 12:20 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> >>
>>> >> W dniu 16 czerwca 2011 16:44 u=C5=BCytkownik Rafa=C5=82 Mi=C5=82ecki
>>> >> <zajec5@gmail.com> =C2=A0napisa=C5=82:
>>> >>>
>>> >>> I analyze MMIO dumps of closed source driver and found such a
>>> >>> place: W 2 3855.911536 9 0xb06003fc 0x810 0x0 0
>>> >>> R 2 3855.911540 9 0xb06003fe 0x0 0x0 0
>>> >>> W 2 3855.911541 9 0xb06003fe 0x0 0x0 0
>>> >>>
>>> >>> After translation:
>>> >>> =C2=A0phy_read(0x0810) -> =C2=A00x0000
>>> >>> phy_write(0x0810)<- 0x0000
>>> >>>
>>> >>> So it's quite obvious, the driver is reading PHY register,
>>> >>> masking it and writing masked value. Unfortunately from just
>>> >>> looking at such place we can not guess the mask driver uses.
>>> >>>
>>> >>> I'd like to fake value read from 0xb06003fe to be 0xFFFF.
>>> >>> Is there some ready method for doing such a trick?
>>> >>>
>>> >>> Dump comes from Kernel hacking =E2=86=92 Tracers =E2=86=92 MMIO and
>>> >>> ndiswrapper.
>>> >>
>>> >> I can see values in MMIO trace struct are filled in
>>> >> arch/x86/mm/mmio-mod.c in "pre" and "post". However still no
>>> >> idea how to hack the returned value.
>>
>> If you want to do it that way, the idea is to overwrite
>> the right CPU register in mmio-mod.c:post(). You would test for
>> the address you want to mess with, and then "invert"
>> get_ins_reg_val() to overwrite the register with your own value.
>
> Good, idea thanks!

Implementation attached.
Now I only need to track writes to 0xfaafc3fc (that register is for
addressing to-follow PHY read/write) and wait for 0xfaafc3fe which is
read of PHY register value.

--=20
Rafa=C5=82

--bcaec520e52109e18f04a5db4c0f
Content-Type: application/octet-stream; name="mmio.fake.0xfaafc000.patch"
Content-Disposition: attachment; filename="mmio.fake.0xfaafc000.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gp08tyix0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL21taW8tbW9kLmMgYi9hcmNoL3g4Ni9tbS9tbWlvLW1v
ZC5jCmluZGV4IDNhZGZmN2QuLjdmNzE4ODRiIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9tbS9tbWlv
LW1vZC5jCisrKyBiL2FyY2gveDg2L21tL21taW8tbW9kLmMKQEAgLTIxOSw2ICsyMTksMTEgQEAg
c3RhdGljIHZvaWQgcG9zdChzdHJ1Y3Qga21taW9fcHJvYmUgKnAsIHVuc2lnbmVkIGxvbmcgY29u
ZGl0aW9uLAogCQlCVUcoKTsKIAl9CiAKKwlpZiAobXlfdHJhY2UtPnBoeXMgPT0gMHhmYWFmYzAw
MCkgeworCQlwcl9pbmZvKCJaQUpFQzogZ290IGl0XG4iKTsKKwkJc2V0X2luc19yZWdfdmFsKG15
X3JlYXNvbi0+aXAsIHJlZ3MsIDB4MTM4MTY2NjYpOworCX0KKwogCXN3aXRjaCAobXlfcmVhc29u
LT50eXBlKSB7CiAJY2FzZSBSRUdfUkVBRDoKIAkJbXlfdHJhY2UtPnZhbHVlID0gZ2V0X2luc19y
ZWdfdmFsKG15X3JlYXNvbi0+aXAsIHJlZ3MpOwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvbW0vcGZf
aW4uYyBiL2FyY2gveDg2L21tL3BmX2luLmMKaW5kZXggOWYwNjE0ZC4uODY0NDllZCAxMDA2NDQK
LS0tIGEvYXJjaC94ODYvbW0vcGZfaW4uYworKysgYi9hcmNoL3g4Ni9tbS9wZl9pbi5jCkBAIC00
NjEsNiArNDYxLDk5IEBAIGVycjoKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIHZvaWQgc2V0X3Jl
Z193MzIoaW50IG5vLCBzdHJ1Y3QgcHRfcmVncyAqcmVncywgdTMyIHZhbCkKK3sKKwlzd2l0Y2gg
KG5vKSB7CisJY2FzZSBhcmdfQVg6CisJCXJlZ3MtPmF4ID0gdmFsOworCQlicmVhazsKKwljYXNl
IGFyZ19CWDoKKwkJcmVncy0+YnggPSB2YWw7CisJCWJyZWFrOworCWNhc2UgYXJnX0NYOgorCQly
ZWdzLT5jeCA9IHZhbDsKKwkJYnJlYWs7CisJY2FzZSBhcmdfRFg6CisJCXJlZ3MtPmR4ID0gdmFs
OworCQlicmVhazsKKwljYXNlIGFyZ19TUDoKKwkJcmVncy0+c3AgPSB2YWw7CisJCWJyZWFrOwor
CWNhc2UgYXJnX0JQOgorCQlyZWdzLT5icCA9IHZhbDsKKwkJYnJlYWs7CisJY2FzZSBhcmdfU0k6
CisJCXJlZ3MtPnNpID0gdmFsOworCQlicmVhazsKKwljYXNlIGFyZ19ESToKKwkJcmVncy0+ZGkg
PSB2YWw7CisJCWJyZWFrOworI2lmZGVmIF9fYW1kNjRfXworCWNhc2UgYXJnX1I4OgorCQlyZWdz
LT5yOCA9IHZhbDsKKwkJYnJlYWs7CisJY2FzZSBhcmdfUjk6CisJCXJlZ3MtPnI5ID0gdmFsOwor
CQlicmVhazsKKwljYXNlIGFyZ19SMTA6CisJCXJlZ3MtPnIxMCA9IHZhbDsKKwkJYnJlYWs7CisJ
Y2FzZSBhcmdfUjExOgorCQlyZWdzLT5yMTEgPSB2YWw7CisJCWJyZWFrOworCWNhc2UgYXJnX1Ix
MjoKKwkJcmVncy0+cjEyID0gdmFsOworCQlicmVhazsKKwljYXNlIGFyZ19SMTM6CisJCXJlZ3Mt
PnIxMyA9IHZhbDsKKwkJYnJlYWs7CisJY2FzZSBhcmdfUjE0OgorCQlyZWdzLT5yMTQgPSB2YWw7
CisJCWJyZWFrOworCWNhc2UgYXJnX1IxNToKKwkJcmVncy0+cjE1ID0gdmFsOworCQlicmVhazsK
KyNlbmRpZgorCWRlZmF1bHQ6CisJCXByaW50ayhLRVJOX0VSUiAibW1pb3RyYWNlOiBFcnJvciBy
ZWcgbm8jICVkXG4iLCBubyk7CisJfQorfQorCit2b2lkIHNldF9pbnNfcmVnX3ZhbCh1bnNpZ25l
ZCBsb25nIGluc19hZGRyLCBzdHJ1Y3QgcHRfcmVncyAqcmVncywgdTMyIHZhbCkKK3sKKwl1bnNp
Z25lZCBpbnQgb3Bjb2RlOworCWludCByZWc7CisJdW5zaWduZWQgY2hhciAqcDsKKwlzdHJ1Y3Qg
cHJlZml4X2JpdHMgcHJmOworCWludCBpOworCisJcCA9ICh1bnNpZ25lZCBjaGFyICopaW5zX2Fk
ZHI7CisJcCArPSBza2lwX3ByZWZpeChwLCAmcHJmKTsKKwlwICs9IGdldF9vcGNvZGUocCwgJm9w
Y29kZSk7CisJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUocmVnX3JvcCk7IGkrKykKKwkJaWYg
KHJlZ19yb3BbaV0gPT0gb3Bjb2RlKQorCQkJZ290byBkb193b3JrOworCisJZm9yIChpID0gMDsg
aSA8IEFSUkFZX1NJWkUocmVnX3dvcCk7IGkrKykKKwkJaWYgKHJlZ193b3BbaV0gPT0gb3Bjb2Rl
KQorCQkJZ290byBkb193b3JrOworCisJcHJpbnRrKEtFUk5fRVJSICJtbWlvdHJhY2U6IE5vdCBh
IHJlZ2lzdGVyIGluc3RydWN0aW9uLCBvcGNvZGUgIgorCQkJCQkJCSIweCUwMnhcbiIsIG9wY29k
ZSk7CisJcmV0dXJuOworCitkb193b3JrOgorCS8qIGZvciBTVE9TLCBzb3VyY2UgcmVnaXN0ZXIg
aXMgZml4ZWQgKi8KKwlpZiAob3Bjb2RlID09IDB4QUEgfHwgb3Bjb2RlID09IDB4QUIpIHsKKwkJ
cmVnID0gYXJnX0FYOworCX0gZWxzZSB7CisJCXVuc2lnbmVkIGNoYXIgbW9kX3JtID0gKnA7CisJ
CXJlZyA9ICgobW9kX3JtID4+IDMpICYgMHg3KSB8IChwcmYucmV4ciA8PCAzKTsKKwl9CisKKwlz
ZXRfcmVnX3czMihyZWcsIHJlZ3MsIHZhbCk7Cit9CisKIHVuc2lnbmVkIGxvbmcgZ2V0X2luc19p
bW1fdmFsKHVuc2lnbmVkIGxvbmcgaW5zX2FkZHIpCiB7CiAJdW5zaWduZWQgaW50IG9wY29kZTsK
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3BmX2luLmggYi9hcmNoL3g4Ni9tbS9wZl9pbi5oCmlu
ZGV4IGUwNTM0MWEuLjkwYjQzZmYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L21tL3BmX2luLmgKKysr
IGIvYXJjaC94ODYvbW0vcGZfaW4uaApAQCAtMzQsNiArMzQsNyBAQCBlbnVtIHJlYXNvbl90eXBl
IHsKIGVudW0gcmVhc29uX3R5cGUgZ2V0X2luc190eXBlKHVuc2lnbmVkIGxvbmcgaW5zX2FkZHIp
OwogdW5zaWduZWQgaW50IGdldF9pbnNfbWVtX3dpZHRoKHVuc2lnbmVkIGxvbmcgaW5zX2FkZHIp
OwogdW5zaWduZWQgbG9uZyBnZXRfaW5zX3JlZ192YWwodW5zaWduZWQgbG9uZyBpbnNfYWRkciwg
c3RydWN0IHB0X3JlZ3MgKnJlZ3MpOwordm9pZCBzZXRfaW5zX3JlZ192YWwodW5zaWduZWQgbG9u
ZyBpbnNfYWRkciwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIHUzMiB2YWwpOwogdW5zaWduZWQgbG9u
ZyBnZXRfaW5zX2ltbV92YWwodW5zaWduZWQgbG9uZyBpbnNfYWRkcik7CiAKICNlbmRpZiAvKiBf
X1BGX0hfICovCg==
--bcaec520e52109e18f04a5db4c0f--
