Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1BERrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:17 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39066 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1BERrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:13 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 10/17] net/9p: Implement syncfs 9P operation
Date: Sat,  5 Feb 2011 23:16:38 +0530
Message-Id: <1296928005-9529-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/net/9p/9p.h     |    2 ++
 include/net/9p/client.h |    1 +
 net/9p/client.c         |   21 +++++++++++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 071fd7a..73dc432 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -139,6 +139,8 @@ do { \
  */
 
 enum p9_msg_t {
+	P9_TSYNCFS = 0,
+	P9_RSYNCFS,
 	P9_TLERROR = 6,
 	P9_RLERROR,
 	P9_TSTATFS = 8,
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 83ba6a4..0a30977 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -230,6 +230,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
 		gid_t gid, struct p9_qid *qid);
 int p9_client_clunk(struct p9_fid *fid);
 int p9_client_fsync(struct p9_fid *fid, int datasync);
+int p9_client_sync_fs(struct p9_fid *fid);
 int p9_client_remove(struct p9_fid *fid);
 int p9_client_read(struct p9_fid *fid, char *data, char __user *udata,
 							u64 offset, u32 count);
diff --git a/net/9p/client.c b/net/9p/client.c
index a848bca..a05673b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1191,6 +1191,27 @@ error:
 }
 EXPORT_SYMBOL(p9_client_fsync);
 
+int p9_client_sync_fs(struct p9_fid *fid)
+{
+	int err = 0;
+	struct p9_req_t *req;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, ">>> TSYNC_FS fid %d\n", fid->fid);
+
+	clnt = fid->clnt;
+	req = p9_client_rpc(clnt, P9_TSYNCFS, "d", fid->fid);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto error;
+	}
+	P9_DPRINTK(P9_DEBUG_9P, "<<< RSYNCFS fid %d\n", fid->fid);
+	p9_free_req(clnt, req);
+error:
+	return err;
+}
+EXPORT_SYMBOL(p9_client_sync_fs);
+
 int p9_client_clunk(struct p9_fid *fid)
 {
 	int err;
-- 
1.7.1

