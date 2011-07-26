Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1GZTBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:01:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58650 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1GZTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110726161808.GA5333@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com> <20110725161009.GA9193@dumpdata.com>
 <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com> <20110726161808.GA5333@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 26 Jul 2011 15:01:17 -0400
X-Google-Sender-Auth: ptVuE2k-wwuTKEX19_sYt0g1I5c
Message-ID: <CAObL_7Fi5F6Xxv7Z5UtEQAA+gH4429gN=GG8ur6rxa6-rgr+2w@mail.gmail.com>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64: Give
 vvars their own page) breaks Xen PV guests (64-bit).
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@infradead.org,
        JBeulich@novell.com, richard.weinberger@gmail.com, mikpe@it.uu.se,
        andi@firstfloor.org, brgerst@gmail.com, Louis.Rilling@kerlabs.com,
        Valdis.Kletnieks@vt.edu, pageexec@freemail.hu, mingo@elte.hu,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Content-Type: multipart/mixed; boundary=bcaec539603ab45df804a8fd8f06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec539603ab45df804a8fd8f06
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2011 at 12:18 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> > However, this is what I get later on, any ideas?
>>
>> > [ =A0 =A00.585880] init[1] illegal int 0xcc from 32-bit mode ip:ffffff=
ffff600400 cs:e033 sp:7fff230ca088 ax:ffffffffff600400 si:7faee3e822bf di:7=
fff230ca158
>>
>> That will, indeed, crash your system.
>>
>> 0xe033 is FLAT_RING3_CS64
>>
>> Jeremy / other Xen people: =A0I'm trying to implement a lightweight
>> check to distinguish a trap from a sane (i.e. allowable for syscalls)
>> 64-bit user context from anything else. =A0There seems to be precedent
>> for using ->cs =3D=3D __USER_CS to detect 64-bitness; for example, step.=
c
>> contains:
>>
>> #ifdef CONFIG_X86_64
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 0x40 ... 0x4f:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (regs->cs !=3D __USER=
_CS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 32-bi=
t mode: register increment */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 64-bit mode: REX pref=
ix */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> #endif
>>
>> The prefetch opcode checker in mm/fault.c does something similar.
>>
>> Even the sysret code in xen/xen-asm_64.S does:
>>
>> =A0 =A0 =A0 =A0 pushq %r11
>> =A0 =A0 =A0 =A0 pushq $__USER_CS
>> =A0 =A0 =A0 =A0 pushq %rcx
>>
>> So I'm at a bit of a loss.
>>
>> You could probably hack it up and get your kernel to boot by allowing
>> __USER_CS and 0xe033 in that check, but I'd rather understand it
>
> Did this little hack:
>
>
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.=
c
> index dda7dff..5d0cf37 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -131,7 +131,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs=
 *regs, long error_code)
> =A0 =A0 =A0 =A0 * Real 64-bit user mode code has cs =3D=3D __USER_CS. =A0=
Anything else
> =A0 =A0 =A0 =A0 * is bogus.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (regs->cs !=3D __USER_CS) {
> + =A0 =A0 =A0 if ((regs->cs !=3D __USER_CS) && (regs->cs !=3D FLAT_RING3_=
CS64)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * If we trapped from kernel mode, we migh=
t as well OOPS now
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * instead of returning to some random add=
ress and OOPSing
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index f987bde..0e4c13c 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_=
t phys, pgprot_t prot)
> =A0# endif
> =A0#else
> =A0 =A0 =A0 =A0case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
> + =A0 =A0 =A0 case VVAR_PAGE:
> =A0#endif
> =A0 =A0 =A0 =A0case FIX_TEXT_POKE0:
> =A0 =A0 =A0 =A0case FIX_TEXT_POKE1:
>
> And getting this on 64-bit:
>
> =A0started: BusyBox v1.14.3 (2011-07-26 11:43:49 EDT)
> [ =A0 =A00.578603] rcS[1128]: segfault at ffffffffff5ff0a0 ip 00007fff40b=
7380a sp 00007fff40b5c0f0 error 4
> [ =A0 =A00.578847] rcS used greatest stack depth: 5024 bytes left
> [ =A0 =A00.581897] sh[1131]: segfault at ffffffffff5ff0a0 ip 00007fffb93f=
f80a sp 00007fffb92bbd70 error 4
> [ =A0 =A01.587637] sh[1137]: segfault at ffffffffff5ff0a0 ip 00007ffffa5f=
f80a sp 00007ffffa522560 error 4
> [ =A0 =A02.592295] sh[1141]: segfault at ffffffffff5ff0a0 ip 00007ffffcb3=
f80a sp 00007ffffca98af0 error 4
> [ =A0 =A03.596344] sh[1145]: segfault at ffffffffff5ff0a0 ip 00007fff2e3f=
f80a sp 00007fff2e3e3370 error 4
> [ =A0 =A04.599812] sh[1149]: segfault at ffffffffff5ff0a0 ip 00007fff62df=
f80a sp 00007fff62ca9f10 error 4
> [ =A0 =A05.605835] sh[1153]: segfault at ffffffffff5ff0a0 ip 00007fff117f=
f80a sp 00007fff1175e7f0 error 4
> [ =A0 =A06.609438] sh[1157]: segfault at ffffffffff5ff0a0 ip 00007fff91bf=
f80a sp 00007fff91bd71c0 error 4
> [ =A0 =A07.614714] sh[1161]: segfault at ffffffffff5ff0a0 ip 00007fff396b=
280a sp 00007fff3968ede0 error 4
> [ =A0 =A08.620374] sh[1165]: segfault at ffffffffff5ff0a0 ip 00007fffd398=
b80a sp 00007fffd38ecd70 error 4
> [ =A0 =A09.625512] sh[1169]: segfault at ffffffffff5ff0a0 ip 00007fff617d=
980a sp 00007fff61776070 error 4
> [ =A0 10.630246] sh[1173]: segfault at ffffffffff5ff0a0 ip 00007fff89fff8=
0a sp 00007fff89f7f3b0 error 4
> [ =A0 11.635588] sh[1177]: segfault at ffffffffff5ff0a0 ip 00007fffa95ff8=
0a sp 00007fffa95ea7c0 error 4
> [ =A0 12.640491] sh[1181]: segfault at ffffffffff5ff0a0 ip 00007fff28cd18=
0a sp 00007fff28c524f0 error 4

That one means that the vvar fixmap isn't working.  Can you try the
attached patch?

--Andy

>
> ..
>

--bcaec539603ab45df804a8fd8f06
Content-Type: text/x-patch; charset=US-ASCII; name="xen-hack.patch"
Content-Disposition: attachment; filename="xen-hack.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gql8eixx0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzXzY0LmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvcHJvY2Vzc182NC5jCmluZGV4IGNhNmY3YWIuLmIxZjNmNTMgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9wcm9jZXNzXzY0LmMKKysrIGIvYXJjaC94ODYva2VybmVsL3Byb2Nlc3NfNjQu
YwpAQCAtNjM4LDYgKzYzOCwyNSBAQCBsb25nIGRvX2FyY2hfcHJjdGwoc3RydWN0IHRhc2tfc3Ry
dWN0ICp0YXNrLCBpbnQgY29kZSwgdW5zaWduZWQgbG9uZyBhZGRyKQogCQlicmVhazsKIAl9CiAK
KwljYXNlIDEwMDA6IHsKKwkJa2VybmVsX2ZwdV9iZWdpbigpOworCQlrZXJuZWxfZnB1X2VuZCgp
OworCQlyZXQgPSAwOworCQlicmVhazsKKwl9CisKKwljYXNlIDEwMDE6IHsKKwkJaW50IGk7CisJ
CWtlcm5lbF9mcHVfYmVnaW4oKTsKKwkJZm9yIChpID0gMDsgaSA8IDk5OTsgaSsrKSB7CisJCQlz
dHRzKCk7CisJCQljbHRzKCk7CisJCX0KKwkJa2VybmVsX2ZwdV9lbmQoKTsKKwkJcmV0ID0gMDsK
KwkJYnJlYWs7CisJfQorCiAJZGVmYXVsdDoKIAkJcmV0ID0gLUVJTlZBTDsKIAkJYnJlYWs7CmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4vbW11LmMgYi9hcmNoL3g4Ni94ZW4vbW11LmMKaW5kZXgg
MGNjY2NiNi4uNTg4ODU3OSAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL21tdS5jCisrKyBiL2Fy
Y2gveDg2L3hlbi9tbXUuYwpAQCAtMTgyOSw2ICsxODI5LDcgQEAgc3RhdGljIHZvaWQgeGVuX3Nl
dF9maXhtYXAodW5zaWduZWQgaWR4LCBwaHlzX2FkZHJfdCBwaHlzLCBwZ3Byb3RfdCBwcm90KQog
IyBlbmRpZgogI2Vsc2UKIAljYXNlIFZTWVNDQUxMX0xBU1RfUEFHRSAuLi4gVlNZU0NBTExfRklS
U1RfUEFHRToKKwljYXNlIFZWQVJfUEFHRToKICNlbmRpZgogCWNhc2UgRklYX1RFWFRfUE9LRTA6
CiAJY2FzZSBGSVhfVEVYVF9QT0tFMToKQEAgLTE4NjksNyArMTg3MCw4IEBAIHN0YXRpYyB2b2lk
IHhlbl9zZXRfZml4bWFwKHVuc2lnbmVkIGlkeCwgcGh5c19hZGRyX3QgcGh5cywgcGdwcm90X3Qg
cHJvdCkKICNpZmRlZiBDT05GSUdfWDg2XzY0CiAJLyogUmVwbGljYXRlIGNoYW5nZXMgdG8gbWFw
IHRoZSB2c3lzY2FsbCBwYWdlIGludG8gdGhlIHVzZXIKIAkgICBwYWdldGFibGUgdnN5c2NhbGwg
bWFwcGluZy4gKi8KLQlpZiAoaWR4ID49IFZTWVNDQUxMX0xBU1RfUEFHRSAmJiBpZHggPD0gVlNZ
U0NBTExfRklSU1RfUEFHRSkgeworCWlmIChpZHggPj0gVlNZU0NBTExfTEFTVF9QQUdFICYmIGlk
eCA8PSBWU1lTQ0FMTF9GSVJTVF9QQUdFIHx8CisJICAgIGlkeCA9PSBWVkFSX1BBR0UpIHsKIAkJ
dW5zaWduZWQgbG9uZyB2YWRkciA9IF9fZml4X3RvX3ZpcnQoaWR4KTsKIAkJc2V0X3B0ZV92YWRk
cl9wdWQobGV2ZWwzX3VzZXJfdnN5c2NhbGwsIHZhZGRyLCBwdGUpOwogCX0K
--bcaec539603ab45df804a8fd8f06--
