Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1BBAoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:7970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1BBAoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418091"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ebiederm@xmission.com, serue@us.ibm.com, davem@davemloft.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [56/139] user_ns: Introduce user_nsmap_uid and user_ns_map_gid.
Message-Id: <20110202004412.6E16E3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Upstream commit 5c1469de7545a35a16ff2b902e217044a7d2f8a5

Define what happens when a we view a uid from one user_namespace
in another user_namepece.

- If the user namespaces are the same no mapping is necessary.

- For most cases of difference use overflowuid and overflowgid,
  the uid and gid currently used for 16bit apis when we have a 32bit uid
  that does fit in 16bits.  Effectively the situation is the same,
  we want to return a uid or gid that is not assigned to any user.

- For the case when we happen to be mapping the uid or gid of the
  creator of the target user namespace use uid 0 and gid as confusing
  that user with root is not a problem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/include/linux/user_namespace.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/user_namespace.h
+++ linux-2.6.35.y/include/linux/user_namespace.h
@@ -36,6 +36,9 @@ static inline void put_user_ns(struct us
 		kref_put(&ns->kref, free_user_ns);
 }
 
+uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t uid);
+gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t gid);
+
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -52,6 +55,17 @@ static inline void put_user_ns(struct us
 {
 }
 
+static inline uid_t user_ns_map_uid(struct user_namespace *to,
+	const struct cred *cred, uid_t uid)
+{
+	return uid;
+}
+static inline gid_t user_ns_map_gid(struct user_namespace *to,
+	const struct cred *cred, gid_t gid)
+{
+	return gid;
+}
+
 #endif
 
 #endif /* _LINUX_USER_H */
Index: linux-2.6.35.y/kernel/user_namespace.c
===================================================================
--- linux-2.6.35.y.orig/kernel/user_namespace.c
+++ linux-2.6.35.y/kernel/user_namespace.c
@@ -9,6 +9,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
+#include <linux/highuid.h>
 #include <linux/cred.h>
 
 /*
@@ -82,3 +83,46 @@ void free_user_ns(struct kref *kref)
 	schedule_work(&ns->destroyer);
 }
 EXPORT_SYMBOL(free_user_ns);
+
+uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t uid)
+{
+	struct user_namespace *tmp;
+
+	if (likely(to == cred->user->user_ns))
+		return uid;
+
+
+	/* Is cred->user the creator of the target user_ns
+	 * or the creator of one of it's parents?
+	 */
+	for ( tmp = to; tmp != &init_user_ns;
+	      tmp = tmp->creator->user_ns ) {
+		if (cred->user == tmp->creator) {
+			return (uid_t)0;
+		}
+	}
+
+	/* No useful relationship so no mapping */
+	return overflowuid;
+}
+
+gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t gid)
+{
+	struct user_namespace *tmp;
+
+	if (likely(to == cred->user->user_ns))
+		return gid;
+
+	/* Is cred->user the creator of the target user_ns
+	 * or the creator of one of it's parents?
+	 */
+	for ( tmp = to; tmp != &init_user_ns;
+	      tmp = tmp->creator->user_ns ) {
+		if (cred->user == tmp->creator) {
+			return (gid_t)0;
+		}
+	}
+
+	/* No useful relationship so no mapping */
+	return overflowgid;
+}
