Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1F1MDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:03:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54207 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab1F1L5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:57:21 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-9f-4e09c19f6730
X-AuditID: b753bd60-a0aaaba0000019f4-9f-4e09c19f6730
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 03/13] kprobes: Return -ENOENT if probe point doesn't
 exist
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 27 Jun 2011 16:26:50 +0900
Message-ID: <20110627072650.6528.67329.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOENT if probe point doesn't exist, but still returns
-EINVAL if both of kprobe->addr and kprobe->symbol_name are
specified or both are not specified.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
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

