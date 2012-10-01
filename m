Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2JAXCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35546 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667Ab2JAXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:27 -0400
Message-Id: <20121001225203.927624379@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 149/180] epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit d80e731ecab420ddcb79ee9d0ac427acbc187b4b upstream.

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
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/eventpoll.c             |    4 ++++
 fs/signalfd.c              |   11 +++++++++++
 include/asm-generic/poll.h |    2 ++
 include/linux/signalfd.h   |    5 ++++-
 kernel/fork.c              |    5 ++++-
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f539204..15a7ef3 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -814,6 +814,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
+	/* the caller holds eppoll_entry->whead->lock */
+	if ((unsigned long)key & POLLFREE)
+		list_del_init(&wait->task_list);
+
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
diff --git a/fs/signalfd.c b/fs/signalfd.c
index d98bea8..6339cb4 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -29,6 +29,17 @@
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
index b363b91..ed9b65e 100644
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -60,13 +60,16 @@ static inline void signalfd_notify(struct task_struct *tsk, int sig)
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
index cd075bc..c28f804 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -64,6 +64,7 @@
 #include <linux/magic.h>
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
+#include <linux/signalfd.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -815,8 +816,10 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 
 void __cleanup_sighand(struct sighand_struct *sighand)
 {
-	if (atomic_dec_and_test(&sighand->count))
+	if (atomic_dec_and_test(&sighand->count)) {
+		signalfd_cleanup(sighand);
 		kmem_cache_free(sighand_cachep, sighand);
+	}
 }
 
 
-- 
1.7.2.1.45.g54fbc



