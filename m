Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2LRC3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:29:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37467 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2LRC3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:29:21 -0500
Date: Tue, 18 Dec 2012 13:29:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20121218132907.099de7f8d94e73f189b01b21@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Dec_2012_13_29_07_+1100_YGrEzi1=kn6dAlJ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Dec_2012_13_29_07_+1100_YGrEzi1=kn6dAlJ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

mm/migrate.c: In function 'migrate_misplaced_transhuge_page':
mm/migrate.c:1738:2: error: incompatible type for argument 3 of 'update_mmu=
_cache_pmd'
arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but =
argument is of type 'pmd_t'

Caused by commit b32967ff101a ("mm: numa: Add THP migration for the NUMA
working set scanning fault case") from Linus' tree interacting with
commit "x86: convert update_mmu_cache() and update_mmu_cache_pmd() to
functions".

This was previously reported as against the tip tree, but the fix patch
(which was applied to the tip tree) did not survive the rewrite that went
into Linus' tree.  Just a little annoyed :-(

I have applied this patch for today (Linus can you just apply this to
your tree, the patch in Andrew's tree just exposes this problem by
converting a macro into a static line function, but the argument in the
call added by Mel's patch is wrong anyway)

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 10 Dec 2012 19:50:57 +1100
Subject: [PATCH] mm,numa: fix update_mmu_cache_pmd call

Fixes this build error:

mm/migrate.c: In function 'migrate_misplaced_transhuge_page_put':
mm/migrate.c:1666:2: error: incompatible type for argument 3 of 'update_mmu=
_cache_pmd'
arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but =
argument is of type 'pmd_t'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5be98e5..964a8c1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1663,7 +1663,7 @@ int migrate_misplaced_transhuge_page_put(struct mm_st=
ruct *mm,
 	page_add_new_anon_rmap(new_page, vma, haddr);
=20
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
 	page_remove_rmap(page);
 	/*
 	 * Finish the charge transaction under the page table lock to
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Dec_2012_13_29_07_+1100_YGrEzi1=kn6dAlJ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQz9TzAAoJEECxmPOUX5FEVsAP/33Gtd/aklDPYu2gCF6ujj/z
mGh9K18Kww5CmAc83yQXl37FutigVCyjmnFdai+0IEMSTer+g5ox8Op4n6xRG5oY
vchTThNSMiudnAv7PRQo7cps0CodxQA8vk48rZ7g508C/cYx15Q2aZTh5cbVQw0N
SgqUWze0zkJvNLjKOYovozbqVf3LuurlzheyjmhguhC/T9rIzIJtquM/vLVXrLSE
ZvnDARfCDfQuFobDdiC9ckgtxArEqtn9LIorkiNQkvtplfSCNOw8MzoK+Z4QjwmO
1kNM+FIqXpwtnp4Fcjb2GCT7UCrU+bssht8uoiv06P2ExP+XIQ1xlBBQKIabHQ4J
3nLxQ9p08FEUQWZZo1uIUeY3lWC3kbCF0OMiPYgLa5nQeMTrXHf9gW9GVmN4aPpd
F1iX1u+XzwFYLG0aC5aCIUQMm347UbEKYA6kzAO74SmESGiVkwMDkns8flZ+GMJ9
3ZXgpzrCIckoZ/puJ8+fWNBAvybX9AeJdiA8y9Ce7sOczoh8G62egyzHoStpg6wV
ANAc4SbS2cIYvvokXPtul4sHwNxXgBCypPwVuf7vDoThYQPvobo7u9v9aBXDOoWe
ZdxpDWIR0ZaFXbGsOWmMFEl2h8SB97hzUqLbfOzmfqNfFuD9ZdpirMOA/5cZxZkA
Od6rkBGqDhDBvQZGiElc
=moQR
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Dec_2012_13_29_07_+1100_YGrEzi1=kn6dAlJ0--
