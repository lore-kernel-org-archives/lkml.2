Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab2LJIZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:25:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47257 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2LJIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:25:05 -0500
Date: Mon, 10 Dec 2012 19:25:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121210192502.4063413a4026cb1009573b20@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_25_02_+1100_LvppzccKW3/Y/6YT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_25_02_+1100_LvppzccKW3/Y/6YT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/huge_memory.c between commit 2083d67027ad ("mm/mempolicy: Implement
change_prot_numa() in terms of change_protection()") from the tip,  tree
and commit "thp: change_huge_pmd(): make sure we don't try to make a page
writable" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/migrate.h
index bcb5ddc,50d2974..0000000
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@@ -7,16 -7,13 +7,23 @@@
 =20
  typedef struct page *new_page_t(struct page *, unsigned long private, int=
 **);
 =20
 +enum migrate_reason {
 +	MR_COMPACTION,
 +	MR_MEMORY_FAILURE,
 +	MR_MEMORY_HOTPLUG,
 +	MR_SYSCALL,		/* also applies to cpusets */
 +	MR_MEMPOLICY_MBIND,
 +	MR_NUMA_MISPLACED,
 +	MR_CMA
 +};
 +
+ /*
+  * Return values from addresss_space_operations.migratepage():
+  * - negative errno on page migration failure;
+  * - zero on page migration success;
+  */
+ #define MIGRATEPAGE_SUCCESS		0
+=20
  #ifdef CONFIG_MIGRATION
 =20
  extern void putback_lru_pages(struct list_head *l);
diff --cc mm/migrate.c
index c0afe60,c3724b6..0000000
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@@ -981,8 -977,7 +981,8 @@@ int migrate_pages(struct list_head *fro
  			case -EAGAIN:
  				retry++;
  				break;
- 			case 0:
+ 			case MIGRATEPAGE_SUCCESS:
 +				nr_succeeded++;
  				break;
  			default:
  				/* Permanent failure */
@@@ -991,14 -986,8 +991,14 @@@
  			}
  		}
  	}
- 	rc =3D 0;
+ 	rc =3D nr_failed + retry;
  out:
 +	if (nr_succeeded)
 +		count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
 +	if (nr_failed)
 +		count_vm_events(PGMIGRATE_FAIL, nr_failed);
 +	trace_mm_migrate_pages(nr_succeeded, nr_failed, mode, reason);
 +
  	if (!swapwrite)
  		current->flags &=3D ~PF_SWAPWRITE;
 =20
diff --cc mm/huge_memory.c
index 2c4e4d4,28a368c..0000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -1352,17 -1433,8 +1352,18 @@@ int change_huge_pmd(struct vm_area_stru
  	if (__pmd_trans_huge_lock(pmd, vma) =3D=3D 1) {
  		pmd_t entry;
  		entry =3D pmdp_get_and_clear(mm, addr, pmd);
 -		entry =3D pmd_modify(entry, newprot);
 +		if (!prot_numa)
 +			entry =3D pmd_modify(entry, newprot);
 +		else {
 +			struct page *page =3D pmd_page(*pmd);
 +
 +			/* only check non-shared pages */
 +			if (page_mapcount(page) =3D=3D 1 &&
 +			    !pmd_numa(*pmd)) {
 +				entry =3D pmd_mknuma(entry);
 +			}
 +		}
+ 		BUG_ON(pmd_write(entry));
  		set_pmd_at(mm, addr, pmd, entry);
  		spin_unlock(&vma->vm_mm->page_table_lock);
  		ret =3D 1;

--Signature=_Mon__10_Dec_2012_19_25_02_+1100_LvppzccKW3/Y/6YT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxZxeAAoJEECxmPOUX5FE9foP/RNZyhi0xnK1/U5qrbSZvKM/
KX9crwVb9Az59etnaouE5nFnQ0tNsEkO4EyeBRx3nJOWofmKAzFOLh9PKU4Ql7WU
ix2z37q7sp+gK9iTO0A5vyMJrimI+iteU8uLzwrN2xNyA4BMWTZUAz/5QcgofwVB
ZNuHQW5roecksR8s1gq4lzjvIo3o+cWMTm+uKCrj7SGiSdxLvUk9N+GeUp/MAu9g
mIupI6wS7tE0vhnV0SeNpAhDGqy4SlUo+zvobFKvqn8AVfanX3Cl1BrGXwWMuU5Z
pdOlH1nlRuVQWXHOUKapjKT95P9z+YyML+RpMGAPsn/QIRreQZDxuZcCS3O0G8Xi
+WxyNhXjl/w4u4nZtj8yQYoeTyWlREBpkAXfsRZ0pBPbpP1QJhexjc08fSBxyziJ
u5GacJUsIr/GxhteOPYwQJ6abDM6TnbEkjJYh77YujRTnBk5PT8/fSVdwhV7m0NO
FE8fwUSlbRg+3S9hAMAFngD/qTOpwkTcOMdfuLHUn8nSTveA30AhMzEyWsj+w7nW
WZocP27anGppUvSeVWnov/6J+kJn3Q/GnskTjSykGllYTLUJUOHDUjFhwR2XHNCn
iphM5OQq/679vmN+adf0CwlWTK+mmXSNB8BTv1K6FCVMLaofQcNZb8Rna2xBUCt0
Hqlf1YK+X1DK93XsvNno
=5V5F
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_25_02_+1100_LvppzccKW3/Y/6YT--
