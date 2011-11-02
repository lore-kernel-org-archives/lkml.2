Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab1KCBiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:38:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933815Ab1KCBiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:57 2011
Message-Id: <20111102221457.812711598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>
Subject: [084/107] um: fix ubd cow size
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Weinberger <richard@nod.at>

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
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -510,8 +510,37 @@ __uml_exitcall(kill_io_thread);
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
 


