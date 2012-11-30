Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2K3KST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab2K3KSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/16] GFS2: Review bug traps in glops.c
Date: Fri, 30 Nov 2012 09:52:06 +0000
Message-Id: <1354269141-3311-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of the bug traps here could really be warnings. The others are
converted from BUG() to GLOCK_BUG_ON() since we'll most likely
need to know the glock state in order to debug any issues which
arise. As a result of this, __dump_glock has to be renamed and
is no longer static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e6c2fd5..e543871 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -55,8 +55,6 @@ struct gfs2_glock_iter {
 
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
-static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
-#define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { __dump_glock(NULL, gl); BUG(); } } while(0)
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
 
 static struct dentry *gfs2_root;
@@ -1013,7 +1011,7 @@ trap_recursive:
 	printk(KERN_ERR "pid: %d\n", pid_nr(gh->gh_owner_pid));
 	printk(KERN_ERR "lock type: %d req lock state : %d\n",
 	       gh->gh_gl->gl_name.ln_type, gh->gh_state);
-	__dump_glock(NULL, gl);
+	gfs2_dump_glock(NULL, gl);
 	BUG();
 }
 
@@ -1508,7 +1506,7 @@ static int dump_glock(struct seq_file *seq, struct gfs2_glock *gl)
 {
 	int ret;
 	spin_lock(&gl->gl_spin);
-	ret = __dump_glock(seq, gl);
+	ret = gfs2_dump_glock(seq, gl);
 	spin_unlock(&gl->gl_spin);
 	return ret;
 }
@@ -1655,7 +1653,7 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 }
 
 /**
- * __dump_glock - print information about a glock
+ * gfs2_dump_glock - print information about a glock
  * @seq: The seq_file struct
  * @gl: the glock
  *
@@ -1672,7 +1670,7 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
  * Returns: 0 on success, -ENOBUFS when we run out of space
  */
 
-static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
+int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	unsigned long long dtime;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 307ac31..fd580b7 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -178,33 +178,33 @@ static inline struct address_space *gfs2_glock2aspace(struct gfs2_glock *gl)
 	return NULL;
 }
 
-int gfs2_glock_get(struct gfs2_sbd *sdp,
-		   u64 number, const struct gfs2_glock_operations *glops,
-		   int create, struct gfs2_glock **glp);
-void gfs2_glock_hold(struct gfs2_glock *gl);
-void gfs2_glock_put_nolock(struct gfs2_glock *gl);
-void gfs2_glock_put(struct gfs2_glock *gl);
-void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
-		      struct gfs2_holder *gh);
-void gfs2_holder_reinit(unsigned int state, unsigned flags,
-			struct gfs2_holder *gh);
-void gfs2_holder_uninit(struct gfs2_holder *gh);
-int gfs2_glock_nq(struct gfs2_holder *gh);
-int gfs2_glock_poll(struct gfs2_holder *gh);
-int gfs2_glock_wait(struct gfs2_holder *gh);
-void gfs2_glock_dq(struct gfs2_holder *gh);
-void gfs2_glock_dq_wait(struct gfs2_holder *gh);
-
-void gfs2_glock_dq_uninit(struct gfs2_holder *gh);
-int gfs2_glock_nq_num(struct gfs2_sbd *sdp,
-		      u64 number, const struct gfs2_glock_operations *glops,
-		      unsigned int state, int flags, struct gfs2_holder *gh);
-
-int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
-void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
-void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
-
-__printf(2, 3)
+extern int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
+			  const struct gfs2_glock_operations *glops,
+			  int create, struct gfs2_glock **glp);
+extern void gfs2_glock_hold(struct gfs2_glock *gl);
+extern void gfs2_glock_put_nolock(struct gfs2_glock *gl);
+extern void gfs2_glock_put(struct gfs2_glock *gl);
+extern void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state,
+			     unsigned flags, struct gfs2_holder *gh);
+extern void gfs2_holder_reinit(unsigned int state, unsigned flags,
+			       struct gfs2_holder *gh);
+extern void gfs2_holder_uninit(struct gfs2_holder *gh);
+extern int gfs2_glock_nq(struct gfs2_holder *gh);
+extern int gfs2_glock_poll(struct gfs2_holder *gh);
+extern int gfs2_glock_wait(struct gfs2_holder *gh);
+extern void gfs2_glock_dq(struct gfs2_holder *gh);
+extern void gfs2_glock_dq_wait(struct gfs2_holder *gh);
+extern void gfs2_glock_dq_uninit(struct gfs2_holder *gh);
+extern int gfs2_glock_nq_num(struct gfs2_sbd *sdp, u64 number,
+			     const struct gfs2_glock_operations *glops,
+			     unsigned int state, int flags,
+			     struct gfs2_holder *gh);
+extern int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
+extern void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
+extern void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
+extern int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
+#define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { gfs2_dump_glock(NULL, gl); BUG(); } } while(0)
+extern __printf(2, 3)
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
 
 /**
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 32cc4fd..0a3e7c7 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -74,7 +74,7 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 
 		gfs2_trans_add_revoke(sdp, bd);
 	}
-	BUG_ON(!fsync && atomic_read(&gl->gl_ail_count));
+	GLOCK_BUG_ON(gl, !fsync && atomic_read(&gl->gl_ail_count));
 	spin_unlock(&sdp->sd_ail_lock);
 	gfs2_log_unlock(sdp);
 }
@@ -96,7 +96,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	tr.tr_ip = (unsigned long)__builtin_return_address(0);
 	sb_start_intwrite(sdp->sd_vfs);
 	gfs2_log_reserve(sdp, tr.tr_reserved);
-	BUG_ON(current->journal_info);
+	WARN_ON_ONCE(current->journal_info);
 	current->journal_info = &tr;
 
 	__gfs2_ail_flush(gl, 0);
@@ -139,7 +139,7 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 
 	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
 		return;
-	BUG_ON(gl->gl_state != LM_ST_EXCLUSIVE);
+	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
 	gfs2_log_flush(gl->gl_sbd, gl);
 	filemap_fdatawrite(metamapping);
@@ -168,7 +168,7 @@ static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 {
 	struct address_space *mapping = gfs2_glock2aspace(gl);
 
-	BUG_ON(!(flags & DIO_METADATA));
+	WARN_ON_ONCE(!(flags & DIO_METADATA));
 	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
 	truncate_inode_pages(mapping, 0);
 
@@ -197,7 +197,7 @@ static void inode_go_sync(struct gfs2_glock *gl)
 	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
 		return;
 
-	BUG_ON(gl->gl_state != LM_ST_EXCLUSIVE);
+	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
 	gfs2_log_flush(gl->gl_sbd, gl);
 	filemap_fdatawrite(metamapping);
-- 
1.7.4

