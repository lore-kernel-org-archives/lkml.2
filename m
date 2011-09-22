Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1IVU5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:57:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1IVU53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:57:29 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 3/3] seq_file: convert seq buffer to vmalloc
Date: Thu, 22 Sep 2011 13:57:09 -0700
Message-Id: <1316725029-22737-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316725029-22737-1-git-send-email-ccross@android.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seq_files are often used for debugging.  When things are going wrong
due to failed physically contiguous allocations, the exponentially
growing physically contiguous allocations in seq_read can make things
worse.  There is no need for physically contiguous memory, so switch
to virtually contiguous memory instead.

Signed-off-by: Colin Cross <ccross@android.com>
---
 fs/seq_file.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 8d9778c..7045656 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -76,15 +77,11 @@ int seq_reserve(struct seq_file *m, size_t size)
 {
 	void *buf;
 
-	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = vmalloc(size);
 	if (!buf)
 		return -ENOMEM;
 
-	kfree(m->buf);
+	vfree(m->buf);
 	m->buf = buf;
 	m->size = size;
 
@@ -106,7 +103,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 		return 0;
 	}
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = vmalloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			return -ENOMEM;
 	}
@@ -145,8 +142,8 @@ static int traverse(struct seq_file *m, loff_t offset)
 
 Eoverflow:
 	m->op->stop(m, p);
-	kfree(m->buf);
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	vfree(m->buf);
+	m->buf = vmalloc(m->size <<= 1);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
 
@@ -199,7 +196,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	m->version = file->f_version;
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = vmalloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			goto Enomem;
 	}
@@ -239,8 +236,8 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
-		kfree(m->buf);
-		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+		vfree(m->buf);
+		m->buf = vmalloc(m->size <<= 1);
 		if (!m->buf)
 			goto Enomem;
 		m->count = 0;
@@ -355,7 +352,7 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	kfree(m->buf);
+	vfree(m->buf);
 	kfree(m);
 	return 0;
 }
-- 
1.7.4.1

