Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab2FGEZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:25:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547Ab2FGEZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:25:04 -0400
Message-Id: <20120607041402.910569680@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:31 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        James Chapman <jchapman@katalix.com>
Subject: [ 33/47] l2tp: fix oops in L2TP IP sockets for connect() AF_UNSPEC case
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: James Chapman <jchapman@katalix.com>

[ Upstream commit c51ce49735c183ef2592db70f918ee698716276b ]

An application may call connect() to disconnect a socket using an
address with family AF_UNSPEC. The L2TP IP sockets were not handling
this case when the socket is not bound and an attempt to connect()
using AF_UNSPEC in such cases would result in an oops. This patch
addresses the problem by protecting the sk_prot->disconnect() call
against trying to unhash the socket before it is bound.

The patch also adds more checks that the sockaddr supplied to bind()
and connect() calls is valid.

 RIP: 0010:[<ffffffff82e133b0>]  [<ffffffff82e133b0>] inet_unhash+0x50/0xd0
 RSP: 0018:ffff88001989be28  EFLAGS: 00010293
 Stack:
  ffff8800407a8000 0000000000000000 ffff88001989be78 ffffffff82e3a249
  ffffffff82e3a050 ffff88001989bec8 ffff88001989be88 ffff8800407a8000
  0000000000000010 ffff88001989bec8 ffff88001989bea8 ffffffff82e42639
 Call Trace:
 [<ffffffff82e3a249>] udp_disconnect+0x1f9/0x290
 [<ffffffff82e42639>] inet_dgram_connect+0x29/0x80
 [<ffffffff82d012fc>] sys_connect+0x9c/0x100

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -251,9 +251,16 @@ static int l2tp_ip_bind(struct sock *sk,
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct sockaddr_l2tpip *addr = (struct sockaddr_l2tpip *) uaddr;
-	int ret = -EINVAL;
+	int ret;
 	int chk_addr_ret;
 
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		return -EINVAL;
+	if (addr_len < sizeof(struct sockaddr_l2tpip))
+		return -EINVAL;
+	if (addr->l2tp_family != AF_INET)
+		return -EINVAL;
+
 	ret = -EADDRINUSE;
 	read_lock_bh(&l2tp_ip_lock);
 	if (__l2tp_ip_bind_lookup(&init_net, addr->l2tp_addr.s_addr, sk->sk_bound_dev_if, addr->l2tp_conn_id))
@@ -283,6 +290,8 @@ static int l2tp_ip_bind(struct sock *sk,
 	sk_del_node_init(sk);
 	write_unlock_bh(&l2tp_ip_lock);
 	ret = 0;
+	sock_reset_flag(sk, SOCK_ZAPPED);
+
 out:
 	release_sock(sk);
 
@@ -303,13 +312,14 @@ static int l2tp_ip_connect(struct sock *
 	__be32 saddr;
 	int oif, rc;
 
-	rc = -EINVAL;
+	if (sock_flag(sk, SOCK_ZAPPED)) /* Must bind first - autobinding does not work */
+		return -EINVAL;
+
 	if (addr_len < sizeof(*lsa))
-		goto out;
+		return -EINVAL;
 
-	rc = -EAFNOSUPPORT;
 	if (lsa->l2tp_family != AF_INET)
-		goto out;
+		return -EAFNOSUPPORT;
 
 	lock_sock(sk);
 
@@ -363,6 +373,14 @@ out:
 	return rc;
 }
 
+static int l2tp_ip_disconnect(struct sock *sk, int flags)
+{
+	if (sock_flag(sk, SOCK_ZAPPED))
+		return 0;
+
+	return udp_disconnect(sk, flags);
+}
+
 static int l2tp_ip_getname(struct socket *sock, struct sockaddr *uaddr,
 			   int *uaddr_len, int peer)
 {
@@ -591,7 +609,7 @@ static struct proto l2tp_ip_prot = {
 	.close		   = l2tp_ip_close,
 	.bind		   = l2tp_ip_bind,
 	.connect	   = l2tp_ip_connect,
-	.disconnect	   = udp_disconnect,
+	.disconnect	   = l2tp_ip_disconnect,
 	.ioctl		   = udp_ioctl,
 	.destroy	   = l2tp_ip_destroy_sock,
 	.setsockopt	   = ip_setsockopt,


