Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1KVBEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:04:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37631 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KVBEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:04:13 -0500
Date: Tue, 22 Nov 2011 12:03:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-Id: <20111122120358.aa2cefdcdace9a98acafd4b9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_12_03_58_+1100_fguqivX+Je1Coa2Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_12_03_58_+1100_fguqivX+Je1Coa2Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next merge of the arm-lpae tree got a conflict in
arch/arm/mm/ioremap.c between commit 3afb51f744b6 ("ARM: add generic
ioremap optimization by reusing static mappings") from the arm tree and
commit ec93d80c4b07 ("ARM: LPAE: Page table maintenance for the 3-level
format") from the arm-lpae tree.

I guessed (probably incorrectly) about the fix up (see below).  Please
supply a better fix if necessary.

More generally, is the LPAE stuff going to be merged soon?  The above
arm-lpae commit dates from February (though it was recommitted on Nov
15) ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/ioremap.c
index 12c7ad2,d1f78ba..0000000
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@@ -194,7 -208,14 +202,8 @@@ void __iomem * __arm_ioremap_pfn_caller
  	 */
  	if (pfn >=3D 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
  		return NULL;
+ #endif
 =20
 -	/*
 -	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
 -	 */
 -	if (WARN_ON(pfn_valid(pfn)))
 -		return NULL;
 -
  	type =3D get_mem_type(mtype);
  	if (!type)
  		return NULL;
@@@ -329,34 -322,28 +338,34 @@@ __arm_ioremap_exec(unsigned long phys_a
  void __iounmap(volatile void __iomem *io_addr)
  {
  	void *addr =3D (void *)(PAGE_MASK & (unsigned long)io_addr);
 -#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 -	struct vm_struct **p, *tmp;
 +	struct vm_struct *vm;
 =20
 -	/*
 -	 * If this is a section based mapping we need to handle it
 -	 * specially as the VM subsystem does not know how to handle
 -	 * such a beast. We need the lock here b/c we need to clear
 -	 * all the mappings before the area can be reclaimed
 -	 * by someone else.
 -	 */
 -	write_lock(&vmlist_lock);
 -	for (p =3D &vmlist ; (tmp =3D *p) ; p =3D &tmp->next) {
 -		if ((tmp->flags & VM_IOREMAP) && (tmp->addr =3D=3D addr)) {
 -			if (tmp->flags & VM_ARM_SECTION_MAPPING) {
 -				unmap_area_sections((unsigned long)tmp->addr,
 -						    tmp->size);
 -			}
 +	read_lock(&vmlist_lock);
 +	for (vm =3D vmlist; vm; vm =3D vm->next) {
 +		if (vm->addr > addr)
 +			break;
 +		if (!(vm->flags & VM_IOREMAP))
 +			continue;
 +		/* If this is a static mapping we must leave it alone */
 +		if ((vm->flags & VM_ARM_STATIC_MAPPING) &&
 +		    (vm->addr <=3D addr) && (vm->addr + vm->size > addr)) {
 +			read_unlock(&vmlist_lock);
 +			return;
 +		}
- #ifndef CONFIG_SMP
++#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 +		/*
 +		 * If this is a section based mapping we need to handle it
 +		 * specially as the VM subsystem does not know how to handle
 +		 * such a beast.
 +		 */
 +		if ((vm->addr =3D=3D addr) &&
 +		    (vm->flags & VM_ARM_SECTION_MAPPING)) {
 +			unmap_area_sections((unsigned long)vm->addr, vm->size);
  			break;
  		}
 -	}
 -	write_unlock(&vmlist_lock);
  #endif
 +	}
 +	read_unlock(&vmlist_lock);
 =20
  	vunmap(addr);
  }

--Signature=_Tue__22_Nov_2011_12_03_58_+1100_fguqivX+Je1Coa2Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyvT+AAoJEECxmPOUX5FE2nAP/23j+X08bWc4cy8XUmOOidVg
/7lR+E/3oC1+AT7krRyML0wFhBQ6fOJ5WalqPKpZaMPkHIkml1BA/fE9R2rCmefp
v+tiBxm1a3JUsr4r6sUe/7KmTn/fWbFSB+sQXol75SEC1BRNYh17BrpJjWfShhZX
4K9rHu2POHUf0ZVgOEqgbImA1F1m7l5M+McMw3YUBpez1DhhUmegSIxQTPwGMiXA
QwXHCfp+fY1x/anoYzMoWhK44klXHD4DIIFuBffPFeZBjDRBAe2/XFJCj9Art/i+
jn+fCBiG8t8JFb6n0hgp6XH5Y4TppOxJGMWnafb7sZsG/qlHpE9ZQt3hqVohA7OS
nJwa1qvzJ/rm4M9/DG+iz6d5op6ekUJQJQmbHF4s99lDsfMEdWoDTOqrBVTH4+xi
wnvtzE/j4kCoX/lj4BX7e9m+5j7q7o9nb5OjnbnUoAP099u0EtYTaAaRUzQmF6L6
MJXqo9WOM+c33zEWpHXsrH/lZ0ZaHBKLCVs215pXm0qgygHtvgCGsOvp7+KOcXbh
AC3VlU1XHIpqGHifaUjxF5H6dUPxB0icTUNnfxFr8nZ1YZi6wokZst5lV4qYkmTa
E03jNRR7n90N8r4rk98+VosxdUR8XW2agLzMG816u/21fT4C3ZH/9VfPCJjTNlQq
565YyKqwNgfBkDRk2vzG
=ga5c
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_12_03_58_+1100_fguqivX+Je1Coa2Z--
