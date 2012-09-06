Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2IFPIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:08:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab2IFPIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:08:41 -0400
Date: Thu, 6 Sep 2012 11:08:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: eparis@redhat.com
Subject: Check all returns from audit_log_start
Message-ID: <20120906150838.GA23345@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, eparis@redhat.com
References: <20120906134628.GA8962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906134628.GA8962@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following on from the previous patch that fixed an oops, these
are all the other similar code patterns in the tree with the same
checks added.  I never saw these causing problems, but checking
this everywhere seems to make more sense than every subsequent
routine that gets passed 'ab' having to check it.

Later we could remove all those same checks from audit_log_format
and friends. For now, this just prevents similar bugs being introduced
as the one in my previous patch.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 36abf2a..2df27a7 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -665,7 +665,7 @@ extern __printf(4, 5)
 void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 	       const char *fmt, ...);
 
-extern struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask, int type);
+extern struct audit_buffer __must_check *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask, int type);
 extern __printf(2, 3)
 void audit_log_format(struct audit_buffer *ab, const char *fmt, ...);
 extern void		    audit_log_end(struct audit_buffer *ab);
diff --git a/kernel/audit.c b/kernel/audit.c
index ea3b7b6..832c549 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -271,6 +271,9 @@ static int audit_log_config_change(char *function_name, int new, int old,
 	int rc = 0;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	if (!ab)
+		return -EINVAL;
+
 	audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
 			 old, loginuid, sessionid);
 	if (sid) {
@@ -632,6 +635,9 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 	}
 
 	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
+	if (!*ab)
+		return -EINVAL;
+
 	audit_log_format(*ab, "pid=%d uid=%u auid=%u ses=%u",
 			 pid, uid, auid, ses);
 	if (sid) {
@@ -1145,7 +1151,7 @@ static inline void audit_get_stamp(struct audit_context *ctx,
  * will be written at syscall exit.  If there is no associated task, then
  * task context (ctx) should be NULL.
  */
-struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
+struct audit_buffer __must_check *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 				     int type)
 {
 	struct audit_buffer	*ab	= NULL;
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index ed206fd..2580edf 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -462,13 +462,15 @@ static void kill_rules(struct audit_tree *tree)
 		if (rule->tree) {
 			/* not a half-baked one */
 			ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
-			audit_log_format(ab, "op=");
-			audit_log_string(ab, "remove rule");
-			audit_log_format(ab, " dir=");
-			audit_log_untrustedstring(ab, rule->tree->pathname);
-			audit_log_key(ab, rule->filterkey);
-			audit_log_format(ab, " list=%d res=1", rule->listnr);
-			audit_log_end(ab);
+			if (ab) {
+				audit_log_format(ab, "op=");
+				audit_log_string(ab, "remove rule");
+				audit_log_format(ab, " dir=");
+				audit_log_untrustedstring(ab, rule->tree->pathname);
+				audit_log_key(ab, rule->filterkey);
+				audit_log_format(ab, " list=%d res=1", rule->listnr);
+				audit_log_end(ab);
+			}
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4b96415..1f39dcf 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2707,6 +2707,8 @@ void audit_core_dumps(long signr)
 		return;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	if (!ab)
+		return;
 	audit_log_abend(ab, "memory violation", signr);
 	audit_log_end(ab);
 }
@@ -2716,6 +2718,8 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 	struct audit_buffer *ab;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	if (!ab)
+		return;
 	audit_log_abend(ab, "seccomp", signr);
 	audit_log_format(ab, " syscall=%ld", syscall);
 	audit_log_format(ab, " compat=%d", is_compat_task());
diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
index 7a57f67..6fa60ff 100644
--- a/security/integrity/ima/ima_audit.c
+++ b/security/integrity/ima/ima_audit.c
@@ -38,6 +38,9 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 		return;
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	if (!ab)
+		return;
+
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 current->pid, current_cred()->uid,
 			 audit_get_loginuid(current),
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 1a95830..2c39e18 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -276,6 +276,8 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 	int result = 0;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
+	if (!ab)
+		return -EINVAL;
 
 	entry->uid = -1;
 	entry->action = UNKNOWN;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6c77f63..59c5929 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2802,6 +2802,8 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 				audit_size = 0;
 			}
 			ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR);
+			if (!ab)
+				return -EINVAL;
 			audit_log_format(ab, "op=setxattr invalid_context=");
 			audit_log_n_untrustedstring(ab, value, audit_size);
 			audit_log_end(ab);
@@ -5318,6 +5320,8 @@ static int selinux_setprocattr(struct task_struct *p,
 				else
 					audit_size = size;
 				ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR);
+				if (!ab)
+					return -EINVAL;
 				audit_log_format(ab, "op=fscreate invalid_context=");
 				audit_log_n_untrustedstring(ab, value, audit_size);
 				audit_log_end(ab);
