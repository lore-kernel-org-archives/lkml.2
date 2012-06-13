Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2FMAGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:06:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2FMAGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:06:03 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 3/3] eCryptfs: Make all miscdev functions use daemon ptr in file private_data
Date: Tue, 12 Jun 2012 17:05:40 -0700
Message-Id: <1339545940-11736-4-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
References: <1338061161.4284.16.camel@lappy>
 <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that a pointer to a valid struct ecryptfs_daemon is stored in the
private_data of an opened /dev/ecryptfs file, the remaining miscdev
functions can utilize the pointer rather than looking up the
ecryptfs_daemon at the beginning of each operation.

The security model of /dev/ecryptfs is simplified a little bit with this
patch. Upon opening /dev/ecryptfs, a per-user ecryptfs_daemon is
registered. Another daemon cannot be registered for that user until the
last file reference is released. During the lifetime of the
ecryptfs_daemon, access checks are not performed on the /dev/ecryptfs
operations because it is assumed that the application securely handles
the opened file descriptor and does not unintentionally leak it to
processes that are not trusted.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |   16 ++-----
 fs/ecryptfs/messaging.c       |  105 +++++++----------------------------------
 fs/ecryptfs/miscdev.c         |   98 ++++++++++----------------------------
 3 files changed, 47 insertions(+), 172 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 01a1f85..0deb4f2 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -392,10 +392,7 @@ struct ecryptfs_daemon {
 #define ECRYPTFS_DAEMON_MISCDEV_OPEN 0x00000008
 	u32 flags;
 	u32 num_queued_msg_ctx;
-	struct pid *pid;
-	uid_t euid;
-	struct user_namespace *user_ns;
-	struct task_struct *task;
+	struct file *file;
 	struct mutex mux;
 	struct list_head msg_ctx_out_queue;
 	wait_queue_head_t wait;
@@ -619,9 +616,8 @@ int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
 int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
-int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
-			      struct user_namespace *user_ns, struct pid *pid,
-			      u32 seq);
+int ecryptfs_process_response(struct ecryptfs_daemon *daemon,
+			      struct ecryptfs_message *msg, u32 seq);
 int ecryptfs_send_message(char *data, int data_len,
 			  struct ecryptfs_msg_ctx **msg_ctx);
 int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
@@ -666,8 +662,7 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 				     struct inode *ecryptfs_inode);
 struct page *ecryptfs_get_locked_page(struct inode *inode, loff_t index);
 int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon);
-int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon, uid_t euid,
-				 struct user_namespace *user_ns);
+int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon);
 int ecryptfs_parse_packet_length(unsigned char *data, size_t *size,
 				 size_t *length_size);
 int ecryptfs_write_packet_length(char *dest, size_t size,
@@ -679,8 +674,7 @@ int ecryptfs_send_miscdev(char *data, size_t data_size,
 			  u16 msg_flags, struct ecryptfs_daemon *daemon);
 void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
 int
-ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
-		      struct user_namespace *user_ns, struct pid *pid);
+ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, struct file *file);
 int ecryptfs_init_kthread(void);
 void ecryptfs_destroy_kthread(void);
 int ecryptfs_privileged_open(struct file **lower_file,
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index c11911d..b29bb8b 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -32,8 +32,8 @@ static struct mutex ecryptfs_msg_ctx_lists_mux;
 static struct hlist_head *ecryptfs_daemon_hash;
 struct mutex ecryptfs_daemon_hash_mux;
 static int ecryptfs_hash_bits;
-#define ecryptfs_uid_hash(uid) \
-        hash_long((unsigned long)uid, ecryptfs_hash_bits)
+#define ecryptfs_current_euid_hash(uid) \
+		hash_long((unsigned long)current_euid(), ecryptfs_hash_bits)
 
 static u32 ecryptfs_msg_counter;
 static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
@@ -105,26 +105,24 @@ void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
 
 /**
  * ecryptfs_find_daemon_by_euid
- * @euid: The effective user id which maps to the desired daemon id
- * @user_ns: The namespace in which @euid applies
  * @daemon: If return value is zero, points to the desired daemon pointer
  *
  * Must be called with ecryptfs_daemon_hash_mux held.
  *
- * Search the hash list for the given user id.
+ * Search the hash list for the current effective user id.
  *
  * Returns zero if the user id exists in the list; non-zero otherwise.
  */
-int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon, uid_t euid,
-				 struct user_namespace *user_ns)
+int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon)
 {
 	struct hlist_node *elem;
 	int rc;
 
 	hlist_for_each_entry(*daemon, elem,
-			     &ecryptfs_daemon_hash[ecryptfs_uid_hash(euid)],
-			     euid_chain) {
-		if ((*daemon)->euid == euid && (*daemon)->user_ns == user_ns) {
+			    &ecryptfs_daemon_hash[ecryptfs_current_euid_hash()],
+			    euid_chain) {
+		if ((*daemon)->file->f_cred->euid == current_euid() &&
+		    (*daemon)->file->f_cred->user_ns == current_user_ns()) {
 			rc = 0;
 			goto out;
 		}
@@ -137,9 +135,7 @@ out:
 /**
  * ecryptfs_spawn_daemon - Create and initialize a new daemon struct
  * @daemon: Pointer to set to newly allocated daemon struct
- * @euid: Effective user id for the daemon
- * @user_ns: The namespace in which @euid applies
- * @pid: Process id for the daemon
+ * @file: File used when opening /dev/ecryptfs
  *
  * Must be called ceremoniously while in possession of
  * ecryptfs_sacred_daemon_hash_mux
@@ -147,8 +143,7 @@ out:
  * Returns zero on success; non-zero otherwise
  */
 int
-ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
-		      struct user_namespace *user_ns, struct pid *pid)
+ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, struct file *file)
 {
 	int rc = 0;
 
@@ -159,16 +154,13 @@ ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
 		       "GFP_KERNEL memory\n", __func__, sizeof(**daemon));
 		goto out;
 	}
-	(*daemon)->euid = euid;
-	(*daemon)->user_ns = get_user_ns(user_ns);
-	(*daemon)->pid = get_pid(pid);
-	(*daemon)->task = current;
+	(*daemon)->file = file;
 	mutex_init(&(*daemon)->mux);
 	INIT_LIST_HEAD(&(*daemon)->msg_ctx_out_queue);
 	init_waitqueue_head(&(*daemon)->wait);
 	(*daemon)->num_queued_msg_ctx = 0;
 	hlist_add_head(&(*daemon)->euid_chain,
-		       &ecryptfs_daemon_hash[ecryptfs_uid_hash(euid)]);
+		       &ecryptfs_daemon_hash[ecryptfs_current_euid_hash()]);
 out:
 	return rc;
 }
@@ -188,9 +180,6 @@ int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon)
 	if ((daemon->flags & ECRYPTFS_DAEMON_IN_READ)
 	    || (daemon->flags & ECRYPTFS_DAEMON_IN_POLL)) {
 		rc = -EBUSY;
-		printk(KERN_WARNING "%s: Attempt to destroy daemon with pid "
-		       "[0x%p], but it is in the midst of a read or a poll\n",
-		       __func__, daemon->pid);
 		mutex_unlock(&daemon->mux);
 		goto out;
 	}
@@ -203,12 +192,6 @@ int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon)
 		ecryptfs_msg_ctx_alloc_to_free(msg_ctx);
 	}
 	hlist_del(&daemon->euid_chain);
-	if (daemon->task)
-		wake_up_process(daemon->task);
-	if (daemon->pid)
-		put_pid(daemon->pid);
-	if (daemon->user_ns)
-		put_user_ns(daemon->user_ns);
 	mutex_unlock(&daemon->mux);
 	kzfree(daemon);
 out:
@@ -219,8 +202,6 @@ out:
  * ecryptfs_process_reponse
  * @msg: The ecryptfs message received; the caller should sanity check
  *       msg->data_len and free the memory
- * @pid: The process ID of the userspace application that sent the
- *       message
  * @seq: The sequence number of the message; must match the sequence
  *       number for the existing message context waiting for this
  *       response
@@ -239,16 +220,11 @@ out:
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
-			      struct user_namespace *user_ns, struct pid *pid,
-			      u32 seq)
+int ecryptfs_process_response(struct ecryptfs_daemon *daemon,
+			      struct ecryptfs_message *msg, u32 seq)
 {
-	struct ecryptfs_daemon *uninitialized_var(daemon);
 	struct ecryptfs_msg_ctx *msg_ctx;
 	size_t msg_size;
-	struct nsproxy *nsproxy;
-	struct user_namespace *tsk_user_ns;
-	uid_t ctx_euid;
 	int rc;
 
 	if (msg->index >= ecryptfs_message_buf_len) {
@@ -261,51 +237,6 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 	}
 	msg_ctx = &ecryptfs_msg_ctx_arr[msg->index];
 	mutex_lock(&msg_ctx->mux);
-	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rcu_read_lock();
-	nsproxy = task_nsproxy(msg_ctx->task);
-	if (nsproxy == NULL) {
-		rc = -EBADMSG;
-		printk(KERN_ERR "%s: Receiving process is a zombie. Dropping "
-		       "message.\n", __func__);
-		rcu_read_unlock();
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
-		goto wake_up;
-	}
-	tsk_user_ns = __task_cred(msg_ctx->task)->user_ns;
-	ctx_euid = task_euid(msg_ctx->task);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, ctx_euid, tsk_user_ns);
-	rcu_read_unlock();
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
-	if (rc) {
-		rc = -EBADMSG;
-		printk(KERN_WARNING "%s: User [%d] received a "
-		       "message response from process [0x%p] but does "
-		       "not have a registered daemon\n", __func__,
-		       ctx_euid, pid);
-		goto wake_up;
-	}
-	if (ctx_euid != euid) {
-		rc = -EBADMSG;
-		printk(KERN_WARNING "%s: Received message from user "
-		       "[%d]; expected message from user [%d]\n", __func__,
-		       euid, ctx_euid);
-		goto unlock;
-	}
-	if (tsk_user_ns != user_ns) {
-		rc = -EBADMSG;
-		printk(KERN_WARNING "%s: Received message from user_ns "
-		       "[0x%p]; expected message from user_ns [0x%p]\n",
-		       __func__, user_ns, tsk_user_ns);
-		goto unlock;
-	}
-	if (daemon->pid != pid) {
-		rc = -EBADMSG;
-		printk(KERN_ERR "%s: User [%d] sent a message response "
-		       "from an unrecognized process [0x%p]\n",
-		       __func__, ctx_euid, pid);
-		goto unlock;
-	}
 	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
 		rc = -EINVAL;
 		printk(KERN_WARNING "%s: Desired context element is not "
@@ -328,9 +259,8 @@ int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 	}
 	memcpy(msg_ctx->msg, msg, msg_size);
 	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_DONE;
-	rc = 0;
-wake_up:
 	wake_up_process(msg_ctx->task);
+	rc = 0;
 unlock:
 	mutex_unlock(&msg_ctx->mux);
 out:
@@ -352,14 +282,11 @@ ecryptfs_send_message_locked(char *data, int data_len, u8 msg_type,
 			     struct ecryptfs_msg_ctx **msg_ctx)
 {
 	struct ecryptfs_daemon *daemon;
-	uid_t euid = current_euid();
 	int rc;
 
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
+	rc = ecryptfs_find_daemon_by_euid(&daemon);
 	if (rc || !daemon) {
 		rc = -ENOTCONN;
-		printk(KERN_ERR "%s: User [%d] does not have a daemon "
-		       "registered\n", __func__, euid);
 		goto out;
 	}
 	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 2cd9c3f..358156b 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -33,7 +33,7 @@ static atomic_t ecryptfs_num_miscdev_opens;
 
 /**
  * ecryptfs_miscdev_poll
- * @file: dev file (ignored)
+ * @file: dev file
  * @pt: dev poll table (ignored)
  *
  * Returns the poll mask
@@ -41,20 +41,10 @@ static atomic_t ecryptfs_num_miscdev_opens;
 static unsigned int
 ecryptfs_miscdev_poll(struct file *file, poll_table *pt)
 {
-	struct ecryptfs_daemon *daemon;
+	struct ecryptfs_daemon *daemon = file->private_data;
 	unsigned int mask = 0;
-	uid_t euid = current_euid();
-	int rc;
 
-	mutex_lock(&ecryptfs_daemon_hash_mux);
-	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	if (rc || !daemon) {
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
-		return -EINVAL;
-	}
 	mutex_lock(&daemon->mux);
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		printk(KERN_WARNING "%s: Attempt to poll on zombified "
 		       "daemon\n", __func__);
@@ -79,7 +69,7 @@ out_unlock_daemon:
 /**
  * ecryptfs_miscdev_open
  * @inode: inode of miscdev handle (ignored)
- * @file: file for miscdev handle (ignored)
+ * @file: file for miscdev handle
  *
  * Returns zero on success; non-zero otherwise
  */
@@ -87,7 +77,6 @@ static int
 ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 {
 	struct ecryptfs_daemon *daemon = NULL;
-	uid_t euid = current_euid();
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
@@ -98,30 +87,20 @@ ecryptfs_miscdev_open(struct inode *inode, struct file *file)
 		       "count; rc = [%d]\n", __func__, rc);
 		goto out_unlock_daemon_list;
 	}
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	if (rc || !daemon) {
-		rc = ecryptfs_spawn_daemon(&daemon, euid, current_user_ns(),
-					   task_pid(current));
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to spawn daemon; "
-			       "rc = [%d]\n", __func__, rc);
-			goto out_module_put_unlock_daemon_list;
-		}
-	}
-	mutex_lock(&daemon->mux);
-	if (daemon->pid != task_pid(current)) {
+	rc = ecryptfs_find_daemon_by_euid(&daemon);
+	if (!rc) {
 		rc = -EINVAL;
-		printk(KERN_ERR "%s: pid [0x%p] has registered with euid [%d], "
-		       "but pid [0x%p] has attempted to open the handle "
-		       "instead\n", __func__, daemon->pid, daemon->euid,
-		       task_pid(current));
-		goto out_unlock_daemon;
+		goto out_unlock_daemon_list;
+	}
+	rc = ecryptfs_spawn_daemon(&daemon, file);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to spawn daemon; "
+		       "rc = [%d]\n", __func__, rc);
+		goto out_module_put_unlock_daemon_list;
 	}
+	mutex_lock(&daemon->mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_MISCDEV_OPEN) {
 		rc = -EBUSY;
-		printk(KERN_ERR "%s: Miscellaneous device handle may only be "
-		       "opened once per daemon; pid [0x%p] already has this "
-		       "handle open\n", __func__, daemon->pid);
 		goto out_unlock_daemon;
 	}
 	daemon->flags |= ECRYPTFS_DAEMON_MISCDEV_OPEN;
@@ -140,7 +119,7 @@ out_unlock_daemon_list:
 /**
  * ecryptfs_miscdev_release
  * @inode: inode of fs/ecryptfs/euid handle (ignored)
- * @file: file for fs/ecryptfs/euid handle (ignored)
+ * @file: file for fs/ecryptfs/euid handle
  *
  * This keeps the daemon registered until the daemon sends another
  * ioctl to fs/ecryptfs/ctl or until the kernel module unregisters.
@@ -150,20 +129,18 @@ out_unlock_daemon_list:
 static int
 ecryptfs_miscdev_release(struct inode *inode, struct file *file)
 {
-	struct ecryptfs_daemon *daemon = NULL;
-	uid_t euid = current_euid();
+	struct ecryptfs_daemon *daemon = file->private_data;
 	int rc;
 
-	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	if (rc || !daemon)
-		daemon = file->private_data;
 	mutex_lock(&daemon->mux);
 	BUG_ON(!(daemon->flags & ECRYPTFS_DAEMON_MISCDEV_OPEN));
 	daemon->flags &= ~ECRYPTFS_DAEMON_MISCDEV_OPEN;
 	atomic_dec(&ecryptfs_num_miscdev_opens);
 	mutex_unlock(&daemon->mux);
+
+	mutex_lock(&ecryptfs_daemon_hash_mux);
 	rc = ecryptfs_exorcise_daemon(daemon);
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (rc) {
 		printk(KERN_CRIT "%s: Fatal error whilst attempting to "
 		       "shut down daemon; rc = [%d]. Please report this "
@@ -171,7 +148,6 @@ ecryptfs_miscdev_release(struct inode *inode, struct file *file)
 		BUG();
 	}
 	module_put(THIS_MODULE);
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return rc;
 }
 
@@ -247,7 +223,7 @@ out_unlock:
 
 /**
  * ecryptfs_miscdev_read - format and send message from queue
- * @file: fs/ecryptfs/euid miscdevfs handle (ignored)
+ * @file: miscdevfs handle
  * @buf: User buffer into which to copy the next message on the daemon queue
  * @count: Amount of space available in @buf
  * @ppos: Offset in file (ignored)
@@ -261,43 +237,27 @@ static ssize_t
 ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 		      loff_t *ppos)
 {
-	struct ecryptfs_daemon *daemon;
+	struct ecryptfs_daemon *daemon = file->private_data;
 	struct ecryptfs_msg_ctx *msg_ctx;
 	size_t packet_length_size;
 	char packet_length[ECRYPTFS_MAX_PKT_LEN_SIZE];
 	size_t i;
 	size_t total_length;
-	uid_t euid = current_euid();
 	int rc;
 
-	mutex_lock(&ecryptfs_daemon_hash_mux);
-	/* TODO: Just use file->private_data? */
-	rc = ecryptfs_find_daemon_by_euid(&daemon, euid, current_user_ns());
-	if (rc || !daemon) {
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
-		return -EINVAL;
-	}
 	mutex_lock(&daemon->mux);
-	if (task_pid(current) != daemon->pid) {
-		mutex_unlock(&daemon->mux);
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
-		return -EPERM;
-	}
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		rc = 0;
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		printk(KERN_WARNING "%s: Attempt to read from zombified "
 		       "daemon\n", __func__);
 		goto out_unlock_daemon;
 	}
 	if (daemon->flags & ECRYPTFS_DAEMON_IN_READ) {
 		rc = 0;
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out_unlock_daemon;
 	}
 	/* This daemon will not go away so long as this flag is set */
 	daemon->flags |= ECRYPTFS_DAEMON_IN_READ;
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 check_list:
 	if (list_empty(&daemon->msg_ctx_out_queue)) {
 		mutex_unlock(&daemon->mux);
@@ -381,16 +341,12 @@ out_unlock_daemon:
  * ecryptfs_miscdev_response - miscdevess response to message previously sent to daemon
  * @data: Bytes comprising struct ecryptfs_message
  * @data_size: sizeof(struct ecryptfs_message) + data len
- * @euid: Effective user id of miscdevess sending the miscdev response
- * @user_ns: The namespace in which @euid applies
- * @pid: Miscdevess id of miscdevess sending the miscdev response
  * @seq: Sequence number for miscdev response packet
  *
  * Returns zero on success; non-zero otherwise
  */
-static int ecryptfs_miscdev_response(char *data, size_t data_size,
-				     uid_t euid, struct user_namespace *user_ns,
-				     struct pid *pid, u32 seq)
+static int ecryptfs_miscdev_response(struct ecryptfs_daemon *daemon, char *data,
+				     size_t data_size, u32 seq)
 {
 	struct ecryptfs_message *msg = (struct ecryptfs_message *)data;
 	int rc;
@@ -402,7 +358,7 @@ static int ecryptfs_miscdev_response(char *data, size_t data_size,
 		rc = -EINVAL;
 		goto out;
 	}
-	rc = ecryptfs_process_response(msg, euid, user_ns, pid, seq);
+	rc = ecryptfs_process_response(daemon, msg, seq);
 	if (rc)
 		printk(KERN_ERR
 		       "Error processing response message; rc = [%d]\n", rc);
@@ -412,7 +368,7 @@ out:
 
 /**
  * ecryptfs_miscdev_write - handle write to daemon miscdev handle
- * @file: File for misc dev handle (ignored)
+ * @file: File for misc dev handle
  * @buf: Buffer containing user data
  * @count: Amount of data in @buf
  * @ppos: Pointer to offset in file (ignored)
@@ -427,7 +383,6 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 	u32 seq;
 	size_t packet_size, packet_size_length;
 	char *data;
-	uid_t euid = current_euid();
 	unsigned char packet_size_peek[ECRYPTFS_MAX_PKT_LEN_SIZE];
 	ssize_t rc;
 
@@ -487,10 +442,9 @@ memdup:
 		}
 		memcpy(&counter_nbo, &data[PKT_CTR_OFFSET], PKT_CTR_SIZE);
 		seq = be32_to_cpu(counter_nbo);
-		rc = ecryptfs_miscdev_response(
+		rc = ecryptfs_miscdev_response(file->private_data,
 				&data[PKT_LEN_OFFSET + packet_size_length],
-				packet_size, euid, current_user_ns(),
-				task_pid(current), seq);
+				packet_size, seq);
 		if (rc) {
 			printk(KERN_WARNING "%s: Failed to deliver miscdev "
 			       "response to requesting operation; rc = [%zd]\n",
-- 
1.7.9.5

