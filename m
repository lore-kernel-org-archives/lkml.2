Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1GUKDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:03:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:55930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1GUKD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:03:28 -0400
Date: Thu, 21 Jul 2011 10:02:05 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-bc81d48d13d8839fae6833c95794c403b2133f36@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110627072650.6528.67329.stgit@fedora15>
References: <20110627072650.6528.67329.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Return -ENOENT if probe point doesn't exist
Git-Commit-ID: bc81d48d13d8839fae6833c95794c403b2133f36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:02:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc81d48d13d8839fae6833c95794c403b2133f36
Gitweb:     http://git.kernel.org/tip/bc81d48d13d8839fae6833c95794c403b2133f36
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Jun 2011 16:26:50 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 15 Jul 2011 15:11:47 -0400

kprobes: Return -ENOENT if probe point doesn't exist

Return -ENOENT if probe point doesn't exist, but still returns
-EINVAL if both of kprobe->addr and kprobe->symbol_name are
specified or both are not specified.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20110627072650.6528.67329.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7798181..b30fd54 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1255,19 +1255,29 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 /*
  * If we have a symbol_name argument, look it up and add the offset field
  * to it. This way, we can specify a relative address to a symbol.
+ * This returns encoded errors if it fails to look up symbol or invalid
+ * combination of parameters.
  */
 static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->addr;
+
+	if ((p->symbol_name && p->addr) ||
+	    (!p->symbol_name && !p->addr))
+		goto invalid;
+
 	if (p->symbol_name) {
-		if (addr)
-			return NULL;
 		kprobe_lookup_name(p->symbol_name, addr);
+		if (!addr)
+			return ERR_PTR(-ENOENT);
 	}
 
-	if (!addr)
-		return NULL;
-	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
+	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
+	if (addr)
+		return addr;
+
+invalid:
+	return ERR_PTR(-EINVAL);
 }
 
 /* Check passed kprobe is valid and return kprobe in kprobe_table. */
@@ -1311,8 +1321,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	kprobe_opcode_t *addr;
 
 	addr = kprobe_addr(p);
-	if (!addr)
-		return -EINVAL;
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
 	p->addr = addr;
 
 	ret = check_kprobe_rereg(p);
@@ -1335,6 +1345,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	 */
 	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
+		/* Return -ENOENT if fail. */
+		ret = -ENOENT;
 		/*
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
@@ -1351,6 +1363,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 			module_put(probed_mod);
 			goto fail_with_jump_label;
 		}
+		/* ret will be updated by following code */
 	}
 	preempt_enable();
 	jump_label_unlock();
@@ -1399,7 +1412,7 @@ out:
 fail_with_jump_label:
 	preempt_enable();
 	jump_label_unlock();
-	return -EINVAL;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
@@ -1686,8 +1699,8 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 
 	if (kretprobe_blacklist_size) {
 		addr = kprobe_addr(&rp->kp);
-		if (!addr)
-			return -EINVAL;
+		if (IS_ERR(addr))
+			return PTR_ERR(addr);
 
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
 			if (kretprobe_blacklist[i].addr == addr)
