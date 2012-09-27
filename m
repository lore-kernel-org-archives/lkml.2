Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2I0HEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:04:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43443 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2I0HES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:04:18 -0400
Date: Thu, 27 Sep 2012 17:04:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120927170413.789a21781469a9bb8737bee3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_17_04_13_+1000_SCFKmE6XbZWWaIMD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_17_04_13_+1000_SCFKmE6XbZWWaIMD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/huge_memory.c between commit 93c9d633bd9e ("mm/thp: Preserve pgprot
across huge page split") from the tip tree and commit "thp: merge page
pre-alloc in khugepaged_loop into khugepaged_do_scan" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/huge_memory.c
index 5ab8c26,50bd2ac..0000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -2307,11 -2240,43 +2307,41 @@@ static int khugepaged_wait_event(void
  		kthread_should_stop();
  }
 =20
- static void khugepaged_do_scan(struct page **hpage)
+ static void khugepaged_alloc_sleep(void)
+ {
+ 	wait_event_freezable_timeout(khugepaged_wait, false,
+ 			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+ }
+=20
+ #ifndef CONFIG_NUMA
+ static struct page *khugepaged_alloc_hugepage(bool *wait)
+ {
+ 	struct page *hpage;
+=20
+ 	do {
+ 		hpage =3D alloc_hugepage(khugepaged_defrag());
+ 		if (!hpage) {
+ 			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+ 			if (!*wait)
+ 				return NULL;
+=20
+ 			*wait =3D false;
+ 			khugepaged_alloc_sleep();
+ 		} else
+ 			count_vm_event(THP_COLLAPSE_ALLOC);
+ 	} while (unlikely(!hpage) && likely(khugepaged_enabled()));
+=20
+ 	return hpage;
+ }
+ #endif
+=20
+ static void khugepaged_do_scan(void)
  {
+ 	struct page *hpage =3D NULL;
  	unsigned int progress =3D 0, pass_through_head =3D 0;
 -	unsigned int pages =3D khugepaged_pages_to_scan;
 +	unsigned int pages =3D ACCESS_ONCE(khugepaged_pages_to_scan);
+ 	bool wait =3D true;
 =20
 -	barrier(); /* write khugepaged_pages_to_scan to local stack */
 -
  	while (progress < pages) {
  		cond_resched();
 =20

--Signature=_Thu__27_Sep_2012_17_04_13_+1000_SCFKmE6XbZWWaIMD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY/ptAAoJEECxmPOUX5FEHGIP/0FrGkV6Ap3z9KurKYkDDh+N
pETc1/HqcOdQJK8S/UjwIEIDTXZAyZ+g7Wl3CWQOtAVzJC/wHOe05ke7xsbWH0v0
vYkPXYlEeqzeIlZb4uWHxVRKzvZAahmbjJuiFcvgdmDEFnfIqqjhBV4wjUYiut2l
yOuMEtd2d6lrZHYyqlKsYcMzvIefritbLeuMkKC6Q1rHYs4U8gjTvH89CqNO2JPp
7hjqQGL/plBe5+/bJws8qogqBtpm9xIDZwq+Ue6haQuqXRIuH3BFfYiyKNu8uSMT
iTpxvMjfFW5DFhzrxYvZht6Jfu9hP5vpae1AaCws3FmaI46OyUD35uqOfKzOCa7K
SwX6udPaUTtNL0yVw2t0uWcRkjLoFcdnakdKHpZvarwkZKOWcdyXYIObKaLJXEM4
RAvnebOLrRDRDCao5DfgzrD1AfigBLcDArlV71SNs410JG2gMJhXP1VvzcUKbb1h
P2IDKoS4G/xKC2P3rcxGT30aGHxmZNLEdTKtehn7Eo7qsJ9GP4s5KQe09lFabEax
QA0LGviwGqUbXlACoDIyK3EUNWo0fBV45ly5NBHS/Ues9vvD3B+xNBD4qQJ0FLI4
QCgV1AcvzzyNGmshBNFidmxEuUZhaNv6k4qHojFHgVg3ERrPcL7/SafvUWbSVkB7
rZ+oxNY8FF1Efk8EANkJ
=wruq
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_17_04_13_+1000_SCFKmE6XbZWWaIMD--
