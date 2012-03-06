Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2CFQUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:20:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2CFQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:58 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=RjuAiaFd7zoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=uDatQDoUE6n_j2kEEDAA:9 a=91B-5eJWPmwOUK4An44A:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161950.357072870@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 16/25][RFC 3.0.23-rt39-rc1] seqlock: Prevent rt starvation
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0016-seqlock-Prevent-rt-starvation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If a low prio writer gets preempted while holding the seqlock write
locked, a high prio reader spins forever on RT.

To prevent this let the reader grab the spinlock, so it blocks and
eventually boosts the writer. This way the writer can proceed and
endless spinning is prevented.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seqlock.h |   23 +++++++++++++++++++++++
 include/net/neighbour.h |    2 +-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index b44048d..29ffd4f 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -177,10 +177,33 @@ typedef struct {
 /*
  * Read side functions for starting and finalizing a read side section.
  */
+#ifndef CONFIG_PREEMPT_RT_FULL
 static inline unsigned read_seqbegin(const seqlock_t *sl)
 {
 	return read_seqcount_begin(&sl->seqcount);
 }
+#else
+/*
+ * Starvation safe read side for RT
+ */
+static inline unsigned read_seqbegin(seqlock_t *sl)
+{
+	unsigned ret;
+
+repeat:
+	ret = sl->seqcount.sequence;
+	if (unlikely(ret & 1)) {
+		/*
+		 * Take the lock and let the writer proceed (i.e. evtl
+		 * boost it), otherwise we could loop here forever.
+		 */
+		spin_lock(&sl->lock);
+		spin_unlock(&sl->lock);
+		goto repeat;
+	}
+	return ret;
+}
+#endif
 
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 {
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 4014b62..9c1cb97 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -377,7 +377,7 @@ struct neighbour_cb {
 
 #define NEIGH_CB(skb)	((struct neighbour_cb *)(skb)->cb)
 
-static inline void neigh_ha_snapshot(char *dst, const struct neighbour *n,
+static inline void neigh_ha_snapshot(char *dst, struct neighbour *n,
 				     const struct net_device *dev)
 {
 	unsigned int seq;
-- 
1.7.8.3


