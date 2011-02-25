Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab1BYTv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:51:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab1BYTv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:51:56 -0500
Date: Fri, 25 Feb 2011 14:50:53 -0500
From: Jason Baron <jbaron@redhat.com>
Message-Id: <201102251950.p1PJorw9023013@int-mx12.intmail.prod.int.phx2.redhat.com>
To: davidel@xmailserver.org, nelhage@ksplice.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, security@kernel.org
Subject: [PATCH] optimize epoll loop detection
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The recent epoll patch to prevent introducing cycles among the epoll
data structures is implemented using a brute force search. Although,
the epoll code limits path lengths to 4 deep, it is still possible
exploit the algorithm and cause a local dos. Using the program below,
I was able to busy the kernel to run for 15 minutes in the loop
detection algorithm. (That can't be good for real-time performance :))

The test program is diabolical, but it represents a local 'dos'
attack. The program can be run by any user, and uses almost all 1024
of its open file descriptor limit. If that limit were raised by a
sysadmin, the program could be run indefinitely. (The run time is
basically: (max # of open file descriptors / 4) ^ 4. So in the
case of 1024 max file descriptor, we generate ~256 ^ 4 path checks,
which causes a quite a lot of function calls.

We can improve the loop detection code, to not be brute force, and
make sure that it doesn't re-visit nodes that it has already visited.
Using this optimized version the 15 minute test ran in .3 seconds.
The algorithm relies on the fact that there are no cycles in the
graph to begin with, and thus the newly added link must be involved
in the cycle (if there is one introduced).

I've re-tested the original test program, and the diabolical test
case below, but otherwise haven't done further epoll testing.

test program:

#include <unistd.h>
#include <sys/epoll.h>
#include <sys/time.h>
#include <stdio.h>

#define SIZE 250

int main(void) {

	int links[SIZE];
	int links2[SIZE];
	int links3[SIZE];
	int links4[SIZE];
	int i, j;
	int ret;
	int ep1, ep2;
	struct timeval start, end;

	struct epoll_event evt = {
		.events = EPOLLIN
	};

	ep1 = epoll_create(1);
	for (i = 0; i < SIZE; i++) {
		links[i] = epoll_create(1);
		ret = epoll_ctl(ep1, EPOLL_CTL_ADD, links[i], &evt);
		if (ret)
			perror("error 1");
	}
	for (i = 0; i < SIZE; i++) {
		links2[i] = epoll_create(1);
		for (j = 0; j < SIZE; j++) {
			epoll_ctl(links[j], EPOLL_CTL_ADD, links2[i], &evt);
			if (ret)
				perror("error 2");
		}
	}
	for (i = 0; i < SIZE; i++) {
		links3[i] = epoll_create(1);
		for (j = 0; j < SIZE; j++) {
			epoll_ctl(links2[j], EPOLL_CTL_ADD, links3[i], &evt);
			if (ret)
				perror("error 3");
		}
	}
	for (i = 0; i < SIZE; i++) {
		links4[i] = epoll_create(1);
		for (j = 0; j < SIZE; j++) {
			epoll_ctl(links3[j], EPOLL_CTL_ADD, links4[i], &evt);
			if (ret)
				perror("error 4");
		}
	}

 	ep2 = epoll_create(1);
	gettimeofday(&start, NULL);
	ret = epoll_ctl(ep2, EPOLL_CTL_ADD, ep1, &evt);
	/* creates a loop */
	//ret = epoll_ctl(links4[499], EPOLL_CTL_ADD, ep1, &evt);
	if (ret)
		perror("error 5");
	gettimeofday(&end, NULL);

	printf("%ld\n", ((end.tv_sec * 1000000 + end.tv_usec)
		- (start.tv_sec * 1000000 + start.tv_usec)));

	return 0;

}

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/eventpoll.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4a09af9..ea74bc9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -95,6 +95,9 @@ struct epoll_filefd {
 	int fd;
 };
 
+/* used to keep track of visited nodes, so they can be cleared */
+LIST_HEAD(visited_list);
+
 /*
  * Structure used to track possible nested calls, for too deep recursions
  * and loop cycles.
@@ -188,6 +191,10 @@ struct eventpoll {
 
 	/* The user that created the eventpoll descriptor */
 	struct user_struct *user;
+
+	/* used to optimize loop detection check */
+	int visited;
+	struct list_head visitedllink;
 };
 
 /* Wait structure used by the poll hooks */
@@ -1228,16 +1235,22 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 	int error = 0;
 	struct file *file = priv;
 	struct eventpoll *ep = file->private_data;
+	struct eventpoll *ep_tovisit;
 	struct rb_node *rbp;
 	struct epitem *epi;
 
 	mutex_lock(&ep->mtx);
+	ep->visited = 1;
+	list_add(&ep->visitedllink, &visited_list);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
+			ep_tovisit = epi->ffd.file->private_data;
+			if (ep_tovisit->visited)
+				continue;
 			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 					       ep_loop_check_proc, epi->ffd.file,
-					       epi->ffd.file->private_data, current);
+					       ep_tovisit, current);
 			if (error != 0)
 				break;
 		}
@@ -1260,8 +1273,17 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
  */
 static int ep_loop_check(struct eventpoll *ep, struct file *file)
 {
-	return ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
+	int ret;
+	struct eventpoll *ep_cur, *ep_next;
+
+	ret = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 			      ep_loop_check_proc, file, ep, current);
+	/* clear visited list */
+	list_for_each_entry_safe(ep_cur, ep_next, &visited_list, visitedllink) {
+		ep_cur->visited = 0;
+		list_del(&ep_cur->visitedllink);
+	}
+	return ret;
 }
 
 /*
-- 
1.7.1

