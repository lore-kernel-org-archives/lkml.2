Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2GEFho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 01:37:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58804 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2GEFhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 01:37:43 -0400
Date: Thu, 5 Jul 2012 15:37:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the kvm-ppc tree with Linus' tree
Message-Id: <20120705153728.19e2318efa0cfb0eedecc4f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_15_37_28_+1000_YjxlVTSD630I0fVd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_15_37_28_+1000_YjxlVTSD630I0fVd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
arch/powerpc/kernel/entry_64.S between commit c58ce2b1e3c7 ("ppc64: fix
missing to check all bits of _TIF_USER_WORK_MASK in preempt") from Linus'
tree and commit bc8cc4993e19 ("PPC: use CURRENT_THREAD_INFO instead of
open coded assembly") from the kvm-ppc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kernel/entry_64.S
index cf38a17,ba943b9..0000000
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@@ -559,54 -558,27 +559,54 @@@ _GLOBAL(ret_from_except_lite
  	mtmsrd	r10,1		  /* Update machine state */
  #endif /* CONFIG_PPC_BOOK3E */
 =20
- 	clrrdi	r9,r1,THREAD_SHIFT	/* current_thread_info() */
 -#ifdef CONFIG_PREEMPT
+ 	CURRENT_THREAD_INFO(r9, r1)
 -	li	r0,_TIF_NEED_RESCHED	/* bits to check */
  	ld	r3,_MSR(r1)
  	ld	r4,TI_FLAGS(r9)
 -	/* Move MSR_PR bit in r3 to _TIF_SIGPENDING position in r0 */
 -	rlwimi	r0,r3,32+TIF_SIGPENDING-MSR_PR_LG,_TIF_SIGPENDING
 -	and.	r0,r4,r0	/* check NEED_RESCHED and maybe SIGPENDING */
 -	bne	do_work
 -
 -#else /* !CONFIG_PREEMPT */
 -	ld	r3,_MSR(r1)	/* Returning to user mode? */
  	andi.	r3,r3,MSR_PR
 -	beq	restore		/* if not, just restore regs and return */
 +	beq	resume_kernel
 =20
  	/* Check current_thread_info()->flags */
 +	andi.	r0,r4,_TIF_USER_WORK_MASK
 +	beq	restore
 +
 +	andi.	r0,r4,_TIF_NEED_RESCHED
 +	beq	1f
 +	bl	.restore_interrupts
 +	bl	.schedule
 +	b	.ret_from_except_lite
 +
 +1:	bl	.save_nvgprs
 +	bl	.restore_interrupts
 +	addi	r3,r1,STACK_FRAME_OVERHEAD
 +	bl	.do_notify_resume
 +	b	.ret_from_except
 +
 +resume_kernel:
 +#ifdef CONFIG_PREEMPT
 +	/* Check if we need to preempt */
 +	andi.	r0,r4,_TIF_NEED_RESCHED
 +	beq+	restore
 +	/* Check that preempt_count() =3D=3D 0 and interrupts are enabled */
 +	lwz	r8,TI_PREEMPT(r9)
 +	cmpwi	cr1,r8,0
 +	ld	r0,SOFTE(r1)
 +	cmpdi	r0,0
 +	crandc	eq,cr1*4+eq,eq
 +	bne	restore
 +
 +	/*
 +	 * Here we are preempting the current task. We want to make
 +	 * sure we are soft-disabled first
 +	 */
 +	SOFT_DISABLE_INTS(r3,r4)
 +1:	bl	.preempt_schedule_irq
 +
 +	/* Re-test flags and eventually loop */
- 	clrrdi	r9,r1,THREAD_SHIFT
+ 	CURRENT_THREAD_INFO(r9, r1)
  	ld	r4,TI_FLAGS(r9)
 -	andi.	r0,r4,_TIF_USER_WORK_MASK
 -	bne	do_work
 -#endif /* !CONFIG_PREEMPT */
 +	andi.	r0,r4,_TIF_NEED_RESCHED
 +	bne	1b
 +#endif /* CONFIG_PREEMPT */
 =20
  	.globl	fast_exc_return_irq
  fast_exc_return_irq:

--Signature=_Thu__5_Jul_2012_15_37_28_+1000_YjxlVTSD630I0fVd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9SgYAAoJEECxmPOUX5FE5TEP/jwozfX4TVhoqhThdEQI8w0W
oRscf1EedAzupKLj2rLiDZfe2AUlxCVOSY37CcoLBx87zVlXowTcHZkS3J6ihWtO
YsaZUMmd8fuTBfVppQOflAEzmXjYln8ye/XGgwij4cn8P3hmisPY+NhgudHMmvph
WES/Or9ZYf4ikAH6A413VivaTM2zy+IghboJ0vhhOx2mXBpMM0wT6fK0vAD7srex
ZqQ8mnTnSW5yyZ1O/B4hFowMlj2cTsoruxUV5UJ07SlUIvTQUsRb6fcIOQoM21Mu
e89lMTLy6uFV5wOT6CVFkkNSAOniO7eSGfiMLLFljgWyFU8muPcF2UDuB7d6rUM2
yQkveN8oTsVhY6GNDukrYARIOgs0PNGVmQDXvBjqm5gRVVsebst3U6kSw2ty7mcD
kplYcG7g87y2FgcsF5GQJNf8f2r845qY2nS0KlAyqAvcZylZ4nLIiMyI1Gk9bz9T
ijWmHPMfAtRUPCre81dW96+48RCuT6A6tMTZpOdolsflibHD8urPw1MlxreHKUvH
hYZx7r7H3bMKSJcIey64GkEv+WRY9vV4hVVoo8+1SpACm/YNO2mCIuW5/9V2RWyL
SNL18HTlWHWzwp1rFyRORgGeAVg46WRr6VrrI9alhwWsI/ydZPxuUBObjrIVzn6e
J/jngMB/sS/DMsbVFQyV
=O7Ve
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_15_37_28_+1000_YjxlVTSD630I0fVd--
