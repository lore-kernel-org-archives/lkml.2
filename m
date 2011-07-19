Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1GSQiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:38:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58765 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSQiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:38:22 -0400
MIME-Version: 1.0
In-Reply-To: <4E258A11020000780004E39B@nat28.tlf.novell.com>
References: <4E258A11020000780004E39B@nat28.tlf.novell.com>
Date: Tue, 19 Jul 2011 09:38:20 -0700
X-Google-Sender-Auth: 0L6rYQF5tJ9xMBaqaP6yTk-3Vxg
Message-ID: <CAE9FiQWdaNY_bjXtDbsR88ZsYPGzsiT18wQTqjtrRXVF-fu1dw@mail.gmail.com>
Subject: Re: [PATCH] x86-64: make enabling of MMCFG on AMD Fam10 CPUs actually work
From: Yinghai Lu <yinghai@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf30780f305c1f7404a86ebe70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30780f305c1f7404a86ebe70
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2011 at 4:43 AM, Jan Beulich <JBeulich@novell.com> wrote:
> Forcibly enabling the MMCFG space on AMD Fam10 CPUs cannot be expected
> to work, since with the firmware not being aware of the address range
> used, it cannot possibly reserve the space in E820 or ACPI resources.
> Hence we need to manually insert the range into the E820 table, and
> enable the range only when the insertion actually works without
> conflict.
>
> Adding the calls to the respective E820 handling functions additionally
> requires to deal with modpost's mismatch checking: The function doing
> those calls needs to be __init, and it is being made sure that it gets
> called (from its __cpuinit caller) only on the BSP, and through a stub
> (silencing the warning).
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
>
> ---
> =A0arch/x86/kernel/mmconf-fam10h_64.c | =A0 22 +++++++++++++++++++---
> =A01 file changed, 19 insertions(+), 3 deletions(-)
>
> --- 3.0-rc7/arch/x86/kernel/mmconf-fam10h_64.c
> +++ 3.0-rc7-x86_64-mmcfg-fam10/arch/x86/kernel/mmconf-fam10h_64.c
> @@ -14,6 +14,7 @@
> =A0#include <asm/io.h>
> =A0#include <asm/msr.h>
> =A0#include <asm/acpi.h>
> +#include <asm/e820.h>
> =A0#include <asm/mmconfig.h>
> =A0#include <asm/pci_x86.h>
>
> @@ -49,7 +50,7 @@ static int __cpuinit cmp_range(const voi
> =A0/* need to avoid (0xfd<<32), (0xfe<<32), and (0xff<<32), ht used space=
 */
> =A0#define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
> =A0#define BASE_VALID(b) ((b) + MMCONF_SIZE <=3D (0xfdULL<<32) || (b) >=
=3D (1ULL<<40))
> -static void __cpuinit get_fam10h_pci_mmconf_base(void)
> +static void __init _get_fam10h_pci_mmconf_base(void)
> =A0{
> =A0 =A0 =A0 =A0int i;
> =A0 =A0 =A0 =A0unsigned bus;
> @@ -163,7 +164,21 @@ static void __cpuinit get_fam10h_pci_mmc
> =A0 =A0 =A0 =A0return;
>
> =A0out:
> - =A0 =A0 =A0 fam10h_pci_mmconf_base =3D base;
> + =A0 =A0 =A0 if(!e820_any_mapped(base, base + MMCONF_SIZE, 0)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 e820_add_region(base, MMCONF_SIZE, E820_RES=
ERVED);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 update_e820();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fam10h_pci_mmconf_base =3D base;
> + =A0 =A0 =A0 }
> +}
> +
> +/*
> + * Section-mismatch warning avoidance: This gets called from a ___cpuini=
t
> + * function (below), but only on the BSP, and needs to call the __init
> + * functions e820_add_region() and update_e820() (above).
> + */
> +static void __ref get_fam10h_pci_mmconf_base(void)
> +{
> + =A0 =A0 =A0 _get_fam10h_pci_mmconf_base();
> =A0}
>
> =A0void __cpuinit fam10h_check_enable_mmcfg(void)
> @@ -199,7 +214,8 @@ void __cpuinit fam10h_check_enable_mmcfg
> =A0 =A0 =A0 =A0 * if it is not enabled, try to enable it and assume only =
one segment
> =A0 =A0 =A0 =A0 * with 256 buses
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 get_fam10h_pci_mmconf_base();
> + =A0 =A0 =A0 if (!fam10h_pci_mmconf_base)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_fam10h_pci_mmconf_base();
> =A0 =A0 =A0 =A0if (!fam10h_pci_mmconf_base) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pci_probe &=3D ~PCI_CHECK_ENABLE_AMD_MMCON=
F;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
>
>

sent out some time ago...please check attached patch.

Maybe you can combine them together.

Thanks

Yinghai

--20cf30780f305c1f7404a86ebe70
Content-Type: text/x-patch; charset=US-ASCII; name="fix_amd_mmconf.patch"
Content-Disposition: attachment; filename="fix_amd_mmconf.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqb36pov0

U3ViamVjdDogW1BBVENIIC12Ml0geDg2L3BjaTogQWRkIG1tY29uZiByYW5nZSBpbnRvIGU4MjAg
Zm9yIHdoZW4gaXQgaXMgZnJvbSBNU1Igd2l0aCBhbWQgZmFtbDBoCgpmb3IgQU1EIEZhbTEwaCwg
aXQgd2UgcmVhZCBtbWNvbmYgZnJvbSBNU1IgZWFybHksIHdlIHNob3VsZCBqdXN0IHRydXN0IGl0
CmJlY2F1c2Ugd2UgY2hlY2sgaXQgYW5kIGNvcnJlY3QgaXQgYWxyZWFkeS4KCnNvIGFkZCBpdCB0
byBlODIwCgpBbHNvIGNvcnJlY3QgdGhlIGJhc2UgY2FsdWxhdGluZyB0byBtYWtlIGl0IHdvcmsg
YmVsb3cgNGcgY2FzZS4KCi12MjogcmVtb3ZlIHVucmVsYXRlZCBzb3J0X3JhbmdlIGNoYW5nZXMu
CiAgICAgYWxzbyBtYWtlIEZBTTEwSF9NTUlPX0NPTkZfQkFTRV9NQVNLIHRvIGJlIFVMTCBwb2lu
dGVkIGJ5IEphbi4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9y
Zz4KQ2M6IEphbiBCZXVsaWNoIDxqYmV1bGljaEBub3ZlbGwuY29tPgoKLS0tCiBhcmNoL3g4Ni9r
ZXJuZWwvbW1jb25mLWZhbTEwaF82NC5jIHwgICAxOCArKysrKysrKysrKysrKysrKysKIDEgZmls
ZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tl
cm5lbC9tbWNvbmYtZmFtMTBoXzY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJj
aC94ODYva2VybmVsL21tY29uZi1mYW0xMGhfNjQuYworKysgbGludXgtMi42L2FyY2gveDg2L2tl
cm5lbC9tbWNvbmYtZmFtMTBoXzY0LmMKQEAgLTE2LDYgKzE2LDcgQEAKICNpbmNsdWRlIDxhc20v
YWNwaS5oPgogI2luY2x1ZGUgPGFzbS9tbWNvbmZpZy5oPgogI2luY2x1ZGUgPGFzbS9wY2lfeDg2
Lmg+CisjaW5jbHVkZSA8YXNtL2U4MjAuaD4KIAogc3RydWN0IHBjaV9ob3N0YnJpZGdlX3Byb2Jl
IHsKIAl1MzIgYnVzOwpAQCAtMjYsNiArMjcsMjEgQEAgc3RydWN0IHBjaV9ob3N0YnJpZGdlX3By
b2JlIHsKIAogc3RhdGljIHU2NCBfX2NwdWluaXRkYXRhIGZhbTEwaF9wY2lfbW1jb25mX2Jhc2U7
CiAKKy8qIG9ubHkgb24gQlNQICovCitzdGF0aWMgdm9pZCBfX2luaXRfcmVmb2sgZTgyMF9hZGRf
bW1jb25mX3JhbmdlKGludCBidXNuYml0cykKK3sKKwl1NjQgZW5kOworCisJZW5kID0gZmFtMTBo
X3BjaV9tbWNvbmZfYmFzZSArICgxVUxMPDwoYnVzbmJpdHMgKyAyMCkpIC0gMTsKKwlpZiAoIWU4
MjBfYWxsX21hcHBlZChmYW0xMGhfcGNpX21tY29uZl9iYXNlLCBlbmQrMSwgRTgyMF9SRVNFUlZF
RCkpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIkZhbSAxMGggbW1jb25mIFslbGx4LCAlbGx4XVxu
IiwKKwkJCQkgZmFtMTBoX3BjaV9tbWNvbmZfYmFzZSwgZW5kKTsKKwkJZTgyMF9hZGRfcmVnaW9u
KGZhbTEwaF9wY2lfbW1jb25mX2Jhc2UsIDFVTEw8PChidXNuYml0cyArIDIwKSwKKwkJCQkgRTgy
MF9SRVNFUlZFRCk7CisJCXNhbml0aXplX2U4MjBfbWFwKCk7CisJfQorfQorCiBzdGF0aWMgc3Ry
dWN0IHBjaV9ob3N0YnJpZGdlX3Byb2JlIHBjaV9wcm9iZXNbXSBfX2NwdWluaXRkYXRhID0gewog
CXsgMCwgMHgxOCwgUENJX1ZFTkRPUl9JRF9BTUQsIDB4MTIwMCB9LAogCXsgMHhmZiwgMCwgUENJ
X1ZFTkRPUl9JRF9BTUQsIDB4MTIwMCB9LApAQCAtMTY0LDYgKzE4MCw3IEBAIHN0YXRpYyB2b2lk
IF9fY3B1aW5pdCBnZXRfZmFtMTBoX3BjaV9tbWMKIAogb3V0OgogCWZhbTEwaF9wY2lfbW1jb25m
X2Jhc2UgPSBiYXNlOworCWU4MjBfYWRkX21tY29uZl9yYW5nZSg4KTsKIH0KIAogdm9pZCBfX2Nw
dWluaXQgZmFtMTBoX2NoZWNrX2VuYWJsZV9tbWNmZyh2b2lkKQpAQCAtMTg5LDYgKzIwNiw3IEBA
IHZvaWQgX19jcHVpbml0IGZhbTEwaF9jaGVja19lbmFibGVfbW1jZmcKIAogCQkJaWYgKCFmYW0x
MGhfcGNpX21tY29uZl9iYXNlKSB7CiAJCQkJZmFtMTBoX3BjaV9tbWNvbmZfYmFzZSA9IGJhc2U7
CisJCQkJZTgyMF9hZGRfbW1jb25mX3JhbmdlKGJ1c25iaXRzKTsKIAkJCQlyZXR1cm47CiAJCQl9
IGVsc2UgaWYgKGZhbTEwaF9wY2lfbW1jb25mX2Jhc2UgPT0gIGJhc2UpCiAJCQkJcmV0dXJuOwo=
--20cf30780f305c1f7404a86ebe70--
