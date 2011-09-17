Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1IQMbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 08:31:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44837 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1IQMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 08:31:11 -0400
Message-ID: <4E749003.30909@gmail.com>
Date: Sat, 17 Sep 2011 14:18:11 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] xip: export xip_file_fault
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
i_mutex so no problem. With this patch it's possible to reuse the
generic xip_file_fault, using a wrapper function in a fs, without to
reinvent the wheel.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- linux-3.1-rc4/mm/filemap_xip.c.orig	2011-09-17 13:58:44.000000000 +0200
+++ linux-3.1-rc4/mm/filemap_xip.c	2011-09-17 13:59:31.000000000 +0200
@@ -218,7 +218,7 @@ retry:
  *
  * This function is derived from filemap_fault, but used for execute in place
  */
-static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
@@ -296,6 +296,7 @@ out:
 		return ret;
 	}
 }
+EXPORT_SYMBOL_GPL(xip_file_fault);
 
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
--- linux-3.1-rc4/include/linux/fs.h.orig	2011-09-17 13:59:01.000000000 +0200
+++ linux-3.1-rc4/include/linux/fs.h	2011-09-17 14:00:35.000000000 +0200
@@ -409,6 +409,7 @@ struct pipe_inode_info;
 struct poll_table_struct;
 struct kstatfs;
 struct vm_area_struct;
+struct vm_fault;
 struct vfsmount;
 struct cred;
 
@@ -2403,6 +2404,7 @@ extern int nonseekable_open(struct inode
 extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 			     loff_t *ppos);
 extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
+extern int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
 			      size_t len, loff_t *ppos);
 extern int xip_truncate_page(struct address_space *mapping, loff_t from);


