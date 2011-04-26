Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1DZVbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:31:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:44123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab1DZVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951134"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: nelhage@ksplice.com, tgraf@infradead.org, davem@davemloft.net,
        ak@linux.intel.com, jmm@debian.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [48/106] inet_diag: Make sure we actually run the same bytecode we audited.
Message-Id: <20110426211328.428CB3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Nelson Elhage <nelhage@ksplice.com>

commit 22e76c849d505d87c5ecf3d3e6742a65f0ff4860 upstream.

We were using nlmsg_find_attr() to look up the bytecode by attribute when
auditing, but then just using the first attribute when actually running
bytecode. So, if we received a message with two attribute elements, where only
the second had type INET_DIAG_REQ_BYTECODE, we would validate and run different
bytecode strings.

Fix this by consistently using nlmsg_find_attr everywhere.

[AK: Add const to nlmsg_find_attr to fix new warning]

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: Thomas Graf <tgraf@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[jmm: Slightly adapted to apply against 2.6.32]
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/inet_diag.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: linux-2.6.35.y/net/ipv4/inet_diag.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/inet_diag.c
+++ linux-2.6.35.y/net/ipv4/inet_diag.c
@@ -490,9 +490,11 @@ static int inet_csk_diag_dump(struct soc
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
@@ -512,7 +514,7 @@ static int inet_csk_diag_dump(struct soc
 		entry.dport = ntohs(inet->inet_dport);
 		entry.userlocks = sk->sk_userlocks;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -527,9 +529,11 @@ static int inet_twsk_diag_dump(struct in
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
@@ -548,7 +552,7 @@ static int inet_twsk_diag_dump(struct in
 		entry.dport = ntohs(tw->tw_dport);
 		entry.userlocks = 0;
 
-		if (!inet_diag_bc_run(RTA_DATA(bc), RTA_PAYLOAD(bc), &entry))
+		if (!inet_diag_bc_run(nla_data(bc), nla_len(bc), &entry))
 			return 0;
 	}
 
@@ -618,7 +622,7 @@ static int inet_diag_dump_reqs(struct sk
 	struct inet_diag_req *r = NLMSG_DATA(cb->nlh);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct listen_sock *lopt;
-	struct rtattr *bc = NULL;
+	const struct nlattr *bc = NULL;
 	struct inet_sock *inet = inet_sk(sk);
 	int j, s_j;
 	int reqnum, s_reqnum;
@@ -638,8 +642,9 @@ static int inet_diag_dump_reqs(struct sk
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
@@ -672,8 +677,8 @@ static int inet_diag_dump_reqs(struct sk
 					&ireq->rmt_addr;
 				entry.dport = ntohs(ireq->rmt_port);
 
-				if (!inet_diag_bc_run(RTA_DATA(bc),
-						    RTA_PAYLOAD(bc), &entry))
+				if (!inet_diag_bc_run(nla_data(bc),
+						      nla_len(bc), &entry))
 					continue;
 			}
 
Index: linux-2.6.35.y/include/net/netlink.h
===================================================================
--- linux-2.6.35.y.orig/include/net/netlink.h
+++ linux-2.6.35.y/include/net/netlink.h
@@ -384,7 +384,7 @@ static inline int nlmsg_parse(const stru
  *
  * Returns the first attribute which matches the specified type.
  */
-static inline struct nlattr *nlmsg_find_attr(struct nlmsghdr *nlh,
+static inline struct nlattr *nlmsg_find_attr(const struct nlmsghdr *nlh,
 					     int hdrlen, int attrtype)
 {
 	return nla_find(nlmsg_attrdata(nlh, hdrlen),
