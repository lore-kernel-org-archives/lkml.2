Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab0GTCUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 22:20:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36359 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab0GTCUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 22:20:36 -0400
Date: Tue, 20 Jul 2010 12:20:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20100720122032.88e0fcd9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/vhost/net.c between commit
1680e9063ea28099a1efa8ca11cee069cc7a9bc3 ("vhost-net: avoid flush under
lock") from the net-current tree and commit
dd1f4078f0d2de74a308f00a2dffbd550cfba59f ("vhost-net: minor cleanup")
from the net tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/vhost/net.c
index d219070,107af9e..0000000
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@@ -527,15 -527,12 +527,14 @@@ static long vhost_net_set_backend(struc
  
  	/* start polling new socket */
  	oldsock = vq->private_data;
- 	if (sock == oldsock)
- 		goto done;
+ 	if (sock != oldsock){
+                 vhost_net_disable_vq(n, vq);
+                 rcu_assign_pointer(vq->private_data, sock);
+                 vhost_net_enable_vq(n, vq);
+ 	}
  
- 	vhost_net_disable_vq(n, vq);
- 	rcu_assign_pointer(vq->private_data, sock);
- 	vhost_net_enable_vq(n, vq);
- done:
 +	mutex_unlock(&vq->mutex);
 +
  	if (oldsock) {
  		vhost_net_flush_vq(n, index);
  		fput(oldsock->file);
