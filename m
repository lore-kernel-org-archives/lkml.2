Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab1ESSIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50783 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933997Ab1ESSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:42 -0400
X-Sasl-enc: CnC7p9hQ4onbNq0R2PVJQHwdFJOucGp4aKTph7bQrI4r 1305828521
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180557.860613739@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [37/71] net: dev_close() should check IFF_UP
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit e14a599335427f81bbb0008963e59aa9c6449dce upstream.

Commit 443457242beb (factorize sync-rcu call in
unregister_netdevice_many) mistakenly removed one test from dev_close()

Following actions trigger a BUG :

modprobe bonding
modprobe dummy
ifconfig bond0 up
ifenslave bond0 dummy0
rmmod dummy

dev_close() must not close a non IFF_UP device.

With help from Frank Blaschka and Einar EL Lueck

Reported-by: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Reported-by: Einar EL Lueck <ELELUECK@de.ibm.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1332,11 +1332,13 @@ int dev_close_many(struct list_head *hea
  */
 int dev_close(struct net_device *dev)
 {
-	LIST_HEAD(single);
+	if (dev->flags & IFF_UP) {
+		LIST_HEAD(single);
 
-	list_add(&dev->unreg_list, &single);
-	dev_close_many(&single);
-	list_del(&single);
+		list_add(&dev->unreg_list, &single);
+		dev_close_many(&single);
+		list_del(&single);
+	}
 	return 0;
 }
 EXPORT_SYMBOL(dev_close);


