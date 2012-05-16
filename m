Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab2EPVp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2EPVpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:45:55 -0400
Date: Thu, 17 May 2012 00:15:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: [PATCHv2-RFC 1/6] skbuff: add an api to orphan frags
Message-ID: <11324c9708a8ca6b4f76b7092ab730b83c65575c.1337202879.git.mst@redhat.com>
References: <cover.1337202879.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337202879.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many places do
       if ((skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY))
		skb_copy_ubufs(skb, gfp_mask);
to copy and invoke frag destructors if necessary.
Add an inline helper for this.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/skbuff.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bb47314..2c5c69d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1665,6 +1665,22 @@ static inline void skb_orphan(struct sk_buff *skb)
 }
 
 /**
+ *	skb_orphan_frags - orphan the frags contained in a buffer
+ *	@skb: buffer to orphan frags from
+ *	@gfp_mask: allocation mask for replacement pages
+ *
+ *	For each frag in the SKB which needs a destructor (i.e. has an
+ *	owner) create a copy of that frag and release the original
+ *	page by calling the destructor.
+ */
+static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
+{
+	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY)))
+		return 0;
+	return skb_copy_ubufs(skb, gfp_mask);
+}
+
+/**
  *	__skb_queue_purge - empty a list
  *	@list: list to empty
  *
-- 
MST

