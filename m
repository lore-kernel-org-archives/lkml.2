Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab0HFU6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:58:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49246 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab0HFU6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:58:52 -0400
Date: Fri, 6 Aug 2010 22:58:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/ecryptfs/file.c: introduce missing free
Message-ID: <Pine.LNX.4.64.1008062258130.5466@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The comments in the code indicate that file_info should be released if the
function fails.  This releasing is done at the label out_free, not out.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = kmem_cache_zalloc(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return <+...x...+>;
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmem_cache_zalloc %s" % (p1[0].file,p1[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 fs/ecryptfs/file.c                  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 6e4f84c..622c951 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -199,7 +199,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 			       "the persistent file for the dentry with name "
 			       "[%s]; rc = [%d]\n", __func__,
 			       ecryptfs_dentry->d_name.name, rc);
-			goto out;
+			goto out_free;
 		}
 	}
 	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
@@ -207,7 +207,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		rc = -EPERM;
 		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
 		       "file must hence be opened RO\n", __func__);
-		goto out;
+		goto out_free;
 	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
