Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1F2AsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 20:48:15 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49681 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1F2AsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 20:48:12 -0400
From: greearb@candelatech.com
To: penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/2] slub: Enable backtrace for create/delete points.
Date: Tue, 28 Jun 2011 17:47:41 -0700
Message-Id: <1309308462-20124-2-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309308462-20124-1-git-send-email-greearb@candelatech.com>
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This patch attempts to grab a backtrace for the creation
and deletion points of the slub object.  When a fault is
detected, we can then get a better idea of where the item
was deleted.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Fix compile when CONFIG_STACKTRACE is not enabled
    (It is required for this particular feature.)

:100644 100644 35f351f... 3477ce5... M	mm/slub.c
 mm/slub.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..3477ce5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -191,8 +191,12 @@ static LIST_HEAD(slab_caches);
 /*
  * Tracking user of a slab.
  */
+#define TRACK_ADDRS_COUNT 16
 struct track {
-	unsigned long addr;	/* Called from address */
+	unsigned long caddr;
+#ifdef CONFIG_STACKTRACE
+	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
+#endif
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -420,7 +424,25 @@ static void set_track(struct kmem_cache *s, void *object,
 	struct track *p = get_track(s, object, alloc);
 
 	if (addr) {
-		p->addr = addr;
+#ifdef CONFIG_STACKTRACE
+		struct stack_trace trace;
+		int i;
+
+		trace.nr_entries = 0;
+		trace.max_entries = TRACK_ADDRS_COUNT;
+		trace.entries = p->addrs;
+		trace.skip = 3;
+		save_stack_trace(&trace);
+
+		/* See rant in lockdep.c */
+		if (trace.nr_entries != 0 &&
+		    trace.entries[trace.nr_entries - 1] == ULONG_MAX)
+			trace.nr_entries--;
+
+		for (i = trace.nr_entries; i < TRACK_ADDRS_COUNT; i++)
+			p->addrs[i] = 0;
+#endif
+		p->caddr = addr;
 		p->cpu = smp_processor_id();
 		p->pid = current->pid;
 		p->when = jiffies;
@@ -439,11 +461,19 @@ static void init_tracking(struct kmem_cache *s, void *object)
 
 static void print_track(const char *s, struct track *t)
 {
-	if (!t->addr)
+	int i;
+	if (!t->caddr)
 		return;
 
 	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
+		s, (void *)t->caddr, jiffies - t->when, t->cpu, t->pid);
+#ifdef CONFIG_STACKTRACE
+	for (i = 0; i < TRACK_ADDRS_COUNT; i++)
+		if (t->addrs[i])
+			printk(KERN_ERR "\t%pS\n", (void *)t->addrs[i]);
+		else
+			break;
+#endif
 }
 
 static void print_tracking(struct kmem_cache *s, void *object)
@@ -3721,7 +3751,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			break;
 
 		caddr = t->loc[pos].addr;
-		if (track->addr == caddr) {
+		if (track->caddr == caddr) {
 
 			l = &t->loc[pos];
 			l->count++;
@@ -3744,7 +3774,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			return 1;
 		}
 
-		if (track->addr < caddr)
+		if (track->caddr < caddr)
 			end = pos;
 		else
 			start = pos;
@@ -3762,7 +3792,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			(t->count - pos) * sizeof(struct location));
 	t->count++;
 	l->count = 1;
-	l->addr = track->addr;
+	l->addr = track->caddr;
 	l->sum_time = age;
 	l->min_time = age;
 	l->max_time = age;
-- 
1.7.3.4

