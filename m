Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2ETANb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 20:13:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42909 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2ETAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 20:13:29 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] net/ipv4: replace simple_strtoul with kstrtoul
Date: Sun, 20 May 2012 02:13:18 +0200
Message-Id: <1337472798-18913-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace simple_strtoul with kstrtoul in three similar occurrences, all setup
handlers:
* route.c: set_rhash_entries
* tcp.c: set_thash_entries
* udp.c: set_uhash_entries

Also check if the conversion failed.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 net/ipv4/route.c |    8 +++++++-
 net/ipv4/tcp.c   |    8 +++++++-
 net/ipv4/udp.c   |    8 +++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 167ea10..84d1832 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3430,9 +3430,15 @@ struct ip_rt_acct __percpu *ip_rt_acct __read_mostly;
 static __initdata unsigned long rhash_entries;
 static int __init set_rhash_entries(char *str)
 {
+	ssize_t ret;
+
 	if (!str)
 		return 0;
-	rhash_entries = simple_strtoul(str, &str, 0);
+
+	ret = kstrtoul(str, 0, &rhash_entries);
+	if (ret)
+		return 0;
+
 	return 1;
 }
 __setup("rhash_entries=", set_rhash_entries);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6589e11..6ed0552 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3222,9 +3222,15 @@ extern struct tcp_congestion_ops tcp_reno;
 static __initdata unsigned long thash_entries;
 static int __init set_thash_entries(char *str)
 {
+	ssize_t ret;
+
 	if (!str)
 		return 0;
-	thash_entries = simple_strtoul(str, &str, 0);
+
+	ret = kstrtoul(str, 0, &thash_entries);
+	if (ret)
+		return 0;
+
 	return 1;
 }
 __setup("thash_entries=", set_thash_entries);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fe14105..662836a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2163,9 +2163,15 @@ void udp4_proc_exit(void)
 static __initdata unsigned long uhash_entries;
 static int __init set_uhash_entries(char *str)
 {
+	ssize_t ret;
+
 	if (!str)
 		return 0;
-	uhash_entries = simple_strtoul(str, &str, 0);
+
+	ret = kstrtoul(str, 0, &uhash_entries);
+	if (ret)
+		return 0;
+
 	if (uhash_entries && uhash_entries < UDP_HTABLE_SIZE_MIN)
 		uhash_entries = UDP_HTABLE_SIZE_MIN;
 	return 1;
-- 
1.7.10

