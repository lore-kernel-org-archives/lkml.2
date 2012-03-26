Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab2CZEBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 00:01:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50122 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2CZEB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 00:01:29 -0400
Date: Mon, 26 Mar 2012 15:01:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Alex Shi <alex.shi@intel.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120326150107.392bc3a7e0175b5009bcfeff@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Mar_2012_15_01_07_+1100_GLoWKR.bhUOdDRTg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Mar_2012_15_01_07_+1100_GLoWKR.bhUOdDRTg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in  between
commit a6fca40f1d7f ("x86, tlb: Switch cr3 in leave_mm() only when
needed") from the tip tree and commit "x86: use this_cpu_xxx to replace
percpu_xxx funcs" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/mm/tlb.c
index 125bcad,e931db0..0000000
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@@ -61,13 -61,11 +61,13 @@@ static DEFINE_PER_CPU_READ_MOSTLY(int,=20
   */
  void leave_mm(int cpu)
  {
- 	struct mm_struct *active_mm =3D percpu_read(cpu_tlbstate.active_mm);
- 	if (percpu_read(cpu_tlbstate.state) =3D=3D TLBSTATE_OK)
++	struct mm_struct *active_mm =3D __this_cpu_read(cpu_tlbstate.active_mm);
+ 	if (__this_cpu_read(cpu_tlbstate.state) =3D=3D TLBSTATE_OK)
  		BUG();
 -	cpumask_clear_cpu(cpu,
 -			  mm_cpumask(__this_cpu_read(cpu_tlbstate.active_mm)));
 -	load_cr3(swapper_pg_dir);
 +	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 +		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 +		load_cr3(swapper_pg_dir);
 +	}
  }
  EXPORT_SYMBOL_GPL(leave_mm);
 =20

--Signature=_Mon__26_Mar_2012_15_01_07_+1100_GLoWKR.bhUOdDRTg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPb+oDAAoJEECxmPOUX5FEly4P/iRwK8x9g8WJiW9UbSaqGTsg
vtwUwGsasrZgVft1wSQKgHQhqTzm/ApJu/BdR14AWndsyK5om1iCrQCJn2Dzgd1u
LtgYPXgbBeMVPmCqdLPJRKw/nYH65hE4SNxJgH3dq/3z4nPLrBtMnqVtyY6A8NA5
asuLAdccbiABQByYSTWtmJLYoaXApyOjv4A3N3W/5Ngvjcc+yw1COuTqONARzhTH
wGOLFGjqcnq/ZYD+wJfhU1ZBjYZObjTcvIXs+hjW8CUWdhmxxoagcoB6bFN0ZLwE
Jnldq6Vc6nwE8BDJx0OAUfTLjw5b8LCQDvLqVaMXHn/Pm2KJime98488CGIPEUQi
TlSchj3q9Qa9Vu5WhNoXqUNQfARm0HlshzGtQcW5yiIPLRqNyTtANSY+EnIzWvzf
j33qc01MNHGpYJErYx8Ic9sTzqDkGd/M+q4SJITvQaTlolYfYSCbDsDhvXZd3rD+
fQ3LUhknpqP3RuUDHbrH5QKjEGzC3aJhCGaAjV30WfMZPkvomOTTQlum2z5AsM/U
fE/jVNZdgWBzY2fipMRT2Wf7gI4vjEhHJNIOp3mBDQFdnr+mqNgBizf4LWDB42Lz
wOzsUK58WDeY77d53DtwI41v1ovUuLAKD2NYVq63dOjYr2+W55aZ1uwvWV7WU5j4
spfRLwMgm0X3V/Ayo5Aj
=J790
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Mar_2012_15_01_07_+1100_GLoWKR.bhUOdDRTg--
