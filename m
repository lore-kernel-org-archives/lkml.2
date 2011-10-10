Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1JJNqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:46:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab1JJNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:40 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=wcdmOFjdefwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7d_E57ReAAAA:8 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=JQPa_b3VZhMwvoEwGp4A:9 a=monqSxFlZvkStwVGmqUA:7 a=QEXdDO2ut3YA:10 a=D6-X0JM3zdQA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=nuFonRLdc8OWMynR:21 a=8o6rwKegUk97ASZs:21 a=tjN5YKOCHrhnDKdR2I8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134137.925269465@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 02/20] Tracepoint: Dissociate from module mutex
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0002-Tracepoint-Dissociate-from-module-mutex.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Copy the information needed from struct module into a local module list
held within tracepoint.c from within the module coming/going notifier.

This vastly simplifies locking of tracepoint registration /
unregistration, because we don't have to take the module mutex to
register and unregister tracepoints anymore. Steven Rostedt ran into
dependency problems related to modules mutex vs kprobes mutex vs ftrace
mutex vs tracepoint mutex that seems to be hard to fix without removing
this dependency between tracepoint and module mutex. (note: it should be
investigated whether kprobes could benefit of being dissociated from the
modules mutex too.)

This also fixes module handling of tracepoint list iterators, because it
was expecting the list to be sorted by pointer address. Given we have
control on our own list now, it's OK to sort this list which has
tracepoints as its only purpose. The reason why this sorting is required
is to handle the fact that seq files (and any read() operation from
user-space) cannot hold the tracepoint mutex across multiple calls, so
list entries may vanish between calls. With sorting, the tracepoint
iterator becomes usable even if the list don't contain the exact item
pointed to by the iterator anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20110810191839.GC8525@Krystal
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/module.h     |   12 ---
 include/linux/tracepoint.h |   25 +++----
 kernel/module.c            |   47 ------------
 kernel/tracepoint.c        |  169 ++++++++++++++++++++++++++++++++++++++--=
----
 4 files changed, 158 insertions(+), 95 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 1c30087..8639216 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -580,9 +580,6 @@ int unregister_module_notifier(struct notifier_block * =
nb);
=20
 extern void print_modules(void);
=20
-extern void module_update_tracepoints(void);
-extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -698,15 +695,6 @@ static inline int unregister_module_notifier(struct no=
tifier_block * nb)
 static inline void print_modules(void)
 {
 }
-
-static inline void module_update_tracepoints(void)
-{
-}
-
-static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
-{
-	return 0;
-}
 #endif /* CONFIG_MODULES */
=20
 #ifdef CONFIG_SYSFS
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d530a44..df0a779 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -54,8 +54,18 @@ extern int tracepoint_probe_unregister_noupdate(const ch=
ar *name, void *probe,
 						void *data);
 extern void tracepoint_probe_update_all(void);
=20
+#ifdef CONFIG_MODULES
+struct tp_module {
+	struct list_head list;
+	unsigned int num_tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
+};
+#endif /* CONFIG_MODULES */
+
 struct tracepoint_iter {
-	struct module *module;
+#ifdef CONFIG_MODULES
+	struct tp_module *module;
+#endif /* CONFIG_MODULES */
 	struct tracepoint * const *tracepoint;
 };
=20
@@ -63,8 +73,6 @@ extern void tracepoint_iter_start(struct tracepoint_iter =
*iter);
 extern void tracepoint_iter_next(struct tracepoint_iter *iter);
 extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
 extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint * const **tracepoin=
t,
-	struct tracepoint * const *begin, struct tracepoint * const *end);
=20
 /*
  * tracepoint_synchronize_unregister must be called between the last trace=
point
@@ -78,17 +86,6 @@ static inline void tracepoint_synchronize_unregister(voi=
d)
=20
 #define PARAMS(args...) args
=20
-#ifdef CONFIG_TRACEPOINTS
-extern
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-	struct tracepoint * const *end);
-#else
-static inline
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-	struct tracepoint * const *end)
-{ }
-#endif /* CONFIG_TRACEPOINTS */
-
 #endif /* _LINUX_TRACEPOINT_H */
=20
 /*
diff --git a/kernel/module.c b/kernel/module.c
index 04379f92..93342d9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3487,50 +3487,3 @@ void module_layout(struct module *mod,
 }
 EXPORT_SYMBOL(module_layout);
 #endif
-
-#ifdef CONFIG_TRACEPOINTS
-void module_update_tracepoints(void)
-{
-	struct module *mod;
-
-	mutex_lock(&module_mutex);
-	list_for_each_entry(mod, &modules, list)
-		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints_ptrs,
-				mod->tracepoints_ptrs + mod->num_tracepoints);
-	mutex_unlock(&module_mutex);
-}
-
-/*
- * Returns 0 if current not found.
- * Returns 1 if current found.
- */
-int module_get_iter_tracepoints(struct tracepoint_iter *iter)
-{
-	struct module *iter_mod;
-	int found =3D 0;
-
-	mutex_lock(&module_mutex);
-	list_for_each_entry(iter_mod, &modules, list) {
-		if (!iter_mod->taints) {
-			/*
-			 * Sorted module list
-			 */
-			if (iter_mod < iter->module)
-				continue;
-			else if (iter_mod > iter->module)
-				iter->tracepoint =3D NULL;
-			found =3D tracepoint_get_iter_range(&iter->tracepoint,
-				iter_mod->tracepoints_ptrs,
-				iter_mod->tracepoints_ptrs
-					+ iter_mod->num_tracepoints);
-			if (found) {
-				iter->module =3D iter_mod;
-				break;
-			}
-		}
-	}
-	mutex_unlock(&module_mutex);
-	return found;
-}
-#endif
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index b219f14..db110b8 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -34,11 +34,16 @@ extern struct tracepoint * const __stop___tracepoints_p=
trs[];
 static const int tracepoint_debug;
=20
 /*
- * tracepoints_mutex nests inside module_mutex. Tracepoints mutex protects=
 the
- * builtin and module tracepoints and the hash table.
+ * Tracepoints mutex protects the builtin and module tracepoints and the h=
ash
+ * table, as well as the local module list.
  */
 static DEFINE_MUTEX(tracepoints_mutex);
=20
+#ifdef CONFIG_MODULES
+/* Local list of struct module */
+static LIST_HEAD(tracepoint_module_list);
+#endif /* CONFIG_MODULES */
+
 /*
  * Tracepoint hash table, containing the active tracepoints.
  * Protected by tracepoints_mutex.
@@ -292,9 +297,10 @@ static void disable_tracepoint(struct tracepoint *elem)
  * @end: end of the range
  *
  * Updates the probe callback corresponding to a range of tracepoints.
+ * Called with tracepoints_mutex held.
  */
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-				   struct tracepoint * const *end)
+static void tracepoint_update_probe_range(struct tracepoint * const *begin,
+					  struct tracepoint * const *end)
 {
 	struct tracepoint * const *iter;
 	struct tracepoint_entry *mark_entry;
@@ -302,7 +308,6 @@ void tracepoint_update_probe_range(struct tracepoint * =
const *begin,
 	if (!begin)
 		return;
=20
-	mutex_lock(&tracepoints_mutex);
 	for (iter =3D begin; iter < end; iter++) {
 		mark_entry =3D get_tracepoint((*iter)->name);
 		if (mark_entry) {
@@ -312,11 +317,27 @@ void tracepoint_update_probe_range(struct tracepoint =
* const *begin,
 			disable_tracepoint(*iter);
 		}
 	}
-	mutex_unlock(&tracepoints_mutex);
 }
=20
+#ifdef CONFIG_MODULES
+void module_update_tracepoints(void)
+{
+	struct tp_module *tp_mod;
+
+	list_for_each_entry(tp_mod, &tracepoint_module_list, list)
+		tracepoint_update_probe_range(tp_mod->tracepoints_ptrs,
+			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
+}
+#else /* CONFIG_MODULES */
+void module_update_tracepoints(void)
+{
+}
+#endif /* CONFIG_MODULES */
+
+
 /*
  * Update probes, removing the faulty probes.
+ * Called with tracepoints_mutex held.
  */
 static void tracepoint_update_probes(void)
 {
@@ -359,11 +380,12 @@ int tracepoint_probe_register(const char *name, void =
*probe, void *data)
=20
 	mutex_lock(&tracepoints_mutex);
 	old =3D tracepoint_add_probe(name, probe, data);
-	mutex_unlock(&tracepoints_mutex);
-	if (IS_ERR(old))
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
-
+	}
 	tracepoint_update_probes();		/* may update entry */
+	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
 	return 0;
 }
@@ -402,11 +424,12 @@ int tracepoint_probe_unregister(const char *name, voi=
d *probe, void *data)
=20
 	mutex_lock(&tracepoints_mutex);
 	old =3D tracepoint_remove_probe(name, probe, data);
-	mutex_unlock(&tracepoints_mutex);
-	if (IS_ERR(old))
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
-
+	}
 	tracepoint_update_probes();		/* may update entry */
+	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
 	return 0;
 }
@@ -489,9 +512,8 @@ void tracepoint_probe_update_all(void)
 	if (!list_empty(&old_probes))
 		list_replace_init(&old_probes, &release_probes);
 	need_update =3D 0;
-	mutex_unlock(&tracepoints_mutex);
-
 	tracepoint_update_probes();
+	mutex_unlock(&tracepoints_mutex);
 	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
 		list_del(&pos->u.list);
 		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
@@ -509,7 +531,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
  * Will return the first tracepoint in the range if the input tracepoint is
  * NULL.
  */
-int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+static int tracepoint_get_iter_range(struct tracepoint * const **tracepoin=
t,
 	struct tracepoint * const *begin, struct tracepoint * const *end)
 {
 	if (!*tracepoint && begin !=3D end) {
@@ -520,11 +542,12 @@ int tracepoint_get_iter_range(struct tracepoint * con=
st **tracepoint,
 		return 1;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tracepoint_get_iter_range);
=20
+#ifdef CONFIG_MODULES
 static void tracepoint_get_iter(struct tracepoint_iter *iter)
 {
 	int found =3D 0;
+	struct tp_module *iter_mod;
=20
 	/* Core kernel tracepoints */
 	if (!iter->module) {
@@ -534,12 +557,43 @@ static void tracepoint_get_iter(struct tracepoint_ite=
r *iter)
 		if (found)
 			goto end;
 	}
-	/* tracepoints in modules. */
-	found =3D module_get_iter_tracepoints(iter);
+	/* Tracepoints in modules */
+	mutex_lock(&tracepoints_mutex);
+	list_for_each_entry(iter_mod, &tracepoint_module_list, list) {
+		/*
+		 * Sorted module list
+		 */
+		if (iter_mod < iter->module)
+			continue;
+		else if (iter_mod > iter->module)
+			iter->tracepoint =3D NULL;
+		found =3D tracepoint_get_iter_range(&iter->tracepoint,
+			iter_mod->tracepoints_ptrs,
+			iter_mod->tracepoints_ptrs
+				+ iter_mod->num_tracepoints);
+		if (found) {
+			iter->module =3D iter_mod;
+			break;
+		}
+	}
+	mutex_unlock(&tracepoints_mutex);
 end:
 	if (!found)
 		tracepoint_iter_reset(iter);
 }
+#else /* CONFIG_MODULES */
+static void tracepoint_get_iter(struct tracepoint_iter *iter)
+{
+	int found =3D 0;
+
+	/* Core kernel tracepoints */
+	found =3D tracepoint_get_iter_range(&iter->tracepoint,
+			__start___tracepoints_ptrs,
+			__stop___tracepoints_ptrs);
+	if (!found)
+		tracepoint_iter_reset(iter);
+}
+#endif /* CONFIG_MODULES */
=20
 void tracepoint_iter_start(struct tracepoint_iter *iter)
 {
@@ -566,26 +620,98 @@ EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
=20
 void tracepoint_iter_reset(struct tracepoint_iter *iter)
 {
+#ifdef CONFIG_MODULES
 	iter->module =3D NULL;
+#endif /* CONFIG_MODULES */
 	iter->tracepoint =3D NULL;
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
=20
 #ifdef CONFIG_MODULES
+static int tracepoint_module_coming(struct module *mod)
+{
+	struct tp_module *tp_mod, *iter;
+	int ret =3D 0;
+
+	/*
+	 * We skip modules that tain the kernel, especially those with different
+	 * module header (for forced load), to make sure we don't cause a crash.
+	 */
+	if (mod->taints)
+		return 0;
+	mutex_lock(&tracepoints_mutex);
+	tp_mod =3D kmalloc(sizeof(struct tp_module), GFP_KERNEL);
+	if (!tp_mod) {
+		ret =3D -ENOMEM;
+		goto end;
+	}
+	tp_mod->num_tracepoints =3D mod->num_tracepoints;
+	tp_mod->tracepoints_ptrs =3D mod->tracepoints_ptrs;
+
+	/*
+	 * tracepoint_module_list is kept sorted by struct module pointer
+	 * address for iteration on tracepoints from a seq_file that can release
+	 * the mutex between calls.
+	 */
+	list_for_each_entry_reverse(iter, &tracepoint_module_list, list) {
+		BUG_ON(iter =3D=3D tp_mod);	/* Should never be in the list twice */
+		if (iter < tp_mod) {
+			/* We belong to the location right after iter. */
+			list_add(&tp_mod->list, &iter->list);
+			goto module_added;
+		}
+	}
+	/* We belong to the beginning of the list */
+	list_add(&tp_mod->list, &tracepoint_module_list);
+module_added:
+	tracepoint_update_probe_range(mod->tracepoints_ptrs,
+		mod->tracepoints_ptrs + mod->num_tracepoints);
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+
+static int tracepoint_module_going(struct module *mod)
+{
+	struct tp_module *pos;
+
+	mutex_lock(&tracepoints_mutex);
+	tracepoint_update_probe_range(mod->tracepoints_ptrs,
+		mod->tracepoints_ptrs + mod->num_tracepoints);
+	list_for_each_entry(pos, &tracepoint_module_list, list) {
+		if (pos->tracepoints_ptrs =3D=3D mod->tracepoints_ptrs) {
+			list_del(&pos->list);
+			kfree(pos);
+			break;
+		}
+	}
+	/*
+	 * In the case of modules that were tainted at "coming", we'll simply
+	 * walk through the list without finding it. We cannot use the "tainted"
+	 * flag on "going", in case a module taints the kernel only after being
+	 * loaded.
+	 */
+	mutex_unlock(&tracepoints_mutex);
+	return 0;
+}
=20
 int tracepoint_module_notify(struct notifier_block *self,
 			     unsigned long val, void *data)
 {
 	struct module *mod =3D data;
+	int ret =3D 0;
=20
 	switch (val) {
 	case MODULE_STATE_COMING:
+		ret =3D tracepoint_module_coming(mod);
+		break;
+	case MODULE_STATE_LIVE:
+		break;
 	case MODULE_STATE_GOING:
-		tracepoint_update_probe_range(mod->tracepoints_ptrs,
-			mod->tracepoints_ptrs + mod->num_tracepoints);
+		ret =3D tracepoint_module_going(mod);
 		break;
 	}
-	return 0;
+	return ret;
 }
=20
 struct notifier_block tracepoint_module_nb =3D {
@@ -598,7 +724,6 @@ static int init_tracepoints(void)
 	return register_module_notifier(&tracepoint_module_nb);
 }
 __initcall(init_tracepoints);
-
 #endif /* CONFIG_MODULES */
=20
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYSAAoJEIy3vGnGbaoA5LYQAJ+9RO3IDk2kxDlz37TnxOTt
iQQuZXd7mWH3D29PF2i05wPyv84nFANq8qp8upGp5zH5oE/RTjPje4VAt2wetPVu
sAET44mClMYIVe1JVTqpuViGEpZNiKoV/o+0b6EBoz/HtwRTtlMs4zpYTdn+MMmQ
7rzJ4aGqLUwnshw236hHVS1R7PLbCE+cKNfn3Si6EXbxDU2ok7JppUnV9V+h5eDT
+05U3SHl1ysrlBoOFov/qKn9spmvLlKxO/dhZmeiVkXLPyhhHMOXfFZgEcYvZj3B
IHnZZ1t2UlnTmBxWtWRolESwbnac3TGHu69Pq6BRoVb4GSCiDAOEydsJbpR1A0Tq
HfixrSJRoYCt1IOC2SMVCu5Xgs4LQYsedpMFMbCw3y/Hg6cC7tlTX0ZJWSz+0Gvo
7v9HjE2iHsIDawt6QJZwdVHin27JjU+ZZi4/rDJj9nC+ks/bEGMYf/6yatqCTl6s
WD5mE2ynIhrcL7TgfbRDnmyG2IKtBLRJpCH2sQmQ5w2j/qNdtQ2RdoFwaWPIu5Ue
rKpbZZZA7ZZtfYaxeS0SVdAlbdGGNiptCsDZixjQ5ObgC5DxGhTWpPmJKlAF6gn3
8NzBSVmuO/BE8jj23xr4DOYsRXjLohwgy4rfYDdHKn63SZALXARKc32h0BeIu+am
qNXYF5zdqRrMNvh/0/Q8
=FPZR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
