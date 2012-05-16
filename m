Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab2EPHg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:36:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59134 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514Ab2EPHg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:36:26 -0400
Date: Wed, 16 May 2012 17:36:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20120516173616.ed5b60cf4b16e34a57206559@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_17_36_16_+1000_PCJx5H2=UIPPElKd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_17_36_16_+1000_PCJx5H2=UIPPElKd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/x86/mm/tlb.c between commit a6fca40f1d7f ("x86, tlb: Switch cr3 in
leave_mm() only when needed") from the tip tree and commit c6ae41e7d469
("x86: replace percpu_xxx funcs with this_cpu_xxx") from the percpu tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/mm/tlb.c
index 125bcad,3804471..0000000
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@@ -61,13 -61,11 +61,13 @@@ static DEFINE_PER_CPU_READ_MOSTLY(int,=20
   */
  void leave_mm(int cpu)
  {
- 	struct mm_struct *active_mm =3D percpu_read(cpu_tlbstate.active_mm);
- 	if (percpu_read(cpu_tlbstate.state) =3D=3D TLBSTATE_OK)
++	struct mm_struct *active_mm =3D this_cpu_read(cpu_tlbstate.active_mm);
+ 	if (this_cpu_read(cpu_tlbstate.state) =3D=3D TLBSTATE_OK)
  		BUG();
 -	cpumask_clear_cpu(cpu,
 -			  mm_cpumask(this_cpu_read(cpu_tlbstate.active_mm)));
 -	load_cr3(swapper_pg_dir);
 +	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 +		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 +		load_cr3(swapper_pg_dir);
 +	}
  }
  EXPORT_SYMBOL_GPL(leave_mm);
 =20

--Signature=_Wed__16_May_2012_17_36_16_+1000_PCJx5H2=UIPPElKd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs1jwAAoJEECxmPOUX5FEpQUP/0mva319wbJhcCihCMy05QpN
r2/lWJRF9u60JzydUczQXOcn0LBvWtIv2L5hGYEcTNKlS9dBMbUu/Q/J+gyx8xn1
OZdpXWBvliDRlACfQeFUvzqYlZnQBxRSKU0mhlDSX9OsKv8e7f0maZ42CgP/ouB2
iHLAb9XV8EGmqX++k+n5z32yTkOuxGg80p6ff9GZVvhnt/pgVPlPIMYWKJAkzxQU
hVNYkoOSjHFWE1Efd+XbVXk38I81eFulL8lb4Aux7iTDei+8W5MDoPEVSId1Dk5+
1T+0QWfbTjdwzmsWnnkgwrdO4/1bHOv2rPsYB4SVYLVieacgtRtoS0dA3t3D7EeL
/WXwA0pqsfSBI8vYtgLPn9wJeJKB9rotKDmfAis802W6cy7yVEK4SGLxXrWKDpoo
pSSCoE9u41+vsQyimc3HyuXWbeY8FgPpZn36C/NurYkac9FdNt0QEHw8HmFljTTl
hp5W64vSQkpLk/wn3zXp460pWDHDyVbLKBZlAv7pzA20Sb65MsR9yy6831l7bKWn
EV1agoIxbRtUIKtO1h8db1WJ90kuF474EtWv+f0Gl8ziFYLWi1xzhqvPphspKlvS
Aq0WsfwKz4nf4RLx5sRjeoc8KM7IhOPKVASqpgq27mu8R1VygR1DGAXl+ptELsCh
IUNEi5XiBuNH+yzGvprc
=xz+a
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_17_36_16_+1000_PCJx5H2=UIPPElKd--
