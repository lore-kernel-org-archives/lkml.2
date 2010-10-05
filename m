Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0JESWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:22:41 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24969 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab0JESWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:22:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 05 Oct 2010 14:22:37 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] vcs: add poll/fasync support
In-reply-to: <20101004212025.279eca25.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.1010051359330.3107@xanadu.home>
References: <alpine.LFD.2.00.1009302320360.1146@xanadu.home>
 <20101004155454.771f7b70.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1010042323350.3107@xanadu.home>
 <20101004212025.279eca25.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Andrew Morton wrote:

> On Mon, 04 Oct 2010 23:51:25 -0400 (EDT) Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> > On Mon, 4 Oct 2010, Andrew Morton wrote:
> > 
> > > Formally, we need fs.h and notifier.h (at lesat).  I'll fix that up.
> > 
> > I didn't think that notifier.h was necessary as the declaration for 
> > register_vt_notifier() is in vt_kern.h, which also includes notifier.h 
> > itself already.
> 
> bug ;) vt_kern.h could use a forward declaration and save the include.

Sure.

> > As to fs.h... I agree in principle, but I don't see what my patch is 
> > adding that would make fs.h a new requirement. In other words it was 
> > probably required even before, which could justify a patch of its own?
> 
> kill_fasync() declaration.

My point is... that the file already contained lots of stuff before my 
patch, such as the usage of a struct file_operations, that should have 
required fs.h before my patch.  Hence the question if this seemingly 
missing include should be fixed separately as this is unrelated to the 
topic of my patch.  But I'm afraid I've spent too much energy discussing 
this rather unimportant point already to be worth the trouble.

Please consider using the replacement patch below which includes 
various fixes for all the different issues you raised.

----- >8
From: Nicolas Pitre <nico@fluxnic.net>
Date: Mon, 27 Sep 2010 18:32:31 -0400
Subject: [PATCH] vcs: add poll/fasync support

The /dev/vcs* devices are used, amongst other things, by accessibility
applications such as BRLTTY to display the screen content onto refreshable
braille displays.  Currently this is performed by constantly reading from
/dev/vcsa0 whether or not the screen content has changed.  Given the
default braille refresh rate of 25 times per second, this easily qualifies
as the biggest source of wake-up events preventing laptops from entering
deeper power saving states.

To avoid this periodic polling, let's add support for select()/poll() and
SIGIO with the /dev/vcs* devices.  The implemented semantic is to report
data availability whenever the corresponding vt has seen some update after
the last read() operation.  The application still has to lseek() back
as usual in order to read() the new data.

Not to create unwanted overhead, the needed data structure is allocated
and the vt notification callback is registered only when the poll or
fasync method is invoked for the first time per file instance.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
Acked-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index bcce46c..6f7054e 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -35,6 +35,12 @@
 #include <linux/console.h>
 #include <linux/device.h>
 #include <linux/smp_lock.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/signal.h>
+#include <linux/slab.h>
+#include <linux/notifier.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -45,6 +51,86 @@
 #undef addr
 #define HEADER_SIZE	4
 
+struct vcs_poll_data {
+	struct notifier_block notifier;
+	unsigned int cons_num;
+	bool seen_last_update;
+	wait_queue_head_t waitq;
+	struct fasync_struct *fasync;
+};
+
+static int
+vcs_notifier(struct notifier_block *nb, unsigned long code, void *_param)
+{
+	struct vt_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	struct vcs_poll_data *poll =
+		container_of(nb, struct vcs_poll_data, notifier);
+	int currcons = poll->cons_num;
+
+	if (code != VT_UPDATE)
+		return NOTIFY_DONE;
+
+	if (currcons == 0)
+		currcons = fg_console;
+	else
+		currcons--;
+	if (currcons != vc->vc_num)
+		return NOTIFY_DONE;
+
+	poll->seen_last_update = false;
+	wake_up_interruptible(&poll->waitq);
+	kill_fasync(&poll->fasync, SIGIO, POLL_IN);
+	return NOTIFY_OK;
+}
+
+static void
+vcs_poll_data_free(struct vcs_poll_data *poll)
+{
+	unregister_vt_notifier(&poll->notifier);
+	kfree(poll);
+}
+
+static struct vcs_poll_data *
+vcs_poll_data_get(struct file *file)
+{
+	struct vcs_poll_data *poll = file->private_data;
+
+	if (poll)
+		return poll;
+
+	poll = kzalloc(sizeof(*poll), GFP_KERNEL);
+	if (!poll)
+		return NULL;
+	poll->cons_num = iminor(file->f_path.dentry->d_inode) & 127;
+	init_waitqueue_head(&poll->waitq);
+	poll->notifier.notifier_call = vcs_notifier;
+	if (register_vt_notifier(&poll->notifier) != 0) {
+		kfree(poll);
+		return NULL;
+	}
+
+	/*
+	 * This code may be called either through ->poll() or ->fasync().
+	 * If we have two threads using the same file descriptor, they could
+	 * both enter this function, both notice that the structure hasn't
+	 * been allocated yet and go ahead allocating it in parallel, but
+	 * only one of them must survive and be shared otherwise we'd leak
+	 * memory with a dangling notifier callback.
+	 */
+	spin_lock(&file->f_lock);
+	if (!file->private_data) {
+		file->private_data = poll;
+	} else {
+		/* someone else raced ahead of us */
+		vcs_poll_data_free(poll);
+		poll = file->private_data;
+	}
+	spin_unlock(&file->f_lock);
+
+	return poll;
+}
+
 static int
 vcs_size(struct inode *inode)
 {
@@ -102,6 +188,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int currcons = iminor(inode);
 	struct vc_data *vc;
+	struct vcs_poll_data *poll;
 	long pos;
 	long viewed, attr, read;
 	int col, maxcol;
@@ -134,6 +221,9 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	ret = -EINVAL;
 	if (pos < 0)
 		goto unlock_out;
+	poll = file->private_data;
+	if (count && poll)
+		poll->seen_last_update = true;
 	read = 0;
 	ret = 0;
 	while (count) {
@@ -457,6 +547,37 @@ unlock_out:
 	return ret;
 }
 
+static unsigned int
+vcs_poll(struct file *file, poll_table *wait)
+{
+	struct vcs_poll_data *poll = vcs_poll_data_get(file);
+	int ret = 0;
+
+	if (poll) {
+		poll_wait(file, &poll->waitq, wait);
+		if (!poll->seen_last_update)
+			ret = POLLIN | POLLRDNORM;
+	}
+	return ret;
+}
+
+static int
+vcs_fasync(int fd, struct file *file, int on)
+{
+	struct vcs_poll_data *poll = file->private_data;
+
+	if (!poll) {
+		/* don't allocate anything if all we want is disable fasync */
+		if (!on)
+			return 0;
+		poll = vcs_poll_data_get(file);
+		if (!poll)
+			return -ENOMEM;
+	}
+
+	return fasync_helper(fd, file, on, &poll->fasync);
+}
+
 static int
 vcs_open(struct inode *inode, struct file *filp)
 {
@@ -470,11 +591,23 @@ vcs_open(struct inode *inode, struct file *filp)
 	return ret;
 }
 
+static int vcs_release(struct inode *inode, struct file *file)
+{
+	struct vcs_poll_data *poll = file->private_data;
+
+	if (poll)
+		vcs_poll_data_free(poll);
+	return 0;
+}
+
 static const struct file_operations vcs_fops = {
 	.llseek		= vcs_lseek,
 	.read		= vcs_read,
 	.write		= vcs_write,
+	.poll		= vcs_poll,
+	.fasync		= vcs_fasync,
 	.open		= vcs_open,
+	.release	= vcs_release,
 };
 
 static struct class *vc_class;
