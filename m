Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0CRVkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:40:49 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39723 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0CRVkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W5jDAVUvpc8aAsdRjI0OGcYuxq6tqQZ7ySKgylHk2BcQxloAibzF2SeL5EgYNFdglK
         z1bGowrI3JJPXGqohBzyXJpJgcULzwLkGZfW5LX7kMkDbZAdw07EfFPi2oDJ4rl4X94p
         rCLHWXI/wQcfc0q/kGobiSurAl3kNsIkmcsS8=
MIME-Version: 1.0
In-Reply-To: <87r5nhziss.fsf@tac.ki.iif.hu>
References: <87vdcwv139.fsf@tac.ki.iif.hu> <87ljdsibqe.fsf@macbook.be.48ers.dk>
	 <87r5nhziss.fsf@tac.ki.iif.hu>
Date: Thu, 18 Mar 2010 21:40:45 +0000
Message-ID: <bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
Subject: Re: RFC: direct MTD support for SquashFS
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 4:38 PM, Ferenc Wagner <wferi@niif.hu> wrote:
>
> I could only compare apples to oranges before porting the patch to the
> LZMA variant.  So I refrain from that for a couple of days yet.  But
> meanwhile I started adding a pluggable backend framework to SquashFS,
> and would much appreciate some comments about the applicability of this
> idea.  The patch is (intended to be) a no-op, applies on top of current
> git (a3d3203e4bb40f253b1541e310dc0f9305be7c84).

This looks promising, making the backend pluggable (like the new
compressor framework) is far better and cleaner than scattering the
code full of #ifdef's.  Far better than the previous patch :-)

A couple of specific comments...

+/* A backend is initialized for each SquashFS block read operation,
+ * making further sequential reads possible from the block.
+ */
+static void *bdev_init(struct squashfs_sb_info *msblk, u64 index,
size_t length)
+{
+	struct squashfs_bdev *bdev = msblk->backend_data;
+	struct buffer_head *bh;
+
+	bh = kcalloc((msblk->block_size >> bdev->devblksize_log2) + 1,
+			sizeof(*bh), GFP_KERNEL);

You should alloc against the larger of msblk->block_size and
METADATA_SIZE (8 Kbytes).  Block_size could be 4 Kbytes only.

+static int fill_bdev_super(struct super_block *sb, void *data, int silent)
+{
+	struct squashfs_sb_info *msblk;
+	struct squashfs_bdev *bdev;
+	int err = squashfs_fill_super2(sb, data, silent, &squashfs_bdev_ops);
+	if (err)
+		return err;
+
+	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
+	if (!bdev)
+		return -ENOMEM;
+
+	bdev->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	bdev->devblksize_log2 = ffz(~bdev->devblksize);
+
+	msblk = sb->s_fs_info;
+	msblk->backend_data = bdev;
+	return 0;
+}

This function looks rather 'back-to-front' to me.  I'm assuming that
squashfs_fill_super2() will be the current fill superblock function?
This function wants to read data off the filesystem through the
backend, and yet the backend (bdev, mblk->backend_data) hasn't been
initialised when it's called...

Phillip
