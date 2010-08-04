Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab0HDWYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:24:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:42578 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0HDWYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:24:50 -0400
Date: Thu, 5 Aug 2010 08:24:38 +1000
From: Neil Brown <neilb@suse.de>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        linux-raid@vger.kernel.org, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Message-ID: <20100805082438.0b476adb@notabene>
In-Reply-To: <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<20100804111803.GA32643@infradead.org>
	<alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 13:53:03 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 4 Aug 2010, Christoph Hellwig wrote:
> 
> > The good news is that you have it tracked down, the bad news is that I 
> > know very little about dm-crypt.  Maybe the issue is the single threaded 
> > decryption in dm-crypt?  Can you check how much CPU time the dm crypt 
> > kernel thread uses?
> 
> I'm not sure it's that. I have a Core i5 with AES-NI and that didn't 
> significantly increase my overall performance, as it's not there the 
> bottleneck is (at least in my system).
> 
> I earlier sent out an email wondering if someone could shed some light on 
> how scheduling, block caching and read-ahead works together when one does 
> disks->md->crypto->lvm->fs, becase that's a lot of layers and potentially 
> a lot of unneeded buffering, readahead and scheduling magic?
> 

Both page-cache and read-ahead work at the filesystem level, so only the
device in the stack that the filesystem mounts from is relevant for these.
Any read-ahead setting on other devices are ignored.
Other levels only have a cache if they explicitly need one.  e.g. raid5 has a
stripe-cache to allow parity calculations across all blocks in a stripe.

Scheduling can potentially happen at every layer, but it takes very different
forms.  Crypto, lvm, raid0 etc don't do any scheduling - it is just
first-in-first-out.
RAID5 does some scheduling for writes (but not reads) to try to gather full
stripes.  If you write 2 of 3 blocks in a stripe, then 3 of 3 in another
stripe, the 3 of 3 will be processed immediately while the 2 of 3 might be
delayed a little in the hope that the third will arrive.

The sys/block/XXX/queue/scheduler setting only applies at the bottom of the
stack (though when you have dm-multipath it is actually one step above the
bottom).

Hope that helps,
NeilBrown
