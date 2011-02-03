Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1BCPnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab1BCPnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:43:03 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 1/4] kprobe - ktrace instruction slot cache interface
Date: Thu,  3 Feb 2011 16:42:38 +0100
Message-Id: <1296747761-9082-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using kprobe detour buffer allocation, adding interface
to use it from trace framework

wbr,
jirka
---
 include/linux/kprobes.h |    8 ++++++++
 kernel/kprobes.c        |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index dd7c12e..1e984e9 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -436,4 +436,12 @@ static inline int enable_jprobe(struct jprobe *jp)
 	return enable_kprobe(&jp->kp);
 }
 
+#ifdef CONFIG_KTRACE
+
+extern kprobe_opcode_t __kprobes *get_ktrace_insn_slot(void);
+extern void __kprobes free_ktrace_insn_slot(kprobe_opcode_t * slot, int dirty);
+extern void __init ktrace_insn_init(int size);
+
+#endif /* CONFIG_KTRACE */
+
 #endif /* _LINUX_KPROBES_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7798181..5bc31d6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -285,6 +285,39 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
 	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
 	mutex_unlock(&kprobe_insn_mutex);
 }
+
+#ifdef CONFIG_KTRACE
+static DEFINE_MUTEX(ktrace_insn_mutex);
+static struct kprobe_insn_cache ktrace_insn_slots = {
+	.pages = LIST_HEAD_INIT(ktrace_insn_slots.pages),
+	.insn_size = MAX_INSN_SIZE,
+	.nr_garbage = 0,
+};
+
+kprobe_opcode_t __kprobes *get_ktrace_insn_slot(void)
+{
+	kprobe_opcode_t *ret = NULL;
+
+	mutex_lock(&ktrace_insn_mutex);
+	ret = __get_insn_slot(&ktrace_insn_slots);
+	mutex_unlock(&ktrace_insn_mutex);
+
+	return ret;
+}
+
+void __kprobes free_ktrace_insn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	mutex_lock(&ktrace_insn_mutex);
+	__free_insn_slot(&ktrace_insn_slots, slot, dirty);
+	mutex_unlock(&ktrace_insn_mutex);
+}
+
+void __init ktrace_insn_init(int size)
+{
+	ktrace_insn_slots.insn_size = size;
+}
+#endif /* CONFIG_KTRACE */
+
 #ifdef CONFIG_OPTPROBES
 /* For optimized_kprobe buffer */
 static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
-- 
1.7.1

