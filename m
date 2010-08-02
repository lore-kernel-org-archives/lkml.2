Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab0HBAml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0HBAmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:42:40 -0400
Date: Mon, 2 Aug 2010 10:42:27 +1000
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Bryan Mesich <bryan.mesich@ndsu.edu>,
        scst-devel@lists.sourceforge.net, Jens Axboe <jens.axboe@oracle.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: RAID/block regression starting from 2.6.32, bisected
Message-ID: <20100802104227.79340b49@notabene>
In-Reply-To: <4C52A98A.7060507@kernel.org>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>
	<4C28EFD6.2070203@vlnb.net>
	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>
	<4C3EF3AD.5070509@vlnb.net>
	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>
	<4C4D7DF5.9060909@vlnb.net>
	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>
	<4C5073F3.1060406@vlnb.net>
	<4C52A98A.7060507@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 12:29:30 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 07/28/2010 08:16 PM, Vladislav Bolkhovitin wrote:
> > In recent kernels we are experiencing a problem that in our setup
> > using SCST BLOCKIO backend some BIOs are finished, i.e. the finish
> > callback called for them, with error -EIO. It happens quite often,
> > much more often than one would expect to have an actual IO
> > error. (BLOCKIO backend just converts all incoming SCSI commands to
> > the corresponding block requests.)
> > 
> > After some investigation, we figured out, that, most likely,
> > raid5.c::make_request() for some reason sometimes calls bio_endio()
> > with not BIO_UPTODATE bios.
> > 
> > We bisected it to commit: 
> > 
> > commit a82afdfcb8c0df09776b6458af6b68fc58b2e87b
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Fri Jul 3 17:48:16 2009 +0900
> > 
> >     block: use the same failfast bits for bio and request
> 
> That commit doesn't (or at least isn't supposed to) make any behavior
> difference.  It's just repositioning flag bits.  If the commit is
> actually causing the problem, I think one possibility is that whatever
> code could be using hard coded constants which now are mapped to
> different flags.  The mixed merge changes have been in mainline for
> quite some time and shipping in all major distros too and this is the
> first time this is reported, so I don't think it could be a widespread
> problem.
> 
> Thanks.
> 

The problem is that md/raid5 tests bio->bi_rw against RWA_MASK, which used to
align with BIO_RW_AHEAD, and now doesn't.
However the definition of bio_rw() in fs.h seems to justify that RWA_MASK
should align with BIO_RW_AHEAD, as does the definition of READA.

Given the current definitions, any WRITE request with BIO_RW_FAILFAST_DEV
set is going to confused a number of drives which test
     bio_rw(bio) == WRITE

I guess RWA_MASK needs to be changed to (1<<BIO_RW_AHEAD), and READA need to
be change to that value too.

Can I leave that to you Tejun?

Thanks,
NeilBrown
