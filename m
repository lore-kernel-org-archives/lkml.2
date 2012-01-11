Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab2AKNW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:22:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab2AKNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:21:28 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/5] GFS2: fail mount if journal recovery fails
Date: Wed, 11 Jan 2012 12:57:27 +0000
Message-Id: <1326286648-5515-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
References: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

If the first mounter fails to recover one of the journals
during mount, the mount should fail.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e5701c7..97742a7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -429,6 +429,7 @@ struct gfs2_jdesc {
 #define JDF_RECOVERY 1
 	unsigned int jd_jid;
 	unsigned int jd_blocks;
+	int jd_recover_error;
 };
 
 struct gfs2_statfs_change_host {
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 80701d1..963b2d7 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -583,6 +583,7 @@ fail_gunlock_j:
 
 	fs_info(sdp, "jid=%u: %s\n", jd->jd_jid, (error) ? "Failed" : "Done");
 fail:
+	jd->jd_recover_error = error;
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
 done:
 	clear_bit(JDF_RECOVERY, &jd->jd_flags);
@@ -611,6 +612,6 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd, bool wait)
 		wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait,
 			    TASK_UNINTERRUPTIBLE);
 
-	return 0;
+	return wait ? jd->jd_recover_error : 0;
 }
 
-- 
1.7.4

