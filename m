Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab2AKNVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:21:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab2AKNV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:21:26 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/5] GFS2: let spectator mount do read only recovery
Date: Wed, 11 Jan 2012 12:57:26 +0000
Message-Id: <1326286648-5515-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
References: <1326286648-5515-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Previously, a spectator mount would not even attempt to do
journal recovery for a failed node.  This meant that if all
mounted nodes were spectators, everyone would be stuck after
a node failed, all waiting for recovery to be performed.
This is unnecessary since the failed node had a clean journal.

Instead, allow a spectator mount to do a partial "read only"
recovery, which means it will check if the failed journal is
clean, and if so, report a successful recovery.  If the failed
journal is not clean, it reports that journal recovery failed.
This makes it work the same as a read only mount on a read only
block device.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b9422bc..e5701c7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -498,6 +498,7 @@ enum {
 	SDF_NORECOVERY		= 4,
 	SDF_DEMOTE		= 5,
 	SDF_NOJOURNALID		= 6,
+	SDF_RORECOVERY		= 7, /* read only recovery */
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b01573b..6aacf3f 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1078,7 +1078,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 
 	if (sdp->sd_args.ar_spectator) {
                 sb->s_flags |= MS_RDONLY;
-		set_bit(SDF_NORECOVERY, &sdp->sd_flags);
+		set_bit(SDF_RORECOVERY, &sdp->sd_flags);
 	}
 	if (sdp->sd_args.ar_posix_acl)
 		sb->s_flags |= MS_POSIXACL;
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index af49e8f..80701d1 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -516,7 +516,9 @@ void gfs2_recover_func(struct work_struct *work)
 		if (error)
 			goto fail_gunlock_ji;
 
-		if (test_bit(SDF_JOURNAL_CHECKED, &sdp->sd_flags)) {
+		if (test_bit(SDF_RORECOVERY, &sdp->sd_flags)) {
+			ro = 1;
+		} else if (test_bit(SDF_JOURNAL_CHECKED, &sdp->sd_flags)) {
 			if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
 				ro = 1;
 		} else {
-- 
1.7.4

