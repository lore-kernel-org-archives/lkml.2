Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0DFWSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab0DFWSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:18:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] kprobes: Move enable/disable_kprobe() out from debugfs
	code
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 06 Apr 2010 18:24:52 -0400
Message-ID: <20100406222452.13879.48199.stgit@localhost6.localdomain6>
In-Reply-To: <4BB5FED3.4020809@redhat.com>
References: <4BB5FED3.4020809@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move enable/disable_kprobe() API out from debugfs related code,
because these interfaces are not related to debugfs interface.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
