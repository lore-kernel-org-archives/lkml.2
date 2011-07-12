Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1GLXiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:38:03 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58738 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754181Ab1GLXhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:45 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [RFC PATCH 07/14] user namespace: use net->user_ns for some capable calls under net/
Date: Tue, 12 Jul 2011 23:30:45 +0000
Message-Id: <1310513452-13397-8-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310513452-13397-1-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@ubuntu.com>

Just a partial conversion to show how the previous patch is expected to
be used.

Changelog:
  6/28/11: fix typo in net/core/sock.c
  7/08/11: don't target capability which authorizes module loading

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/dev.c  |    4 ++--
 net/core/sock.c |   14 ++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9c58c1e..63d25b3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5004,7 +5004,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSIFNAME:
-		if (!capable(CAP_NET_ADMIN))
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		dev_load(net, ifr.ifr_name);
 		rtnl_lock();
@@ -5043,7 +5043,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
 	case SIOCSHWTSTAMP:
-		if (!capable(CAP_NET_ADMIN))
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		/* fall through */
 	case SIOCBONDSLAVEINFOQUERY:
diff --git a/net/core/sock.c b/net/core/sock.c
index 6e81978..965b1e7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -417,7 +417,7 @@ static int sock_bindtodevice(struct sock *sk, char __user *optval, int optlen)
 
 	/* Sorry... */
 	ret = -EPERM;
-	if (!capable(CAP_NET_RAW))
+	if (!ns_capable(net->user_ns, CAP_NET_RAW))
 		goto out;
 
 	ret = -EINVAL;
@@ -485,6 +485,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	int valbool;
 	struct linger ling;
 	int ret = 0;
+	struct net *net = sock_net(sk);
 
 	/*
 	 *	Options without arguments
@@ -505,7 +506,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case SO_DEBUG:
-		if (val && !capable(CAP_NET_ADMIN))
+		if (val && !ns_capable(net->user_ns, CAP_NET_ADMIN))
 			ret = -EACCES;
 		else
 			sock_valbool_flag(sk, SOCK_DBG, valbool);
@@ -548,7 +549,7 @@ set_sndbuf:
 		break;
 
 	case SO_SNDBUFFORCE:
-		if (!capable(CAP_NET_ADMIN)) {
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
@@ -586,7 +587,7 @@ set_rcvbuf:
 		break;
 
 	case SO_RCVBUFFORCE:
-		if (!capable(CAP_NET_ADMIN)) {
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
@@ -609,7 +610,8 @@ set_rcvbuf:
 		break;
 
 	case SO_PRIORITY:
-		if ((val >= 0 && val <= 6) || capable(CAP_NET_ADMIN))
+		if ((val >= 0 && val <= 6) ||
+		     ns_capable(net->user_ns, CAP_NET_ADMIN))
 			sk->sk_priority = val;
 		else
 			ret = -EPERM;
@@ -726,7 +728,7 @@ set_rcvbuf:
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!capable(CAP_NET_ADMIN))
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			ret = -EPERM;
 		else
 			sk->sk_mark = val;
-- 
1.7.4.1

