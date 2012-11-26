Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2KZRtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:49:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47668 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab2KZRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 143/270] libceph: delay debugfs initialization until we learn global_id
Date: Mon, 26 Nov 2012 14:57:13 -0200
Message-Id: <1353949160-26803-144-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit d1c338a509cea5378df59629ad47382810c38623 upstream.

The debugfs directory includes the cluster fsid and our unique global_id.
We need to delay the initialization of the debug entry until we have
learned both the fsid and our global_id from the monitor or else the
second client can't create its debugfs entry and will fail (and multiple
client instances aren't properly reflected in debugfs).

Reported by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/debugfs.c      |    1 +
 net/ceph/ceph_common.c |    1 -
 net/ceph/debugfs.c     |    4 ++++
 net/ceph/mon_client.c  |   51 +++++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index fb962ef..6d59006 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -201,6 +201,7 @@ int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 	int err = -ENOMEM;
 
 	dout("ceph_fs_debugfs_init\n");
+	BUG_ON(!fsc->client->debugfs_dir);
 	fsc->debugfs_congestion_kb =
 		debugfs_create_file("writeback_congestion_kb",
 				    0600,
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 3b45e01..408a81a 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -83,7 +83,6 @@ int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid)
 			return -1;
 		}
 	} else {
-		pr_info("client%lld fsid %pU\n", ceph_client_id(client), fsid);
 		memcpy(&client->fsid, fsid, sizeof(*fsid));
 	}
 	return 0;
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 54b531a..38b5dc1 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -189,6 +189,9 @@ int ceph_debugfs_client_init(struct ceph_client *client)
 	snprintf(name, sizeof(name), "%pU.client%lld", &client->fsid,
 		 client->monc.auth->global_id);
 
+	dout("ceph_debugfs_client_init %p %s\n", client, name);
+
+	BUG_ON(client->debugfs_dir);
 	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
 	if (!client->debugfs_dir)
 		goto out;
@@ -234,6 +237,7 @@ out:
 
 void ceph_debugfs_client_cleanup(struct ceph_client *client)
 {
+	dout("ceph_debugfs_client_cleanup %p\n", client);
 	debugfs_remove(client->debugfs_osdmap);
 	debugfs_remove(client->debugfs_monmap);
 	debugfs_remove(client->osdc.debugfs_file);
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 105d533..900ea0f 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -311,6 +311,17 @@ int ceph_monc_open_session(struct ceph_mon_client *monc)
 EXPORT_SYMBOL(ceph_monc_open_session);
 
 /*
+ * We require the fsid and global_id in order to initialize our
+ * debugfs dir.
+ */
+static bool have_debugfs_info(struct ceph_mon_client *monc)
+{
+	dout("have_debugfs_info fsid %d globalid %lld\n",
+	     (int)monc->client->have_fsid, monc->auth->global_id);
+	return monc->client->have_fsid && monc->auth->global_id > 0;
+}
+
+/*
  * The monitor responds with mount ack indicate mount success.  The
  * included client ticket allows the client to talk to MDSs and OSDs.
  */
@@ -320,9 +331,12 @@ static void ceph_monc_handle_map(struct ceph_mon_client *monc,
 	struct ceph_client *client = monc->client;
 	struct ceph_monmap *monmap = NULL, *old = monc->monmap;
 	void *p, *end;
+	int had_debugfs_info, init_debugfs = 0;
 
 	mutex_lock(&monc->mutex);
 
+	had_debugfs_info = have_debugfs_info(monc);
+
 	dout("handle_monmap\n");
 	p = msg->front.iov_base;
 	end = p + msg->front.iov_len;
@@ -344,12 +358,22 @@ static void ceph_monc_handle_map(struct ceph_mon_client *monc,
 
 	if (!client->have_fsid) {
 		client->have_fsid = true;
+		if (!had_debugfs_info && have_debugfs_info(monc)) {
+			pr_info("client%lld fsid %pU\n",
+				ceph_client_id(monc->client),
+				&monc->client->fsid);
+			init_debugfs = 1;
+		}
 		mutex_unlock(&monc->mutex);
-		/*
-		 * do debugfs initialization without mutex to avoid
-		 * creating a locking dependency
-		 */
-		ceph_debugfs_client_init(client);
+
+		if (init_debugfs) {
+			/*
+			 * do debugfs initialization without mutex to avoid
+			 * creating a locking dependency
+			 */
+			ceph_debugfs_client_init(monc->client);
+		}
+
 		goto out_unlocked;
 	}
 out:
@@ -865,8 +889,10 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 {
 	int ret;
 	int was_auth = 0;
+	int had_debugfs_info, init_debugfs = 0;
 
 	mutex_lock(&monc->mutex);
+	had_debugfs_info = have_debugfs_info(monc);
 	if (monc->auth->ops)
 		was_auth = monc->auth->ops->is_authenticated(monc->auth);
 	monc->pending_auth = 0;
@@ -889,7 +915,22 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 		__send_subscribe(monc);
 		__resend_generic_request(monc);
 	}
+
+	if (!had_debugfs_info && have_debugfs_info(monc)) {
+		pr_info("client%lld fsid %pU\n",
+			ceph_client_id(monc->client),
+			&monc->client->fsid);
+		init_debugfs = 1;
+	}
 	mutex_unlock(&monc->mutex);
+
+	if (init_debugfs) {
+		/*
+		 * do debugfs initialization without mutex to avoid
+		 * creating a locking dependency
+		 */
+		ceph_debugfs_client_init(monc->client);
+	}
 }
 
 static int __validate_auth(struct ceph_mon_client *monc)
-- 
1.7.9.5

