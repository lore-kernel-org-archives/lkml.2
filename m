Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0JOLcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:32:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0JOLco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:32:44 -0400
Message-ID: <4CB83BCD.4090507@redhat.com>
Date: Fri, 15 Oct 2010 13:32:29 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xiyou.wangcong@gmail.com
Subject: [PATCH v3] procfs: fix numbering in /proc/locks
References: <4CA484BA.7090809@redhat.com>	<4CAB1693.2080301@redhat.com> <20101007162702.7db08f5b.akpm@linux-foundation.org>
In-Reply-To: <20101007162702.7db08f5b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The lock number in /proc/locks (first field) is implemented by a counter
(private field of struct seq_file) which is incremented at each call of
locks_show() and reset to 1 in locks_start() whatever the offset is. It
should be reset according to the actual position in the list.

Moreover, locks_show() can be called twice to print a single line thus
skipping a number. The counter should be incremented in locks_next().

And last, pos is a loff_t, which can be bigger than a pointer, so we 
don't use the pointer as an integer anymore, and allocate a loff_t
instead.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 locks.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..767ef8e 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2085,7 +2085,7 @@ EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 #include <linux/seq_file.h>
 
 static void lock_get_status(struct seq_file *f, struct file_lock *fl,
-							int id, char *pfx)
+			    loff_t id, char *pfx)
 {
 	struct inode *inode = NULL;
 	unsigned int fl_pid;
@@ -2098,7 +2098,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 	if (fl->fl_file != NULL)
 		inode = fl->fl_file->f_path.dentry->d_inode;
 
-	seq_printf(f, "%d:%s ", id, pfx);
+	seq_printf(f, "%lld:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
 		seq_printf(f, "%6s %s ",
 			     (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ",
@@ -2161,24 +2161,27 @@ static int locks_show(struct seq_file *f, void *v)
 
 	fl = list_entry(v, struct file_lock, fl_link);
 
-	lock_get_status(f, fl, (long)f->private, "");
+	lock_get_status(f, fl, *((loff_t *)f->private), "");
 
 	list_for_each_entry(bfl, &fl->fl_block, fl_block)
-		lock_get_status(f, bfl, (long)f->private, " ->");
+		lock_get_status(f, bfl, *((loff_t *)f->private), " ->");
 
-	f->private++;
 	return 0;
 }
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
+	loff_t *p = f->private;
+
 	lock_kernel();
-	f->private = (void *)1;
+	*p = (*pos + 1);
 	return seq_list_start(&file_lock_list, *pos);
 }
 
 static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 {
+	loff_t *p = f->private;
+	++*p;
 	return seq_list_next(v, &file_lock_list, pos);
 }
 
@@ -2196,14 +2199,14 @@ static const struct seq_operations locks_seq_operations = {
 
 static int locks_open(struct inode *inode, struct file *filp)
 {
-	return seq_open(filp, &locks_seq_operations);
+	return seq_open_private(filp, &locks_seq_operations, sizeof(loff_t));
 }
 
 static const struct file_operations proc_locks_operations = {
 	.open		= locks_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int __init proc_locks_init(void)
