Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0KMCeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 21:34:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65446 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0KMCem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 21:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cls2IMyB3dE+2nfGuGlp9ycnCJsaKQpNXoGggB/fDD4qaGJCdDexxpTHTaTKR/VM4e
         LGbNVc6clYI1va5Op28xwIpZGEnbxXL5JBbSIgW4J01BhYbp1SPPyWV0RByj9I0c6CKi
         jbxsQ7thA2JhvtTLi/heZhHeOI4WP2H0B3IjI=
Date: Sat, 13 Nov 2010 10:34:35 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH] APPARMOR: code cleanup on context.h
Message-ID: <20101113023435.GB2713@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use current api to replace old codes.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/apparmor/include/context.h |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index a9cbee4..c9112f3 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -82,23 +82,6 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token);
 int aa_restore_previous_profile(u64 cookie);
 
 /**
- * __aa_task_is_confined - determine if @task has any confinement
- * @task: task to check confinement of  (NOT NULL)
- *
- * If @task != current needs to be called in RCU safe critical section
- */
-static inline bool __aa_task_is_confined(struct task_struct *task)
-{
-	struct aa_task_cxt *cxt = __task_cred(task)->security;
-
-	BUG_ON(!cxt || !cxt->profile);
-	if (unconfined(aa_newest_version(cxt->profile)))
-		return 0;
-
-	return 1;
-}
-
-/**
  * aa_cred_profile - obtain cred's profiles
  * @cred: cred to obtain profiles from  (NOT NULL)
  *
@@ -138,9 +121,8 @@ static inline struct aa_profile *aa_current_profile(void)
 {
 	const struct aa_task_cxt *cxt = current_cred()->security;
 	struct aa_profile *profile;
-	BUG_ON(!cxt || !cxt->profile);
 
-	profile = aa_newest_version(cxt->profile);
+	profile = __aa_current_profile();
 	/*
 	 * Whether or not replacement succeeds, use newest profile so
 	 * there is no need to update it after replacement.
@@ -151,4 +133,18 @@ static inline struct aa_profile *aa_current_profile(void)
 	return profile;
 }
 
+/**
+ * __aa_task_is_confined - determine if @task has any confinement
+ * @task: task to check confinement of  (NOT NULL)
+ *
+ * If @task != current needs to be called in RCU safe critical section
+ */
+static inline bool __aa_task_is_confined(struct task_struct *task)
+{
+	if (unconfined(aa_cred_profile(__task_cred(task))))
+		return 0;
+
+	return 1;
+}
+
 #endif /* __AA_CONTEXT_H */
-- 
1.6.5.3

