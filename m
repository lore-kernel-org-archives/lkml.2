Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516Ab2BJXVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:21:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473Ab2BJWk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:40:57 -0500
MIME-Version: 1.0
Message-Id: <20120210222946.539688302@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>
Subject: [patch 17/86] proc: unify mem_read() and mem_write()
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 572d34b946bae070debd42db1143034d9687e13f upstream.

No functional changes, cleanup and preparation.

mem_read() and mem_write() are very similar. Move this code into the
new common helper, mem_rw(), which takes the additional "int write"
argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |   90 ++++++++++++++++++++-------------------------------------
 1 file changed, 32 insertions(+), 58 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -782,57 +782,13 @@ static int mem_open(struct inode* inode,
 	return 0;
 }
 
-static ssize_t mem_read(struct file * file, char __user * buf,
-			size_t count, loff_t *ppos)
+static ssize_t mem_rw(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos, int write)
 {
-	int ret;
-	char *page;
-	unsigned long src = *ppos;
 	struct mm_struct *mm = file->private_data;
-
-	if (!mm)
-		return 0;
-
-	page = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		return -ENOMEM;
-
-	ret = 0;
- 
-	while (count > 0) {
-		int this_len, retval;
-
-		this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
-		retval = access_remote_vm(mm, src, page, this_len, 0);
-		if (!retval) {
-			if (!ret)
-				ret = -EIO;
-			break;
-		}
-
-		if (copy_to_user(buf, page, retval)) {
-			ret = -EFAULT;
-			break;
-		}
- 
-		ret += retval;
-		src += retval;
-		buf += retval;
-		count -= retval;
-	}
-	*ppos = src;
-
-	free_page((unsigned long) page);
-	return ret;
-}
-
-static ssize_t mem_write(struct file * file, const char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	int copied;
+	unsigned long addr = *ppos;
+	ssize_t copied;
 	char *page;
-	unsigned long dst = *ppos;
-	struct mm_struct *mm = file->private_data;
 
 	if (!mm)
 		return 0;
@@ -843,30 +799,48 @@ static ssize_t mem_write(struct file * f
 
 	copied = 0;
 	while (count > 0) {
-		int this_len, retval;
+		int this_len = min_t(int, count, PAGE_SIZE);
 
-		this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
-		if (copy_from_user(page, buf, this_len)) {
+		if (write && copy_from_user(page, buf, this_len)) {
 			copied = -EFAULT;
 			break;
 		}
-		retval = access_remote_vm(mm, dst, page, this_len, 1);
-		if (!retval) {
+
+		this_len = access_remote_vm(mm, addr, page, this_len, write);
+		if (!this_len) {
 			if (!copied)
 				copied = -EIO;
 			break;
 		}
-		copied += retval;
-		buf += retval;
-		dst += retval;
-		count -= retval;			
+
+		if (!write && copy_to_user(buf, page, this_len)) {
+			copied = -EFAULT;
+			break;
+		}
+
+		buf += this_len;
+		addr += this_len;
+		copied += this_len;
+		count -= this_len;
 	}
-	*ppos = dst;
+	*ppos = addr;
 
 	free_page((unsigned long) page);
 	return copied;
 }
 
+static ssize_t mem_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	return mem_rw(file, buf, count, ppos, 0);
+}
+
+static ssize_t mem_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	return mem_rw(file, (char __user*)buf, count, ppos, 1);
+}
+
 loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
 	switch (orig) {


