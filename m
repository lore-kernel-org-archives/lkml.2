Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0F3JAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:00:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:17358 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0F3JAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:00:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,510,1272870000"; 
   d="c'?scan'208";a="294667812"
From: "Ma, Ling" <ling.ma@intel.com>
To: "mingo@elte.hu" <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Jun 2010 16:59:18 +0800
Subject: RE: [PATCH RFC] [X86] Optimize memcpy by avoiding memory false
 dependece
Thread-Topic: [PATCH RFC] [X86] Optimize memcpy by avoiding memory false
 dependece
Thread-Index: AcsXMfDY1G1lZcgMQp+Do+RhGJYxyABADIRg
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F09F023CE6B@shsmsx502.ccr.corp.intel.com>
References: <1277753065-18610-1-git-send-email-ling.ma@intel.com>
In-Reply-To: <1277753065-18610-1-git-send-email-ling.ma@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_C10D3FB0CD45994C8A51FEC1227CE22F09F023CE6Bshsmsx502ccrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_C10D3FB0CD45994C8A51FEC1227CE22F09F023CE6Bshsmsx502ccrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Ingo

We extract some compared results by attachment micro-benchmarks on Corei7.
(gcc -O2 -o memcpy-kernel memcpy-kernel.c )

LAT: Len  127, alignment  4/16:  improvement: 2X
LAT: Len  127, alignment  0/16:  improvement: 2X
LAT: Len 1024, alignment  4/16:  improvement: 1.5X
LAT: Len 1024, alignment  0/ 0:   no change
LAT: Len 4096, alignment  4/16:  improvement :1.6X
LAT: Len 4096, alignment  0/ 8:   improvement:1.37X
LAT: Len 8192, alignment 16/ 0:   no change
LAT: Len 8192, alignment  0/16:  improvement 1.45X

Any comments from you ?

Thanks
Ling

> -----Original Message-----
> From: Ma, Ling
> Sent: Tuesday, June 29, 2010 3:24 AM
> To: mingo@elte.hu
> Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org; Ma,
> Ling
> Subject: [PATCH RFC] [X86] Optimize memcpy by avoiding memory false
> dependece
>=20
> From: Ma Ling <ling.ma@intel.com>
>=20
> All read operations after allocation stage can run speculatively,
> all write operation will run in program order, and if addresses are
> different read may run before older write operation, otherwise wait
> until write commit. However CPU don't check each address bit,
> so read could fail to recognize different address even they
> are in different page.For example if rsi is 0xf004, rdi is 0xe008,
> in following operation there will generate big performance latency.
> 1. movq (%rsi),	%rax
> 2. movq %rax,	(%rdi)
> 3. movq 8(%rsi), %rax
> 4. movq %rax,	8(%rdi)
>=20
> If %rsi and rdi were in really the same meory page, there are TRUE
> read-after-write dependence because instruction 2 write 0x008 and
> instruction 3 read 0x00c, the two address are overlap partially.
> Actually there are in different page and no any issues,
> but without checking each address bit CPU could think they are
> in the same page, and instruction 3 have to wait for instruction 2
> to write data into cache from write buffer, then load data from cache,
> the cost time read spent is equal to mfence instruction. We may avoid it =
by
> tuning operation sequence as follow.
>=20
> 1. movq 8(%rsi), %rax
> 2. movq %rax,	8(%rdi)
> 3. movq (%rsi),	%rax
> 4. movq %rax,	(%rdi)
>=20
> Instruction 3 read 0x004, instruction 2 write address 0x010, no any
> dependence.
> At last on Core2 we gain 1.83x speedup compared with original instruction
> sequence.
> In this patch we first handle small size(less 20bytes), then jump to
> different copy mode. Based on our micro-benchmark small bytes from 1 to 1=
27
> bytes,
> we got up to 2X improvement, and up to 1.5X improvement for 1024 bytes on
> Corei7.
> (We use our micro-benchmark, and will do further test according to your
> requirment)
>=20
> Thanks
> Ling
>=20
> ---
>  arch/x86/lib/memcpy_64.S |  158
> ++++++++++++++++++++++++++++++----------------
>  1 files changed, 103 insertions(+), 55 deletions(-)
>=20
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index f82e884..5902438 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -40,84 +40,132 @@
>  ENTRY(__memcpy)
>  ENTRY(memcpy)
>  	CFI_STARTPROC
> +	movq %rdi, %rax
>=20
>  	/*
> -	 * Put the number of full 64-byte blocks into %ecx.
> -	 * Tail portion is handled at the end:
> +	 * Use 32bit CMP here to avoid long NOP padding.
>  	 */
> -	movq %rdi, %rax
> -	movl %edx, %ecx
> -	shrl   $6, %ecx
> -	jz .Lhandle_tail
> +	cmp  $0x20, %edx
> +	jb .Lhandle_tail
>=20
> -	.p2align 4
> -.Lloop_64:
>  	/*
> -	 * We decrement the loop index here - and the zero-flag is
> -	 * checked at the end of the loop (instructions inbetween do
> -	 * not change the zero flag):
> +	 * We check whether memory false dependece could occur,
> +	 * then jump to corresponding copy mode.
>  	 */
> -	decl %ecx
> +	cmp  %dil, %sil
> +	jl .Lcopy_backward
> +	subl $0x20, %edx
> +.Lcopy_forward_loop:
> +	subq $0x20,	%rdx
>=20
>  	/*
> -	 * Move in blocks of 4x16 bytes:
> +	 * Move in blocks of 4x8 bytes:
>  	 */
> -	movq 0*8(%rsi),		%r11
> -	movq 1*8(%rsi),		%r8
> -	movq %r11,		0*8(%rdi)
> -	movq %r8,		1*8(%rdi)
> -
> -	movq 2*8(%rsi),		%r9
> -	movq 3*8(%rsi),		%r10
> -	movq %r9,		2*8(%rdi)
> -	movq %r10,		3*8(%rdi)
> -
> -	movq 4*8(%rsi),		%r11
> -	movq 5*8(%rsi),		%r8
> -	movq %r11,		4*8(%rdi)
> -	movq %r8,		5*8(%rdi)
> -
> -	movq 6*8(%rsi),		%r9
> -	movq 7*8(%rsi),		%r10
> -	movq %r9,		6*8(%rdi)
> -	movq %r10,		7*8(%rdi)
> -
> -	leaq 64(%rsi), %rsi
> -	leaq 64(%rdi), %rdi
> -
> -	jnz  .Lloop_64
> +	movq 0*8(%rsi),	%r8
> +	movq 1*8(%rsi),	%r9
> +	movq 2*8(%rsi),	%r10
> +	movq 3*8(%rsi),	%r11
> +	leaq 4*8(%rsi),	%rsi
> +
> +	movq %r8,	0*8(%rdi)
> +	movq %r9,	1*8(%rdi)
> +	movq %r10,	2*8(%rdi)
> +	movq %r11,	3*8(%rdi)
> +	leaq 4*8(%rdi),	%rdi
> +	jae  .Lcopy_forward_loop
> +	addq $0x20,	%rdx
> +	jmp  .Lhandle_tail
> +
> +.Lcopy_backward:
> +	/*
> +	 * Calculate copy position to tail.
> +	 */
> +	addq %rdx,	%rsi
> +	addq %rdx,	%rdi
> +	subq $0x20,	%rdx
> +	/*
> +	 * At most 3 ALU operations in one cycle,
> +	 * so append NOPS in the same 16bytes trunk.
> +	 */
> +	.p2align 4
> +.Lcopy_backward_loop:
> +	subq $0x20,	%rdx
> +	movq -1*8(%rsi),	%r8
> +	movq -2*8(%rsi),	%r9
> +	movq -3*8(%rsi),	%r10
> +	movq -4*8(%rsi),	%r11
> +	leaq -4*8(%rsi),	%rsi
> +	movq %r8,		-1*8(%rdi)
> +	movq %r9,		-2*8(%rdi)
> +	movq %r10,		-3*8(%rdi)
> +	movq %r11,		-4*8(%rdi)
> +	leaq -4*8(%rdi),	%rdi
> +	jae  .Lcopy_backward_loop
>=20
> +	/*
> +	 * Calculate copy position to head.
> +	 */
> +	addq $0x20,	%rdx
> +	subq %rdx,	%rsi
> +	subq %rdx,	%rdi
>  .Lhandle_tail:
> -	movl %edx, %ecx
> -	andl  $63, %ecx
> -	shrl   $3, %ecx
> -	jz   .Lhandle_7
> +	cmpq $16,	%rdx
> +	jb   .Lless_16bytes
>=20
> +	/*
> +	 * Move data from 16 bytes to 31 bytes.
> +	 */
> +	movq 0*8(%rsi), %r8
> +	movq 1*8(%rsi),	%r9
> +	movq -2*8(%rsi, %rdx),	%r10
> +	movq -1*8(%rsi, %rdx),	%r11
> +	movq %r8,	0*8(%rdi)
> +	movq %r9,	1*8(%rdi)
> +	movq %r10,	-2*8(%rdi, %rdx)
> +	movq %r11,	-1*8(%rdi, %rdx)
> +	retq
>  	.p2align 4
> -.Lloop_8:
> -	decl %ecx
> -	movq (%rsi),		%r8
> -	movq %r8,		(%rdi)
> -	leaq 8(%rdi),		%rdi
> -	leaq 8(%rsi),		%rsi
> -	jnz  .Lloop_8
> -
> -.Lhandle_7:
> -	movl %edx, %ecx
> -	andl $7, %ecx
> -	jz .Lend
> +.Lless_16bytes:
> +	cmpq $8,	%rdx
> +	jb   .Lless_8bytes
> +	/*
> +	 * Move data from 8 bytes to 15 bytes.
> +	 */
> +	movq 0*8(%rsi),	%r8
> +	movq -1*8(%rsi, %rdx),	%r9
> +	movq %r8,	0*8(%rdi)
> +	movq %r9,	-1*8(%rdi, %rdx)
> +	retq
> +	.p2align 4
> +.Lless_8bytes:
> +	cmpq $4,	%rdx
> +	jb   .Lless_3bytes
>=20
> +	/*
> +	 * Move data from 4 bytes to 7 bytes.
> +	 */
> +	movl (%rsi), %ecx
> +	movl -4(%rsi, %rdx), %r8d
> +	movl %ecx, (%rdi)
> +	movl %r8d, -4(%rdi, %rdx)
> +	retq
>  	.p2align 4
> +.Lless_3bytes:
> + 	cmpl $0, %edx
> +	je .Lend
> +	/*
> +	 * Move data from 1 bytes to 3 bytes.
> +	 */
>  .Lloop_1:
>  	movb (%rsi), %r8b
>  	movb %r8b, (%rdi)
>  	incq %rdi
>  	incq %rsi
> -	decl %ecx
> +	decl %edx
>  	jnz .Lloop_1
>=20
>  .Lend:
> -	ret
> +	retq
>  	CFI_ENDPROC
>  ENDPROC(memcpy)
>  ENDPROC(__memcpy)
> --
> 1.6.5.2


--_002_C10D3FB0CD45994C8A51FEC1227CE22F09F023CE6Bshsmsx502ccrc_
Content-Type: text/plain; name="memcpy-kernel.c"
Content-Description: memcpy-kernel.c
Content-Disposition: attachment; filename="memcpy-kernel.c"; size=7630;
	creation-date="Wed, 30 Jun 2010 09:07:05 GMT";
	modification-date="Wed, 30 Jun 2010 09:06:55 GMT"
Content-Transfer-Encoding: base64

I2luY2x1ZGU8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgoKCnR5cGVkZWYgdW5zaWduZWQg
bG9uZyBsb25nIGludCBocF90aW1pbmdfdDsKI2RlZmluZSAgTUFYU0FNUExFU1RQVCAgICAgICAg
MTAwMAojZGVmaW5lICBNQVhDT1BZU0laRSAgICAgICAgICAoMTAyNCAqIDEwMjQgKiAxMDApCiNk
ZWZpbmUgIE9SSUcgIDAKI2RlZmluZSAgTkVXICAgMQpzdGF0aWMgY2hhciogYnVmMSA9IE5VTEw7
CnN0YXRpYyBjaGFyKiBidWYyID0gTlVMTDsKc3RhdGljIGludCByZXBlYXRfb25lX3Rlc3QgPSAz
MjsKCmhwX3RpbWluZ190IF9kbF9ocF90aW1pbmdfb3ZlcmhlYWQ7CiMgZGVmaW5lIEhQX1RJTUlO
R19OT1coVmFyKSBcCiAgKHsgdW5zaWduZWQgbG9uZyBsb25nIF9oaSwgX2xvOyBcCiAgICAgYXNt
IHZvbGF0aWxlICgicmR0c2MiIDogIj1hIiAoX2xvKSwgIj1kIiAoX2hpKSk7IFwKICAgICAoVmFy
KSA9IF9oaSA8PCAzMiB8IF9sbzsgfSkKCiNkZWZpbmUgSFBfVElNSU5HX0RJRkYoRGlmZiwgU3Rh
cnQsIEVuZCkJKERpZmYpID0gKChFbmQpIC0gKFN0YXJ0KSkKI2RlZmluZSBIUF9USU1JTkdfVE9U
QUwodG90YWxfdGltZSwgc3RhcnQsIGVuZCkJXAogIGRvCQkJCQkJCQkJXAogICAgewkJCQkJCQkJ
CVwKICAgICAgaHBfdGltaW5nX3QgdG1wdGltZTsJCQkJCQlcCiAgICAgIEhQX1RJTUlOR19ESUZG
ICh0bXB0aW1lLCBzdGFydCArIF9kbF9ocF90aW1pbmdfb3ZlcmhlYWQsIGVuZCk7CVwKCXRvdGFs
X3RpbWUgKz0gdG1wdGltZTsJCQkJCQlcCiAgICB9CQkJCQkJCQkJXAogIHdoaWxlICgwKQoKI2Rl
ZmluZSBIUF9USU1JTkdfQkVTVChiZXN0X3RpbWUsIHN0YXJ0LCBlbmQpCVwKICBkbwkJCQkJCQkJ
CVwKICAgIHsJCQkJCQkJCQlcCiAgICAgIGhwX3RpbWluZ190IHRtcHRpbWU7CQkJCQkJXAogICAg
ICBIUF9USU1JTkdfRElGRiAodG1wdGltZSwgc3RhcnQgKyBfZGxfaHBfdGltaW5nX292ZXJoZWFk
LCBlbmQpOwlcCiAgICAgIGlmIChiZXN0X3RpbWUgPiB0bXB0aW1lKQkJCQkJCVwKCWJlc3RfdGlt
ZSA9IHRtcHRpbWU7CQkJCQkJXAogICAgfQkJCQkJCQkJCVwKICB3aGlsZSAoMCkKCgp2b2lkIG1l
bWNweV9vcmlnKGNoYXIgKmRzdCwgY2hhciAqc3JjLCBpbnQgbGVuKTsKdm9pZCBtZW1jcHlfbmV3
KGNoYXIgKmRzdCwgY2hhciAqc3JjLCBpbnQgbGVuKTsKdm9pZCAoKmRvX21lbWNweSkoY2hhciAq
ZHN0LCBjaGFyICpzcmMsIGludCBsZW4pOwoKc3RhdGljIHZvaWQKZG9fb25lX3Rlc3QgKCBjaGFy
ICpkc3QsIGNoYXIgKnNyYywKCSAgICAgc2l6ZV90IGxlbikKewogICAgICBocF90aW1pbmdfdCBz
dGFydCBfX2F0dHJpYnV0ZSAoKHVudXNlZCkpOwogICAgICBocF90aW1pbmdfdCBzdG9wIF9fYXR0
cmlidXRlICgodW51c2VkKSk7CiAgICAgIGhwX3RpbWluZ190IGJlc3RfdGltZSA9IH4gKGhwX3Rp
bWluZ190KSAwOwogICAgICBzaXplX3QgaSxqOwoKICAgICAgZm9yIChpID0gMDsgaSA8IHJlcGVh
dF9vbmVfdGVzdDsgKytpKQoJewoJICBIUF9USU1JTkdfTk9XIChzdGFydCk7CgkgIGRvX21lbWNw
eSAoIGRzdCwgc3JjLCBsZW4pOwoJICBIUF9USU1JTkdfTk9XIChzdG9wKTsKCSAgSFBfVElNSU5H
X0JFU1QgKGJlc3RfdGltZSwgc3RhcnQsIHN0b3ApOwoJfQoKICAgICAgcHJpbnRmICgiXHQlemQi
LCAoc2l6ZV90KSBiZXN0X3RpbWUpOwp9CgpzdGF0aWMgdm9pZApkb190ZXN0IChzaXplX3QgYWxp
Z24xLCBzaXplX3QgYWxpZ24yLCBzaXplX3QgbGVuKQp7CiAgc2l6ZV90IGksIGo7CiAgY2hhciAq
czEsICpzMjsKCiAgczEgPSAoY2hhciAqKSAoYnVmMSArIGFsaWduMSk7CiAgczIgPSAoY2hhciAq
KSAoYnVmMiArIGFsaWduMik7CgoKICAgcHJpbnRmICgiVFBUOiBMZW4gJTR6ZCwgYWxpZ25tZW50
ICUyemQvJTJ6ZDoiLCBsZW4sIGFsaWduMSwgYWxpZ24yKTsKICAgZG9fbWVtY3B5ID0gbWVtY3B5
X29yaWc7CiAgIGRvX29uZV90ZXN0IChzMiwgczEsIGxlbik7CiAgIGRvX21lbWNweSA9IG1lbWNw
eV9uZXc7CiAgIGRvX29uZV90ZXN0IChzMiwgczEsIGxlbik7CgogICAgcHV0Y2hhciAoJ1xuJyk7
Cn0KCnN0YXRpYyB0ZXN0X2luaXQodm9pZCkKewogIGludCBpOwogIGJ1ZjEgPSB2YWxsb2MoTUFY
Q09QWVNJWkUpOwogIGJ1ZjIgPSB2YWxsb2MoTUFYQ09QWVNJWkUpOwoKICBmb3IgKGkgPSAwOyBp
IDwgTUFYQ09QWVNJWkUgOyBpID0gaSArIDY0KSB7CiAgICAgICAgYnVmMVtpXSA9IGJ1ZjJbaV0g
PSBpICYgMHhmZjsKICB9Cgp9Cgp2b2lkIG1lbXNldF9jKGNoYXIgKmRzdCwgY2hhciAqc3JjLCBp
bnQgbGVuKQp7CglfX2FzbV9fKCJtb3YgJXJkeCwgJXJjeCIpOwoJX19hc21fXygic2hyICQzLCAl
cmN4Iik7CglfX2FzbV9fKCJyZXAgc3Rvc3EiKTsKfQp2b2lkIG1lbXNldF8yKGNoYXIgKmRzdCwg
Y2hhciAqc3JjLCBpbnQgbGVuKQp7CglfX2FzbV9fKCJzdWIgICQxMjgsICVyZHgiKTsKCV9fYXNt
X18oIjE6Iik7CglfX2FzbV9fKCJzdWIgICQxMjgsICVyZHgiKTsKCV9fYXNtX18oIm1vdmRxYSAl
eG1tMCwgKCVyZGkpIik7CglfX2FzbV9fKCJtb3ZkcWEgJXhtbTAsIDE2KCVyZGkpIik7CglfX2Fz
bV9fKCJtb3ZkcWEgJXhtbTAsIDMyKCVyZGkpIik7CglfX2FzbV9fKCJtb3ZkcWEgJXhtbTAsIDQ4
KCVyZGkpIik7CglfX2FzbV9fKCJtb3ZkcWEgJXhtbTAsIDY0KCVyZGkpIik7CglfX2FzbV9fKCJt
b3ZkcWEgJXhtbTAsIDgwKCVyZGkpIik7CglfX2FzbV9fKCJtb3ZkcWEgJXhtbTAsIDk2KCVyZGkp
Iik7CglfX2FzbV9fKCJtb3ZkcWEgJXhtbTAsIDExMiglcmRpKSIpOwoJX19hc21fXygiamFlIDFi
Iik7Cgp9Cgp2b2lkIG1lbWNweV9uZXcoY2hhciAqZHN0LCBjaGFyICpzcmMsIGludCBsZW4pCnsK
CglfX2FzbV9fKCJtb3ZxICVyZGksICVyYXgiKTsKCV9fYXNtX18oImNtcCAgJDB4MjAsICVlZHgi
KTsKCV9fYXNtX18oImpiIDFmIik7CgoJLyoKCSAqIFdlIGNoZWNrIHdoZXRoZXIgbWVtb3J5IGZh
bHNlIGRlcGVuZGVjZSBjb3VsZCBvY2N1ciwKCSAqIHRoZW4ganVtcCB0byBjb3JyZXNwb25kaW5n
IGNvcHkgbW9kZS4KCSAqLwoJX19hc21fXygiY21wICAlZGlsLCAlc2lsIik7CglfX2FzbV9fKCJq
bCAyZiIpOwoJX19hc21fXygic3VibCAkMHgyMCwgJWVkeCIpOwpfX2FzbV9fKCIzOiIpOwoJX19h
c21fXygic3VicSAkMHgyMCwJJXJkeCIpOwoKCS8qCgkgKiBNb3ZlIGluIGJsb2NrcyBvZiA0eDgg
Ynl0ZXM6CgkgKi8KCV9fYXNtX18oIm1vdnEgMCo4KCVyc2kpLAklcjgiKTsKCV9fYXNtX18oIm1v
dnEgMSo4KCVyc2kpLAklcjkiKTsKCV9fYXNtX18oIm1vdnEgMio4KCVyc2kpLAklcjEwIik7Cglf
X2FzbV9fKCJtb3ZxIDMqOCglcnNpKSwJJXIxMSIpOwoJX19hc21fXygibGVhcSA0KjgoJXJzaSks
CSVyc2kiKTsKCglfX2FzbV9fKCJtb3ZxICVyOCwJMCo4KCVyZGkpIik7CglfX2FzbV9fKCJtb3Zx
ICVyOSwJMSo4KCVyZGkpIik7CglfX2FzbV9fKCJtb3ZxICVyMTAsCTIqOCglcmRpKSIpOwoJX19h
c21fXygibW92cSAlcjExLAkzKjgoJXJkaSkiKTsKCV9fYXNtX18oImxlYXEgNCo4KCVyZGkpLAkl
cmRpIik7CglfX2FzbV9fKCJqYWUgIDNiIik7CglfX2FzbV9fKCJhZGRxICQweDIwLCAlcmR4Iik7
CglfX2FzbV9fKCJqbXAgIDFmIik7CgpfX2FzbV9fKCIyOiIpOwoJLyoKCSAqIENhbGN1bGF0ZSBj
b3B5IHBvc2l0aW9uIHRvIHRhaWwuCgkgKi8KCV9fYXNtX18oImFkZHEgJXJkeCwgJXJzaSIpOwoJ
X19hc21fXygiYWRkcSAlcmR4LCAlcmRpIik7CglfX2FzbV9fKCJzdWJxICQweDIwLAklcmR4Iik7
CglfX2FzbV9fKCIucDJhbGlnbiA0Iik7Cl9fYXNtX18oIjQ6Iik7CglfX2FzbV9fKCJzdWJxICQw
eDIwLAklcmR4Iik7CglfX2FzbV9fKCJtb3ZxIC0xKjgoJXJzaSksCSVyOCIpOwoJX19hc21fXygi
bW92cSAtMio4KCVyc2kpLAklcjkiKTsKCV9fYXNtX18oIm1vdnEgLTMqOCglcnNpKSwJJXIxMCIp
OwoJX19hc21fXygibW92cSAtNCo4KCVyc2kpLAklcjExIik7CglfX2FzbV9fKCJsZWFxIC00Kjgo
JXJzaSksCSVyc2kiKTsKCV9fYXNtX18oIm1vdnEgJXI4LAkJLTEqOCglcmRpKSIpOwoJX19hc21f
XygibW92cSAlcjksCQktMio4KCVyZGkpIik7CglfX2FzbV9fKCJtb3ZxICVyMTAsCQktMyo4KCVy
ZGkpIik7CglfX2FzbV9fKCJtb3ZxICVyMTEsCQktNCo4KCVyZGkpIik7CglfX2FzbV9fKCJsZWFx
IC00KjgoJXJkaSksCSVyZGkiKTsKCV9fYXNtX18oImphZSAgNGIiKTsKCgkvKgoJICogQ2FsY3Vs
YXRlIGNvcHkgcG9zaXRpb24gdG8gaGVhZC4KCSAqLwoJX19hc21fXygiYWRkcSAkMHgyMCwgJXJk
eCIpOwoJX19hc21fXygic3VicSAlcmR4LCAlcnNpIik7CglfX2FzbV9fKCJzdWJxICVyZHgsICVy
ZGkiKTsKX19hc21fXygiMToiKTsKCV9fYXNtX18oImNtcHEgJDE2LCAlcmR4Iik7CglfX2FzbV9f
KCJqYiAgIDVmIik7CgoJLyoKCSAqIE1vdmUgZGF0YSBmcm9tIDE2IGJ5dGVzIHRvIDMxIGJ5dGVz
LgoJICovCglfX2FzbV9fKCJtb3ZxIDAqOCglcnNpKSwJJXI4Iik7CglfX2FzbV9fKCJtb3ZxIDEq
OCglcnNpKSwJJXI5Iik7CglfX2FzbV9fKCJtb3ZxIC0yKjgoJXJzaSwgJXJkeCksCSVyMTAiKTsK
CV9fYXNtX18oIm1vdnEgLTEqOCglcnNpLCAlcmR4KSwJJXIxMSIpOwoJX19hc21fXygibW92cSAl
cjgsCTAqOCglcmRpKSIpOwoJX19hc21fXygibW92cSAlcjksCTEqOCglcmRpKSIpOwoJX19hc21f
XygibW92cSAlcjEwLAktMio4KCVyZGksICVyZHgpIik7CglfX2FzbV9fKCJtb3ZxICVyMTEsCS0x
KjgoJXJkaSwgJXJkeCkiKTsKCV9fYXNtX18oInJldHEiKTsKCV9fYXNtX18oIi5wMmFsaWduIDQi
KTsKX19hc21fXygiNToiKTsKCV9fYXNtX18oImNtcHEgJDgsICVyZHgiKTsKCV9fYXNtX18oImpi
ICAgNmYiKTsKCS8qCgkgKiBNb3ZlIGRhdGEgZnJvbSA4IGJ5dGVzIHRvIDE1IGJ5dGVzLgoJICov
CglfX2FzbV9fKCJtb3ZxIDAqOCglcnNpKSwJJXI4Iik7CglfX2FzbV9fKCJtb3ZxIC0xKjgoJXJz
aSwgJXJkeCksCSVyOSIpOwoJX19hc21fXygibW92cSAlcjgsCTAqOCglcmRpKSIpOwoJX19hc21f
XygibW92cSAlcjksCS0xKjgoJXJkaSwgJXJkeCkiKTsKCV9fYXNtX18oInJldHEiKTsKCV9fYXNt
X18oIi5wMmFsaWduIDQiKTsKX19hc21fXygiNjoiKTsKCV9fYXNtX18oImNtcHEgJDQsICVyZHgi
KTsKCV9fYXNtX18oImpiICAgN2YiKTsKCgkvKgoJICogTW92ZSBkYXRhIGZyb20gNCBieXRlcyB0
byA3IGJ5dGVzLgoJICovCglfX2FzbV9fKCJtb3ZsICglcnNpKSwgJWVjeCIpOwoJX19hc21fXygi
bW92bCAtNCglcnNpLCAlcmR4KSwgJXI4ZCIpOwoJX19hc21fXygibW92bCAlZWN4LCAoJXJkaSki
KTsKCV9fYXNtX18oIm1vdmwgJXI4ZCwgLTQoJXJkaSwgJXJkeCkiKTsKCV9fYXNtX18oInJldHEi
KTsKCV9fYXNtX18oIi5wMmFsaWduIDQiKTsKX19hc21fXygiNzoiKTsKCV9fYXNtX18oImNtcGwg
JDAsICVlZHgiKTsKCV9fYXNtX18oImplIDhmIik7CgkvKgoJICogTW92ZSBkYXRhIGZyb20gMSBi
eXRlcyB0byAzIGJ5dGVzLgoJICovCl9fYXNtX18oIjk6Iik7CglfX2FzbV9fKCJtb3ZiICglcnNp
KSwgJXI4YiIpOwoJX19hc21fXygibW92YiAlcjhiLCAoJXJkaSkiKTsKCV9fYXNtX18oImluY3Eg
JXJkaSIpOwoJX19hc21fXygiaW5jcSAlcnNpIik7CglfX2FzbV9fKCJkZWNsICVlZHgiKTsKCV9f
YXNtX18oImpueiA5YiIpOwoKX19hc21fXygiODoiKTsKfQoKdm9pZCBtZW1jcHlfb3JpZyhjaGFy
ICpkc3QsIGNoYXIgKnNyYywgaW50IGxlbikKewoJX19hc21fXygibW92ICVyZGksICVyYXgiKTsK
CV9fYXNtX18oIm1vdmwgJWVkeCwgJWVjeCIpOwoJX19hc21fXygic2hybCAgICQ2LCAlZWN4Iik7
CglfX2FzbV9fKCJqeiAyZiIpOwoJX19hc21fXygibW92ICQweDgwLCAlcjhkICAiKTsgIC8qYWxp
Z25lZCBjYXNlIGZvciBsb29wIDEgKi8KCV9fYXNtX18oIjE6Iik7CglfX2FzbV9fKCJkZWNsICVl
Y3giKTsKCV9fYXNtX18oIm1vdiAwKjgoJXJzaSksICVyMTEiKTsKCV9fYXNtX18oIm1vdiAxKjgo
JXJkaSksICVyOCIpOwoJX19hc21fXygibW92ICVyMTEsCTAqOCglcmRpKSIpOwoJX19hc21fXygi
bW92ICVyOCwJMSo4KCVyZGkpIik7CglfX2FzbV9fKCJtb3YgMio4KCVyc2kpLCAlcjkiKTsKCV9f
YXNtX18oIm1vdiAzKjgoJXJkaSksICVyMTAiKTsKCV9fYXNtX18oIm1vdiAlcjksCTIqOCglcmRp
KSIpOwoJX19hc21fXygibW92ICVyMTAsCTMqOCglcmRpKSIpOwoJX19hc21fXygibW92IDQqOCgl
cnNpKSwgJXIxMSIpOwoJX19hc21fXygibW92IDUqOCglcmRpKSwgJXI4Iik7CglfX2FzbV9fKCJt
b3YgJXIxMSwJNCo4KCVyZGkpIik7CglfX2FzbV9fKCJtb3YgJXI4LAk1KjgoJXJkaSkiKTsKCV9f
YXNtX18oIm1vdiA2KjgoJXJzaSksICVyOSIpOwoJX19hc21fXygibW92IDcqOCglcmRpKSwgJXIx
MCIpOwoJX19hc21fXygibW92ICVyOSwJNio4KCVyZGkpIik7CglfX2FzbV9fKCJtb3YgJXIxMCwJ
Nyo4KCVyZGkpIik7CglfX2FzbV9fKCJsZWFxIDY0KCVyc2kpLCAlcnNpIik7CglfX2FzbV9fKCJs
ZWFxIDY0KCVyZGkpLCAlcmRpIik7CglfX2FzbV9fKCJqbnogIDFiIik7CglfX2FzbV9fKCIyOiIp
OwoJX19hc21fXygibW92bCAlZWR4LCAlZWN4Iik7CglfX2FzbV9fKCJhbmRsICQ2MywgJWVjeCIp
OwoJX19hc21fXygic2hybCAgICQzLCAlZWN4Iik7CglfX2FzbV9fKCJqeiA0ZiIpOwoJX19hc21f
XygiMzoiKTsKCV9fYXNtX18oImRlY2wgJWVjeCIpOwoJX19hc21fXygibW92ICglcnNpKSwJJXI4
Iik7CglfX2FzbV9fKCJtb3YgJXI4LAkoJXJkaSkiKTsKCV9fYXNtX18oImxlYXEgOCglcmRpKSwJ
JXJkaSIpOwoJX19hc21fXygibGVhcSA4KCVyc2kpLAklcnNpIik7CglfX2FzbV9fKCJqbnogM2Ii
KTsKCV9fYXNtX18oIjQ6Iik7CglfX2FzbV9fKCJtb3ZsICVlZHgsCSVlY3giKTsKCV9fYXNtX18o
ImFuZGwgJDcsCSVlY3giKTsKCV9fYXNtX18oImp6IDZmIik7CglfX2FzbV9fKCI1OiIpOwoJX19h
c21fXygibW92YiAoJXJzaSksCSVyOGIiKTsKCV9fYXNtX18oIm1vdmIgJXI4YiwgKCVyZGkpIik7
CglfX2FzbV9fKCJpbmNxICVyZGkiKTsKCV9fYXNtX18oImluY3EgJXJzaSIpOwoJX19hc21fXygi
ZGVjbCAlZWN4Iik7CglfX2FzbV9fKCJqbnogNWIiKTsKCV9fYXNtX18oIjY6Iik7Cn0KCgp2b2lk
IG1haW4odm9pZCkKewogIGludCBpOwogIHRlc3RfaW5pdCgpOwogIHByaW50ZiAoIiUyM3MiLCAi
Iik7CiAgcHJpbnRmICgiXHQlc1x0JXNcbiIsICJtZW1jcHlfb3JpZyIsICJtZW1jcHlfbmV3Iik7
CiAgICBmb3IoaSA9IDA7IGk8IDEyODtpPSAxICsgaSkgewogICAgIGRvX3Rlc3QoMCwgMCwgaSk7
CiAgICAgZG9fdGVzdCgwLCA4LCBpKTsKICAgICBkb190ZXN0KDQsIDE2LCBpKTsKICAgICBkb190
ZXN0KDAsIDE2LCBpKTsKICAgIH0KICAgICBkb190ZXN0KDQsIDE2LCAxMDI0KTsKICAgICBkb190
ZXN0KDAsIDAsIDEwMjQpOwogICAgIGRvX3Rlc3QoNCwgMTYsIDQwOTYpOwogICAgIGRvX3Rlc3Qo
MCwgOCwgNDA5Nik7CiAgICAgZG9fdGVzdCgwLCAxNiwgNDA5Nik7CiAgICAgZG9fdGVzdCgwLCA2
NCwgNDA5Nik7CiAgICAgZG9fdGVzdCgwLCAwLCA0MDk2KTsKICAgICBkb190ZXN0KDE2LCAwLCA0
MDk2KjIpOwogICAgIGRvX3Rlc3QoMCwgMTYsIDQwOTYqMik7CglyZXR1cm4gOwp9Cg==

--_002_C10D3FB0CD45994C8A51FEC1227CE22F09F023CE6Bshsmsx502ccrc_--
