Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1GLSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:48:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53261 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1GLSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:48:44 -0400
Subject: [PATCH] fs: seq_file - add event counter to simplify poll() support
From: Kay Sievers <kay.sievers@vrfy.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Andrew Morton akpm"@linux-foundation.org, NeilBrown <neilb@suse.de>,
        "Lucas De Marchi lucas.demarchi"@profusion.mobi
Date: Tue, 12 Jul 2011 20:48:39 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310496523.2193.4.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Al,
any objections? If not, care to pick that up?

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: fs: seq_file - add event counter to simplify poll() support

Moving the event counter into the dynamically allocated 'struc seq_file'
allows poll() support without the need to allocate its own tracking
structure.

All current users are switched over to use the new counter.

Requested-by: Andrew Morton akpm@linux-foundation.org
Acked-by: NeilBrown <neilb@suse.de>
Tested-by: Lucas De Marchi lucas.demarchi@profusion.mobi
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/md/md.c               |   26 ++++++++------------------
 fs/namespace.c                |    4 ++--
 fs/proc/base.c                |    2 +-
 include/linux/mnt_namespace.h |    1 -
 include/linux/seq_file.h      |    1 +
 mm/swapfile.c                 |   29 ++++++++---------------------
 6 files changed, 20 insertions(+), 43 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 91e31e2..dfc9425 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6394,16 +6394,11 @@ static void md_seq_stop(struct seq_file *seq, void *v)
 		mddev_put(mddev);
 }
 
-struct mdstat_info {
-	int event;
-};
-
 static int md_seq_show(struct seq_file *seq, void *v)
 {
 	mddev_t *mddev = v;
 	sector_t sectors;
 	mdk_rdev_t *rdev;
-	struct mdstat_info *mi = seq->private;
 	struct bitmap *bitmap;
 
 	if (v == (void*)1) {
@@ -6415,7 +6410,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 
 		spin_unlock(&pers_lock);
 		seq_printf(seq, "\n");
-		mi->event = atomic_read(&md_event_count);
+		seq->poll_event = atomic_read(&md_event_count);
 		return 0;
 	}
 	if (v == (void*)2) {
@@ -6527,26 +6522,21 @@ static const struct seq_operations md_seq_ops = {
 
 static int md_seq_open(struct inode *inode, struct file *file)
 {
+	struct seq_file *seq;
 	int error;
-	struct mdstat_info *mi = kmalloc(sizeof(*mi), GFP_KERNEL);
-	if (mi == NULL)
-		return -ENOMEM;
 
 	error = seq_open(file, &md_seq_ops);
 	if (error)
-		kfree(mi);
-	else {
-		struct seq_file *p = file->private_data;
-		p->private = mi;
-		mi->event = atomic_read(&md_event_count);
-	}
+		return error;
+
+	seq = file->private_data;
+	seq->poll_event = atomic_read(&md_event_count);
 	return error;
 }
 
 static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
 {
-	struct seq_file *m = filp->private_data;
-	struct mdstat_info *mi = m->private;
+	struct seq_file *seq = filp->private_data;
 	int mask;
 
 	poll_wait(filp, &md_event_waiters, wait);
@@ -6554,7 +6544,7 @@ static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
 	/* always allow read */
 	mask = POLLIN | POLLRDNORM;
 
-	if (mi->event != atomic_read(&md_event_count))
+	if (seq->poll_event != atomic_read(&md_event_count))
 		mask |= POLLERR | POLLPRI;
 	return mask;
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index fe59bd1..cda50fe 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -934,8 +934,8 @@ int mnt_had_events(struct proc_mounts *p)
 	int res = 0;
 
 	br_read_lock(vfsmount_lock);
-	if (p->event != ns->event) {
-		p->event = ns->event;
+	if (p->m.poll_event != ns->event) {
+		p->m.poll_event = ns->event;
 		res = 1;
 	}
 	br_read_unlock(vfsmount_lock);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index fc5bc27..d213f9d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -673,7 +673,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	p->m.private = p;
 	p->ns = ns;
 	p->root = root;
-	p->event = ns->event;
+	p->m.poll_event = ns->event;
 
 	return 0;
 
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 0b89efc..2930485 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -18,7 +18,6 @@ struct proc_mounts {
 	struct seq_file m; /* must be the first element */
 	struct mnt_namespace *ns;
 	struct path root;
-	int event;
 };
 
 struct fs_struct;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 03c0232..be720cd 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -23,6 +23,7 @@ struct seq_file {
 	u64 version;
 	struct mutex lock;
 	const struct seq_operations *op;
+	int poll_event;
 	void *private;
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ff8dc1a..1b8c339 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1681,19 +1681,14 @@ out:
 }
 
 #ifdef CONFIG_PROC_FS
-struct proc_swaps {
-	struct seq_file seq;
-	int event;
-};
-
 static unsigned swaps_poll(struct file *file, poll_table *wait)
 {
-	struct proc_swaps *s = file->private_data;
+	struct seq_file *seq = file->private_data;
 
 	poll_wait(file, &proc_poll_wait, wait);
 
-	if (s->event != atomic_read(&proc_poll_event)) {
-		s->event = atomic_read(&proc_poll_event);
+	if (seq->poll_event != atomic_read(&proc_poll_event)) {
+		seq->poll_event = atomic_read(&proc_poll_event);
 		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
 	}
 
@@ -1783,24 +1778,16 @@ static const struct seq_operations swaps_op = {
 
 static int swaps_open(struct inode *inode, struct file *file)
 {
-	struct proc_swaps *s;
+	struct seq_file *seq;
 	int ret;
 
-	s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
-
-	file->private_data = s;
-
 	ret = seq_open(file, &swaps_op);
-	if (ret) {
-		kfree(s);
+	if (ret)
 		return ret;
-	}
 
-	s->seq.private = s;
-	s->event = atomic_read(&proc_poll_event);
-	return ret;
+	seq = file->private_data;
+	seq->poll_event = atomic_read(&proc_poll_event);
+	return 0;
 }
 
 static const struct file_operations proc_swaps_operations = {


