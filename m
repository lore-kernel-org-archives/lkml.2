Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab2ESNgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:36:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2ESNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:36:37 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=4DxiM1yUUzsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=8VYa5Bofk6_1wQGEyz4A:9 a=_atxi0d_ArSV0Ya4De4A:7 a=QEXdDO2ut3YA:10 a=KS-R6h4kOB8A:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=XerzmAdm2-pAM_q7WWUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120519133635.472089501@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 19 May 2012 09:35:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/3] ring-buffer: Merge separate resize loops
References: <20120519133551.942867137@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Merge-separate-resize-loops.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

There are 2 separate loops to resize cpu buffers that are online and
offline. Merge them to make the code look better.

Also change the name from update_completion to update_done to allow
shorter lines.

Link: http://lkml.kernel.org/r/1337372991-14783-1-git-send-email-vnagarnaik=
@google.com

Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 68388f8..6420cda 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -473,7 +473,7 @@ struct ring_buffer_per_cpu {
 	int				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
 	struct work_struct		update_pages_work;
-	struct completion		update_completion;
+	struct completion		update_done;
 };
=20
 struct ring_buffer {
@@ -1058,7 +1058,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, in=
t nr_pages, int cpu)
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock =3D (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
-	init_completion(&cpu_buffer->update_completion);
+	init_completion(&cpu_buffer->update_done);
=20
 	bpage =3D kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1461,7 +1461,7 @@ static void update_pages_handler(struct work_struct *=
work)
 	struct ring_buffer_per_cpu *cpu_buffer =3D container_of(work,
 			struct ring_buffer_per_cpu, update_pages_work);
 	rb_update_pages(cpu_buffer);
-	complete(&cpu_buffer->update_completion);
+	complete(&cpu_buffer->update_done);
 }
=20
 /**
@@ -1534,39 +1534,29 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size,
 		get_online_cpus();
 		/*
 		 * Fire off all the required work handlers
-		 * Look out for offline CPUs
-		 */
-		for_each_buffer_cpu(buffer, cpu) {
-			cpu_buffer =3D buffer->buffers[cpu];
-			if (!cpu_buffer->nr_pages_to_update ||
-			    !cpu_online(cpu))
-				continue;
-
-			schedule_work_on(cpu, &cpu_buffer->update_pages_work);
-		}
-		/*
-		 * This loop is for the CPUs that are not online.
-		 * We can't schedule anything on them, but it's not necessary
+		 * We can't schedule on offline CPUs, but it's not necessary
 		 * since we can change their buffer sizes without any race.
 		 */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer =3D buffer->buffers[cpu];
-			if (!cpu_buffer->nr_pages_to_update ||
-			    cpu_online(cpu))
+			if (!cpu_buffer->nr_pages_to_update)
 				continue;
=20
-			rb_update_pages(cpu_buffer);
+			if (cpu_online(cpu))
+				schedule_work_on(cpu,
+						&cpu_buffer->update_pages_work);
+			else
+				rb_update_pages(cpu_buffer);
 		}
=20
 		/* wait for all the updates to complete */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer =3D buffer->buffers[cpu];
-			if (!cpu_buffer->nr_pages_to_update ||
-			    !cpu_online(cpu))
+			if (!cpu_buffer->nr_pages_to_update)
 				continue;
=20
-			wait_for_completion(&cpu_buffer->update_completion);
-			/* reset this value */
+			if (cpu_online(cpu))
+				wait_for_completion(&cpu_buffer->update_done);
 			cpu_buffer->nr_pages_to_update =3D 0;
 		}
=20
@@ -1593,13 +1583,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, =
unsigned long size,
 		if (cpu_online(cpu_id)) {
 			schedule_work_on(cpu_id,
 					 &cpu_buffer->update_pages_work);
-			wait_for_completion(&cpu_buffer->update_completion);
+			wait_for_completion(&cpu_buffer->update_done);
 		} else
 			rb_update_pages(cpu_buffer);
=20
-		put_online_cpus();
-		/* reset this value */
 		cpu_buffer->nr_pages_to_update =3D 0;
+		put_online_cpus();
 	}
=20
  out:
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPt6HjAAoJEIy3vGnGbaoA0z4QAIgXuVXM5+NY+z5Kme9mfMx7
axWAv5MbB+d/+qEJ+ElZKxwJ49j0KiTaR6En3FzybqjlshWtwyMupnqhFD5zzO44
xN4mEJkekfKHl/aBaRpAzSc0saMW+qcZsI9ibdkouHneAX9j8gsNbsHWEwz2XGUy
NRASkiw4vvw0kBIGYSq5rM62dXKu0KhQKIa+mzH6jpqxvWNh4883z/mYEv2YSPzY
3Ny0ykqiASdRRW4Ly5tCI0Evu2XqgMpdQUGPEpR83OXNuR2bTEu/RpcVXscEcrwX
O9QtiE/rIWJHXwa0JG4CLaScO+L1D8ANknHP83U9lD42WsZbD7JYT8oFA3KU6PeZ
WOJXwS4/1cZRC5QR9zNfTzW1lX1l9Z03bBsUpv/rP1uYMEzas39J2VEI/QMR45E3
dKB+b73u73tJWD3j27v6xf/czUVylhWyUyrve7ChGkfCD7NxEgHulfEqO8jRC6Ts
a//p3jZw3gnjQUmGlk2VRSGFAjsSk5IFzsi2gffVSnUsiHqsZBFqmXweiUwzqxGE
BTuPcm4mtrrRIe8ZOnjT9W0XJg9tzWZ1c0Ap1ZdDe3U7yyqCn9Zq0ogWRDnwDTRV
QdxmnIbkEcWli3qb64KeclZs3hC0ps2dfUpqkaEz49d24mljmvpb05lGmlz4Ncsl
dzR+UzyeLfV8ToN9EiZ9
=8Zs3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
