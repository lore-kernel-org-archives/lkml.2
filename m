Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0EKXen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:34:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52599 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab0EKXdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Andries Brouwer <aeb@cwi.nl>
Subject: [PATCH RFC tip/core/rcu 07/11] fs: remove all rcu head initializations, except on_stack initializations
Date: Tue, 11 May 2010 16:33:02 -0700
Message-Id: <1273620786-20392-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andries Brouwer <aeb@cwi.nl>
---
 fs/file.c             |    3 ---
 fs/fs-writeback.c     |   31 ++++++++++++++++++++++++++-----
 fs/partitions/check.c |    1 -
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..cccaead 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
@@ -430,7 +428,6 @@ struct files_struct init_files = {
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
-		.rcu		= RCU_HEAD_INIT,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4b37f7c..ea38c65 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -75,12 +75,33 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 	return test_bit(WS_ONSTACK_B, &work->state);
 }
 
-static inline void bdi_work_init(struct bdi_work *work,
-				 struct wb_writeback_args *args)
+static inline void __bdi_work_init(struct bdi_work *work,
+				   struct wb_writeback_args *args,
+				   int on_stack)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
+	if (on_stack) {
+		work->state |= WS_ONSTACK;
+		init_rcu_head_on_stack(&work->rcu_head);
+	}
+}
+
+static inline void bdi_work_init(struct bdi_work *work,
+				 struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, false);
+}
+
+static inline void bdi_work_init_on_stack(struct bdi_work *work,
+					  struct wb_writeback_args *args)
+{
+	__bdi_work_init(work, args, true);
+}
+
+static inline void bdi_destroy_work_on_stack(struct bdi_work *work)
+{
+	destroy_rcu_head_on_stack(&work->rcu_head);
 }
 
 /**
@@ -233,11 +254,11 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	};
 	struct bdi_work work;
 
-	bdi_work_init(&work, &args);
-	work.state |= WS_ONSTACK;
+	bdi_work_init_on_stack(&work, &args);
 
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
+	bdi_destroy_work_on_stack(&work);
 }
 
 /**
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..7444e6f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -456,7 +456,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
-- 
1.7.0.6

