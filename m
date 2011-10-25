Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1JYHfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:35:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46164 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1JYHff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:35:35 -0400
Date: Tue, 25 Oct 2011 18:35:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the tip tree with the cputime tree
Message-Id: <20111025183518.6b9747b5d870b55129266785@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_18_35_18_+1100_f.RC5SerKcTS2LUE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_18_35_18_+1100_f.RC5SerKcTS2LUE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in fs/proc/stat.c
between commit f6116715d1ba ("[S390] cputime: add sparse checking and
cleanup") from the cputime tree and commit a25cac5198d4 ("proc: Consider
NO_HZ when printing idle and iowait times") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/stat.c
index 566cd04,42b274d..0000000
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@@ -21,6 -22,35 +22,34 @@@
  #define arch_idle_time(cpu) 0
  #endif
 =20
+ static cputime64_t get_idle_time(int cpu)
+ {
+ 	u64 idle_time =3D get_cpu_idle_time_us(cpu, NULL);
+ 	cputime64_t idle;
+=20
+ 	if (idle_time =3D=3D -1ULL) {
+ 		/* !NO_HZ so we can rely on cpustat.idle */
 -		idle =3D kstat_cpu(cpu).cpustat.idle;
 -		idle =3D cputime64_add(idle, arch_idle_time(cpu));
++		idle =3D kstat_cpu(cpu).cpustat.idle + arch_idle_time(cpu);
+ 	} else
+ 		idle =3D usecs_to_cputime(idle_time);
+=20
+ 	return idle;
+ }
+=20
+ static cputime64_t get_iowait_time(int cpu)
+ {
+ 	u64 iowait_time =3D get_cpu_iowait_time_us(cpu, NULL);
+ 	cputime64_t iowait;
+=20
+ 	if (iowait_time =3D=3D -1ULL)
+ 		/* !NO_HZ so we can rely on cpustat.iowait */
+ 		iowait =3D kstat_cpu(cpu).cpustat.iowait;
+ 	else
+ 		iowait =3D usecs_to_cputime(iowait_time);
+=20
+ 	return iowait;
+ }
+=20
  static int show_stat(struct seq_file *p, void *v)
  {
  	int i, j;
@@@ -39,16 -69,17 +68,16 @@@
  	jif =3D boottime.tv_sec;
 =20
  	for_each_possible_cpu(i) {
 -		user =3D cputime64_add(user, kstat_cpu(i).cpustat.user);
 -		nice =3D cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 -		system =3D cputime64_add(system, kstat_cpu(i).cpustat.system);
 -		idle =3D cputime64_add(idle, get_idle_time(i));
 -		iowait =3D cputime64_add(iowait, get_iowait_time(i));
 -		irq =3D cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 -		softirq =3D cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 -		steal =3D cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 -		guest =3D cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 -		guest_nice =3D cputime64_add(guest_nice,
 -			kstat_cpu(i).cpustat.guest_nice);
 +		user +=3D kstat_cpu(i).cpustat.user;
 +		nice +=3D kstat_cpu(i).cpustat.nice;
 +		system +=3D kstat_cpu(i).cpustat.system;
- 		idle +=3D kstat_cpu(i).cpustat.idle + arch_idle_time(i);
- 		iowait +=3D kstat_cpu(i).cpustat.iowait;
++		idle +=3D get_idle_time(i);
++		iowait +=3D  get_iowait_time(i);
 +		irq +=3D kstat_cpu(i).cpustat.irq;
 +		softirq +=3D kstat_cpu(i).cpustat.softirq;
 +		steal +=3D kstat_cpu(i).cpustat.steal;
 +		guest +=3D kstat_cpu(i).cpustat.guest;
 +		guest_nice +=3D kstat_cpu(i).cpustat.guest_nice;
  		sum +=3D kstat_cpu_irqs_sum(i);
  		sum +=3D arch_irq_stat_cpu(i);
 =20

--Signature=_Tue__25_Oct_2011_18_35_18_+1100_f.RC5SerKcTS2LUE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpma2AAoJEECxmPOUX5FEiJgQAKANDAmT/OMi+k2/B/uz1aCL
wfte3jhx7j35p4wtv0X3/AcddWKdjmv7KZ+Tn1PaRUFmHEj1yJ4xhSQlquWLH99n
qr+DuDO95IlKyYa0RNfKhdM72EYqXpJkVhQ9qxqaF3whXeHZVsZG/Br1GRW45QPI
3V63fhv3dKwNKyp918ccAgiSdVOvHvdYctCypEmN0Tvx0qoQOc7jegu0NrKcK5eM
z9e/QCemnoxUaiu0TaSkweWHk+IVdiaLqYXeZHoPgOkuSeQJLZSjyWI1ibS1zGR4
LkuL+L4EQfrJeco+FQCetPR0Vpeh8wzGwXlwekWAQ/CnLQkIGuvX//Rka5IZtCZA
lS87Ac6a6PkjUrS5+ao1pAkGoXrGoNG8DLsDnrqbnfQyKhWnenIVcsf578Cz2Uv3
0fVE1+zKCY4NQvl9ndJK22opAhwk8z4vtXKraq7+fhMrruhX5KRw2mwLp1neQBSK
gwnY2dcGEUwvzEBbgJ722qnfUDbXL2gOlGZe1X1wN1txVFokUPswBt8w8tbG2c4m
a09ZxkIEuliSghhc0mnfZgc/bid4Th09VNYLfmveq8Wwq4uRVlv/6JnQPiTXmN5j
i4wnhlloKB/cxavRkPSdxlkZPgpvlJtwiqQ3kSx4wWal1IbuVMHWEDZuDJhP776j
TjISX07XJeakpFyTyMzS
=Q28t
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_18_35_18_+1100_f.RC5SerKcTS2LUE--
