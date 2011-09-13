Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1IMCUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 22:20:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab1IMCUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 22:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110912153129.GA10625@infradead.org>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
 <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
 <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
 <20110912143452.GA31539@infradead.org> <CAG1a4rsuYVehnSCM3KxeYQ+g94nrivG1vfss=y8275E4D24qTg@mail.gmail.com>
 <20110912153129.GA10625@infradead.org>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Mon, 12 Sep 2011 22:20:01 -0400
Message-ID: <CAG1a4rsKQexL8vhAAoJDtnEvqH0rDvPQCiBGM74EH-+pZ9+WPg@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 11:31 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Yes, the shifts were the wrong way around.  I'll leave the 9 in for now,
> we use it in so many places and if we're going to clean it up I'd do it
> in ne go.
>
> Index: linux-2.6/fs/hfsplus/super.c
> ===================================================================
> --- linux-2.6.orig/fs/hfsplus/super.c   2011-09-12 11:20:33.866598100 -0400
> +++ linux-2.6/fs/hfsplus/super.c        2011-09-12 11:20:52.538098052 -0400
> @@ -344,6 +344,7 @@ static int hfsplus_fill_super(struct sup
>        struct inode *root, *inode;
>        struct qstr str;
>        struct nls_table *nls = NULL;
> +       u64 last_fs_block, last_fs_page;
>        int err;
>
>        err = -EINVAL;
> @@ -399,9 +400,13 @@ static int hfsplus_fill_super(struct sup
>        if (!sbi->rsrc_clump_blocks)
>                sbi->rsrc_clump_blocks = 1;
>
> -       err = generic_check_addressable(sbi->alloc_blksz_shift,
> -                                       sbi->total_blocks);
> -       if (err) {
> +       err = -EFBIG;
> +       last_fs_block = sbi->total_blocks - 1;
> +       last_fs_page = (last_fs_block << sbi->alloc_blksz_shift) >>
> +                       PAGE_CACHE_SHIFT;
> +
> +       if ((last_fs_block > (sector_t)(~0ULL) >> (sbi->alloc_blksz_shift - 9)) ||
> +           (last_fs_page > (pgoff_t)(~0ULL))) {
>                printk(KERN_ERR "hfs: filesystem size too large.\n");
>                goto out_free_vhdr;
>        }
>

Christoph,

This patch works for me.

And could you comment on my PAGE_SIZE question?

>> Also I have a little concern about consistency in using
>> PAGE_CACHE_SHIFT and PAGE_SHIFT. hfsplus_read_wrapper() limits visible
>> block size to PAGE_SIZE, not PAGE_CACHE_SIZE. And although now they
>> are equal comment in linux/pagemap.h clearly says that PAGE_CACHE_SIZE
>> can be bigger than PAGE_SIZE. Is it something that should be fixed in
>> hfsplus_read_wrapper() ?
