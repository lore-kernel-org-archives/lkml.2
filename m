Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab1FWRjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:39:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:35824 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898Ab1FWRjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nelson Elhage <nelhage@ksplice.com>,
        Thomas Graf <tgraf@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 234/247] inet_diag: Make sure we actually run the same bytecode we audited.
Date: Thu, 23 Jun 2011 13:35:02 -0400
Message-Id: <1308850515-15242-175-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 22e76c849d505d87c5ecf3d3e6742a65f0ff4860 upstream.

We were using nlmsg_find_attr() to look up the bytecode by attribute when
auditing, but then just using the first attribute when actually running
bytecode. So, if we received a message with two attribute elements, where only
the second had type INET_DIAG_REQ_BYTECODE, we would validate and run different
bytecode strings.

Fix this by consistently using nlmsg_find_attr everywhere.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: Thomas Graf <tgraf@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/inet_diag.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index e5fa2dd..7403b9b 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -490,9 +490,11 @@ static int inet_csk_diag_dump(struct sock *sk,
 {
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 
-	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
+	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
 		struct inet_diag_entry entry;
-		struct rtattr *bc = (struct rtattr *)(r + 1);
+		const struct nlattr *bc = nlmsg_find_attr(cb->nlh,
+							  sizeof(*r),
+							  INET_DIAG_REQ_BYTECODE);
 		struct inet_sock *inet = inet_sk(sk);
 
 		entry.family = sk->sk_family;
@@ -512,7 +514,7 @@ static int inet_csk_diag_dump(struct sock *sk,
 		entry.dport = ntohs(inet->inet_dport);
 		entry.userlocks = sk->sk_userlocks;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -527,9 +529,11 @@ static int inet_twsk_diag_dump(struct inet_timewait_sock *tw,
 {
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 
-	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
+	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
 		struct inet_diag_entry entry;
-		struct rtattr *bc = (struct rtattr *)(r + 1);
+		const struct nlattr *bc = nlmsg_find_attr(cb->nlh,
+							  sizeof(*r),
+							  INET_DIAG_REQ_BYTECODE);
 
 		entry.family = tw->tw_family;
 #if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
@@ -548,7 +552,7 @@ static int inet_twsk_diag_dump(struct inet_timewait_sock *tw,
 		entry.dport = ntohs(tw->tw_dport);
 		entry.userlocks = 0;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -618,7 +622,7 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct listen_sock *lopt;
-	struct rtattr *bc = NULL;
+	const struct nlattr *bc = NULL;
 	struct inet_sock *inet = inet_sk(sk);
 	int j, s_j;
 	int reqnum, s_reqnum;
@@ -638,8 +642,9 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 	if (!lopt || !lopt->qlen)
 		goto out;
 
-	if (cb->nlh->nlmsg_len > 4 + NLMSG_SPACE(sizeof(*r))) {
-		bc = (struct rtattr *)(r + 1);
+	if (nlmsg_attrlen(cb->nlh, sizeof(*r))) {
+		bc = nlmsg_find_attr(cb->nlh, sizeof(*r),
+				     INET_DIAG_REQ_BYTECODE);
 		entry.sport = inet->inet_num;
 		entry.userlocks = sk->sk_userlocks;
 	}
@@ -672,8 +677,8 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 					&ireq->rmt_addr;
 				entry.dport = ntohs(ireq->rmt_port);
 
-				if (!inet_diag_bc_run(RTA_DATA(bc),
-						    RTA_PAYLOAD(bc), &entry))
+				if (!inet_diag_bc_run(nla_data(bc),
+						      nla_len(bc), &entry))
 					continue;
 			}
 
-- 
1.7.4.4

