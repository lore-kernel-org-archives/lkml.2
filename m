Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507Ab2BJWlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:41:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760471Ab2BJWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:40:59 -0500
MIME-Version: 1.0
Message-Id: <20120210222946.638109489@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>
Subject: [patch 18/86] proc: make sure mem_open() doesnt pin the targets memory
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 6d08f2c7139790c268820a2e590795cb8333181a upstream.

Once /proc/pid/mem is opened, the memory can't be released until
mem_release() even if its owner exits.

Change mem_open() to do atomic_inc(mm_count) + mmput(), this only
pins mm_struct. Change mem_rw() to do atomic_inc_not_zero(mm_count)
before access_remote_vm(), this verifies that this mm is still alive.

I am not sure what should mem_rw() return if atomic_inc_not_zero()
fails. With this patch it returns zero to match the "mm == NULL" case,
may be it should return -EINVAL like it did before e268337d.

Perhaps it makes sense to add the additional fatal_signal_pending()
check into the main loop, to ensure we do not hold this memory if
the target task was oom-killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -775,6 +775,13 @@ static int mem_open(struct inode* inode,
 	if (IS_ERR(mm))
 		return PTR_ERR(mm);
 
+	if (mm) {
+		/* ensure this mm_struct can't be freed */
+		atomic_inc(&mm->mm_count);
+		/* but do not pin its memory */
+		mmput(mm);
+	}
+
 	/* OK to pass negative loff_t, we can catch out-of-range */
 	file->f_mode |= FMODE_UNSIGNED_OFFSET;
 	file->private_data = mm;
@@ -798,6 +805,9 @@ static ssize_t mem_rw(struct file *file,
 		return -ENOMEM;
 
 	copied = 0;
+	if (!atomic_inc_not_zero(&mm->mm_users))
+		goto free;
+
 	while (count > 0) {
 		int this_len = min_t(int, count, PAGE_SIZE);
 
@@ -825,6 +835,8 @@ static ssize_t mem_rw(struct file *file,
 	}
 	*ppos = addr;
 
+	mmput(mm);
+free:
 	free_page((unsigned long) page);
 	return copied;
 }
@@ -861,7 +873,7 @@ static int mem_release(struct inode *ino
 {
 	struct mm_struct *mm = file->private_data;
 	if (mm)
-		mmput(mm);
+		mmdrop(mm);
 	return 0;
 }
 


