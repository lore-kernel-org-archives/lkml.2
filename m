Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2K1QoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45503 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2K1QoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:06 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 05/25] char: add aio_{read,write} to /dev/{null,zero}
Date: Wed, 28 Nov 2012 08:43:29 -0800
Message-Id: <1354121029-1376-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

These are handy for measuring the cost of the aio infrastructure with
operations that do very little and complete immediately.

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/char/mem.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 0537903..968ae6e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -627,6 +627,18 @@ static ssize_t write_null(struct file *file, const char __user *buf,
 	return count;
 }
 
+static ssize_t aio_read_null(struct kiocb *iocb, const struct iovec *iov,
+			     unsigned long nr_segs, loff_t pos)
+{
+	return 0;
+}
+
+static ssize_t aio_write_null(struct kiocb *iocb, const struct iovec *iov,
+			      unsigned long nr_segs, loff_t pos)
+{
+	return iov_length(iov, nr_segs);
+}
+
 static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -670,6 +682,24 @@ static ssize_t read_zero(struct file *file, char __user *buf,
 	return written ? written : -EFAULT;
 }
 
+static ssize_t aio_read_zero(struct kiocb *iocb, const struct iovec *iov,
+			     unsigned long nr_segs, loff_t pos)
+{
+	size_t written = 0;
+	unsigned long i;
+	ssize_t ret;
+
+	for (i = 0; i < nr_segs; i++) {
+		ret = read_zero(iocb->ki_filp, iov[i].iov_base, iov[i].iov_len,
+				&pos);
+		if (ret < 0)
+			break;
+		written += ret;
+	}
+
+	return written ? written : -EFAULT;
+}
+
 static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 {
 #ifndef CONFIG_MMU
@@ -738,6 +768,7 @@ static int open_port(struct inode * inode, struct file * filp)
 #define full_lseek      null_lseek
 #define write_zero	write_null
 #define read_full       read_zero
+#define aio_write_zero	aio_write_null
 #define open_mem	open_port
 #define open_kmem	open_mem
 #define open_oldmem	open_mem
@@ -766,6 +797,8 @@ static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
 	.read		= read_null,
 	.write		= write_null,
+	.aio_read	= aio_read_null,
+	.aio_write	= aio_write_null,
 	.splice_write	= splice_write_null,
 };
 
@@ -782,6 +815,8 @@ static const struct file_operations zero_fops = {
 	.llseek		= zero_lseek,
 	.read		= read_zero,
 	.write		= write_zero,
+	.aio_read	= aio_read_zero,
+	.aio_write	= aio_write_zero,
 	.mmap		= mmap_zero,
 };
 
-- 
1.7.12

