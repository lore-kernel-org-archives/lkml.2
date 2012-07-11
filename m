Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2GKLsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:48:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48154 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab2GKLsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:48:52 -0400
Subject: [RFC PATCH] tun: don't zeroize sock->file on detach
To: davem@davemloft.net
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: netdev@vger.kernel.org, ruanzhijie@hotmail.com,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 15:48:20 +0400
Message-ID: <20120711114753.24395.53193.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for bug, introduced in 3.4 kernel by commit
1ab5ecb90cb6a3df1476e052f76a6e8f6511cb3d, which, among other things, replaced
simple sock_put() by sk_release_kernel(). Below is sequence, which leads to
oops for non-persistent devices:

tun_chr_close()
tun_detach()				<== tun->socket.file = NULL
tun_free_netdev()
sk_release_sock()
sock_release(sock->file == NULL)
iput(SOCK_INODE(sock))			<== dereference on NULL pointer

This patch just removes zeroing of socket's file from __tun_detach().
sock_release() will do this.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 drivers/net/tun.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 987aeef..c1639f3 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -185,7 +185,6 @@ static void __tun_detach(struct tun_struct *tun)
 	netif_tx_lock_bh(tun->dev);
 	netif_carrier_off(tun->dev);
 	tun->tfile = NULL;
-	tun->socket.file = NULL;
 	netif_tx_unlock_bh(tun->dev);
 
 	/* Drop read queue */

