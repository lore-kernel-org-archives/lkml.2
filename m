Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2CLM77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:59:59 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23283 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab2CLM74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:59:56 -0400
Subject: [PATCH v3] tun: don't hold network namespace by tun sockets
To: davem@davemloft.net
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: xemul@parallels.com, ebiederm@aristanetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com, devel@openvz.org
Date: Mon, 12 Mar 2012 16:59:41 +0400
Message-ID: <20120312125833.24166.72610.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3: added previously removed sock_put() to the tun_release() callback, because
sk_release_kernel() doesn't drop the socket reference.

v2: sk_release_kernel() used for socket release. Dummy tun_release() is
required for sk_release_kernel() ---> sock_release() ---> sock->ops->release()
call.

TUN was designed to destroy it's socket on network namesapce shutdown. But this
will never happen for persistent device, because it's socket holds network
namespace.
This patch removes of holding network namespace by TUN socket and replaces it
by creating socket in init_net and then changing it's net it to desired one. On
shutdown socket is moved back to init_net prior to final put.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 drivers/net/tun.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2c5d349..74d7f76 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -359,7 +359,7 @@ static void tun_free_netdev(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
-	sock_put(tun->socket.sk);
+	sk_release_kernel(tun->socket.sk);
 }
 
 /* Net device open. */
@@ -980,10 +980,18 @@ static int tun_recvmsg(struct kiocb *iocb, struct socket *sock,
 	return ret;
 }
 
+static int tun_release(struct socket *sock)
+{
+	if (sock->sk)
+		sock_put(sock->sk);
+	return 0;
+}
+
 /* Ops structure to mimic raw sockets with tun */
 static const struct proto_ops tun_socket_ops = {
 	.sendmsg = tun_sendmsg,
 	.recvmsg = tun_recvmsg,
+	.release = tun_release,
 };
 
 static struct proto tun_proto = {
@@ -1110,10 +1118,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun->vnet_hdr_sz = sizeof(struct virtio_net_hdr);
 
 		err = -ENOMEM;
-		sk = sk_alloc(net, AF_UNSPEC, GFP_KERNEL, &tun_proto);
+		sk = sk_alloc(&init_net, AF_UNSPEC, GFP_KERNEL, &tun_proto);
 		if (!sk)
 			goto err_free_dev;
 
+		sk_change_net(sk, net);
 		tun->socket.wq = &tun->wq;
 		init_waitqueue_head(&tun->wq.wait);
 		tun->socket.ops = &tun_socket_ops;
@@ -1174,7 +1183,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 	return 0;
 
  err_free_sk:
-	sock_put(sk);
+	tun_free_netdev(dev);
  err_free_dev:
 	free_netdev(dev);
  failed:

