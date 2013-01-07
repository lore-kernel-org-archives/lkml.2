Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3AGKDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:03:03 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:48100 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3AGKCt (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 7 Jan 2013 05:02:49 -0500
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
Subject: [PATCH 1/3 v3] dm raid1: add resync speed control for dm-raid1
Date: Mon,  7 Jan 2013 18:02:11 +0800
Message-Id: <1357552933-26126-2-git-send-email-gzhao@suse.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357552933-26126-1-git-send-email-gzhao@suse.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IO performance on the already available lv is very bad
during the initial sync when we create a mirror lv. This
patch add the rate limit for every mirror target to control
resync speed.

This patch only limited the resync IO speed simply, and
didn't care about user IO, because it is mainly used in
clustered situations, and we don't know the IO load on
other nodes, so it isn't practical to measure them in
those cases.

Signed-off-by: Guangliang Zhao <gzhao@suse.com>
---
 drivers/md/dm-raid1.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 9bfd057..43e428a 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/ratelimit.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/dm-dirty-log.h>
@@ -26,6 +27,11 @@
 #define DM_RAID1_HANDLE_ERRORS 0x01
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
 
+/* Default resync interval*/
+#define RESYNC_JIFFIES	HZ
+/* Default max resync speed in KB/s */
+#define DEFAULT_RESYNC_SPEED		(0xFFFFFFF)
+
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
 /*-----------------------------------------------------------------
@@ -69,6 +75,9 @@ struct mirror_set {
 	int log_failure;
 	int leg_failure;
 	atomic_t suspend;
+	/* recovery speed control */
+	struct ratelimit_state ms_rlimit;
+	struct delayed_work resync_waker;
 
 	atomic_t default_mirror;	/* Default mirror */
 
@@ -383,12 +392,18 @@ static void do_recovery(struct mirror_set *ms)
 	/*
 	 * Copy any already quiesced regions.
 	 */
-	while ((reg = dm_rh_recovery_start(ms->rh))) {
+	while (__ratelimit(&ms->ms_rlimit) &&
+			(reg = dm_rh_recovery_start(ms->rh))) {
 		r = recover(ms, reg);
 		if (r)
 			dm_rh_recovery_end(reg, 0);
 	}
 
+	/* Broke off the resync process, so wake up kmirrord later on */
+	if (!ms->in_sync)
+		schedule_delayed_work(&ms->resync_waker,
+				      ms->ms_rlimit.interval);
+
 	/*
 	 * Update the in sync flag.
 	 */
@@ -842,6 +857,14 @@ static void do_mirror(struct work_struct *work)
 	do_failures(ms, &failures);
 }
 
+static void do_resync_wake(struct work_struct *work)
+{
+	struct mirror_set *ms =
+		container_of(work, struct mirror_set, resync_waker.work);
+
+	wakeup_mirrord(ms);
+}
+
 /*-----------------------------------------------------------------
  * Target functions
  *---------------------------------------------------------------*/
@@ -852,6 +875,7 @@ static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 {
 	size_t len;
 	struct mirror_set *ms = NULL;
+	int burst;
 
 	len = sizeof(*ms) + (sizeof(ms->mirror[0]) * nr_mirrors);
 
@@ -875,6 +899,10 @@ static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 	ms->leg_failure = 0;
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
+	burst = (DEFAULT_RESYNC_SPEED * (RESYNC_JIFFIES / HZ)) << 1;
+	burst = DIV_ROUND_UP(burst, region_size);
+	ratelimit_state_init(&ms->ms_rlimit, RESYNC_JIFFIES, burst);
+	INIT_DELAYED_WORK(&ms->resync_waker, do_resync_wake);
 
 	ms->read_record_pool = mempool_create_slab_pool(MIN_READ_RECORDS,
 						_dm_raid1_read_record_cache);
-- 
1.7.10.4

