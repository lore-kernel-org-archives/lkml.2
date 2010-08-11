Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab0HKX65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:57 -0400
Received: from kroah.org ([198.145.64.141]:43446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759076Ab0HKX6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:40 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.530157123@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [065/111] Btrfs: fix regression in orphan cleanup
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit 6c090a11e1c403b727a6a8eff0b97d5fb9e95cb5 upstream.

Currently orphan cleanup only ever gets triggered if we cross subvolumes during
a lookup, which means that if we just mount a plain jane fs that has orphans in
it, they will never get cleaned up.  This results in panic's like these

http://www.kerneloops.org/oops.php?number=1109085

where adding an orphan entry results in -EEXIST being returned and we panic.  In
order to fix this, we check to see on lookup if our root has had the orphan
cleanup done, and if not go ahead and do it.  This is easily reproduceable by
running this testcase

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	char data[4096];
	char newdata[4096];
	int fd1, fd2;

	memset(data, 'a', 4096);
	memset(newdata, 'b', 4096);

	while (1) {
		int i;

		fd1 = creat("file1", 0666);
		if (fd1 < 0)
			break;

		for (i = 0; i < 512; i++)
			write(fd1, data, 4096);

		fsync(fd1);
		close(fd1);

		fd2 = creat("file2", 0666);
		if (fd2 < 0)
			break;

		ftruncate(fd2, 4096 * 512);

		for (i = 0; i < 512; i++)
			write(fd2, newdata, 4096);
		close(fd2);

		i = rename("file2", "file1");
		unlink("file1");
	}

	return 0;
}

and then pulling the power on the box, and then trying to run that test again
when the box comes back up.  I've tested this locally and it fixes the problem.
Thanks to Tomas Carnecky for helping me track this down initially.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3796,6 +3796,12 @@ struct inode *btrfs_lookup_dentry(struct
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root);
+		if (unlikely(root->clean_orphans) &&
+		    !(inode->i_sb->s_flags & MS_RDONLY)) {
+			down_read(&root->fs_info->cleanup_work_sem);
+			btrfs_orphan_cleanup(root);
+			up_read(&root->fs_info->cleanup_work_sem);
+		}
 		return inode;
 	}
 


