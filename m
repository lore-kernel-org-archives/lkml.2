Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3AGKDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:03:21 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:54286 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3AGKDU (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 7 Jan 2013 05:03:20 -0500
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
Subject: [PATCH 2/3 v3] dm raid1: add interface to set resync speed
Date: Mon,  7 Jan 2013 18:02:12 +0800
Message-Id: <1357552933-26126-3-git-send-email-gzhao@suse.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357552933-26126-1-git-send-email-gzhao@suse.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioctl to control resync speed, userspace tool
is dmsetup message, message format is:
	dmsetup message $device 0 "set-max-resync-speed $speed"
e.g.
	dmsetup message /dev/dm-2 0 "set-max-resync-speed 12345"

Signed-off-by: Guangliang Zhao <gzhao@suse.com>
---
 drivers/md/dm-raid1.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 43e428a..3cdad37 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1361,6 +1361,49 @@ static void mirror_resume(struct dm_target *ti)
 }
 
 /*
+ * convert speed into members of ratelimit_state
+ */
+static void speed_to_rlimit(struct mirror_set *ms, struct ratelimit_state *rl,
+			    unsigned int speed)
+{
+	sector_t region_size = dm_rh_get_region_size(ms->rh);
+
+	rl->interval = RESYNC_JIFFIES;
+	rl->burst = (speed * (RESYNC_JIFFIES / HZ)) << 1;
+	rl->burst = DIV_ROUND_UP(rl->burst, region_size);
+}
+
+/*
+ * Message interface
+ *	set-max-resync-speed $speed(KB/s)
+ */
+static int mirror_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct mirror_set *ms = ti->private;
+	unsigned int speed;
+	int ret = 0;
+
+	if (!strcasecmp(argv[0], "set-max-resync-speed")) {
+		if (sscanf(argv[1], "%u", &speed) != 1) {
+			DMWARN("invalid speed parameter %s", argv[1]);
+			ret = -EINVAL;
+			goto error;
+		}
+
+		speed_to_rlimit(ms, &ms->ms_rlimit, speed);
+		goto out;
+	} else {
+		ret = -EINVAL;
+		goto error;
+	}
+
+error:
+	DMWARN("unrecognised message received.");
+out:
+	return ret;
+}
+
+/*
  * device_status_char
  * @m: mirror device/leg we want the status of
  *
@@ -1450,6 +1493,7 @@ static struct target_type mirror_target = {
 	.presuspend = mirror_presuspend,
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
+	.message = mirror_message,
 	.status	 = mirror_status,
 	.iterate_devices = mirror_iterate_devices,
 };
-- 
1.7.10.4

