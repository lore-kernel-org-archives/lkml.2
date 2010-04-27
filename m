Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0D1MTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0D1MTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:19:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/2] [RESEND] kprobes: Move enable/disable_kprobe() out
	from debugfs code
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 27 Apr 2010 18:33:12 -0400
Message-ID: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
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
Acked-by:  Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
