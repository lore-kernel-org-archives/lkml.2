Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1AEXsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:48:32 -0500
Received: from kroah.org ([198.145.64.141]:41038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1AEXpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:15 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:27 2011
Message-Id: <20110105230326.974515123@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Vagin <avagin@openvz.org>
Subject: [35/49] net: release dst entry while cache-hot for GSO case too
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Krishna Kumar <krkumar2@in.ibm.com>

commit 068a2de57ddf4f472e32e7af868613c574ad1d88 upstream.

Non-GSO code drops dst entry for performance reasons, but
the same is missing for GSO code. Drop dst while cache-hot
for GSO case too.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1747,6 +1747,14 @@ gso:
 
 		skb->next = nskb->next;
 		nskb->next = NULL;
+
+		/*
+		 * If device doesnt need nskb->dst, release it right now while
+		 * its hot in this cpu cache
+		 */
+		if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
+			skb_dst_drop(nskb);
+
 		rc = ops->ndo_start_xmit(nskb, dev);
 		if (unlikely(rc != NETDEV_TX_OK)) {
 			nskb->next = skb->next;


