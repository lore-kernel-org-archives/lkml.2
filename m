Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0D1Qen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:34:43 -0400
Received: from www.tglx.de ([62.245.132.106]:35829 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab0D1Qel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:34:41 -0400
Date: Wed, 28 Apr 2010 18:34:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>  <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>  <1272399798.2255.2.camel@localhost>  <1272400246.2255.5.camel@localhost>  <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
  <1272434481.1974.101.camel@work-vm> <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Xianghua Xiao wrote:
> Just tried the patch, still got umount hang, please see below.

Can you please apply the patch below and provide the debug output ?

Thanks,

	tglx
---
 fs/file_table.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/fs/file_table.c
===================================================================
--- linux-2.6-tip.orig/fs/file_table.c
+++ linux-2.6-tip/fs/file_table.c
@@ -410,7 +410,27 @@ int fs_may_remount_ro(struct super_block
 		list = &sb->s_files;
 #endif
 		list_for_each_entry(file, list, f_u.fu_list) {
-			struct inode *inode = file->f_path.dentry->d_inode;
+			struct inode *inode;
+
+			if (!file->f_path) {
+				printk(KERN_ERR "file %p fpath == NULL\n",
+				       file);
+				continue;
+			}
+
+			if (!file->f_path.dentry) {
+				printk(KERN_ERR "file %p dentry == NULL\n",
+				       file);
+				continue;
+			}
+
+			if (!file->f_path.dentry->d_inode) {
+				printk(KERN_ERR "file %p d_inode == NULL\n",
+				       file);
+				continue;
+			}
+
+			inode = file->f_path.dentry->d_inode;
 
 			/* File with pending delete? */
 			if (inode->i_nlink == 0)
