Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab0HLAEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:04:31 -0400
Received: from kroah.org ([198.145.64.141]:60179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759505Ab0HLAEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:13 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:25 2010
Message-Id: <20100812000125.479843970@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>, Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [24/54] fs/ecryptfs/file.c: introduce missing free
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit ceeab92971e8af05c1e81a4ff2c271124b55bb9b upstream.

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
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -199,7 +199,7 @@ static int ecryptfs_open(struct inode *i
 			       "the persistent file for the dentry with name "
 			       "[%s]; rc = [%d]\n", __func__,
 			       ecryptfs_dentry->d_name.name, rc);
-			goto out;
+			goto out_free;
 		}
 	}
 	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
@@ -207,7 +207,7 @@ static int ecryptfs_open(struct inode *i
 		rc = -EPERM;
 		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
 		       "file must hence be opened RO\n", __func__);
-		goto out;
+		goto out_free;
 	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);


