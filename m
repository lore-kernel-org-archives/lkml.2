Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1CRSo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:44:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:48497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab1CRSot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,206,1299484800"; 
   d="scan'208";a="668805234"
From: "Luck, Tony" <tony.luck@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: pstore: fix leaking ->i_private
In-Reply-To: <20110317104434.GB22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
Date: Fri, 18 Mar 2011 11:44:48 -0700
Message-Id: <4d83a82032021e2997@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

Move kfree() of i_private out of ->unlink() and into ->evict_inode()

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

> Incidentally, you are leaking ->i_private on umount.  You want ->evict_inode()
> doing that kfree(), not ->unlink().  And possibly ->erase() as well, with
> check for zero i_nlink around it (in ->evict_inode()).

I think this does what I want.

I only want to ->erase() the persistant store if there has been an unlink(2)
on the file.  It looks to be safe and right to do this in ->unlink()

I don't think I need any checks on i_nlink - pstore filesystem won't let you
make extra links to a file.

end_writeback(inode) looks to be somewhat overkill, all I need is to set I_CLEAR
bit in ->i_state. But nobody else does this by hand, and the extra actions in
end_writeback() look to be harmless.

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 0834223..e8b0c08 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -73,11 +73,16 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	struct pstore_private *p = dentry->d_inode->i_private;
 
 	p->erase(p->id);
-	kfree(p);
 
 	return simple_unlink(dir, dentry);
 }
 
+static void pstore_evict_inode(struct inode *inode)
+{
+	kfree(inode->i_private);
+	end_writeback(inode);
+}
+
 static const struct inode_operations pstore_dir_inode_operations = {
 	.lookup		= simple_lookup,
 	.unlink		= pstore_unlink,
@@ -110,6 +115,7 @@ static struct inode *pstore_get_inode(struct super_block *sb,
 static const struct super_operations pstore_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
+	.evict_inode	= pstore_evict_inode,
 	.show_options	= generic_show_options,
 };
 
