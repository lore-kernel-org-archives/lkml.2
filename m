Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab2CFQWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:22:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2CFQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:52 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=Prn1BMZWIT8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=fGgtZ5qPRsjjeZbjNp8A:9 a=7KSBAKXWhaLU6dyLyqcA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161949.369724383@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 12/25][RFC 3.0.23-rt39-rc1] seqlock: Provide seq_spin_* functions
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0012-seqlock-Provide-seq_spin_-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

In some cases it's desirable to lock the seqlock w/o changing the
seqcount. Provide functions for this, so we can avoid open coded
constructs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seqlock.h |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 3e1f3f9..b44048d 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -188,6 +188,19 @@ static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 }
 
 /*
+ * Ditto w/o barriers
+ */
+static inline unsigned __read_seqbegin(const seqlock_t *sl)
+{
+	return __read_seqcount_begin(&sl->seqcount);
+}
+
+static inline unsigned __read_seqretry(const seqlock_t *sl, unsigned start)
+{
+	return __read_seqcount_retry(&sl->seqcount, start);
+}
+
+/*
  * Lock out other writers and update the count.
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
@@ -247,4 +260,55 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+/*
+ * Instead of open coding a spinlock and a seqcount, the following
+ * functions allow to serialize on the seqlock w/o touching seqcount.
+ */
+static inline void seq_spin_lock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+}
+
+static inline int seq_spin_trylock(seqlock_t *sl)
+{
+	return spin_trylock(&sl->lock);
+}
+
+static inline void seq_spin_unlock(seqlock_t *sl)
+{
+	spin_unlock(&sl->lock);
+}
+
+static inline void assert_seq_spin_locked(seqlock_t *sl)
+{
+	assert_spin_locked(&sl->lock);
+}
+
+static inline void seq_spin_lock_nested(seqlock_t *sl, int subclass)
+{
+	spin_lock_nested(&sl->lock, subclass);
+}
+
+/*
+ * For writers which need to take/release the lock w/o updating seqcount for
+ * whatever reasons the following functions allow to update the count
+ * after the lock has been acquired or before it is released.
+ */
+static inline void write_seqlock_begin(seqlock_t *sl)
+{
+	assert_spin_locked(&sl->lock);
+	write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_seqlock_end(seqlock_t *sl)
+{
+	assert_spin_locked(&sl->lock);
+	write_seqcount_end(&sl->seqcount);
+}
+
+static inline void write_seqlock_barrier(seqlock_t *sl)
+{
+	write_seqcount_barrier(&sl->seqcount);
+}
+
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.7.8.3


