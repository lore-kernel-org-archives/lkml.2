Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0IOIOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:14:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59991 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0IOIOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BdhIOdDwMkfgTMS31xmYsELjTafFwJWOKHMcs8mXCMmC/JKbBvbP0zHiScHWdKC6rb
         7mbSqLnd4tfnNTdkSIQNTLpNrXpWNbse2PxBc2SvtjJtUR781oEU1q/qcvs2vxNPcv8f
         uyybrdAIGWWkCiwt5QTfjoP5rcrTBYFbnEUpc=
MIME-Version: 1.0
In-Reply-To: <20100913160905.332ff633.akpm@linux-foundation.org>
References: <20100908100710.GA26365@zhongling.bej.apac.novell.com>
	<20100913160905.332ff633.akpm@linux-foundation.org>
Date: Wed, 15 Sep 2010 16:14:43 +0800
Message-ID: <AANLkTin-6wZJ=YAwYN+MYH8uNV4=rNuSHrnB4wVCYov7@mail.gmail.com>
Subject: Re: [PATCH] vfs: calculate block-size correctly
From: McPacino <mcpacino@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 7:09 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 8 Sep 2010 18:07:10 +0800
> Cong Meng <mcpacino@gmail.com> wrote:
>
> > I sent this patch half mount ago, but no response at all. If anything is
> > wrong, please tell me. Thanks a lots. This is my first time to send patch
> > to linux kernel.
> >
> > The invocation of __getblk(bdev, block, size) will cause kernel stall if
> > the @size parameter is not equal to the blockr-size of @bdev, which is saved
> > in bdev->bd_inode->i_blkbits.
> >
> > submit_bh() has the similar problem.
> >
> > This patch calculates the block-size using i_blkbits.
> > So that, for example, __getblk() can get a 4K buffer head while the
> > block-size of @bdev is 1K.
> >
>
> This comes up every couple of years and iirc we always decided that
> it's a bug in the calling code somewhere.  How did you hit it?
>

I am working on a new multi-version snapshot target module for device-mapper
which is almost done.  It's on-disk metadata block size is fixed 4K, no matter
what the actual disk block size is. So I call __getblk(bdev, block,
4096) to buffer
the metedata.

This is how I hit it.

grow_dev_page(), the main routine of grow_buffers(), has already supported to
grow page buffer of different size.

If we adapt grow_buffer() this way, imho, It's flexible that make
__getblk() get
buffer head of different size. why not?

>
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
> >       pgoff_t index;
> >       int sizebits;
> >
> > -     sizebits = -1;
> > -     do {
> > -             sizebits++;
> > -     } while ((size << sizebits) < PAGE_SIZE);
>
> I'm sure the existing code could use __roundup_pow_of_two() here.
>

What does this mean?

(sorry for sneding again. this is plain text.)

Thanks.
