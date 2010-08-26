Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0HZDhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 23:37:06 -0400
Received: from ozlabs.org ([203.10.76.45]:44349 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0HZDhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 23:37:04 -0400
Date: Thu, 26 Aug 2010 13:34:56 +1000
From: Anton Blanchard <anton@samba.org>
To: Eric Paris <eparis@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        sgrubb@redhat.com
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
Message-ID: <20100826033456.GB17882@kryten>
References: <29151.1282270393@neuling.org>
 <1282586177.2681.43.camel@localhost.localdomain>
 <20887.1282615880@neuling.org>
 <1282621410.26616.406.camel@localhost.localdomain>
 <15180.1282705886@neuling.org>
 <1282737584.13142.153.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282737584.13142.153.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric,

Here's another approach Mikey and I were discussing. We allocate the
tsk->audit_context as before, but we avoid setting the TIF_SYSCALL_AUDIT until
the first rule gets added.

We could look at clearing the flag when the rules go back to zero, but this
simple patch covers the most common case I think.

Anton
---

Index: powerpc.git/kernel/auditfilter.c
===================================================================
--- powerpc.git.orig/kernel/auditfilter.c	2010-08-26 08:04:19.998892577 +1000
+++ powerpc.git/kernel/auditfilter.c	2010-08-26 08:04:30.290374256 +1000
@@ -859,6 +859,21 @@ out:
 static u64 prio_low = ~0ULL/2;
 static u64 prio_high = ~0ULL/2 - 1;
 
+#ifdef CONFIG_AUDITSYSCALL
+static void enable_syscall_auditing(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+	do_each_thread(g, t) {
+		if (t->audit_context)
+			set_tsk_thread_flag(t, TIF_SYSCALL_AUDIT);
+	} while_each_thread(g, t);
+	read_unlock_irqrestore(&tasklist_lock, flags);
+}
+#endif
+
 /* Add rule to given filterlist if not a duplicate. */
 static inline int audit_add_rule(struct audit_entry *entry)
 {
@@ -922,9 +937,14 @@ static inline int audit_add_rule(struct
 		list_add_tail_rcu(&entry->list, list);
 	}
 #ifdef CONFIG_AUDITSYSCALL
-	if (!dont_count)
+	if (!dont_count) {
 		audit_n_rules++;
 
+		/* Did we add our first rule? */
+		if (audit_n_rules == 1)
+			enable_syscall_auditing();
+	}
+
 	if (!audit_match_signal(entry))
 		audit_signals++;
 #endif
Index: powerpc.git/kernel/auditsc.c
===================================================================
--- powerpc.git.orig/kernel/auditsc.c	2010-08-26 08:04:19.998892577 +1000
+++ powerpc.git/kernel/auditsc.c	2010-08-26 08:04:30.390388654 +1000
@@ -886,7 +886,10 @@ int audit_alloc(struct task_struct *tsk)
 	context->filterkey = key;
 
 	tsk->audit_context  = context;
-	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
+
+	/* We postpone setting the thread flag until we add the first rule */
+	if (audit_n_rules != 0)
+		set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 	return 0;
 }
 
