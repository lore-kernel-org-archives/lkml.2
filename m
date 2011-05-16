Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1EPTcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:32:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52158 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1EPTb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:31:58 -0400
Subject: [PATCH V5 3/6 net-next] skbuff: Add userspace zero-copy buffers in
 skb
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 12:31:54 -0700
Message-ID: <1305574314.3456.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds userspace buffers support in skb shared info. A new 
struct skb_ubuf_info is needed to maintain the userspace buffers
argument and index, a callback is used to notify userspace to release
the buffers once lower device has done DMA (Last reference to that skb
has gone).

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/linux/skbuff.h |   26 ++++++++++++++++++++++++++
 net/core/skbuff.c      |   13 +++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 79aafbb..40faffe 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -189,6 +189,18 @@ enum {
 	SKBTX_DRV_NEEDS_SK_REF = 1 << 3,
 };
 
+/*
+ * The callback notifies userspace to release buffers when skb DMA is
done in
+ * lower device, the skb last reference should be 0 when calling this.
+ * The desc is used to track userspace buffer index.
+ */
+struct skb_ubuf_info {
+	/* support buffers allocation from userspace */
+	void		(*callback)(struct sk_buff *);
+	void		*arg;
+	size_t		desc;
+};
+
 /* This data is invariant across clones and lives at
  * the end of the header data, ie. at skb->end.
  */
@@ -211,6 +223,10 @@ struct skb_shared_info {
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
 	void *		destructor_arg;
+
+	/* DMA mapping from/to userspace buffers */
+	struct skb_ubuf_info ubuf;
+
 	/* must be last field, see pskb_expand_head() */
 	skb_frag_t	frags[MAX_SKB_FRAGS];
 };
@@ -2261,5 +2277,15 @@ static inline void
skb_checksum_none_assert(struct sk_buff *skb)
 }
 
 bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off);
+
+/*
+ *	skb_ubuf - is the buffer from userspace
+ *	@skb: buffer to check
+ */
+static inline int skb_ubuf(const struct sk_buff *skb)
+{
+	return (skb_shinfo(skb)->ubuf.callback != NULL);
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7ebeed0..9cbd3fc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -210,6 +210,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t
gfp_mask,
 	shinfo = skb_shinfo(skb);
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
+	shinfo->ubuf.callback = NULL;
+	shinfo->ubuf.arg = NULL;
 	kmemcheck_annotate_variable(shinfo->destructor_arg);
 
 	if (fclone) {
@@ -328,6 +330,14 @@ static void skb_release_data(struct sk_buff *skb)
 				put_page(skb_shinfo(skb)->frags[i].page);
 		}
 
+		/*
+		 * if skb buf is from userspace, we need to notify the caller
+		 * the lower device DMA has done;
+		 */
+		if (skb_shinfo(skb)->ubuf.callback) {
+			skb_shinfo(skb)->ubuf.callback(skb);
+			skb_shinfo(skb)->ubuf.callback = NULL;
+		}
 		if (skb_has_frag_list(skb))
 			skb_drop_fraglist(skb);
 
@@ -480,6 +490,9 @@ bool skb_recycle_check(struct sk_buff *skb, int
skb_size)
 	if (irqs_disabled())
 		return false;
 
+	if (skb_ubuf(skb))
+		return false;
+
 	if (skb_is_nonlinear(skb) || skb->fclone != SKB_FCLONE_UNAVAILABLE)
 		return false;
 


