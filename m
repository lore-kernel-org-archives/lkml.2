Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0HXKSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:18:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:42308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab0HXKSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:18:47 -0400
Message-ID: <4C739B49.6080409@kernel.org>
Date: Tue, 24 Aug 2010 12:13:29 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH REPOST 2.6.36-rc2] percpu_counter: add debugobj support
References: <20100813134756.GA5235@swordfish.minsk.epam.com> <4C73899A.304@kernel.org> <20100824091536.GA5440@swordfish.minsk.epam.com>
In-Reply-To: <20100824091536.GA5440@swordfish.minsk.epam.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 10:18:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All percpu counters are linked to a global list on initialization and
removed from it on destruction.  The list is walked during CPU
up/down.  If a percpu counter is freed without being properly
destroyed, the system will oops only on the next CPU up/down making it
pretty nasty to track down.  This patch adds debugobj support for
percpu counters so that such problems can be found easily.

As percpu counters don't make sense on stack and can't be statically
initialized, debugobj support is pretty simple.  It's initialized and
activated on counter initialization, and deactivatd and destroyed on
counter destruction.  With this patch applied, the bug fixed by commit
602586a83b719df0fbd94196a1359ed35aeb2df3 (shmem: put_super must
percpu_counter_destroy) triggers the following warning on tmpfs
unmount and the system won't oops on the next cpu up/down operation.

 ------------[ cut here ]------------
 WARNING: at /devel/tj/os/work/lib/debugobjects.c:259 debug_print_object+0x5c/0x70()
 Hardware name: Bochs
 ODEBUG: free active (active state 0) object type: percpu_counter
 Modules linked in:
 Pid: 3999, comm: umount Not tainted 2.6.36-rc2-work+ #5
 Call Trace:
  [<ffffffff81083f7f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff81084076>] warn_slowpath_fmt+0x46/0x50
  [<ffffffff813b45cc>] debug_print_object+0x5c/0x70
  [<ffffffff813b50e5>] debug_check_no_obj_freed+0x125/0x210
  [<ffffffff811577d3>] kfree+0xb3/0x2f0
  [<ffffffff81132edd>] shmem_put_super+0x1d/0x30
  [<ffffffff81162e96>] generic_shutdown_super+0x56/0xe0
  [<ffffffff81162f86>] kill_anon_super+0x16/0x60
  [<ffffffff81162ff7>] kill_litter_super+0x27/0x30
  [<ffffffff81163295>] deactivate_locked_super+0x45/0x60
  [<ffffffff81163cfa>] deactivate_super+0x4a/0x70
  [<ffffffff8117d446>] mntput_no_expire+0x86/0xe0
  [<ffffffff8117df7f>] sys_umount+0x6f/0x360
  [<ffffffff8103f01b>] system_call_fastpath+0x16/0x1b
 ---[ end trace cce2a341ba3611a7 ]---

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Andrew, if there's no objection, can you please route this through
your tree?

Oops, reposted with [PATCH] prefix.

Thanks.

 lib/Kconfig.debug    |    8 ++++++++
 lib/percpu_counter.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..651d794 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -317,6 +317,14 @@ config DEBUG_OBJECTS_RCU_HEAD
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).

+config DEBUG_OBJECTS_PERCPU_COUNTER
+	bool "Debug percpu counter objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  percpu counter routines to track the life time of percpu counter
+	  objects and validate the percpu counter operations.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index ec9048e..14a793f 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -8,10 +8,53 @@
 #include <linux/init.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <linux/debugobjects.h>

 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);

+#ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
+
+static struct debug_obj_descr percpu_counter_debug_descr;
+
+static int percpu_counter_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct percpu_counter *fbc = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		percpu_counter_destroy(fbc);
+		debug_object_free(fbc, &percpu_counter_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static struct debug_obj_descr percpu_counter_debug_descr = {
+	.name		= "percpu_counter",
+	.fixup_free	= percpu_counter_fixup_free,
+};
+
+static inline void debug_percpu_counter_activate(struct percpu_counter *fbc)
+{
+	debug_object_init(fbc, &percpu_counter_debug_descr);
+	debug_object_activate(fbc, &percpu_counter_debug_descr);
+}
+
+static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
+{
+	debug_object_deactivate(fbc, &percpu_counter_debug_descr);
+	debug_object_free(fbc, &percpu_counter_debug_descr);
+}
+
+#else	/* CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER */
+static inline void debug_percpu_counter_activate(struct percpu_counter *fbc)
+{ }
+static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
+{ }
+#endif	/* CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER */
+
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
@@ -75,6 +118,9 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
+
+	debug_percpu_counter_activate(fbc);
+
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_add(&fbc->list, &percpu_counters);
@@ -89,6 +135,8 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
 	if (!fbc->counters)
 		return;

+	debug_percpu_counter_deactivate(fbc);
+
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
