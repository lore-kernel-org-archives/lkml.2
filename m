Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2LJILX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:11:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51746 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2LJILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:11:22 -0500
Date: Mon, 10 Dec 2012 19:11:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121210191120.d6984a1183c969ff2bb91d5a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_11_20_+1100_5NegCEf1_o25svqS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_11_20_+1100_5NegCEf1_o25svqS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in mm/migrate.c
and include/linux/migrate.h between commits 070059b28578 ("mm/compaction:
Move migration fail/success stats to migrate.c") and 2d85cca46951
("mm/migrate: Add a tracepoint for migrate_pages") from the tip tree and
commit "mm: adjust address_space_operations.migratepage() return code"
from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

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

--Signature=_Mon__10_Dec_2012_19_11_20_+1100_5NegCEf1_o25svqS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxZkoAAoJEECxmPOUX5FEx58P/iZgju8VMymp0bmYSF41eKeJ
inUPm51wxmiw8vbDwGVQ9a39OwDdwLojyOsPPwz0fyTKp0+qmI3CI6LyGOIcGhGN
jy08AdxmsIIfFhFFh91QfcpWGof9Tfc9pIjQIYDqHXouK7pWAUipiEJ+R6Nxw+9f
SrQ+zxBOActB++SpOum5NZemFI0bKFjyhNkp7fPvPhKfxTzDNZ1qSz1UzQ+ZYdbr
xtsFg279OcKhXfP+lXm+NFWs9VVLEm6sBiWjIbwQt2EiUsBga6toLMLBWwld5eEQ
9q4ejOmaCnQh+HrQ/Q9lae+nnqRtwZEMSJkt9YaoT3INXA4vLarxbCbDr3p9XqvC
+7LxSSUMr87dvLaQrgXItFmsN/rUh5TfMKJNYOvo7ccE41xiws6VOQjzpHtv4mKZ
ITdCIEr3gRGHutNVwDZZoCsy1LUwjsAy2qE4trzl2VOdROI92ChGS1RQFV/E0q0E
T7VlJpIZi1qWRQU01LsRnrW+4ztFgCnKTkOlA9eRCl//9LMxV0pLvIC+26pdALji
2bcxxRLXNs6grWYsOPnxubvDwJf3SY38EE0Fvhed1UBWGlvkVe3a7jzoEjFNEMuD
tD47409ugNeSIk4AjLFXFSogycHLivzBDGESsds3G6CQ+5rubMiC1tG1h+0u/xcW
JsHyJfGXFTnp1BMSto0G
=r0rP
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_11_20_+1100_5NegCEf1_o25svqS--
