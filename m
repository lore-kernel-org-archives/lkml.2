Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0C2G7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:59:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59790 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0C2G7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hJvKqYeJq8AxyiUD7RLx3lBM4cq+/KN4Vgk+zyzUJXDoSQbZQTVy+dkLwRW30RFAZO
         KPqeKH0uX74apk6u4DrHXwmP42gHJJ7JY7lK/V3Bl6stqGL/fEEGRbHEH+FVbWbwKMcX
         jgdvtfdkvxxZUBRb7xElVkcDxFWrjyfJw84tY=
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Herbert <therbert@google.com>
In-Reply-To: <1269845561.2164.1.camel@edumazet-laptop>
References: <20100329174300.512d83a8.sfr@canb.auug.org.au>
	 <1269845561.2164.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 08:59:30 +0200
Message-ID: <1269845970.2164.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Le lundi 29 mars 2010 à 08:52 +0200, Eric Dumazet a écrit :
> Le lundi 29 mars 2010 à 17:43 +1100, Stephen Rothwell a écrit :
> > Hi Dave,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > ppc44x_defconfig) failed like this:
> > 
> > net/core/net-sysfs.c:476: warning: 'struct netdev_rx_queue' declared inside parameter list
> > net/core/net-sysfs.c:476: warning: its scope is only this definition or declaration, which is probably not what you want
> > net/core/net-sysfs.c:478: warning: 'struct netdev_rx_queue' declared inside parameter list
> > net/core/net-sysfs.c: In function 'rx_queue_attr_show':
> > net/core/net-sysfs.c:489: error: dereferencing pointer to incomplete type
> > net/core/net-sysfs.c:489: warning: type defaults to 'int' in declaration of '__mptr'
> > net/core/net-sysfs.c:489: warning: initialization from incompatible pointer type
> > net/core/net-sysfs.c:489: error: invalid use of undefined type 'struct netdev_rx_queue'
> > net/core/net-sysfs.c:494: warning: passing argument 1 of 'attribute->show' from incompatible pointer type
> > net/core/net-sysfs.c:494: note: expected 'struct netdev_rx_queue *' but argument is of type 'struct netdev_rx_queue *'
> > 
> > (and many more)
> > 
> > Caused by commit 0a9627f2649a02bea165cfd529d7bcb625c2fcad ("rps: Receive
> > Packet Steering") from the net tree.  struct netdev_rx_queue is protected by
> > CONFIG_RPS in netdevice.h, but uses are not so protected in net-sysfs.c.
> > 
> > I applied the following patch for today:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 29 Mar 2010 17:27:55 +1100
> > Subject: [PATCH] rps: fix net-sysfs build for !CONFIG_RPS
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Oops, a cleaner patch would be :

[PATCH] rps: fix net-sysfs build for !CONFIG_RPS

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f6b6bfe..2144a7f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -466,6 +466,7 @@ static struct attribute_group wireless_group = {
 };
 #endif
 
+#ifdef CONFIG_RPS
 /*
  * RX queue sysfs structures and functions.
  */
@@ -675,7 +676,7 @@ static void rx_queue_remove_kobjects(struct net_device *net)
 		kobject_put(&net->_rx[i].kobj);
 	kset_unregister(net->queues_kset);
 }
-
+#endif /* CONFIG_RPS */
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_HOTPLUG
@@ -739,7 +740,7 @@ void netdev_unregister_kobject(struct net_device * net)
 	if (!net_eq(dev_net(net), &init_net))
 		return;
 
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_RPS
 	rx_queue_remove_kobjects(net);
 #endif
 
@@ -782,7 +783,7 @@ int netdev_register_kobject(struct net_device *net)
 	if (error)
 		return error;
 
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_RPS
 	error = rx_queue_register_kobjects(net);
 	if (error) {
 		device_del(dev);


