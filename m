Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1HJSw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:52:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1HJSw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:52:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=NBLMJvnzKAXoQZ4QSK+4u0KodYlrR9EO4ZtpLgLKeH4GT1dpYsPKKPTpf9omSbg16
	WjuUwgFfqig2sDcXtLwJA==
From: Mike Waychison <mikew@google.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] tcp: initialize variable ecn_ok in syncookies path
Date: Wed, 10 Aug 2011 11:51:24 -0700
Message-Id: <1313002284-2362-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a gcc 4.4.3, warnings are emitted for a possibly uninitialized use
of ecn_ok.

This can happen if cookie_check_timestamp() returns due to not having
seen a timestamp.  Defaulting to ecn off seems like a reasonable thing to do in this case, so initialized ecn_ok to false.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 net/ipv4/syncookies.c |    2 +-
 net/ipv6/syncookies.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 92bb943..3bc5c8f 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -276,7 +276,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 	int mss;
 	struct rtable *rt;
 	__u8 rcv_wscale;
-	bool ecn_ok;
+	bool ecn_ok = false;
 
 	if (!sysctl_tcp_syncookies || !th->ack || th->rst)
 		goto out;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 89d5bf8..ac83896 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -165,7 +165,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	int mss;
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
-	bool ecn_ok;
+	bool ecn_ok = false;
 
 	if (!sysctl_tcp_syncookies || !th->ack || th->rst)
 		goto out;
-- 
1.7.3.1

