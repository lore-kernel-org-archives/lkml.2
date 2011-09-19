Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1ISXIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:08:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61591 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1ISXIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:08:44 -0400
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1316472096.2455.27.camel@edumazet-laptop>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
	 <1316471007.2455.24.camel@edumazet-laptop>
	 <20110919223649.GO7761@one.firstfloor.org>
	 <1316472096.2455.27.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 01:07:05 +0200
Message-ID: <1316473625.2455.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 20 septembre 2011 à 00:41 +0200, Eric Dumazet a écrit :

> I'll provide not a hack but a clean patch for this.
> 

Here is a draft, just in case. (not even booted, its late here...)

I'll test it tomorrow with a variant of your patch.


 include/linux/idr.h |   13 +++++++++++++
 lib/idr.c           |   32 +++++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 255491c..a6b7655 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -64,6 +64,14 @@ struct idr {
 	spinlock_t	  lock;
 };
 
+/* special id_free_cnt value to mark idr without freelist */
+#define IDR_NOFREELIST -1
+
+static inline bool idr_nofreelist(const struct idr *idr)
+{
+	return idr->id_free_cnt == IDR_NOFREELIST;
+}
+
 #define IDR_INIT(name)						\
 {								\
 	.top		= NULL,					\
@@ -114,6 +122,11 @@ void idr_remove_all(struct idr *idp);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
+static inline void idr_nofreelist_init(struct idr *idp)
+{
+	idr_init(idp);
+	idp->id_free_cnt = IDR_NOFREELIST;
+}
 
 /*
  * IDA - IDR based id allocator, use when translation from id to
diff --git a/lib/idr.c b/lib/idr.c
index db040ce..d4ce74d 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -44,6 +44,9 @@ static struct idr_layer *get_from_free_list(struct idr *idp)
 	struct idr_layer *p;
 	unsigned long flags;
 
+	if (idr_nofreelist(idp))
+		return kmem_cache_zalloc(idr_layer_cache, GFP_KERNEL);
+
 	spin_lock_irqsave(&idp->lock, flags);
 	if ((p = idp->id_free)) {
 		idp->id_free = p->ary[0];
@@ -77,14 +80,17 @@ static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
 
 static void move_to_free_list(struct idr *idp, struct idr_layer *p)
 {
-	unsigned long flags;
-
-	/*
-	 * Depends on the return element being zeroed.
-	 */
-	spin_lock_irqsave(&idp->lock, flags);
-	__move_to_free_list(idp, p);
-	spin_unlock_irqrestore(&idp->lock, flags);
+	if (idr_nofreelist(idp)) {
+		kmem_cache_free(idr_layer_cache, p);
+	} else {
+		unsigned long flags;
+		/*
+		 * Depends on the return element being zeroed.
+		 */
+		spin_lock_irqsave(&idp->lock, flags);
+		__move_to_free_list(idp, p);
+		spin_unlock_irqrestore(&idp->lock, flags);
+	}
 }
 
 static void idr_mark_full(struct idr_layer **pa, int id)
@@ -122,6 +128,7 @@ static void idr_mark_full(struct idr_layer **pa, int id)
  */
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
+	BUG_ON(idr_nofreelist(idp));
 	while (idp->id_free_cnt < IDR_FREE_MAX) {
 		struct idr_layer *new;
 		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
@@ -243,7 +250,10 @@ build_up:
 				p = p->ary[0];
 				new->ary[0] = NULL;
 				new->bitmap = new->count = 0;
-				__move_to_free_list(idp, new);
+				if (idr_nofreelist(idp))
+					kmem_cache_free(idr_layer_cache, p);
+				else
+					__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
 			return -1;
@@ -487,7 +497,7 @@ EXPORT_SYMBOL(idr_remove_all);
  */
 void idr_destroy(struct idr *idp)
 {
-	while (idp->id_free_cnt) {
+	while (idp->id_free_cnt > 0) {
 		struct idr_layer *p = get_from_free_list(idp);
 		kmem_cache_free(idr_layer_cache, p);
 	}
@@ -839,7 +849,7 @@ int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 	 * Throw away extra resources one by one after each successful
 	 * allocation.
 	 */
-	if (ida->idr.id_free_cnt || ida->free_bitmap) {
+	if (ida->idr.id_free_cnt > 0 || ida->free_bitmap) {
 		struct idr_layer *p = get_from_free_list(&ida->idr);
 		if (p)
 			kmem_cache_free(idr_layer_cache, p);


