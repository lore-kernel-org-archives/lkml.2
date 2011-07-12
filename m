Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1GLXiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:38:00 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58736 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754106Ab1GLXhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:45 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [RFC PATCH 08/14] af_netlink.c: make netlink_capable userns-aware
Date: Tue, 12 Jul 2011 23:30:46 +0000
Message-Id: <1310513452-13397-9-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310513452-13397-1-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

netlink_capable should check for permissions against the user
namespace owning the socket in question.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/netlink/af_netlink.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6ef64ad..81c1099 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -580,8 +580,15 @@ retry:
 
 static inline int netlink_capable(struct socket *sock, unsigned int flag)
 {
-	return (nl_table[sock->sk->sk_protocol].nl_nonroot & flag) ||
-	       capable(CAP_NET_ADMIN);
+	struct net *net;
+	if (nl_table[sock->sk->sk_protocol].nl_nonroot & flag)
+		return 1;
+#ifdef CONFIG_NET_NS
+	net = sock->sk->sk_net;
+#else
+	net = &init_net;
+#endif
+	return ns_capable(net->user_ns, CAP_NET_ADMIN);
 }
 
 static void
-- 
1.7.4.1

