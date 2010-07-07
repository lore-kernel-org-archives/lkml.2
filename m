Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0GGVvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:51:05 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34454 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab0GGVu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=bEaqyz5ryw9fKTAuW8VRSYtP3usGf/zSv
	yLKm0XlRV92YnjFx1MgN0ockaokTroBqPJnVPwTwlPJoz5SYTL219YjJJYLSVc1O
	eOGrmLrnxbev7c9PPghwfVJkLt/SkVohPk0sEUMeyZH1h8/ey4sx6TTcFbPMD+Nb
	+z+6yHLBQ8=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH v3 09/10] ceph-rbd: sync common header and source files with server version
Date: Wed,  7 Jul 2010 15:11:31 -0700
Message-Id: <9562d2cf653ef49280ae824fbd26a3346d612fcd.1278539315.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/ceph_fs.c      |   50 +++++++++++++++++++++++------------------------
 fs/ceph/ceph_fs.h      |    8 +++---
 fs/ceph/ceph_strings.c |    1 +
 fs/ceph/rados.h        |    8 +++++++
 4 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/ceph_fs.c b/fs/ceph/ceph_fs.c
index 79d76bc..3ac6cc7 100644
--- a/fs/ceph/ceph_fs.c
+++ b/fs/ceph/ceph_fs.c
@@ -29,46 +29,44 @@ int ceph_file_layout_is_valid(const struct ceph_file_layout *layout)
 
 int ceph_flags_to_mode(int flags)
 {
+	int mode;
+
 #ifdef O_DIRECTORY  /* fixme */
 	if ((flags & O_DIRECTORY) == O_DIRECTORY)
 		return CEPH_FILE_MODE_PIN;
 #endif
+	if ((flags & O_APPEND) == O_APPEND)
+		flags |= O_WRONLY;
+
+	if ((flags & O_ACCMODE) == O_RDWR)
+		mode = CEPH_FILE_MODE_RDWR;
+	else if ((flags & O_ACCMODE) == O_WRONLY)
+		mode = CEPH_FILE_MODE_WR;
+	else
+		mode = CEPH_FILE_MODE_RD;
+
 #ifdef O_LAZY
 	if (flags & O_LAZY)
-		return CEPH_FILE_MODE_LAZY;
+		mode |= CEPH_FILE_MODE_LAZY;
 #endif
-	if ((flags & O_APPEND) == O_APPEND)
-		flags |= O_WRONLY;
 
-	flags &= O_ACCMODE;
-	if ((flags & O_RDWR) == O_RDWR)
-		return CEPH_FILE_MODE_RDWR;
-	if ((flags & O_WRONLY) == O_WRONLY)
-		return CEPH_FILE_MODE_WR;
-	return CEPH_FILE_MODE_RD;
+	return mode;
 }
 
 int ceph_caps_for_mode(int mode)
 {
-	switch (mode) {
-	case CEPH_FILE_MODE_PIN:
-		return CEPH_CAP_PIN;
-	case CEPH_FILE_MODE_RD:
-		return CEPH_CAP_PIN | CEPH_CAP_FILE_SHARED |
+	int caps = CEPH_CAP_PIN;
+
+	if (mode & CEPH_FILE_MODE_RD)
+		caps |= CEPH_CAP_FILE_SHARED |
 			CEPH_CAP_FILE_RD | CEPH_CAP_FILE_CACHE;
-	case CEPH_FILE_MODE_RDWR:
-		return CEPH_CAP_PIN | CEPH_CAP_FILE_SHARED |
-			CEPH_CAP_FILE_EXCL |
-			CEPH_CAP_FILE_RD | CEPH_CAP_FILE_CACHE |
-			CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER |
-			CEPH_CAP_AUTH_SHARED | CEPH_CAP_AUTH_EXCL |
-			CEPH_CAP_XATTR_SHARED | CEPH_CAP_XATTR_EXCL;
-	case CEPH_FILE_MODE_WR:
-		return CEPH_CAP_PIN | CEPH_CAP_FILE_SHARED |
-			CEPH_CAP_FILE_EXCL |
+	if (mode & CEPH_FILE_MODE_WR)
+		caps |= CEPH_CAP_FILE_EXCL |
 			CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER |
 			CEPH_CAP_AUTH_SHARED | CEPH_CAP_AUTH_EXCL |
 			CEPH_CAP_XATTR_SHARED | CEPH_CAP_XATTR_EXCL;
-	}
-	return 0;
+	if (mode & CEPH_FILE_MODE_LAZY)
+		caps |= CEPH_CAP_FILE_LAZYIO;
+
+	return caps;
 }
diff --git a/fs/ceph/ceph_fs.h b/fs/ceph/ceph_fs.h
index 2fa992e..d8b7e58 100644
--- a/fs/ceph/ceph_fs.h
+++ b/fs/ceph/ceph_fs.h
@@ -55,16 +55,15 @@
  */
 #define CEPH_FEATURE_UID        1
 #define CEPH_FEATURE_NOSRCADDR  2
-#define CEPH_FEATURE_FLOCK      4
 
 #define CEPH_FEATURE_SUPPORTED_MON  CEPH_FEATURE_UID|CEPH_FEATURE_NOSRCADDR
 #define CEPH_FEATURE_REQUIRED_MON   CEPH_FEATURE_UID
-#define CEPH_FEATURE_SUPPORTED_MDS  CEPH_FEATURE_UID|CEPH_FEATURE_NOSRCADDR|CEPH_FEATURE_FLOCK
+#define CEPH_FEATURE_SUPPORTED_MDS  CEPH_FEATURE_UID|CEPH_FEATURE_NOSRCADDR
 #define CEPH_FEATURE_REQUIRED_MDS   CEPH_FEATURE_UID
 #define CEPH_FEATURE_SUPPORTED_OSD  CEPH_FEATURE_UID|CEPH_FEATURE_NOSRCADDR
 #define CEPH_FEATURE_REQUIRED_OSD   CEPH_FEATURE_UID
 #define CEPH_FEATURE_SUPPORTED_CLIENT CEPH_FEATURE_NOSRCADDR
-#define CEPH_FEATURE_REQUIRED_CLIENT CEPH_FEATURE_NOSRCADDR
+#define CEPH_FEATURE_REQUIRED_CLIENT 0
 
 
 /*
@@ -563,7 +562,8 @@ int ceph_flags_to_mode(int flags);
 			      CEPH_CAP_FILE_EXCL)
 #define CEPH_CAP_ANY_WR   (CEPH_CAP_ANY_EXCL | CEPH_CAP_ANY_FILE_WR)
 #define CEPH_CAP_ANY      (CEPH_CAP_ANY_RD | CEPH_CAP_ANY_EXCL | \
-			   CEPH_CAP_ANY_FILE_WR | CEPH_CAP_PIN)
+			   CEPH_CAP_ANY_FILE_WR | CEPH_CAP_FILE_LAZYIO | \
+			   CEPH_CAP_PIN)
 
 #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
 			CEPH_LOCK_IXATTR)
diff --git a/fs/ceph/ceph_strings.c b/fs/ceph/ceph_strings.c
index 7503aee..0f943a0 100644
--- a/fs/ceph/ceph_strings.c
+++ b/fs/ceph/ceph_strings.c
@@ -28,6 +28,7 @@ const char *ceph_osd_op_name(int op)
 	case CEPH_OSD_OP_TRUNCATE: return "truncate";
 	case CEPH_OSD_OP_ZERO: return "zero";
 	case CEPH_OSD_OP_WRITEFULL: return "writefull";
+	case CEPH_OSD_OP_ROLLBACK: return "rollback";
 
 	case CEPH_OSD_OP_APPEND: return "append";
 	case CEPH_OSD_OP_STARTSYNC: return "startsync";
diff --git a/fs/ceph/rados.h b/fs/ceph/rados.h
index 8fcc023..ccc27fc 100644
--- a/fs/ceph/rados.h
+++ b/fs/ceph/rados.h
@@ -203,6 +203,7 @@ enum {
 	CEPH_OSD_OP_TMAPGET = CEPH_OSD_OP_MODE_RD | CEPH_OSD_OP_TYPE_DATA | 12,
 
 	CEPH_OSD_OP_CREATE  = CEPH_OSD_OP_MODE_WR | CEPH_OSD_OP_TYPE_DATA | 13,
+	CEPH_OSD_OP_ROLLBACK= CEPH_OSD_OP_MODE_WR | CEPH_OSD_OP_TYPE_DATA | 14,
 
 	/** attrs **/
 	/* read */
@@ -272,6 +273,10 @@ static inline int ceph_osd_op_mode_modify(int op)
 	return (op & CEPH_OSD_OP_MODE) == CEPH_OSD_OP_MODE_WR;
 }
 
+/*
+ * note that the following tmap stuff is also defined in the ceph librados.h
+ * any modification here needs to be updated there
+ */
 #define CEPH_OSD_TMAP_HDR 'h'
 #define CEPH_OSD_TMAP_SET 's'
 #define CEPH_OSD_TMAP_RM  'r'
@@ -350,6 +355,9 @@ struct ceph_osd_op {
 		struct {
 			__le64 cookie, count;
 		} __attribute__ ((packed)) pgls;
+	        struct {
+		        __le64 snapid;
+	        } __attribute__ ((packed)) snap;
 	};
 	__le32 payload_len;
 } __attribute__ ((packed));
-- 
1.5.6.5

