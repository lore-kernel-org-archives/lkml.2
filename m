Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab2HUPLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:11:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2HUPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:11:18 -0400
Date: Tue, 21 Aug 2012 08:10:51 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-f7fa6ef0ded995aad68650a877198f70e44b7621@git.kernel.org>
Cc: fche@redhat.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, ananth@in.ibm.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fche@redhat.com, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20120605102820.27845.90133.stgit@localhost.localdomain>
References: <20120605102820.27845.90133.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: cleanup to separate probe-able check
Git-Commit-ID: f7fa6ef0ded995aad68650a877198f70e44b7621
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:10:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7fa6ef0ded995aad68650a877198f70e44b7621
Gitweb:     http://git.kernel.org/tip/f7fa6ef0ded995aad68650a877198f70e44b7621
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 5 Jun 2012 19:28:20 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:56 -0400

kprobes: cleanup to separate probe-able check

Separate probe-able address checking code from
register_kprobe().

Link: http://lkml.kernel.org/r/20120605102820.27845.90133.stgit@localhost.localdomain

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |   82 +++++++++++++++++++++++++++++------------------------
 1 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7a8a122..6137fe3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1313,67 +1313,80 @@ static inline int check_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
-int __kprobes register_kprobe(struct kprobe *p)
+static __kprobes int check_kprobe_address_safe(struct kprobe *p,
+					       struct module **probed_mod)
 {
 	int ret = 0;
-	struct kprobe *old_p;
-	struct module *probed_mod;
-	kprobe_opcode_t *addr;
-
-	addr = kprobe_addr(p);
-	if (IS_ERR(addr))
-		return PTR_ERR(addr);
-	p->addr = addr;
-
-	ret = check_kprobe_rereg(p);
-	if (ret)
-		return ret;
 
 	jump_label_lock();
 	preempt_disable();
+
+	/* Ensure it is not in reserved area nor out of text */
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
 	    ftrace_text_reserved(p->addr, p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
-		goto cannot_probe;
+		goto out;
 	}
 
-	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
-	p->flags &= KPROBE_FLAG_DISABLED;
-
-	/*
-	 * Check if are we probing a module.
-	 */
-	probed_mod = __module_text_address((unsigned long) p->addr);
-	if (probed_mod) {
-		/* Return -ENOENT if fail. */
-		ret = -ENOENT;
+	/* Check if are we probing a module */
+	*probed_mod = __module_text_address((unsigned long) p->addr);
+	if (*probed_mod) {
 		/*
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
 		 */
-		if (unlikely(!try_module_get(probed_mod)))
-			goto cannot_probe;
+		if (unlikely(!try_module_get(*probed_mod))) {
+			ret = -ENOENT;
+			goto out;
+		}
 
 		/*
 		 * If the module freed .init.text, we couldn't insert
 		 * kprobes in there.
 		 */
-		if (within_module_init((unsigned long)p->addr, probed_mod) &&
-		    probed_mod->state != MODULE_STATE_COMING) {
-			module_put(probed_mod);
-			goto cannot_probe;
+		if (within_module_init((unsigned long)p->addr, *probed_mod) &&
+		    (*probed_mod)->state != MODULE_STATE_COMING) {
+			module_put(*probed_mod);
+			*probed_mod = NULL;
+			ret = -ENOENT;
 		}
-		/* ret will be updated by following code */
 	}
+out:
 	preempt_enable();
 	jump_label_unlock();
 
+	return ret;
+}
+
+int __kprobes register_kprobe(struct kprobe *p)
+{
+	int ret;
+	struct kprobe *old_p;
+	struct module *probed_mod;
+	kprobe_opcode_t *addr;
+
+	/* Adjust probe address from symbol */
+	addr = kprobe_addr(p);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+	p->addr = addr;
+
+	ret = check_kprobe_rereg(p);
+	if (ret)
+		return ret;
+
+	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
+	p->flags &= KPROBE_FLAG_DISABLED;
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
-	mutex_lock(&kprobe_mutex);
 
+	ret = check_kprobe_address_safe(p, &probed_mod);
+	if (ret)
+		return ret;
+
+	mutex_lock(&kprobe_mutex);
 	jump_label_lock(); /* needed to call jump_label_text_reserved() */
 
 	get_online_cpus();	/* For avoiding text_mutex deadlock. */
@@ -1410,11 +1423,6 @@ out:
 		module_put(probed_mod);
 
 	return ret;
-
-cannot_probe:
-	preempt_enable();
-	jump_label_unlock();
-	return ret;
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
