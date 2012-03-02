Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2CBGhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:37:05 -0500
Received: from mail.southpole.se ([193.12.106.18]:49857 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2CBGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:37:03 -0500
Message-ID: <1330670192.19557.96.camel@satguru>
Subject: Re: OpenRISC: BUG: failure at mm/page_alloc.c:2467/free_pages()!
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 02 Mar 2012 07:36:32 +0100
In-Reply-To: <4F501E60.3090701@nod.at>
References: <4F501E60.3090701@nod.at>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OTxQtBG54KpfOy6ukqlA"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 70219-12260
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-OTxQtBG54KpfOy6ukqlA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-02 at 02:12 +0100, Richard Weinberger wrote:
> Hi!
>=20
> CONFIG_DEBUG_VM exposes this splat:
> BUG: failure at mm/page_alloc.c:2467/free_pages()!
>=20
> addr is 0xc100c000, but memory_end is 0x02000000.

virt_addr_valid() is broken (asm/page.h) as it's trying to compare to a
phys_addr_t.

Something like the following looks better:

diff --git a/arch/openrisc/include/asm/page.h
b/arch/openrisc/include/asm/page.h
index b041b34..c4ffaee 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -94,8 +94,7 @@ extern unsigned long memory_end;
=20
 #define pfn_valid(pfn)          ((pfn) < max_mapnr)
=20
-#define virt_addr_valid(kaddr)  (((void *)(kaddr) >=3D (void
*)PAGE_OFFSET) && \
-                               ((void *)(kaddr) < (void *)memory_end))
+#define virt_addr_valid(kaddr) (pfn_valid(virt_to_pfn(kaddr)))
=20
 #endif /* __ASSEMBLY__ */


--=-OTxQtBG54KpfOy6ukqlA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9QanAACgkQ70gcjN2673MBqwCfUfPt8nkDJsuYQkDFbS/Eogro
ij8An3ZNjA97v89OMRbYsTIUPoWSqeKh
=Yy8S
-----END PGP SIGNATURE-----

--=-OTxQtBG54KpfOy6ukqlA--

