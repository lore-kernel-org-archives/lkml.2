Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1C2NJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:09:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:42866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1C2NJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:09:02 -0400
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>
In-Reply-To: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 15:11:11 +0200
Message-ID: <1301404271.2250.381.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 13:12 +0900, Tetsuo Handa wrote:
> @@ -86,6 +86,11 @@ static inline int write_tryseqlock(seqlo
>  static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
>  {
>         unsigned ret;
> +#ifdef CONFIG_PROVE_LOCKING
> +       unsigned long flags;
> +       spin_lock_irqsave(&((seqlock_t *) sl)->lock, flags);
> +       spin_unlock_irqrestore(&((seqlock_t *) sl)->lock, flags);
> +#endif
>  
>  repeat:
>         ret = sl->sequence; 

That isn't the right way, something like the below would do, however
there's a reason this isn't done, we use these primitives from the VDSO
which means they're not permitted to write to any kernel memory at all.

We could sort that by creating a raw_ variant that doesn't get the
annotation, something I think is already done for -rt anyway.


---
 include/linux/seqlock.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e98cd2e..f2bc19c 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -94,6 +94,7 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 		cpu_relax();
 		goto repeat;
 	}
+	rwlock_acquire_read(&sl->lock->dep_map, 0, 0, _RET_IP_);
 
 	return ret;
 }
@@ -107,6 +108,8 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	smp_rmb();
 
+	rwlock_release(&sl->lock->dep_map, 1, _RET_IP_);
+
 	return unlikely(sl->sequence != start);
 }
 
@@ -120,6 +123,9 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 
 typedef struct seqcount {
 	unsigned sequence;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 } seqcount_t;
 
 #define SEQCNT_ZERO { 0 }
@@ -148,6 +154,7 @@ static inline unsigned __read_seqcount_begin(const seqcount_t *s)
 		cpu_relax();
 		goto repeat;
 	}
+	rwlock_acquire_read(&sl->dep_map, 0, 0, _RET_IP_);
 	return ret;
 }
 
@@ -183,7 +190,9 @@ static inline unsigned read_seqcount_begin(const seqcount_t *s)
  */
 static inline int __read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
-	return unlikely(s->sequence != start);
+	int ret = unlikely(s->sequence != start);
+	rwlock_release(&sl->dep_map, 1, _RET_IP_);
+	return ret;
 }
 
 /**
@@ -210,6 +219,7 @@ static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
  */
 static inline void write_seqcount_begin(seqcount_t *s)
 {
+	rwlock_acquire(&sl->dep_map, 0, 0, _RET_IP_);
 	s->sequence++;
 	smp_wmb();
 }
@@ -218,6 +228,7 @@ static inline void write_seqcount_end(seqcount_t *s)
 {
 	smp_wmb();
 	s->sequence++;
+	rwlock_release(&sl->dep_map, 1, _RET_IP_);
 }
 
 /**


