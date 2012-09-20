Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab2ITByu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:54:50 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58554 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2ITBxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:53:08 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:08 -0700
Message-Id: <1348105949-25454-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hCazqnBnErG9fWYiz8nNLYGgwke2RuDg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 06/27] audit: Simply AUDIT_TTY_SET and AUDIT_TTY_GET
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Use current instead of looking up the current up the current task by
process identifier.  Netlink requests are processed in trhe context of
the sending task so this is safe.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/audit.c |   38 +++++++++++++-------------------------
 1 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 58f704b..2a8728f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -866,41 +866,29 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	case AUDIT_TTY_GET: {
 		struct audit_tty_status s;
-		struct task_struct *tsk;
-		unsigned long flags;
-
-		rcu_read_lock();
-		tsk = find_task_by_vpid(pid);
-		if (tsk && lock_task_sighand(tsk, &flags)) {
-			s.enabled = tsk->signal->audit_tty != 0;
-			unlock_task_sighand(tsk, &flags);
-		} else
-			err = -ESRCH;
-		rcu_read_unlock();
-
-		if (!err)
-			audit_send_reply(NETLINK_CB(skb).pid, seq,
-					 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
+		struct task_struct *tsk = current;
+
+		spin_lock_irq(&tsk->sighand->siglock);
+		s.enabled = tsk->signal->audit_tty != 0;
+		spin_unlock_irq(&tsk->sighand->siglock);
+
+		audit_send_reply(NETLINK_CB(skb).pid, seq,
+				 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_TTY_SET: {
 		struct audit_tty_status *s;
-		struct task_struct *tsk;
-		unsigned long flags;
+		struct task_struct *tsk = current;
 
 		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
 			return -EINVAL;
 		s = data;
 		if (s->enabled != 0 && s->enabled != 1)
 			return -EINVAL;
-		rcu_read_lock();
-		tsk = find_task_by_vpid(pid);
-		if (tsk && lock_task_sighand(tsk, &flags)) {
-			tsk->signal->audit_tty = s->enabled != 0;
-			unlock_task_sighand(tsk, &flags);
-		} else
-			err = -ESRCH;
-		rcu_read_unlock();
+
+		spin_lock_irq(&tsk->sighand->siglock);
+		tsk->signal->audit_tty = s->enabled != 0;
+		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	}
 	default:
-- 
1.7.5.4

