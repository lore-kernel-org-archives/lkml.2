Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3AHBDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:03:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38332 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3AHBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:03:48 -0500
Date: Mon, 7 Jan 2013 17:03:44 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH] percpu-refcount: Sparse fixes
Message-ID: <20130108010344.GN26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130103144839.7a514924.akpm@linux-foundation.org>
 <20130107234737.GI26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107234737.GI26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some more fixes, the percpu refcount code is now sparse clean for
me. It's kind of ugly, but I'm not sure it's really any uglier than it
was before. Seem reasonable?

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 include/linux/percpu-refcount.h |  2 +-
 lib/percpu-refcount.c           | 51 ++++++++++++++++++++++-------------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 1654a5b..bed9a0d 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -74,7 +74,7 @@
 
 struct percpu_ref {
 	atomic64_t		count;
-	unsigned __percpu	*pcpu_count;
+	unsigned long		pcpu_count;
 };
 
 void percpu_ref_init(struct percpu_ref *ref);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index e018f01..15e2bda 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -61,7 +61,7 @@
 #define PCPU_REF_DYING		2
 #define PCPU_REF_DEAD		3
 
-#define REF_STATUS(count)	((unsigned long) count & PCPU_STATUS_MASK)
+#define REF_STATUS(count)	(count & PCPU_STATUS_MASK)
 
 /**
  * percpu_ref_init - initialize a dynamic percpu refcount
@@ -78,47 +78,47 @@ void percpu_ref_init(struct percpu_ref *ref)
 	now <<= PCPU_STATUS_BITS;
 	now |= PCPU_REF_NONE;
 
-	ref->pcpu_count = (void *) now;
+	ref->pcpu_count = now;
 }
 
-static void percpu_ref_alloc(struct percpu_ref *ref, unsigned __user *pcpu_count)
+static void percpu_ref_alloc(struct percpu_ref *ref, unsigned long pcpu_count)
 {
-	unsigned __percpu *new;
-	unsigned long last = (unsigned long) pcpu_count;
-	unsigned long now = jiffies;
+	unsigned long new, now = jiffies;
 
 	now <<= PCPU_STATUS_BITS;
 	now |= PCPU_REF_NONE;
 
-	if (now - last <= HZ << PCPU_STATUS_BITS) {
+	if (now - pcpu_count <= HZ << PCPU_STATUS_BITS) {
 		rcu_read_unlock();
-		new = alloc_percpu(unsigned);
+		new = (unsigned long) alloc_percpu(unsigned);
 		rcu_read_lock();
 
 		if (!new)
 			goto update_time;
 
-		BUG_ON(((unsigned long) new) & PCPU_STATUS_MASK);
+		BUG_ON(new & PCPU_STATUS_MASK);
 
 		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
-			free_percpu(new);
+			free_percpu((void __percpu *) new);
 		else
 			pr_debug("created");
 	} else {
-update_time:	new = (void *) now;
+update_time:	new = now;
 		cmpxchg(&ref->pcpu_count, pcpu_count, new);
 	}
 }
 
 void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long pcpu_count;
 	uint64_t v;
 
-	pcpu_count = rcu_dereference(ref->pcpu_count);
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
-		__this_cpu_inc(*pcpu_count);
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));
 	} else {
 		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
 					&ref->count);
@@ -138,17 +138,19 @@ void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
  */
 int percpu_ref_put(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long pcpu_count;
 	uint64_t v;
 	int ret = 0;
 
 	rcu_read_lock();
 
-	pcpu_count = rcu_dereference(ref->pcpu_count);
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	switch (REF_STATUS(pcpu_count)) {
 	case PCPU_REF_PTR:
-		__this_cpu_dec(*pcpu_count);
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_dec(*((unsigned __percpu *) pcpu_count));
 		break;
 	case PCPU_REF_NONE:
 	case PCPU_REF_DYING:
@@ -180,18 +182,19 @@ int percpu_ref_put(struct percpu_ref *ref)
  */
 int percpu_ref_kill(struct percpu_ref *ref)
 {
-	unsigned __percpu *old, *new, *pcpu_count = ref->pcpu_count;
-	unsigned long status;
+	unsigned long old, new, status, pcpu_count;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	do {
 		status = REF_STATUS(pcpu_count);
 
 		switch (status) {
 		case PCPU_REF_PTR:
-			new = (void *) PCPU_REF_DYING;
+			new = PCPU_REF_DYING;
 			break;
 		case PCPU_REF_NONE:
-			new = (void *) PCPU_REF_DEAD;
+			new = PCPU_REF_DEAD;
 			break;
 		case PCPU_REF_DYING:
 		case PCPU_REF_DEAD:
@@ -208,7 +211,7 @@ int percpu_ref_kill(struct percpu_ref *ref)
 		synchronize_rcu();
 
 		for_each_possible_cpu(cpu)
-			count += *per_cpu_ptr(pcpu_count, cpu);
+			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
 
 		pr_debug("global %lli pcpu %i",
 			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
@@ -217,9 +220,9 @@ int percpu_ref_kill(struct percpu_ref *ref)
 		atomic64_add((int) count, &ref->count);
 		smp_wmb();
 		/* Between setting global count and setting PCPU_REF_DEAD */
-		ref->pcpu_count = (void *) PCPU_REF_DEAD;
+		ref->pcpu_count = PCPU_REF_DEAD;
 
-		free_percpu(pcpu_count);
+		free_percpu((unsigned __percpu *) pcpu_count);
 	}
 
 	return 1;
-- 
1.7.12

