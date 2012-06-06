Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2FFECg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:02:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2FFEAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:17 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=JnBuZxMqR0MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=KxDeNtWQo16-VlM9bMwA:9 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=x1bhHwVgPDRym49s:21 a=LJI6GUBgj1IF9NcM:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040015.450519248@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][PATCH 09/12] kprobes: cleanup to separate probe-able check
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0009-kprobes-cleanup-to-separate-probe-able-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
 kernel/kprobes.c |   82 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

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
 
-- 
1.7.10


