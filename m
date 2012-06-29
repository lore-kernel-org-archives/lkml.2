Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2F2Qqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:46:34 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42779 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2F2Qq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:46:28 -0400
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vincent Sanders <vincent.sanders@collabora.co.uk>
Subject: [PATCH net-next 05/15] security: selinux: Add AF_BUS socket SELinux hooks
Date: Fri, 29 Jun 2012 17:45:44 +0100
Message-Id: <1340988354-26981-6-git-send-email-vincent.sanders@collabora.co.uk>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Add Security-Enhanced Linux (SELinux) hook for AF_BUS socket address family.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
---
 security/selinux/hooks.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4ee6f23..5bacbe2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -67,6 +67,7 @@
 #include <linux/quota.h>
 #include <linux/un.h>		/* for Unix socket types */
 #include <net/af_unix.h>	/* for Unix socket types */
+#include <net/af_bus.h>	/* for Bus socket types */
 #include <linux/parser.h>
 #include <linux/nfs_mount.h>
 #include <net/ipv6.h>
@@ -4101,6 +4102,39 @@ static int selinux_socket_unix_may_send(struct socket *sock,
 			    &ad);
 }
 
+static int selinux_socket_bus_connect(struct sock *sock, struct sock *other,
+				      struct sock *newsk)
+{
+	struct sk_security_struct *sksec_sock = sock->sk_security;
+	struct sk_security_struct *sksec_other = other->sk_security;
+	struct sk_security_struct *sksec_new = newsk->sk_security;
+	struct common_audit_data ad;
+	struct lsm_network_audit net = {0,};
+	int err;
+
+	ad.type = LSM_AUDIT_DATA_NET;
+	ad.u.net = &net;
+	ad.u.net->sk = other;
+
+	err = avc_has_perm(sksec_sock->sid, sksec_other->sid,
+			   sksec_other->sclass,
+			   UNIX_STREAM_SOCKET__CONNECTTO, &ad);
+	if (err)
+		return err;
+
+	/* server child socket */
+	sksec_new->peer_sid = sksec_sock->sid;
+	err = security_sid_mls_copy(sksec_other->sid, sksec_sock->sid,
+				    &sksec_new->sid);
+	if (err)
+		return err;
+
+	/* connecting socket */
+	sksec_sock->peer_sid = sksec_new->sid;
+
+	return 0;
+}
+
 static int selinux_inet_sys_rcv_skb(int ifindex, char *addrp, u16 family,
 				    u32 peer_sid,
 				    struct common_audit_data *ad)
@@ -5643,6 +5677,7 @@ static struct security_operations selinux_ops = {
 
 	.unix_stream_connect =		selinux_socket_unix_stream_connect,
 	.unix_may_send =		selinux_socket_unix_may_send,
+	.bus_connect =		        selinux_socket_bus_connect,
 
 	.socket_create =		selinux_socket_create,
 	.socket_post_create =		selinux_socket_post_create,
-- 
1.7.10

