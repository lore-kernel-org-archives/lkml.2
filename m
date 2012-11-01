Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264Ab2KATQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762070Ab2KATOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:14:06 -0400
Date: Thu, 1 Nov 2012 21:16:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 net-next 1/8] skb: report completion status for zero copy
 skbs
Message-ID: <725e0613989e6bb75ff5b4b550283e4403c1809b.1351797353.git.mst@redhat.com>
References: <cover.1351797353.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1351797353.git.mst@redhat.com>
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if skb is marked for zero copy, net core might still decide
to copy it later which is somewhat slower than a copy in user context:
besides copying the data we need to pin/unpin the pages.

Add a parameter reporting such cases through zero copy callback:
if this happens a lot, device can take this into account
and switch to copying in user context.

This patch updates all users but ignores the passed value for now:
it will be used by follow-up patches.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c  | 2 +-
 drivers/vhost/vhost.h  | 2 +-
 include/linux/skbuff.h | 4 +++-
 net/core/skbuff.c      | 4 ++--
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 99ac2cb..73d08db 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1600,7 +1600,7 @@ void vhost_ubuf_put_and_wait(struct vhost_ubuf_ref *ubufs)
 	kfree(ubufs);
 }
 
-void vhost_zerocopy_callback(struct ubuf_info *ubuf)
+void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool status)
 {
 	struct vhost_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1125af3..2de4ce2 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -191,7 +191,7 @@ bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len);
-void vhost_zerocopy_callback(struct ubuf_info *);
+void vhost_zerocopy_callback(struct ubuf_info *, bool);
 int vhost_zerocopy_signal_used(struct vhost_virtqueue *vq);
 
 #define vq_err(vq, fmt, ...) do {                                  \
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a2a0bdb..e5eae5b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -235,11 +235,13 @@ enum {
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
  * lower device, the skb last reference should be 0 when calling this.
+ * The zerocopy_success argument is true if zero copy transmit occurred,
+ * false on data copy or out of memory error caused by data copy attempt.
  * The ctx field is used to track device context.
  * The desc field is used to track userspace buffer index.
  */
 struct ubuf_info {
-	void (*callback)(struct ubuf_info *);
+	void (*callback)(struct ubuf_info *, bool zerocopy_success);
 	void *ctx;
 	unsigned long desc;
 };
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6e04b1f..4abdf71 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -519,7 +519,7 @@ static void skb_release_data(struct sk_buff *skb)
 
 			uarg = skb_shinfo(skb)->destructor_arg;
 			if (uarg->callback)
-				uarg->callback(uarg);
+				uarg->callback(uarg, true);
 		}
 
 		if (skb_has_frag_list(skb))
@@ -797,7 +797,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	for (i = 0; i < num_frags; i++)
 		skb_frag_unref(skb, i);
 
-	uarg->callback(uarg);
+	uarg->callback(uarg, false);
 
 	/* skb frags point to kernel buffers */
 	for (i = num_frags - 1; i >= 0; i--) {
-- 
MST

