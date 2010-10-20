Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab0JTHUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:20:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36905 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab0JTHUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:20:41 -0400
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 00:20:36 -0700
Message-ID: <AANLkTinpR5QQUkd5VJMyotiEMLZYZdDs5-Jwn3LQ4pC0@mail.gmail.com>
Subject: [PATCH] sched_fair.c:find_busiest_group(), kernel 2.6.35.7
From: Andrew Dickinson <whydna@whydna.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix the corner case where we're crashing with
divide_error in find_busiest_group (see
https://bugzilla.kernel.org/show_bug.cgi?id=16991).
I don't fully understand what the case is that causes sds.total_pwr to
be zero in find_busiest_group, but this patch guards against the
divide-by-zero bug.

I also added safe-guarding around other routines in the scheduler code
where we're dividing by power; that's more of a just-in-case and I'm
definitely open for debate on that.

diff -ruwp a/kernel/sched_fair.c b/kernel/sched_fair.c
--- a/kernel/sched_fair.c	2010-10-19 23:47:51.000000000 -0700
+++ b/kernel/sched_fair.c	2010-10-20 00:08:17.000000000 -0700
@@ -1344,7 +1344,9 @@ find_idlest_group(struct sched_domain *s
 		}

 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+		avg_load = (avg_load * SCHED_LOAD_SCALE);
+		if (group->cpu_power)
+			avg_load /= group->cpu_power;

 		if (local_group) {
 			this_load = avg_load;
@@ -2409,7 +2411,9 @@ static inline void update_sg_lb_stats(st
 	update_group_power(sd, this_cpu);

 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
+	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE);
+	if (group->cpu_power)
+		sgs->avg_load /= group->cpu_power;

 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2692,7 +2696,7 @@ find_busiest_group(struct sched_domain *
 	if (!(*balance))
 		goto ret;

-	if (!sds.busiest || sds.busiest_nr_running == 0)
+	if (!sds.busiest || sds.busiest_nr_running == 0 || sds.total_pwr == 0)
 		goto out_balanced;

 	if (sds.this_load >= sds.max_load)
@@ -2757,7 +2761,9 @@ find_busiest_queue(struct sched_group *g
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_LOAD_SCALE) / power;
+		wl = (wl * SCHED_LOAD_SCALE);
+		if (power)
+			wl /= power;

 		if (wl > max_load) {
 			max_load = wl;
