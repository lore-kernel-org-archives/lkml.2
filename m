Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2KSWBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:01:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47887 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2KSWBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:01:02 -0500
Date: Mon, 19 Nov 2012 14:00:51 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: catch possible NULL audit buffers
Message-ID: <20121119220051.GA16851@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for audit_log_start() to return NULL. Handle it in the
various callers.

Signed-off-by: Kees Cook <keescook@chromium.org>

---
This leaves out the change to the audit_seccomp, since I fixed that in
a separate patch ("audit: create explicit AUDIT_SECCOMP event type").
---
 kernel/audit.c       |    4 ++++
 kernel/audit_tree.c  |   26 +++++++++++++++++---------
 kernel/audit_watch.c |    2 ++
 kernel/auditsc.c     |    6 ++++--
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 40414e9..a219998 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -272,6 +272,8 @@ static int audit_log_config_change(char *function_name, int new, int old,
 	int rc = 0;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	if (unlikely(!ab))
+		return rc;
 	audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
 			 old, from_kuid(&init_user_ns, loginuid), sessionid);
 	if (sid) {
@@ -619,6 +621,8 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 	}
 
 	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
+	if (unlikely(!*ab))
+		return rc;
 	audit_log_format(*ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_tgid_vnr(current),
 			 from_kuid(&init_user_ns, current_uid()),
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index ed206fd..29dc061 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -449,11 +449,26 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	return 0;
 }
 
+static void audit_log_remove_rule(struct audit_krule *rule)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab, "op=");
+	audit_log_string(ab, "remove rule");
+	audit_log_format(ab, " dir=");
+	audit_log_untrustedstring(ab, rule->tree->pathname);
+	audit_log_key(ab, rule->filterkey);
+	audit_log_format(ab, " list=%d res=1", rule->listnr);
+	audit_log_end(ab);
+}
+
 static void kill_rules(struct audit_tree *tree)
 {
 	struct audit_krule *rule, *next;
 	struct audit_entry *entry;
-	struct audit_buffer *ab;
 
 	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
 		entry = container_of(rule, struct audit_entry, rule);
@@ -461,14 +476,7 @@ static void kill_rules(struct audit_tree *tree)
 		list_del_init(&rule->rlist);
 		if (rule->tree) {
 			/* not a half-baked one */
-			ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
-			audit_log_format(ab, "op=");
-			audit_log_string(ab, "remove rule");
-			audit_log_format(ab, " dir=");
-			audit_log_untrustedstring(ab, rule->tree->pathname);
-			audit_log_key(ab, rule->filterkey);
-			audit_log_format(ab, " list=%d res=1", rule->listnr);
-			audit_log_end(ab);
+			audit_log_remove_rule(rule);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 9a9ae6e..3e29b7a 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -240,6 +240,8 @@ static void audit_watch_log_rule_change(struct audit_krule *r, struct audit_watc
 	if (audit_enabled) {
 		struct audit_buffer *ab;
 		ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
+		if (unlikely(!ab))
+			return;
 		audit_log_format(ab, "auid=%u ses=%u op=",
 				 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 				 audit_get_sessionid(current));
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2f186ed..f515ee9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1481,14 +1481,14 @@ static void show_special(struct audit_context *context, int *call_panic)
 			audit_log_end(ab);
 			ab = audit_log_start(context, GFP_KERNEL,
 					     AUDIT_IPC_SET_PERM);
+			if (unlikely(!ab))
+				return;
 			audit_log_format(ab,
 				"qbytes=%lx ouid=%u ogid=%u mode=%#ho",
 				context->ipc.qbytes,
 				context->ipc.perm_uid,
 				context->ipc.perm_gid,
 				context->ipc.perm_mode);
-			if (!ab)
-				return;
 		}
 		break; }
 	case AUDIT_MQ_OPEN: {
@@ -2775,6 +2775,8 @@ void audit_core_dumps(long signr)
 		return;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	if (unlikely(!ab))
+		return;
 	audit_log_abend(ab, "memory violation", signr);
 	audit_log_end(ab);
 }
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
