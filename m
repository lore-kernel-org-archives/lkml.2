Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2KZD3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:29:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2KZD3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:29:22 -0500
From: ling.ma.program@gmail.com
To: edumazet@google.com
Cc: linux-kernel@vger.kernel.org, Ma Ling <ling.ma.program@gmail.com>
Subject: [PATCH RFC] [INET]: Get cirtical word in first 64bit of cache line
Date: Mon, 26 Nov 2012 11:29:15 +0800
Message-Id: <1353900555-5966-1-git-send-email-ling.ma.program@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma.program@gmail.com>

In order to reduce memory latency when last level cache miss occurs,
modern CPUs i.e. x86 and arm introduced Critical Word First(CWF) or
Early Restart(ER) to get data ASAP. For CWF if critical word is first member
in cache line, memory feed CPU with critical word, then fill others
data in cache line one by one, otherwise after critical word it must
cost more cycle to fill the remaining cache line. For Early First CPU will
restart until critical word in cache line reaches.

Hash value is critical word, so in this patch we place it as first member
in cache line(sock address is cache-line aligned), and it is also good for
Early Restart platform as well .

Thanks
Ling

---
 include/net/sock.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 4a45216..312cf31 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -128,10 +128,10 @@ struct net;
 
 /**
  *	struct sock_common - minimal network layer representation of sockets
- *	@skc_daddr: Foreign IPv4 addr
- *	@skc_rcv_saddr: Bound local IPv4 addr
  *	@skc_hash: hash value used with various protocol lookup tables
  *	@skc_u16hashes: two u16 hash values used by UDP lookup tables
+ *	@skc_daddr: Foreign IPv4 addr
+ *	@skc_rcv_saddr: Bound local IPv4 addr
  *	@skc_family: network address family
  *	@skc_state: Connection state
  *	@skc_reuse: %SO_REUSEADDR setting
@@ -149,16 +149,16 @@ struct net;
  *	for struct sock and struct inet_timewait_sock.
  */
 struct sock_common {
+	/* skc_hash belongs to first member in sock with cache-line aligned*/
+	union  {
+		unsigned int	skc_hash;
+		__u16		skc_u16hashes[2];
+	};
 	/* skc_daddr and skc_rcv_saddr must be grouped :
 	 * cf INET_MATCH() and INET_TW_MATCH()
 	 */
 	__be32			skc_daddr;
 	__be32			skc_rcv_saddr;
-
-	union  {
-		unsigned int	skc_hash;
-		__u16		skc_u16hashes[2];
-	};
 	unsigned short		skc_family;
 	volatile unsigned char	skc_state;
 	unsigned char		skc_reuse;
-- 
1.7.1

