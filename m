Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0DZRMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:12:54 -0400
Received: from lazybastard.de ([212.112.238.170]:56249 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0DZRMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:12:53 -0400
Date: Mon, 26 Apr 2010 19:12:36 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Paolo Minazzi <paolo.minazzi@gmail.com>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
Message-ID: <20100426171236.GG4364@logfs.org>
References: <20100422203358.GB30749@logfs.org> <20100423100532.GN27497@kernel.dk> <20100423205518.GB7008@logfs.org> <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org> <20100426170247.GP27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100426170247.GP27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 April 2010 19:02:48 +0200, Jens Axboe wrote:
> On Mon, Apr 26 2010, Jörn Engel wrote:
> > Otherwise we hit a BUG_ON in bdi_queue_work().
> > 
> > Signed-off-by: Joern Engel <joern@logfs.org>
> > ---
> >  drivers/mtd/mtdcore.c |   17 ++++++++++++++++-
> >  1 files changed, 16 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> > index cb4858b..8dd3e46 100644
> > --- a/drivers/mtd/mtdcore.c
> > +++ b/drivers/mtd/mtdcore.c
> > @@ -322,6 +322,12 @@ int add_mtd_device(struct mtd_info *mtd)
> >  		if (!mtd_table[i]) {
> >  			struct mtd_notifier *not;
> >  
> > +			err = bdi_register(mtd->backing_dev_info, NULL, "mtd%d",
> > +					i);
> > +			if (err) {
> > +				/* We lose the errno information :( */
> > +				break;
> > +			}
> 
> This is not a good idea, even if it'll currently work.
> 
> > @@ -692,6 +698,15 @@ static int __init init_mtd(void)
> >  	int ret;
> >  	ret = class_register(&mtd_class);
> >  
> > +	ret = bdi_init(&mtd_bdi_unmappable);
> > +	if (ret)
> > +		return ret;
> > +	ret = bdi_init(&mtd_bdi_ro_mappable);
> > +	if (ret)
> > +		return ret;
> > +	ret = bdi_init(&mtd_bdi_rw_mappable);
> > +	if (ret)
> > +		return ret;
> 
> Do the bdi_register() here as well.

-ENOBRAIN

Initially I wanted to do just than.  Then I looked at the block layer
and thought we could create one backing_dev_info per mtd as well.  Not
necessarily a bad if I would actually _create_ them and not just reuse
the same ones over and over again.

Jörn

-- 
Linux [...] existed just for discussion between people who wanted
to show off how geeky they were.
-- Rob Enderle
