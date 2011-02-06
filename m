Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1BFDWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 22:22:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37914 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1BFDWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 22:22:30 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 5 Feb 2011 19:22:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Nelson Elhage <nelhage@ksplice.com>
cc: linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        security@kernel.org
Subject: Re: [PATCH] epoll: Prevent deadlock through unsafe ->f_op->poll()
 calls.
In-Reply-To: <1296954535-29495-1-git-send-email-nelhage@ksplice.com>
Message-ID: <alpine.DEB.2.00.1102051916170.22851@localhost6.localdomain6>
References: <1296954535-29495-1-git-send-email-nelhage@ksplice.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Feb 2011, Nelson Elhage wrote:

> In several places, an epoll fd can call another file's ->f_op->poll() method
> with ep->mtx held. This is in general unsafe, because that other file could
> itself be an epoll fd that contains the original epoll fd.
> 
> The code defends against this possibility in its own ->poll() method using
> ep_call_nested, but there are several other unsafe calls to ->poll elsewhere
> that can be made to deadlock. For example, the following simple program causes
> the call in ep_insert recursively call the original fd's ->poll, leading to
> deadlock:
> 
> ------------------------------8<------------------------------
>  #include <unistd.h>
>  #include <sys/epoll.h>
> 
>  int main(void) {
>      int e1, e2, p[2];
>      struct epoll_event evt = {
>          .events = EPOLLIN
>      };
> 
>      e1 = epoll_create(1);
>      e2 = epoll_create(2);
>      pipe(p);
> 
>      epoll_ctl(e2, EPOLL_CTL_ADD, e1, &evt);
>      epoll_ctl(e1, EPOLL_CTL_ADD, p[0], &evt);
>      write(p[1], p, sizeof p);
>      epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
> 
>      return 0;
>  }
> ------------------------------8<------------------------------

Yuck, true :|
The call nested function is heavy, and the patch below does it only if the 
file descriptor is an epoll one.
But, that does not fix the problem WRT the send-events proc, even if we 
call the new ep_poll_file().
At this point, we better remove the heavy checks from the fast path, and 
perform a check at insetion time, if the inserted fd is an epoll one.
That way, the price for the check is paid once, and only if the inserted 
fd is an epoll one.



- Davide


---
 fs/eventpoll.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 107 insertions(+), 20 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2011-02-05 17:39:48.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2011-02-05 19:04:46.000000000 -0800
@@ -214,6 +214,25 @@
 };
 
 /*
+ * Structure used to channel f_op->poll() data through the ep_call_nested()
+ * when calling f_op->poll() on an epoll descriptor.
+ */
+struct ep_poll_file_data {
+	struct file *file;
+	struct poll_table_struct *pt;
+};
+
+static int ep_eventpoll_release(struct inode *inode, struct file *file);
+static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait);
+
+/* File callbacks that implement the eventpoll file behaviour */
+static const struct file_operations eventpoll_fops = {
+	.release	= ep_eventpoll_release,
+	.poll		= ep_eventpoll_poll,
+	.llseek		= noop_llseek,
+};
+
+/*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
 /* Maximum number of epoll watched descriptors, per user */
@@ -257,6 +276,11 @@
 };
 #endif /* CONFIG_SYSCTL */
 
+/* Fast test to see if the file is an evenpoll file */
+static inline int is_file_epoll(struct file *f)
+{
+	return f->f_op == &eventpoll_fops;
+}
 
 /* Setup the structure that is used as key for the RB tree */
 static inline void ep_set_ffd(struct epoll_filefd *ffd,
@@ -414,6 +438,82 @@
 	put_cpu();
 }
 
+/**
+ * ep_poll_file_proc - Callback passed to @ep_call_nested() when calling
+ *                     @f_op->poll() on an epoll file descriptor.
+ *
+ * @priv: Pointer to an @ep_poll_file_data structure.
+ * @cookie: Cookie passed to the @ep_call_nested() API.
+ * @call_nests: Current value of nested calls, during the @ep_call_nested()
+ *              processing.
+ *
+ * Returns: Returns the value of the wrapped @f_op->poll() call.
+ */
+static int ep_poll_file_proc(void *priv, void *cookie, int call_nests)
+{
+	struct ep_poll_file_data *epfd = priv;
+
+	return epfd->file->f_op->poll(epfd->file, epfd->pt);
+}
+
+/**
+ * ep_nested_poll_file - Uses the @ep_call_nested() API to call a file
+ *                       pointer @f_op->poll() function.
+ *
+ * @ep: Pointer to the epoll private data structure.
+ * @file: Pointer to the file of which we need to call the @f_op->poll()
+ *        function.
+ * @pt: Pointer to the @poll_table_struct structure to be passed to
+ *      the @f_op->poll() call.
+ *
+ * Returns: Returns the ready flags returned by the file's @f_op->poll() API.
+ */
+static unsigned int ep_nested_poll_file(struct eventpoll *ep, struct file *file,
+					struct poll_table_struct *pt)
+{
+	int events;
+	struct ep_poll_file_data epfd;
+
+	/*
+	 * This is merely a call to file->f_op->poll() under
+	 * ep_call_nested. This shares a nested_calls struct with
+	 * ep_eventpoll_poll in order to prevent other sites that call
+	 * ->f_op->poll from recursing back into this file and deadlocking.
+	 */
+	epfd.file = file;
+	epfd.pt = pt;
+	events = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
+				ep_poll_file_proc, &epfd, ep, current);
+
+	return events != -1 ? events : 0;
+}
+
+/**
+ * ep_poll_file - Calls the file's @f_op->poll() callback, possibly
+ *                using the @ep_call_nested() API if the target file is
+ *                an epoll file.
+ *
+ * @ep: Pointer to the epoll private data structure.
+ * @file: Pointer to the file of which we need to call the @f_op->poll()
+ *        function.
+ * @pt: Pointer to the @poll_table_struct structure to be passed to
+ *      the @f_op->poll() call.
+ *
+ * Returns: Returns the ready flags returned by the file's @f_op->poll() API.
+ */
+static inline unsigned int ep_poll_file(struct eventpoll *ep, struct file *file,
+					struct poll_table_struct *pt)
+{
+	/*
+	 * Optimize for the common path. Most of the target files are not epoll
+	 * file descriptors.
+	 */
+	if (unlikely(is_file_epoll(file)))
+		return ep_nested_poll_file(ep, file, pt);
+
+	return file->f_op->poll(file, pt);
+}
+
 /*
  * This function unregisters poll callbacks from the associated file
  * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
@@ -652,7 +752,7 @@
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 {
-	int pollflags;
+	int events;
 	struct eventpoll *ep = file->private_data;
 
 	/* Insert inside our poll wait queue */
@@ -664,23 +764,10 @@
 	 * supervision, since the call to f_op->poll() done on listed files
 	 * could re-enter here.
 	 */
-	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, ep, ep, current);
-
-	return pollflags != -1 ? pollflags : 0;
-}
+	events = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
+				ep_poll_readyevents_proc, ep, ep, current);
 
-/* File callbacks that implement the eventpoll file behaviour */
-static const struct file_operations eventpoll_fops = {
-	.release	= ep_eventpoll_release,
-	.poll		= ep_eventpoll_poll,
-	.llseek		= noop_llseek,
-};
-
-/* Fast test to see if the file is an evenpoll file */
-static inline int is_file_epoll(struct file *f)
-{
-	return f->f_op == &eventpoll_fops;
+	return events != -1 ? events : 0;
 }
 
 /*
@@ -931,7 +1018,7 @@
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
-	revents = tfile->f_op->poll(tfile, &epq.pt);
+	revents = ep_poll_file(ep, tfile, &epq.pt);
 
 	/*
 	 * We have to check if something went wrong during the poll wait queue
@@ -1017,7 +1104,7 @@
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = ep_poll_file(ep, epi->ffd.file, NULL);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1064,7 +1151,7 @@
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		revents = ep_poll_file(ep, epi->ffd.file, NULL) &
 			epi->event.events;
 
 		/*
