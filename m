Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0IOQQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:16:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0IOQQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:16:15 -0400
Date: Wed, 15 Sep 2010 18:16:10 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Make blkdev_issue_discard() interruptible
In-Reply-To: <AANLkTinmJyJOqgSe6G0RiNUgT59wtxeT6y+0b3GivQem@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1009151815190.3162@dhcp-lab-213.englab.brq.redhat.com>
References: <1284561161-22278-1-git-send-email-lczerner@redhat.com> <AANLkTinmJyJOqgSe6G0RiNUgT59wtxeT6y+0b3GivQem@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571141147-1924175857-1284567373=:3162"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571141147-1924175857-1284567373=:3162
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 15 Sep 2010, Mike Snitzer wrote:

> On Wed, Sep 15, 2010 at 10:32 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > Since the discard may take quite long time, especially with really big
> > extents (like the whole device for example), it would be nice to give to
> > users the opportunity to abort it. This is especially useful for mkfs,
> > when user can not know in advance how long it will take.
> >
> > In conjunction with mke2fs patch "Inform user about ongoing discard"
> > it gives the user all the comfort of being informed about discard and
> > being able to abort the operation.
> >
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  block/blk-lib.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index d0216b9..4f54a1a 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -102,6 +102,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> >                else if (!bio_flagged(bio, BIO_UPTODATE))
> >                        ret = -EIO;
> >                bio_put(bio);
> > +
> > +               if (signal_pending(current)) {
> > +                       ret = -ERESTARTSYS;
> > +                       break;
> > +               }
> >        }
> >        return ret;
> >  out_free_page:
> 
> Neil Brown recently suggested the use of fatal_signal_pending() rather
> than signal_epnding() in another thread:
> http://lkml.org/lkml/2010/9/12/232
> 
> I think Neil's suggestion applies here too?
> 
> Mike

Good to know, thanks a lot. I'll resend the patch shortly.

-Lukas
--571141147-1924175857-1284567373=:3162--
