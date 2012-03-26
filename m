Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2CZAGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 20:06:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40613 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2CZAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 20:06:08 -0400
Date: Mon, 26 Mar 2012 11:05:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Jason Baron <jbaron@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20120326110550.5029ac4c49c2be2e2e0381cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Mar_2012_11_05_50_+1100_hKMFaWFe7P94N02z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Mar_2012_11_05_50_+1100_hKMFaWFe7P94N02z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/kernel/process.c between commit 909af768e888 ("coredump: remove
VM_ALWAYSDUMP flag") from the  tree and commit e19d478e808e ("ARM:
7294/1: vectors: use gate_vma for vectors user mapping") from the arm
tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/process.c
index d3eca45,1531480..0000000
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@@ -529,17 -531,36 +529,35 @@@ unsigned long arch_randomize_brk(struc
  #ifdef CONFIG_MMU
  /*
   * The vectors page is always readable from user space for the
-  * atomic helpers and the signal restart code.  Let's declare a mapping
-  * for it so it is visible through ptrace and /proc/<pid>/mem.
+  * atomic helpers and the signal restart code. Insert it into the
+  * gate_vma so that it is visible through ptrace and /proc/<pid>/mem.
   */
+ static struct vm_area_struct gate_vma;
 =20
- int vectors_user_mapping(void)
+ static int __init gate_vma_init(void)
  {
- 	struct mm_struct *mm =3D current->mm;
- 	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
- 				       VM_READ | VM_EXEC |
- 				       VM_MAYREAD | VM_MAYEXEC | VM_RESERVED,
- 				       NULL);
+ 	gate_vma.vm_start	=3D 0xffff0000;
+ 	gate_vma.vm_end		=3D 0xffff0000 + PAGE_SIZE;
+ 	gate_vma.vm_page_prot	=3D PAGE_READONLY_EXEC;
+ 	gate_vma.vm_flags	=3D VM_READ | VM_EXEC |
 -				  VM_MAYREAD | VM_MAYEXEC |
 -				  VM_ALWAYSDUMP;
++				  VM_MAYREAD | VM_MAYEXEC;
+ 	return 0;
+ }
+ arch_initcall(gate_vma_init);
+=20
+ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+ {
+ 	return &gate_vma;
+ }
+=20
+ int in_gate_area(struct mm_struct *mm, unsigned long addr)
+ {
+ 	return (addr >=3D gate_vma.vm_start) && (addr < gate_vma.vm_end);
+ }
+=20
+ int in_gate_area_no_mm(unsigned long addr)
+ {
+ 	return in_gate_area(NULL, addr);
  }
 =20
  const char *arch_vma_name(struct vm_area_struct *vma)

--Signature=_Mon__26_Mar_2012_11_05_50_+1100_hKMFaWFe7P94N02z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPb7LeAAoJEECxmPOUX5FEgCQP/A03Vf2JQ2DJMm62fu7y+imO
294QWlMBZviWpYOc+mlWo+8OTR1n4XU6OAnEHNhGVdBSRgitoBPIuo/yzfSBnueL
VZiwKro/aNeOtZdQtgLL1VAhd9JJ92Ak7kWbq7Dje4265DSsgrvTe3qhd6DY9+h8
i4HDEfLI5CbssUHJf51FQQk+9/bXeI4yVILtAhOjOUD/WBIoB0xiYCHO41a+AaTK
BEtYOQnsRuaQLmR5Dp/2ee0Fv9/9VDDS0QwJydEuPGArv7d1ppmh8uVppFw/kxJk
oqVCGCQdZHcQtydSWrSM/dASMAA50s1NW4526j4wFMHHpuWtMjZoq7Fbkhjm2HNh
FyWTjGmvN9Mh2i7E6b1lPtEdvwAlX5/SzIH9/4d5XbonJTYhlCDb0cPvBPPRvMcF
13Y4R1Tv8TO5NF7SdVW7Wi/AtYi43S/2HRrfE2ppml++OBqwi9rsntSMNMNT/h5h
xQgZ9eeznyVJQOY45wKSe1mq8zVHL9Qw6CtIpeM46qO+QFxmRtIkrjRA6nNV/T2P
Zv+lB+N/KUqDUSIg3S41NjsSmL7Bk6cQOeeiG2nCSOrLNqjujDNMWpVkdPpn8hrq
+S1J2vdk/YlcGznPW1aRE2d46ZJUep/5Y/0wdxzddXbK+WZBmnqJackceBSGSEBl
IPecyDmO42Y9mG0jv+y9
=tWgl
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Mar_2012_11_05_50_+1100_hKMFaWFe7P94N02z--
