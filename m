Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1BFBJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:09:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55557 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1BFBJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:09:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F5U9ErH//u7uMLyU57XPbHRrGzW86Z68lGkGgZ49vdi3Y+U+VO7Rr5lIwY0I+QG+1m
         IxWRp98Rfsw4WmhbPYOsWIE5m8SOvAO4IyH62SiWgWOSw/OWZfnd8AM9YeDxgjIKb2Kj
         dobnUuHCYF7aO3LNu1GMVSQyz7StxrpHWtRDs=
From: Nelson Elhage <nelhage@ksplice.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH] epoll: Prevent deadlock through unsafe ->f_op->poll() calls.
Date: Sat,  5 Feb 2011 20:08:55 -0500
Message-Id: <1296954535-29495-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.2.43.g68ef4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In several places, an epoll fd can call another file's ->f_op->poll() method
with ep->mtx held. This is in general unsafe, because that other file could
itself be an epoll fd that contains the original epoll fd.

The code defends against this possibility in its own ->poll() method using
ep_call_nested, but there are several other unsafe calls to ->poll elsewhere
that can be made to deadlock. For example, the following simple program causes
the call in ep_insert recursively call the original fd's ->poll, leading to
deadlock:

------------------------------8<------------------------------
 #include <unistd.h>
 #include <sys/epoll.h>

 int main(void) {
     int e1, e2, p[2];
     struct epoll_event evt = {
         .events = EPOLLIN
     };

     e1 = epoll_create(1);
     e2 = epoll_create(2);
     pipe(p);

     epoll_ctl(e2, EPOLL_CTL_ADD, e1, &evt);
     epoll_ctl(e1, EPOLL_CTL_ADD, p[0], &evt);
     write(p[1], p, sizeof p);
     epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);

     return 0;
 }
------------------------------8<------------------------------

This patch fixes the problem by wrapping all such calls in ep_call_nested, using
the same nested_calls instance as the ->poll method. It's possible there are
more elegant solutions, but this works and is minimally invasive.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
 fs/eventpoll.c |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8cf07242..4ca27cf5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -213,6 +213,12 @@ struct ep_send_events_data {
 	struct epoll_event __user *events;
 };
 
+/* Used by the ep_poll_file() function as callback private data */
+struct ep_poll_file_data {
+	struct file *file;
+	struct poll_table_struct *pt;
+};
+
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
@@ -668,6 +674,31 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 	return pollflags != -1 ? pollflags : 0;
 }
 
+int ep_poll_file_proc(void *priv, void *cookie, int call_nests)
+{
+	struct ep_poll_file_data *data = priv;
+	return data->file->f_op->poll(data->file, data->pt);
+}
+
+static unsigned int ep_poll_file(struct eventpoll *ep, struct file *file,
+				 struct poll_table_struct *pt)
+{
+	int pollflags;
+	struct ep_poll_file_data data;
+	/*
+	 * This is merely a call to file->f_op->poll() under
+	 * ep_call_nested. This shares a nested_calls struct with
+	 * ep_eventpoll_poll in order to prevent other sites that call
+	 * ->f_op->poll from recursing back into this file and deadlocking.
+	 */
+	data.file = file;
+	data.pt   = pt;
+	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
+				   ep_poll_file_proc, &data, ep, current);
+
+	return pollflags != -1 ? pollflags : 0;
+}
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 	.release	= ep_eventpoll_release,
@@ -928,7 +959,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
-	revents = tfile->f_op->poll(tfile, &epq.pt);
+	revents = ep_poll_file(ep, tfile, &epq.pt);
 
 	/*
 	 * We have to check if something went wrong during the poll wait queue
@@ -1014,7 +1045,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = ep_poll_file(ep, epi->ffd.file, NULL);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1061,7 +1092,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		revents = ep_poll_file(ep, epi->ffd.file, NULL) &
 			epi->event.events;
 
 		/*
-- 
1.7.2.43.g68ef4

