Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2JZAFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:05:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:52497 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2JZAFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ramesh Nagappa <ramesh.nagappa@ericsson.com>,
        Shawn Lu <shawn.lu@ericsson.com>,
        Robert Coulson <robert.coulson@ericsson.com>,
        Billie Alsup <billie.alsup@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/31] net: Fix skb_under_panic oops in neigh_resolve_output
Date: Thu, 25 Oct 2012 17:04:26 -0700
Message-Id: <20121026000216.906164171@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "ramesh.nagappa@gmail.com" <ramesh.nagappa@gmail.com>

[ Upstream commit e1f165032c8bade3a6bdf546f8faf61fda4dd01c ]

The retry loop in neigh_resolve_output() and neigh_connected_output()
call dev_hard_header() with out reseting the skb to network_header.
This causes the retry to fail with skb_under_panic. The fix is to
reset the network_header within the retry loop.

Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Reviewed-by: Shawn Lu <shawn.lu@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1313,8 +1313,6 @@ int neigh_resolve_output(struct sk_buff
 	if (!dst)
 		goto discard;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	if (!neigh_event_send(neigh, skb)) {
 		int err;
 		struct net_device *dev = neigh->dev;
@@ -1326,6 +1324,7 @@ int neigh_resolve_output(struct sk_buff
 			neigh_hh_init(neigh, dst, dst->ops->protocol);
 
 		do {
+			__skb_pull(skb, skb_network_offset(skb));
 			seq = read_seqbegin(&neigh->ha_lock);
 			err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 					      neigh->ha, NULL, skb->len);
@@ -1358,9 +1357,8 @@ int neigh_connected_output(struct sk_buf
 	struct net_device *dev = neigh->dev;
 	unsigned int seq;
 
-	__skb_pull(skb, skb_network_offset(skb));
-
 	do {
+		__skb_pull(skb, skb_network_offset(skb));
 		seq = read_seqbegin(&neigh->ha_lock);
 		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 				      neigh->ha, NULL, skb->len);


