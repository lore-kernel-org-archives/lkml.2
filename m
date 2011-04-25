Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1DYUhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:37:21 -0400
Received: from 1wt.eu ([62.212.114.60]:34501 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab1DYUZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:12 -0400
Message-Id: <20110425200239.771785194@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 156/173] econet: Fix crash in aun_incoming().
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 4e085e76cbe558b79b54cbab772f61185879bc64 upstream.

Unconditional use of skb->dev won't work here,
try to fetch the econet device via skb_dst()->dev
instead.

Suggested by Eric Dumazet.

Reported-by: Nelson Elhage <nelhage@ksplice.com>
Tested-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
[jmm: Slightly adapted for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/econet/af_econet.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/net/econet/af_econet.c
===================================================================
--- longterm-2.6.27.orig/net/econet/af_econet.c	2011-04-25 18:51:48.591279239 +0200
+++ longterm-2.6.27/net/econet/af_econet.c	2011-04-25 18:59:35.943279187 +0200
@@ -845,9 +845,13 @@
 {
 	struct iphdr *ip = ip_hdr(skb);
 	unsigned char stn = ntohl(ip->saddr) & 0xff;
+	struct dst_entry *dst = skb->dst;
+	struct ec_device *edev = NULL;
 	struct sock *sk;
 	struct sk_buff *newskb;
-	struct ec_device *edev = skb->dev->ec_ptr;
+
+	if (dst)
+		edev = dst->dev->ec_ptr;
 
 	if (! edev)
 		goto bad;


