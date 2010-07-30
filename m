Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab0G3S6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:58:21 -0400
Received: from kroah.org ([198.145.64.141]:51847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569Ab0G3RTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.310029685@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <tao.ma@oracle.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [096/165] ext4: Fix fencepost error in chosing choosing group vs file preallocation.
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit cc483f102c3f703e853c96f95a654f0106fb2603 upstream (as of v2.6.33-git11)

The ext4 multiblock allocator decides whether to use group or file
preallocation based on the file size.  When the file size reaches
s_mb_stream_request (default is 16 blocks), it changes to use a
file-specific preallocation. This is cool, but it has a tiny problem.

See a simple script:
mkfs.ext4 -b 1024 /dev/sda8 1000000
mount -t ext4 -o nodelalloc /dev/sda8 /mnt/ext4
for((i=0;i<5;i++))
do
cat /mnt/4096>>/mnt/ext4/a	#4096 is a file with 4096 characters.
cat /mnt/4096>>/mnt/ext4/b
done
debuge4fs -R 'stat a' /dev/sda8|grep BLOCKS -A 1

And you get
BLOCKS:
(0-14):8705-8719, (15):2356, (16-19):8465-8468

So there are 3 extents, a bit strange for the lonely 15th logical
block.  As we write to the 16 blocks, we choose file preallocation in
ext4_mb_group_or_file, but in ext4_mb_normalize_request, we meet with
the 16*1024 range, so no preallocation will be carried. file b then
reserves the space after '2356', so when when write 16, we start from
another part.

This patch just change the check in ext4_mb_group_or_file, so
that for the lonely 15 we will still use group preallocation.
After the patch, we will get:
debuge4fs -R 'stat a' /dev/sda8|grep BLOCKS -A 1
BLOCKS:
(0-15):8705-8720, (16-19):8465-8468

Looks more sane. Thanks.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3938,7 +3938,7 @@ static void ext4_mb_group_or_file(struct
 
 	/* don't use group allocation for large files */
 	size = max(size, isize);
-	if (size >= sbi->s_mb_stream_request) {
+	if (size > sbi->s_mb_stream_request) {
 		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
 		return;
 	}


