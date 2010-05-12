Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0ELXRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:17:36 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47914 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0ELXQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=fbPy8B4pxTVIj0GdDZwZ3+mW8fxlt1/l1
	YnSV+ceq0oOEC9NK017AG1rIMrnEwqy7F7724WJ1tvnPdtwWSHfaPqp7VDqZcP90
	i5keW7KLXQ+DYAhXu1zx9wXtpnxv3AoGNiVJT0USF2GETmkjgxusq2Cp7NS7eNYD
	vpIG+YJDPE=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 6/8] ceph: sync ceph_fs.h with the server tree version
Date: Wed, 12 May 2010 16:23:38 -0700
Message-Id: <224684fc4a9c3cccdaa7342048555c024aaa22d7.1273705398.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
References: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
References: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is being done so that we can use the new unattended
pool operations.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/ceph_fs.h      |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/ceph_strings.c |   23 ++++++++++++++++++++++-
 fs/ceph/messenger.c    |    1 -
 fs/ceph/msgr.h         |    1 -
 fs/ceph/rados.h        |    4 ++--
 5 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/ceph_fs.h b/fs/ceph/ceph_fs.h
index 8b194c6..24cd676 100644
--- a/fs/ceph/ceph_fs.h
+++ b/fs/ceph/ceph_fs.h
@@ -20,7 +20,7 @@
  */
 #define CEPH_VERSION_MAJOR 0
 #define CEPH_VERSION_MINOR 19
-#define CEPH_VERSION_PATCH 0
+#define CEPH_VERSION_PATCH 1
 
 #define _CEPH_STRINGIFY(x) #x
 #define CEPH_STRINGIFY(x) _CEPH_STRINGIFY(x)
@@ -36,7 +36,7 @@
  * client-facing protocol.
  */
 #define CEPH_OSD_PROTOCOL     8 /* cluster internal */
-#define CEPH_MDS_PROTOCOL     9 /* cluster internal */
+#define CEPH_MDS_PROTOCOL    12 /* cluster internal */
 #define CEPH_MON_PROTOCOL     5 /* cluster internal */
 #define CEPH_OSDC_PROTOCOL   24 /* server/client */
 #define CEPH_MDSC_PROTOCOL   32 /* server/client */
@@ -100,6 +100,8 @@ int ceph_file_layout_is_valid(const struct ceph_file_layout *layout);
 #define CEPH_AUTH_NONE	 	0x1
 #define CEPH_AUTH_CEPHX	 	0x2
 
+#define CEPH_AUTH_UID_DEFAULT ((__u64) -1)
+
 
 /*********************************************
  * message layer
@@ -137,11 +139,27 @@ int ceph_file_layout_is_valid(const struct ceph_file_layout *layout);
 #define CEPH_MSG_CLIENT_SNAP            0x312
 #define CEPH_MSG_CLIENT_CAPRELEASE      0x313
 
+/* pool ops */
+#define CEPH_MSG_POOLOP_REPLY           48
+#define CEPH_MSG_POOLOP                 49
+
+
 /* osd */
 #define CEPH_MSG_OSD_MAP          41
 #define CEPH_MSG_OSD_OP           42
 #define CEPH_MSG_OSD_OPREPLY      43
 
+/* pool operations */
+enum {
+  POOL_OP_CREATE			= 0x01,
+  POOL_OP_DELETE			= 0x02,
+  POOL_OP_AUID_CHANGE			= 0x03,
+  POOL_OP_CREATE_SNAP			= 0x11,
+  POOL_OP_DELETE_SNAP			= 0x12,
+  POOL_OP_CREATE_UNMANAGED_SNAP		= 0x21,
+  POOL_OP_DELETE_UNMANAGED_SNAP		= 0x22,
+};
+
 struct ceph_mon_request_header {
 	__le64 have_version;
 	__le16 session_mon;
@@ -164,6 +182,31 @@ struct ceph_mon_statfs_reply {
 	struct ceph_statfs st;
 } __attribute__ ((packed));
 
+const char *ceph_pool_op_name(int op);
+
+struct ceph_mon_poolop {
+	struct ceph_mon_request_header monhdr;
+	struct ceph_fsid fsid;
+	__le32 pool;
+	__le32 op;
+	__le64 auid;
+	__le64 snapid;
+	__le32 name_len;
+} __attribute__ ((packed));
+
+struct ceph_mon_poolop_reply {
+	struct ceph_mon_request_header monhdr;
+	struct ceph_fsid fsid;
+	__le32 reply_code;
+	__le32 epoch;
+	char has_data;
+	char data[0];
+} __attribute__ ((packed));
+
+struct ceph_mon_unmanaged_snap {
+	__le64 snapid;
+} __attribute__ ((packed));
+
 struct ceph_osd_getmap {
 	struct ceph_mon_request_header monhdr;
 	struct ceph_fsid fsid;
diff --git a/fs/ceph/ceph_strings.c b/fs/ceph/ceph_strings.c
index 8e4be6a..af9180b 100644
--- a/fs/ceph/ceph_strings.c
+++ b/fs/ceph/ceph_strings.c
@@ -10,7 +10,6 @@ const char *ceph_entity_type_name(int type)
 	case CEPH_ENTITY_TYPE_OSD: return "osd";
 	case CEPH_ENTITY_TYPE_MON: return "mon";
 	case CEPH_ENTITY_TYPE_CLIENT: return "client";
-	case CEPH_ENTITY_TYPE_ADMIN: return "admin";
 	case CEPH_ENTITY_TYPE_AUTH: return "auth";
 	default: return "unknown";
 	}
@@ -174,3 +173,25 @@ const char *ceph_snap_op_name(int o)
 	}
 	return "???";
 }
+
+const char *ceph_pool_op_name(int op)
+{
+  switch (op) {
+  case POOL_OP_CREATE:
+    return "create pool";
+  case POOL_OP_DELETE:
+    return "delete pool";
+  case POOL_OP_AUID_CHANGE:
+    return "change auid";
+  case POOL_OP_CREATE_SNAP:
+    return "create snap";
+  case POOL_OP_DELETE_SNAP:
+    return "delete snap";
+  case POOL_OP_CREATE_UNMANAGED_SNAP:
+    return "create unmanaged snap";
+  case POOL_OP_DELETE_UNMANAGED_SNAP:
+    return "delete unmanaged snap";
+  default:
+    return "unknown";
+  }
+}
diff --git a/fs/ceph/messenger.c b/fs/ceph/messenger.c
index e4871d9..3360ed1 100644
--- a/fs/ceph/messenger.c
+++ b/fs/ceph/messenger.c
@@ -47,7 +47,6 @@ const char *ceph_name_type_str(int t)
 	case CEPH_ENTITY_TYPE_MDS: return "mds";
 	case CEPH_ENTITY_TYPE_OSD: return "osd";
 	case CEPH_ENTITY_TYPE_CLIENT: return "client";
-	case CEPH_ENTITY_TYPE_ADMIN: return "admin";
 	default: return "???";
 	}
 }
diff --git a/fs/ceph/msgr.h b/fs/ceph/msgr.h
index 6baa8e4..892a029 100644
--- a/fs/ceph/msgr.h
+++ b/fs/ceph/msgr.h
@@ -50,7 +50,6 @@ struct ceph_entity_name {
 #define CEPH_ENTITY_TYPE_MDS    0x02
 #define CEPH_ENTITY_TYPE_OSD    0x04
 #define CEPH_ENTITY_TYPE_CLIENT 0x08
-#define CEPH_ENTITY_TYPE_ADMIN  0x10
 #define CEPH_ENTITY_TYPE_AUTH   0x20
 
 #define CEPH_ENTITY_TYPE_ANY    0xFF
diff --git a/fs/ceph/rados.h b/fs/ceph/rados.h
index a1fc1d0..75c3d27 100644
--- a/fs/ceph/rados.h
+++ b/fs/ceph/rados.h
@@ -100,8 +100,8 @@ struct ceph_pg_pool {
 	__le64 snap_seq;          /* seq for per-pool snapshot */
 	__le32 snap_epoch;        /* epoch of last snap */
 	__le32 num_snaps;
-	__le32 num_removed_snap_intervals;
-	__le64 uid;
+	__le32 num_removed_snap_intervals; /* if non-empty, NO per-pool snaps */
+	__le64 auid;               /* who owns the pg */
 } __attribute__ ((packed));
 
 /*
-- 
1.5.6.5

