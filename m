Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596Ab1ESTks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934491Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 12/13] blk-cgroup: Make cgroup stat reset path blkg->lock free for dispatch stats
Date: Thu, 19 May 2011 15:38:30 -0400
Message-Id: <1305833911-7717-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now dispatch stats update is lock free. But reset of these stats still
takes blkg->stats_lock and is dependent on that. As stats are per cpu,
we should be able to just reset the stats on each cpu without any locks.
(Atleast for 64bit arch).

On 32bit arch there is a small race where 64bit updates are not atomic.
The result of this race can be that in the presence of other writers,
one might not get 0 value after reset of a stat and might see something
intermediate

One can write more complicated code to cover this race like sending IPI
to other cpus to reset stats and for offline cpus, reset these directly.

Right not I am not taking that path because reset_update is more of a
debug feature and it can happen only on 32bit arch and possibility of
it happening is small. Will fix it if it becomes a real problem. For
the time being going for code simplicity.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3622518e..e41cc6f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -537,6 +537,30 @@ struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
 }
 EXPORT_SYMBOL_GPL(blkiocg_lookup_group);
 
+static void blkio_reset_stats_cpu(struct blkio_group *blkg)
+{
+	struct blkio_group_stats_cpu *stats_cpu;
+	int i, j, k;
+	/*
+	 * Note: On 64 bit arch this should not be an issue. This has the
+	 * possibility of returning some inconsistent value on 32bit arch
+	 * as 64bit update on 32bit is non atomic. Taking care of this
+	 * corner case makes code very complicated, like sending IPIs to
+	 * cpus, taking care of stats of offline cpus etc.
+	 *
+	 * reset stats is anyway more of a debug feature and this sounds a
+	 * corner case. So I am not complicating the code yet until and
+	 * unless this becomes a real issue.
+	 */
+	for_each_possible_cpu(i) {
+		stats_cpu = per_cpu_ptr(blkg->stats_cpu, i);
+		stats_cpu->sectors = 0;
+		for(j = 0; j < BLKIO_STAT_CPU_NR; j++)
+			for (k = 0; k < BLKIO_STAT_TOTAL; k++)
+				stats_cpu->stat_arr_cpu[j][k] = 0;
+	}
+}
+
 static int
 blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 {
@@ -581,7 +605,11 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 		}
 #endif
 		spin_unlock(&blkg->stats_lock);
+
+		/* Reset Per cpu stats which don't take blkg->stats_lock */
+		blkio_reset_stats_cpu(blkg);
 	}
+
 	spin_unlock_irq(&blkcg->lock);
 	return 0;
 }
-- 
1.7.4.4

