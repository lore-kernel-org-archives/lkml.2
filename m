Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1IVU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:58:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab1IVU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:57:28 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 1/3] fs: seq_file: add seq_reserve
Date: Thu, 22 Sep 2011 13:57:07 -0700
Message-Id: <1316725029-22737-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316725029-22737-1-git-send-email-ccross@android.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a seq_reserve function to allow users of the seq_file interface to
increase the initial size of the buffer.  Avoids repeated allocations and
calls to the show function in cases where large buffers of known size are
needed.

Signed-off-by: Colin Cross <ccross@android.com>
---
 fs/seq_file.c            |   30 ++++++++++++++++++++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 05d6b0e..8d9778c 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -62,6 +62,36 @@ int seq_open(struct file *file, const struct seq_operations *op)
 }
 EXPORT_SYMBOL(seq_open);
 
+/**
+ *	seq_reserve -	increase initial buffer for sequential file
+ *	@m:	target buffer
+ *	@size: size in bytes to reserve
+ *
+ *	seq_reserve() increases the initial size of the seq_file buffer.  Can
+ *	be used to avoid future allocations and repeated calls to the show
+ *	function for large buffers of known size.
+ *	Returns 0 on success, or -ENOMEM if the buffer cannot be allocated.
+ */
+int seq_reserve(struct seq_file *m, size_t size)
+{
+	void *buf;
+
+	/* don't ask for more than the kmalloc() max size */
+	if (size > KMALLOC_MAX_SIZE)
+		size = KMALLOC_MAX_SIZE;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	kfree(m->buf);
+	m->buf = buf;
+	m->size = size;
+
+	return 0;
+}
+EXPORT_SYMBOL(seq_reserve);
+
 static int traverse(struct seq_file *m, loff_t offset)
 {
 	loff_t pos = 0, index;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 03c0232..ad93319 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -75,6 +75,7 @@ static inline void seq_commit(struct seq_file *m, int num)
 
 char *mangle_path(char *s, char *p, char *esc);
 int seq_open(struct file *, const struct seq_operations *);
+int seq_reserve(struct seq_file *m, size_t size);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
-- 
1.7.4.1

