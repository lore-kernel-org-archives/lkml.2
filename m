Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1LSEkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:40:22 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38679 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1LSEkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:40:21 -0500
Date: Mon, 19 Dec 2011 15:40:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: linux-next: manual merge of the tip tree with the cputime tree
Message-Id: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_15_40_10_+1100_1WPumsYz+XsKIwYm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_15_40_10_+1100_1WPumsYz+XsKIwYm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
fs/proc/uptime.c between commit c3e0ef9a298e ("[S390] fix cputime
overflow in uptime_proc_show") from the cputime tree and commit
3292beb340c7 ("sched/accounting: Change cpustat fields to an array") from
the tip tree.

I fixed it up (I think - see below) and can carry the fix as necessary.

Generally, you guys seem to be working a little at cross purposes ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/uptime.c
index ab51510,0fb22e4..0000000
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@@ -6,30 -6,25 +6,29 @@@
  #include <linux/time.h>
  #include <linux/kernel_stat.h>
  #include <asm/cputime.h>
 =20
  static int uptime_proc_show(struct seq_file *m, void *v)
  {
  	struct timespec uptime;
  	struct timespec idle;
- 	cputime64_t idletime;
 +	u64 nsec;
 +	u32 rem;
  	int i;
+ 	u64 idletime =3D 0;
 =20
- 	idletime =3D 0;
  	for_each_possible_cpu(i)
- 		idletime +=3D kstat_cpu(i).cpustat.idle;
+ 		idletime +=3D kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
 =20
  	do_posix_clock_monotonic_gettime(&uptime);
  	monotonic_to_bootbased(&uptime);
 -	cputime_to_timespec(idletime, &idle);
 +	nsec =3D cputime64_to_jiffies64(idletime) * TICK_NSEC;
 +	idle.tv_sec =3D div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 +	idle.tv_nsec =3D rem;
  	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
  			(unsigned long) uptime.tv_sec,
  			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
  			(unsigned long) idle.tv_sec,
  			(idle.tv_nsec / (NSEC_PER_SEC / 100)));
  	return 0;
  }
 =20

--Signature=_Mon__19_Dec_2011_15_40_10_+1100_1WPumsYz+XsKIwYm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7sAqAAoJEECxmPOUX5FEN6YQAKg6p3bVuoiJCzYE8IHjOX0a
i1mkJeGTVArf6CHqbj87BBczXcw8XRH1K3sN5/K7yqfbMz4OfVdsW1FRA2fR3uyH
u1B7t0lP8h1fzpKJUdamUPJFzrGpOSzOSehuyX5Ob7OHHSOXkbW0eGUwgJXr5fRU
HKpd5rUnj2Tw/bmusAT1QXjFWGuOtn4g1pHX2+U5FVtTk96EtMPgbTx1PReyT/gA
yQdi9vs4XG+gJthoHeUlGT7MJ9BCKURWw62cZV1O2eLEaIKfKoFDQvTUug0p6IJo
c0ZPekqzP4tD2TZW85wbcXVqCFFyzeJ+H12djt9MpgMqMWtIPL123aorHoafFVPT
TTfukSmjV7hpWb0cFj5Y7PyQWCbrWxbstxzHZuOA9o3LiabFIl/aqOdCDVRpQGbK
mLp6t28qEA3zkPDrIKEJieE1+Ow9Oh1sVSK9FxBv0Q7n1nUv1bjNvOwzafHwH+zR
FBs3OE1029JOMj3EaEe0sjsZX1optxz4Ed+XTkeu4lkRi76/TJVh4fntVtmOVW2J
OaWXsnjC7Ni4hbDBbTZt4iR3n4ov9xKBUWaHgZ5eWcQErQq9ellqP1ySwH9pW7Hh
Q+j0ge2qb5k68xGOB7+Fl7BchpLG0YoD3dT6SkJ/3w//xkZoF6n+uNfDvSuhiwgT
rBrJDx2gzPn1PGij7Cmd
=3Lh9
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_15_40_10_+1100_1WPumsYz+XsKIwYm--
