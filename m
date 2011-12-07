Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab1LGQVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab1LGQVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161214.938974798@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:04 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Tyler Hicks <tyhicks@canonical.com>
Subject: [002/104] eCryptfs: Flush file in vma close
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 32001d6fe9ac6b0423e674a3093aa56740849f3b upstream.

Dirty pages weren't being written back when an mmap'ed eCryptfs file was
closed before the mapping was unmapped. Since f_ops->flush() is not
called by the munmap() path, the lower file was simply being released.
This patch flushes the eCryptfs file in the vm_ops->close() path.

https://launchpad.net/bugs/870326

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/file.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -139,6 +139,27 @@ out:
 	return rc;
 }
 
+static void ecryptfs_vma_close(struct vm_area_struct *vma)
+{
+	filemap_write_and_wait(vma->vm_file->f_mapping);
+}
+
+static const struct vm_operations_struct ecryptfs_file_vm_ops = {
+	.close		= ecryptfs_vma_close,
+	.fault		= filemap_fault,
+};
+
+static int ecryptfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int rc;
+
+	rc = generic_file_mmap(file, vma);
+	if (!rc)
+		vma->vm_ops = &ecryptfs_file_vm_ops;
+
+	return rc;
+}
+
 struct kmem_cache *ecryptfs_file_info_cache;
 
 /**
@@ -349,7 +370,7 @@ const struct file_operations ecryptfs_ma
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = ecryptfs_compat_ioctl,
 #endif
-	.mmap = generic_file_mmap,
+	.mmap = ecryptfs_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
 	.release = ecryptfs_release,


