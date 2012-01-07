Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2AGSlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:41:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40356 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab2AGSlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:41:11 -0500
Date: Sat, 7 Jan 2012 10:41:04 -0800
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] audit: treat s_id as an untrusted string
Message-ID: <20120107184104.GF2618@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of s_id should go through the untrusted string path, just to be
extra careful.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
applies on top of http://lkml.org/lkml/2012/1/6/308
---
 security/integrity/ima/ima_audit.c |    8 +++++---
 security/lsm_audit.c               |   23 +++++++++++++----------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
index c5c5a72..2ad942f 100644
--- a/security/integrity/ima/ima_audit.c
+++ b/security/integrity/ima/ima_audit.c
@@ -56,9 +56,11 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 		audit_log_format(ab, " name=");
 		audit_log_untrustedstring(ab, fname);
 	}
-	if (inode)
-		audit_log_format(ab, " dev=%s ino=%lu",
-				 inode->i_sb->s_id, inode->i_ino);
+	if (inode) {
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
+	}
 	audit_log_format(ab, " res=%d", !result ? 0 : 1);
 	audit_log_end(ab);
 }
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 5f3b532..293b8c4 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -235,10 +235,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 		audit_log_d_path(ab, " path=", &a->u.path);
 
 		inode = a->u.path.dentry->d_inode;
-		if (inode)
-			audit_log_format(ab, " dev=%s ino=%lu",
-					inode->i_sb->s_id,
-					inode->i_ino);
+		if (inode) {
+			audit_log_format(ab, " dev=");
+			audit_log_untrustedstring(ab, inode->i_sb->s_id);
+			audit_log_format(ab, " ino=%lu", inode->i_ino);
+		}
 		break;
 	}
 	case LSM_AUDIT_DATA_DENTRY: {
@@ -248,10 +249,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
 
 		inode = a->u.dentry->d_inode;
-		if (inode)
-			audit_log_format(ab, " dev=%s ino=%lu",
-					inode->i_sb->s_id,
-					inode->i_ino);
+		if (inode) {
+			audit_log_format(ab, " dev=");
+			audit_log_untrustedstring(ab, inode->i_sb->s_id);
+			audit_log_format(ab, " ino=%lu", inode->i_ino);
+		}
 		break;
 	}
 	case LSM_AUDIT_DATA_INODE: {
@@ -266,8 +268,9 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 					 dentry->d_name.name);
 			dput(dentry);
 		}
-		audit_log_format(ab, " dev=%s ino=%lu", inode->i_sb->s_id,
-				 inode->i_ino);
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
 		break;
 	}
 	case LSM_AUDIT_DATA_TASK:
-- 
1.7.4.1


-- 
Kees Cook
ChromeOS Security
