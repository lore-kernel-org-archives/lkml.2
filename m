Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1GPLZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:25:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1GPLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:55 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=0pK2OdDvPzwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=-D3izZLT1A5nhObaUc4A:9 a=hCfWMXY0RJRh-wuMraUA:7 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=dGJ0OcVc7YAA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=UyfQCd-_YNrwqUix:21 a=pxPdys86OnwsKF08:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112254.122078142@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 11/20] kprobes: Return -ENOENT if probe point doesnt exist
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0011-kprobes-Return-ENOENT-if-probe-point-doesn-t-exist.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.7.5.4


