Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2K3E0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 23:26:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47635 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2K3E0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 23:26:21 -0500
Date: Fri, 30 Nov 2012 15:26:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-Id: <20121130152604.251a14846d6f29c18d65ccae@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Nov_2012_15_26_04_+1100_4m5EeboWINZRZxh1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Nov_2012_15_26_04_+1100_4m5EeboWINZRZxh1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
kernel/sched/core.c between commit 0a74bef8bed1 ("sched: Add an rq
migration call-back to sched_class") from the tip tree and commit
582b336ec2c0 ("sched: add notifier for cross-cpu migrations") from the
kvm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched/core.c
index 20fb760,c86b8b6..0000000
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@@ -953,10 -959,16 +960,18 @@@ void set_task_cpu(struct task_struct *p
  	trace_sched_migrate_task(p, new_cpu);
 =20
  	if (task_cpu(p) !=3D new_cpu) {
+ 		struct task_migration_notifier tmn;
+=20
 +		if (p->sched_class->migrate_task_rq)
 +			p->sched_class->migrate_task_rq(p, new_cpu);
  		p->se.nr_migrations++;
  		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
+=20
+ 		tmn.task =3D p;
+ 		tmn.from_cpu =3D task_cpu(p);
+ 		tmn.to_cpu =3D new_cpu;
+=20
+ 		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);
  	}
 =20
  	__set_task_cpu(p, new_cpu);

--Signature=_Fri__30_Nov_2012_15_26_04_+1100_4m5EeboWINZRZxh1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQuDVcAAoJEECxmPOUX5FEoj4P/jrrRJmaCoESOQXVz5lZH/Cw
9gu6oSHgprlogqWVQSNGAMcuRkA0DsBV/xUVo2QMBgJcMOQ2iFYzUA68cBOMju/u
QiNc7fWVHjYkvsNgCDNCl0l0p2inVLaCsLa06oWVKn2boRfF6BGnDDvTClOkTu/S
EfVgpZvAgsryYKOPbIhAXPMOgKp5FbuVl2IQCsp/skeQE1r4kzj2YT3G4AT0V1K3
RfHkUGEOnkO9mYj+Zgv/6UDALDaIBgN/76rFCO8IZ5miWsklmoMbfuZt4OWpU7P+
I7eHT6AZjDbBkW1gMFjp0Ci6++qgMIxn6cB5Jd1WDGpwUscvjWU6OelXIXViB9KS
apfWzN3vwrdazW/RO5ygVqrG28a2VhDRoNhpNY/yJVEMlvaFybt8hgig2J4L9ae7
wlm2vuCBf2tvDc2K5wXDbqF1N5Rf9SEMyBX1g47UH9O2i+yBeND2NpM4AuQ95XnF
ukoYj1kKJqLqzZbrhhpW52l7UjJpk4ey6PIJJlGVbYZYmAn43/Zxh7ZTME1HcBeJ
HtWAzS6CCcd48ZgXPHVIC86Quf1RqCOfGL5ZvvOVh6uK952znwfaNBnmKmPorSZd
qWeZMOrg+kCAv3SDU1xA0CjZdhus3yV0xoa25A4AMXl+rC8uj7T3tFynFSfe2/BV
DsaQNXY00gecYWUtzjCw
=nC4N
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Nov_2012_15_26_04_+1100_4m5EeboWINZRZxh1--
