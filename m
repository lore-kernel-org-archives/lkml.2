Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0L0MXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 07:23:16 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:32854 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0L0MXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 07:23:15 -0500
From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
Organization: IBM
To: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] dm: improve read performance
Date: Mon, 27 Dec 2010 13:23:12 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.35-22-customkernel; KDE/4.4.2; i686; ; )
Cc: dm-devel@redhat.com, akpm@linux-foundation.org, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        cotte@de.ibm.com, ehrhardt@linux.vnet.ibm.com
References: <201012271219.56476.mume@linux.vnet.ibm.com> <20101227225459.5a5150ab@notabene.brown>
In-Reply-To: <20101227225459.5a5150ab@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012271323.13406.mume@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon December 27 2010 12:54:59 Neil Brown wrote:
> On Mon, 27 Dec 2010 12:19:55 +0100 Mustafa Mesanovic
> 
> <mume@linux.vnet.ibm.com> wrote:
> > From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
> > 
> > A short explanation in prior: in this case we have "stacked" dm devices.
> > Two multipathed luns combined together to one striped logical volume.
> > 
> > I/O throughput degradation happens at __bio_add_page when bio's get
> > checked upon max_sectors. In this setup max_sectors is always set to 8
> > -> what is 4KiB.
> > A standalone striped logical volume on luns which are not multipathed do
> > not have the problem: the logical volume will take over the max_sectors
> > from luns below.
> > 
> > Same happens with luns which are multipathed -> the multipathed targets
> > have the same max_sectors as the luns below.
> > 
> > So "magic" happens only when target has no own merge_fn and below lying
> > devices
> > have a merge function -> we got then max_sectors=PAGE_SIZE >> 9.
> > This patch prevents that max_sectors will be set to PAGE_SIZE >> 9.
> > Instead it will use the minimum max_sectors value from below devices.
> > 
> > Using the patch improves read I/O up to 3x. In this specific case from
> > 600MiB/s up to 1800MiB/s.
> 
> and using this patch will cause IO to fail sometimes.
> If an IO request which is larger than a page crosses a device boundary in
> the underlying e.g. RAID0, the RAID0 will return an error as such things
> should not happen - they are prevented by merge_bvec_fn.
> 
> If merge_bvec_fn is not being honoured, then you MUST limit requests to a
> single entry iovec of at most one page.
> 
> NeilBrown
> 

Thank you for that hint, I will try to write a merge_bvec_fn for dm-stripe.c
which solves the problem, if that is ok?

Mustafa Mesanovic

> > Signed-off-by: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
> > ---
> > 
> >  dm-table.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/md/dm-table.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-table.c	2010-12-23 13:49:18.000000000
> > +0100 +++ linux-2.6/drivers/md/dm-table.c	2010-12-23 13:50:22.000000000
> > +0100 @@ -518,7 +518,7 @@
> > 
> >  	if (q->merge_bvec_fn && !ti->type->merge)
> >  	
> >  		blk_limits_max_hw_sectors(limits,
> > 
> > -					  (unsigned int) (PAGE_SIZE >> 9));
> > +					  q->limits.max_sectors);
> > 
> >  	return 0;
> >  
> >  }
> >  EXPORT_SYMBOL_GPL(dm_set_device_limits);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
