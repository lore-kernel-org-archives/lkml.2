Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162460Ab1FAIu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:50:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162428Ab1FAIUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:20:24 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:25 2011
Message-Id: <20110601081125.103643957@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:30 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [060/165] bridge: initialize fake_rtable metrics
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1254
Lines: 40


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 33eb9873a283a2076f2b5628813d5365ca420ea9 ]

bridge netfilter code uses a fake_rtable, and we must init its _metric
field or risk NULL dereference later.

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=35672

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_netfilter.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -117,6 +117,10 @@ static struct dst_ops fake_dst_ops = {
  * ipt_REJECT needs it.  Future netfilter modules might
  * require us to fill additional fields.
  */
+static const u32 br_dst_default_metrics[RTAX_MAX] = {
+	[RTAX_MTU - 1] = 1500,
+};
+
 void br_netfilter_rtable_init(struct net_bridge *br)
 {
 	struct rtable *rt = &br->fake_rtable;
@@ -124,7 +128,7 @@ void br_netfilter_rtable_init(struct net
 	atomic_set(&rt->dst.__refcnt, 1);
 	rt->dst.dev = br->dev;
 	rt->dst.path = &rt->dst;
-	dst_metric_set(&rt->dst, RTAX_MTU, 1500);
+	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
 	rt->dst.flags	= DST_NOXFRM;
 	rt->dst.ops = &fake_dst_ops;
 }


