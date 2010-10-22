Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab0JVV1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:27:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0JVV1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:27:18 -0400
Date: Fri, 22 Oct 2010 14:27:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH v3] procfs: fix numbering in /proc/locks
Message-Id: <20101022142704.7b7692f4.akpm@linux-foundation.org>
In-Reply-To: <4CB83BCD.4090507@redhat.com>
References: <4CA484BA.7090809@redhat.com>
	<4CAB1693.2080301@redhat.com>
	<20101007162702.7db08f5b.akpm@linux-foundation.org>
	<4CB83BCD.4090507@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 13:32:29 +0200
Jerome Marchand <jmarchan@redhat.com> wrote:

> 
> The lock number in /proc/locks (first field) is implemented by a counter
> (private field of struct seq_file) which is incremented at each call of
> locks_show() and reset to 1 in locks_start() whatever the offset is. It
> should be reset according to the actual position in the list.
> 
> Moreover, locks_show() can be called twice to print a single line thus
> skipping a number. The counter should be incremented in locks_next().
> 
> And last, pos is a loff_t, which can be bigger than a pointer, so we 
> don't use the pointer as an integer anymore, and allocate a loff_t
> instead.
> 

The changelog didn't actually describe the bug.  At least, not in any
way I can understand.

So I went back to your first patch and stole the following sentence:

   Because of this, the numbering erratically restarts at 1 several
   times when reading a long /proc/locks file.

and appended it to the first paragraph.

It's somewhat important to describe the user-visible effects of a bug,
please.  It helps engineers when deciding whether to backport a patch
into their kernels and it helps end-users decide whether a particular
patch will solve a problem they're experiencing.  It's also useful to
those who must decide which kernel.org release(s) should include the
patch.

Which reminds me.  Do you think this bug is serious enough to warrant
backporting the fix into -stable?


>  locks.c |   19 +++++++++++--------

Patch looks good.  seq_open_private()'s psize should have been size_t,
not int.  But that's not your doing ;)

I had to fiddle the patch a bit due to BKL changes in linux-next.  Then
I mucked it up, then I fixed it.  Please double-check my handiwork.



From: Jerome Marchand <jmarchan@redhat.com>

The lock number in /proc/locks (first field) is implemented by a counter
(private field of struct seq_file) which is incremented at each call of
locks_show() and reset to 1 in locks_start() whatever the offset is.  It
should be reset according to the actual position in the list.  Because of
this, the numbering erratically restarts at 1 several times when reading a
long /proc/locks file.

Moreover, locks_show() can be called twice to print a single line thus
skipping a number.  The counter should be incremented in locks_next().

And last, pos is a loff_t, which can be bigger than a pointer, so we don't
use the pointer as an integer anymore, and allocate a loff_t instead.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/locks.c~procfs-fix-numbering-in-proc-locks fs/locks.c
--- a/fs/locks.c~procfs-fix-numbering-in-proc-locks
+++ a/fs/locks.c
@@ -2109,7 +2109,7 @@ EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 #include <linux/seq_file.h>
 
 static void lock_get_status(struct seq_file *f, struct file_lock *fl,
-							int id, char *pfx)
+			    loff_t id, char *pfx)
 {
 	struct inode *inode = NULL;
 	unsigned int fl_pid;
@@ -2122,7 +2122,7 @@ static void lock_get_status(struct seq_f
 	if (fl->fl_file != NULL)
 		inode = fl->fl_file->f_path.dentry->d_inode;
 
-	seq_printf(f, "%d:%s ", id, pfx);
+	seq_printf(f, "%lld:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
 		seq_printf(f, "%6s %s ",
 			     (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ",
@@ -2185,24 +2185,27 @@ static int locks_show(struct seq_file *f
 
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
 	lock_flocks();
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
 
@@ -2220,14 +2223,14 @@ static const struct seq_operations locks
 
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
_

