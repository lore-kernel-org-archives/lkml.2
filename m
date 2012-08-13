Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2HMUeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:34:13 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56669 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2HMUYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:16 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 13 Aug 2012 13:18:28 -0700
Message-Id: <1344889115-21610-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX180rtvdTs7Bj9pcnGdQuLNJ7lTsrdscASo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1316]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 14/21] userns: nfnetlink_log: Report socket uids in the log sockets user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

At logging instance creation capture the peer netlink socket's user
namespace. Use the captured peer user namespace when reporting socket
uids to the peer.

The peer socket's user namespace is guaranateed to be valid until the user
closes the netlink socket.  nfnetlink_log removes instances during the final
close of a socket.  __build_packet_message does not get called after an
instance is destroyed.   Therefore it is safe to let the peer netlink socket
take care of the user namespace reference counting for us.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig                  |    1 -
 net/netfilter/nfnetlink_log.c |   14 ++++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 07435e0..2660b31 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -947,7 +947,6 @@ config UIDGID_CONVERTED
 	depends on NETFILTER_XT_MATCH_OWNER = n
 	depends on NETFILTER_XT_MATCH_RECENT = n
 	depends on NETFILTER_XT_TARGET_LOG = n
-	depends on NETFILTER_NETLINK_LOG = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
 	depends on DNS_RESOLVER = n
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 169ab59..4142aac 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -55,6 +55,7 @@ struct nfulnl_instance {
 	unsigned int qlen;		/* number of nlmsgs in skb */
 	struct sk_buff *skb;		/* pre-allocatd skb */
 	struct timer_list timer;
+	struct user_namespace *peer_user_ns;	/* User namespace of the peer process */
 	int peer_pid;			/* PID of the peer process */
 
 	/* configurable parameters */
@@ -132,7 +133,7 @@ instance_put(struct nfulnl_instance *inst)
 static void nfulnl_timer(unsigned long data);
 
 static struct nfulnl_instance *
-instance_create(u_int16_t group_num, int pid)
+instance_create(u_int16_t group_num, int pid, struct user_namespace *user_ns)
 {
 	struct nfulnl_instance *inst;
 	int err;
@@ -162,6 +163,7 @@ instance_create(u_int16_t group_num, int pid)
 
 	setup_timer(&inst->timer, nfulnl_timer, (unsigned long)inst);
 
+	inst->peer_user_ns = user_ns;
 	inst->peer_pid = pid;
 	inst->group_num = group_num;
 
@@ -503,8 +505,11 @@ __build_packet_message(struct nfulnl_instance *inst,
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
 			struct file *file = skb->sk->sk_socket->file;
-			__be32 uid = htonl(file->f_cred->fsuid);
-			__be32 gid = htonl(file->f_cred->fsgid);
+			__be32 uid = htonl(from_kuid_munged(inst->peer_user_ns,
+							    file->f_cred->fsuid));
+			__be32 gid = htonl(from_kgid_munged(inst->peer_user_ns,
+							    file->f_cred->fsgid));
+			/* need to unlock here since NLA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 			if (nla_put_be32(inst->skb, NFULA_UID, uid) ||
 			    nla_put_be32(inst->skb, NFULA_GID, gid))
@@ -783,7 +788,8 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			}
 
 			inst = instance_create(group_num,
-					       NETLINK_CB(skb).pid);
+					       NETLINK_CB(skb).pid,
+					       sk_user_ns(NETLINK_CB(skb).ssk));
 			if (IS_ERR(inst)) {
 				ret = PTR_ERR(inst);
 				goto out;
-- 
1.7.5.4

