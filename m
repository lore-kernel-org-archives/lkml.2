Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2EAOBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:01:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50882 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2EAOBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
References: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 2 May 2012 00:01:36 +1000
Message-ID: <CAPa8GCAgDU8FYdMuWsn2PuUW0GQxdKWJV6K0SmQEzb3s1GHxwA@mail.gmail.com>
Subject: Re: [patch|rfc] block: don't mark buffers beyond end of disk as mapped
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jaxboe@fusionio.com, Kyle McMartin <kmcmarti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 May 2012 23:46, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> We have a bug report open where a squashfs image mounted on ppc64 would
> exhibit errors due to trying to read beyond the end of the disk.  It can
> easily be reproduced by doing the following:
>
> [root@ibm-p750e-02-lp3 ~]# ls -l install.img
> -rw-r--r-- 1 root root 142032896 Apr 30 16:46 install.img
> [root@ibm-p750e-02-lp3 ~]# mount -o loop ./install.img /mnt/test
> [root@ibm-p750e-02-lp3 ~]# dd if=/dev/loop0 of=/dev/null
> dd: reading `/dev/loop0': Input/output error
> 277376+0 records in
> 277376+0 records out
> 142016512 bytes (142 MB) copied, 0.9465 s, 150 MB/s
>
> In dmesg, you'll find the following:
>
> squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [   43.106012] attempt to access beyond end of device
> [   43.106029] loop0: rw=0, want=277410, limit=277408
> [   43.106039] Buffer I/O error on device loop0, logical block 138704
> [   43.106053] attempt to access beyond end of device
> [   43.106057] loop0: rw=0, want=277412, limit=277408
> [   43.106061] Buffer I/O error on device loop0, logical block 138705
> [   43.106066] attempt to access beyond end of device
> [   43.106070] loop0: rw=0, want=277414, limit=277408
> [   43.106073] Buffer I/O error on device loop0, logical block 138706
> [   43.106078] attempt to access beyond end of device
> [   43.106081] loop0: rw=0, want=277416, limit=277408
> [   43.106085] Buffer I/O error on device loop0, logical block 138707
> [   43.106089] attempt to access beyond end of device
> [   43.106093] loop0: rw=0, want=277418, limit=277408
> [   43.106096] Buffer I/O error on device loop0, logical block 138708
> [   43.106101] attempt to access beyond end of device
> [   43.106104] loop0: rw=0, want=277420, limit=277408
> [   43.106108] Buffer I/O error on device loop0, logical block 138709
> [   43.106112] attempt to access beyond end of device
> [   43.106116] loop0: rw=0, want=277422, limit=277408
> [   43.106120] Buffer I/O error on device loop0, logical block 138710
> [   43.106124] attempt to access beyond end of device
> [   43.106128] loop0: rw=0, want=277424, limit=277408
> [   43.106131] Buffer I/O error on device loop0, logical block 138711
> [   43.106135] attempt to access beyond end of device
> [   43.106139] loop0: rw=0, want=277426, limit=277408
> [   43.106143] Buffer I/O error on device loop0, logical block 138712
> [   43.106147] attempt to access beyond end of device
> [   43.106151] loop0: rw=0, want=277428, limit=277408
> [   43.106154] Buffer I/O error on device loop0, logical block 138713
> [   43.106158] attempt to access beyond end of device
> [   43.106162] loop0: rw=0, want=277430, limit=277408
> [   43.106166] attempt to access beyond end of device
> [   43.106169] loop0: rw=0, want=277432, limit=277408
> ...
> [   43.106307] attempt to access beyond end of device
> [   43.106311] loop0: rw=0, want=277470, limit=2774
>
> What's strange is that the same messages aren't output when mounting an
> ext2, 3, or 4 image of the same size.  Digging into this, I found that
> squashfs manages to read in the end block(s) of the disk during the
> mount operation.  That leads to block_read_full_page being called with
> buffers that are beyond end of disk, but are marked as mapped.  Thus, it
> would end up submitting read I/O against them, resulting in the errors
> mentioned above.  I fixed the problem by modifying init_page_buffers to
> only set the buffer mapped if it fell inside of i_size.  Since I haven't
> fully explained the reason that extN does not hit this problem, I'm
> proposing this as an RFC, though it does look like a good fix to me.
>
> Comments would be appreciated.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 351e18e..b3d6a97 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -921,6 +921,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>        struct buffer_head *head = page_buffers(page);
>        struct buffer_head *bh = head;
>        int uptodate = PageUptodate(page);
> +       struct inode *inode = bdev->bd_inode;
> +       sector_t last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
>
>        do {
>                if (!buffer_mapped(bh)) {
> @@ -929,7 +931,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>                        bh->b_blocknr = block;
>                        if (uptodate)
>                                set_buffer_uptodate(bh);
> -                       set_buffer_mapped(bh);
> +                       if (block <= last_block)
> +                               set_buffer_mapped(bh);
>                }
>                block++;
>                bh = bh->b_this_page;

Not a bad fix. But it's kind of sad to have i_size checking logic also in
block_read_full_page, that does not cope with this.

I have found there are parts of the kernel (readahead) that try to read
beyond EOF and seem to get angry if we return an error (by not
marking uptodate in readpage) in that case though :(

But, either way, I think it's very reasonable to not mark buffers beyond
end of device as mapped. So I think your patch is fine.

I guess for ext[234], it does not read metadata close to the end of the
device or you were using 4K sized blocks?
