Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0JROh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab0JROhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/22] GFS2: Improve journal allocation via sysfs
Date: Mon, 18 Oct 2010 15:15:43 +0100
Message-Id: <1287411346-17855-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently a feature was added to GFS2 to allow journal id allocation
via sysfs. This patch builds upon that so that a negative journal id
will be treated as an error code to be passed back as the return code
from mount. This allows termination of the mount process if there is
a failure.

Also, the process has been updated so that the kernel will wait
for a journal id, even in the "spectator" case. This is required
in order to avoid mounting a filesystem in case there is an error
while joining the cluster. In the spectator case, 0 is written into
the file to indicate that all is well, and that mount should continue.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 6f6ff8a..764fbb4 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -494,7 +494,7 @@ struct gfs2_sb_host {
  */
 
 struct lm_lockstruct {
-	unsigned int ls_jid;
+	int ls_jid;
 	unsigned int ls_first;
 	unsigned int ls_first_done;
 	unsigned int ls_nodir;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5b11f37..aeafc23 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1056,8 +1056,6 @@ static int gfs2_journalid_wait(void *word)
 
 static int wait_on_journal(struct gfs2_sbd *sdp)
 {
-	if (sdp->sd_args.ar_spectator)
-		return 0;
 	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
 		return 0;
 
@@ -1160,6 +1158,20 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	if (error)
 		goto fail_sb;
 
+	/*
+	 * If user space has failed to join the cluster or some similar
+	 * failure has occurred, then the journal id will contain a
+	 * negative (error) number. This will then be returned to the
+	 * caller (of the mount syscall). We do this even for spectator
+	 * mounts (which just write a jid of 0 to indicate "ok" even though
+	 * the jid is unused in the spectator case)
+	 */
+	if (sdp->sd_lockstruct.ls_jid < 0) {
+		error = sdp->sd_lockstruct.ls_jid;
+		sdp->sd_lockstruct.ls_jid = 0;
+		goto fail_sb;
+	}
+
 	error = init_inodes(sdp, DO);
 	if (error)
 		goto fail_sb;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index ccacffd..64082a5 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -399,31 +399,32 @@ static ssize_t recover_status_show(struct gfs2_sbd *sdp, char *buf)
 
 static ssize_t jid_show(struct gfs2_sbd *sdp, char *buf)
 {
-	return sprintf(buf, "%u\n", sdp->sd_lockstruct.ls_jid);
+	return sprintf(buf, "%d\n", sdp->sd_lockstruct.ls_jid);
 }
 
 static ssize_t jid_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 {
-        unsigned jid;
+        int jid;
 	int rv;
 
-	rv = sscanf(buf, "%u", &jid);
+	rv = sscanf(buf, "%d", &jid);
 	if (rv != 1)
 		return -EINVAL;
 
 	spin_lock(&sdp->sd_jindex_spin);
 	rv = -EINVAL;
-	if (sdp->sd_args.ar_spectator)
-		goto out;
 	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
 		goto out;
 	rv = -EBUSY;
-	if (test_and_clear_bit(SDF_NOJOURNALID, &sdp->sd_flags) == 0)
+	if (test_bit(SDF_NOJOURNALID, &sdp->sd_flags) == 0)
 		goto out;
+	rv = 0;
+	if (sdp->sd_args.ar_spectator && jid > 0)
+		rv = jid = -EINVAL;
 	sdp->sd_lockstruct.ls_jid = jid;
+	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
-	rv = 0;
 out:
 	spin_unlock(&sdp->sd_jindex_spin);
 	return rv ? rv : len;
@@ -617,7 +618,7 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
 	if (!test_bit(SDF_NOJOURNALID, &sdp->sd_flags))
-		add_uevent_var(env, "JOURNALID=%u", sdp->sd_lockstruct.ls_jid);
+		add_uevent_var(env, "JOURNALID=%d", sdp->sd_lockstruct.ls_jid);
 	if (gfs2_uuid_valid(uuid))
 		add_uevent_var(env, "UUID=%pUB", uuid);
 	return 0;
-- 
1.7.1.1

