Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2JSCrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:47:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:51495 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab2JSCrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: [ 37/62] netfilter: ipset: timeout fixing bug broke SET target special timeout value
Date: Thu, 18 Oct 2012 19:45:05 -0700
Message-Id: <20121019024301.975608518@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit a73f89a61f92b364f0b4a3be412b5b70553afc23 upstream.

The patch "127f559 netfilter: ipset: fix timeout value overflow bug"
broke the SET target when no timeout was specified.

Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_set.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -16,6 +16,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_set.h>
+#include <linux/netfilter/ipset/ip_set_timeout.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -310,7 +311,8 @@ set_target_v2(struct sk_buff *skb, const
 		info->del_set.flags, 0, UINT_MAX);
 
 	/* Normalize to fit into jiffies */
-	if (add_opt.timeout > UINT_MAX/MSEC_PER_SEC)
+	if (add_opt.timeout != IPSET_NO_TIMEOUT &&
+	    add_opt.timeout > UINT_MAX/MSEC_PER_SEC)
 		add_opt.timeout = UINT_MAX/MSEC_PER_SEC;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);


