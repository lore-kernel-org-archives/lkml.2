Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2DJU1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:27:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40927 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab2DJU1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:27:06 -0400
Date: Tue, 10 Apr 2012 13:26:44 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Eric Paris <eparis@redhat.com>, Paul Moore <paul.moore@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] Smack: build when CONFIG_AUDIT not defined
Message-ID: <20120410202644.GA10466@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes builds where CONFIG_AUDIT is not defined and
CONFIG_SECURITY_SMACK=y.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/smack/smack_lsm.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 81c03a5..10056f2 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1939,18 +1939,19 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	char *hostsp;
 	struct socket_smack *ssp = sk->sk_security;
 	struct smk_audit_info ad;
-	struct lsm_network_audit net;
 
 	rcu_read_lock();
 	hostsp = smack_host_label(sap);
 	if (hostsp != NULL) {
-		sk_lbl = SMACK_UNLABELED_SOCKET;
 #ifdef CONFIG_AUDIT
+		struct lsm_network_audit net;
+
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		ad.a.u.net->family = sap->sin_family;
 		ad.a.u.net->dport = sap->sin_port;
 		ad.a.u.net->v4info.daddr = sap->sin_addr.s_addr;
 #endif
+		sk_lbl = SMACK_UNLABELED_SOCKET;
 		rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE, &ad);
 	} else {
 		sk_lbl = SMACK_CIPSO_SOCKET;
@@ -2809,11 +2810,14 @@ static int smack_unix_stream_connect(struct sock *sock,
 	struct socket_smack *osp = other->sk_security;
 	struct socket_smack *nsp = newsk->sk_security;
 	struct smk_audit_info ad;
-	struct lsm_network_audit net;
 	int rc = 0;
 
+#ifdef CONFIG_AUDIT
+	struct lsm_network_audit net;
+
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 	smk_ad_setfield_u_net_sk(&ad, other);
+#endif
 
 	if (!capable(CAP_MAC_OVERRIDE))
 		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
@@ -2842,11 +2846,14 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 	struct socket_smack *ssp = sock->sk->sk_security;
 	struct socket_smack *osp = other->sk->sk_security;
 	struct smk_audit_info ad;
-	struct lsm_network_audit net;
 	int rc = 0;
 
+#ifdef CONFIG_AUDIT
+	struct lsm_network_audit net;
+
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 	smk_ad_setfield_u_net_sk(&ad, other->sk);
+#endif
 
 	if (!capable(CAP_MAC_OVERRIDE))
 		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
@@ -2993,7 +3000,9 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	char *csp;
 	int rc;
 	struct smk_audit_info ad;
+#ifdef CONFIG_AUDIT
 	struct lsm_network_audit net;
+#endif
 	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
 		return 0;
 
@@ -3156,7 +3165,9 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	char *sp;
 	int rc;
 	struct smk_audit_info ad;
+#ifdef CONFIG_AUDIT
 	struct lsm_network_audit net;
+#endif
 
 	/* handle mapped IPv4 packets arriving via IPv6 sockets */
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
-- 
1.7.0.4

