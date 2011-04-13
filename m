Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1DMQNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:45 -0400
Received: from kroah.org ([198.145.64.141]:53084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab1DMQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:49 2011
Message-Id: <20110413161049.528295657@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [66/71] econet: Fix crash in aun_incoming().
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -844,9 +844,13 @@ static void aun_incoming(struct sk_buff
 {
 	struct iphdr *ip = ip_hdr(skb);
 	unsigned char stn = ntohl(ip->saddr) & 0xff;
+	struct dst_entry *dst = skb_dst(skb);
+	struct ec_device *edev = NULL;
 	struct sock *sk;
 	struct sk_buff *newskb;
-	struct ec_device *edev = skb->dev->ec_ptr;
+
+	if (dst)
+		edev = dst->dev->ec_ptr;
 
 	if (! edev)
 		goto bad;


