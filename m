Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab1ILP5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:57:32 -0400
Received: from nm11.bullet.mail.ird.yahoo.com ([77.238.189.64]:35638 "HELO
	nm11.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758069Ab1ILP5b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:57:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 233858.48595.bm@omp1012.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cRYQGd84sBXPbL4CI2ZPoJHFFsb7J5ZLhFFety2a98Q//EBG8bv/ECsJ/Z0KRLKLw0z/KVFPP3I56FlEeLoEX6mlGjY0n/kzIRfCCcFCIcfj1FGzf9vrj6ayt0qmVylSZycFLyYIJRBh5poSKxItmKj8Bhffu2EuI388K491SlM=;
X-YMail-OSG: rtYrjlUVM1mdPXM7S0wlWP0Nwg_G96C_09YC3nN_Y9v2Fph
 dEoO4DNyu7irkkhNkLMaaXLquBJ824_2sfZpDsUT55cRdofZ6yZA5FvzM.xM
 gtE6k_iuHu5g04YagdEpNU66cpkmzUUbKebrI9X9OInDUDrewMb6XEonACWe
 2s5vC8et6PoCXEJb738n0cYLGTEvQnBqmznsoxJaLZrr0Ux_h9Fo2zZojCvi
 i7MkIy0mYx_gdgCzFXV9SgTnF3FFC1Bf7jV4u9KwRTSwQQZ2YW4jM8rzyvn1
 LkyHs.xnijBwGBvchiQIaklRT.ZcM1dDLaZ_l_L.2eVea2HFqHdpOuKmc8mK
 5IsL.T74gX37Ux1i9PqrneTjnlisF4_7hrsEpm6ErtqSGps_IM9gN0AU8m5W
 KSpUN_2NPL_pjdpLdNlA-
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315843050.34041.YahooMailClassic@web29505.mail.ird.yahoo.com>
Date: Mon, 12 Sep 2011 16:57:30 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Christoph Hellwig <hch@infradead.org>, Pavel Ivanov <paivanof@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
In-Reply-To: <CAG1a4rsuYVehnSCM3KxeYQ+g94nrivG1vfss=y8275E4D24qTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:

> On Mon, Sep 12, 2011 at 10:34 AM,
> Christoph Hellwig <hch@infradead.org>
> wrote:
> > Does this patch fix your issues with large block
> sizes?
> 
> I'll be able to try it in the evening but meanwhile I have
> some comments below.
> 
> >
> >
> > Index: linux-2.6/fs/hfsplus/super.c
> >
> ===================================================================
> > --- linux-2.6.orig/fs/hfsplus/super.c   2011-09-12
> 09:56:58.619988416 -0400
> > +++ linux-2.6/fs/hfsplus/super.c        2011-09-12
> 10:07:18.006651395 -0400
> > @@ -344,6 +344,7 @@ static int
> hfsplus_fill_super(struct sup
> >        struct inode *root, *inode;
> >        struct qstr str;
> >        struct nls_table *nls = NULL;
> > +       u64 last_fs_block, last_fs_page;
> >        int err;
> >
> >        err = -EINVAL;
> > @@ -399,9 +400,13 @@ static int
> hfsplus_fill_super(struct sup
> >        if (!sbi->rsrc_clump_blocks)
> >                sbi->rsrc_clump_blocks = 1;
> >
> > -       err =
> generic_check_addressable(sbi->alloc_blksz_shift,
> > -                                  
>     sbi->total_blocks);
> > -       if (err) {
> > +       err = -EFBIG;
> > +       last_fs_block = sbi->total_blocks - 1;
> > +       last_fs_page = (last_fs_block >>
> sbi->alloc_blksz_shift) <<
> > +                       PAGE_CACHE_SHIFT;
> 
> Did you mix left and right shifts here? Expression doesn't
> make sense to me.
> 
> Also I have a little concern about consistency in using
> PAGE_CACHE_SHIFT and PAGE_SHIFT. hfsplus_read_wrapper()
> limits visible
> block size to PAGE_SIZE, not PAGE_CACHE_SIZE. And although
> now they
> are equal comment in linux/pagemap.h clearly says that
> PAGE_CACHE_SIZE
> can be bigger than PAGE_SIZE. Is it something that should
> be fixed in
> hfsplus_read_wrapper() ?
> 
> > +
> > +       if ((last_fs_block > (sector_t)(~0ULL)
> >> (sbi->alloc_blksz_shift - 9)) ||
> 
> Maybe this 9 should be extracted from here and
> generic_check_addressable() into some macro?
> 
> > +           (last_fs_page > (pgoff_t)(~0ULL)))
> {
> >                printk(KERN_ERR "hfs:
> filesystem size too large.\n");
> >                goto out_free_vhdr;
> >        }
> >

I 2nd that this is kind of ugly. The literal "9". How about abstracting this logic out to say, hfs_check_addressable()?
