Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1DZTvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab1DZTvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:51:43 -0400
Date: Tue, 26 Apr 2011 21:50:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] signal: rename signandsets() to sigandnsets()
Message-ID: <20110426195018.GG8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194822.GA8520@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Tejun and Linus pointed out, "nand" is the wrong name for "x & ~y",
it should be "andn". Rename signandsets() as suggested.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    6 +++---
 kernel/signal.c        |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- sigprocmask/include/linux/signal.h~6_rename_nand	2011-04-26 19:53:42.000000000 +0200
+++ sigprocmask/include/linux/signal.h	2011-04-26 19:58:01.000000000 +0200
@@ -123,13 +123,13 @@ _SIG_SET_BINOP(sigorsets, _sig_or)
 #define _sig_and(x,y)	((x) & (y))
 _SIG_SET_BINOP(sigandsets, _sig_and)
 
-#define _sig_nand(x,y)	((x) & ~(y))
-_SIG_SET_BINOP(signandsets, _sig_nand)
+#define _sig_andn(x,y)	((x) & ~(y))
+_SIG_SET_BINOP(sigandnsets, _sig_andn)
 
 #undef _SIG_SET_BINOP
 #undef _sig_or
 #undef _sig_and
-#undef _sig_nand
+#undef _sig_andn
 
 #define _SIG_SET_OP(name, op)						\
 static inline void name(sigset_t *set)					\
--- sigprocmask/kernel/signal.c~6_rename_nand	2011-04-26 19:54:20.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-26 19:59:43.000000000 +0200
@@ -592,7 +592,7 @@ static int rm_from_queue_full(sigset_t *
 	if (sigisemptyset(&m))
 		return 0;
 
-	signandsets(&s->signal, &s->signal, mask);
+	sigandnsets(&s->signal, &s->signal, mask);
 	list_for_each_entry_safe(q, n, &s->list, list) {
 		if (sigismember(mask, q->info.si_signo)) {
 			list_del_init(&q->list);
@@ -2119,7 +2119,7 @@ static void __set_task_blocked(struct ta
 {
 	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
 		sigset_t newblocked;
-		signandsets(&newblocked, newset, &current->blocked);
+		sigandnsets(&newblocked, newset, &current->blocked);
 		retarget_shared_pending(tsk, &newblocked);
 	}
 	tsk->blocked = *newset;
@@ -2157,7 +2157,7 @@ int sigprocmask(int how, sigset_t *set, 
 		sigorsets(&newset, &tsk->blocked, set);
 		break;
 	case SIG_UNBLOCK:
-		signandsets(&newset, &tsk->blocked, set);
+		sigandnsets(&newset, &tsk->blocked, set);
 		break;
 	case SIG_SETMASK:
 		newset = *set;

