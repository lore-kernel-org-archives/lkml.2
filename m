Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0ICNPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0ICNPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:15:42 -0400
Date: Fri, 3 Sep 2010 15:15:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: getting rid of __GFP_NOFAIL in tty_add_file
Message-ID: <20100903131537.GF1894@jolsa.brq.redhat.com>
References: <1283444276-19355-1-git-send-email-jolsa@redhat.com>
 <20100902200950.GE16897@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902200950.GE16897@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 01:09:50PM -0700, Greg KH wrote:
> On Thu, Sep 02, 2010 at 06:17:56PM +0200, Jiri Olsa wrote:
> > hi,
> > 
> > added error handling for struct tty_file_private allocation,
> > Fixed error paths in tty_open and ptmx_open.
> 
> Heh, look at the linux-next tree, there's already a patch from Pekka in
> there that does this, but in a little different way.  Let me know if
> that version doesn't work for you.

cool ;)

I think the current error paths do not release some memory
 - tty_struct in tty_open path
 - tty_struct/dev_pts_index/inode in ptmx_open error paths

question is if that's a big deal in case we were not able to allocate
as much as struct tty_file_private..

I'm attaching my patch rebased for linux-next, but I would not mind
this one being omitted for the reason above.

thanks,
jirka

---
Added error handling for struct tty_file_private allocation,
Fixed error paths in tty_open and ptmx_open.


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/char/pty.c    |   31 +++++++++++++++++------------
 drivers/char/tty_io.c |   52 +++++++++++++++++++++++++++++++-----------------
 include/linux/tty.h   |    5 +++-
 3 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 923a485..08a449c 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -652,17 +652,24 @@ static const struct tty_operations pty_unix98_ops = {
 static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
+	struct tty_file_private *priv;
 	int retval;
 	int index;
 
 	nonseekable_open(inode, filp);
 
+	priv = alloc_tty_priv();
+	if (!priv)
+		return -ENOMEM;
+
 	/* find a device that is not in use. */
 	tty_lock();
 	index = devpts_new_index(inode);
 	tty_unlock();
-	if (index < 0)
+	if (index < 0) {
+		free_tty_priv(priv);
 		return index;
+	}
 
 	mutex_lock(&tty_mutex);
 	tty_lock();
@@ -671,32 +678,30 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	if (IS_ERR(tty)) {
 		retval = PTR_ERR(tty);
+		free_tty_priv(priv);
+		devpts_kill_index(inode, index);
 		goto out;
 	}
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
-
-	retval = tty_add_file(tty, filp);
-	if (retval)
-		goto out;
+	tty_set_priv(priv, tty, filp);
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
-		goto out1;
+		goto out_release;
 
 	retval = ptm_driver->ops->open(tty, filp);
 	if (retval)
-		goto out2;
-out1:
-	tty_unlock();
-	return retval;
-out2:
+		goto out_release;
+
+out:
 	tty_unlock();
-	tty_release(inode, filp);
 	return retval;
-out:
+
+out_release:
 	devpts_kill_index(inode, index);
 	tty_unlock();
+	tty_release(inode, filp);
 	return retval;
 }
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d6c659f..5071d01 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -195,35 +195,44 @@ static inline struct tty_struct *file_tty(struct file *file)
 	return ((struct tty_file_private *)file->private_data)->tty;
 }
 
-/* Associate a new file with the tty structure */
-int tty_add_file(struct tty_struct *tty, struct file *file)
+struct tty_file_private *alloc_tty_priv(void)
 {
 	struct tty_file_private *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	priv = kmalloc(sizeof(struct tty_file_private), GFP_KERNEL);
+	if (priv)
+		INIT_LIST_HEAD(&priv->list);
+
+	return priv;
+}
 
+/* Associate a new file with the tty structure */
+void tty_set_priv(struct tty_file_private *priv, struct tty_struct *tty,
+		  struct file *file)
+{
 	priv->tty = tty;
 	priv->file = file;
-	file->private_data = priv;
 
 	spin_lock(&tty_files_lock);
 	list_add(&priv->list, &tty->tty_files);
 	spin_unlock(&tty_files_lock);
 
-	return 0;
+	file->private_data = priv;
 }
 
 /* Delete file from its tty */
-void tty_del_file(struct file *file)
+void free_tty_priv(struct tty_file_private *priv)
 {
-	struct tty_file_private *priv = file->private_data;
+	if (!list_empty(&priv->list)) {
+		struct file *file = priv->file;
+
+		spin_lock(&tty_files_lock);
+		list_del(&priv->list);
+		spin_unlock(&tty_files_lock);
+
+		file->private_data = NULL;
+	}
 
-	spin_lock(&tty_files_lock);
-	list_del(&priv->list);
-	spin_unlock(&tty_files_lock);
-	file->private_data = NULL;
 	kfree(priv);
 }
 
@@ -1713,7 +1722,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	 *  - do_tty_hangup no longer sees this file descriptor as
 	 *    something that needs to be handled for hangups.
 	 */
-	tty_del_file(filp);
+	free_tty_priv(filp->private_data);
 
 	/*
 	 * Perform some housekeeping before deciding whether to return.
@@ -1792,6 +1801,7 @@ int tty_release(struct inode *inode, struct file *filp)
 static int tty_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty = NULL;
+	struct tty_file_private *priv;
 	int noctty, retval;
 	struct tty_driver *driver;
 	int index;
@@ -1866,6 +1876,13 @@ got_driver:
 		}
 	}
 
+	priv = alloc_tty_priv();
+	if (!priv) {
+		tty_unlock();
+		mutex_unlock(&tty_mutex);
+		return -ENOMEM;
+	}
+
 	if (tty) {
 		retval = tty_reopen(tty);
 		if (retval)
@@ -1877,14 +1894,11 @@ got_driver:
 	tty_driver_kref_put(driver);
 	if (IS_ERR(tty)) {
 		tty_unlock();
+		free_tty_priv(priv);
 		return PTR_ERR(tty);
 	}
 
-	retval = tty_add_file(tty, filp);
-	if (retval) {
-		tty_unlock();
-		return retval;
-	}
+	tty_set_priv(priv, tty, filp);
 
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 86be0cd..1520a35 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -465,8 +465,11 @@ extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
+struct tty_file_private *alloc_tty_priv(void);
+void tty_set_priv(struct tty_file_private *priv, struct tty_struct *tty,
+		struct file *file);
+void free_tty_priv(struct tty_file_private *priv);
 extern struct tty_struct *alloc_tty_struct(void);
-extern int tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
-- 
1.7.1

