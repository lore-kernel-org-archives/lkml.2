Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1ASCei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 21:34:38 -0500
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:46888 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab1ASCeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 21:34:37 -0500
Subject: Re: [PATCH v3]  fs/direct-io.c: don't try to allocate more than
 BIO_MAX_PAGES in a bio
From: David Dillow <dillowda@ornl.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20110118165359.09023fe9.akpm@linux-foundation.org>
References: <1294977946.21790.20.camel@obelisk.thedillows.org>
	 <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
	 <1295023584.24487.16.camel@lap75545.ornl.gov>
	 <x49y66jmljv.fsf@segfault.boston.devel.redhat.com>
	 <1295319627.3051.89.camel@obelisk.thedillows.org>
	 <20110118165359.09023fe9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 21:34:30 -0500
Message-ID: <1295404470.5233.31.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 16:53 -0800, Andrew Morton wrote:
> On Mon, 17 Jan 2011 22:00:27 -0500
> David Dillow <dillowda@ornl.gov> wrote:
> 
> > When using devices that support max_segments > BIO_MAX_PAGES (256),
> > direct IO tries to allocate a bio with more pages than allowed, which
> > leads to an oops in dio_bio_alloc(). Clamp the request to the supported
> > maximum, and change dio_bio_alloc() to reflect that bio_alloc() will
> > always return a bio when called with __GFP_WAIT and a valid number of
> > vectors.
> 
> Which device driver triggers this condition?

I found it with the changes I've been making to the SRP driver to
support much larger IOs; this is not upstream yet.

> > Also added cc to stable, as this has been a longstanding item.
> 
> Well.  -stable only needs the patch if the driver which triggers the
> problem is also there.  But we don't know what driver that is, yet???

Good point.

Any driver that supports a sg_tablesize of more than 256 has the
potential for problems. A quick search of the tree indicates that the
following set their initial sg_tablesize to SCSI_MAX_SG_CHAIN_SEGMENTS
(2048), though they may be saved by a separate bug I found -- and sent a
patch to the list -- that incorrectly causes that define to take the
value 128. 

./drivers/usb/storage/scsiglue.c
./drivers/scsi/arm/powertec.c
./drivers/scsi/arm/eesox.c
./drivers/scsi/arm/cumana_2.c
./drivers/ata/pata_icside.c

CCISS looks to pull the config from the hardware and has a case for more
than 512 entries, so maybe on that one. AACRAID has cases above 256, and
also seems to calculate the setting in some instances as well. FNIC uses
1024.

> > +	/*
> > +	 * bio_alloc() is guaranteed to return a bio when called with
> > +	 * __GFP_WAIT and we request a valid number of vectors.
> > +	 */
> >  	bio = bio_alloc(GFP_KERNEL, nr_vecs);
> > +	BUG_ON(!bio);
> 
> This BUG_ON() is pretty pointless,
> 
> >  	bio->bi_bdev = bdev;
> 
> because the next statement will reliably oops, providing us with the
> same information.

Fair enough, though I'd argue -- weakly -- that BUG_ON gives a pointer
to the source. I had to dig through the assembly and figure out that
this function was inlined, but I'd agree that it wasn't too hard and
it'd be nice to avoid the conditional on a hot path.

I'll reroll it, or you can drop the BUG_ON, either way is fine by me.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

