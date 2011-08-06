Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab1HFAQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:16:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1HFAMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:16 2011
Message-Id: <20110806000415.930570169@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:04:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [43/50] gre: fix netns vs proto registration ordering
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit c2892f02712e9516d72841d5c019ed6916329794 upstream.

GRE protocol receive hook can be called right after protocol addition is done.
If netns stuff is not yet initialized, we're going to oops in
net_generic().

This is remotely oopsable if ip_gre is compiled as module and packet
comes at unfortunate moment of module loading.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_gre.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1667,14 +1667,15 @@ static int __init ipgre_init(void)
 
 	printk(KERN_INFO "GRE over IPv4 tunneling driver\n");
 
-	if (inet_add_protocol(&ipgre_protocol, IPPROTO_GRE) < 0) {
-		printk(KERN_INFO "ipgre init: can't add protocol\n");
-		return -EAGAIN;
-	}
-
 	err = register_pernet_device(&ipgre_net_ops);
 	if (err < 0)
-		goto gen_device_failed;
+		return err;
+
+	err = inet_add_protocol(&ipgre_protocol, IPPROTO_GRE);
+	if (err < 0) {
+		printk(KERN_INFO "ipgre init: can't add protocol\n");
+		goto add_proto_failed;
+	}
 
 	err = rtnl_link_register(&ipgre_link_ops);
 	if (err < 0)
@@ -1690,9 +1691,9 @@ out:
 tap_ops_failed:
 	rtnl_link_unregister(&ipgre_link_ops);
 rtnl_link_failed:
-	unregister_pernet_device(&ipgre_net_ops);
-gen_device_failed:
 	inet_del_protocol(&ipgre_protocol, IPPROTO_GRE);
+add_proto_failed:
+	unregister_pernet_device(&ipgre_net_ops);
 	goto out;
 }
 
@@ -1700,9 +1701,9 @@ static void __exit ipgre_fini(void)
 {
 	rtnl_link_unregister(&ipgre_tap_ops);
 	rtnl_link_unregister(&ipgre_link_ops);
-	unregister_pernet_device(&ipgre_net_ops);
 	if (inet_del_protocol(&ipgre_protocol, IPPROTO_GRE) < 0)
 		printk(KERN_INFO "ipgre close: can't remove protocol\n");
+	unregister_pernet_device(&ipgre_net_ops);
 }
 
 module_init(ipgre_init);


