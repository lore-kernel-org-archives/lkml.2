Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2BKXLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:11:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab2BKXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:11:13 -0500
Date: Sat, 11 Feb 2012 15:10:36 -0800
From: tip-bot for Anton Vorontsov <anton.vorontsov@linaro.org>
Message-ID: <tip-9388dc3047a88bedfd867e9ba3e1980c815ac524@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, arve@android.com, anton.vorontsov@linaro.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, san@google.com,
        ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, ccross@android.com,
        kosaki.motohiro@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton.vorontsov@linaro.org,
        arve@android.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        san@google.com, ebiederm@xmission.com, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, ccross@android.com,
        kosaki.motohiro@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120209164519.GA10266@oksana.dev.rtsoft.ru>
References: <20120209164519.GA10266@oksana.dev.rtsoft.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Turn lock_task_sighand()
  into a static inline
Git-Commit-ID: 9388dc3047a88bedfd867e9ba3e1980c815ac524
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 11 Feb 2012 15:10:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9388dc3047a88bedfd867e9ba3e1980c815ac524
Gitweb:     http://git.kernel.org/tip/9388dc3047a88bedfd867e9ba3e1980c815ac524
Author:     Anton Vorontsov <anton.vorontsov@linaro.org>
AuthorDate: Thu, 9 Feb 2012 20:45:19 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Feb 2012 15:41:33 +0100

sched: Turn lock_task_sighand() into a static inline

It appears that sparse tool understands static inline functions
for context balance checking, so let's turn the macros into an
inline func.

This makes the code a little bit more robust.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Arve <arve@android.com>
Cc: San Mehat <san@google.com>
Cc: Colin Cross <ccross@android.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: kernel-team@android.com
Cc: linaro-kernel@lists.linaro.org
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120209164519.GA10266@oksana.dev.rtsoft.ru
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 92313a3f..5dba2ad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2393,12 +2393,15 @@ static inline void task_unlock(struct task_struct *p)
 extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 							unsigned long *flags);
 
-#define lock_task_sighand(tsk, flags)					\
-({	struct sighand_struct *__ss;					\
-	__cond_lock(&(tsk)->sighand->siglock,				\
-		    (__ss = __lock_task_sighand(tsk, flags)));		\
-	__ss;								\
-})									\
+static inline struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
+						       unsigned long *flags)
+{
+	struct sighand_struct *ret;
+
+	ret = __lock_task_sighand(tsk, flags);
+	(void)__cond_lock(&tsk->sighand->siglock, ret);
+	return ret;
+}
 
 static inline void unlock_task_sighand(struct task_struct *tsk,
 						unsigned long *flags)
