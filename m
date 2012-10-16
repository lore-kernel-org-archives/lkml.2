Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2JPCUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:20:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40677 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2JPCUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:20:50 -0400
Date: Tue, 16 Oct 2012 13:20:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the cortex tree with Linus' tree
Message-Id: <20121016132041.92051657ab1cb802ddadad15@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Oct_2012_13_20_41_+1100_4lGerLlr4z/z1WU/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Oct_2012_13_20_41_+1100_4lGerLlr4z/z1WU/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

Today's linux-next merge of the cortex tree got a conflict in
arch/arm/include/asm/ptrace.h between commit cb8db5d4578a ("UAPI:
(Scripted) Disintegrate arch/arm/include/asm") from Linus' tree and
commit 69bc3631744a ("Cortex-M3: Add base support for Cortex-M3") from
the cortex tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

I also had to add this merge fix patch:

diff --git a/arch/arm/include/uapi/asm/ptrace.h b/arch/arm/include/uapi/asm=
/ptrace.h
index 96ee092..b71a3f8 100644
--- a/arch/arm/include/uapi/asm/ptrace.h
+++ b/arch/arm/include/uapi/asm/ptrace.h
@@ -49,13 +49,15 @@
 #define SYSTEM_MODE	0x0000001f
 #define MODE32_BIT	0x00000010
 #define MODE_MASK	0x0000001f
-#define PSR_T_BIT	0x00000020
-#define PSR_F_BIT	0x00000040
-#define PSR_I_BIT	0x00000080
-#define PSR_A_BIT	0x00000100
-#define PSR_E_BIT	0x00000200
-#define PSR_J_BIT	0x01000000
-#define PSR_Q_BIT	0x08000000
+#define V4_PSR_T_BIT	0x00000020	/* >=3D V4T, but not V7M */
+#define V7M_PSR_T_BIT	0x01000000
+#define PSR_T_BIT	V4_PSR_T_BIT
+#define PSR_F_BIT	0x00000040	/* >=3D V4, but not V7M */
+#define PSR_I_BIT	0x00000080	/* >=3D V4, but not V7M */
+#define PSR_A_BIT	0x00000100	/* >=3D V6, but not V7M */
+#define PSR_E_BIT	0x00000200	/* >=3D V6, but not V7M */
+#define PSR_J_BIT	0x01000000	/* >=3D V5J, but not V7M */
+#define PSR_Q_BIT	0x08000000	/* >=3D V5E, including V7M */
 #define PSR_V_BIT	0x10000000
 #define PSR_C_BIT	0x20000000
 #define PSR_Z_BIT	0x40000000
@@ -125,6 +127,7 @@ struct pt_regs {
 #define ARM_r1		uregs[1]
 #define ARM_r0		uregs[0]
 #define ARM_ORIG_r0	uregs[17]
+#define ARM_EXC_RET	uregs[18]
=20
 /*
  * The size of the user-visible VFP state as seen by PTRACE_GET/SETVFPREGS

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/ptrace.h
index 3d52ee1,090fea7..0000000
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@@ -10,12 -10,156 +10,29 @@@
  #ifndef __ASM_ARM_PTRACE_H
  #define __ASM_ARM_PTRACE_H
 =20
 -#include <asm/hwcap.h>
 +#include <uapi/asm/ptrace.h>
 =20
 -#define PTRACE_GETREGS		12
 -#define PTRACE_SETREGS		13
 -#define PTRACE_GETFPREGS	14
 -#define PTRACE_SETFPREGS	15
 -/* PTRACE_ATTACH is 16 */
 -/* PTRACE_DETACH is 17 */
 -#define PTRACE_GETWMMXREGS	18
 -#define PTRACE_SETWMMXREGS	19
 -/* 20 is unused */
 -#define PTRACE_OLDSETOPTIONS	21
 -#define PTRACE_GET_THREAD_AREA	22
 -#define PTRACE_SET_SYSCALL	23
 -/* PTRACE_SYSCALL is 24 */
 -#define PTRACE_GETCRUNCHREGS	25
 -#define PTRACE_SETCRUNCHREGS	26
 -#define PTRACE_GETVFPREGS	27
 -#define PTRACE_SETVFPREGS	28
 -#define PTRACE_GETHBPREGS	29
 -#define PTRACE_SETHBPREGS	30
 -
 -/*
 - * PSR bits
 - * Note on V7M there is no mode contained in the PSR
 - */
 -#define USR26_MODE	0x00000000
 -#define FIQ26_MODE	0x00000001
 -#define IRQ26_MODE	0x00000002
 -#define SVC26_MODE	0x00000003
+ #if defined(__KERNEL__) && defined(CONFIG_CPU_V7M)
+ /*
+  * Use 0 here to get code right that creates a userspace
+  * or kernel space thread
+  */
++#undef USR_MODE
++#undef SVC_MODE
++#undef PSR_T_BIT
+ #define USR_MODE	0x00000000
+ #define SVC_MODE	0x00000000
 -#else
 -#define USR_MODE	0x00000010
 -#define SVC_MODE	0x00000013
 -#endif
 -#define FIQ_MODE	0x00000011
 -#define IRQ_MODE	0x00000012
 -#define ABT_MODE	0x00000017
 -#define UND_MODE	0x0000001b
 -#define SYSTEM_MODE	0x0000001f
 -#define MODE32_BIT	0x00000010
 -#define MODE_MASK	0x0000001f
 -
 -#define V4_PSR_T_BIT	0x00000020	/* >=3D V4T, but not V7M */
 -#define V7M_PSR_T_BIT	0x01000000
 -#if defined(__KERNEL__) && defined(CONFIG_CPU_V7M)
+ #define PSR_T_BIT	V7M_PSR_T_BIT
 -#else
 -/* for compatibility */
 -#define PSR_T_BIT	V4_PSR_T_BIT
 -#endif
 -
 -#define PSR_F_BIT	0x00000040	/* >=3D V4, but not V7M */
 -#define PSR_I_BIT	0x00000080	/* >=3D V4, but not V7M */
 -#define PSR_A_BIT	0x00000100	/* >=3D V6, but not V7M */
 -#define PSR_E_BIT	0x00000200	/* >=3D V6, but not V7M */
 -#define PSR_J_BIT	0x01000000	/* >=3D V5J, but not V7M */
 -#define PSR_Q_BIT	0x08000000	/* >=3D V5E, including V7M */
 -#define PSR_V_BIT	0x10000000
 -#define PSR_C_BIT	0x20000000
 -#define PSR_Z_BIT	0x40000000
 -#define PSR_N_BIT	0x80000000
 -
 -/*
 - * Groups of PSR bits
 - */
 -#define PSR_f		0xff000000	/* Flags		*/
 -#define PSR_s		0x00ff0000	/* Status		*/
 -#define PSR_x		0x0000ff00	/* Extension		*/
 -#define PSR_c		0x000000ff	/* Control		*/
 -
 -/*
 - * ARMv7 groups of PSR bits
 - */
 -#define APSR_MASK	0xf80f0000	/* N, Z, C, V, Q and GE flags */
 -#define PSR_ISET_MASK	0x01000010	/* ISA state (J, T) mask */
 -#define PSR_IT_MASK	0x0600fc00	/* If-Then execution state mask */
 -#define PSR_ENDIAN_MASK	0x00000200	/* Endianness state mask */
 -
 -/*
 - * Default endianness state
 - */
 -#ifdef CONFIG_CPU_ENDIAN_BE8
 -#define PSR_ENDSTATE	PSR_E_BIT
 -#else
 -#define PSR_ENDSTATE	0
+ #endif
+=20
 -/*=20
 - * These are 'magic' values for PTRACE_PEEKUSR that return info about whe=
re a
 - * process is located in memory.
 - */
 -#define PT_TEXT_ADDR		0x10000
 -#define PT_DATA_ADDR		0x10004
 -#define PT_TEXT_END_ADDR	0x10008
 -
  #ifndef __ASSEMBLY__
 -
 -/*
 - * This struct defines the way the registers are stored on the
 - * stack during a system call.  Note that sizeof(struct pt_regs)
 - * has to be a multiple of 8.
 - */
 -#ifndef __KERNEL__
 -struct pt_regs {
 -	long uregs[18];
 -};
 -#else /* __KERNEL__ */
  struct pt_regs {
+ #ifdef CONFIG_CPU_V7M
+ 	unsigned long uregs[20];
+ #else
  	unsigned long uregs[18];
+ #endif
  };
 -#endif /* __KERNEL__ */
 -
 -#define ARM_cpsr	uregs[16]
 -#define ARM_pc		uregs[15]
 -#define ARM_lr		uregs[14]
 -#define ARM_sp		uregs[13]
 -#define ARM_ip		uregs[12]
 -#define ARM_fp		uregs[11]
 -#define ARM_r10		uregs[10]
 -#define ARM_r9		uregs[9]
 -#define ARM_r8		uregs[8]
 -#define ARM_r7		uregs[7]
 -#define ARM_r6		uregs[6]
 -#define ARM_r5		uregs[5]
 -#define ARM_r4		uregs[4]
 -#define ARM_r3		uregs[3]
 -#define ARM_r2		uregs[2]
 -#define ARM_r1		uregs[1]
 -#define ARM_r0		uregs[0]
 -#define ARM_ORIG_r0	uregs[17]
 -#define ARM_EXC_RET	uregs[18]
 -
 -/*
 - * The size of the user-visible VFP state as seen by PTRACE_GET/SETVFPREGS
 - * and core dumps.
 - */
 -#define ARM_VFPREGS_SIZE ( 32 * 8 /*fpregs*/ + 4 /*fpscr*/ )
 -
 -#ifdef __KERNEL__
 =20
  #define user_mode(regs)	\
  	(((regs)->ARM_cpsr & 0xf) =3D=3D 0)

--Signature=_Tue__16_Oct_2012_13_20_41_+1100_4lGerLlr4z/z1WU/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfMR5AAoJEECxmPOUX5FEy9AP/jldJLlmumCYDezF7lB+ywO5
M35FqnoacJrOtY1g5ieDYCz+D/1vmlFS1EW1dOCyj67AcNcy5kw62Kzl3Zj7V2nM
dDQu+6p3kMej58TyZbJg6CYcZpUnVIkLKi/T0SyPAgCJNL8PNg636CtJSdU3RcmI
uF3OTXcL0OrFAQRAXVDyG4x+sMDmMGiWF86slbP+8xwwjgzZN5SI24gkaI1p7euv
2p0WtHFda8mTmRM2yV0kBciXlldZfVmBZgZ8BohZApRYC3f+j/tI4EmjYogy/yZQ
IURQxWUS1DQYWjhAJHUAgefgTtmzr7DUE72JD/oSj1K25X/Kg0DnTv5dhtcsIdM+
a2KlK1epc6dy5MJKRcwgxRXeM2XV5qrI3eoDAxEPAYS/NYwFEaff8lQYsOLA3DSX
gaTd2uzZuqBHwmhZye4BqZiOMxaOaJZ62S5L6yuOQEndHRwLMdFCDwx27J14PlEw
XLkWuHIjOYUXGO/YBR4t1+yopkXUVbg1UK3GM0nHlrPlrCMUrWwdLhqR9AkPvCgB
hbP/0se9/KwpOFaPlQ1DJU4YYLoC+804BvQWgIxlsFFXFzXeFi2t9+75VC7vwYyo
y4iP6wHvhKc8xLkH7vR52VLPB8cyV5CDi7qjLuIcL0t3EeexNGSMxW/7l97o7dsJ
vJu6LOVp20GSElHdRfJx
=v7SL
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Oct_2012_13_20_41_+1100_4lGerLlr4z/z1WU/--
