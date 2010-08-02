Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0HBJtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0HBJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/8] GFS2: Wait for journal id on mount if not specified on mount command line
Date: Mon,  2 Aug 2010 10:27:53 +0100
Message-Id: <1280741279-6782-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a wait for the journal id in the case that it has
not been specified on the command line. This is to allow the future
removal of the mount.gfs2 helper. The journal id would instead be
directly communicated by gfs_controld to the file system. Here is a
comparison of the two systems:

Current:
1. mount calls mount.gfs2
2. mount.gfs2 connects to gfs_controld to retrieve the journal id
3. mount.gfs2 adds the journal id to the mount command line and calls
the mount system call
4. gfs_controld receives the status of the mount request via a uevent

Proposed:
1. mount calls the mount system call (no mount.gfs2 helper)
2. gfs_controld receives a uevent for a gfs2 fs which it doesn't know
about already
3. gfs_controld assigns a journal id to it via sysfs
4. the mount system call then completes as normal (sending a uevent
according to status)

The advantage of the proposed system is that it is completely backward
compatible with the current system both at the kernel and at the
userland levels. The "first" parameter can also be set the same way,
with the restriction that it must be set before the journal id is
assigned.

In addition, if mount becomes stuck waiting for a reply from
gfs_controld which never arrives, then it is killable and will abort the
mount gracefully.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b5d7363..8fcbce4 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -460,6 +460,7 @@ enum {
 	SDF_NOBARRIERS		= 3,
 	SDF_NORECOVERY		= 4,
 	SDF_DEMOTE		= 5,
+	SDF_NOJOURNALID		= 6,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3593b3a..45a4a36 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -76,7 +76,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	sb->s_fs_info = sdp;
 	sdp->sd_vfs = sb;
-
+	set_bit(SDF_NOJOURNALID, &sdp->sd_flags);
 	gfs2_tune_init(&sdp->sd_tune);
 
 	init_waitqueue_head(&sdp->sd_glock_wait);
@@ -1050,7 +1050,8 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 			ret = match_int(&tmp[0], &option);
 			if (ret || option < 0) 
 				goto hostdata_error;
-			ls->ls_jid = option;
+			if (test_and_clear_bit(SDF_NOJOURNALID, &sdp->sd_flags))
+				ls->ls_jid = option;
 			break;
 		case Opt_id:
 			/* Obsolete, but left for backward compat purposes */
@@ -1102,6 +1103,24 @@ void gfs2_lm_unmount(struct gfs2_sbd *sdp)
 		lm->lm_unmount(sdp);
 }
 
+static int gfs2_journalid_wait(void *word)
+{
+	if (signal_pending(current))
+		return -EINTR;
+	schedule();
+	return 0;
+}
+
+static int wait_on_journal(struct gfs2_sbd *sdp)
+{
+	if (sdp->sd_args.ar_spectator)
+		return 0;
+	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
+		return 0;
+
+	return wait_on_bit(&sdp->sd_flags, SDF_NOJOURNALID, gfs2_journalid_wait, TASK_INTERRUPTIBLE);
+}
+
 void gfs2_online_uevent(struct gfs2_sbd *sdp)
 {
 	struct super_block *sb = sdp->sd_vfs;
@@ -1194,6 +1213,10 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	if (error)
 		goto fail_locking;
 
+	error = wait_on_journal(sdp);
+	if (error)
+		goto fail_sb;
+
 	error = init_inodes(sdp, DO);
 	if (error)
 		goto fail_sb;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 37f5393..d019d0d 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -325,6 +325,30 @@ static ssize_t lkfirst_show(struct gfs2_sbd *sdp, char *buf)
 	return sprintf(buf, "%d\n", ls->ls_first);
 }
 
+static ssize_t lkfirst_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+	unsigned first;
+	int rv;
+
+	rv = sscanf(buf, "%u", &first);
+	if (rv != 1 || first > 1)
+		return -EINVAL;
+	spin_lock(&sdp->sd_jindex_spin);
+	rv = -EBUSY;
+	if (test_bit(SDF_NOJOURNALID, &sdp->sd_flags) == 0)
+		goto out;
+	rv = -EINVAL;
+	if (sdp->sd_args.ar_spectator)
+		goto out;
+	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
+		goto out;
+        sdp->sd_lockstruct.ls_first = first;
+        rv = 0;
+out:
+        spin_unlock(&sdp->sd_jindex_spin);
+        return rv ? rv : len;
+}
+
 static ssize_t first_done_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
@@ -377,14 +401,41 @@ static ssize_t jid_show(struct gfs2_sbd *sdp, char *buf)
 	return sprintf(buf, "%u\n", sdp->sd_lockstruct.ls_jid);
 }
 
+static ssize_t jid_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+        unsigned jid;
+	int rv;
+
+	rv = sscanf(buf, "%u", &jid);
+	if (rv != 1)
+		return -EINVAL;
+
+	spin_lock(&sdp->sd_jindex_spin);
+	rv = -EINVAL;
+	if (sdp->sd_args.ar_spectator)
+		goto out;
+	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
+		goto out;
+	rv = -EBUSY;
+	if (test_and_clear_bit(SDF_NOJOURNALID, &sdp->sd_flags) == 0)
+		goto out;
+	sdp->sd_lockstruct.ls_jid = jid;
+	smp_mb__after_clear_bit();
+	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
+	rv = 0;
+out:
+	spin_unlock(&sdp->sd_jindex_spin);
+	return rv ? rv : len;
+}
+
 #define GDLM_ATTR(_name,_mode,_show,_store) \
 static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 
 GDLM_ATTR(proto_name,		0444, proto_name_show,		NULL);
 GDLM_ATTR(block,		0644, block_show,		block_store);
 GDLM_ATTR(withdraw,		0644, withdraw_show,		withdraw_store);
-GDLM_ATTR(jid,			0444, jid_show,			NULL);
-GDLM_ATTR(first,		0444, lkfirst_show,		NULL);
+GDLM_ATTR(jid,			0644, jid_show,			jid_store);
+GDLM_ATTR(first,		0644, lkfirst_show,		lkfirst_store);
 GDLM_ATTR(first_done,		0444, first_done_show,		NULL);
 GDLM_ATTR(recover,		0600, NULL,			recover_store);
 GDLM_ATTR(recover_done,		0444, recover_done_show,	NULL);
@@ -564,7 +615,7 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
-	if (!sdp->sd_args.ar_spectator)
+	if (!test_bit(SDF_NOJOURNALID, &sdp->sd_flags))
 		add_uevent_var(env, "JOURNALID=%u", sdp->sd_lockstruct.ls_jid);
 	if (gfs2_uuid_valid(uuid))
 		add_uevent_var(env, "UUID=%pUB", uuid);
-- 
1.7.1.1

