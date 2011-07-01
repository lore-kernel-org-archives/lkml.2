Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1GANhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:37:34 -0400
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3834 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab1GANhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:37:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] poll: add poll_requested_events() function
Date: Fri, 1 Jul 2011 15:37:30 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: "linux-media" <linux-media@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011537.30829.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

And without this information select(nfds, NULL, NULL, &exceptfds, NULL) will
start video streaming when all you wanted was to wait for events that are
signalled with POLLPRI.

The solution is to set the qproc field to NULL in poll_table_struct once
poll() matches the events, not the poll_table_struct pointer itself. That
way drivers can obtain the mask through a new poll_requested_events inline.

The poll_table_struct can still be NULL since some kernel code calls it
internally (netfs_state_poll() in ./drivers/staging/pohmelfs/netfs.h). In
that case poll_requested_events() returns ~0 (i.e. all events).

Since eventpoll always leaves the key field at ~0 instead of using the
requested events mask, that source was changed as well to properly fill in
the key field.

No driver changes were necessary. This patch is against v3.0-rc5.

Comments?

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 fs/eventpoll.c       |   14 ++++++++++----
 fs/select.c          |   32 ++++++++++++++------------------
 include/linux/poll.h |    7 ++++++-
 3 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..022c652 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -650,9 +650,11 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
 	struct epitem *epi, *tmp;
+	poll_table pt = { NULL, ~0UL };
 
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 		    epi->event.events)
 			return POLLIN | POLLRDNORM;
 		else {
@@ -946,6 +948,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
+	epq.pt.key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1027,20 +1030,21 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 {
 	int pwake = 0;
 	unsigned int revents;
+	poll_table pt = { NULL, ~0UL };
 
 	/*
 	 * Set the new event interest mask before calling f_op->poll();
 	 * otherwise we might miss an event that happens between the
 	 * f_op->poll() call and the new event set registering.
 	 */
-	epi->event.events = event->events;
+	epi->event.events = pt.key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1075,6 +1079,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	poll_table pt = { NULL, ~0UL };
 
 	/*
 	 * We can loop without lock because we are passed a task private list.
@@ -1087,7 +1092,8 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 			epi->event.events;
 
 		/*
diff --git a/fs/select.c b/fs/select.c
index d33418f..2da21b8 100644
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
+		wait->qproc = NULL;
 		timed_out = 1;
 	}
 
@@ -459,17 +457,17 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 					if ((mask & POLLOUT_SET) && (out & bit)) {
 						res_out |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 					if ((mask & POLLEX_SET) && (ex & bit)) {
 						res_ex |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 				}
 			}
@@ -481,7 +479,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 				*rexp = res_ex;
 			cond_resched();
 		}
-		wait = NULL;
+		wait->qproc = NULL;
 		if (retval || timed_out || signal_pending(current))
 			break;
 		if (table.error) {
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
+		pt->qproc = NULL;
 		timed_out = 1;
 	}
 
@@ -788,7 +784,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 				 */
 				if (do_pollfd(pfd, pt)) {
 					count++;
-					pt = NULL;
+					pt->qproc = NULL;
 				}
 			}
 		}
@@ -796,7 +792,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 		 * All waiters have already been registered, so don't provide
 		 * a poll_table to them on the next loop iteration.
 		 */
-		pt = NULL;
+		pt->qproc = NULL;
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
diff --git a/include/linux/poll.h b/include/linux/poll.h
index cf40010..fe1e360 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -39,10 +39,15 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && wait_address)
+	if (p && p->qproc && wait_address)
 		p->qproc(filp, wait_address, p);
 }
 
+static inline unsigned long poll_requested_events(const poll_table *p)
+{
+	return p ? p->key : ~0UL;
+}
+
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 {
 	pt->qproc = qproc;
-- 
1.7.1

