Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab1KCBeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:34:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab1KCBeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:50 2011
Message-Id: <20111102221450.714196442@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stratos Psomadakis <psomas@gentoo.org>,
        Wolfgang Walter <wolfgang.walter@stwm.de>,
        Tim Gardner <tim.gardner@canonical.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: [007/107] Fix broken backport for IPv6 tunnels
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stratos Psomadakis <psomas@gentoo.org>

Fix broken backport for IPv6 tunnels in 2.6.32-longterm kernels.

upstream commit d5aa407f59f5b83d2c50ec88f5bf56d40f1f8978 ("tunnels: fix
netns vs proto registration ordering") , which was included in
2.6.32.44-longterm, was not backported correctly, and results in a NULL
pointer dereference in ip6_tunnel.c for longterm kernels >=2.6.32.44

Use [un]register_pernet_gen_device() instead of
[un]register_pernet_device() to fix it.

Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/ip6_tunnel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1466,7 +1466,7 @@ static int __init ip6_tunnel_init(void)
 {
 	int  err;
 
-	err = register_pernet_device(&ip6_tnl_net_ops);
+	err = register_pernet_gen_device(&ip6_tnl_net_id, &ip6_tnl_net_ops);
 	if (err < 0)
 		goto out_pernet;
 
@@ -1487,7 +1487,7 @@ static int __init ip6_tunnel_init(void)
 out_ip6ip6:
 	xfrm6_tunnel_deregister(&ip4ip6_handler, AF_INET);
 out_ip4ip6:
-	unregister_pernet_device(&ip6_tnl_net_ops);
+	unregister_pernet_gen_device(ip6_tnl_net_id, &ip6_tnl_net_ops);
 out_pernet:
 	return err;
 }


