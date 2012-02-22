Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2BVRk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:40:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2BVRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:40:52 -0500
Date: Wed, 22 Feb 2012 18:33:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] signalfd: introduce signalfd_cleanup()
Message-ID: <20120222173356.GA7147@redhat.com>
References: <20120222173326.GA7139@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222173326.GA7139@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation. __cleanup_sighand() obviously must not free sighand
if ->signalfd_wqh is in use. And the new helper which checks this
wait_queue_head_t before kmem_cache_free(). Currently it does
nothing except it helps to catch the bug early.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Cc: <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/signalfd.c            |    7 +++++++
 include/linux/signalfd.h |    5 ++++-
 kernel/fork.c            |    5 ++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 492465b..35d19ae 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -30,6 +30,13 @@
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
 
+void signalfd_cleanup(struct sighand_struct *sighand)
+{
+	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
+
+	BUG_ON(waitqueue_active(wqh));
+}
+
 struct signalfd_ctx {
 	sigset_t sigmask;
 };
diff --git a/include/linux/signalfd.h b/include/linux/signalfd.h
index 3ff4961..247399b 100644
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -61,13 +61,16 @@ static inline void signalfd_notify(struct task_struct *tsk, int sig)
 		wake_up(&tsk->sighand->signalfd_wqh);
 }
 
+extern void signalfd_cleanup(struct sighand_struct *sighand);
+
 #else /* CONFIG_SIGNALFD */
 
 static inline void signalfd_notify(struct task_struct *tsk, int sig) { }
 
+static inline void signalfd_cleanup(struct sighand_struct *sighand) { }
+
 #endif /* CONFIG_SIGNALFD */
 
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SIGNALFD_H */
-
diff --git a/kernel/fork.c b/kernel/fork.c
index b77fd55..e2cd3e2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -66,6 +66,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
 #include <linux/khugepaged.h>
+#include <linux/signalfd.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -935,8 +936,10 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 
 void __cleanup_sighand(struct sighand_struct *sighand)
 {
-	if (atomic_dec_and_test(&sighand->count))
+	if (atomic_dec_and_test(&sighand->count)) {
+		signalfd_cleanup(sighand);
 		kmem_cache_free(sighand_cachep, sighand);
+	}
 }
 
 
-- 
1.5.5.1


