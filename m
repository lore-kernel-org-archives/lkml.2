Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0JTUYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:24:14 -0400
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:44651 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab0JTUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:23:52 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        Yoshihisa Abe <yoshiabe@cs.cmu.edu>, Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [RFC][PATCH 3/3] Coda: replace BKL with mutex
Date: Wed, 20 Oct 2010 16:23:04 -0400
Message-Id: <1287606184-26889-4-git-send-email-jaharkes@cs.cmu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
References: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihisa Abe <yoshiabe@cs.cmu.edu>

Replace the BKL with a mutex to provide atomicity during mounting and to
protect access to the upcall queues in struct venus_comm.

Signed-off-by: Yoshihisa Abe <yoshiabe@cs.cmu.edu>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
---
 fs/coda/inode.c            |   44 ++++++++++++++++++++++++++++++--------------
 fs/coda/psdev.c            |   28 +++++++++++++++++-----------
 fs/coda/upcall.c           |   13 ++++++++-----
 include/linux/coda_psdev.h |    2 ++
 4 files changed, 57 insertions(+), 30 deletions(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index d287bed..3b94b7a 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/file.h>
 #include <linux/vfs.h>
@@ -144,7 +145,7 @@ static int get_device_index(struct coda_mount_data *data)
 static int coda_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *root = NULL;
-	struct venus_comm *vc = NULL;
+	struct venus_comm *vc;
 	struct CodaFid fid;
 	int error;
 	int idx;
@@ -158,21 +159,26 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	printk(KERN_INFO "coda_read_super: device index: %i\n", idx);
 
 	vc = &coda_comms[idx];
+	mutex_lock(&vc->vc_mutex);
+
 	if (!vc->vc_inuse) {
 		printk("coda_read_super: No pseudo device\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto unlock_out;
 	}
 
-        if ( vc->vc_sb ) {
+	if (vc->vc_sb) {
 		printk("coda_read_super: Device already mounted\n");
-		return -EBUSY;
+		error = -EBUSY;
+		goto unlock_out;
 	}
 
 	error = bdi_setup_and_register(&vc->bdi, "coda", BDI_CAP_MAP_COPY);
 	if (error)
-		goto bdi_err;
+		goto unlock_out;
 
 	vc->vc_sb = sb;
+	mutex_unlock(&vc->vc_mutex);
 
 	sb->s_fs_info = vc;
 	sb->s_flags |= MS_NOATIME;
@@ -201,26 +207,36 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	printk("coda_read_super: rootinode is %ld dev %s\n", 
 	       root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root)
+	if (!sb->s_root) {
+		error = -EINVAL;
 		goto error;
+	}
         return 0;
 
- error:
-	bdi_destroy(&vc->bdi);
- bdi_err:
+error:
 	if (root)
 		iput(root);
-	if (vc)
-		vc->vc_sb = NULL;
 
-	return -EINVAL;
+	mutex_lock(&vc->vc_mutex);
+	bdi_destroy(&vc->bdi);
+	vc->vc_sb = NULL;
+	sb->s_fs_info = NULL;
+	mutex_unlock(&vc->vc_mutex);
+	return error;
+
+unlock_out:
+	mutex_unlock(&vc->vc_mutex);
+	return error;
 }
 
 static void coda_put_super(struct super_block *sb)
 {
-	bdi_destroy(&coda_vcp(sb)->bdi);
-	coda_vcp(sb)->vc_sb = NULL;
+	struct venus_comm *vcp = coda_vcp(sb);
+	mutex_lock(&vcp->vc_mutex);
+	bdi_destroy(&vcp->bdi);
+	vcp->vc_sb = NULL;
 	sb->s_fs_info = NULL;
+	mutex_unlock(&vcp->vc_mutex);
 
 	printk("Coda: Bye bye.\n");
 }
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index f786759..d815c24 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -35,7 +35,7 @@
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/device.h>
 #include <asm/io.h>
 #include <asm/system.h>
@@ -67,8 +67,10 @@ static unsigned int coda_psdev_poll(struct file *file, poll_table * wait)
 	unsigned int mask = POLLOUT | POLLWRNORM;
 
 	poll_wait(file, &vcp->vc_waitq, wait);
+	mutex_lock(&vcp->vc_mutex);
 	if (!list_empty(&vcp->vc_pending))
                 mask |= POLLIN | POLLRDNORM;
+	mutex_unlock(&vcp->vc_mutex);
 
 	return mask;
 }
@@ -150,7 +152,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 	}
         
 	/* Look for the message on the processing queue. */
-	lock_kernel();
+	mutex_lock(&vcp->vc_mutex);
 	list_for_each(lh, &vcp->vc_processing) {
 		tmp = list_entry(lh, struct upc_req , uc_chain);
 		if (tmp->uc_unique == hdr.unique) {
@@ -159,7 +161,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 			break;
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&vcp->vc_mutex);
 
 	if (!req) {
 		printk("psdev_write: msg (%d, %d) not found\n", 
@@ -214,7 +216,7 @@ static ssize_t coda_psdev_read(struct file * file, char __user * buf,
 	if (nbytes == 0)
 		return 0;
 
-	lock_kernel();
+	mutex_lock(&vcp->vc_mutex);
 
 	add_wait_queue(&vcp->vc_waitq, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
@@ -228,7 +230,9 @@ static ssize_t coda_psdev_read(struct file * file, char __user * buf,
 			retval = -ERESTARTSYS;
 			break;
 		}
+		mutex_unlock(&vcp->vc_mutex);
 		schedule();
+		mutex_lock(&vcp->vc_mutex);
 	}
 
 	set_current_state(TASK_RUNNING);
@@ -261,7 +265,7 @@ static ssize_t coda_psdev_read(struct file * file, char __user * buf,
 	CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
 	kfree(req);
 out:
-	unlock_kernel();
+	mutex_unlock(&vcp->vc_mutex);
 	return (count ? count : retval);
 }
 
@@ -274,10 +278,10 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 	if (idx < 0 || idx >= MAX_CODADEVS)
 		return -ENODEV;
 
-	lock_kernel();
-
 	err = -EBUSY;
 	vcp = &coda_comms[idx];
+	mutex_lock(&vcp->vc_mutex);
+
 	if (!vcp->vc_inuse) {
 		vcp->vc_inuse++;
 
@@ -291,7 +295,7 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 		err = 0;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&vcp->vc_mutex);
 	return err;
 }
 
@@ -306,7 +310,7 @@ static int coda_psdev_release(struct inode * inode, struct file * file)
 		return -1;
 	}
 
-	lock_kernel();
+	mutex_lock(&vcp->vc_mutex);
 
 	/* Wakeup clients so they can return. */
 	list_for_each_entry_safe(req, tmp, &vcp->vc_pending, uc_chain) {
@@ -331,7 +335,7 @@ static int coda_psdev_release(struct inode * inode, struct file * file)
 
 	file->private_data = NULL;
 	vcp->vc_inuse--;
-	unlock_kernel();
+	mutex_unlock(&vcp->vc_mutex);
 	return 0;
 }
 
@@ -359,9 +363,11 @@ static int init_coda_psdev(void)
 		err = PTR_ERR(coda_psdev_class);
 		goto out_chrdev;
 	}		
-	for (i = 0; i < MAX_CODADEVS; i++)
+	for (i = 0; i < MAX_CODADEVS; i++) {
+		mutex_init(&(&coda_comms[i])->vc_mutex);
 		device_create(coda_psdev_class, NULL,
 			      MKDEV(CODA_PSDEV_MAJOR, i), NULL, "cfs%d", i);
+	}
 	coda_sysctl_init();
 	goto out;
 
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index e53847f..e41b906 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -27,7 +27,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
@@ -607,7 +607,8 @@ static void coda_unblock_signals(sigset_t *old)
 				 (r)->uc_opcode != CODA_RELEASE) || \
 				(r)->uc_flags & CODA_REQ_READ))
 
-static inline void coda_waitfor_upcall(struct upc_req *req)
+static inline void coda_waitfor_upcall(struct venus_comm *vcp,
+				       struct upc_req *req)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long timeout = jiffies + coda_timeout * HZ;
@@ -640,10 +641,12 @@ static inline void coda_waitfor_upcall(struct upc_req *req)
 			break;
 		}
 
+		mutex_unlock(&vcp->vc_mutex);
 		if (blocked)
 			schedule_timeout(HZ);
 		else
 			schedule();
+		mutex_lock(&vcp->vc_mutex);
 	}
 	if (blocked)
 		coda_unblock_signals(&old);
@@ -671,7 +674,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	struct upc_req *req = NULL, *sig_req;
 	int error;
 
-	lock_kernel();
+	mutex_lock(&vcp->vc_mutex);
 
 	if (!vcp->vc_inuse) {
 		printk(KERN_NOTICE "coda: Venus dead, not sending upcall\n");
@@ -711,7 +714,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	 * ENODEV.  */
 
 	/* Go to sleep.  Wake up on signals only after the timeout. */
-	coda_waitfor_upcall(req);
+	coda_waitfor_upcall(vcp, req);
 
 	/* Op went through, interrupt or not... */
 	if (req->uc_flags & CODA_REQ_WRITE) {
@@ -765,7 +768,7 @@ static int coda_upcall(struct venus_comm *vcp,
 
 exit:
 	kfree(req);
-	unlock_kernel();
+	mutex_unlock(&vcp->vc_mutex);
 	return error;
 }
 
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 284b520..42a8229 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -8,6 +8,7 @@
 
 #ifdef __KERNEL__
 #include <linux/backing-dev.h>
+#include <linux/mutex.h>
 
 struct kstatfs;
 
@@ -20,6 +21,7 @@ struct venus_comm {
 	int                 vc_inuse;
 	struct super_block *vc_sb;
 	struct backing_dev_info bdi;
+	struct mutex	    vc_mutex;
 };
 
 
-- 
1.6.3.3

