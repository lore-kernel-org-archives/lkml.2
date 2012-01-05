Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab2AEQog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:44:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964820Ab2AEQo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:26 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] gfs2: dlm based recovery coordination
Date: Thu,  5 Jan 2012 10:44:17 -0600
Message-Id: <1325781857-7938-6-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new method of managing recovery is an alternative to
the previous approach of using the userland gfs_controld.

- use dlm slot numbers to assign journal id's
- use dlm recovery callbacks to initiate journal recovery
- use a dlm lock to determine the first node to mount fs
- use a dlm lock to track journals that need recovery

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/gfs2/glock.c             |    2 +-
 fs/gfs2/glock.h             |    7 +-
 fs/gfs2/incore.h            |   58 +++-
 fs/gfs2/lock_dlm.c          |  993 ++++++++++++++++++++++++++++++++++++++++++-
 fs/gfs2/main.c              |   10 +
 fs/gfs2/ops_fstype.c        |   29 +-
 fs/gfs2/recovery.c          |    4 +
 fs/gfs2/sys.c               |   33 +-
 fs/gfs2/sys.h               |    2 +
 include/linux/gfs2_ondisk.h |    2 +
 10 files changed, 1098 insertions(+), 42 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 88e8a23..376816f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1353,7 +1353,7 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 	spin_lock(&gl->gl_spin);
 	gl->gl_reply = ret;
 
-	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))) {
+	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags))) {
 		if (gfs2_should_freeze(gl)) {
 			set_bit(GLF_FROZEN, &gl->gl_flags);
 			spin_unlock(&gl->gl_spin);
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 6670711..5b548b07 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -121,8 +121,11 @@ enum {
 
 struct lm_lockops {
 	const char *lm_proto_name;
-	int (*lm_mount) (struct gfs2_sbd *sdp, const char *fsname);
- 	void (*lm_unmount) (struct gfs2_sbd *sdp);
+	int (*lm_mount) (struct gfs2_sbd *sdp, const char *table);
+	void (*lm_first_done) (struct gfs2_sbd *sdp);
+	void (*lm_recovery_result) (struct gfs2_sbd *sdp, unsigned int jid,
+				    unsigned int result);
+	void (*lm_unmount) (struct gfs2_sbd *sdp);
 	void (*lm_withdraw) (struct gfs2_sbd *sdp);
 	void (*lm_put_lock) (struct gfs2_glock *gl);
 	int (*lm_lock) (struct gfs2_glock *gl, unsigned int req_state,
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 892ac37..9182a87 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -139,8 +139,45 @@ struct gfs2_bufdata {
 #define GDLM_STRNAME_BYTES	25
 #define GDLM_LVB_SIZE		32
 
+/*
+ * ls_recover_flags:
+ *
+ * DFL_BLOCK_LOCKS: dlm is in recovery and will grant locks that had been
+ * held by failed nodes whose journals need recovery.  Those locks should
+ * only be used for journal recovery until the journal recovery is done.
+ * This is set by the dlm recover_prep callback and cleared by the
+ * gfs2_control thread when journal recovery is complete.  To avoid
+ * races between recover_prep setting and gfs2_control clearing, recover_spin
+ * is held while changing this bit and reading/writing recover_block
+ * and recover_start.
+ *
+ * DFL_NO_DLM_OPS: dlm lockspace ops/callbacks are not being used.
+ *
+ * DFL_FIRST_MOUNT: this node is the first to mount this fs and is doing
+ * recovery of all journals before allowing other nodes to mount the fs.
+ * This is cleared when FIRST_MOUNT_DONE is set.
+ *
+ * DFL_FIRST_MOUNT_DONE: this node was the first mounter, and has finished
+ * recovery of all journals, and now allows other nodes to mount the fs.
+ *
+ * DFL_MOUNT_DONE: gdlm_mount has completed successfully and cleared
+ * BLOCK_LOCKS for the first time.  The gfs2_control thread should now
+ * control clearing BLOCK_LOCKS for further recoveries.
+ *
+ * DFL_UNMOUNT: gdlm_unmount sets to keep sdp off gfs2_control_wq.
+ *
+ * DFL_DLM_RECOVERY: set while dlm is in recovery, between recover_prep()
+ * and recover_done(), i.e. set while recover_block == recover_start.
+ */
+
 enum {
 	DFL_BLOCK_LOCKS		= 0,
+	DFL_NO_DLM_OPS		= 1,
+	DFL_FIRST_MOUNT		= 2,
+	DFL_FIRST_MOUNT_DONE	= 3,
+	DFL_MOUNT_DONE		= 4,
+	DFL_UNMOUNT		= 5,
+	DFL_DLM_RECOVERY	= 6,
 };
 
 struct lm_lockname {
@@ -504,14 +541,26 @@ struct gfs2_sb_host {
 struct lm_lockstruct {
 	int ls_jid;
 	unsigned int ls_first;
-	unsigned int ls_first_done;
 	unsigned int ls_nodir;
 	const struct lm_lockops *ls_ops;
-	unsigned long ls_flags;
 	dlm_lockspace_t *ls_dlm;
 
-	int ls_recover_jid_done;
-	int ls_recover_jid_status;
+	int ls_recover_jid_done;   /* These two are deprecated, */
+	int ls_recover_jid_status; /* used previously by gfs_controld */
+
+	struct dlm_lksb ls_mounted_lksb; /* mounted_lock */
+	struct dlm_lksb ls_control_lksb; /* control_lock */
+	char ls_control_lvb[GDLM_LVB_SIZE]; /* control_lock lvb */
+	struct completion ls_sync_wait; /* {control,mounted}_{lock,unlock} */
+
+	spinlock_t ls_recover_spin; /* protects following fields */
+	unsigned long ls_recover_flags; /* DFL_ */
+	uint32_t ls_recover_mount; /* gen in first recover_done cb */
+	uint32_t ls_recover_start; /* gen in last recover_done cb */
+	uint32_t ls_recover_block; /* copy recover_start in last recover_prep */
+	uint32_t ls_recover_size; /* size of recover_submit, recover_result */
+	uint32_t *ls_recover_submit; /* gen in last recover_slot cb per jid */
+	uint32_t *ls_recover_result; /* result of last jid recovery */
 };
 
 struct gfs2_sbd {
@@ -549,6 +598,7 @@ struct gfs2_sbd {
 	wait_queue_head_t sd_glock_wait;
 	atomic_t sd_glock_disposal;
 	struct completion sd_locking_init;
+	struct delayed_work sd_control_work;
 
 	/* Inode Stuff */
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index ce85b62..bb8ea8e 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2009 Red Hat, Inc.  All rights reserved.
+ * Copyright 2004-2011 Red Hat, Inc.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -11,12 +11,15 @@
 #include <linux/dlm.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 #include <linux/gfs2_ondisk.h>
 
 #include "incore.h"
 #include "glock.h"
 #include "util.h"
+#include "sys.h"
 
+extern struct workqueue_struct *gfs2_control_wq;
 
 static void gdlm_ast(void *arg)
 {
@@ -185,34 +188,1002 @@ static void gdlm_cancel(struct gfs2_glock *gl)
 	dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_CANCEL, NULL, gl);
 }
 
-static int gdlm_mount(struct gfs2_sbd *sdp, const char *fsname)
+/*
+ * dlm/gfs2 recovery coordination using dlm_recover callbacks
+ *
+ *  1. dlm_controld sees lockspace members change
+ *  2. dlm_controld blocks dlm-kernel locking activity
+ *  3. dlm_controld within dlm-kernel notifies gfs2 (recover_prep)
+ *  4. dlm_controld starts and finishes its own user level recovery
+ *  5. dlm_controld starts dlm-kernel dlm_recoverd to do kernel recovery
+ *  6. dlm_recoverd notifies gfs2 of failed nodes (recover_slot)
+ *  7. dlm_recoverd does its own lock recovery
+ *  8. dlm_recoverd unblocks dlm-kernel locking activity
+ *  9. dlm_recoverd notifies gfs2 when done (recover_done with new generation)
+ * 10. gfs2_control updates control_lock lvb with new generation and jid bits
+ * 11. gfs2_control enqueues journals for gfs2_recover to recover (maybe none)
+ * 12. gfs2_recover dequeues and recovers journals of failed nodes
+ * 13. gfs2_recover provides recovery results to gfs2_control (recovery_result)
+ * 14. gfs2_control updates control_lock lvb jid bits for recovered journals
+ * 15. gfs2_control unblocks normal locking when all journals are recovered
+ *
+ * - failures during recovery
+ *
+ * recover_prep() may set BLOCK_LOCKS (step 3) again before gfs2_control
+ * clears BLOCK_LOCKS (step 15), e.g. another node fails while still
+ * recovering for a prior failure.  gfs2_control needs a way to detect
+ * this so it can leave BLOCK_LOCKS set in step 15.  This is managed using
+ * the recover_block and recover_start values.
+ *
+ * recover_done() provides a new lockspace generation number each time it
+ * is called (step 9).  This generation number is saved as recover_start.
+ * When recover_prep() is called, it sets BLOCK_LOCKS and sets
+ * recover_block = recover_start.  So, while recover_block is equal to
+ * recover_start, BLOCK_LOCKS should remain set.  (recover_spin must
+ * be held around the BLOCK_LOCKS/recover_block/recover_start logic.)
+ *
+ * - more specific gfs2 steps in sequence above
+ *
+ *  3. recover_prep sets BLOCK_LOCKS and sets recover_block = recover_start
+ *  6. recover_slot records any failed jids (maybe none)
+ *  9. recover_done sets recover_start = new generation number
+ * 10. gfs2_control sets control_lock lvb = new gen + bits for failed jids
+ * 12. gfs2_recover does journal recoveries for failed jids identified above
+ * 14. gfs2_control clears control_lock lvb bits for recovered jids
+ * 15. gfs2_control checks if recover_block == recover_start (step 3 occured
+ *     again) then do nothing, otherwise if recover_start > recover_block
+ *     then clear BLOCK_LOCKS.
+ *
+ * - parallel recovery steps across all nodes
+ *
+ * All nodes attempt to update the control_lock lvb with the new generation
+ * number and jid bits, but only the first to get the control_lock EX will
+ * do so; others will see that it's already done (lvb already contains new
+ * generation number.)
+ *
+ * . All nodes get the same recover_prep/recover_slot/recover_done callbacks
+ * . All nodes attempt to set control_lock lvb gen + bits for the new gen
+ * . One node gets control_lock first and writes the lvb, others see it's done
+ * . All nodes attempt to recover jids for which they see control_lock bits set
+ * . One node succeeds for a jid, and that one clears the jid bit in the lvb
+ * . All nodes will eventually see all lvb bits clear and unblock locks
+ *
+ * - is there a problem with clearing an lvb bit that should be set
+ *   and missing a journal recovery?
+ *
+ * 1. jid fails
+ * 2. lvb bit set for step 1
+ * 3. jid recovered for step 1
+ * 4. jid taken again (new mount)
+ * 5. jid fails (for step 4)
+ * 6. lvb bit set for step 5 (will already be set)
+ * 7. lvb bit cleared for step 3
+ *
+ * This is not a problem because the failure in step 5 does not
+ * require recovery, because the mount in step 4 could not have
+ * progressed far enough to unblock locks and access the fs.  The
+ * control_mount() function waits for all recoveries to be complete
+ * for the latest lockspace generation before ever unblocking locks
+ * and returning.  The mount in step 4 waits until the recovery in
+ * step 1 is done.
+ *
+ * - special case of first mounter: first node to mount the fs
+ *
+ * The first node to mount a gfs2 fs needs to check all the journals
+ * and recover any that need recovery before other nodes are allowed
+ * to mount the fs.  (Others may begin mounting, but they must wait
+ * for the first mounter to be done before taking locks on the fs
+ * or accessing the fs.)  This has two parts:
+ *
+ * 1. The mounted_lock tells a node it's the first to mount the fs.
+ * Each node holds the mounted_lock in PR while it's mounted.
+ * Each node tries to acquire the mounted_lock in EX when it mounts.
+ * If a node is granted the mounted_lock EX it means there are no
+ * other mounted nodes (no PR locks exist), and it is the first mounter.
+ * The mounted_lock is demoted to PR when first recovery is done, so
+ * others will fail to get an EX lock, but will get a PR lock.
+ *
+ * 2. The control_lock blocks others in control_mount() while the first
+ * mounter is doing first mount recovery of all journals.
+ * A mounting node needs to acquire control_lock in EX mode before
+ * it can proceed.  The first mounter holds control_lock in EX while doing
+ * the first mount recovery, blocking mounts from other nodes, then demotes
+ * control_lock to NL when it's done (others_may_mount/first_done),
+ * allowing other nodes to continue mounting.
+ *
+ * first mounter:
+ * control_lock EX/NOQUEUE success
+ * mounted_lock EX/NOQUEUE success (no other PR, so no other mounters)
+ * set first=1
+ * do first mounter recovery
+ * mounted_lock EX->PR
+ * control_lock EX->NL, write lvb generation
+ *
+ * other mounter:
+ * control_lock EX/NOQUEUE success (if fail -EAGAIN, retry)
+ * mounted_lock EX/NOQUEUE fail -EAGAIN (expected due to other mounters PR)
+ * mounted_lock PR/NOQUEUE success
+ * read lvb generation
+ * control_lock EX->NL
+ * set first=0
+ *
+ * - mount during recovery
+ *
+ * If a node mounts while others are doing recovery (not first mounter),
+ * the mounting node will get its initial recover_done() callback without
+ * having seen any previous failures/callbacks.
+ *
+ * It must wait for all recoveries preceding its mount to be finished
+ * before it unblocks locks.  It does this by repeating the "other mounter"
+ * steps above until the lvb generation number is >= its mount generation
+ * number (from initial recover_done) and all lvb bits are clear.
+ *
+ * - control_lock lvb format
+ *
+ * 4 bytes generation number: the latest dlm lockspace generation number
+ * from recover_done callback.  Indicates the jid bitmap has been updated
+ * to reflect all slot failures through that generation.
+ * 4 bytes unused.
+ * GDLM_LVB_SIZE-8 bytes of jid bit map. If bit N is set, it indicates
+ * that jid N needs recovery.
+ */
+
+#define JID_BITMAP_OFFSET 8 /* 4 byte generation number + 4 byte unused */
+
+static void control_lvb_read(struct lm_lockstruct *ls, uint32_t *lvb_gen,
+			     char *lvb_bits)
+{
+	uint32_t gen;
+	memcpy(lvb_bits, ls->ls_control_lvb, GDLM_LVB_SIZE);
+	memcpy(&gen, lvb_bits, sizeof(uint32_t));
+	*lvb_gen = le32_to_cpu(gen);
+}
+
+static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
+			      char *lvb_bits)
+{
+	uint32_t gen;
+	memcpy(ls->ls_control_lvb, lvb_bits, GDLM_LVB_SIZE);
+	gen = cpu_to_le32(lvb_gen);
+	memcpy(ls->ls_control_lvb, &gen, sizeof(uint32_t));
+}
+
+static int all_jid_bits_clear(char *lvb)
+{
+	int i;
+	for (i = JID_BITMAP_OFFSET; i < GDLM_LVB_SIZE; i++) {
+		if (lvb[i])
+			return 0;
+	}
+	return 1;
+}
+
+static void sync_wait_cb(void *arg)
+{
+	struct lm_lockstruct *ls = arg;
+	complete(&ls->ls_sync_wait);
+}
+
+static int sync_unlock(struct gfs2_sbd *sdp, struct dlm_lksb *lksb, char *name)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	int error;
 
-	if (fsname == NULL) {
-		fs_info(sdp, "no fsname found\n");
-		return -EINVAL;
+	error = dlm_unlock(ls->ls_dlm, lksb->sb_lkid, 0, lksb, ls);
+	if (error) {
+		fs_err(sdp, "%s lkid %x error %d\n",
+		       name, lksb->sb_lkid, error);
+		return error;
+	}
+
+	wait_for_completion(&ls->ls_sync_wait);
+
+	if (lksb->sb_status != -DLM_EUNLOCK) {
+		fs_err(sdp, "%s lkid %x status %d\n",
+		       name, lksb->sb_lkid, lksb->sb_status);
+		return -1;
+	}
+	return 0;
+}
+
+static int sync_lock(struct gfs2_sbd *sdp, int mode, uint32_t flags,
+		     unsigned int num, struct dlm_lksb *lksb, char *name)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	char strname[GDLM_STRNAME_BYTES];
+	int error, status;
+
+	memset(strname, 0, GDLM_STRNAME_BYTES);
+	snprintf(strname, GDLM_STRNAME_BYTES, "%8x%16x", LM_TYPE_NONDISK, num);
+
+	error = dlm_lock(ls->ls_dlm, mode, lksb, flags,
+			 strname, GDLM_STRNAME_BYTES - 1,
+			 0, sync_wait_cb, ls, NULL);
+	if (error) {
+		fs_err(sdp, "%s lkid %x flags %x mode %d error %d\n",
+		       name, lksb->sb_lkid, flags, mode, error);
+		return error;
+	}
+
+	wait_for_completion(&ls->ls_sync_wait);
+
+	status = lksb->sb_status;
+
+	if (status && status != -EAGAIN) {
+		fs_err(sdp, "%s lkid %x flags %x mode %d status %d\n",
+		       name, lksb->sb_lkid, flags, mode, status);
+	}
+
+	return status;
+}
+
+static int mounted_unlock(struct gfs2_sbd *sdp)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sync_unlock(sdp, &ls->ls_mounted_lksb, "mounted_lock");
+}
+
+static int mounted_lock(struct gfs2_sbd *sdp, int mode, uint32_t flags)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sync_lock(sdp, mode, flags, GFS2_MOUNTED_LOCK,
+			 &ls->ls_mounted_lksb, "mounted_lock");
+}
+
+static int control_unlock(struct gfs2_sbd *sdp)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sync_unlock(sdp, &ls->ls_control_lksb, "control_lock");
+}
+
+static int control_lock(struct gfs2_sbd *sdp, int mode, uint32_t flags)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sync_lock(sdp, mode, flags, GFS2_CONTROL_LOCK,
+			 &ls->ls_control_lksb, "control_lock");
+}
+
+static void gfs2_control_func(struct work_struct *work)
+{
+	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_control_work.work);
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	char lvb_bits[GDLM_LVB_SIZE];
+	uint32_t block_gen, start_gen, lvb_gen, flags;
+	int recover_set = 0;
+	int write_lvb = 0;
+	int recover_size;
+	int i, error;
+
+	spin_lock(&ls->ls_recover_spin);
+	/*
+	 * No MOUNT_DONE means we're still mounting; control_mount()
+	 * will set this flag, after which this thread will take over
+	 * all further clearing of BLOCK_LOCKS.
+	 *
+	 * FIRST_MOUNT means this node is doing first mounter recovery,
+	 * for which recovery control is handled by
+	 * control_mount()/control_first_done(), not this thread.
+	 */
+	if (!test_bit(DFL_MOUNT_DONE, &ls->ls_recover_flags) ||
+	     test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags)) {
+		spin_unlock(&ls->ls_recover_spin);
+		return;
+	}
+	block_gen = ls->ls_recover_block;
+	start_gen = ls->ls_recover_start;
+	spin_unlock(&ls->ls_recover_spin);
+
+	/*
+	 * Equal block_gen and start_gen implies we are between
+	 * recover_prep and recover_done callbacks, which means
+	 * dlm recovery is in progress and dlm locking is blocked.
+	 * There's no point trying to do any work until recover_done.
+	 */
+
+	if (block_gen == start_gen)
+		return;
+
+	/*
+	 * Propagate recover_submit[] and recover_result[] to lvb:
+	 * dlm_recoverd adds to recover_submit[] jids needing recovery
+	 * gfs2_recover adds to recover_result[] journal recovery results
+	 *
+	 * set lvb bit for jids in recover_submit[] if the lvb has not
+	 * yet been updated for the generation of the failure
+	 *
+	 * clear lvb bit for jids in recover_result[] if the result of
+	 * the journal recovery is SUCCESS
+	 */
+
+	error = control_lock(sdp, DLM_LOCK_EX, DLM_LKF_CONVERT|DLM_LKF_VALBLK);
+	if (error) {
+		fs_err(sdp, "control lock EX error %d\n", error);
+		return;
+	}
+
+	control_lvb_read(ls, &lvb_gen, lvb_bits);
+
+	spin_lock(&ls->ls_recover_spin);
+	if (block_gen != ls->ls_recover_block ||
+	    start_gen != ls->ls_recover_start) {
+		fs_info(sdp, "recover generation %u block1 %u %u\n",
+			start_gen, block_gen, ls->ls_recover_block);
+		spin_unlock(&ls->ls_recover_spin);
+		control_lock(sdp, DLM_LOCK_NL, DLM_LKF_CONVERT);
+		return;
+	}
+
+	recover_size = ls->ls_recover_size;
+
+	if (lvb_gen <= start_gen) {
+		/*
+		 * Clear lvb bits for jids we've successfully recovered.
+		 * Because all nodes attempt to recover failed journals,
+		 * a journal can be recovered multiple times successfully
+		 * in succession.  Only the first will really do recovery,
+		 * the others find it clean, but still report a successful
+		 * recovery.  So, another node may have already recovered
+		 * the jid and cleared the lvb bit for it.
+		 */
+		for (i = 0; i < recover_size; i++) {
+			if (ls->ls_recover_result[i] != LM_RD_SUCCESS)
+				continue;
+
+			ls->ls_recover_result[i] = 0;
+
+			if (!test_bit_le(i, lvb_bits+JID_BITMAP_OFFSET))
+				continue;
+
+			__clear_bit_le(i, lvb_bits+JID_BITMAP_OFFSET);
+			write_lvb = 1;
+		}
+	}
+
+	if (lvb_gen == start_gen) {
+		/*
+		 * Failed slots before start_gen are already set in lvb.
+		 */
+		for (i = 0; i < recover_size; i++) {
+			if (!ls->ls_recover_submit[i])
+				continue;
+			if (ls->ls_recover_submit[i] < lvb_gen)
+				ls->ls_recover_submit[i] = 0;
+		}
+	} else if (lvb_gen < start_gen) {
+		/*
+		 * Failed slots before start_gen are not yet set in lvb.
+		 */
+		for (i = 0; i < recover_size; i++) {
+			if (!ls->ls_recover_submit[i])
+				continue;
+			if (ls->ls_recover_submit[i] < start_gen) {
+				ls->ls_recover_submit[i] = 0;
+				__set_bit_le(i, lvb_bits+JID_BITMAP_OFFSET);
+			}
+		}
+		/* even if there are no bits to set, we need to write the
+		   latest generation to the lvb */
+		write_lvb = 1;
+	} else {
+		/*
+		 * we should be getting a recover_done() for lvb_gen soon
+		 */
+	}
+	spin_unlock(&ls->ls_recover_spin);
+
+	if (write_lvb) {
+		control_lvb_write(ls, start_gen, lvb_bits);
+		flags = DLM_LKF_CONVERT | DLM_LKF_VALBLK;
+	} else {
+		flags = DLM_LKF_CONVERT;
+	}
+
+	error = control_lock(sdp, DLM_LOCK_NL, flags);
+	if (error) {
+		fs_err(sdp, "control lock NL error %d\n", error);
+		return;
+	}
+
+	/*
+	 * Everyone will see jid bits set in the lvb, run gfs2_recover_set(),
+	 * and clear a jid bit in the lvb if the recovery is a success.
+	 * Eventually all journals will be recovered, all jid bits will
+	 * be cleared in the lvb, and everyone will clear BLOCK_LOCKS.
+	 */
+
+	for (i = 0; i < recover_size; i++) {
+		if (test_bit_le(i, lvb_bits+JID_BITMAP_OFFSET)) {
+			fs_info(sdp, "recover generation %u jid %d\n",
+				start_gen, i);
+			gfs2_recover_set(sdp, i);
+			recover_set++;
+		}
+	}
+	if (recover_set)
+		return;
+
+	/*
+	 * No more jid bits set in lvb, all recovery is done, unblock locks
+	 * (unless a new recover_prep callback has occured blocking locks
+	 * again while working above)
+	 */
+
+	spin_lock(&ls->ls_recover_spin);
+	if (ls->ls_recover_block == block_gen &&
+	    ls->ls_recover_start == start_gen) {
+		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
+		spin_unlock(&ls->ls_recover_spin);
+		fs_info(sdp, "recover generation %u done\n", start_gen);
+		gfs2_glock_thaw(sdp);
+	} else {
+		fs_info(sdp, "recover generation %u block2 %u %u\n",
+			start_gen, block_gen, ls->ls_recover_block);
+		spin_unlock(&ls->ls_recover_spin);
+	}
+}
+
+static int control_mount(struct gfs2_sbd *sdp)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	char lvb_bits[GDLM_LVB_SIZE];
+	uint32_t start_gen, block_gen, mount_gen, lvb_gen;
+	int mounted_mode;
+	int retries = 0;
+	int error;
+
+	memset(&ls->ls_mounted_lksb, 0, sizeof(struct dlm_lksb));
+	memset(&ls->ls_control_lksb, 0, sizeof(struct dlm_lksb));
+	memset(&ls->ls_control_lvb, 0, GDLM_LVB_SIZE);
+	ls->ls_control_lksb.sb_lvbptr = ls->ls_control_lvb;
+	init_completion(&ls->ls_sync_wait);
+
+	set_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
+
+	error = control_lock(sdp, DLM_LOCK_NL, DLM_LKF_VALBLK);
+	if (error) {
+		fs_err(sdp, "control_mount control_lock NL error %d\n", error);
+		return error;
+	}
+
+	error = mounted_lock(sdp, DLM_LOCK_NL, 0);
+	if (error) {
+		fs_err(sdp, "control_mount mounted_lock NL error %d\n", error);
+		control_unlock(sdp);
+		return error;
+	}
+	mounted_mode = DLM_LOCK_NL;
+
+restart:
+	if (retries++ && signal_pending(current)) {
+		error = -EINTR;
+		goto fail;
+	}
+
+	/*
+	 * We always start with both locks in NL. control_lock is
+	 * demoted to NL below so we don't need to do it here.
+	 */
+
+	if (mounted_mode != DLM_LOCK_NL) {
+		error = mounted_lock(sdp, DLM_LOCK_NL, DLM_LKF_CONVERT);
+		if (error)
+			goto fail;
+		mounted_mode = DLM_LOCK_NL;
+	}
+
+	/*
+	 * Other nodes need to do some work in dlm recovery and gfs2_control
+	 * before the recover_done and control_lock will be ready for us below.
+	 * A delay here is not required but often avoids having to retry.
+	 */
+
+	msleep_interruptible(500);
+
+	/*
+	 * Acquire control_lock in EX and mounted_lock in either EX or PR.
+	 * control_lock lvb keeps track of any pending journal recoveries.
+	 * mounted_lock indicates if any other nodes have the fs mounted.
+	 */
+
+	error = control_lock(sdp, DLM_LOCK_EX, DLM_LKF_CONVERT|DLM_LKF_NOQUEUE|DLM_LKF_VALBLK);
+	if (error == -EAGAIN) {
+		goto restart;
+	} else if (error) {
+		fs_err(sdp, "control_mount control_lock EX error %d\n", error);
+		goto fail;
+	}
+
+	error = mounted_lock(sdp, DLM_LOCK_EX, DLM_LKF_CONVERT|DLM_LKF_NOQUEUE);
+	if (!error) {
+		mounted_mode = DLM_LOCK_EX;
+		goto locks_done;
+	} else if (error != -EAGAIN) {
+		fs_err(sdp, "control_mount mounted_lock EX error %d\n", error);
+		goto fail;
+	}
+
+	error = mounted_lock(sdp, DLM_LOCK_PR, DLM_LKF_CONVERT|DLM_LKF_NOQUEUE);
+	if (!error) {
+		mounted_mode = DLM_LOCK_PR;
+		goto locks_done;
+	} else {
+		/* not even -EAGAIN should happen here */
+		fs_err(sdp, "control_mount mounted_lock PR error %d\n", error);
+		goto fail;
+	}
+
+locks_done:
+	/*
+	 * If we got both locks above in EX, then we're the first mounter.
+	 * If not, then we need to wait for the control_lock lvb to be
+	 * updated by other mounted nodes to reflect our mount generation.
+	 *
+	 * In simple first mounter cases, first mounter will see zero lvb_gen,
+	 * but in cases where all existing nodes leave/fail before mounting
+	 * nodes finish control_mount, then all nodes will be mounting and
+	 * lvb_gen will be non-zero.
+	 */
+
+	control_lvb_read(ls, &lvb_gen, lvb_bits);
+
+	if (lvb_gen == 0xFFFFFFFF) {
+		/* special value to force mount attempts to fail */
+		fs_err(sdp, "control_mount control_lock disabled\n");
+		error = -EINVAL;
+		goto fail;
+	}
+
+	if (mounted_mode == DLM_LOCK_EX) {
+		/* first mounter, keep both EX while doing first recovery */
+		spin_lock(&ls->ls_recover_spin);
+		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
+		set_bit(DFL_MOUNT_DONE, &ls->ls_recover_flags);
+		set_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags);
+		spin_unlock(&ls->ls_recover_spin);
+		fs_info(sdp, "first mounter control generation %u\n", lvb_gen);
+		return 0;
+	}
+
+	error = control_lock(sdp, DLM_LOCK_NL, DLM_LKF_CONVERT);
+	if (error)
+		goto fail;
+
+	/*
+	 * We are not first mounter, now we need to wait for the control_lock
+	 * lvb generation to be >= the generation from our first recover_done
+	 * and all lvb bits to be clear (no pending journal recoveries.)
+	 */
+
+	if (!all_jid_bits_clear(lvb_bits)) {
+		/* journals need recovery, wait until all are clear */
+		fs_info(sdp, "control_mount wait for journal recovery\n");
+		goto restart;
+	}
+
+	spin_lock(&ls->ls_recover_spin);
+	block_gen = ls->ls_recover_block;
+	start_gen = ls->ls_recover_start;
+	mount_gen = ls->ls_recover_mount;
+
+	if (lvb_gen < mount_gen) {
+		/* wait for mounted nodes to update control_lock lvb to our
+		   generation, which might include new recovery bits set */
+		fs_info(sdp, "control_mount wait1 block %u start %u mount %u "
+			"lvb %u flags %lx\n", block_gen, start_gen, mount_gen,
+			lvb_gen, ls->ls_recover_flags);
+		spin_unlock(&ls->ls_recover_spin);
+		goto restart;
+	}
+
+	if (lvb_gen != start_gen) {
+		/* wait for mounted nodes to update control_lock lvb to the
+		   latest recovery generation */
+		fs_info(sdp, "control_mount wait2 block %u start %u mount %u "
+			"lvb %u flags %lx\n", block_gen, start_gen, mount_gen,
+			lvb_gen, ls->ls_recover_flags);
+		spin_unlock(&ls->ls_recover_spin);
+		goto restart;
+	}
+
+	if (block_gen == start_gen) {
+		/* dlm recovery in progress, wait for it to finish */
+		fs_info(sdp, "control_mount wait3 block %u start %u mount %u "
+			"lvb %u flags %lx\n", block_gen, start_gen, mount_gen,
+			lvb_gen, ls->ls_recover_flags);
+		spin_unlock(&ls->ls_recover_spin);
+		goto restart;
 	}
 
-	error = dlm_new_lockspace(fsname, NULL, 
-				  DLM_LSFL_FS | DLM_LSFL_NEWEXCL |
-				  (ls->ls_nodir ? DLM_LSFL_NODIR : 0),
-				  GDLM_LVB_SIZE, NULL, NULL, NULL, &ls->ls_dlm);
+	clear_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
+	set_bit(DFL_MOUNT_DONE, &ls->ls_recover_flags);
+	memset(ls->ls_recover_submit, 0, ls->ls_recover_size*sizeof(uint32_t));
+	memset(ls->ls_recover_result, 0, ls->ls_recover_size*sizeof(uint32_t));
+	spin_unlock(&ls->ls_recover_spin);
+	return 0;
+
+fail:
+	mounted_unlock(sdp);
+	control_unlock(sdp);
+	return error;
+}
+
+static int dlm_recovery_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
+static int control_first_done(struct gfs2_sbd *sdp)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	char lvb_bits[GDLM_LVB_SIZE];
+	uint32_t start_gen, block_gen;
+	int error;
+
+restart:
+	spin_lock(&ls->ls_recover_spin);
+	start_gen = ls->ls_recover_start;
+	block_gen = ls->ls_recover_block;
+
+	if (test_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags) ||
+	    !test_bit(DFL_MOUNT_DONE, &ls->ls_recover_flags) ||
+	    !test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags)) {
+		/* sanity check, should not happen */
+		fs_err(sdp, "control_first_done start %u block %u flags %lx\n",
+		       start_gen, block_gen, ls->ls_recover_flags);
+		spin_unlock(&ls->ls_recover_spin);
+		control_unlock(sdp);
+		return -1;
+	}
+
+	if (start_gen == block_gen) {
+		/*
+		 * Wait for the end of a dlm recovery cycle to switch from
+		 * first mounter recovery.  We can ignore any recover_slot
+		 * callbacks between the recover_prep and next recover_done
+		 * because we are still the first mounter and any failed nodes
+		 * have not fully mounted, so they don't need recovery.
+		 */
+		spin_unlock(&ls->ls_recover_spin);
+		fs_info(sdp, "control_first_done wait gen %u\n", start_gen);
+
+		wait_on_bit(&ls->ls_recover_flags, DFL_DLM_RECOVERY,
+			    dlm_recovery_wait, TASK_UNINTERRUPTIBLE);
+		goto restart;
+	}
+
+	clear_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags);
+	set_bit(DFL_FIRST_MOUNT_DONE, &ls->ls_recover_flags);
+	memset(ls->ls_recover_submit, 0, ls->ls_recover_size*sizeof(uint32_t));
+	memset(ls->ls_recover_result, 0, ls->ls_recover_size*sizeof(uint32_t));
+	spin_unlock(&ls->ls_recover_spin);
+
+	memset(lvb_bits, 0, sizeof(lvb_bits));
+	control_lvb_write(ls, start_gen, lvb_bits);
+
+	error = mounted_lock(sdp, DLM_LOCK_PR, DLM_LKF_CONVERT);
+	if (error)
+		fs_err(sdp, "control_first_done mounted PR error %d\n", error);
+
+	error = control_lock(sdp, DLM_LOCK_NL, DLM_LKF_CONVERT|DLM_LKF_VALBLK);
 	if (error)
-		printk(KERN_ERR "dlm_new_lockspace error %d", error);
+		fs_err(sdp, "control_first_done control NL error %d\n", error);
 
 	return error;
 }
 
+/*
+ * Expand static jid arrays if necessary (by increments of RECOVER_SIZE_INC)
+ * to accomodate the largest slot number.  (NB dlm slot numbers start at 1,
+ * gfs2 jids start at 0, so jid = slot - 1)
+ */
+
+#define RECOVER_SIZE_INC 16
+
+static int set_recover_size(struct gfs2_sbd *sdp, struct dlm_slot *slots,
+			    int num_slots)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	uint32_t *submit = NULL;
+	uint32_t *result = NULL;
+	uint32_t old_size, new_size;
+	int i, max_jid;
+
+	max_jid = 0;
+	for (i = 0; i < num_slots; i++) {
+		if (max_jid < slots[i].slot - 1)
+			max_jid = slots[i].slot - 1;
+	}
+
+	old_size = ls->ls_recover_size;
+
+	if (old_size >= max_jid + 1)
+		return 0;
+
+	new_size = old_size + RECOVER_SIZE_INC;
+
+	submit = kzalloc(new_size * sizeof(uint32_t), GFP_NOFS);
+	result = kzalloc(new_size * sizeof(uint32_t), GFP_NOFS);
+	if (!submit || !result) {
+		kfree(submit);
+		kfree(result);
+		return -ENOMEM;
+	}
+
+	spin_lock(&ls->ls_recover_spin);
+	memcpy(submit, ls->ls_recover_submit, old_size * sizeof(uint32_t));
+	memcpy(result, ls->ls_recover_result, old_size * sizeof(uint32_t));
+	kfree(ls->ls_recover_submit);
+	kfree(ls->ls_recover_result);
+	ls->ls_recover_submit = submit;
+	ls->ls_recover_result = result;
+	ls->ls_recover_size = new_size;
+	spin_unlock(&ls->ls_recover_spin);
+	return 0;
+}
+
+static void free_recover_size(struct lm_lockstruct *ls)
+{
+	kfree(ls->ls_recover_submit);
+	kfree(ls->ls_recover_result);
+	ls->ls_recover_submit = NULL;
+	ls->ls_recover_result = NULL;
+	ls->ls_recover_size = 0;
+}
+
+/* dlm calls before it does lock recovery */
+
+static void gdlm_recover_prep(void *arg)
+{
+	struct gfs2_sbd *sdp = arg;
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
+	spin_lock(&ls->ls_recover_spin);
+	ls->ls_recover_block = ls->ls_recover_start;
+	set_bit(DFL_DLM_RECOVERY, &ls->ls_recover_flags);
+
+	if (!test_bit(DFL_MOUNT_DONE, &ls->ls_recover_flags) ||
+	     test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags)) {
+		spin_unlock(&ls->ls_recover_spin);
+		return;
+	}
+	set_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
+	spin_unlock(&ls->ls_recover_spin);
+}
+
+/* dlm calls after recover_prep has been completed on all lockspace members;
+   identifies slot/jid of failed member */
+
+static void gdlm_recover_slot(void *arg, struct dlm_slot *slot)
+{
+	struct gfs2_sbd *sdp = arg;
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	int jid = slot->slot - 1;
+
+	spin_lock(&ls->ls_recover_spin);
+	if (ls->ls_recover_size < jid + 1) {
+		fs_err(sdp, "recover_slot jid %d gen %u short size %d",
+		       jid, ls->ls_recover_block, ls->ls_recover_size);
+		spin_unlock(&ls->ls_recover_spin);
+		return;
+	}
+
+	if (ls->ls_recover_submit[jid]) {
+		fs_info(sdp, "recover_slot jid %d gen %u prev %u",
+			jid, ls->ls_recover_block, ls->ls_recover_submit[jid]);
+	}
+	ls->ls_recover_submit[jid] = ls->ls_recover_block;
+	spin_unlock(&ls->ls_recover_spin);
+}
+
+/* dlm calls after recover_slot and after it completes lock recovery */
+
+static void gdlm_recover_done(void *arg, struct dlm_slot *slots, int num_slots,
+			      int our_slot, uint32_t generation)
+{
+	struct gfs2_sbd *sdp = arg;
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
+	/* ensure the ls jid arrays are large enough */
+	set_recover_size(sdp, slots, num_slots);
+
+	spin_lock(&ls->ls_recover_spin);
+	ls->ls_recover_start = generation;
+
+	if (!ls->ls_recover_mount) {
+		ls->ls_recover_mount = generation;
+		ls->ls_jid = our_slot - 1;
+	}
+
+	if (!test_bit(DFL_UNMOUNT, &ls->ls_recover_flags))
+		queue_delayed_work(gfs2_control_wq, &sdp->sd_control_work, 0);
+
+	clear_bit(DFL_DLM_RECOVERY, &ls->ls_recover_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&ls->ls_recover_flags, DFL_DLM_RECOVERY);
+	spin_unlock(&ls->ls_recover_spin);
+}
+
+/* gfs2_recover thread has a journal recovery result */
+
+static void gdlm_recovery_result(struct gfs2_sbd *sdp, unsigned int jid,
+				 unsigned int result)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
+	if (test_bit(DFL_NO_DLM_OPS, &ls->ls_recover_flags))
+		return;
+
+	/* don't care about the recovery of own journal during mount */
+	if (jid == ls->ls_jid)
+		return;
+
+	spin_lock(&ls->ls_recover_spin);
+	if (test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags)) {
+		spin_unlock(&ls->ls_recover_spin);
+		return;
+	}
+	if (ls->ls_recover_size < jid + 1) {
+		fs_err(sdp, "recovery_result jid %d short size %d",
+		       jid, ls->ls_recover_size);
+		spin_unlock(&ls->ls_recover_spin);
+		return;
+	}
+
+	fs_info(sdp, "recover jid %d result %s\n", jid,
+		result == LM_RD_GAVEUP ? "busy" : "success");
+
+	ls->ls_recover_result[jid] = result;
+
+	/* GAVEUP means another node is recovering the journal; delay our
+	   next attempt to recover it, to give the other node a chance to
+	   finish before trying again */
+
+	if (!test_bit(DFL_UNMOUNT, &ls->ls_recover_flags))
+		queue_delayed_work(gfs2_control_wq, &sdp->sd_control_work,
+				   result == LM_RD_GAVEUP ? HZ : 0);
+	spin_unlock(&ls->ls_recover_spin);
+}
+
+const struct dlm_lockspace_ops gdlm_lockspace_ops = {
+	.recover_prep = gdlm_recover_prep,
+	.recover_slot = gdlm_recover_slot,
+	.recover_done = gdlm_recover_done,
+};
+
+static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	char cluster[GFS2_LOCKNAME_LEN];
+	const char *fsname;
+	uint32_t flags;
+	int error, ops_result;
+
+	/*
+	 * initialize everything
+	 */
+
+	INIT_DELAYED_WORK(&sdp->sd_control_work, gfs2_control_func);
+	spin_lock_init(&ls->ls_recover_spin);
+	ls->ls_recover_flags = 0;
+	ls->ls_recover_mount = 0;
+	ls->ls_recover_start = 0;
+	ls->ls_recover_block = 0;
+	ls->ls_recover_size = 0;
+	ls->ls_recover_submit = NULL;
+	ls->ls_recover_result = NULL;
+
+	error = set_recover_size(sdp, NULL, 0);
+	if (error)
+		goto fail;
+
+	/*
+	 * prepare dlm_new_lockspace args
+	 */
+
+	fsname = strchr(table, ':');
+	if (!fsname) {
+		fs_info(sdp, "no fsname found\n");
+		error = -EINVAL;
+		goto fail_free;
+	}
+	memset(cluster, 0, sizeof(cluster));
+	memcpy(cluster, table, strlen(table) - strlen(fsname));
+	fsname++;
+
+	flags = DLM_LSFL_FS | DLM_LSFL_NEWEXCL;
+	if (ls->ls_nodir)
+		flags |= DLM_LSFL_NODIR;
+
+	/*
+	 * create/join lockspace
+	 */
+
+	error = dlm_new_lockspace(fsname, cluster, flags, GDLM_LVB_SIZE,
+				  &gdlm_lockspace_ops, sdp, &ops_result,
+				  &ls->ls_dlm);
+	if (error) {
+		fs_err(sdp, "dlm_new_lockspace error %d\n", error);
+		goto fail_free;
+	}
+
+	if (ops_result < 0) {
+		/*
+		 * dlm does not support ops callbacks,
+		 * old dlm_controld/gfs_controld are used, try without ops.
+		 */
+		fs_info(sdp, "dlm lockspace ops not used\n");
+		free_recover_size(ls);
+		set_bit(DFL_NO_DLM_OPS, &ls->ls_recover_flags);
+		return 0;
+	}
+
+	if (!test_bit(SDF_NOJOURNALID, &sdp->sd_flags)) {
+		fs_err(sdp, "dlm lockspace ops disallow jid preset\n");
+		error = -EINVAL;
+		goto fail_release;
+	}
+
+	/*
+	 * control_mount() uses control_lock to determine first mounter,
+	 * and for later mounts, waits for any recoveries to be cleared.
+	 */
+
+	error = control_mount(sdp);
+	if (error) {
+		fs_err(sdp, "mount control error %d\n", error);
+		goto fail_release;
+	}
+
+	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
+	ls->ls_first = !!test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags);
+	return 0;
+
+fail_release:
+	dlm_release_lockspace(ls->ls_dlm, 2);
+fail_free:
+	free_recover_size(ls);
+fail:
+	return error;
+}
+
+static void gdlm_first_done(struct gfs2_sbd *sdp)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	int error;
+
+	if (test_bit(DFL_NO_DLM_OPS, &ls->ls_recover_flags))
+		return;
+
+	error = control_first_done(sdp);
+	if (error)
+		fs_err(sdp, "mount first_done error %d\n", error);
+}
+
 static void gdlm_unmount(struct gfs2_sbd *sdp)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 
+	if (test_bit(DFL_NO_DLM_OPS, &ls->ls_recover_flags))
+		goto release;
+
+	/* wait for gfs2_control_wq to be done with this mount */
+
+	spin_lock(&ls->ls_recover_spin);
+	set_bit(DFL_UNMOUNT, &ls->ls_recover_flags);
+	spin_unlock(&ls->ls_recover_spin);
+	flush_delayed_work_sync(&sdp->sd_control_work);
+
+	/* mounted_lock and control_lock will be purged in dlm recovery */
+release:
 	if (ls->ls_dlm) {
 		dlm_release_lockspace(ls->ls_dlm, 2);
 		ls->ls_dlm = NULL;
 	}
+
+	free_recover_size(ls);
 }
 
 static const match_table_t dlm_tokens = {
@@ -226,6 +1197,8 @@ static const match_table_t dlm_tokens = {
 const struct lm_lockops gfs2_dlm_ops = {
 	.lm_proto_name = "lock_dlm",
 	.lm_mount = gdlm_mount,
+	.lm_first_done = gdlm_first_done,
+	.lm_recovery_result = gdlm_recovery_result,
 	.lm_unmount = gdlm_unmount,
 	.lm_put_lock = gdlm_put_lock,
 	.lm_lock = gdlm_lock,
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 8a139ff..d59ecec 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -28,6 +28,8 @@
 #include "recovery.h"
 #include "dir.h"
 
+struct workqueue_struct *gfs2_control_wq;
+
 static struct shrinker qd_shrinker = {
 	.shrink = gfs2_shrink_qd_memory,
 	.seeks = DEFAULT_SEEKS,
@@ -145,12 +147,19 @@ static int __init init_gfs2_fs(void)
 	if (!gfs_recovery_wq)
 		goto fail_wq;
 
+	gfs2_control_wq = alloc_workqueue("gfs2_control",
+			       WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE, 0);
+	if (!gfs2_control_wq)
+		goto fail_control;
+
 	gfs2_register_debugfs();
 
 	printk("GFS2 installed\n");
 
 	return 0;
 
+fail_control:
+	destroy_workqueue(gfs_recovery_wq);
 fail_wq:
 	unregister_filesystem(&gfs2meta_fs_type);
 fail_unregister:
@@ -194,6 +203,7 @@ static void __exit exit_gfs2_fs(void)
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
 	destroy_workqueue(gfs_recovery_wq);
+	destroy_workqueue(gfs2_control_wq);
 
 	rcu_barrier();
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 079587e..0df89da 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -562,8 +562,12 @@ static void gfs2_others_may_mount(struct gfs2_sbd *sdp)
 {
 	char *message = "FIRSTMOUNT=Done";
 	char *envp[] = { message, NULL };
-	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	ls->ls_first_done = 1;
+
+	fs_info(sdp, "first mount done, others may mount\n");
+
+	if (sdp->sd_lockstruct.ls_ops->lm_first_done)
+		sdp->sd_lockstruct.ls_ops->lm_first_done(sdp);
+
 	kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
 }
 
@@ -947,7 +951,6 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 	struct gfs2_args *args = &sdp->sd_args;
 	const char *proto = sdp->sd_proto_name;
 	const char *table = sdp->sd_table_name;
-	const char *fsname;
 	char *o, *options;
 	int ret;
 
@@ -1007,21 +1010,12 @@ hostdata_error:
 		}
 	}
 
-	if (sdp->sd_args.ar_spectator)
-		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.s", table);
-	else
-		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.%u", table,
-			 sdp->sd_lockstruct.ls_jid);
-
-	fsname = strchr(table, ':');
-	if (fsname)
-		fsname++;
 	if (lm->lm_mount == NULL) {
 		fs_info(sdp, "Now mounting FS...\n");
 		complete_all(&sdp->sd_locking_init);
 		return 0;
 	}
-	ret = lm->lm_mount(sdp, fsname);
+	ret = lm->lm_mount(sdp, table);
 	if (ret == 0)
 		fs_info(sdp, "Joined cluster. Now mounting FS...\n");
 	complete_all(&sdp->sd_locking_init);
@@ -1127,6 +1121,8 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	if (error)
 		goto fail;
 
+	snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s", sdp->sd_table_name);
+
 	gfs2_create_debugfs_file(sdp);
 
 	error = gfs2_sys_fs_add(sdp);
@@ -1163,6 +1159,13 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 		goto fail_sb;
 	}
 
+	if (sdp->sd_args.ar_spectator)
+		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.s",
+			 sdp->sd_table_name);
+	else
+		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.%u",
+			 sdp->sd_table_name, sdp->sd_lockstruct.ls_jid);
+
 	error = init_inodes(sdp, DO);
 	if (error)
 		goto fail_sb;
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index f2a02ed..af49e8f 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -436,12 +436,16 @@ static void gfs2_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
 	char env_status[20];
 	char *envp[] = { env_jid, env_status, NULL };
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
         ls->ls_recover_jid_done = jid;
         ls->ls_recover_jid_status = message;
 	sprintf(env_jid, "JID=%d", jid);
 	sprintf(env_status, "RECOVERY=%s",
 		message == LM_RD_SUCCESS ? "Done" : "Failed");
         kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
+
+	if (sdp->sd_lockstruct.ls_ops->lm_recovery_result)
+		sdp->sd_lockstruct.ls_ops->lm_recovery_result(sdp, jid, message);
 }
 
 void gfs2_recover_func(struct work_struct *work)
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 443cabc..d33172c 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -298,7 +298,7 @@ static ssize_t block_show(struct gfs2_sbd *sdp, char *buf)
 	ssize_t ret;
 	int val = 0;
 
-	if (test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))
+	if (test_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags))
 		val = 1;
 	ret = sprintf(buf, "%d\n", val);
 	return ret;
@@ -313,9 +313,9 @@ static ssize_t block_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	val = simple_strtol(buf, NULL, 0);
 
 	if (val == 1)
-		set_bit(DFL_BLOCK_LOCKS, &ls->ls_flags);
+		set_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
 	else if (val == 0) {
-		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_flags);
+		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
 		smp_mb__after_clear_bit();
 		gfs2_glock_thaw(sdp);
 	} else {
@@ -350,8 +350,8 @@ static ssize_t lkfirst_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 		goto out;
 	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
 		goto out;
-        sdp->sd_lockstruct.ls_first = first;
-        rv = 0;
+	sdp->sd_lockstruct.ls_first = first;
+	rv = 0;
 out:
         spin_unlock(&sdp->sd_jindex_spin);
         return rv ? rv : len;
@@ -360,19 +360,14 @@ out:
 static ssize_t first_done_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	return sprintf(buf, "%d\n", ls->ls_first_done);
+	return sprintf(buf, "%d\n", !!test_bit(DFL_FIRST_MOUNT_DONE, &ls->ls_recover_flags));
 }
 
-static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+int gfs2_recover_set(struct gfs2_sbd *sdp, unsigned jid)
 {
-	unsigned jid;
 	struct gfs2_jdesc *jd;
 	int rv;
 
-	rv = sscanf(buf, "%u", &jid);
-	if (rv != 1)
-		return -EINVAL;
-
 	rv = -ESHUTDOWN;
 	spin_lock(&sdp->sd_jindex_spin);
 	if (test_bit(SDF_NORECOVERY, &sdp->sd_flags))
@@ -389,6 +384,20 @@ static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	}
 out:
 	spin_unlock(&sdp->sd_jindex_spin);
+	return rv;
+}
+
+static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+	unsigned jid;
+	int rv;
+
+	rv = sscanf(buf, "%u", &jid);
+	if (rv != 1)
+		return -EINVAL;
+
+	rv = gfs2_recover_set(sdp, jid);
+
 	return rv ? rv : len;
 }
 
diff --git a/fs/gfs2/sys.h b/fs/gfs2/sys.h
index e94560e..79182d6 100644
--- a/fs/gfs2/sys.h
+++ b/fs/gfs2/sys.h
@@ -19,5 +19,7 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp);
 int gfs2_sys_init(void);
 void gfs2_sys_uninit(void);
 
+int gfs2_recover_set(struct gfs2_sbd *sdp, unsigned jid);
+
 #endif /* __SYS_DOT_H__ */
 
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 4f44629..b148087 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -22,6 +22,8 @@
 #define GFS2_LIVE_LOCK		1
 #define GFS2_TRANS_LOCK		2
 #define GFS2_RENAME_LOCK	3
+#define GFS2_CONTROL_LOCK	4
+#define GFS2_MOUNTED_LOCK	5
 
 /* Format numbers for various metadata types */
 
-- 
1.7.6

