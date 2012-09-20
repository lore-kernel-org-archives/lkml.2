Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2ITBxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:53:09 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58535 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2ITBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:53:00 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:06 -0700
Message-Id: <1348105949-25454-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+xSKQ/41NfhlCEmKQ768iF0v+xhHgi9g0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0021]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 04/27] audit: Use current instead of NETLINK_CREDS() in audit_filter
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Get caller process uid and gid and pid values from the current task
instead of the NETLINK_CB.  This is simpler than passing NETLINK_CREDS
from from audit_receive_msg to audit_filter_user_rules and avoid the
chance of being hit by the occassional bugs in netlink uid/gid
credential passing.  This is a safe changes because all netlink
requests are processed in the task of the sending process.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/audit.h |    2 +-
 kernel/audit.c        |    2 +-
 kernel/auditfilter.c  |   13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 36abf2a..9c9af0e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -700,7 +700,7 @@ extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid);
 extern int		    audit_update_lsm_rules(void);
 
 				/* Private API (for audit.c only) */
-extern int audit_filter_user(struct netlink_skb_parms *cb);
+extern int audit_filter_user(void);
 extern int audit_filter_type(int type);
 extern int  audit_receive_filter(int type, int pid, int uid, int seq,
 				void *data, size_t datasz, uid_t loginuid,
diff --git a/kernel/audit.c b/kernel/audit.c
index 7b7268e..fecb150 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -744,7 +744,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
 
-		err = audit_filter_user(&NETLINK_CB(skb));
+		err = audit_filter_user();
 		if (err == 1) {
 			err = 0;
 			if (msg_type == AUDIT_USER_TTY) {
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a6c3f1a..b754f43 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1236,8 +1236,7 @@ int audit_compare_dname_path(const char *dname, const char *path,
 	return strncmp(p, dname, dlen);
 }
 
-static int audit_filter_user_rules(struct netlink_skb_parms *cb,
-				   struct audit_krule *rule,
+static int audit_filter_user_rules(struct audit_krule *rule,
 				   enum audit_state *state)
 {
 	int i;
@@ -1249,13 +1248,13 @@ static int audit_filter_user_rules(struct netlink_skb_parms *cb,
 
 		switch (f->type) {
 		case AUDIT_PID:
-			result = audit_comparator(cb->creds.pid, f->op, f->val);
+			result = audit_comparator(task_pid_vnr(current), f->op, f->val);
 			break;
 		case AUDIT_UID:
-			result = audit_comparator(cb->creds.uid, f->op, f->val);
+			result = audit_comparator(current_uid(), f->op, f->val);
 			break;
 		case AUDIT_GID:
-			result = audit_comparator(cb->creds.gid, f->op, f->val);
+			result = audit_comparator(current_gid(), f->op, f->val);
 			break;
 		case AUDIT_LOGINUID:
 			result = audit_comparator(audit_get_loginuid(current),
@@ -1287,7 +1286,7 @@ static int audit_filter_user_rules(struct netlink_skb_parms *cb,
 	return 1;
 }
 
-int audit_filter_user(struct netlink_skb_parms *cb)
+int audit_filter_user(void)
 {
 	enum audit_state state = AUDIT_DISABLED;
 	struct audit_entry *e;
@@ -1295,7 +1294,7 @@ int audit_filter_user(struct netlink_skb_parms *cb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
-		if (audit_filter_user_rules(cb, &e->rule, &state)) {
+		if (audit_filter_user_rules(&e->rule, &state)) {
 			if (state == AUDIT_DISABLED)
 				ret = 0;
 			break;
-- 
1.7.5.4

