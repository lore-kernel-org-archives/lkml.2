Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab1IJPhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 11:37:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54945 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1IJPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 11:37:49 -0400
Message-ID: <4E6B82DB.50803@gmail.com>
Date: Sat, 10 Sep 2011 17:31:39 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFC] xip: use i_mutex for xip_file_fault
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

There aren't sufficient sync points for a fs for xip operations. In 
particular for the mmap case. It can be not sufficient to lock/unlock 
to do some operation inside get_xip_mem callback. For xip_file_read 
it's really easy to write a fs specific wrapper, xip_file_write hold 
i_mutex so no problem. With this patch we can avoid concurrent truncate 
operation and xip mmap.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- filemap_xip.c.orig	2011-09-10 17:16:56.000000000 +0200
+++ filemap_xip.c	2011-09-10 17:19:25.000000000 +0200
@@ -230,6 +230,7 @@ static int xip_file_fault(struct vm_area
 	int error;
 
 	/* XXX: are VM_FAULT_ codes OK? */
+	mutex_lock(&inode->i_mutex);
 again:
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
@@ -239,8 +240,10 @@ again:
 						&xip_mem, &xip_pfn);
 	if (likely(!error))
 		goto found;
-	if (error != -ENODATA)
+	if (error != -ENODATA) {
+		mutex_unlock(&inode->i_mutex);
 		return VM_FAULT_OOM;
+	}
 
 	/* sparse block */
 	if ((vma->vm_flags & (VM_WRITE | VM_MAYWRITE)) &&
@@ -253,17 +256,22 @@ again:
 		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 1,
 							&xip_mem, &xip_pfn);
 		mutex_unlock(&xip_sparse_mutex);
-		if (error)
+		if (error) {
+			mutex_unlock(&inode->i_mutex);
 			return VM_FAULT_SIGBUS;
+		}
 		/* unmap sparse mappings at pgoff from all other vmas */
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
-		if (err == -ENOMEM)
+		if (err == -ENOMEM) {
+			mutex_unlock(&inode->i_mutex);
 			return VM_FAULT_OOM;
+		}
 		BUG_ON(err);
+		mutex_unlock(&inode->i_mutex);
 		return VM_FAULT_NOPAGE;
 	} else {
 		int err, ret = VM_FAULT_OOM;
@@ -292,6 +300,7 @@ found:
 out:
 		write_seqcount_end(&xip_sparse_seq);
 		mutex_unlock(&xip_sparse_mutex);
+		mutex_unlock(&inode->i_mutex);
 
 		return ret;
 	}
