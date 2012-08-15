Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2HOTva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:36926 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2HOTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Richard Weinberger <richard@nod.at>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 096/165] um: fix ubd cow size
Date: Wed, 15 Aug 2012 15:47:20 -0400
Message-ID: <1345060109-9187-97-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8535639810e578960233ad39def3ac2157b0c3ec upstream.

ubd_file_size() cannot use ubd_dev->cow.file because at this time
ubd_dev->cow.file is not initialized.
Therefore, ubd_file_size() will always report a wrong disk size when
COW files are used.
Reading from /dev/ubd* would crash the kernel.

We have to read the correct disk size from the COW file's backing
file.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/um/drivers/ubd_kern.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 3d63b83..1cbad01 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -511,8 +511,37 @@ __uml_exitcall(kill_io_thread);
 static inline int ubd_file_size(struct ubd *ubd_dev, __u64 *size_out)
 {
 	char *file;
+	int fd;
+	int err;
+
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
 
-	file = ubd_dev->cow.file ? ubd_dev->cow.file : ubd_dev->file;
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
 
-- 
1.7.12.rc2

