Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1GEOsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:48:11 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:56353 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab1GEOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:48:07 -0400
X-Greylist: delayed 761 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jul 2011 10:48:07 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=T/SK53jUlQmBmSHxbAWxAEh0i2sxFqoT12OwJIDAp/ulfTb87YU/YtqnU6UdtJ58;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4E13212D.3020005@earthlink.net>
Date: Tue, 05 Jul 2011 10:35:25 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: kernel -2.6.35.13 longterm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79b9e3807f6a9e0145235deeea05c6474f350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is it possible to get the following patches included in the longterm kernel
2.6.35.13?

They let linux behave according to:

"Basic Requirements for IPv6 Customer Edge Routers
    draft-ietf-v6ops-ipv6-cpe-router-09"

From: Thomas Graf
Subject: [PATCH] ipv6: add special mode accept_ra=2 to accept RA while 
configured as router
Date: Friday, September 3, 2010 - 5:59 am

The current IPv6 behavior is to not accept router advertisements while
forwarding, i.e. configured as router.

This does make sense, a router is typically not supposed to be auto
configured. However there are exceptions and we should allow the
current behavior to be overwritten.

Therefore this patch enables the user to overrule the "if forwarding
enabled then don't listen to RAs" rule by setting accept_ra to the
special value of 2.

An alternative would be to ignore the forwarding switch alltogether
and solely accept RAs based on the value of accept_ra. However, I
found that if not intended, accepting RAs as a router can lead to
strange unwanted behavior therefore we it seems wise to only do so
if the user explicitely asks for this behavior.

Signed-off-by: Thomas Graf <tgraf at infradead.org>

Index: net-2.6/net/ipv6/ndisc.c
===================================================================
--- net-2.6.orig/net/ipv6/ndisc.c
+++ net-2.6/net/ipv6/ndisc.c
@@ -1105,6 +1105,18 @@ errout:
       rtnl_set_sk_err(net, RTNLGRP_ND_USEROPT, err);
   }

+static inline int accept_ra(struct inet6_dev *in6_dev)
+{
+    /*
+     * If forwarding is enabled, RA are not accepted unless the special
+     * hybrid mode (accept_ra=2) is enabled.
+     */
+    if (in6_dev->cnf.forwarding && in6_dev->cnf.accept_ra < 2)
+        return 0;
+
+    return in6_dev->cnf.accept_ra;
+}
+
   static void ndisc_router_discovery(struct sk_buff *skb)
   {
       struct ra_msg *ra_msg = (struct ra_msg *)skb_transport_header(skb);
@@ -1158,8 +1170,7 @@ static void ndisc_router_discovery(struc
           return;
       }

-    /* skip route and link configuration on routers */
-    if (in6_dev->cnf.forwarding || !in6_dev->cnf.accept_ra)
+    if (!accept_ra(in6_dev))
           goto skip_linkparms;

   #ifdef CONFIG_IPV6_NDISC_NODETYPE
@@ -1309,8 +1320,7 @@ skip_linkparms:
                    NEIGH_UPDATE_F_ISROUTER);
       }

-    /* skip route and link configuration on routers */
-    if (in6_dev->cnf.forwarding || !in6_dev->cnf.accept_ra)
+    if (!accept_ra(in6_dev))
           goto out;

   #ifdef CONFIG_IPV6_ROUTE_INFO

Similar to accepting router advertisement, the IPv6 stack does not send router
solicitations if forwarding is enabled.

This patch enables this behavior to be overruled by setting forwarding to the
special value 2.

Signed-off-by: Thomas Graf <tgraf at xxxxxxxxxxxxx>

Index: net-2.6/net/ipv6/addrconf.c
===================================================================
--- net-2.6.orig/net/ipv6/addrconf.c
+++ net-2.6/net/ipv6/addrconf.c
@@ -2964,7 +2964,8 @@ static void addrconf_dad_completed(struc
          start sending router solicitations.
        */

-    if (ifp->idev->cnf.forwarding == 0 &&
+    if ((ifp->idev->cnf.forwarding == 0 ||
+         ifp->idev->cnf.forwarding == 2) &&
           ifp->idev->cnf.rtr_solicits > 0 &&
           (dev->flags&IFF_LOOPBACK) == 0 &&
           (ipv6_addr_type(&ifp->addr) & IPV6_ADDR_LINKLOCAL)) {





Thanks for your consideration,
Steve Clark
