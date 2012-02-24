Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2BXTOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab2BXTOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:14:08 -0500
Date: Fri, 24 Feb 2012 20:07:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] epoll: introduce POLLFREE to flush ->signalfd_wqh
	before kfree()
Message-ID: <20120224190711.GB22287@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com> <20120224190651.GA22287@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224190651.GA22287@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is intentionally incomplete to simplify the review.
It ignores ep_unregister_pollwait() which plays with the same wqh.
See the next change.

epoll assumes that the EPOLL_CTL_ADD'ed file controls everything
f_op->poll() needs. In particular it assumes that the wait queue
can't go away until eventpoll_release(). This is not true in case
of signalfd, the task which does EPOLL_CTL_ADD uses its ->sighand
which is not connected to the file.

This patch adds the special event, POLLFREE, currently only for
epoll. It expects that init_poll_funcptr()'ed hook should do the
necessary cleanup. Perhaps it should be defined as EPOLLFREE in
eventpoll.

__cleanup_sighand() is changed to do wake_up_poll(POLLFREE) if
->signalfd_wqh is not empty, we add the new signalfd_cleanup()
helper.

ep_poll_callback(POLLFREE) simply does list_del_init(task_list).
This make this poll entry inconsistent, but we don't care. If you
share epoll fd which contains our sigfd with another process you
should blame yourself. signalfd is "really special". I simply do
not know how we can define the "right" semantics if it used with
epoll.

The main problem is, epoll calls signalfd_poll() once to establish
the connection with the wait queue, after that signalfd_poll(NULL)
returns the different/inconsistent results depending on who does
EPOLL_CTL_MOD/signalfd_read/etc. IOW: apart from sigmask, signalfd
has nothing to do with the file, it works with the current thread.

In short: this patch is the hack which tries to fix the symptoms.
It also assumes that nobody can take tasklist_lock under epoll
locks, this seems to be true.

Note:

	- we do not have wake_up_all_poll() but wake_up_poll()
	  is fine, poll/epoll doesn't use WQ_FLAG_EXCLUSIVE.

	- signalfd_cleanup() uses POLLHUP along with POLLFREE,
	  we need a couple of simple changes in eventpoll.c to
	  make sure it can't be "lost".

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Cc: <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c             |    4 ++++
 fs/signalfd.c              |   11 +++++++++++
 include/asm-generic/poll.h |    2 ++
 include/linux/signalfd.h   |    5 ++++-
 kernel/fork.c              |    5 ++++-
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aabdfc3..34bbfc6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -842,6 +842,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
+	/* the caller holds eppoll_entry->whead->lock */
+	if ((unsigned long)key & POLLFREE)
+		list_del_init(&wait->task_list);
+
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 492465b..79c1eea 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -30,6 +30,17 @@
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
 
+void signalfd_cleanup(struct sighand_struct *sighand)
+{
+	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
+
+	if (likely(!waitqueue_active(wqh)))
+		return;
+
+	/* wait_queue_t->func(POLLFREE) should do remove_wait_queue() */
+	wake_up_poll(wqh, POLLHUP | POLLFREE);
+}
+
 struct signalfd_ctx {
 	sigset_t sigmask;
 };
diff --git a/include/asm-generic/poll.h b/include/asm-generic/poll.h
index 44bce83..9ce7f44 100644
--- a/include/asm-generic/poll.h
+++ b/include/asm-generic/poll.h
@@ -28,6 +28,8 @@
 #define POLLRDHUP       0x2000
 #endif
 
+#define POLLFREE	0x4000	/* currently only for epoll */
+
 struct pollfd {
 	int fd;
 	short events;
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


