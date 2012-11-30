Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2K3CNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:13:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64490 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2K3CNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121130011608.GA11004@shiny.int.fusionio.com>
References: <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny> <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny> <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny> <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
 <CA+55aFwoM3wje+XS60=kE3eVndWQD6szfgYa9MyfSp=itdr9Vg@mail.gmail.com> <20121130011608.GA11004@shiny.int.fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 18:13:02 -0800
X-Google-Sender-Auth: xS2CxXnSSRK-XYcx37w-Tuq3Cgg
Message-ID: <CA+55aFw1B3vDvSaQRDecVvg5bpvu1k-VGOCHvumEZo4M+vj5Yg@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 5:16 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> I searched through filemap.c for the magic i_size check that would let
> us get away with ignoring i_blkbits in get_blocks, but its just not
> there.  The whole fallback-to-buffered scheme seems to rely on
> get_blocks checking for i_size.  I really hope I'm just missing
> something.

So generic_write_checks() limits the size to i_size at for writes (and
for "isblk").

Sure, then it will do the buffered part after that, but that should
all be fine anyway, since by then we use the normal page cache.

For reads, generic_file_aio_read() will check pos < size, but doesn't
seem to actually limit the size of the iovec.

I'm not sure why it doesn't just do "iov_shorten()".

Anyway, having looked at actually passing in the block size to
get_block(), I can say that is a horrible idea. There are tons of
get_block functions (for various filesystems), and *none* of them
really want the block size, because they tend to work on block
indexes. And if they do want the block size, they'll just get it from
the inode or sb, since they are filesystems and it's all stable.

So the *only* of the places that would want the block size is
fs/block_dev.c. And the callers really already seem to do the i_size
check, although they sometimes do it badly. And since there are fewer
callers than there are get_block() implementations, I think we should
just fix the callers and be done with it.

Those generic_file_aio_read/write() functions in fs/direct-io.c really
just seem to be badly written. The fact that they may depend on the
i_size check in get_blocks() is sad, but I think we should fix it and
just remove the check for block devices. That's going to simplify so
much..

I updated the 'block-dev' branch to have that simpler fs/block_dev.c
model instead. I'll look at the iovec shortening later. It's a
non-fast-forward thing, look out!

(I actually think we should just add the max-offset check to
rw_copy_check_uvector(). That one already does the MAX_RW_COUNT thing,
and we could make it do a max_offset check as well).

                      Linus
