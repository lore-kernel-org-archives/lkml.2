Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0EXWnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:43:06 -0400
Received: from kroah.org ([198.145.64.141]:35980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab0EXWiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:12 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 15:30:14 2010
Message-Id: <20100524223014.563332517@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:27:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Mingming Cao <cmm@us.ibm.com>, "Jayson R. King" <dev@jaysonking.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [03/24] percpu counter: clean up percpu_counter_sum_and_set()
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Mingming Cao <cmm@us.ibm.com>

commit 1f7c14c62ce63805f9574664a6c6de3633d4a354 upstream.

percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
the former updates the global counter after accounting.  Since we are
taking the fbc->lock to calculate the precise value of the counter in
percpu_counter_sum() anyway, it should simply set fbc->count too, as the
percpu_counter_sum_and_set() does.

This patch merges these two interfaces into one.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

---
 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |   12 +++---------
 lib/percpu_counter.c           |    8 +++-----
 3 files changed, 7 insertions(+), 15 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1778,7 +1778,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct
 #ifdef CONFIG_SMP
 	if (free_blocks - root_blocks < FBC_BATCH)
 		free_blocks =
-			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
+			percpu_counter_sum(&sbi->s_freeblocks_counter);
 #endif
 	if (free_blocks <= root_blocks)
 		/* we don't have free space */
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,19 +44,13 @@ static inline void percpu_counter_add(st
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
-	s64 ret = __percpu_counter_sum(fbc, 0);
+	s64 ret = __percpu_counter_sum(fbc);
 	return ret < 0 ? 0 : ret;
 }
 
-static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
-{
-	return __percpu_counter_sum(fbc, 1);
-}
-
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
-	return __percpu_counter_sum(fbc, 0);
+	return __percpu_counter_sum(fbc);
 }
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -62,11 +62,9 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		if (set)
-			*pcount = 0;
+		*pcount = 0;
 	}
-	if (set)
-		fbc->count = ret;
+	fbc->count = ret;
 
 	spin_unlock(&fbc->lock);
 	return ret;


