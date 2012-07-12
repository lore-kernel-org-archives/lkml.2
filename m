Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2GLD5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 23:57:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42322 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2GLD5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 23:57:50 -0400
Date: Thu, 12 Jul 2012 13:57:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bharat Bhushan <r65777@freescale.com>,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the kvm-ppc tree with the powerpc tree
Message-Id: <20120712135735.7678a50ffb107e3094af27b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jul_2012_13_57_35_+1000_42t3SwETbDx.TCP2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jul_2012_13_57_35_+1000_42t3SwETbDx.TCP2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
arch/powerpc/kvm/booke_interrupts.S between commit c75df6f96c59
("powerpc: Fix usage of register macros getting ready for %r0 change")
from the powerpc tree and commit fc372c0843b8 ("booke: Added crit/mc
exception handler for e500v2") from the kvm-ppc tree.

I fixed it up (see below - could do with checking) and can carry the fix
as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kvm/booke_interrupts.S
index 8fd4b2a,09456c4..0000000
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@@ -52,16 -53,21 +52,21 @@@
                         (1<<BOOKE_INTERRUPT_PROGRAM) | \
                         (1<<BOOKE_INTERRUPT_DTLB_MISS))
 =20
- .macro KVM_HANDLER ivor_nr
+ .macro KVM_HANDLER ivor_nr scratch srr0
  _GLOBAL(kvmppc_handler_\ivor_nr)
  	/* Get pointer to vcpu and record exit number. */
- 	mtspr	SPRN_SPRG_WSCRATCH0, r4
+ 	mtspr	\scratch , r4
  	mfspr	r4, SPRN_SPRG_RVCPU
 -	stw	r3, VCPU_GPR(r3)(r4)
 -	stw	r5, VCPU_GPR(r5)(r4)
 -	stw	r6, VCPU_GPR(r6)(r4)
++	stw	r3, VCPU_GPR(R3)(r4)
 +	stw	r5, VCPU_GPR(R5)(r4)
 +	stw	r6, VCPU_GPR(R6)(r4)
+ 	mfspr	r3, \scratch
  	mfctr	r5
- 	lis	r6, kvmppc_resume_host@h
 -	stw	r3, VCPU_GPR(r4)(r4)
++	stw	r3, VCPU_GPR(R4)(r4)
  	stw	r5, VCPU_CTR(r4)
+ 	mfspr	r3, \srr0
+ 	lis	r6, kvmppc_resume_host@h
+ 	stw	r3, VCPU_PC(r4)
  	li	r5, \ivor_nr
  	ori	r6, r6, kvmppc_resume_host@l
  	mtctr	r6
@@@ -99,12 -104,11 +103,11 @@@ _GLOBAL(kvmppc_handler_len
   *  r5: KVM exit number
   */
  _GLOBAL(kvmppc_resume_host)
- 	stw	r3, VCPU_GPR(R3)(r4)
  	mfcr	r3
  	stw	r3, VCPU_CR(r4)
 -	stw	r7, VCPU_GPR(r7)(r4)
 -	stw	r8, VCPU_GPR(r8)(r4)
 -	stw	r9, VCPU_GPR(r9)(r4)
 +	stw	r7, VCPU_GPR(R7)(r4)
 +	stw	r8, VCPU_GPR(R8)(r4)
 +	stw	r9, VCPU_GPR(R9)(r4)
 =20
  	li	r6, 1
  	slw	r6, r6, r5

--Signature=_Thu__12_Jul_2012_13_57_35_+1000_42t3SwETbDx.TCP2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/ksvAAoJEECxmPOUX5FEqCAP/3ISjJw9Hi7XbLji7GYzUJk4
aVFglFeFWKLyjZTlTL3ka8z9m3nvzgxIP5iIzmmg2fHSS2W7JfA9/S+PY7Ci5aD+
Qkp1rtz8WzsHq1Td75bs1RpZ5EfiKBuac30+YSKWykbempcOP5new8hpHXjq/pah
MF9BoPe0/fIKMad08NXPmp96OZwrs5mYwJSRVyZ3dLV1rj7Gk6KuOVaPpa/RGI5m
WsRF4ka3MrEwA2AJeW0/iqbqjZuokl4RY5y7dsZnWFacVRXZKGIyi165sgze3Sf6
hB96KKixpBo1vU7R+dsKDwzCs3F2qvXzTF/Gl6DNWZ7l9aR6KPchYIkrUPMISje/
OOl5Xku4sEoIUJMwbSgExyh66/l6EjsIRn4MmLxXhU7XkNrp11gKqEiLNDKGEwEm
5WiO1gaDEAsTUBiCqzHjAqypV20dA1UiMGdi0UsKyKUkw7LkLh2QVfRV8sitQ/Lm
uZCkv41w5KidzLS/ZlicG//9iPm2EGF9quJztzQl0JSFduzJ70HaVEyiimOaAO5W
NOBdLKfHcuRd/y70NFM3/5HMzn1B5DapVKd7ZhVs/dq8U4181QZHAiAuKxzuMxLg
zJL0yb461p1yFM6VtRdPu92wEU4AtO4tNoxHPvVf2Yne7WUtpJKKejXjgCRDZt4h
YVJYz7raMgIFZnqlKPJX
=etvw
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jul_2012_13_57_35_+1000_42t3SwETbDx.TCP2--
