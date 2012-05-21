Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2EUHuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:50:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41287 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2EUHuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:50:19 -0400
Date: Mon, 21 May 2012 17:50:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the userns tree
Message-Id: <20120521175009.7bd4948c026d8acc61f26753@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_17_50_09_+1000_yOX15ztliT=ENxQW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_17_50_09_+1000_yOX15ztliT=ENxQW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the userns tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/sched/numa.c: In function 'ng_allowed':
kernel/sched/numa.c:1270:16: error: 'struct user_struct' has no member name=
d 'user_ns'
kernel/sched/numa.c:1270:40: error: 'struct user_struct' has no member name=
d 'user_ns'
kernel/sched/numa.c:1278:28: error: 'struct user_struct' has no member name=
d 'user_ns'

Caused by commit a2dae61eb839 ("sched/numa: Introduce sys_numa_{t,m}bind
()") from the tip tree interacting with commit d0bd6594e286 ("userns:
Deprecate and rename the user_namespace reference in the user_struct")
from the userns tree.

I applied this merge fix up patch (more may be required):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 21 May 2012 17:40:55 +1000
Subject: [PATCH] userns: fix up for user_ns move to struct cred

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/sched/numa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 8eb92f7..1149993 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -1267,7 +1267,7 @@ static int ng_allowed(struct numa_group *ng, struct t=
ask_struct *p)
=20
 	rcu_read_lock();
 	tcred =3D __task_cred(p);
-	if (cred->user->user_ns =3D=3D tcred->user->user_ns &&
+	if (cred->user_ns =3D=3D tcred->user_ns &&
 	    (cred->uid =3D=3D tcred->euid &&
 	     cred->uid =3D=3D tcred->suid &&
 	     cred->uid =3D=3D tcred->uid  &&
@@ -1275,7 +1275,7 @@ static int ng_allowed(struct numa_group *ng, struct t=
ask_struct *p)
 	     cred->gid =3D=3D tcred->sgid &&
 	     cred->gid =3D=3D tcred->gid))
 		goto ok;
-	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+	if (ns_capable(tcred->user_ns, CAP_SYS_PTRACE))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
--=20
1.7.10.280.gaa39


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_May_2012_17_50_09_+1000_yOX15ztliT=ENxQW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPufOxAAoJEECxmPOUX5FE2MwP/0i1/487OfnbtnhCW8CWNYT8
ZjfpltuXWNRIuBdevrsIjOePSyuM1UF0bvuVNnyzhGedxlYqZtKut/Rn0aGXtVfF
paOi1SvBU1lFEQkIl6R+VAv0PGuWK3ir4IpyzJkO9OjMK8lMYvkI2pfofvePM6Eo
OqwmzSpwt/PyozrPb/aCV9/Y6+pUNdYfONkVRm05kyGWdIYkYCBBy8nArPlEIze4
QXZhJUgEFiHsC8IV1SOklu2JvAWbtdQ1VrzTQz+kgg1QVxzBnVSJVU4nw9nsGrNn
PlS4xaYPR4mQndy+sk5Vg+IKsgq6n26DJ5mJ+n/c9X1nf6WEBJwbuCu/krvka8vx
jkJg04lnDpLIs4N/vaLzeVdl/44DDD54T1+mrOeZEQdmihjb/O8j6Ukrp5cVjb0u
KToQqXXPv5AsZenpQXnpGu+u9LKUtMTF2G2rbrbbnD9InQhUsf9vuQjHVyLgMSdu
p5RxC44LeS9WaF60EfFz7uFA7tnM2tKMOF9ALQ+DxB4JWIxRrrORjSuEVdgB5kI0
jVvFjeJM1806dmV5RW39o7p4IRWLK4X2fbWa4Yffn8hc6GaprWnQVb3NjlZT7IfZ
APZ+1O3tOmNSKVqHfTi7Rf7etm8pdjpnd8dRRBeYczYE5MI0Hkw1sszygZx6D5s6
uVoip0F8tWiaOJ32iXfC
=Vkjz
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_17_50_09_+1000_yOX15ztliT=ENxQW--
