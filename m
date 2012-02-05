Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2BEW0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:34 -0500
Received: from 1wt.eu ([62.212.114.60]:61963 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab2BEW0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:32 -0500
Message-Id: <20120205220951.546428393@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 49/91] um: fix ubd cow size
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 8535639810e578960233ad39def3ac2157b0c3ec upstream.

ubd_file_size() cannot use ubd_dev->cow.file because at this time
ubd_dev->cow.file is not initialized.
Therefore, ubd_file_size() will always report a wrong disk size when
COW files are used.
Reading from /dev/ubd* would crash the kernel.

We have to read the correct disk size from the COW file's backing
file.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/um/drivers/ubd_kern.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/arch/um/drivers/ubd_kern.c
===================================================================
--- longterm-2.6.27.orig/arch/um/drivers/ubd_kern.c	2012-02-05 22:34:33.536914634 +0100
+++ longterm-2.6.27/arch/um/drivers/ubd_kern.c	2012-02-05 22:34:41.803915498 +0100
@@ -529,8 +529,37 @@
 static inline int ubd_file_size(struct ubd *ubd_dev, __u64 *size_out)
 {
 	char *file;
+	int fd;
+	int err;
 
-	file = ubd_dev->cow.file ? ubd_dev->cow.file : ubd_dev->file;
+	__u32 version;
+	__u32 align;
+	char *backing_file;
+	time_t mtime;
+	unsigned long long size;
+	int sector_size;
+	int bitmap_offset;
+
+	if (ubd_dev->file && ubd_dev->cow.file) {
+		file = ubd_dev->cow.file;
+
+		goto out;
+	}
+
+	fd = os_open_file(ubd_dev->file, global_openflags, 0);
+	if (fd < 0)
+		return fd;
+
+	err = read_cow_header(file_reader, &fd, &version, &backing_file, \
+		&mtime, &size, &sector_size, &align, &bitmap_offset);
+	os_close_file(fd);
+
+	if(err == -EINVAL)
+		file = ubd_dev->file;
+	else
+		file = backing_file;
+
+out:
 	return os_file_size(file, size_out);
 }
 


