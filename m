Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0I3T7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:59:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35975 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab0I3T7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wNx9AKurMP/kaxf4o1EKlypl1fLsitckHIsNOqTpnPC/8Ij5nP6pRwa4CJEW1XKOSs
         h6Ztxm95fagSoAOmIcHlZSMTDxqRFXuZ3HkcNsw/N62bnKQAt3PQ9u8FWVuGFJ9qid7G
         f0s+2sRV412fvLgyA0EtzlV220QCtD3KBJ98g=
MIME-Version: 1.0
In-Reply-To: <1285875804.2180.1.camel@cowboy>
References: <1285875804.2180.1.camel@cowboy>
Date: Thu, 30 Sep 2010 22:59:51 +0300
X-Google-Sender-Auth: Mo7K5wjL8uloOysxov-0mtMNy78
Message-ID: <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in pcc_cpufreq_do_osc
From: Pekka Enberg <penberg@kernel.org>
To: dave@gnu.org
Cc: davej@redhat.com, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Content-Type: multipart/mixed; boundary=001636284d1c63a84c04917f85ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636284d1c63a84c04917f85ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2010 at 10:43 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> x86, cpufreq: avoid an unnecessary double free when finished in pcc_cpufr=
eq_do_osc()
>
> There is no need to fall through the out_free label thus saving a kfree c=
all.
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
> =A0arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/=
cpu/cpufreq/pcc-cpufreq.c
> index 994230d..db7dc35 100644
> --- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> @@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *han=
dle)
> =A0 =A0 =A0 =A0if (!(supported & 0x1))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENODEV;
>
> + =A0 =A0 =A0 return ret;
> +
> =A0out_free:
> =A0 =A0 =A0 =A0kfree(output.pointer);
> =A0 =A0 =A0 =A0return ret;

Where is the double free here? I can't see it. I do see memory leaks
happening in error handling paths of pcc_cpufreq_do_osc() which makes
me think we need something like the attached patch.

--001636284d1c63a84c04917f85ee
Content-Type: application/octet-stream; 
	name="0001-x86-cpufreq-Fix-pcc_cpufreq_do_osc-memory-leaks.patch"
Content-Disposition: attachment; 
	filename="0001-x86-cpufreq-Fix-pcc_cpufreq_do_osc-memory-leaks.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_geq1tzig0

RnJvbSA4YjE4YTUxMDc3YzllNWIzNmQ1NGE1ZTQ1ZjkwNThlYjNhYWUyNDc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQZWtrYSBFbmJlcmcgPHBlbmJlcmdAY3MuaGVsc2lua2kuZmk+
CkRhdGU6IFRodSwgMzAgU2VwIDIwMTAgMjI6NTc6MzMgKzAzMDAKU3ViamVjdDogW1BBVENIXSB4
ODYsIGNwdWZyZXE6IEZpeCBwY2NfY3B1ZnJlcV9kb19vc2MoKSBtZW1vcnkgbGVha3MKCklmIGFj
cGlfZXZhbHVhdGVfb2JqZWN0KCkgZnVuY3Rpb24gY2FsbCBkb2Vzbid0IGZhaWwsIHdlIG11c3Qg
a2ZyZWUoKQpvdXRwdXQuYnVmZmVyIGJlZm9yZSByZXR1cm5pbmcgZnJvbSBwY2NfY3B1ZnJlcV9k
b19vc2MoKS4KClNpZ25lZC1vZmYtYnk6IFBla2thIEVuYmVyZyA8cGVuYmVyZ0Bjcy5oZWxzaW5r
aS5maT4KLS0tCiBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NwdWZyZXEvcGNjLWNwdWZyZXEuYyB8ICAg
MTggKysrKysrKysrKysrLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyks
IDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9jcHVmcmVx
L3BjYy1jcHVmcmVxLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NwdWZyZXEvcGNjLWNwdWZyZXEu
YwppbmRleCA5OTQyMzBkLi40ZjZmNjc5IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2NwdWZyZXEvcGNjLWNwdWZyZXEuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NwdWZyZXEv
cGNjLWNwdWZyZXEuYwpAQCAtMzY4LDE2ICszNjgsMjIgQEAgc3RhdGljIGludCBfX2luaXQgcGNj
X2NwdWZyZXFfZG9fb3NjKGFjcGlfaGFuZGxlICpoYW5kbGUpCiAJCXJldHVybiAtRU5PREVWOwog
CiAJb3V0X29iaiA9IG91dHB1dC5wb2ludGVyOwotCWlmIChvdXRfb2JqLT50eXBlICE9IEFDUElf
VFlQRV9CVUZGRVIpCi0JCXJldHVybiAtRU5PREVWOworCWlmIChvdXRfb2JqLT50eXBlICE9IEFD
UElfVFlQRV9CVUZGRVIpIHsKKwkJcmV0ID0gLUVOT0RFVjsKKwkJZ290byBvdXRfZnJlZTsKKwl9
CiAKIAllcnJvcnMgPSAqKCh1MzIgKilvdXRfb2JqLT5idWZmZXIucG9pbnRlcikgJiB+KDEgPDwg
MCk7Ci0JaWYgKGVycm9ycykKLQkJcmV0dXJuIC1FTk9ERVY7CisJaWYgKGVycm9ycykgeworCQly
ZXQgPSAtRU5PREVWOworCQlnb3RvIG91dF9mcmVlOworCX0KIAogCXN1cHBvcnRlZCA9ICooKHUz
MiAqKShvdXRfb2JqLT5idWZmZXIucG9pbnRlciArIDQpKTsKLQlpZiAoIShzdXBwb3J0ZWQgJiAw
eDEpKQotCQlyZXR1cm4gLUVOT0RFVjsKKwlpZiAoIShzdXBwb3J0ZWQgJiAweDEpKSB7CisJCXJl
dCA9IC1FTk9ERVY7CisJCWdvdG8gb3V0X2ZyZWU7CisJfQogCiBvdXRfZnJlZToKIAlrZnJlZShv
dXRwdXQucG9pbnRlcik7Ci0tIAoxLjUuNi40Cgo=
--001636284d1c63a84c04917f85ee--
