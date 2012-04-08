Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2DHFWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:22:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2DHFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:18 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:05 -0700
Message-Id: <1333862139-31737-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ni8D2ju/QkhPniAce+zHCOds8FCnZCeM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2740]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 09/43] mqueue: Explicitly capture the user namespace to send the notification to.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Stop relying on user->user_ns which is going away and instead capture
the user_namespace of the process we are supposed to notify.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 ipc/mqueue.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 28bd64d..b53cf34 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -66,6 +66,7 @@ struct mqueue_inode_info {
 
 	struct sigevent notify;
 	struct pid* notify_owner;
+	struct user_namespace *notify_user_ns;
 	struct user_struct *user;	/* user who created, for accounting */
 	struct sock *notify_sock;
 	struct sk_buff *notify_cookie;
@@ -139,6 +140,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		INIT_LIST_HEAD(&info->e_wait_q[0].list);
 		INIT_LIST_HEAD(&info->e_wait_q[1].list);
 		info->notify_owner = NULL;
+		info->notify_user_ns = NULL;
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
@@ -536,7 +538,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			rcu_read_lock();
 			sig_i.si_pid = task_tgid_nr_ns(current,
 						ns_of_pid(info->notify_owner));
-			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
+			sig_i.si_uid = user_ns_map_uid(info->notify_user_ns,
 						current_cred(), current_uid());
 			rcu_read_unlock();
 
@@ -550,7 +552,9 @@ static void __do_notify(struct mqueue_inode_info *info)
 		}
 		/* after notification unregisters process */
 		put_pid(info->notify_owner);
+		put_user_ns(info->notify_user_ns);
 		info->notify_owner = NULL;
+		info->notify_user_ns = NULL;
 	}
 	wake_up(&info->wait_q);
 }
@@ -575,7 +579,9 @@ static void remove_notification(struct mqueue_inode_info *info)
 		netlink_sendskb(info->notify_sock, info->notify_cookie);
 	}
 	put_pid(info->notify_owner);
+	put_user_ns(info->notify_user_ns);
 	info->notify_owner = NULL;
+	info->notify_user_ns = NULL;
 }
 
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
@@ -1140,6 +1146,7 @@ retry:
 		}
 
 		info->notify_owner = get_pid(task_tgid(current));
+		info->notify_user_ns = get_user_ns(current_user_ns());
 		inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	}
 	spin_unlock(&info->lock);
-- 
1.7.2.5

