Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2HMUdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:33:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56682 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2HMUYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Date: Mon, 13 Aug 2012 13:18:27 -0700
Message-Id: <1344889115-21610-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18sMTKCp6/WBBCG5iPk3h/xKHPZN1wfK04=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0557]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 13/21] userns: Teach inet_diag to work with user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Compute the user namespace of the socket that we are replying to
and translate the kuids of reported sockets into that user namespace.

Cc: Andrew Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/inet_diag.h |    1 +
 init/Kconfig              |    1 -
 net/ipv4/inet_diag.c      |   21 +++++++++++++++------
 net/ipv4/udp_diag.c       |    5 ++++-
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index f1362b5..e788c18 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -159,6 +159,7 @@ struct inet_diag_handler {
 struct inet_connection_sock;
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 			      struct sk_buff *skb, struct inet_diag_req_v2 *req,
+			      struct user_namespace *user_ns,
 			      u32 pid, u32 seq, u16 nlmsg_flags,
 			      const struct nlmsghdr *unlh);
 void inet_diag_dump_icsk(struct inet_hashinfo *h, struct sk_buff *skb,
diff --git a/init/Kconfig b/init/Kconfig
index 8447e0c..07435e0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -950,7 +950,6 @@ config UIDGID_CONVERTED
 	depends on NETFILTER_NETLINK_LOG = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
-	depends on INET_DIAG = n
 	depends on DNS_RESOLVER = n
 
 	# Filesystems
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 570e61f..8bc005b 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -69,6 +69,7 @@ static inline void inet_diag_unlock_handler(
 
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 			      struct sk_buff *skb, struct inet_diag_req_v2 *req,
+			      struct user_namespace *user_ns,		      	
 			      u32 pid, u32 seq, u16 nlmsg_flags,
 			      const struct nlmsghdr *unlh)
 {
@@ -124,7 +125,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	}
 #endif
 
-	r->idiag_uid = sock_i_uid(sk);
+	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	r->idiag_inode = sock_i_ino(sk);
 
 	if (ext & (1 << (INET_DIAG_MEMINFO - 1))) {
@@ -199,11 +200,12 @@ EXPORT_SYMBOL_GPL(inet_sk_diag_fill);
 
 static int inet_csk_diag_fill(struct sock *sk,
 			      struct sk_buff *skb, struct inet_diag_req_v2 *req,
+			      struct user_namespace *user_ns,
 			      u32 pid, u32 seq, u16 nlmsg_flags,
 			      const struct nlmsghdr *unlh)
 {
 	return inet_sk_diag_fill(sk, inet_csk(sk),
-			skb, req, pid, seq, nlmsg_flags, unlh);
+			skb, req, user_ns, pid, seq, nlmsg_flags, unlh);
 }
 
 static int inet_twsk_diag_fill(struct inet_timewait_sock *tw,
@@ -256,14 +258,16 @@ static int inet_twsk_diag_fill(struct inet_timewait_sock *tw,
 }
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
-			struct inet_diag_req_v2 *r, u32 pid, u32 seq, u16 nlmsg_flags,
+			struct inet_diag_req_v2 *r,
+			struct user_namespace *user_ns,
+			u32 pid, u32 seq, u16 nlmsg_flags,
 			const struct nlmsghdr *unlh)
 {
 	if (sk->sk_state == TCP_TIME_WAIT)
 		return inet_twsk_diag_fill((struct inet_timewait_sock *)sk,
 					   skb, r, pid, seq, nlmsg_flags,
 					   unlh);
-	return inet_csk_diag_fill(sk, skb, r, pid, seq, nlmsg_flags, unlh);
+	return inet_csk_diag_fill(sk, skb, r, user_ns, pid, seq, nlmsg_flags, unlh);
 }
 
 int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *in_skb,
@@ -311,6 +315,7 @@ int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *in_s
 	}
 
 	err = sk_diag_fill(sk, rep, req,
+			   sk_user_ns(NETLINK_CB(in_skb).ssk),
 			   NETLINK_CB(in_skb).pid,
 			   nlh->nlmsg_seq, 0, nlh);
 	if (err < 0) {
@@ -551,6 +556,7 @@ static int inet_csk_diag_dump(struct sock *sk,
 		return 0;
 
 	return inet_csk_diag_fill(sk, skb, r,
+				  sk_user_ns(NETLINK_CB(cb->skb).ssk),
 				  NETLINK_CB(cb->skb).pid,
 				  cb->nlh->nlmsg_seq, NLM_F_MULTI, cb->nlh);
 }
@@ -591,7 +597,9 @@ static int inet_twsk_diag_dump(struct inet_timewait_sock *tw,
 }
 
 static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
-			      struct request_sock *req, u32 pid, u32 seq,
+			      struct request_sock *req,
+			      struct user_namespace *user_ns,
+			      u32 pid, u32 seq,
 			      const struct nlmsghdr *unlh)
 {
 	const struct inet_request_sock *ireq = inet_rsk(req);
@@ -625,7 +633,7 @@ static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 	r->idiag_expires = jiffies_to_msecs(tmo);
 	r->idiag_rqueue = 0;
 	r->idiag_wqueue = 0;
-	r->idiag_uid = sock_i_uid(sk);
+	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	r->idiag_inode = 0;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (r->idiag_family == AF_INET6) {
@@ -702,6 +710,7 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 			}
 
 			err = inet_diag_fill_req(skb, sk, req,
+					       sk_user_ns(NETLINK_CB(cb->skb).ssk),
 					       NETLINK_CB(cb->skb).pid,
 					       cb->nlh->nlmsg_seq, cb->nlh);
 			if (err < 0) {
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 16d0960..d2f336e 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -24,7 +24,9 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb,
 	if (!inet_diag_bc_sk(bc, sk))
 		return 0;
 
-	return inet_sk_diag_fill(sk, NULL, skb, req, NETLINK_CB(cb->skb).pid,
+	return inet_sk_diag_fill(sk, NULL, skb, req,
+			sk_user_ns(NETLINK_CB(cb->skb).ssk),
+			NETLINK_CB(cb->skb).pid,
 			cb->nlh->nlmsg_seq, NLM_F_MULTI, cb->nlh);
 }
 
@@ -69,6 +71,7 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
 		goto out;
 
 	err = inet_sk_diag_fill(sk, NULL, rep, req,
+			   sk_user_ns(NETLINK_CB(in_skb).ssk),
 			   NETLINK_CB(in_skb).pid,
 			   nlh->nlmsg_seq, 0, nlh);
 	if (err < 0) {
-- 
1.7.5.4

