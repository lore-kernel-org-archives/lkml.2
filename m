Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2BBK23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:28:29 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3239 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2BBK21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:28:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv7 PATCH 2/4] poll: add poll_requested_events() and poll_does_not_wait() functions
Date: Thu,  2 Feb 2012 11:26:55 +0100
Message-Id: <54c55b11bba94b57a76ca7553f735bcb822aa43d.1328176079.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
References: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
References: <a92b9a00741769f3c38a54d3a6799509f9089452.1328176079.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

In some cases the poll() implementation in a driver has to do different
things depending on the events the caller wants to poll for. An example is
when a driver needs to start a DMA engine if the caller polls for POLLIN,
but doesn't want to do that if POLLIN is not requested but instead only
POLLOUT or POLLPRI is requested. This is something that can happen in the
video4linux subsystem.

Unfortunately, the current epoll/poll/select implementation doesn't provide
that information reliably. The poll_table_struct does have it: it has a key
field with the event mask. But once a poll() call matches one or more bits
of that mask any following poll() calls are passed a NULL poll_table_struct
pointer.

The solution is to set the qproc field to NULL in poll_table_struct once
poll() matches the events, not the poll_table_struct pointer itself. That
way drivers can obtain the mask through a new poll_requested_events inline.

The poll_table_struct can still be NULL since some kernel code calls it
internally (netfs_state_poll() in ./drivers/staging/pohmelfs/netfs.h). In
that case poll_requested_events() returns ~0 (i.e. all events).

Very rarely drivers might want to know whether poll_wait will actually wait.
If another earlier file descriptor in the set already matched the events the
caller wanted to wait for, then the kernel will return from the select() call
without waiting.

A new helper function poll_does_not_wait() is added that drivers can use to
detect this situation.

Drivers should no longer access any of the poll_table internals, but use the
poll_requested_events() and poll_does_not_wait() access functions instead.

Since the behavior of the qproc field changes with this patch (since this
function pointer can now be NULL when that wasn't possible in the past) I
have renamed that field from qproc to pq_proc. Any out-of-tree driver that
uses it will now fail to compile.

Some notes regarding the correctness of this patch: the driver's poll()
function is called with a 'struct poll_table_struct *wait' argument. This
pointer may or may not be NULL, drivers can never rely on it being one or
the other as that depends on whether or not an earlier file descriptor in
the select()'s fdset matched the requested events.

There are only three things a driver can do with the wait argument:

1) obtain the key field:

	events = wait ? wait->key : ~0;

   This will still work although it should be replaced with the new
   poll_requested_events() function (which does exactly the same).
   This will now even work better, since wait is no longer set to NULL
   unnecessarily.

2) use the qproc callback. This could be deadly since qproc can now be
   NULL. Renaming qproc should prevent this from happening. There are no
   kernel drivers that actually access this callback directly, BTW.

3) test whether wait == NULL to determine whether poll would return without
   waiting. This is no longer sufficient as the correct test is now
   wait == NULL || wait->pq_proc == NULL.

   However, the worst that can happen here is a slight performance hit in
   the case where wait != NULL and wait->pq_proc == NULL. In that case the
   driver will assume that poll_wait() will actually add the fd to the set
   of waiting file descriptors. Of course, poll_wait() will not do that
   since it tests for wait->pq_proc. This will not break anything, though.

   There is only one place in the whole kernel where this happens
   (sock_poll_wait() in include/net/sock.h) and that code will be replaced
   by a call to poll_does_not_wait() in the next patch.

   Note that even if wait->pq_proc != NULL drivers cannot rely on poll_wait()
   actually waiting. The next file descriptor from the set might match the
   event mask and thus any possible waits will never happen.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/select.c          |   38 +++++++++++++++++---------------------
 include/linux/poll.h |   35 ++++++++++++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index d33418f..4bcc3a4 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -386,13 +386,11 @@ get_max:
 static inline void wait_key_set(poll_table *wait, unsigned long in,
 				unsigned long out, unsigned long bit)
 {
-	if (wait) {
-		wait->key = POLLEX_SET;
-		if (in & bit)
-			wait->key |= POLLIN_SET;
-		if (out & bit)
-			wait->key |= POLLOUT_SET;
-	}
+	wait->key = POLLEX_SET;
+	if (in & bit)
+		wait->key |= POLLIN_SET;
+	if (out & bit)
+		wait->key |= POLLOUT_SET;
 }
 
 int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
@@ -414,7 +412,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 	poll_initwait(&table);
 	wait = &table.pt;
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
-		wait = NULL;
+		wait->pq_proc = NULL;
 		timed_out = 1;
 	}
 
@@ -459,17 +457,17 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
 						retval++;
-						wait = NULL;
+						wait->pq_proc = NULL;
 					}
 					if ((mask & POLLOUT_SET) && (out & bit)) {
 						res_out |= bit;
 						retval++;
-						wait = NULL;
+						wait->pq_proc = NULL;
 					}
 					if ((mask & POLLEX_SET) && (ex & bit)) {
 						res_ex |= bit;
 						retval++;
-						wait = NULL;
+						wait->pq_proc = NULL;
 					}
 				}
 			}
@@ -481,7 +479,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 				*rexp = res_ex;
 			cond_resched();
 		}
-		wait = NULL;
+		wait->pq_proc = NULL;
 		if (retval || timed_out || signal_pending(current))
 			break;
 		if (table.error) {
@@ -720,7 +718,7 @@ struct poll_list {
  * interested in events matching the pollfd->events mask, and the result
  * matching that mask is both recorded in pollfd->revents and returned. The
  * pwait poll_table will be used by the fd-provided poll handler for waiting,
- * if non-NULL.
+ * if pwait->pq_proc is non-NULL.
  */
 static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 {
@@ -738,9 +736,7 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 		if (file != NULL) {
 			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll) {
-				if (pwait)
-					pwait->key = pollfd->events |
-							POLLERR | POLLHUP;
+				pwait->key = pollfd->events | POLLERR | POLLHUP;
 				mask = file->f_op->poll(file, pwait);
 			}
 			/* Mask out unneeded events. */
@@ -763,7 +759,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 
 	/* Optimise the no-wait case */
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
-		pt = NULL;
+		pt->pq_proc = NULL;
 		timed_out = 1;
 	}
 
@@ -781,22 +777,22 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 			for (; pfd != pfd_end; pfd++) {
 				/*
 				 * Fish for events. If we found one, record it
-				 * and kill the poll_table, so we don't
+				 * and kill poll_table->pq_proc, so we don't
 				 * needlessly register any other waiters after
 				 * this. They'll get immediately deregistered
 				 * when we break out and return.
 				 */
 				if (do_pollfd(pfd, pt)) {
 					count++;
-					pt = NULL;
+					pt->pq_proc = NULL;
 				}
 			}
 		}
 		/*
 		 * All waiters have already been registered, so don't provide
-		 * a poll_table to them on the next loop iteration.
+		 * a poll_table->pq_proc to them on the next loop iteration.
 		 */
-		pt = NULL;
+		pt->pq_proc = NULL;
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
diff --git a/include/linux/poll.h b/include/linux/poll.h
index cf40010..08b7ea5 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -32,20 +32,45 @@ struct poll_table_struct;
  */
 typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *, struct poll_table_struct *);
 
+/*
+ * Do not touch the structure directly, use the access functions
+ * poll_does_not_wait() and poll_requested_events() instead.
+ */
 typedef struct poll_table_struct {
-	poll_queue_proc qproc;
+	poll_queue_proc pq_proc;
 	unsigned long key;
 } poll_table;
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && wait_address)
-		p->qproc(filp, wait_address, p);
+	if (p && p->pq_proc && wait_address)
+		p->pq_proc(filp, wait_address, p);
+}
+
+/*
+ * Return true if it is guaranteed that poll will not wait. This is the case
+ * if the poll() of another file descriptor in the set got an event, so there
+ * is no need for waiting.
+ */
+static inline bool poll_does_not_wait(const poll_table *p)
+{
+	return p == NULL || p->pq_proc == NULL;
+}
+
+/*
+ * Return the set of events that the application wants to poll for.
+ * This is useful for drivers that need to know whether a DMA transfer has
+ * to be started implicitly on poll(). You typically only want to do that
+ * if the application is actually polling for POLLIN and/or POLLOUT.
+ */
+static inline unsigned long poll_requested_events(const poll_table *p)
+{
+	return p ? p->key : ~0UL;
 }
 
-static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
+static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc pq_proc)
 {
-	pt->qproc = qproc;
+	pt->pq_proc = pq_proc;
 	pt->key   = ~0UL; /* all events enabled */
 }
 
-- 
1.7.8.3

