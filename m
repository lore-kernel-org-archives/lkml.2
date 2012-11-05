Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2KEEDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 23:03:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39788 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2KEEDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 23:03:19 -0500
Date: Mon, 5 Nov 2012 15:03:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the signal tree with the cortex tree
Message-Id: <20121105150307.05dc233ef299ab73df5dbf89@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Nov_2012_15_03_07_+1100_4k0_DeIE0Zk2J_R/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Nov_2012_15_03_07_+1100_4k0_DeIE0Zk2J_R/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/arm/kernel/process.c between commit 77a3018e38b9 ("Cortex-M3: Add
support for exception handling") from the cortex tree and commit
9e6479930021 ("arm: switch to generic fork/vfork/clone") from the signal
tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/process.c
index 585b9ab,4ab80bb..0000000
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@@ -384,14 -383,11 +384,15 @@@ copy_thread(unsigned long clone_flags,=20
 =20
  	memset(&thread->cpu_context, 0, sizeof(struct cpu_context_save));
 =20
- 	if (likely(regs)) {
- 		*childregs =3D *regs;
+ 	if (likely(!(p->flags & PF_KTHREAD))) {
+ 		*childregs =3D *current_pt_regs();
  		childregs->ARM_r0 =3D 0;
- 		childregs->ARM_sp =3D stack_start;
+ 		if (stack_start)
+ 			childregs->ARM_sp =3D stack_start;
 +#if defined CONFIG_CPU_V7M
 +		/* Return to Thread mode with Process stack */
 +		childregs->ARM_EXC_RET =3D 0xfffffffdUL;
 +#endif
  	} else {
  		memset(childregs, 0, sizeof(struct pt_regs));
  		thread->cpu_context.r4 =3D stk_sz;

--Signature=_Mon__5_Nov_2012_15_03_07_+1100_4k0_DeIE0Zk2J_R/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQlzp7AAoJEECxmPOUX5FEks8P/1/0l8k8SgkjS/k/kSGYUuOn
aJWoD1fYBYq4PiY8wnkjq2UYwi1OaDDWTkPj/vqerc8gwGJKGBJB6d+Qy8vGoict
zz9zC2Lx8k2LeSgDs7dIjYW+xP7pl12lkLp6GeotMPuLrs9mIQiHFw2AdKOG2BIb
40zxQ8fKHqIWY6pY5Tv2Q5N8Gy7KjrUXQ4Wki+Vd0C70uiOLuerBzrJebLIif+XG
EDGnV4RGTOY+yD9AXR0E2J52jwGxfy0QbxbZ3PpB6eC5cS7f07M5wYydrTs21YAA
scgo1QB5eStt3dhrHj3kBDO3/VUQTTC0iZlzUkrf8g2ksaI29rogtti7LwIlZjPj
XWzNcR9PspTLXW6XUHdGjg3wHzw8V7xIlliXYVQwGB4bsIpeDnT4THVmA8UL4aP6
M2RRKnnB+56H+uG4EXKLR0V4hSDnGn/pWtREG6azYlTH2jgIB9o35a38itWFp6G0
VNEUjiCOTB1xvEoSRQevmcmBYlxJOpnL2tiCze7gpP60toJx9jA/SIK2gqDsDmMU
7grt5Q12AD9RKVI9stUUGEWEgqbI9Dwh3bzDJrak+G/XFf53a3VH4LfngKAzfLUD
tk+sD0v8iCmMOvqZDm+FHWU0a+N+YWwxTedU54g+AqyzzW4jw/KIdo/8TrjG7D40
Ri3IM9GRR/hq6oLVUIGx
=KZwb
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Nov_2012_15_03_07_+1100_4k0_DeIE0Zk2J_R/--
