Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab1I1Wsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab1I1Wsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.617483478@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>,
        Grazvydas Ignotas <notasas@gmail.com>
Subject: [211/244] btrfs: fix d_off in the first dirent
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit 3765fefaee2da83f10829fa64a74e6b7360350cb upstream.

Since the d_off in the first dirent for "." (that originates from
the 4th argument "offset" of filldir() for the 2nd dirent for "..")
is wrongly assigned in btrfs_real_readdir(), telldir returns same
offset for different locations.

 | # mkfs.btrfs /dev/sdb1
 | # mount /dev/sdb1 fs0
 | # cd fs0
 | # touch file0 file1
 | # ../test
 | telldir: 0
 | readdir: d_off = 2, d_name = "."
 | telldir: 2
 | readdir: d_off = 2, d_name = ".."
 | telldir: 2
 | readdir: d_off = 3, d_name = "file0"
 | telldir: 3
 | readdir: d_off = 2147483647, d_name = "file1"
 | telldir: 2147483647

To fix this problem, pass filp->f_pos (which is loff_t) instead.

 | # ../test
 | telldir: 0
 | readdir: d_off = 1, d_name = "."
 | telldir: 1
 | readdir: d_off = 2, d_name = ".."
 | telldir: 2
 | readdir: d_off = 3, d_name = "file0"
 :

At the moment the "offset" for "." is unused because there is no
preceding dirent, however it is better to pass filp->f_pos to follow
grammatical usage.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4124,7 +4124,8 @@ static int btrfs_real_readdir(struct fil
 
 	/* special case for "." */
 	if (filp->f_pos == 0) {
-		over = filldir(dirent, ".", 1, 1, btrfs_ino(inode), DT_DIR);
+		over = filldir(dirent, ".", 1,
+			       filp->f_pos, btrfs_ino(inode), DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 1;
@@ -4133,7 +4134,7 @@ static int btrfs_real_readdir(struct fil
 	if (filp->f_pos == 1) {
 		u64 pino = parent_ino(filp->f_path.dentry);
 		over = filldir(dirent, "..", 2,
-			       2, pino, DT_DIR);
+			       filp->f_pos, pino, DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 2;


