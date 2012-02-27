Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2B0TmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:42:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2B0TmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:42:05 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, eparis@redhat.com
Subject: [PATCH] Fix build failures from audit macros when following coding style
Date: Mon, 27 Feb 2012 11:41:58 -0800
Message-Id: <1330371718-11751-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I was cleaning up some code and hit build failures when following
the kernel coding style / checkpatch.pl recommendations.  In both cases
the code had the form of

  if (X)
	Y;
  else
	Z;

where Y or Z were either the macros audit_log_string or COMMON_AUDIT_DATA_INIT

and the failure was
  error: 'else' without a previous 'if'

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 include/linux/audit.h     |    2 +-
 include/linux/lsm_audit.h |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 9ff7a2c..583010f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -676,7 +676,7 @@ extern void		    audit_log_n_hex(struct audit_buffer *ab,
 extern void		    audit_log_n_string(struct audit_buffer *ab,
 					       const char *buf,
 					       size_t n);
-#define audit_log_string(a,b) audit_log_n_string(a, b, strlen(b));
+#define audit_log_string(a,b) audit_log_n_string(a, b, strlen(b))
 extern void		    audit_log_n_untrustedstring(struct audit_buffer *ab,
 							const char *string,
 							size_t n);
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 88e78de..7a0841c 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -143,9 +143,11 @@ int ipv6_skb_to_auditdata(struct sk_buff *skb,
 		struct common_audit_data *ad, u8 *proto);
 
 /* Initialize an LSM audit data structure. */
-#define COMMON_AUDIT_DATA_INIT(_d, _t) \
-	{ memset((_d), 0, sizeof(struct common_audit_data)); \
-	 (_d)->type = LSM_AUDIT_DATA_##_t; }
+#define COMMON_AUDIT_DATA_INIT(_d, _t)				\
+do {								\
+	memset((_d), 0, sizeof(struct common_audit_data));	\
+	(_d)->type = LSM_AUDIT_DATA_##_t;			\
+} while (0)
 
 void common_lsm_audit(struct common_audit_data *a);
 
-- 
1.7.9

