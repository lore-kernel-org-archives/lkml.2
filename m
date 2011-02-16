Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab1BPB3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:29:20 -0500
Received: from kroah.org ([198.145.64.141]:39399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354Ab1BPAVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.222728489@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [132/272] ext4: fix panic on module unload when stopping lazyinit thread
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 8f1f745331c1b560f53c0d60e55a4f4f43f7cce5 upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=27652

If the lazyinit thread is running, the teardown function
ext4_destroy_lazyinit_thread() has problems:

        ext4_clear_request_list();
        while (ext4_li_info->li_task) {
                wake_up(&ext4_li_info->li_wait_daemon);
                wait_event(ext4_li_info->li_wait_task,
                           ext4_li_info->li_task == NULL);
        }

Clearing the request list will cause the thread to exit and free
ext4_li_info, so then we're waiting on something which is getting
freed.

Fix this up by making the thread respond to kthread_stop, and exit,
without the need to wait for that exit in some other homegrown way.

Reported-and-Tested-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -77,6 +77,7 @@ static struct dentry *ext4_mount(struct
 		       const char *dev_name, void *data);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
+static void ext4_clear_request_list(void);
 
 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
@@ -2704,6 +2705,8 @@ static void ext4_unregister_li_request(s
 	mutex_unlock(&ext4_li_info->li_list_mtx);
 }
 
+static struct task_struct *ext4_lazyinit_task;
+
 /*
  * This is the function where ext4lazyinit thread lives. It walks
  * through the request list searching for next scheduled filesystem.
@@ -2772,6 +2775,10 @@ cont_thread:
 		if (time_before(jiffies, next_wakeup))
 			schedule();
 		finish_wait(&eli->li_wait_daemon, &wait);
+		if (kthread_should_stop()) {
+			ext4_clear_request_list();
+			goto exit_thread;
+		}
 	}
 
 exit_thread:
@@ -2796,6 +2803,7 @@ exit_thread:
 	wake_up(&eli->li_wait_task);
 
 	kfree(ext4_li_info);
+	ext4_lazyinit_task = NULL;
 	ext4_li_info = NULL;
 	mutex_unlock(&ext4_li_mtx);
 
@@ -2818,11 +2826,10 @@ static void ext4_clear_request_list(void
 
 static int ext4_run_lazyinit_thread(void)
 {
-	struct task_struct *t;
-
-	t = kthread_run(ext4_lazyinit_thread, ext4_li_info, "ext4lazyinit");
-	if (IS_ERR(t)) {
-		int err = PTR_ERR(t);
+	ext4_lazyinit_task = kthread_run(ext4_lazyinit_thread,
+					 ext4_li_info, "ext4lazyinit");
+	if (IS_ERR(ext4_lazyinit_task)) {
+		int err = PTR_ERR(ext4_lazyinit_task);
 		ext4_clear_request_list();
 		del_timer_sync(&ext4_li_info->li_timer);
 		kfree(ext4_li_info);
@@ -2973,16 +2980,10 @@ static void ext4_destroy_lazyinit_thread
 	 * If thread exited earlier
 	 * there's nothing to be done.
 	 */
-	if (!ext4_li_info)
+	if (!ext4_li_info || !ext4_lazyinit_task)
 		return;
 
-	ext4_clear_request_list();
-
-	while (ext4_li_info->li_task) {
-		wake_up(&ext4_li_info->li_wait_daemon);
-		wait_event(ext4_li_info->li_wait_task,
-			   ext4_li_info->li_task == NULL);
-	}
+	kthread_stop(ext4_lazyinit_task);
 }
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)


