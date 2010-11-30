Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0K3SwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:52:02 -0500
Received: from ms01.sssup.it ([193.205.80.99]:51747 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784Ab0K3SwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:52:00 -0500
Subject: [PATCH] sched: make pushable_tasks CONFIG_SMP dependant.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1IlWWQtHyKpw/XR5p/7p"
Date: Tue, 30 Nov 2010 19:51:33 +0100
Message-ID: <1291143093.2697.298.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1IlWWQtHyKpw/XR5p/7p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As noted by Peter Zijlstra here https://lkml.org/lkml/2010/11/10/391
(while reviewing other stuff, though), tracking pushable tasks
only makes sense on SMPs.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/init_task.h |    9 ++++++++-
 include/linux/sched.h     |    2 ++
 kernel/sched.c            |    2 ++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f8c06c..6ed8812 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -12,6 +12,13 @@
 #include <linux/securebits.h>
 #include <net/net_namespace.h>
=20
+#ifdef CONFIG_SMP
+# define INIT_PUSHABLE_TASKS(tsk)					\
+	.pushable_tasks =3D PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO),
+#else
+# define INIT_PUSHABLE_TASKS(tsk)
+#endif
+
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
=20
@@ -137,7 +144,7 @@ extern struct cred init_cred;
 		.nr_cpus_allowed =3D NR_CPUS,				\
 	},								\
 	.tasks		=3D LIST_HEAD_INIT(tsk.tasks),			\
-	.pushable_tasks =3D PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
+	INIT_PUSHABLE_TASKS(tsk)					\
 	.ptraced	=3D LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	=3D LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	=3D &tsk,						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0fc8ee..eae4131 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1244,7 +1244,9 @@ struct task_struct {
 #endif
=20
 	struct list_head tasks;
+#ifdef CONFIG_SMP
 	struct plist_node pushable_tasks;
+#endif
=20
 	struct mm_struct *mm, *active_mm;
 #if defined(SPLIT_RSS_COUNTING)
diff --git a/kernel/sched.c b/kernel/sched.c
index 0debad9..166f9f8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2595,7 +2595,9 @@ void sched_fork(struct task_struct *p, int clone_flag=
s)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count =3D 1;
 #endif
+#ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
+#endif
=20
 	put_cpu();
 }
--=20
1.7.2.3

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-1IlWWQtHyKpw/XR5p/7p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkz1R60ACgkQk4XaBE3IOsR1AwCff8ux11nntUcl8n4ZDDXcI4fa
BuAAnjrotdZO/EIAQvetotU0gHeNZ6Aj
=/YP1
-----END PGP SIGNATURE-----

--=-1IlWWQtHyKpw/XR5p/7p--

