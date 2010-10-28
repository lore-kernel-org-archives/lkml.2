Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0J1N54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:57:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab0J1N4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:56:48 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=97Jt8JwOJ3IA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=pKJDfCV8AVH237E5AGQA:9 a=hmfye8OkV17b-mfl81cA:7 a=hgWW_SGuo6VA4i-7bZUiwWv6InYA:4 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028135647.429157214@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 09:55:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 3/8] jump label: Fix error with preempt disable holding mutex
References: <20101028135548.055490014@goodmis.org>
Content-Disposition: inline; filename=0003-jump-label-Fix-error-with-preempt-disable-holding-mu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Kprobes and jump label were having a race between mutexes that
was fixed by reordering the jump label. But this reordering
moved the jump label mutex into a preempt disable location.

This patch does a little fiddling to move the grabbing of
the jump label mutex from inside the preempt disable section
and still keep the order correct between the mutex and the
kprobes lock.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9437e14..9737a76 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1145,17 +1145,13 @@ int __kprobes register_kprobe(struct kprobe *p)
 	if (ret)
 		return ret;
 
-	preempt_disable();
 	jump_label_lock();
+	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
 	    ftrace_text_reserved(p->addr, p->addr) ||
-	    jump_label_text_reserved(p->addr, p->addr)) {
-		preempt_enable();
-		jump_label_unlock();
-		return -EINVAL;
-	}
-	jump_label_unlock();
+	    jump_label_text_reserved(p->addr, p->addr))
+		goto fail_with_jump_label;
 
 	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
 	p->flags &= KPROBE_FLAG_DISABLED;
@@ -1169,10 +1165,9 @@ int __kprobes register_kprobe(struct kprobe *p)
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
 		 */
-		if (unlikely(!try_module_get(probed_mod))) {
-			preempt_enable();
-			return -EINVAL;
-		}
+		if (unlikely(!try_module_get(probed_mod)))
+			goto fail_with_jump_label;
+
 		/*
 		 * If the module freed .init.text, we couldn't insert
 		 * kprobes in there.
@@ -1180,11 +1175,11 @@ int __kprobes register_kprobe(struct kprobe *p)
 		if (within_module_init((unsigned long)p->addr, probed_mod) &&
 		    probed_mod->state != MODULE_STATE_COMING) {
 			module_put(probed_mod);
-			preempt_enable();
-			return -EINVAL;
+			goto fail_with_jump_label;
 		}
 	}
 	preempt_enable();
+	jump_label_unlock();
 
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
@@ -1226,6 +1221,11 @@ out:
 		module_put(probed_mod);
 
 	return ret;
+
+fail_with_jump_label:
+	preempt_enable();
+	jump_label_unlock();
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
-- 
1.7.1


