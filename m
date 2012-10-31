Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935378Ab2JaK3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab2JaK2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:28:54 -0400
Date: Wed, 31 Oct 2012 12:31:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 net-next 2/8] skb: api to report errors for zero copy skbs
Message-ID: <cfa9ea5acdaeaed930a92f7733e5fc80a4e935a0.1351679008.git.mst@redhat.com>
References: <cover.1351679008.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1351679008.git.mst@redhat.com>
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Orphaning frags for zero copy skbs needs to allocate data in atomic
context so is has a chance to fail. If it does we currently discard
the skb which is safe, but we don't report anything to the caller,
so it can not recover by e.g. disabling zero copy.

Add an API to free skb reporting such errors: this is used
by tun in case orphaning frags fails.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8bac11b..0644432 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -568,6 +568,7 @@ static inline struct rtable *skb_rtable(const struct sk_buff *skb)
 }
 
 extern void kfree_skb(struct sk_buff *skb);
+extern void skb_tx_error(struct sk_buff *skb, int err);
 extern void consume_skb(struct sk_buff *skb);
 extern void	       __kfree_skb(struct sk_buff *skb);
 extern struct kmem_cache *skbuff_head_cache;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index eb31f6e..2e7a1fd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -635,6 +635,26 @@ void kfree_skb(struct sk_buff *skb)
 EXPORT_SYMBOL(kfree_skb);
 
 /**
+ *	skb_tx_error - report an sk_buff xmit error
+ *	@skb: buffer that triggered an error
+ *
+ *	Report xmit error if a device callback is tracking this skb.
+ *	skb must be freed afterwards.
+ */
+void skb_tx_error(struct sk_buff *skb, int err)
+{
+	if (skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY) {
+		struct ubuf_info *uarg;
+
+		uarg = skb_shinfo(skb)->destructor_arg;
+		if (uarg->callback)
+			uarg->callback(uarg, err);
+		skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
+	}
+}
+EXPORT_SYMBOL(skb_tx_error);
+
+/**
  *	consume_skb - free an skbuff
  *	@skb: buffer to free
  *
-- 
MST

