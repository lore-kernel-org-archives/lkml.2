Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab2KVVmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:42:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:49610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2KVSk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julien Tinnes <jln@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/83] tcp: handle tcp_net_metrics_init() order-5 memory allocation failures
Date: Wed, 21 Nov 2012 16:42:22 -0800
Message-Id: <20121122004219.159202340@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 976a702ac9eeacea09e588456ab165dc06f9ee83 ]

order-5 allocations can fail with current kernels, we should
try vmalloc() as well.

Reported-by: Julien Tinnes <jln@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_metrics.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -1,13 +1,13 @@
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
-#include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/cache.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/tcp.h>
 #include <linux/hash.h>
+#include <linux/vmalloc.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/net_namespace.h>
@@ -722,7 +722,10 @@ static int __net_init tcp_net_metrics_in
 	net->ipv4.tcp_metrics_hash_log = order_base_2(slots);
 	size = sizeof(struct tcpm_hash_bucket) << net->ipv4.tcp_metrics_hash_log;
 
-	net->ipv4.tcp_metrics_hash = kzalloc(size, GFP_KERNEL);
+	net->ipv4.tcp_metrics_hash = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!net->ipv4.tcp_metrics_hash)
+		net->ipv4.tcp_metrics_hash = vzalloc(size);
+
 	if (!net->ipv4.tcp_metrics_hash)
 		return -ENOMEM;
 
@@ -743,7 +746,10 @@ static void __net_exit tcp_net_metrics_e
 			tm = next;
 		}
 	}
-	kfree(net->ipv4.tcp_metrics_hash);
+	if (is_vmalloc_addr(net->ipv4.tcp_metrics_hash))
+		vfree(net->ipv4.tcp_metrics_hash);
+	else
+		kfree(net->ipv4.tcp_metrics_hash);
 }
 
 static __net_initdata struct pernet_operations tcp_net_metrics_ops = {


