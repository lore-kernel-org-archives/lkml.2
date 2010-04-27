Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0D0ILY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:11:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50224 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0D0ILV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WC7A9RRRzO+MO17V/O3T969o9BIkUX8fI5WukJL7TjLc9dCw2Vw3oyNMXz6+8tVXLQ
         KQdft1L+hPsuCPtPCQTkS5WgAN698m00e1STs7whr3LH90rOSSyspKBMFWGabGZUVs1S
         o9b6SzVHGXVEYMQsX1GXnURqRi6rpE6gtmpcs=
MIME-Version: 1.0
In-Reply-To: <20100427075229.GB27497@kernel.dk>
References: <20100423100532.GN27497@kernel.dk>
	 <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org>
	 <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk>
	 <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org>
	 <20100426170247.GP27497@kernel.dk> <20100426171236.GG4364@logfs.org>
	 <20100427075229.GB27497@kernel.dk>
Date: Tue, 27 Apr 2010 10:11:18 +0200
Message-ID: <z2g4aa525de1004270111r8a9a475fna8715219551a889d@mail.gmail.com>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
From: Paolo Minazzi <paolo.minazzi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I Jens,
I'm Paolo Minazzi and I have a problem with logfs and 2.6.34rc5.
Can I apply the patch to rc5 and make a test on my ARM board ?
Paolo



On Tue, Apr 27, 2010 at 9:52 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Apr 26 2010, Jörn Engel wrote:
>> On Mon, 26 April 2010 19:02:48 +0200, Jens Axboe wrote:
>> > On Mon, Apr 26 2010, Jörn Engel wrote:
>> > > Otherwise we hit a BUG_ON in bdi_queue_work().
>> > >
>> > > Signed-off-by: Joern Engel <joern@logfs.org>
>> > > ---
>> > >  drivers/mtd/mtdcore.c |   17 ++++++++++++++++-
>> > >  1 files changed, 16 insertions(+), 1 deletions(-)
>> > >
>> > > diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
>> > > index cb4858b..8dd3e46 100644
>> > > --- a/drivers/mtd/mtdcore.c
>> > > +++ b/drivers/mtd/mtdcore.c
>> > > @@ -322,6 +322,12 @@ int add_mtd_device(struct mtd_info *mtd)
>> > >           if (!mtd_table[i]) {
>> > >                   struct mtd_notifier *not;
>> > >
>> > > +                 err = bdi_register(mtd->backing_dev_info, NULL, "mtd%d",
>> > > +                                 i);
>> > > +                 if (err) {
>> > > +                         /* We lose the errno information :( */
>> > > +                         break;
>> > > +                 }
>> >
>> > This is not a good idea, even if it'll currently work.
>> >
>> > > @@ -692,6 +698,15 @@ static int __init init_mtd(void)
>> > >   int ret;
>> > >   ret = class_register(&mtd_class);
>> > >
>> > > + ret = bdi_init(&mtd_bdi_unmappable);
>> > > + if (ret)
>> > > +         return ret;
>> > > + ret = bdi_init(&mtd_bdi_ro_mappable);
>> > > + if (ret)
>> > > +         return ret;
>> > > + ret = bdi_init(&mtd_bdi_rw_mappable);
>> > > + if (ret)
>> > > +         return ret;
>> >
>> > Do the bdi_register() here as well.
>>
>> -ENOBRAIN
>>
>> Initially I wanted to do just than.  Then I looked at the block layer
>> and thought we could create one backing_dev_info per mtd as well.  Not
>> necessarily a bad if I would actually _create_ them and not just reuse
>> the same ones over and over again.
>
> I cooked up that patch myself, here:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0661b1ac5d48eb47c8a5948c0554fea25e0895ab
>
> Care to give it a quick spin?
>
> --
> Jens Axboe
>
>
