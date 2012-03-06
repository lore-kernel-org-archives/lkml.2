Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2CFQXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:23:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2CFQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:47 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=_9UVLNhvAEgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=72x_bIlTtuIoEO81M2EA:9 a=P1vqDypEqHjmFqw5pPsA:7 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161945.335361061@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 02/25][RFC 3.0.23-rt39-rc1] revert-seqlock-create-raw_seqlock
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0002-revert-seqlock-create-raw_seqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

revert: seqlock: Create raw_seqlock

Revert:

Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Jul 25 19:27:54 2009 +0200

    seqlock: Create raw_seqlock

    raw_seqlock_t will be used to annotate seqlocks which can not be
    converted to sleeping locks in preempt-rt

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seqlock.h |   63 -----------------------------------------------
 1 files changed, 0 insertions(+), 63 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e262353..11a9073 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -152,11 +152,6 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 
 typedef struct {
 	struct seqcount seqcount;
-	raw_spinlock_t lock;
-} raw_seqlock_t;
-
-typedef struct {
-	struct seqcount seqcount;
 	spinlock_t lock;
 } seqlock_t;
 
@@ -164,21 +159,6 @@ typedef struct {
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
  */
-#define __RAW_SEQLOCK_UNLOCKED(lockname)			\
-	{							\
-		.seqcount = SEQCNT_ZERO,			\
-		.lock =	__RAW_SPIN_LOCK_UNLOCKED(lockname)	\
-	}
-
-#define raw_seqlock_init(x)					\
-	do {							\
-		seqcount_init(&(x)->seqcount);			\
-		raw_spin_lock_init(&(x)->lock);			\
-	} while (0)
-
-#define DEFINE_RAW_SEQLOCK(x) \
-		raw_seqlock_t x = __RAW_SEQLOCK_UNLOCKED(x)
-
 #define __SEQLOCK_UNLOCKED(lockname)			\
 	{						\
 		.seqcount = SEQCNT_ZERO,		\
@@ -202,49 +182,6 @@ typedef struct {
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
  */
-static inline void raw_write_seqlock(raw_seqlock_t *sl)
-{
-	raw_spin_lock(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
-}
-
-static inline void raw_write_sequnlock(raw_seqlock_t *sl)
-{
-	write_seqcount_end(&sl->seqcount);
-	raw_spin_unlock(&sl->lock);
-}
-
-static inline void raw_write_seqlock_irq(raw_seqlock_t *sl)
-{
-	raw_spin_lock_irq(&sl->lock);
-	write_seqcount_begin(&sl->seqcount);
-}
-
-static inline void raw_write_sequnlock_irq(raw_seqlock_t *sl)
-{
-	write_seqcount_end(&sl->seqcount);
-	raw_spin_unlock_irq(&sl->lock);
-}
-
-static inline unsigned long __raw_write_seqlock_irqsave(raw_seqlock_t *sl)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&sl->lock, flags);
-	write_seqcount_begin(&sl->seqcount);
-	return flags;
-}
-
-#define raw_write_seqlock_irqsave(lock, flags)				\
-	do { flags = __raw_write_seqlock_irqsave(lock); } while (0)
-
-static inline void
-raw_write_sequnlock_irqrestore(raw_seqlock_t *sl, unsigned long flags)
-{
-	write_seqcount_end(&sl->seqcount);
-	raw_spin_unlock_irqrestore(&sl->lock, flags);
-}
-
 static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
-- 
1.7.8.3


