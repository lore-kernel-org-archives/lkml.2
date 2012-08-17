Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030783Ab2HQDaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:30:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46832 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030678Ab2HQD1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:07 -0400
Message-Id: <20120817030248.728449300@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Ruan Zhijie <ruanzhijie@hotmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 31/37] tun: dont zeroize sock->file on detach
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/tun.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 926d4db..3a16d4f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -187,7 +187,6 @@ static void __tun_detach(struct tun_struct *tun)
 	netif_tx_lock_bh(tun->dev);
 	netif_carrier_off(tun->dev);
 	tun->tfile = NULL;
-	tun->socket.file = NULL;
 	netif_tx_unlock_bh(tun->dev);
 
 	/* Drop read queue */


