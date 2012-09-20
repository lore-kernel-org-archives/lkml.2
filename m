Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2ITBxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:53:25 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58593 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2ITBxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:53:21 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:11 -0700
Message-Id: <1348105949-25454-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+DycS5+ld5ekXJpnbpU2XzdQGA69nkrAI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0401]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 09/27] audit: Don't pass pid or uid to audit_log_common_recv_msg
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

The only place we use the uid and the pid that we calculate in
audit_receive_msg is in audit_log_common_recv_msg so move the
calculation of these values into the audit_log_common_recv_msg.

Simplify the calcuation of the current pid and uid by
reading them from current instead of reading them from
NETLINK_CREDS.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/audit.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index a31e31b..2e0dd5e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -607,8 +607,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 }
 
 static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
-				     u32 pid, u32 uid, uid_t auid, u32 ses,
-				     u32 sid)
+				     uid_t auid, u32 ses, u32 sid)
 {
 	int rc = 0;
 	char *ctx = NULL;
@@ -621,7 +620,9 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 
 	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
 	audit_log_format(*ab, "pid=%d uid=%u auid=%u ses=%u",
-			 pid, uid, auid, ses);
+			 task_tgid_vnr(current),
+			 from_kuid(&init_user_ns, current_uid()),
+			 auid, ses);
 	if (sid) {
 		rc = security_secid_to_secctx(sid, &ctx, &len);
 		if (rc)
@@ -637,7 +638,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 
 static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
-	u32			uid, pid, seq, sid;
+	u32			seq, sid;
 	void			*data;
 	struct audit_status	*status_get, status_set;
 	int			err;
@@ -663,8 +664,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return err;
 	}
 
-	pid  = NETLINK_CREDS(skb)->pid;
-	uid  = NETLINK_CREDS(skb)->uid;
 	loginuid = audit_get_loginuid(current);
 	sessionid = audit_get_sessionid(current);
 	security_task_getsecid(current, &sid);
@@ -735,7 +734,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
-			audit_log_common_recv_msg(&ab, msg_type, pid, uid,
+			audit_log_common_recv_msg(&ab, msg_type,
 						  loginuid, sessionid, sid);
 
 			if (msg_type != AUDIT_USER_TTY)
@@ -760,8 +759,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlmsg_len(nlh) < sizeof(struct audit_rule))
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE, pid,
-						  uid, loginuid, sessionid, sid);
+			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+						  loginuid, sessionid, sid);
 
 			audit_log_format(ab, " audit_enabled=%d res=0",
 					 audit_enabled);
@@ -779,8 +778,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlmsg_len(nlh) < sizeof(struct audit_rule_data))
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE, pid,
-						  uid, loginuid, sessionid, sid);
+			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+						  loginuid, sessionid, sid);
 
 			audit_log_format(ab, " audit_enabled=%d res=0",
 					 audit_enabled);
@@ -796,8 +795,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_TRIM:
 		audit_trim_trees();
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE, pid,
-					  uid, loginuid, sessionid, sid);
+		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+					  loginuid, sessionid, sid);
 
 		audit_log_format(ab, " op=trim res=1");
 		audit_log_end(ab);
@@ -828,8 +827,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* OK, here comes... */
 		err = audit_tag_tree(old, new);
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE, pid,
-					  uid, loginuid, sessionid, sid);
+		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+					  loginuid, sessionid, sid);
 
 		audit_log_format(ab, " op=make_equiv old=");
 		audit_log_untrustedstring(ab, old);
-- 
1.7.5.4

