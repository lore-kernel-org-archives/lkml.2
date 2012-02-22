Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2BVRlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:41:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab2BVRlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:41:19 -0500
Date: Wed, 22 Feb 2012 18:34:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] epoll: introduce POLLFREE for ep_poll_callback()
Message-ID: <20120222173419.GB7147@redhat.com>
References: <20120222173326.GA7139@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222173326.GA7139@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this patch is intentionally incomplete to simplify the review.
It ignores ep_unregister_pollwait() which plays with the same wqh.
See the next changes.

epoll assumes that the EPOLL_CTL_ADD'ed file controls everything
f_op->poll() needs. In particular it assumes that the wait queue
can't go away until eventpoll_release(). This is not true in case
of signalfd, the task which does EPOLL_CTL_ADD uses its ->sighand
which is not connected to the file.

This patch adds the special event, POLLFREE, currently only for
epoll. It expects that init_poll_funcptr()'ed hook should do the
necessary cleanup. Perhaps it should be defined as EPOLLFREE in
eventpoll.

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

Note: we do not have wake_up_all_poll() but wake_up_poll() should
be fine, poll/epoll doesn't use WQ_FLAG_EXCLUSIVE.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Cc: <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c             |    4 ++++
 fs/signalfd.c              |    5 +++++
 include/asm-generic/poll.h |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aabdfc3..442bedb 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -844,6 +844,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 
 	spin_lock_irqsave(&ep->lock, flags);
 
+	/* the caller holds eppoll_entry->whead->lock */
+	if ((unsigned long)key & POLLFREE)
+		list_del_init(&wait->task_list);
+
 	/*
 	 * If the event mask does not contain any poll(2) event, we consider the
 	 * descriptor to be disabled. This condition is likely the effect of the
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 35d19ae..838ba21 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -34,6 +34,11 @@ void signalfd_cleanup(struct sighand_struct *sighand)
 {
 	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
 
+	if (likely(!waitqueue_active(wqh)))
+		return;
+
+	/* ask wait_queue_t->func() to remove_wait_queue() */
+	wake_up_poll(wqh, POLLHUP | POLLFREE);
 	BUG_ON(waitqueue_active(wqh));
 }
 
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
-- 
1.5.5.1


