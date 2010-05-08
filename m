Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0EHSVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 14:21:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:45520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0EHSVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 14:21:53 -0400
Date: Sat, 8 May 2010 18:20:42 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tony.luck@intel.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
References: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Move enable/disable_kprobe() out from debugfs code
Message-ID: <tip-c0614829c16ab9d31f1b7d40516decfbf3d32102@git.kernel.org>
Git-Commit-ID: c0614829c16ab9d31f1b7d40516decfbf3d32102
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 18:20:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0614829c16ab9d31f1b7d40516decfbf3d32102
Gitweb:     http://git.kernel.org/tip/c0614829c16ab9d31f1b7d40516decfbf3d32102
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Apr 2010 18:33:12 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 May 2010 18:08:30 +0200

kprobes: Move enable/disable_kprobe() out from debugfs code

Move enable/disable_kprobe() API out from debugfs related code,
because these interfaces are not related to debugfs interface.

This fixes a compiler warning.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by:  Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |  132 +++++++++++++++++++++++++++---------------------------
 1 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 0ed46f3..282035f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1588,6 +1588,72 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 	arch_remove_kprobe(p);
 }
 
+/* Disable one kprobe */
+int __kprobes disable_kprobe(struct kprobe *kp)
+{
+	int ret = 0;
+	struct kprobe *p;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Check whether specified probe is valid. */
+	p = __get_valid_kprobe(kp);
+	if (unlikely(p == NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* If the probe is already disabled (or gone), just return */
+	if (kprobe_disabled(kp))
+		goto out;
+
+	kp->flags |= KPROBE_FLAG_DISABLED;
+	if (p != kp)
+		/* When kp != p, p is always enabled. */
+		try_to_disable_aggr_kprobe(p);
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p))
+		disarm_kprobe(p);
+out:
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(disable_kprobe);
+
+/* Enable one kprobe */
+int __kprobes enable_kprobe(struct kprobe *kp)
+{
+	int ret = 0;
+	struct kprobe *p;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Check whether specified probe is valid. */
+	p = __get_valid_kprobe(kp);
+	if (unlikely(p == NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (kprobe_gone(kp)) {
+		/* This kprobe has gone, we couldn't enable it. */
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (p != kp)
+		kp->flags &= ~KPROBE_FLAG_DISABLED;
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
+		p->flags &= ~KPROBE_FLAG_DISABLED;
+		arm_kprobe(p);
+	}
+out:
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(enable_kprobe);
+
 void __kprobes dump_kprobe(struct kprobe *kp)
 {
 	printk(KERN_WARNING "Dumping kprobe:\n");
@@ -1805,72 +1871,6 @@ static const struct file_operations debugfs_kprobes_operations = {
 	.release        = seq_release,
 };
 
-/* Disable one kprobe */
-int __kprobes disable_kprobe(struct kprobe *kp)
-{
-	int ret = 0;
-	struct kprobe *p;
-
-	mutex_lock(&kprobe_mutex);
-
-	/* Check whether specified probe is valid. */
-	p = __get_valid_kprobe(kp);
-	if (unlikely(p == NULL)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* If the probe is already disabled (or gone), just return */
-	if (kprobe_disabled(kp))
-		goto out;
-
-	kp->flags |= KPROBE_FLAG_DISABLED;
-	if (p != kp)
-		/* When kp != p, p is always enabled. */
-		try_to_disable_aggr_kprobe(p);
-
-	if (!kprobes_all_disarmed && kprobe_disabled(p))
-		disarm_kprobe(p);
-out:
-	mutex_unlock(&kprobe_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(disable_kprobe);
-
-/* Enable one kprobe */
-int __kprobes enable_kprobe(struct kprobe *kp)
-{
-	int ret = 0;
-	struct kprobe *p;
-
-	mutex_lock(&kprobe_mutex);
-
-	/* Check whether specified probe is valid. */
-	p = __get_valid_kprobe(kp);
-	if (unlikely(p == NULL)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (kprobe_gone(kp)) {
-		/* This kprobe has gone, we couldn't enable it. */
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (p != kp)
-		kp->flags &= ~KPROBE_FLAG_DISABLED;
-
-	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
-		p->flags &= ~KPROBE_FLAG_DISABLED;
-		arm_kprobe(p);
-	}
-out:
-	mutex_unlock(&kprobe_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(enable_kprobe);
-
 static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
