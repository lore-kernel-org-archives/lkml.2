Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2EUVSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759117Ab2EUVSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:44 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] dlm: prevent connections during shutdown
Date: Mon, 21 May 2012 16:18:33 -0500
Message-Id: <1337635120-19969-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During lowcomms shutdown, a new connection could possibly
be created, and attempt to use a workqueue that's been
destroyed.  Similarly, during startup, a new connection
could attempt to use a workqueue that's not been set up
yet.  Add a global variable to indicate when new connections
are allowed.

Based on patch by: Christine Caulfield <ccaulfie@redhat.com>

Reported-by: dann frazier <dann.frazier@canonical.com>
Reviewed-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 133ef6d..5c1b0e3 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -142,6 +142,7 @@ struct writequeue_entry {
 
 static struct sockaddr_storage *dlm_local_addr[DLM_MAX_ADDR_COUNT];
 static int dlm_local_count;
+static int dlm_allow_conn;
 
 /* Work queues */
 static struct workqueue_struct *recv_workqueue;
@@ -710,6 +711,13 @@ static int tcp_accept_from_sock(struct connection *con)
 	struct connection *newcon;
 	struct connection *addcon;
 
+	mutex_lock(&connections_lock);
+	if (!dlm_allow_conn) {
+		mutex_unlock(&connections_lock);
+		return -1;
+	}
+	mutex_unlock(&connections_lock);
+
 	memset(&peeraddr, 0, sizeof(peeraddr));
 	result = sock_create_kern(dlm_local_addr[0]->ss_family, SOCK_STREAM,
 				  IPPROTO_TCP, &newsock);
@@ -1503,6 +1511,7 @@ void dlm_lowcomms_stop(void)
 	   socket activity.
 	*/
 	mutex_lock(&connections_lock);
+	dlm_allow_conn = 0;
 	foreach_conn(stop_conn);
 	mutex_unlock(&connections_lock);
 
@@ -1530,7 +1539,7 @@ int dlm_lowcomms_start(void)
 	if (!dlm_local_count) {
 		error = -ENOTCONN;
 		log_print("no local IP address has been set");
-		goto out;
+		goto fail;
 	}
 
 	error = -ENOMEM;
@@ -1538,7 +1547,13 @@ int dlm_lowcomms_start(void)
 				      __alignof__(struct connection), 0,
 				      NULL);
 	if (!con_cache)
-		goto out;
+		goto fail;
+
+	error = work_start();
+	if (error)
+		goto fail_destroy;
+
+	dlm_allow_conn = 1;
 
 	/* Start listening */
 	if (dlm_config.ci_protocol == 0)
@@ -1548,20 +1563,17 @@ int dlm_lowcomms_start(void)
 	if (error)
 		goto fail_unlisten;
 
-	error = work_start();
-	if (error)
-		goto fail_unlisten;
-
 	return 0;
 
 fail_unlisten:
+	dlm_allow_conn = 0;
 	con = nodeid2con(0,0);
 	if (con) {
 		close_connection(con, false);
 		kmem_cache_free(con_cache, con);
 	}
+fail_destroy:
 	kmem_cache_destroy(con_cache);
-
-out:
+fail:
 	return error;
 }
-- 
1.7.10.1.362.g242cab3

