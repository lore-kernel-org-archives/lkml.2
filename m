Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2ATR2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:28:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39369 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2ATR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:28:36 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=AfHLeiCYFrweSim_uA0A:9 a=g64D59l-efpmd9k6U4AA:7 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=VSknwxr_VziLByKx:21 a=XT5x3_EWzBsbzCNi:21 a=zXRj-0YoypRXIlwP7jEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327080509.3756.16.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.14-rt32
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Date: Fri, 20 Jan 2012 12:28:29 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GhzL74WzJxxYP+tLYghS"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GhzL74WzJxxYP+tLYghS
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.14-rt32 stable release.

Note, I will no longer be pushing out the broken out patch queue. It was
brought to my attention that the broken out patches no longer apply to
the stable kernel. This is because the broken out patches were created
with git format-patch. As I do not rebase the stable git repo, and only
merge in new stable releases, the patches created by git format-patch do
not apply to the new stable kernels. As this kernel is now maintained in
git, there is no reason to have the broken out patches. If you want to
see them, just do a git format-patch yourself.

For those that don't want to use git, you still have both the
incremental patch and the mega patch with all changes. But if you want
to see individual changes, you will now need to use git.

Also, there have been reports that there are still bugs remaining in
stable-rt -rc release. As these bugs are not regressions, I am releasing
3.0.14-rt32. I will now merge in the latest stable tree and hopefully
that will fix some of the remaining bugs.

One change has been done since 3.0.14-rt32-rc1. That was to add the
module.h header in wait-simple.c. Thanks to Mike Galbraith for pointing
that out.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: c2f2b39a5157e5df29afd370c8a3b36dcff7385c


Or to build 3.0.14-rt32 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.14.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.14-rt32.=
patch.xz


You can also build from 3.0.14-rt31 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.14-=
rt31-rt32.patch.xz



Enjoy,

-- Steve


Changes from 3.0.14-rt31:

---

Steven Rostedt (1):
      Linux 3.0.14-rt32

Thomas Gleixner (3):
      sched: ttwu: Return success when only changing the saved_state value
      wait-simple: Simple waitqueue implementation
      acpi-gpe-use-wait-simple.patch

----
 drivers/acpi/ec.c           |    8 +-
 drivers/acpi/internal.h     |    4 +-
 include/linux/wait-simple.h |  152 +++++++++++++++++++++++++++++++++++++++=
++++
 kernel/Makefile             |    2 +-
 kernel/sched.c              |    4 +-
 kernel/wait-simple.c        |   63 ++++++++++++++++++
 localversion-rt             |    2 +-
 7 files changed, 227 insertions(+), 8 deletions(-)
---------------------------
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5812e01..db0e6c3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -222,7 +222,7 @@ static int ec_poll(struct acpi_ec *ec)
 				if (ec_transaction_done(ec))
 					return 0;
 			} else {
-				if (wait_event_timeout(ec->wait,
+				if (swait_event_timeout(ec->wait,
 						ec_transaction_done(ec),
 						msecs_to_jiffies(1)))
 					return 0;
@@ -272,7 +272,7 @@ static int ec_wait_ibf0(struct acpi_ec *ec)
 	unsigned long delay =3D jiffies + msecs_to_jiffies(ec_delay);
 	/* interrupt wait manually if GPE mode is not active */
 	while (time_before(jiffies, delay))
-		if (wait_event_timeout(ec->wait, ec_check_ibf0(ec),
+		if (swait_event_timeout(ec->wait, ec_check_ibf0(ec),
 					msecs_to_jiffies(1)))
 			return 0;
 	return -ETIME;
@@ -612,7 +612,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	advance_transaction(ec, acpi_ec_read_status(ec));
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) =3D=3D 0) {
-		wake_up(&ec->wait);
+		swait_wake(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
 	}
 	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
@@ -676,7 +676,7 @@ static struct acpi_ec *make_acpi_ec(void)
 		return NULL;
 	ec->flags =3D 1 << EC_FLAGS_QUERY_PENDING;
 	mutex_init(&ec->lock);
-	init_waitqueue_head(&ec->wait);
+	init_swait_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
 	raw_spin_lock_init(&ec->curr_lock);
 	return ec;
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 68ed95f..2519b6e 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -23,6 +23,8 @@
=20
 #define PREFIX "ACPI: "
=20
+#include <linux/wait-simple.h>
+
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
 int acpi_sysfs_init(void);
@@ -59,7 +61,7 @@ struct acpi_ec {
 	unsigned long global_lock;
 	unsigned long flags;
 	struct mutex lock;
-	wait_queue_head_t wait;
+	struct swait_head wait;
 	struct list_head list;
 	struct transaction *curr;
 	raw_spinlock_t curr_lock;
diff --git a/include/linux/wait-simple.h b/include/linux/wait-simple.h
new file mode 100644
index 0000000..de69d8a
--- /dev/null
+++ b/include/linux/wait-simple.h
@@ -0,0 +1,152 @@
+#ifndef _LINUX_WAIT_SIMPLE_H
+#define _LINUX_WAIT_SIMPLE_H
+
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+#include <asm/current.h>
+
+struct swaiter {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
+#define DEFINE_SWAITER(name)					\
+	struct swaiter name =3D {					\
+		.task	=3D current,				\
+		.node	=3D LIST_HEAD_INIT((name).node),		\
+	}
+
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name =3D {				\
+		.lock	=3D __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.list	=3D LIST_HEAD_INIT((name).list),		\
+	}
+
+extern void __init_swait_head(struct swait_head *h, struct lock_class_key =
*key);
+
+#define init_swait_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swait_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+static inline bool swaiter_enqueued(struct swaiter *w)
+{
+	return w->task !=3D NULL;
+}
+
+extern void swait_prepare(struct swait_head *head, struct swaiter *w, int =
state);
+extern void swait_finish(struct swait_head *head, struct swaiter *w);
+
+/*
+ * Adds w to head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter=
 *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/*
+ * Removes w from head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/*
+ * Wakeup functions
+ */
+extern void __swait_wake(struct swait_head *head, unsigned int state);
+
+static inline void swait_wake(struct swait_head *head)
+{
+	__swait_wake(head, TASK_NORMAL);
+}
+
+/*
+ * Event API
+ */
+
+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_timeout(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		ret =3D schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_timeout - sleep until a condition gets true or a timeout el=
apses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, and the remaining
+ * jiffies if the condition evaluated to true before the timeout elapsed.
+ */
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret =3D timeout;						\
+	if (!(condition))						\
+		__swait_event_timeout(wq, condition, __ret);		\
+	__ret;								\
+})
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 11949f1..6a9558b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     =3D sched.o fork.o exec_domain.o panic.o printk=
.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o wait-simple.o jump_label.o
 obj-y +=3D groups.o
=20
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/sched.c b/kernel/sched.c
index 63aeba0..e5ef7a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2693,8 +2693,10 @@ try_to_wake_up(struct task_struct *p, unsigned int s=
tate, int wake_flags)
 		 * if the wakeup condition is true.
 		 */
 		if (!(wake_flags & WF_LOCK_SLEEPER)) {
-			if (p->saved_state & state)
+			if (p->saved_state & state) {
 				p->saved_state =3D TASK_RUNNING;
+				success =3D 1;
+			}
 		}
 		goto out;
 	}
diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
new file mode 100644
index 0000000..35cc000
--- /dev/null
+++ b/kernel/wait-simple.c
@@ -0,0 +1,63 @@
+/*
+ * Simple waitqueues without fancy flags and callbacks
+ *
+ * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
+ *
+ * Based on kernel/wait.c
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/wait-simple.h>
+
+void __init_swait_head(struct swait_head *head, struct lock_class_key *key=
)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->list);
+}
+EXPORT_SYMBOL_GPL(__init_swait_head);
+
+void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	w->task =3D current;
+	__swait_enqueue(head, w);
+	set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(swait_prepare);
+
+void swait_finish(struct swait_head *head, struct swaiter *w)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	if (w->task) {
+		raw_spin_lock_irqsave(&head->lock, flags);
+		__swait_dequeue(w);
+		raw_spin_unlock_irqrestore(&head->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(swait_finish);
+
+void __swait_wake(struct swait_head *head, unsigned int state)
+{
+	struct swaiter *curr, *next;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+
+	list_for_each_entry_safe(curr, next, &head->list, node) {
+		if (wake_up_state(curr->task, state)) {
+			__swait_dequeue(curr);
+			curr->task =3D NULL;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
diff --git a/localversion-rt b/localversion-rt
index a68b433..ce6a482 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt31
+-rt32


--=-GhzL74WzJxxYP+tLYghS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPGaQ9AAoJEIy3vGnGbaoA+tgP/14/sZY3g4HoNwpmkyKB3fgE
jnMgP2iJ7Z+U2sjqxFyVHkMUp0mPOiLDNkA+EsVqk7PyNMt4ykIhgxE65XdGhleC
0Gj1G8nUOB9olEqj0UJJbOudsIgggwFTBUDj6DKsc8wFenpxSsf8WYnl3xUiZ5ij
NSO6JHEFAQ5ALaWNx9CB9nemOtZo100T/XcLzmbOYCQm4vAlLX5shWAEzO6EEKLA
dIj9v0iqwdk7+OKMOEfxV81Ti01JVnR9dclQWFWk+C3log4qVk6Ll5Z/kXrz87Rc
ezuLvsPwETOb9xujNG4UTi9trE7bc0Kazkth1nS/aegd65jYZM76K4DUO75++Co1
4Iscu7fTOVQQK5wvLMoZyfyWk60etw15Wu+JRvCcLINMVwv+cQVfi+GSfdIPUhyn
vj27X9KmX8BE6LbCGNlLRPgJq7mGPKe1jJw4sdsEBTu7GIhtBuaBqeqmTDemjTyl
soQkheeviJt/B3+sZW0bDNXgaKiCVEHwwFhIOpBU4Oeqi1tU53ejKsm7Y5sttCjJ
6i51Zj9HWqa3AWJrEqh9boGnq9SJOSnlaN0dKBSKu1Hvo3tzKNDLBzzLWK0kNd91
SQWeQNU3fml0Ysrmfi7zEG9WHR4iOzK34Qo/WFuZ6fHRd/Img2vSPxp3xuAk6lBV
y56P+bKphWSlJE7A0w5B
=zDBJ
-----END PGP SIGNATURE-----

--=-GhzL74WzJxxYP+tLYghS--

