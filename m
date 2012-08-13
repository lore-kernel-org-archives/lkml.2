Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2HMUZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2HMUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ruan Zhijie <ruanzhijie@hotmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 76/82] tun: dont zeroize sock->file on detach
Date: Mon, 13 Aug 2012 13:19:52 -0700
Message-Id: <20120813201753.106031113@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 66d1b9263a371abd15806c53f486f0645ef31a8f upstream.

This is a fix for bug, introduced in 3.4 kernel by commit
1ab5ecb90cb6a3df1476e052f76a6e8f6511cb3d ("tun: don't hold network
namespace by tun sockets"), which, among other things, replaced simple
sock_put() by sk_release_kernel(). Below is sequence, which leads to
oops for non-persistent devices:

tun_chr_close()
tun_detach()				<== tun->socket.file = NULL
tun_free_netdev()
sk_release_sock()
sock_release(sock->file == NULL)
iput(SOCK_INODE(sock))			<== dereference on NULL pointer

This patch just removes zeroing of socket's file from __tun_detach().
sock_release() will do this.

Reported-by: Ruan Zhijie <ruanzhijie@hotmail.com>
Tested-by: Ruan Zhijie <ruanzhijie@hotmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/tun.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -185,7 +185,6 @@ static void __tun_detach(struct tun_stru
 	netif_tx_lock_bh(tun->dev);
 	netif_carrier_off(tun->dev);
 	tun->tfile = NULL;
-	tun->socket.file = NULL;
 	netif_tx_unlock_bh(tun->dev);
 
 	/* Drop read queue */


