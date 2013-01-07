Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3AGKDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:03:36 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:36537 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3AGKDf (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 7 Jan 2013 05:03:35 -0500
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
Subject: [PATCH 3/3 v3] dm raid1: add interface to get resync speed
Date: Mon,  7 Jan 2013 18:02:13 +0800
Message-Id: <1357552933-26126-4-git-send-email-gzhao@suse.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357552933-26126-1-git-send-email-gzhao@suse.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
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
 drivers/md/dm-raid1.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 3cdad37..62acfa3 100644
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
@@ -1451,6 +1465,8 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 
 		sz += log->type->status(log, type, result+sz, maxlen-sz);
 
+		DMEMIT(" %u", rlimit_to_speed(ms, &ms->ms_rlimit));
+
 		break;
 
 	case STATUSTYPE_TABLE:
-- 
1.7.10.4

