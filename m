Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2HVDLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:11:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59717 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2HVDLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:11:40 -0400
Date: Wed, 22 Aug 2012 13:11:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the rr tree with the mips tree
Message-Id: <20120822131130.d669275edf903d9a38a35789@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Aug_2012_13_11_30_+1000_jeRjfQTmoTo=U7m0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Aug_2012_13_11_30_+1000_jeRjfQTmoTo=U7m0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/mips/kernel/module.c between commit c54de490a2e4 ("MIPS: Module:
Deal with malformed HI16/LO16 relocation sequences") from the mips tree
and commit 9db0bbe072c8 ("MIPS: Fix module.c build for 32 bit") from the
rr tree.

Just context changes (I think).  I fixed it up (see below) and can carry
the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/kernel/module.c
index 4f8c3cb,8ffd089..0000000
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@@ -132,25 -107,6 +105,17 @@@ static int apply_r_mips_hi16_rel(struc
  	return 0;
  }
 =20
- static int apply_r_mips_hi16_rela(struct module *me, u32 *location, Elf_A=
ddr v)
- {
- 	*location =3D (*location & 0xffff0000) |
- 	            ((((long long) v + 0x8000LL) >> 16) & 0xffff);
-=20
- 	return 0;
- }
-=20
 +static void free_relocation_chain(struct mips_hi16 *l)
 +{
 +	struct mips_hi16 *next;
 +
 +	while (l) {
 +		next =3D l->next;
 +		kfree(l);
 +		l =3D next;
 +	}
 +}
 +
  static int apply_r_mips_lo16_rel(struct module *me, u32 *location, Elf_Ad=
dr v)
  {
  	unsigned long insnlo =3D *location;
@@@ -308,61 -217,9 +229,22 @@@ int apply_relocate(Elf_Shdr *sechdrs, c
  			return res;
  	}
 =20
 +	/*
 +	 * Normally the hi16 list should be deallocated at this point.  A
 +	 * malformed binary however could contain a series of R_MIPS_HI16
 +	 * relocations not followed by a R_MIPS_LO16 relocation.  In that
 +	 * case, free up the list and return an error.
 +	 */
 +	if (me->arch.r_mips_hi16_list) {
 +		free_relocation_chain(me->arch.r_mips_hi16_list);
 +		me->arch.r_mips_hi16_list =3D NULL;
 +
 +		return -ENOEXEC;
 +	}
 +
  	return 0;
  }
-=20
- int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
- 		       unsigned int symindex, unsigned int relsec,
- 		       struct module *me)
- {
- 	Elf_Mips_Rela *rel =3D (void *) sechdrs[relsec].sh_addr;
- 	Elf_Sym *sym;
- 	u32 *location;
- 	unsigned int i;
- 	Elf_Addr v;
- 	int res;
-=20
- 	pr_debug("Applying relocate section %u to %u\n", relsec,
- 	       sechdrs[relsec].sh_info);
-=20
- 	for (i =3D 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
- 		/* This is where to make the change */
- 		location =3D (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
- 			+ rel[i].r_offset;
- 		/* This is the symbol it is referring to */
- 		sym =3D (Elf_Sym *)sechdrs[symindex].sh_addr
- 			+ ELF_MIPS_R_SYM(rel[i]);
- 		if (IS_ERR_VALUE(sym->st_value)) {
- 			/* Ignore unresolved weak symbol */
- 			if (ELF_ST_BIND(sym->st_info) =3D=3D STB_WEAK)
- 				continue;
- 			printk(KERN_WARNING "%s: Unknown symbol %s\n",
- 			       me->name, strtab + sym->st_name);
- 			return -ENOENT;
- 		}
-=20
- 		v =3D sym->st_value + rel[i].r_addend;
-=20
- 		res =3D reloc_handlers_rela[ELF_MIPS_R_TYPE(rel[i])](me, location, v);
- 		if (res)
- 			return res;
- 	}
-=20
- 	return 0;
- }
+ #endif
 =20
  /* Given an address, look for it in the module exception tables. */
  const struct exception_table_entry *search_module_dbetables(unsigned long=
 addr)

--Signature=_Wed__22_Aug_2012_13_11_30_+1000_jeRjfQTmoTo=U7m0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNE3iAAoJEECxmPOUX5FELsgP/iL0w4BiLva78NPAkcjUnB+5
mhekY21veMwOVlhQV5F28IVc9hGXayE7DMXmdkbOkSbF6HV78V/IooA3Ek+Ym6Dw
2PfBW2FFOOvcLiI8gFp5ni/xYGpMqehKOcHqNxD3/rRXpFOYPVg4XPH/Lt5X7QYm
UlEfnP4KmICB1gcFgOFnE+JNufV7BQWdpi/uKu9JWXq4LxZBYcA4UoOnXXSrC/fr
TYWzVdoVGiDWgmnDzUtwHSKYqX8sgDOvSyYLkCHMgIa55d+f2TsB9KVz6hc7hxaX
EXUUVDmtvrwXfK9REpGLWoI2STLfSHah9+Kb9FvqYYVwsiPe6qmTa0QLtLchLO4H
WzbjC54+FLZn5xZNILU67pCHgY4GStrXHNHw89XDQMOFPvbk8+EGGgnRfhKJhx2b
JOS2GcfZKyL3NSImXv0XMKilB33wQKu558D6muy6wPEkptk+TPYAiRd7yMYucLM8
L8H7xmqPy/Larrm5OjgWKQj8p0kFgWcANDw3Py1VLDaZZlQQvjxOs1EyZeJdlewU
38BGj3Ks6eE3bpRR0u2nrq7TitImBcw7pUTBG0L7FKSiKzGJJiFirhHlr8cXCFLp
4ugBjxfg5Siu6LwaBlwkhGUQbjFtYrIVJnjIrsRORmEcdCr98rDoGbfmAy1y4+yK
B3R6g55rQ3/Ixf00Wc2h
=DqFX
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Aug_2012_13_11_30_+1000_jeRjfQTmoTo=U7m0--
