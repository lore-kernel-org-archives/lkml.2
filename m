Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2LJIBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:01:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51352 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2LJIBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:01:50 -0500
Date: Mon, 10 Dec 2012 19:01:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121210190139.4ae77c7b70fa24daacf2c9cb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_01_39_+1100_lRryH29crv/r9B+h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_01_39_+1100_lRryH29crv/r9B+h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/memory.c
between changes in commits from the tip tree and commit "mm: thp: set the
accessed flag for old pages on access fault" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memory.c
index 8022526,60201d5..0000000
--- a/mm/memory.c
+++ b/mm/memory.c
@@@ -3812,15 -3620,18 +3812,17 @@@ retry
  							  pmd, flags);
  	} else {
  		pmd_t orig_pmd =3D *pmd;
 -		int ret =3D 0;
 +		int ret;
 =20
  		barrier();
 -		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
 +		if (pmd_trans_huge(orig_pmd)) {
+ 			unsigned int dirty =3D flags & FAULT_FLAG_WRITE;
+=20
 -			if (pmd_numa(vma, orig_pmd)) {
 -				do_huge_pmd_numa_page(mm, vma, address, pmd,
 -						      flags, orig_pmd);
 -			}
 +			if (pmd_numa(*pmd))
 +				return do_huge_pmd_numa_page(mm, vma, address,
 +							     orig_pmd, pmd);
 =20
- 			if ((flags & FAULT_FLAG_WRITE) && !pmd_write(orig_pmd)) {
+ 			if (dirty && !pmd_write(orig_pmd)) {
  				ret =3D do_huge_pmd_wp_page(mm, vma, address, pmd,
  							  orig_pmd);
  				/*
@@@ -3830,10 -3641,12 +3832,13 @@@
  				 */
  				if (unlikely(ret & VM_FAULT_OOM))
  					goto retry;
 +				return ret;
+ 			} else {
+ 				huge_pmd_set_accessed(mm, vma, address, pmd,
+ 						      orig_pmd, dirty);
  			}
 =20
 -			return ret;
 +			return 0;
  		}
  	}
 =20

--Signature=_Mon__10_Dec_2012_19_01_39_+1100_lRryH29crv/r9B+h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxZbjAAoJEECxmPOUX5FE3O8QAJa1KnQX2S8X6/TGy3pv8Od/
0eLCaI6GFXboDa4KPCo6cjn7XpEd578GBBDv6KAHfMt5G65SqDul6v4WkQmIoUP1
BNzZYyy67ucpKaoGA9Nc0rs76TT+rcBZLDoO1ItTt3MGkY/twSumucN7IlZs3Y5i
8eFH4YOYvRt6M7iKSeWVCEb5cvZtro89ofmXdrfC6Iuoks0FNzHFwslH0LIzPU8t
yQahWB/0UD4L2EuQ/o8EIU8xP79qb/nnRQl1EVkXHm510WequEpdi16cOs+YyNDc
f9+VxvBH8vLaj3CbFPhXIN0zP1AlA8kXRlseaSURhEZBSj09bScHptbfU8KZeXLl
GCQsxextfpx/EwLlCgHvpu2yayfH1EKPJDjxjsZ+VHqVEasoDjV0zXllITtZzTYY
woSNujpREZ9pNwv/lDw7oAzVP6fnFRR1D2aRsML5zClegUkuqNf5aelgtzrOxh1T
RCxG/Be7Bhrwc3+ajrISC5I+mvKujJMDXrbn9cBEF1sHlidKrfvyPjGW0U+iSDLu
wdSg4WsP6Mj+BT4tKvqQX8UG2JTuvqAEZyLcX2O+NyE9W4KaVbOkfNsCzBNvS7zl
eNBXs5TAHbjAKpzgMyuKSLeEocjKuptEiF7q23JFRZ6dNfYeMna11Rl9y+vBE3rP
/sZEHe5ItbaZQCzJSAtN
=qoTp
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_01_39_+1100_lRryH29crv/r9B+h--
