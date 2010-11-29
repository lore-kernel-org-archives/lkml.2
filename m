Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0K2TbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:31:02 -0500
Received: from grimli.r00tworld.net ([83.169.44.195]:46464 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0K2TbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:31:00 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 14:31:00 EST
From: Mathias Krause <minipli@googlemail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Huang Ying <ying.huang@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: linux-next: Tree for November 29 (aesni-intel)
Date: Mon, 29 Nov 2010 20:21:45 +0100
Message-Id: <1291058505-9384-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4CF3F6CB.8080904@oracle.com>
References: <4CF3F6CB.8080904@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2010, 19:54 Randy Dunlap wrote:
> On 11/29/10 10:26, Mathias Krause wrote:
>> On 29.11.2010, 17:31 Randy Dunlap wrote:
>>> On Mon, 29 Nov 2010 14:03:35 +1100 Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> Changes since 20101126:
>>>
>>>
>>> on i386 builds, I get tons of these (and more) errors:
>>>
>>> arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
>>> arch/x86/crypto/aesni-intel_asm.S:842: Error: bad register name `%r13'
>>> arch/x86/crypto/aesni-intel_asm.S:843: Error: bad register name `%r14'
>>> arch/x86/crypto/aesni-intel_asm.S:844: Error: bad register name `%rsp'
>>> arch/x86/crypto/aesni-intel_asm.S:849: Error: bad register name `%rsp'
>>> arch/x86/crypto/aesni-intel_asm.S:850: Error: bad register name `%rsp'
>>> arch/x86/crypto/aesni-intel_asm.S:851: Error: bad register name `%r9'
>>>
>>> even though the kernel .config file says:
>>>
>>> CONFIG_CRYPTO_AES=m
>>> CONFIG_CRYPTO_AES_586=m
>>> CONFIG_CRYPTO_AES_NI_INTEL=m
>>>
>>> Should arch/x86/crypto/aesni-intel_asm.S be testing
>>> #ifdef CONFIG_X86_64
>>> instead of
>>> #ifdef __x86_64__
>>> or does that not matter?
>>>
>>> or is this a toolchain issue?
>> 
>> Well, __x86_64__ should be a build-in define of the compiler while
>> CONFIG_X86_64 is defined for 64 bit builds in include/generated/autoconf.h.
>> So by using the latter we should be on the safe side but if your compiler
>> defines __x86_64__ for 32-bit builds it's simply broken. Also git grep
>> showed quite a few more places using __x86_64__ so those would miscompile on
>> your toolchain, too.
>> 
>> But it looks like linux-next is just missing
>> 559ad0ff1368baea14dbc3207d55b02bd69bda4b from Herbert's git repo at
>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.
>> That should fix the build issue.
>
> The build problem still happens when that patch is applied.

That's weird. So it must be something with your toolchain.
Can you please post the output of the following commands?:

$ touch /tmp/null.c; cc -m32 -dD -E /tmp/null.c | grep -E 'x86|i.86'
$ touch /tmp/null.c; cc -m64 -dD -E /tmp/null.c | grep -E 'x86|i.86'

Beside that, the patch below should fix the issue with your toolchain by using
CONFIG_X86_64 instead of __x86_64__.

Sorry for the inconvenience,
Mathias

[PATCH] crypto: aesni-intel - Fixed another build error on x86-32

It looks like not all compilers undef __x86_64__ for 32-bit builds so
switch to CONFIG_X86_64 to test if we're building for 64 or 32 bit.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/aesni-intel_asm.S |   40 ++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index d528fde..de0ec32 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -32,7 +32,7 @@
 #include <linux/linkage.h>
 #include <asm/inst.h>
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 .data
 POLY:   .octa 0xC2000000000000000000000000000001
 TWOONE: .octa 0x00000001000000000000000000000001
@@ -105,7 +105,7 @@ enc:        .octa 0x2
 #define CTR	%xmm11
 #define INC	%xmm12
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 #define AREG	%rax
 #define KEYP	%rdi
 #define OUTP	%rsi
@@ -132,7 +132,7 @@ enc:        .octa 0x2
 #endif
 
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 /* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
 *
 *
@@ -1333,7 +1333,7 @@ _key_expansion_256b:
  *                   unsigned int key_len)
  */
 ENTRY(aesni_set_key)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl KEYP
 	movl 8(%esp), KEYP		# ctx
 	movl 12(%esp), UKEYP		# in_key
@@ -1435,7 +1435,7 @@ ENTRY(aesni_set_key)
 	cmp TKEYP, KEYP
 	jb .Ldec_key_loop
 	xor AREG, AREG
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KEYP
 #endif
 	ret
@@ -1444,7 +1444,7 @@ ENTRY(aesni_set_key)
  * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_enc)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl KEYP
 	pushl KLEN
 	movl 12(%esp), KEYP
@@ -1455,7 +1455,7 @@ ENTRY(aesni_enc)
 	movups (INP), STATE		# input
 	call _aesni_enc1
 	movups STATE, (OUTP)		# output
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KLEN
 	popl KEYP
 #endif
@@ -1630,7 +1630,7 @@ _aesni_enc4:
  * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_dec)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl KEYP
 	pushl KLEN
 	movl 12(%esp), KEYP
@@ -1642,7 +1642,7 @@ ENTRY(aesni_dec)
 	movups (INP), STATE		# input
 	call _aesni_dec1
 	movups STATE, (OUTP)		#output
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KLEN
 	popl KEYP
 #endif
@@ -1818,7 +1818,7 @@ _aesni_dec4:
  *		      size_t len)
  */
 ENTRY(aesni_ecb_enc)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl LEN
 	pushl KEYP
 	pushl KLEN
@@ -1863,7 +1863,7 @@ ENTRY(aesni_ecb_enc)
 	cmp $16, LEN
 	jge .Lecb_enc_loop1
 .Lecb_enc_ret:
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KLEN
 	popl KEYP
 	popl LEN
@@ -1875,7 +1875,7 @@ ENTRY(aesni_ecb_enc)
  *		      size_t len);
  */
 ENTRY(aesni_ecb_dec)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl LEN
 	pushl KEYP
 	pushl KLEN
@@ -1921,7 +1921,7 @@ ENTRY(aesni_ecb_dec)
 	cmp $16, LEN
 	jge .Lecb_dec_loop1
 .Lecb_dec_ret:
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KLEN
 	popl KEYP
 	popl LEN
@@ -1933,7 +1933,7 @@ ENTRY(aesni_ecb_dec)
  *		      size_t len, u8 *iv)
  */
 ENTRY(aesni_cbc_enc)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl IVP
 	pushl LEN
 	pushl KEYP
@@ -1961,7 +1961,7 @@ ENTRY(aesni_cbc_enc)
 	jge .Lcbc_enc_loop
 	movups STATE, (IVP)
 .Lcbc_enc_ret:
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KLEN
 	popl KEYP
 	popl LEN
@@ -1974,7 +1974,7 @@ ENTRY(aesni_cbc_enc)
  *		      size_t len, u8 *iv)
  */
 ENTRY(aesni_cbc_dec)
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	pushl IVP
 	pushl LEN
 	pushl KEYP
@@ -1998,7 +1998,7 @@ ENTRY(aesni_cbc_dec)
 	movaps IN1, STATE1
 	movups 0x10(INP), IN2
 	movaps IN2, STATE2
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	movups 0x20(INP), IN3
 	movaps IN3, STATE3
 	movups 0x30(INP), IN4
@@ -2011,7 +2011,7 @@ ENTRY(aesni_cbc_dec)
 #endif
 	call _aesni_dec4
 	pxor IV, STATE1
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 	pxor IN1, STATE2
 	pxor IN2, STATE3
 	pxor IN3, STATE4
@@ -2049,7 +2049,7 @@ ENTRY(aesni_cbc_dec)
 .Lcbc_dec_ret:
 	movups IV, (IVP)
 .Lcbc_dec_just_ret:
-#ifndef __x86_64__
+#ifndef CONFIG_X86_64
 	popl KLEN
 	popl KEYP
 	popl LEN
@@ -2057,7 +2057,7 @@ ENTRY(aesni_cbc_dec)
 #endif
 	ret
 
-#ifdef __x86_64__
+#ifdef CONFIG_X86_64
 .align 16
 .Lbswap_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
-- 
1.5.6.5

