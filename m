Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab1DMQQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:16:17 -0400
Received: from kroah.org ([198.145.64.141]:53076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab1DMQNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:49 2011
Message-Id: <20110413161049.412863118@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nelson Elhage <nelhage@ksplice.com>, Thomas Graf <tgraf@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [65/71] inet_diag: Make sure we actually run the same bytecode we audited.
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Nelson Elhage <nelhage@ksplice.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/inet_diag.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -489,9 +489,11 @@ static int inet_csk_diag_dump(struct soc
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
@@ -511,7 +513,7 @@ static int inet_csk_diag_dump(struct soc
 		entry.dport = ntohs(inet->inet_dport);
 		entry.userlocks = sk->sk_userlocks;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -526,9 +528,11 @@ static int inet_twsk_diag_dump(struct in
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
@@ -547,7 +551,7 @@ static int inet_twsk_diag_dump(struct in
 		entry.dport = ntohs(tw->tw_dport);
 		entry.userlocks = 0;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -617,7 +621,7 @@ static int inet_diag_dump_reqs(struct sk
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct listen_sock *lopt;
-	struct rtattr *bc = NULL;
+	const struct nlattr *bc = NULL;
 	struct inet_sock *inet = inet_sk(sk);
 	int j, s_j;
 	int reqnum, s_reqnum;
@@ -637,8 +641,9 @@ static int inet_diag_dump_reqs(struct sk
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
@@ -671,8 +676,8 @@ static int inet_diag_dump_reqs(struct sk
 					&ireq->rmt_addr;
 				entry.dport = ntohs(ireq->rmt_port);
 
-				if (!inet_diag_bc_run(RTA_DATA(bc),
-						    RTA_PAYLOAD(bc), &entry))
+				if (!inet_diag_bc_run(nla_data(bc),
+						      nla_len(bc), &entry))
 					continue;
 			}
 


