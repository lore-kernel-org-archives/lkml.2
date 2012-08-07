Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2HGW3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab2HGW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 045/122] tun: fix a crash bug and a memory leak
Date: Tue,  7 Aug 2012 15:25:33 -0700
Message-Id: <20120807221952.249338892@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

commit b09e786bd1dd66418b69348cb110f3a64764626a upstream.

This patch fixes a crash
tun_chr_close -> netdev_run_todo -> tun_free_netdev -> sk_release_kernel ->
sock_release -> iput(SOCK_INODE(sock))
introduced by commit 1ab5ecb90cb6a3df1476e052f76a6e8f6511cb3d

The problem is that this socket is embedded in struct tun_struct, it has
no inode, iput is called on invalid inode, which modifies invalid memory
and optionally causes a crash.

sock_release also decrements sockets_in_use, this causes a bug that
"sockets: used" field in /proc/*/net/sockstat keeps on decreasing when
creating and closing tun devices.

This patch introduces a flag SOCK_EXTERNALLY_ALLOCATED that instructs
sock_release to not free the inode and not decrement sockets_in_use,
fixing both memory corruption and sockets_in_use underflow.

It should be backported to 3.3 an 3.4 stabke.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/tun.c   |    3 +++
 include/linux/net.h |    1 +
 net/socket.c        |    3 +++
 3 files changed, 7 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -358,6 +358,8 @@ static void tun_free_netdev(struct net_d
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
+	BUG_ON(!test_bit(SOCK_EXTERNALLY_ALLOCATED, &tun->socket.flags));
+
 	sk_release_kernel(tun->socket.sk);
 }
 
@@ -1115,6 +1117,7 @@ static int tun_set_iff(struct net *net,
 		tun->flags = flags;
 		tun->txflt.count = 0;
 		tun->vnet_hdr_sz = sizeof(struct virtio_net_hdr);
+		set_bit(SOCK_EXTERNALLY_ALLOCATED, &tun->socket.flags);
 
 		err = -ENOMEM;
 		sk = sk_alloc(&init_net, AF_UNSPEC, GFP_KERNEL, &tun_proto);
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -72,6 +72,7 @@ struct net;
 #define SOCK_NOSPACE		2
 #define SOCK_PASSCRED		3
 #define SOCK_PASSSEC		4
+#define SOCK_EXTERNALLY_ALLOCATED 5
 
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
--- a/net/socket.c
+++ b/net/socket.c
@@ -522,6 +522,9 @@ void sock_release(struct socket *sock)
 	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
 		printk(KERN_ERR "sock_release: fasync list not empty!\n");
 
+	if (test_bit(SOCK_EXTERNALLY_ALLOCATED, &sock->flags))
+		return;
+
 	this_cpu_sub(sockets_in_use, 1);
 	if (!sock->file) {
 		iput(SOCK_INODE(sock));


