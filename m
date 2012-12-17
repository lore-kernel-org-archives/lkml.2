Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2LQI1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:27:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65374 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2LQI1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:27:38 -0500
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
Subject: [PATCH 3/3 v2] dm raid1: add interface to get resync speed
Date: Mon, 17 Dec 2012 16:26:37 +0800
Message-Id: <1355732797-7233-4-git-send-email-gzhao@suse.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355732797-7233-1-git-send-email-gzhao@suse.com>
References: <1355732797-7233-1-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioctl to get resync speed, userspace tool
is dmsetup status:
	dmsetup status $device
e.g.
	dmsetup status /dev/dm-2

Signed-off-by: Guangliang Zhao <gzhao@suse.com>
---
 drivers/md/dm-raid1.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 3cdad37..68081ff 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1427,6 +1427,20 @@ static char device_status_char(struct mirror *m)
 		(test_bit(DM_RAID1_READ_ERROR, &(m->error_type))) ? 'R' : 'U';
 }
 
+/*
+ * get speed from ratelimit_state
+ */
+static unsigned int rlimit_to_speed(struct mirror_set *ms,
+				    struct ratelimit_state *rl)
+{
+	sector_t region_size = dm_rh_get_region_size(ms->rh);
+	unsigned int time, burst;
+
+	time = rl->interval / HZ;
+	burst = (rl->burst * region_size) >> 1;
+
+	return burst / time;
+}
 
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
@@ -1445,9 +1459,10 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 		}
 		buffer[m] = '\0';
 
-		DMEMIT("%llu/%llu 1 %s ",
+		DMEMIT("%llu/%llu 1 %u 1 %s ",
 		      (unsigned long long)log->type->get_sync_count(log),
-		      (unsigned long long)ms->nr_regions, buffer);
+		      (unsigned long long)ms->nr_regions,
+		      rlimit_to_speed(ms, &ms->ms_rlimit), buffer);
 
 		sz += log->type->status(log, type, result+sz, maxlen-sz);
 
-- 
1.7.10.4

