Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1GZS7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:59:14 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41353 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753442Ab1GZS6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:58:19 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        akpm@osdl.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 08/14] af_netlink.c: make netlink_capable userns-aware
Date: Tue, 26 Jul 2011 18:58:31 +0000
Message-Id: <1311706717-7398-9-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1311706717-7398-1-git-send-email-serge@hallyn.com>
References: <1311706717-7398-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

netlink_capable should check for permissions against the user
namespace owning the socket in question.

Changelog:
  Per Eric Dumazet advice, use sock_net(sk) instead of #ifdef.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netlink/af_netlink.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0a4db02..3cc0bbe 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -580,8 +580,9 @@ retry:
 
 static inline int netlink_capable(struct socket *sock, unsigned int flag)
 {
-	return (nl_table[sock->sk->sk_protocol].nl_nonroot & flag) ||
-	       capable(CAP_NET_ADMIN);
+	if (nl_table[sock->sk->sk_protocol].nl_nonroot & flag)
+		return 1;
+	return ns_capable(sock_net(sock->sk)->user_ns, CAP_NET_ADMIN);
 }
 
 static void
-- 
1.7.4.1

