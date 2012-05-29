Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2E2Mtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:49:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38842 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2E2Mt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:49:26 -0400
X-AuditID: b753bd60-9a705ba000007aa1-28-4fc4c5d3f54e
X-AuditID: b753bd60-9a705ba000007aa1-28-4fc4c5d3f54e
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip  6/9] kprobes: cleanup to separate probe-able check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 May 2012 21:49:32 +0900
Message-ID: <20120529124932.9191.22789.stgit@localhost.localdomain>
In-Reply-To: <20120529124833.9191.23007.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate probe-able address checking code from
register_kprobe().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 kernel/kprobes.c |   82 ++++++++++++++++++++++++++++++------------------------
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
 

