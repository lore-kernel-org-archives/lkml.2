Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2LUWWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:22:14 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:43347 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2LUWWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:22:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUu6mvTZ7ONsEeCx8OOocKkCEkC2-OmwdWyjHAJ4=gVHQ@mail.gmail.com>
References: <20121221030018.GA15032@www.outflux.net>
	<50D3E91C.9060907@zytor.com>
	<CAE9FiQVNeQqXktmaG0XOJwSxFEVrGKA9j6UDN2N_aDDp-8y_fA@mail.gmail.com>
	<50D495FD.8060103@zytor.com>
	<CAE9FiQXcXn0xr_ACt4fS_=xWtXR8zGoYfpSzFKG4nEvKF=sGdQ@mail.gmail.com>
	<50D49E0A.1080609@zytor.com>
	<CAE9FiQUu6mvTZ7ONsEeCx8OOocKkCEkC2-OmwdWyjHAJ4=gVHQ@mail.gmail.com>
Date: Fri, 21 Dec 2012 14:22:10 -0800
X-Google-Sender-Auth: 9yqBivVxrPXTcKj1146iAKNdJYM
Message-ID: <CAE9FiQWWNhD5ttoiqmHoG0hrYu2NLO1T+DVN7cac2AG4iE+2og@mail.gmail.com>
Subject: Re: [RFC] stack and heap are executable on x86_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: multipart/mixed; boundary=00151747bd5459bb0104d16447c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151747bd5459bb0104d16447c4
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Dec 21, 2012 at 1:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Dec 21, 2012 at 9:36 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> We should NEVER have RW + x at the same time (at least when the kernel
>> is compiled properly.)  Looks like your patch does get rid of a bunch of
>> stuff in the low mapping -- although the low mapping really should never
>> be +x at all -- but there are still problems with the high mapping
>
> after enabling CONFIG_DEBUG_RODATA
>
> get
> ---[ High Kernel Mapping ]---
> 0xffffffff80000000-0xffffffff81000000          16M                           pmd
> 0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
> 0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
> 0xffffffff82c00000-0xffffffff82dc9000        1828K     RW             GLB x  pte
> 0xffffffff82dc9000-0xffffffff82e00000         220K     RW             GLB NX pte
> 0xffffffff82e00000-0xffffffff83000000           2M     RW         PSE GLB NX pmd
> 0xffffffff83000000-0xffffffff8313a000        1256K     RW             GLB NX pte
> 0xffffffff8313a000-0xffffffff83200000         792K     RW             GLB x  pte
> 0xffffffff83200000-0xffffffff83e00000          12M     RW         PSE GLB x  pmd
> 0xffffffff83e00000-0xffffffffa0000000         450M                           pmd
>
> for
> [    0.000000] Kernel Layout:
> [    0.000000]   .text: [0x01000000-0x021434f8]
> [    0.000000] .rodata: [0x02200000-0x02a13fff]
> [    0.000000]   .data: [0x02c00000-0x02dc763f]
> [    0.000000]   .init: [0x02dc9000-0x0312cfff]
> [    0.000000]    .bss: [0x0313b000-0x03dd6fff]
> [    0.000000]    .brk: [0x03dd7000-0x03dfffff]
>
> looks like .data, .bss, .brk should not have x set.

please check attached patch that set NX for data/bss/brk with 64bit.

Thanks

Yinghai

--00151747bd5459bb0104d16447c4
Content-Type: application/octet-stream; name="no_x_for_data_bss_brk.patch"
Content-Disposition: attachment; filename="no_x_for_data_bss_brk.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hazvwto80

U3ViamVjdDogW1BBVENIXSB4ODYsIDY0Yml0LCBtbTogTWFyayBkYXRhL2Jzcy9icmsgdG8gbngK
CkhQQSBzYWlkLCB3ZSBzaG91bGQgbm90IGhhdmUgUlcgYW5kICt4IHNldCBhdCB0aGUgdGltZS4K
CmZvciBrZXJuZWwgbGF5b3V0OgpbICAgIDAuMDAwMDAwXSBLZXJuZWwgTGF5b3V0OgpbICAgIDAu
MDAwMDAwXSAgIC50ZXh0OiBbMHgwMTAwMDAwMC0weDAyMTQzNGY4XQpbICAgIDAuMDAwMDAwXSAu
cm9kYXRhOiBbMHgwMjIwMDAwMC0weDAyYTEzZmZmXQpbICAgIDAuMDAwMDAwXSAgIC5kYXRhOiBb
MHgwMmMwMDAwMC0weDAyZGM3NjNmXQpbICAgIDAuMDAwMDAwXSAgIC5pbml0OiBbMHgwMmRjOTAw
MC0weDAzMTJjZmZmXQpbICAgIDAuMDAwMDAwXSAgICAuYnNzOiBbMHgwMzEzYjAwMC0weDAzZGQ2
ZmZmXQpbICAgIDAuMDAwMDAwXSAgICAuYnJrOiBbMHgwM2RkNzAwMC0weDAzZGZmZmZmXQoKYmVm
b3JlIHRoZSBwYXRjaCwgd2UgaGF2ZQotLS1bIEhpZ2ggS2VybmVsIE1hcHBpbmcgXS0tLQoweGZm
ZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZjgxMDAwMDAwICAgICAgICAgIDE2TSAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHBtZAoweGZmZmZmZmZmODEwMDAwMDAtMHhmZmZmZmZmZjgyMjAwMDAw
ICAgICAgICAgIDE4TSAgICAgcm8gICAgICAgICBQU0UgR0xCIHggIHBtZAoweGZmZmZmZmZmODIy
MDAwMDAtMHhmZmZmZmZmZjgyYzAwMDAwICAgICAgICAgIDEwTSAgICAgcm8gICAgICAgICBQU0Ug
R0xCIE5YIHBtZAoweGZmZmZmZmZmODJjMDAwMDAtMHhmZmZmZmZmZjgyZGM5MDAwICAgICAgICAx
ODI4SyAgICAgUlcgICAgICAgICAgICAgR0xCIHggIHB0ZQoweGZmZmZmZmZmODJkYzkwMDAtMHhm
ZmZmZmZmZjgyZTAwMDAwICAgICAgICAgMjIwSyAgICAgUlcgICAgICAgICAgICAgR0xCIE5YIHB0
ZQoweGZmZmZmZmZmODJlMDAwMDAtMHhmZmZmZmZmZjgzMDAwMDAwICAgICAgICAgICAyTSAgICAg
UlcgICAgICAgICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZmODMwMDAwMDAtMHhmZmZmZmZmZjgz
MTNhMDAwICAgICAgICAxMjU2SyAgICAgUlcgICAgICAgICAgICAgR0xCIE5YIHB0ZQoweGZmZmZm
ZmZmODMxM2EwMDAtMHhmZmZmZmZmZjgzMjAwMDAwICAgICAgICAgNzkySyAgICAgUlcgICAgICAg
ICAgICAgR0xCIHggIHB0ZQoweGZmZmZmZmZmODMyMDAwMDAtMHhmZmZmZmZmZjgzZTAwMDAwICAg
ICAgICAgIDEyTSAgICAgUlcgICAgICAgICBQU0UgR0xCIHggIHBtZAoweGZmZmZmZmZmODNlMDAw
MDAtMHhmZmZmZmZmZmEwMDAwMDAwICAgICAgICAgNDUwTSAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHBtZAoKYWZ0ZXIgcGF0Y2gsLCB3ZSBnZXQKLS0tWyBIaWdoIEtlcm5lbCBNYXBwaW5nIF0t
LS0KMHhmZmZmZmZmZjgwMDAwMDAwLTB4ZmZmZmZmZmY4MTAwMDAwMCAgICAgICAgICAxNk0gICAg
ICAgICAgICAgICAgICAgICAgICAgICBwbWQKMHhmZmZmZmZmZjgxMDAwMDAwLTB4ZmZmZmZmZmY4
MjIwMDAwMCAgICAgICAgICAxOE0gICAgIHJvICAgICAgICAgUFNFIEdMQiB4ICBwbWQKMHhmZmZm
ZmZmZjgyMjAwMDAwLTB4ZmZmZmZmZmY4MmMwMDAwMCAgICAgICAgICAxME0gICAgIHJvICAgICAg
ICAgUFNFIEdMQiBOWCBwbWQKMHhmZmZmZmZmZjgyYzAwMDAwLTB4ZmZmZmZmZmY4MmUwMDAwMCAg
ICAgICAgICAgMk0gICAgIFJXICAgICAgICAgICAgIEdMQiBOWCBwdGUKMHhmZmZmZmZmZjgyZTAw
MDAwLTB4ZmZmZmZmZmY4MzAwMDAwMCAgICAgICAgICAgMk0gICAgIFJXICAgICAgICAgUFNFIEdM
QiBOWCBwbWQKMHhmZmZmZmZmZjgzMDAwMDAwLTB4ZmZmZmZmZmY4MzIwMDAwMCAgICAgICAgICAg
Mk0gICAgIFJXICAgICAgICAgICAgIEdMQiBOWCBwdGUKMHhmZmZmZmZmZjgzMjAwMDAwLTB4ZmZm
ZmZmZmY4M2UwMDAwMCAgICAgICAgICAxMk0gICAgIFJXICAgICAgICAgUFNFIEdMQiBOWCBwbWQK
MHhmZmZmZmZmZjgzZTAwMDAwLTB4ZmZmZmZmZmZhMDAwMDAwMCAgICAgICAgIDQ1ME0gICAgICAg
ICAgICAgICAgICAgICAgICAgICBwbWQKCnNvIGRhdGEsIGJzcywgYnJrIGdldCBOWCAuLi4KClNp
Z25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94
ODYvbW0vaW5pdF82NC5jIHwgICAgNyArKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0
XzY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdF82NC5j
CisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdF82NC5jCkBAIC04MTEsNiArODExLDcgQEAg
dm9pZCBtYXJrX3JvZGF0YV9ybyh2b2lkKQogCXVuc2lnbmVkIGxvbmcgZW5kID0gKHVuc2lnbmVk
IGxvbmcpICZfX2VuZF9yb2RhdGFfaHBhZ2VfYWxpZ247CiAJdW5zaWduZWQgbG9uZyB0ZXh0X2Vu
ZCA9IFBGTl9BTElHTigmX19zdG9wX19fZXhfdGFibGUpOwogCXVuc2lnbmVkIGxvbmcgcm9kYXRh
X2VuZCA9IFBGTl9BTElHTigmX19lbmRfcm9kYXRhKTsKKwl1bnNpZ25lZCBsb25nIGFsbF9lbmQg
PSBQRk5fQUxJR04oJl9lbmQpOwogCiAJcHJpbnRrKEtFUk5fSU5GTyAiV3JpdGUgcHJvdGVjdGlu
ZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAlbHVrXG4iLAogCSAgICAgICAoZW5kIC0gc3Rh
cnQpID4+IDEwKTsKQEAgLTgxOSwxMCArODIwLDEwIEBAIHZvaWQgbWFya19yb2RhdGFfcm8odm9p
ZCkKIAlrZXJuZWxfc2V0X3RvX3JlYWRvbmx5ID0gMTsKIAogCS8qCi0JICogVGhlIHJvZGF0YSBz
ZWN0aW9uIChidXQgbm90IHRoZSBrZXJuZWwgdGV4dCEpIHNob3VsZCBhbHNvIGJlCi0JICogbm90
LWV4ZWN1dGFibGUuCisJICogVGhlIHJvZGF0YS9kYXRhL2Jzcy9icmsgc2VjdGlvbiAoYnV0IG5v
dCB0aGUga2VybmVsIHRleHQhKQorCSAqIHNob3VsZCBhbHNvIGJlIG5vdC1leGVjdXRhYmxlLgog
CSAqLwotCXNldF9tZW1vcnlfbngocm9kYXRhX3N0YXJ0LCAoZW5kIC0gcm9kYXRhX3N0YXJ0KSA+
PiBQQUdFX1NISUZUKTsKKwlzZXRfbWVtb3J5X254KHJvZGF0YV9zdGFydCwgKGFsbF9lbmQgLSBy
b2RhdGFfc3RhcnQpID4+IFBBR0VfU0hJRlQpOwogCiAJcm9kYXRhX3Rlc3QoKTsKIAo=
--00151747bd5459bb0104d16447c4--
