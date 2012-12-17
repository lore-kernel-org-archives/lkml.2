Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2LQPCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:02:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33387 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2LQPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:02:37 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 09/15] dlm: use new hashtable implementation
Date: Mon, 17 Dec 2012 10:01:29 -0500
Message-Id: <1355756497-15834-9-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch dlm to use the new hashtable implementation. This reduces the amount of
generic unrelated code in the dlm.

This patch depends on d9b482c ("hashtable: introduce a small and naive
hashtable") which was merged in v3.6.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/dlm/lowcomms.c | 53 ++++++++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 35 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index dd87a31..822887c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -55,6 +55,7 @@
 #include <net/sctp/sctp.h>
 #include <net/sctp/user.h>
 #include <net/ipv6.h>
+#include <linux/hashtable.h>
 
 #include "dlm_internal.h"
 #include "lowcomms.h"
@@ -62,7 +63,7 @@
 #include "config.h"
 
 #define NEEDED_RMEM (4*1024*1024)
-#define CONN_HASH_SIZE 32
+#define CONN_HASH_BITS 5
 
 /* Number of messages to send before rescheduling */
 #define MAX_SEND_MSG_COUNT 25
@@ -158,34 +159,27 @@ static int dlm_allow_conn;
 static struct workqueue_struct *recv_workqueue;
 static struct workqueue_struct *send_workqueue;
 
-static struct hlist_head connection_hash[CONN_HASH_SIZE];
+/*
+ * On a sidenote, hash function could be very simple because most clusters
+ * have simple sequential nodeids, so we should be able to go straight to
+ * a connection struct in the array. We don't utilize it at the moment,
+ * but it's something work to keep in mind.
+ */
+static DEFINE_HASHTABLE(connection_hash, CONN_HASH_BITS);
 static DEFINE_MUTEX(connections_lock);
 static struct kmem_cache *con_cache;
 
 static void process_recv_sockets(struct work_struct *work);
 static void process_send_sockets(struct work_struct *work);
 
-
-/* This is deliberately very simple because most clusters have simple
-   sequential nodeids, so we should be able to go straight to a connection
-   struct in the array */
-static inline int nodeid_hash(int nodeid)
-{
-	return nodeid & (CONN_HASH_SIZE-1);
-}
-
 static struct connection *__find_con(int nodeid)
 {
-	int r;
 	struct hlist_node *h;
 	struct connection *con;
 
-	r = nodeid_hash(nodeid);
-
-	hlist_for_each_entry(con, h, &connection_hash[r], list) {
+	hash_for_each_possible(connection_hash, con, h, list, nodeid)
 		if (con->nodeid == nodeid)
 			return con;
-	}
 	return NULL;
 }
 
@@ -196,7 +190,6 @@ static struct connection *__find_con(int nodeid)
 static struct connection *__nodeid2con(int nodeid, gfp_t alloc)
 {
 	struct connection *con = NULL;
-	int r;
 
 	con = __find_con(nodeid);
 	if (con || !alloc)
@@ -206,8 +199,7 @@ static struct connection *__nodeid2con(int nodeid, gfp_t alloc)
 	if (!con)
 		return NULL;
 
-	r = nodeid_hash(nodeid);
-	hlist_add_head(&con->list, &connection_hash[r]);
+	hash_add(connection_hash, &con->list, nodeid);
 
 	con->nodeid = nodeid;
 	mutex_init(&con->sock_mutex);
@@ -235,11 +227,8 @@ static void foreach_conn(void (*conn_func)(struct connection *c))
 	struct hlist_node *h, *n;
 	struct connection *con;
 
-	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_safe(con, h, n, &connection_hash[i], list){
-			conn_func(con);
-		}
-	}
+	hash_for_each_safe(connection_hash, i, h, n, con, list)
+		conn_func(con);
 }
 
 static struct connection *nodeid2con(int nodeid, gfp_t allocation)
@@ -262,12 +251,10 @@ static struct connection *assoc2con(int assoc_id)
 
 	mutex_lock(&connections_lock);
 
-	for (i = 0 ; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry(con, h, &connection_hash[i], list) {
-			if (con->sctp_assoc == assoc_id) {
-				mutex_unlock(&connections_lock);
-				return con;
-			}
+	hash_for_each(connection_hash, i, h, con, list) {
+		if (con->sctp_assoc == assoc_id) {
+			mutex_unlock(&connections_lock);
+			return con;
 		}
 	}
 	mutex_unlock(&connections_lock);
@@ -1637,7 +1624,7 @@ static void free_conn(struct connection *con)
 	close_connection(con, true);
 	if (con->othercon)
 		kmem_cache_free(con_cache, con->othercon);
-	hlist_del(&con->list);
+	hash_del(&con->list);
 	kmem_cache_free(con_cache, con);
 }
 
@@ -1666,10 +1653,6 @@ int dlm_lowcomms_start(void)
 {
 	int error = -EINVAL;
 	struct connection *con;
-	int i;
-
-	for (i = 0; i < CONN_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&connection_hash[i]);
 
 	init_local();
 	if (!dlm_local_count) {
-- 
1.8.0

