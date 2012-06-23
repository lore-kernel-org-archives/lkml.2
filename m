Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2FWJPC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 05:15:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27283 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2FWJO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 05:14:59 -0400
Date: Sat, 23 Jun 2012 12:14:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hfs: copying wrong data in hfs_readdir()
Message-ID: <20120623091446.GA26923@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains that this is copying stack data when then intent was
to copy fd.key.  The way I have written it matches how hfsplus_readdir()
is implemented.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I tried to test this, but to reach the memcpy() you would need to make
one of the calls to filldir() fail and I don't know how to do that.  I
think that in the original code this would cause a crash when we call
hfs_find_exit()

diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 62fc14e..f637bd5 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -162,7 +162,7 @@ static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		rd->file = filp;
 		list_add(&rd->list, &HFS_I(inode)->open_dir_list);
 	}
-	memcpy(&rd->key, &fd.key, sizeof(struct hfs_cat_key));
+	memcpy(&rd->key, fd.key, sizeof(struct hfs_cat_key));
 out:
 	hfs_find_exit(&fd);
 	return err;
