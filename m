Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0JPCZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:25:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0JPCZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:25:51 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=gJRBYOTBAWgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=er-gvXSu9-3I63Nr6b8A:9 a=9Z_JELsnB_QAdRZUUSkA:7 a=B8HRAP43mzGLHAOxeJ2Fbh2lrukA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/9] jump label: Fix deadlock b/w jump_label_mutex vs.
 text_mutex
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1287176134.1998.113.camel@laptop>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.691801067@goodmis.org>  <1287176134.1998.113.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 22:25:49 -0400
Message-ID: <1287195949.16971.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 22:55 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> > +void jump_label_lock(void)
> > +{
> > +       mutex_lock(&jump_label_mutex);
> > +}
> > +
> 
> > +++ b/kernel/kprobes.c
> > @@ -1145,13 +1145,16 @@ int __kprobes register_kprobe(struct kprobe *p)
> >                 return ret;
> >  
> >         preempt_disable();
> > +       jump_label_lock();
> 
> How exactly does that work?
> 

This patch should fix it (compiled tested only). If all agree, I'll add
it to the series.

-- Steve

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d45d72e..0dbd328 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1144,17 +1144,13 @@ int __kprobes register_kprobe(struct kprobe *p)
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
@@ -1168,10 +1164,9 @@ int __kprobes register_kprobe(struct kprobe *p)
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
@@ -1179,11 +1174,11 @@ int __kprobes register_kprobe(struct kprobe *p)
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
@@ -1225,6 +1220,11 @@ out:
 		module_put(probed_mod);
 
 	return ret;
+
+fail_with_jump_label:
+	preempt_enable();
+	jump_label_unlock();
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 


