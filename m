Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1BFHCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 02:02:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60409 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1BFHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 02:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tErj0FRxGM+TBEykxo6GwjSBUQUfE22c/TSHXE9WzN5fU+EZnxJo0lkiEihmKBgUvC
         YtnpAXDuu4zAKe9uyIHVOo9xwnNpQnC3oGV/S7KNukjn7VyUmj2EcghEzIz2noCEZqZt
         MUIlQUtxTwYO42n0j653Bcehkemd3TFRg3VZs=
MIME-Version: 1.0
In-Reply-To: <4D4CA568.70907@goop.org>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
	<4D4A3782.3050702@zytor.com>
	<alpine.DEB.2.00.1102031114030.7277@kaball-desktop>
	<4D4ADFAD.7060507@zytor.com>
	<alpine.DEB.2.00.1102041130060.7277@kaball-desktop>
	<4D4CA568.70907@goop.org>
Date: Sat, 5 Feb 2011 23:02:43 -0800
X-Google-Sender-Auth: pdB_csgrHGWXQ2J5CdvF-RrcZgc
Message-ID: <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
From: Yinghai Lu <yinghai@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: multipart/mixed; boundary=90e6ba53a538af8b58049b97b381
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba53a538af8b58049b97b381
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 4, 2011 at 5:18 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote=
:
> On 02/04/2011 03:35 AM, Stefano Stabellini wrote:
>> On Thu, 3 Feb 2011, H. Peter Anvin wrote:
>>> On 02/03/2011 03:25 AM, Stefano Stabellini wrote:
>>>>> How on Earth would you end up with a reserved region *inside the BRK*=
?
>>>> I think in practice you cannot, but you can have reserved regions at
>>>> _end, that is the main problem I am trying to solve.
>>>> If we have a reserved region at _end and _end is not PMD aligned, then
>>>> we have a problem.
>>>>
>>>> I thought that checking for reserved regions before destroying the
>>>> mapping would be a decent solution (because it wouldn't affect the
>>>> normal case); so I ended up checking between _brk_end and _end too.
>>>>
>>>> Other alternative solutions I thought about but that I discarded becau=
se
>>>> they also affect the normal case are:
>>>>
>>>> - never destroy mappings that could go over _end;
>>>> - always PMD align _end.
>>>>
>>>> If none of the above are acceptable, I welcome other suggestions :-)
>>>>
>>> Sounds like the code does the right thing, but the description needs to
>>> be improved.
>>>
>> I tried to improve both the commit message and the comments within the
>> code, this is the result:
>>
>>
>> commit d0136be7b48953f27202dbde285a7379d06cfe98
>> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Date: =A0 Tue Jan 25 12:05:11 2011 +0000
>>
>> =A0 =A0 x86/mm/init: respect memblock reserved regions when destroying m=
appings
>>
>> =A0 =A0 In init_memory_mapping we destroy the mappings between _brk_end =
and
>> =A0 =A0 _end, but if _end is not PMD aligned we also destroy mappings fo=
r
>> =A0 =A0 potentially reserved regions between _end and the following PMD.
>>
>> =A0 =A0 In order to avoid this problem, before clearing any PMDs we chec=
k if the
>> =A0 =A0 corresponding memory area has been reserved and we only destroy =
the
>> =A0 =A0 mapping if hasn't.
>>
>> =A0 =A0 We found this issue because under Xen we have a valid mapping at=
 _end,
>> =A0 =A0 and if _end is not PMD aligned the current code destroys the ini=
tial
>> =A0 =A0 part of it.
>
> This description makes more sense, even if the code does exactly the
> same thing.
>
>>
>> =A0 =A0 In practice this fix does not have any impact on native.
>>
>> =A0 =A0 Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.=
com>
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 947f42a..65c34f4 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -283,6 +283,8 @@ unsigned long __init_refok init_memory_mapping(unsig=
ned long start,
>> =A0 =A0 =A0 if (!after_bootmem && !start) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pud_t *pud;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pmd_t *pmd;
>> + =A0 =A0 =A0 =A0 =A0 =A0 unsigned long addr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 u64 size, memblock_addr;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mmu_cr4_features =3D read_cr4();
>>
>> @@ -291,11 +293,22 @@ unsigned long __init_refok init_memory_mapping(uns=
igned long start,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* located on different 2M pages. cleanup_=
highmap(), however,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* can only consider _end when it runs, so=
 destroy any
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* mappings beyond _brk_end here.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* If _end is not PMD aligned, we also destr=
oy the mapping of
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* the memory area between _end the next PMD=
, so before clearing
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* the PMD we make sure that the correspondi=
ng memory region has
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* not been reserved.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pud =3D pud_offset(pgd_offset_k(_brk_end), _=
brk_end);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pmd =3D pmd_offset(pud, _brk_end - 1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 while (++pmd <=3D pmd_offset(pud, (unsigned lo=
ng)_end - 1))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pmd_clear(pmd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 addr =3D (_brk_end + PMD_SIZE - 1) & PMD_MASK;
>
> I guess its OK if this is >_end, because the pmd offset will be greater
> than _end's. =A0But is there an edge condition if the pmd_offset goes off
> the end of the pud, and pud page itself happens to be at the end of the
> address space and it wraps?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 while (++pmd <=3D pmd_offset(pud, (unsigned lo=
ng)_end - 1)) {
> Could _end be in a different pud from _brk_end? =A0Could this walk off th=
e
> pud page?
>
> Or is it moot, and there's a guarantee that the whole space is mapped
> out of the same pud page? =A0I guess the original code has the same
> concern, so this patch leaves the status quo unchanged.
>
> =A0 =A0J
>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memblock_addr =3D memblock_x86=
_find_in_range_size(__pa(addr),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &size, PMD_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memblock_addr =3D=3D (u64)=
 __pa(addr) && size >=3D PMD_SIZE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pmd_clear(pmd)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr +=3D PMD_SIZE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> =A0#endif
>> =A0 =A0 =A0 __flush_tlb_all();

why not just move calling cleanup_highmap down?

something like attached patch.

--90e6ba53a538af8b58049b97b381
Content-Type: text/x-patch; charset=US-ASCII; name="fix_cleanup_highmap.patch"
Content-Disposition: attachment; filename="fix_cleanup_highmap.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjtlu4g60

LS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlXzY0LmggfCAgICAyICstCiBhcmNoL3g4
Ni9rZXJuZWwvaGVhZDY0LmMgICAgICAgICAgfCAgICAzIC0tLQogYXJjaC94ODYva2VybmVsL3Nl
dHVwLmMgICAgICAgICAgIHwgICAgNiArKysrKysKIGFyY2gveDg2L21tL2luaXQuYyAgICAgICAg
ICAgICAgICB8ICAgMTkgLS0tLS0tLS0tLS0tLS0tLS0tLQogYXJjaC94ODYvbW0vaW5pdF82NC5j
ICAgICAgICAgICAgIHwgICAgNSArKystLQogNSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25z
KCspLCAyNSBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvaW5jbHVkZS9h
c20vcGd0YWJsZV82NC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3BndGFibGVfNjQuaAorKysgbGludXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNt
L3BndGFibGVfNjQuaApAQCAtMTY1LDcgKzE2NSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IHBnZF9s
YXJnZShwZ2RfdCBwZ2QpIHsKICNkZWZpbmUgX19zd3BfZW50cnlfdG9fcHRlKHgpCQkoKHB0ZV90
KSB7IC5wdGUgPSAoeCkudmFsIH0pCiAKIGV4dGVybiBpbnQga2Vybl9hZGRyX3ZhbGlkKHVuc2ln
bmVkIGxvbmcgYWRkcik7Ci1leHRlcm4gdm9pZCBjbGVhbnVwX2hpZ2htYXAodm9pZCk7CitleHRl
cm4gdm9pZCBjbGVhbnVwX2hpZ2htYXAodW5zaWduZWQgbG9uZyBlbmQpOwogCiAjZGVmaW5lIEhB
VkVfQVJDSF9VTk1BUFBFRF9BUkVBCiAjZGVmaW5lIEhBVkVfQVJDSF9VTk1BUFBFRF9BUkVBX1RP
UERPV04KSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCisrKyBsaW51eC0y
LjYvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCkBAIC03Nyw5ICs3Nyw2IEBAIHZvaWQgX19pbml0
IHg4Nl82NF9zdGFydF9rZXJuZWwoY2hhciAqIHIKIAkvKiBNYWtlIE5VTEwgcG9pbnRlcnMgc2Vn
ZmF1bHQgKi8KIAl6YXBfaWRlbnRpdHlfbWFwcGluZ3MoKTsKIAotCS8qIENsZWFudXAgdGhlIG92
ZXIgbWFwcGVkIGhpZ2ggYWxpYXMgKi8KLQljbGVhbnVwX2hpZ2htYXAoKTsKLQogCW1heF9wZm5f
bWFwcGVkID0gS0VSTkVMX0lNQUdFX1NJWkUgPj4gUEFHRV9TSElGVDsKIAogCWZvciAoaSA9IDA7
IGkgPCBOVU1fRVhDRVBUSU9OX1ZFQ1RPUlM7IGkrKykgewpJbmRleDogbGludXgtMi42L2FyY2gv
eDg2L2tlcm5lbC9zZXR1cC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2
L2tlcm5lbC9zZXR1cC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAg
LTI5Nyw2ICsyOTcsOSBAQCBzdGF0aWMgdm9pZCBfX2luaXQgaW5pdF9nYnBhZ2VzKHZvaWQpCiBz
dGF0aWMgaW5saW5lIHZvaWQgaW5pdF9nYnBhZ2VzKHZvaWQpCiB7CiB9CitzdGF0aWMgdm9pZCBf
X2luaXQgY2xlYW51cF9oaWdobWFwKHVuc2lnbmVkIGxvbmcgZW5kKQoreworfQogI2VuZGlmCiAK
IHN0YXRpYyB2b2lkIF9faW5pdCByZXNlcnZlX2Jyayh2b2lkKQpAQCAtOTIyLDYgKzkyNSw5IEBA
IHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAkgKi8KIAlyZXNlcnZl
X2JyaygpOwogCisJLyogQ2xlYW51cCB0aGUgb3ZlciBtYXBwZWQgaGlnaCBhbGlhcyBhZnRlciBf
YnJrX2VuZCovCisJY2xlYW51cF9oaWdobWFwKF9icmtfZW5kKTsKKwogCW1lbWJsb2NrLmN1cnJl
bnRfbGltaXQgPSBnZXRfbWF4X21hcHBlZCgpOwogCW1lbWJsb2NrX3g4Nl9maWxsKCk7CiAKSW5k
ZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0LmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
Lm9yaWcvYXJjaC94ODYvbW0vaW5pdC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdC5j
CkBAIC0yNzksMjUgKzI3OSw2IEBAIHVuc2lnbmVkIGxvbmcgX19pbml0X3JlZm9rIGluaXRfbWVt
b3J5X20KIAlsb2FkX2NyMyhzd2FwcGVyX3BnX2Rpcik7CiAjZW5kaWYKIAotI2lmZGVmIENPTkZJ
R19YODZfNjQKLQlpZiAoIWFmdGVyX2Jvb3RtZW0gJiYgIXN0YXJ0KSB7Ci0JCXB1ZF90ICpwdWQ7
Ci0JCXBtZF90ICpwbWQ7Ci0KLQkJbW11X2NyNF9mZWF0dXJlcyA9IHJlYWRfY3I0KCk7Ci0KLQkJ
LyoKLQkJICogX2Jya19lbmQgY2Fubm90IGNoYW5nZSBhbnltb3JlLCBidXQgaXQgYW5kIF9lbmQg
bWF5IGJlCi0JCSAqIGxvY2F0ZWQgb24gZGlmZmVyZW50IDJNIHBhZ2VzLiBjbGVhbnVwX2hpZ2ht
YXAoKSwgaG93ZXZlciwKLQkJICogY2FuIG9ubHkgY29uc2lkZXIgX2VuZCB3aGVuIGl0IHJ1bnMs
IHNvIGRlc3Ryb3kgYW55Ci0JCSAqIG1hcHBpbmdzIGJleW9uZCBfYnJrX2VuZCBoZXJlLgotCQkg
Ki8KLQkJcHVkID0gcHVkX29mZnNldChwZ2Rfb2Zmc2V0X2soX2Jya19lbmQpLCBfYnJrX2VuZCk7
Ci0JCXBtZCA9IHBtZF9vZmZzZXQocHVkLCBfYnJrX2VuZCAtIDEpOwotCQl3aGlsZSAoKytwbWQg
PD0gcG1kX29mZnNldChwdWQsICh1bnNpZ25lZCBsb25nKV9lbmQgLSAxKSkKLQkJCXBtZF9jbGVh
cihwbWQpOwotCX0KLSNlbmRpZgogCV9fZmx1c2hfdGxiX2FsbCgpOwogCiAJaWYgKCFhZnRlcl9i
b290bWVtICYmIGU4MjBfdGFibGVfZW5kID4gZTgyMF90YWJsZV9zdGFydCkKSW5kZXg6IGxpbnV4
LTIuNi9hcmNoL3g4Ni9tbS9pbml0XzY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcv
YXJjaC94ODYvbW0vaW5pdF82NC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdF82NC5j
CkBAIC0yOTcsMTMgKzI5NywxNCBAQCB2b2lkIF9faW5pdCBpbml0X2V4dHJhX21hcHBpbmdfdWMo
dW5zaWduCiAgKiByb3VuZGVkIHVwIHRvIHRoZSAyTUIgYm91bmRhcnkuIFRoaXMgY2F0Y2hlcyB0
aGUgaW52YWxpZCBwbWRzIGFzCiAgKiB3ZWxsLCBhcyB0aGV5IGFyZSBsb2NhdGVkIGJlZm9yZSBf
dGV4dDoKICAqLwotdm9pZCBfX2luaXQgY2xlYW51cF9oaWdobWFwKHZvaWQpCit2b2lkIF9faW5p
dCBjbGVhbnVwX2hpZ2htYXAodW5zaWduZWQgbG9uZyBlbmQpCiB7CiAJdW5zaWduZWQgbG9uZyB2
YWRkciA9IF9fU1RBUlRfS0VSTkVMX21hcDsKLQl1bnNpZ25lZCBsb25nIGVuZCA9IHJvdW5kdXAo
KHVuc2lnbmVkIGxvbmcpX2VuZCwgUE1EX1NJWkUpIC0gMTsKIAlwbWRfdCAqcG1kID0gbGV2ZWwy
X2tlcm5lbF9wZ3Q7CiAJcG1kX3QgKmxhc3RfcG1kID0gcG1kICsgUFRSU19QRVJfUE1EOwogCisJ
ZW5kID0gcm91bmR1cChlbmQsIFBNRF9TSVpFKSAtIDE7CisKIAlmb3IgKDsgcG1kIDwgbGFzdF9w
bWQ7IHBtZCsrLCB2YWRkciArPSBQTURfU0laRSkgewogCQlpZiAocG1kX25vbmUoKnBtZCkpCiAJ
CQljb250aW51ZTsK
--90e6ba53a538af8b58049b97b381--
