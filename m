Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab2EYUTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:19:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33909 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab2EYUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120525193716.GA8817@google.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	<CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	<20120525193716.GA8817@google.com>
Date: Fri, 25 May 2012 13:19:46 -0700
X-Google-Sender-Auth: ONFRlL1uTbWjSlcvcW5z1GXJ34U
Message-ID: <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b2ee03ff64db504c0e216b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2ee03ff64db504c0e216b4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, May 25, 2012 at 12:37 PM, Bjorn Helgaas <bhelgaas@google.com> wrote=
:
> On Fri, May 25, 2012 at 11:39:26AM -0700, Yinghai Lu wrote:
>> On Fri, May 25, 2012 at 10:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> >> I don't really like the dependency on PCIBIOS_MAX_MEM_32 + 1ULL
>> >> overflowing to zero -- that means the reader has to know what the
>> >> value of PCIBIOS_MAX_MEM_32 is, and things would break in non-obvious
>> >> ways if we changed it.
>> >>
>>
>> please check if attached one is more clear.
>>
>> make max and bottom is only related to _MEM and not default one.
>>
>> - =A0 =A0 =A0 if (!(res->flags & IORESOURCE_MEM_64))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 max =3D PCIBIOS_MAX_MEM_32;
>> + =A0 =A0 =A0 if (res->flags & IORESOURCE_MEM) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(res->flags & IORESOURCE_MEM_64))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max =3D PCIBIOS_MAX_MEM_32=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (PCIBIOS_MAX_MEM_32 !=3D -1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bottom =3D (resource_size_=
t)(1ULL<<32);
>> + =A0 =A0 =A0 }
>>
>> will still not affect to other arches.
>
> That's goofy. =A0You're proposing to make only x86_64 and x86-PAE try to =
put
> 64-bit BARs above 4GB. =A0Why should this be specific to x86? =A0I acknow=
ledge
> that there's risk in doing this, but if it's a good idea for x86_64, it
> should also be a good idea for other 64-bit architectures.
>
> And testing for "is this x86_32 without PAE?" with
> "PCIBIOS_MAX_MEM_32 =3D=3D -1" is just plain obtuse and hides an
> important bit of arch-specific behavior.
>
> Tangential question about allocate_resource(): =A0Is its "max" argument
> really necessary? =A0We'll obviously only allocate from inside the root
> resource, so "max" is just a way to artificially avoid the end of
> that resource. =A0Is there really a case where that's required?
>
> "min" makes sense because in a case like this, it's valid to allocate fro=
m
> anywhere in the root resource, but we want to try to allocate from the >4=
GB
> part first, then fall back to allocating from the whole resource. =A0I'm =
not
> sure there's a corresponding case for "max."
>
> Getting back to this patch, I don't think we should need to adjust "max" =
at
> all. =A0For example, this:
>
> commit cb1c8e46244cfd84a1a2fe91be860a74c1cf4e25
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date: =A0 Thu May 24 22:15:26 2012 -0600
>
> =A0 =A0PCI: try to allocate 64-bit mem resources above 4GB
>
> =A0 =A0If we have a 64-bit mem resource, try to allocate it above 4GB fir=
st. =A0If
> =A0 =A0that fails, we'll fall back to allocating space below 4GB.
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 4ce5ef2..075e5b1 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -121,14 +121,16 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct =
resource *res,
> =A0{
> =A0 =A0 =A0 =A0int i, ret =3D -ENOMEM;
> =A0 =A0 =A0 =A0struct resource *r;
> - =A0 =A0 =A0 resource_size_t max =3D -1;
> + =A0 =A0 =A0 resource_size_t start =3D 0;
> + =A0 =A0 =A0 resource_size_t end =3D MAX_RESOURCE;

yeah, MAX_RESOURCE is better than -1.

>
> =A0 =A0 =A0 =A0type_mask |=3D IORESOURCE_IO | IORESOURCE_MEM;
>
> - =A0 =A0 =A0 /* don't allocate too high if the pref mem doesn't support =
64bit*/
> - =A0 =A0 =A0 if (!(res->flags & IORESOURCE_MEM_64))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 max =3D PCIBIOS_MAX_MEM_32;

can not remove this one.
otherwise will could allocate above 4g range to non MEM64 resource.


> + =A0 =A0 =A0 /* If this is a 64-bit mem resource, try above 4GB first */
> + =A0 =A0 =A0 if (res->flags & IORESOURCE_MEM_64)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D (resource_size_t) (1ULL << 32);

could affect other arches. let's see if other arches is ok.

please check merged version.

also we have

include/linux/range.h:#define MAX_RESOURCE ((resource_size_t)~0)
arch/x86/kernel/e820.c:#define MAX_RESOURCE_SIZE ((resource_size_t)-1)

we should merge them later?

Thanks

Yinghai

--047d7b2ee03ff64db504c0e216b4
Content-Type: application/octet-stream; 
	name="allocate_high_at_first_v3.patch"
Content-Disposition: attachment; filename="allocate_high_at_first_v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2nozh280

U3ViamVjdDogW1BBVENIXSBQQ0k6IFRyeSB0byBhbGxvY2F0ZSBtZW02NCBhYm92ZSA0RyBhdCBm
aXJzdAoKYW5kIHdpbGwgZmFsbCBiYWNrIHRvIGJlbG93IDRnIGlmIGl0IGNhbiBub3QgZmluZCBh
bnkgYWJvdmUgNGcuCgpvbmx5IHg4NiBoYXZlIFBDSUJJT1NfTUFYX01FTV8zMiBzZXQgdG8gMHhm
ZmZmZmZmZi4KaXQgd2lsbCBvbmx5IGFmZmVjdCB4ODZfNjQgYW5kIDMyYml0IHdpdGggcmVzb3Vy
Y2Vfc2l6ZV90IDY0Yml0IHN1cHBvcnQuCm9ubHkgdGhhdCBjYXNlIGJvdHRvbSBpcyBzZXQgdG8g
NGcgZm9yIGZpcnN0IHRyeS4KCng4NiAzMmJpdCB3aXRob3V0IFg4Nl9QQUUgc3VwcG9ydCB3aWxs
IGhhdmUgYm90dG9tIHNldCB0byAwLCBiZWN1YXNlCnJlc291cmNlX3NpemVfdCBpcyAzMmJpdC4K
CkFsc28gZm9yIDMyYml0IHdpdGggcmVzb3VyY2Vfc2l6ZV90IDY0Yml0IGtlcm5lbCBvbiBtYWNo
aW5lIHdpdGggcGFlIHN1cHBvcnQKd2UgYXJlIHNhZmUgYmVjYXVzZSBpb21lbV9yZXNvdXJjZSBp
cyBsaW1pdGVkIHRvIDMyYml0IGFjY29yZGluZyB0bwp4ODZfcGh5c19iaXRzLgoKLXYyOiB1cGRh
dGUgYm90dG9tIGFzc2lnbmluZyB0byBtYWtlIGl0IGNsZWFyIGZvciBub24tcGFlIHN1cHBvcnQg
bWFjaGluZS4KLXYzOiBCam9ybidzIGNoYW5nZToKCXVzZSBNQVhfUkVPVVJDRSBpbnN0ZWFkIG9m
IC0xCgl1c2Ugc3RhcnQvZW5kIGluc3RlYWQgb2YgYm90dG9tL21heAoJZm9yIGFsbCBhcmNoIGlu
c3RlYWQgb2YganVzdCB4ODZfNjQKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlA
a2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9wY2kvYnVzLmMgfCAgIDI5ICsrKysrKysrKysrKysr
KysrKysrKystLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgNyBkZWxl
dGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9wY2kvYnVzLmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvYnVzLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJz
L3BjaS9idXMuYwpAQCAtMTIxLDE0ICsxMjEsMjMgQEAgcGNpX2J1c19hbGxvY19yZXNvdXJjZShz
dHJ1Y3QgcGNpX2J1cyAqYgogewogCWludCBpLCByZXQgPSAtRU5PTUVNOwogCXN0cnVjdCByZXNv
dXJjZSAqcjsKLQlyZXNvdXJjZV9zaXplX3QgbWF4ID0gLTE7CisJcmVzb3VyY2Vfc2l6ZV90IGVu
ZCA9IE1BWF9SRVNPVVJDRTsKKwlyZXNvdXJjZV9zaXplX3Qgc3RhcnQgPSAwOwogCiAJdHlwZV9t
YXNrIHw9IElPUkVTT1VSQ0VfSU8gfCBJT1JFU09VUkNFX01FTTsKIAotCS8qIGRvbid0IGFsbG9j
YXRlIHRvbyBoaWdoIGlmIHRoZSBwcmVmIG1lbSBkb2Vzbid0IHN1cHBvcnQgNjRiaXQqLwotCWlm
ICghKHJlcy0+ZmxhZ3MgJiBJT1JFU09VUkNFX01FTV82NCkpCi0JCW1heCA9IFBDSUJJT1NfTUFY
X01FTV8zMjsKKwkvKgorCSAqIGRvbid0IGFsbG9jYXRlIHRvbyBoaWdoIGlmIHRoZSBwcmVmIG1l
bSBkb2Vzbid0IHN1cHBvcnQgNjRiaXQKKwkgKiBhbHNvIGlmIHRoaXMgaXMgYSA2NC1iaXQgbWVt
IHJlc291cmNlLCB0cnkgYWJvdmUgNEdCIGZpcnN0CisJICovCisJaWYgKHJlcy0+ZmxhZ3MgJiBJ
T1JFU09VUkNFX01FTSkgeworCQlpZiAoIShyZXMtPmZsYWdzICYgSU9SRVNPVVJDRV9NRU1fNjQp
KQorCQkJZW5kID0gUENJQklPU19NQVhfTUVNXzMyOworCQllbHNlCisJCQlzdGFydCA9IChyZXNv
dXJjZV9zaXplX3QpKDFVTEw8PDMyKTsKKwl9CiAKK2FnYWluOgogCXBjaV9idXNfZm9yX2VhY2hf
cmVzb3VyY2UoYnVzLCByLCBpKSB7CiAJCWlmICghcikKIAkJCWNvbnRpbnVlOwpAQCAtMTQ1LDEy
ICsxNTQsMTggQEAgcGNpX2J1c19hbGxvY19yZXNvdXJjZShzdHJ1Y3QgcGNpX2J1cyAqYgogCiAJ
CS8qIE9rLCB0cnkgaXQgb3V0Li4gKi8KIAkJcmV0ID0gYWxsb2NhdGVfcmVzb3VyY2UociwgcmVz
LCBzaXplLAotCQkJCQlyLT5zdGFydCA/IDogbWluLAotCQkJCQltYXgsIGFsaWduLAorCQkJCQlt
YXgoc3RhcnQsIHItPnN0YXJ0ID8gOiBtaW4pLAorCQkJCQllbmQsIGFsaWduLAogCQkJCQlhbGln
bmYsIGFsaWduZl9kYXRhKTsKIAkJaWYgKHJldCA9PSAwKQotCQkJYnJlYWs7CisJCQlyZXR1cm4g
MDsKKwl9CisKKwlpZiAoc3RhcnQgIT0gMCkgeworCQlzdGFydCA9IDA7CisJCWdvdG8gYWdhaW47
CiAJfQorCiAJcmV0dXJuIHJldDsKIH0KIAo=
--047d7b2ee03ff64db504c0e216b4--
