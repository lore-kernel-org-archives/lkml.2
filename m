Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab2AIVzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:55:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab2AIVzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:55:00 -0500
Date: Mon, 9 Jan 2012 16:54:54 -0500
From: Jason Baron <jbaron@redhat.com>
Message-Id: <201201092154.q09LssQC031126@int-mx01.intmail.prod.int.phx2.redhat.com>
To: akpm@linux-foundation.org
Cc: davidel@xmailserver.org, nelhage@ksplice.com, linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: Cleanup limit paths
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanups based on Andrew Morton's review:
https://lkml.org/lkml/2011/9/2/356

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/eventpoll.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index fd8b8b9..ca47608 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -202,7 +202,7 @@ struct eventpoll {
 
 	/* used to optimize loop detection check */
 	int visited;
-	struct list_head visitedllink;
+	struct list_head visited_list_link;
 };
 
 /* Wait structure used by the poll hooks */
@@ -262,10 +262,13 @@ static struct kmem_cache *epi_cache __read_mostly;
 static struct kmem_cache *pwq_cache __read_mostly;
 
 /* Visited nodes during ep_loop_check(), so we can unset them when we finish */
-LIST_HEAD(visited_list);
+static LIST_HEAD(visited_list);
 
-/* Files with newly added links, which need a limit on emanating paths */
-LIST_HEAD(tfile_check_list);
+/*
+ * List of files with newly added links, where we may need to limit the number
+ * of emanating paths. Protected by the epmutex.
+ */
+static LIST_HEAD(tfile_check_list);
 
 #ifdef CONFIG_SYSCTL
 
@@ -944,16 +947,19 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
 
 
 #define PATH_ARR_SIZE 5
-/* These are the number paths of length 1 to 5, that we are allowing to emanate
+/*
+ * These are the number paths of length 1 to 5, that we are allowing to emanate
  * from a single file of interest. For example, we allow 1000 paths of length
  * 1, to emanate from each file of interest. This essentially represents the
  * potential wakeup paths, which need to be limited in order to avoid massive
  * uncontrolled wakeup storms. The common use case should be a single ep which
  * is connected to n file sources. In this case each file source has 1 path
- * of length 1. Thus, the numbers below should be more than sufficient.
+ * of length 1. Thus, the numbers below should be more than sufficient. These
+ * path limits are enforced during an EPOLL_CTL_ADD operation, since a modify
+ * and delete can't add additional paths. Protected by the epmutex.
  */
-int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
-int path_count[PATH_ARR_SIZE];
+static const int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
+static int path_count[PATH_ARR_SIZE];
 
 static int path_count_inc(int nests)
 {
@@ -1408,7 +1414,7 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 
 	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	ep->visited = 1;
-	list_add(&ep->visitedllink, &visited_list);
+	list_add(&ep->visited_list_link, &visited_list);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1421,12 +1427,13 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 			if (error != 0)
 				break;
 		} else {
-			/* if we've reached a file that is not associated with
-			 * an ep, then then we need to check if the newly added
+			/*
+			 * If we've reached a file that is not associated with
+			 * an ep, then we need to check if the newly added
 			 * links are going to add too many wakeup paths. We do
 			 * this by adding it to the tfile_check_list, if it's
 			 * not already there, and calling reverse_path_check()
-			 * during ep_insert()
+			 * during ep_insert().
 			 */
 			if (list_empty(&epi->ffd.file->f_tfile_llink))
 				list_add(&epi->ffd.file->f_tfile_llink,
@@ -1457,9 +1464,10 @@ static int ep_loop_check(struct eventpoll *ep, struct file *file)
 	ret = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 			      ep_loop_check_proc, file, ep, current);
 	/* clear visited list */
-	list_for_each_entry_safe(ep_cur, ep_next, &visited_list, visitedllink) {
+	list_for_each_entry_safe(ep_cur, ep_next, &visited_list,
+							visited_list_link) {
 		ep_cur->visited = 0;
-		list_del(&ep_cur->visitedllink);
+		list_del(&ep_cur->visited_list_link);
 	}
 	return ret;
 }
-- 
1.7.7.5

