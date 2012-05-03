Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2ECE5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 00:57:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2ECE5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 00:57:47 -0400
Date: Thu, 3 May 2012 14:57:44 +1000
From: NeilBrown <neilb@suse.de>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86: use kernel_fpu_[begin|end] for RAID5
 checksumming
Message-ID: <20120503145744.4e425dd5@notabene.brown>
In-Reply-To: <1335829875-18481-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1335829875-18481-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n2C93Z1d/fBj/sdDZURQlfL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n2C93Z1d/fBj/sdDZURQlfL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 16:51:15 -0700 Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:

> Currently, the SSE and AVX xor functions manually save and restore the
> [X|Y]MM registers. Instead, we should use kernel_fpu_[begin|end].
>=20
> This patch sacrifices some throughput,~5-10% for AVX and ~2% for SSE, in
> exchange for safety against future FPU corruption bugs.
>=20
> Patch applies to md/for-next.
>=20
> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>

Hi Jim,
 I'm really not able to assess the validity of this patch.
I don't doubt it exactly, but I'd value a second opinion just to be confide=
nt.
Peter: can you review and comment?

Thanks,
NeilBrown


> ---
>  arch/x86/include/asm/xor_32.h  |   56 +++++-----------------------------=
--
>  arch/x86/include/asm/xor_64.h  |   61 ++++++----------------------------=
-----
>  arch/x86/include/asm/xor_avx.h |   55 ++++++++--------------------------=
--
>  3 files changed, 30 insertions(+), 142 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
> index 4545708..aabd585 100644
> --- a/arch/x86/include/asm/xor_32.h
> +++ b/arch/x86/include/asm/xor_32.h
> @@ -534,38 +534,6 @@ static struct xor_block_template xor_block_p5_mmx =
=3D {
>   * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
>   */
> =20
> -#define XMMS_SAVE				\
> -do {						\
> -	preempt_disable();			\
> -	cr0 =3D read_cr0();			\
> -	clts();					\
> -	asm volatile(				\
> -		"movups %%xmm0,(%0)	;\n\t"	\
> -		"movups %%xmm1,0x10(%0)	;\n\t"	\
> -		"movups %%xmm2,0x20(%0)	;\n\t"	\
> -		"movups %%xmm3,0x30(%0)	;\n\t"	\
> -		:				\
> -		: "r" (xmm_save) 		\
> -		: "memory");			\
> -} while (0)
> -
> -#define XMMS_RESTORE				\
> -do {						\
> -	asm volatile(				\
> -		"sfence			;\n\t"	\
> -		"movups (%0),%%xmm0	;\n\t"	\
> -		"movups 0x10(%0),%%xmm1	;\n\t"	\
> -		"movups 0x20(%0),%%xmm2	;\n\t"	\
> -		"movups 0x30(%0),%%xmm3	;\n\t"	\
> -		:				\
> -		: "r" (xmm_save)		\
> -		: "memory");			\
> -	write_cr0(cr0);				\
> -	preempt_enable();			\
> -} while (0)
> -
> -#define ALIGN16 __attribute__((aligned(16)))
> -
>  #define OFFS(x)		"16*("#x")"
>  #define PF_OFFS(x)	"256+16*("#x")"
>  #define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
> @@ -587,10 +555,8 @@ static void
>  xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
>  {
>  	unsigned long lines =3D bytes >> 8;
> -	char xmm_save[16*4] ALIGN16;
> -	int cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -633,7 +599,7 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, uns=
igned long *p2)
>  	:
>  	: "memory");
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static void
> @@ -641,10 +607,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, un=
signed long *p2,
>  	  unsigned long *p3)
>  {
>  	unsigned long lines =3D bytes >> 8;
> -	char xmm_save[16*4] ALIGN16;
> -	int cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -694,7 +658,7 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, uns=
igned long *p2,
>  	:
>  	: "memory" );
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static void
> @@ -702,10 +666,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, un=
signed long *p2,
>  	  unsigned long *p3, unsigned long *p4)
>  {
>  	unsigned long lines =3D bytes >> 8;
> -	char xmm_save[16*4] ALIGN16;
> -	int cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -762,7 +724,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, uns=
igned long *p2,
>  	:
>  	: "memory" );
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static void
> @@ -770,10 +732,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, un=
signed long *p2,
>  	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
>  {
>  	unsigned long lines =3D bytes >> 8;
> -	char xmm_save[16*4] ALIGN16;
> -	int cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	/* Make sure GCC forgets anything it knows about p4 or p5,
>  	   such that it won't pass to the asm volatile below a
> @@ -850,7 +810,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, uns=
igned long *p2,
>  	   like assuming they have some legal value.  */
>  	asm("" : "=3Dr" (p4), "=3Dr" (p5));
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static struct xor_block_template xor_block_pIII_sse =3D {
> diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
> index b9b2323..715f904 100644
> --- a/arch/x86/include/asm/xor_64.h
> +++ b/arch/x86/include/asm/xor_64.h
> @@ -34,41 +34,7 @@
>   * no advantages to be gotten from x86-64 here anyways.
>   */
> =20
> -typedef struct {
> -	unsigned long a, b;
> -} __attribute__((aligned(16))) xmm_store_t;
> -
> -/* Doesn't use gcc to save the XMM registers, because there is no easy w=
ay to
> -   tell it to do a clts before the register saving. */
> -#define XMMS_SAVE				\
> -do {						\
> -	preempt_disable();			\
> -	asm volatile(				\
> -		"movq %%cr0,%0		;\n\t"	\
> -		"clts			;\n\t"	\
> -		"movups %%xmm0,(%1)	;\n\t"	\
> -		"movups %%xmm1,0x10(%1)	;\n\t"	\
> -		"movups %%xmm2,0x20(%1)	;\n\t"	\
> -		"movups %%xmm3,0x30(%1)	;\n\t"	\
> -		: "=3D&r" (cr0)			\
> -		: "r" (xmm_save) 		\
> -		: "memory");			\
> -} while (0)
> -
> -#define XMMS_RESTORE				\
> -do {						\
> -	asm volatile(				\
> -		"sfence			;\n\t"	\
> -		"movups (%1),%%xmm0	;\n\t"	\
> -		"movups 0x10(%1),%%xmm1	;\n\t"	\
> -		"movups 0x20(%1),%%xmm2	;\n\t"	\
> -		"movups 0x30(%1),%%xmm3	;\n\t"	\
> -		"movq 	%0,%%cr0	;\n\t"	\
> -		:				\
> -		: "r" (cr0), "r" (xmm_save)	\
> -		: "memory");			\
> -	preempt_enable();			\
> -} while (0)
> +#include <asm/i387.h>
> =20
>  #define OFFS(x)		"16*("#x")"
>  #define PF_OFFS(x)	"256+16*("#x")"
> @@ -91,10 +57,8 @@ static void
>  xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
>  {
>  	unsigned int lines =3D bytes >> 8;
> -	unsigned long cr0;
> -	xmm_store_t xmm_save[4];
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -135,7 +99,7 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, unsi=
gned long *p2)
>  	: [inc] "r" (256UL)
>  	: "memory");
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static void
> @@ -143,10 +107,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, un=
signed long *p2,
>  	  unsigned long *p3)
>  {
>  	unsigned int lines =3D bytes >> 8;
> -	xmm_store_t xmm_save[4];
> -	unsigned long cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -194,7 +156,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, uns=
igned long *p2,
>  	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
>  	: [inc] "r" (256UL)
>  	: "memory");
> -	XMMS_RESTORE;
> +
> +	kernel_fpu_end();
>  }
> =20
>  static void
> @@ -202,10 +165,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, un=
signed long *p2,
>  	  unsigned long *p3, unsigned long *p4)
>  {
>  	unsigned int lines =3D bytes >> 8;
> -	xmm_store_t xmm_save[4];
> -	unsigned long cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -261,7 +222,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, uns=
igned long *p2,
>  	: [inc] "r" (256UL)
>  	: "memory" );
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static void
> @@ -269,10 +230,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, un=
signed long *p2,
>  	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
>  {
>  	unsigned int lines =3D bytes >> 8;
> -	xmm_store_t xmm_save[4];
> -	unsigned long cr0;
> =20
> -	XMMS_SAVE;
> +	kernel_fpu_begin();
> =20
>  	asm volatile(
>  #undef BLOCK
> @@ -336,7 +295,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, uns=
igned long *p2,
>  	: [inc] "r" (256UL)
>  	: "memory");
> =20
> -	XMMS_RESTORE;
> +	kernel_fpu_end();
>  }
> =20
>  static struct xor_block_template xor_block_sse =3D {
> diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_av=
x.h
> index 2510d35..8d2795a 100644
> --- a/arch/x86/include/asm/xor_avx.h
> +++ b/arch/x86/include/asm/xor_avx.h
> @@ -17,35 +17,8 @@
> =20
>  #ifdef CONFIG_AS_AVX
> =20
> -#include <linux/compiler.h>
>  #include <asm/i387.h>
> =20
> -#define ALIGN32 __aligned(32)
> -
> -#define YMM_SAVED_REGS 4
> -
> -#define YMMS_SAVE \
> -do { \
> -	preempt_disable(); \
> -	cr0 =3D read_cr0(); \
> -	clts(); \
> -	asm volatile("vmovaps %%ymm0, %0" : "=3Dm" (ymm_save[0]) : : "memory");=
 \
> -	asm volatile("vmovaps %%ymm1, %0" : "=3Dm" (ymm_save[32]) : : "memory")=
; \
> -	asm volatile("vmovaps %%ymm2, %0" : "=3Dm" (ymm_save[64]) : : "memory")=
; \
> -	asm volatile("vmovaps %%ymm3, %0" : "=3Dm" (ymm_save[96]) : : "memory")=
; \
> -} while (0);
> -
> -#define YMMS_RESTORE \
> -do { \
> -	asm volatile("sfence" : : : "memory"); \
> -	asm volatile("vmovaps %0, %%ymm3" : : "m" (ymm_save[96])); \
> -	asm volatile("vmovaps %0, %%ymm2" : : "m" (ymm_save[64])); \
> -	asm volatile("vmovaps %0, %%ymm1" : : "m" (ymm_save[32])); \
> -	asm volatile("vmovaps %0, %%ymm0" : : "m" (ymm_save[0])); \
> -	write_cr0(cr0); \
> -	preempt_enable(); \
> -} while (0);
> -
>  #define BLOCK4(i) \
>  		BLOCK(32 * i, 0) \
>  		BLOCK(32 * (i + 1), 1) \
> @@ -60,10 +33,9 @@ do { \
> =20
>  static void xor_avx_2(unsigned long bytes, unsigned long *p0, unsigned l=
ong *p1)
>  {
> -	unsigned long cr0, lines =3D bytes >> 9;
> -	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
> +	unsigned long lines =3D bytes >> 9;
> =20
> -	YMMS_SAVE
> +	kernel_fpu_begin();
> =20
>  	while (lines--) {
>  #undef BLOCK
> @@ -82,16 +54,15 @@ do { \
>  		p1 =3D (unsigned long *)((uintptr_t)p1 + 512);
>  	}
> =20
> -	YMMS_RESTORE
> +	kernel_fpu_end();
>  }
> =20
>  static void xor_avx_3(unsigned long bytes, unsigned long *p0, unsigned l=
ong *p1,
>  	unsigned long *p2)
>  {
> -	unsigned long cr0, lines =3D bytes >> 9;
> -	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
> +	unsigned long lines =3D bytes >> 9;
> =20
> -	YMMS_SAVE
> +	kernel_fpu_begin();
> =20
>  	while (lines--) {
>  #undef BLOCK
> @@ -113,16 +84,15 @@ do { \
>  		p2 =3D (unsigned long *)((uintptr_t)p2 + 512);
>  	}
> =20
> -	YMMS_RESTORE
> +	kernel_fpu_end();
>  }
> =20
>  static void xor_avx_4(unsigned long bytes, unsigned long *p0, unsigned l=
ong *p1,
>  	unsigned long *p2, unsigned long *p3)
>  {
> -	unsigned long cr0, lines =3D bytes >> 9;
> -	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
> +	unsigned long lines =3D bytes >> 9;
> =20
> -	YMMS_SAVE
> +	kernel_fpu_begin();
> =20
>  	while (lines--) {
>  #undef BLOCK
> @@ -147,16 +117,15 @@ do { \
>  		p3 =3D (unsigned long *)((uintptr_t)p3 + 512);
>  	}
> =20
> -	YMMS_RESTORE
> +	kernel_fpu_end();
>  }
> =20
>  static void xor_avx_5(unsigned long bytes, unsigned long *p0, unsigned l=
ong *p1,
>  	unsigned long *p2, unsigned long *p3, unsigned long *p4)
>  {
> -	unsigned long cr0, lines =3D bytes >> 9;
> -	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
> +	unsigned long lines =3D bytes >> 9;
> =20
> -	YMMS_SAVE
> +	kernel_fpu_begin();
> =20
>  	while (lines--) {
>  #undef BLOCK
> @@ -184,7 +153,7 @@ do { \
>  		p4 =3D (unsigned long *)((uintptr_t)p4 + 512);
>  	}
> =20
> -	YMMS_RESTORE
> +	kernel_fpu_end();
>  }
> =20
>  static struct xor_block_template xor_block_avx =3D {


--Sig_/n2C93Z1d/fBj/sdDZURQlfL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6IQSDnsnt1WYoG5AQIomg//RyY7UPNG1WrmYrbJHCBxzkG+mjz26sNJ
QmaKMgAPTjUXLt1RQRtRHZi1epMTJn0fMtUYU6/9UYYVyDQ9LycJV9F98GuEyeD8
O8Bh3zcnhtwu73bYI2Yxsen2kghwM2Blt/lMg5a1fAcF0fkwem+WsEhoXRWERXjT
qbP13K/Lxo1nz4zk1KoohSqGBCJfjKRj3b0T3QPWEWX80LGgCmrc1Gy67vGXNB3U
iz1KdU34PvUVQpYGJgDSLTPOl7/paqngpZrUP4aHuIkQPSxW7pTwx7JMtfUXMKTu
ZjlVfDR0de3ncFIZFn4D4tCCddU4DU78wYbbGJzzTFwgJuwMHSPPSUfjRYS+LXvR
nQcirnXz2VTsBxwbfj7DZCksdisYVIxauWIhvnz2IAs+iggx480T8AdcpJvkwUaN
xG3xCnFES5znLu+lXQZqB9/6Q6x4Gm4gwgWd+8GwFUbpNYAGIT0ulBsBr3vM16/P
Y1LaHc9Z6O9Deyu/veZXwlMETc+3zXNgkH3c0aA7XQ7FJqsFempRC4Pk7P6fpeD9
XCtKEc1ELKOpBTwSnC1IkInQ/CX3qFh71Pkx6LRCbKdpUZB8Wav8ynjhn1Uv12b0
79BMZYXutDy1rtvpNbRJedaodgv9T8XuYv4g7Ah9J69HuUdpRuxDZPxznaM2+Goa
s+h47CFitfY=
=Fr8v
-----END PGP SIGNATURE-----

--Sig_/n2C93Z1d/fBj/sdDZURQlfL--
