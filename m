Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1F0XUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:20:23 -0400
Received: from mail.candelatech.com ([208.74.158.172]:43777 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1F0XR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:17:26 -0400
From: greearb@candelatech.com
To: linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] slub: Enable backtrace for create/delete points.
Date: Mon, 27 Jun 2011 16:17:10 -0700
Message-Id: <1309216631-31493-2-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309216631-31493-1-git-send-email-greearb@candelatech.com>
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com>
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
:100644 100644 35f351f... 14d0135... M	mm/slub.c
 mm/slub.c |   39 ++++++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..14d0135 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -191,8 +191,10 @@ static LIST_HEAD(slab_caches);
 /*
  * Tracking user of a slab.
  */
+#define TRACK_ADDRS_COUNT 16
 struct track {
-	unsigned long addr;	/* Called from address */
+	unsigned long caddr;
+	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -420,7 +422,24 @@ static void set_track(struct kmem_cache *s, void *object,
 	struct track *p = get_track(s, object, alloc);
 
 	if (addr) {
-		p->addr = addr;
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
+		for (i = trace.nr_entries; i<TRACK_ADDRS_COUNT; i++)
+			p->addrs[i] = 0;
+
+		p->caddr = addr;
 		p->cpu = smp_processor_id();
 		p->pid = current->pid;
 		p->when = jiffies;
@@ -439,11 +458,17 @@ static void init_tracking(struct kmem_cache *s, void *object)
 
 static void print_track(const char *s, struct track *t)
 {
-	if (!t->addr)
+	int i;
+	if (!t->caddr)
 		return;
 
 	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
+		s, (void *)t->caddr, jiffies - t->when, t->cpu, t->pid);
+	for (i = 0; i < TRACK_ADDRS_COUNT; i++)
+		if (t->addrs[i])
+			printk(KERN_ERR "\t%pS\n", (void *)t->addrs[i]);
+		else
+			break;
 }
 
 static void print_tracking(struct kmem_cache *s, void *object)
@@ -3721,7 +3746,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			break;
 
 		caddr = t->loc[pos].addr;
-		if (track->addr == caddr) {
+		if (track->caddr == caddr) {
 
 			l = &t->loc[pos];
 			l->count++;
@@ -3744,7 +3769,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			return 1;
 		}
 
-		if (track->addr < caddr)
+		if (track->caddr < caddr)
 			end = pos;
 		else
 			start = pos;
@@ -3762,7 +3787,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
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

